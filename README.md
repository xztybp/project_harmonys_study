# project_harmonys_study
关联远程仓库
…or create a new repository on the command line
echo "# project_harmonys_study" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/xztybp/project_harmonys_study.git
git push -u origin main
其他补充：
关于提交信息的格式，可以遵循以下的规则：
feat: 新特性，添加功能
fix: 修改 bug
refactor: 代码重构
docs:文档修改
style: 代码格式修改,注意不是 css 修改
test:测试用例修改
chore:其他修改,比如构建流程,依赖管理