from flask import Flask
import os
from datetime import datetime  # 添加datetime模块

# 关闭开发服务器警告
os.environ['WERKZEUG_RUN_MAIN'] = 'true'

app = Flask(__name__)

# 提取文件名为常量变量
SHUTDOWN_FILENAME = 'shutdown'

@app.route('/s')
def create_shutdown_file():
    """在根目录创建一个shutdown文件"""
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # 获取当前时间
    try:
        with open(SHUTDOWN_FILENAME, 'w') as f:
            pass  # 创建空文件
        return f"[{current_time}] 成功在根目录创建{SHUTDOWN_FILENAME}文件"
    except Exception as e:
        return f"[{current_time}] 创建{SHUTDOWN_FILENAME}文件失败: {str(e)}", 500

@app.route('/n')
def delete_shutdown_file():
    """从根目录删除shutdown文件"""
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # 获取当前时间
    try:
        if os.path.exists(SHUTDOWN_FILENAME):
            os.remove(SHUTDOWN_FILENAME)
            return f"[{current_time}] 成功删除{SHUTDOWN_FILENAME}文件"
        else:
            return f"[{current_time}] {SHUTDOWN_FILENAME}文件不存在", 404
    except Exception as e:
        return f"[{current_time}] 删除{SHUTDOWN_FILENAME}文件失败: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5008, debug=True)
