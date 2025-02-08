from flask import Flask, request, jsonify
import requests
from datetime import datetime, timezone
import json
from config import *  # 导入所有配置

app = Flask(__name__)

def get_current_time():
    """获取当前本地时间"""
    utc_time = datetime.now(timezone.utc)
    local_time = utc_time.astimezone()  # 自动转换为本地时间
    return local_time.strftime('%Y-%m-%d %H:%M:%S %Z')

def format_notification_type(notification_type):
    """格式化通知类型"""
    type_mapping = {
        # 播放相关
        "playback.start": "开始播放",
        "playback.stop": "停止播放",
        "playback.pause": "暂停播放",
        "playback.unpause": "继续播放",
        "playback.progress": "播放进度",
        
        # 系统相关
        "system.webhooktest": "系统测试",
        "system.notificationtest": "通知测试",
        "system.wakingup": "系统唤醒",
        "system.shuttingdown": "系统关闭",
        "system.resumed": "系统恢复",
        "system.update.available": "系统更新可用",
        "system.update.installed": "系统更新完成",
        
        # 库相关
        "library.new": "新增媒体",
        "library.update": "库更新",
        "library.deleted": "删除媒体",  # 添加此行
        "library.scanning": "库扫描中",
        "library.scancomplete": "库扫描完成",
        
        # 用户相关
        "user.login": "用户登录",
        "user.logout": "用户登出",
        "user.new": "新用户创建",
        "user.delete": "用户删除",
        "user.authenticated": "用户验证成功",
        "user.authentication.success": "用户验证成功",
        "user.authenticationfailed": "用户认证失败",  # 添加此行
        "user.authenticationerror": "用户认证错误",   # 添加此行
        "user.password.reset": "用户密码重置",
        
        # 会话相关
        "session.start": "会话开始",
        "session.end": "会话结束",
        "session.timeout": "会话超时",
        
        # 设备相关
        "device.new": "新设备连接",
        "device.delete": "设备移除",
        
        # 任务相关
        "task.completed": "任务完成",
        "task.failed": "任务失败",
        
        # 转码相关
        "transcoding.start": "开始转码",
        "transcoding.end": "转码完成",
        "transcoding.error": "转码错误"
    }
    return type_mapping.get(notification_type, f"未知事件({notification_type})")

def send_telegram_message(message):
    """发送消息到 Telegram"""
    try:
        url = f'https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage'
        payload = {
            'chat_id': TELEGRAM_CHAT_ID,
            'text': message,
            'parse_mode': 'HTML',
            'disable_web_page_preview': True
        }
        response = requests.post(url, json=payload)
        response.raise_for_status()
        return True
    except Exception as e:
        print(f"发送消息失败: {str(e)}")
        return False

def format_message(data):
    """格式化通知消息"""
    try:
        event_type = data.get('Event', '未知事件')
        notification_type = format_notification_type(event_type)
        
        server_info = data.get('Server', {})
        server_name = server_info.get('Name') or SERVER_NAME
        server_version = server_info.get('Version', '')
        
        user_info = data.get('User', {})
        user_name = user_info.get('Name', '')
        
        message_parts = [
            "<b>🎬 Emby 通知</b>",
            f"\n📺 服务器: {server_name}"
        ]
        
        if server_version:
            message_parts[-1] += f" (v{server_version})"
        
        message_parts.append(f"\n📝 类型: {notification_type}")
        
        if user_name:
            message_parts.append(f"\n👤 用户: {user_name}")
        
        title = data.get('Title')
        if title:
            message_parts.append(f"\n🎵 标题: {title}")
        
        description = data.get('Description')
        if description:
            message_parts.append(f"\n📝 描述: {description}")

        event_date = data.get('Date')
        if event_date:
            try:
                dt = datetime.fromisoformat(event_date.replace('Z', '+00:00'))
                local_time = dt.astimezone()
                formatted_time = local_time.strftime('%Y-%m-%d %H:%M:%S')
                message_parts.append(f"\n⏰ 事件时间: {formatted_time}")
            except (ValueError, TypeError) as e:
                print(f"时间格式化错误: {e}")

        current_time = get_current_time()
        message_parts.append(f"\n⌚ 通知时间: {current_time}")

        return "\n".join(message_parts)

    except Exception as e:
        print(f"格式化消息失败: {str(e)}")
        return "消息格式化错误"

@app.route('/webhook', methods=['POST'])
def webhook():
    """处理 webhook 请求"""
    try:
        data = request.json
        if not data:
            return jsonify({'status': 'error', 'message': '无效的请求数据'}), 400
            
        if 'Event' not in data:
            return jsonify({'status': 'error', 'message': '缺少事件类型'}), 400

        message = format_message(data)
        success = send_telegram_message(message)

        if success:
            return jsonify({'status': 'success', 'message': '通知已发送'}), 200
        else:
            return jsonify({'status': 'error', 'message': '发送通知失败'}), 500

    except json.JSONDecodeError:
        return jsonify({'status': 'error', 'message': '无效的 JSON 数据'}), 400
    except Exception as e:
        error_msg = f"处理 webhook 失败: {str(e)}"
        print(error_msg)
        return jsonify({'status': 'error', 'message': error_msg}), 500

if __name__ == '__main__':
    print(f"Emby Webhook 服务启动于 http://{FLASK_HOST}:{FLASK_PORT}")
    app.run(host=FLASK_HOST, port=FLASK_PORT, debug=DEBUG)