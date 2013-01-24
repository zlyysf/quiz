git@github.com:zlyysf/quiz.git
顶层目录名称按惯例： iphone, ui.



注意需要先参考这篇文档，    https://help.github.com/articles/generating-ssh-keys
注意其中输入 passphrase 的地方能空则空，能短则短。
注意把step4中提到的 ~/.ssh/id_rsa.pub 发给lingzhi管理员，让他去设置。

新建一个目录，进入，执行
git clone git@github.com:zlyysf/quiz.git ./
在本地建立分支 workMaster，对应远程的 workMaster，以后修改提交在这个分支进行。
git branch workMaster origin/workMaster
git checkout workMaster
根据书上建议，配置rebase选项
git config branch.workMaster.rebase true


以后git push时使用如下命令 
git push origin workMaster:workMaster

(在本地的分支workMaster下做pull，可以用 git checkout workMaster 来保证在workMaster下，或者使用git branch来查看)
git pull --progress origin workMaster



其他一些常用查看命令
git branch -a
git remote -v
cat .git/config




