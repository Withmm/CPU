#!/bin/zsh

# 当前文件夹路径
current_folder=$(pwd)

# 目标文件夹路径
target_folder="/mnt/d/CPU"

# 检查目标文件夹是否存在
if [ ! -d "$target_folder" ]; then
    echo "Error: Target folder does not exist."
    exit 1
fi

# 遍历当前文件夹中的文件
for file in "$current_folder"/*; do
    # 获取文件名
    filename=$(basename "$file")
    # 检查目标文件夹中是否存在同名文件
    if [ -e "$target_folder/$filename" ]; then
        # 替换文件
        echo "Replacing $filename..."
        cp "$file" "$target_folder"
    else
        # echo "No matching file found for $filename in $target_folder"
    fi
done

echo "Replacement complete."

