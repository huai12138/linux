#!/bin/bash

# 遍历当前目录下所有的 .sh 脚本文件
for file in *.sh; do
  # 提取文件名（不含后缀）
  base_name=$(basename "$file" .sh)
  # 使用 shc 对脚本进行加密并生成可执行文件，允许运行时移植
  shc -r -f "$file" -o "$base_name"
done
