#!/bin/bash

# 安装 oh-my-zsh
echo ">> Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装 powerlevel10k 主题
echo ">> Installing powerlevel10k theme"
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# 安装 zsh-autosuggestions 插件
echo ">> Installing zsh-autosuggestions plugin"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 安装 zsh-syntax-highlighting 插件
echo ">> Installing zsh-syntax-highlighting plugin"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 设置 oh-my-zsh 配置
echo ">> Configuring oh-my-zsh"

# 设置主题为 powerlevel10k
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# 添加插件到 .zshrc
sed -i '/plugins=(git)/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc

# 提示完成
echo "Installation completed! Please restart your terminal or run 'source ~/.zshrc' to apply changes."

