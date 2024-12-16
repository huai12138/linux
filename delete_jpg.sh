#!/bin/bash

# 定义两个路径选项
path1="/home/huai/data/media/downloads/mv"
path2="/home/huai/data/media/downloads/h"

# 提示用户选择路径
echo "请选择要删除 .jpg 文件的目录："
echo "1. $path1"
echo "2. $path2"
read -p "请输入选项 (1 或 2): " choice

# 根据用户选择设置删除路径
case $choice in
  1)
    delete_dir="$path1"
    ;;
  2)
    delete_dir="$path2"
    ;;
  *)
    echo "输入无效，请重新输入。"
    exit 1
    ;;
esac

# 查找并删除指定目录及其子目录下的所有 .jpg 文件
find "$delete_dir" -type f -name "*.jpg" -delete

echo "删除完成。"
