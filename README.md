# Drone simulator (written in Godot)
Last year I was developing a drone simulator to test automatic targeting, which worked and I will attach video of it in the end.

But lately, I repurposed the code to make a mobile drone controll trainer, using touchscreen:

![2025-11-27 17 25 10(2)](https://github.com/user-attachments/assets/c25846f2-ca3c-495e-a341-0b14e4e53718)

Now how the simulator and autotargeting worked:
1. The controll server (example: [https://github.com/yaroslav-06/drone_autotargeting](drone_autotargeting)) is running in the background
2. About 30 times per second godot saved an image from camera in a foulder.
3. The controll server reads the image, detects the other drone, and sends it's image coordinates back to godot via websocket.
4. The godot tries to center the other drone in camera view based on controller inputs.

One of the tests (red square marks the region where controll server predicts the other drone is located):

https://github.com/user-attachments/assets/badfbeb1-aee3-4f21-ae4a-301c0270d05a
