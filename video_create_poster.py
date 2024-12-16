import os
import subprocess

def main():
    # 提供两个预定义的路径供用户选择
    predefined_paths = {
        "1": "/home/huai/data/media/downloads/h",
        "2": "/home/huai/data/media/downloads/mv"
    }

    # 显示路径选项
    print("请选择视频主目录路径：")
    for key, path in predefined_paths.items():
        print(f"{key}: {path}")
    
    # 获取用户选择
    choice = input("请输入选项编号（1或2）：").strip()

    # 验证用户输入
    if choice not in predefined_paths:
        print("无效的选项，请重新运行脚本并选择 1 或 2。")
        return

    video_dir = predefined_paths[choice]

    # 检查选择的目录是否有效
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

