#!/bin/bash

# 使用 find 命令递归查找所有 .sh 文件并转换为 Unix 格式
find . -type f -name "*.sh" | while read -r file; do
  sed -i 's/\r$//' "$file"
done
