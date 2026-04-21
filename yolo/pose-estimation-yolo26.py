from ultralytics import YOLO

model = YOLO("yolo26m-pose.pt")

results = model.predict(
    source="video/demo-air-400-s05-23.mp4",
    save=True,
    vid_stride=5,
    show=False
)