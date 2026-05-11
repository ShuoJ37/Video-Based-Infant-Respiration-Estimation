import cv2
from ultralytics import YOLO

IMAGE_PATH = "inputs/test101.jpg"
OUTPUT_CROP = "test101_crop.jpg"
OUTPUT_VIS = "test101_vis.jpg"

# Load YOLOv8 model
# You can change to yolov8m.pt or yolov8l.pt if you want
model = YOLO("yolov8n.pt")

img = cv2.imread(IMAGE_PATH)
if img is None:
    raise FileNotFoundError(f"Could not read image: {IMAGE_PATH}")

results = model.predict(
    source=IMAGE_PATH,
    conf=0.25,
    classes=[0],   # class 0 = person
    save=False,
    verbose=False
)

result = results[0]
boxes = result.boxes

if boxes is None or len(boxes) == 0:
    raise RuntimeError("No person detected.")

# Pick the highest-confidence person box
best_idx = boxes.conf.argmax().item()
xyxy = boxes.xyxy[best_idx].cpu().numpy().astype(int)
conf = float(boxes.conf[best_idx].cpu().item())

x1, y1, x2, y2 = xyxy

# Clamp to image bounds
h, w = img.shape[:2]
x1 = max(0, x1)
y1 = max(0, y1)
x2 = min(w, x2)
y2 = min(h, y2)

crop = img[y1:y2, x1:x2]
cv2.imwrite(OUTPUT_CROP, crop)

vis = img.copy()
cv2.rectangle(vis, (x1, y1), (x2, y2), (0, 255, 0), 2)
cv2.putText(
    vis,
    f"person {conf:.2f}",
    (x1, max(20, y1 - 10)),
    cv2.FONT_HERSHEY_SIMPLEX,
    0.7,
    (0, 255, 0),
    2,
    cv2.LINE_AA
)
cv2.imwrite(OUTPUT_VIS, vis)

print(f"Saved crop to: {OUTPUT_CROP}")
print(f"Saved visualization to: {OUTPUT_VIS}")
print(f"Box: {(x1, y1, x2, y2)}")