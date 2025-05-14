local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if not getcustomasset then
	warn("Congratulations on escaping jumpscare.")
	return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SafeVideoPlayer"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local videoFrame = Instance.new("VideoFrame")
videoFrame.Name = "VideoDisplay"
videoFrame.Size = UDim2.new(1, 0, 1, 0)
videoFrame.Position = UDim2.new(0, 0, 0, 0)
videoFrame.BackgroundTransparency = 1
videoFrame.Looped = true
videoFrame.Volume = 1
videoFrame.Parent = screenGui

local videoUrl = ""
writefile("video.mp4", game:HttpGet(videoUrl))

videoFrame.Video = getcustomasset("video.mp4")
videoFrame.Playing = true