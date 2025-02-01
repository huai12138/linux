#!/bin/bash

# 使用 find 命令递归查找所有 .sh 文件
find . -type f -name "*.sh" | while read file; do
  # 使用 vim 将文件格式设置为 Unix 并保存
  vim -E -s "$file" <<-EOF
    :set ff=unix
    :wq
EOF
done
