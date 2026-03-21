#!/bin/bash

# 手动部署到 GitHub Pages 的脚本
set -e

echo "🚀 开始手动部署到 GitHub Pages..."

# 检查是否有未提交的更改
if [[ -n $(git status --porcelain) ]]; then
    echo "⚠️  检测到未提交的更改，请先提交所有更改"
    git status
    exit 1
fi

# 确保在正确的分支
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "main" ]]; then
    echo "⚠️  请切换到 main 分支后再运行此脚本"
    echo "当前分支: $BRANCH"
    exit 1
fi

# 构建文档
echo "📦 构建文档..."
npm run docs:build

# 进入构建产物目录
cd docs/.vitepress/dist

# 初始化 git 仓库（如果需要）
if [ ! -d ".git" ]; then
    git init
    git add -A
    git commit -m 'deploy'
    git branch -M main
    git remote add origin https://github.com/skytim/monaco-editor-vue3.git
fi

# 推送到 gh-pages 分支
echo "🚀 部署到 GitHub Pages..."
git add -A
git commit -m "deploy: $(date)"
git push -f origin main:gh-pages

cd ../../../

echo "✅ 部署完成！"
echo "🌐 网站将在几分钟后在以下地址可用:"
echo "   https://skytim.github.io/monaco-editor-vue3/"
