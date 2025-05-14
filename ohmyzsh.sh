#!/bin/bash

# Install oh-my-zsh
if [ -d ~/.oh-my-zsh ]; then
    echo ">> oh-my-zsh is already installed, skipping installation"
else
    echo ">> Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel10k theme
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
    echo ">> powerlevel10k theme is already installed, skipping installation"
else
    echo ">> Installing powerlevel10k theme"
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh-autosuggestions plugin
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    echo ">> zsh-autosuggestions plugin is already installed, skipping installation"
else
    echo ">> Installing zsh-autosuggestions plugin"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting plugin
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    echo ">> zsh-syntax-highlighting plugin is already installed, skipping installation"
else
    echo ">> Installing zsh-syntax-highlighting plugin"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Configure oh-my-zsh
echo ">> Configuring oh-my-zsh"

# Set theme to powerlevel10k (only if not already set)
if grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
    echo ">> Theme already set to powerlevel10k, skipping configuration"
else
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi

# Add plugins to .zshrc (only if not already added)
if grep -q 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc; then
    echo ">> Plugins already configured, skipping configuration"
else
    sed -i '/plugins=(git)/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc
fi

# Copy custom config file if it exists, otherwise skip
if [ -f ~/linux/.zshrc ]; then
    if cmp -s ~/linux/.zshrc ~/.zshrc; then
        echo ">> Custom .zshrc file already exists and is identical, skipping copy"
    else
        echo ">> Copying custom .zshrc file"
        cp ~/linux/.zshrc ~
    fi
else
    echo ">> Custom .zshrc file not found, skipping"
fi

# Copy custom p10k config file if it exists, otherwise skip
if [ -f ~/linux/.p10k.zsh ]; then
    if cmp -s ~/linux/.p10k.zsh ~/.p10k.zsh; then
        echo ">> Custom .p10k.zsh file already exists and is identical, skipping copy"
    else
        echo ">> Copying custom .p10k.zsh file"
        cp ~/linux/.p10k.zsh ~
    fi
else
    echo ">> Custom .p10k.zsh file not found, skipping"
fi

# Completion message
echo "Installation completed! Please restart your terminal or run 'source ~/.zshrc' to apply changes."

