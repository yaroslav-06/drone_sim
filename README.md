# Drone simulator (written in Godot)
Last year I was developing a drone simulator to test automatic targeting, which worked and I will attach video of it in the end.\

But lately I repurposed the code to make a mobile drone controll trainer, using touchscreen:

[paste the video of android test]

Now how the simulator and autotargeting worked:\
1. The controll server (example: [https://github.com/yaroslav-06/drone_autotargeting](drone_autotargeting)) is running in the background
2. About 60 times per second godot saved an image from camera in a foulder.
3. The controll server reads the image, detects the other drone, and sends commands to godot via websocket and tries to center the drone in camera view.

One of the tests:
[paste the video of drone targeting]
