import os
import subprocess

def main():
    # 提示用户输入视频主目录路径
    video_dir = input("请输入视频主目录路径（例如 /home/user/videos）: ").strip()

    # 检查输入目录是否有效
    if not os.path.isdir(video_dir):
        print(f"错误: 视频目录 '{video_dir}' 不存在。")
        return

    # 遍历主目录及其所有子目录
    for root, dirs, files in os.walk(video_dir):
        for file in files:
            # 检查是否是支持的视频文件
            if file.endswith((".mp4", ".ts", ".TS", ".MP4", ".mkv", ".avi", ".mov", ".flv")):
                video_path = os.path.join(root, file)

                # 输出图片文件路径，与视频文件在同一目录
                output_file = os.path.join(root, f"{os.path.splitext(file)[0]}-poster.jpg")

                # FFmpeg命令生成封面图片
                command = [
                    "ffmpeg",
                    "-y",                  # 强制覆盖输出文件
                    "-i", video_path,      # 输入视频路径
                    "-ss", "00:00:01",     # 选取1秒的帧，可自行调整时间点
                    "-vframes", "1",       # 提取一帧
                    "-q:v", "2",           # 图片质量（2为高质量）
                    output_file            # 输出图片路径
                ]

                try:
                    subprocess.run(command, check=True)
                    print(f"生成封面成功: {output_file}")
                except subprocess.CalledProcessError as e:
                    print(f"生成封面失败: {video_path}。错误: {e}")

    print("封面生成任务完成！")

if __name__ == "__main__":
    main()

