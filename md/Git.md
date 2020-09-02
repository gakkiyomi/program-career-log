# Git 碰到的一些问题记录

###  git 查询用户代码数

```bash
git log --author="fangcong" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }'
```



### git 批量删除分支

```shell
git branch |grep 'branchName' |xargs git branch -D
```

这是通过 shell 管道命令来实现的批量删除分支的功能

`git branch` 输出当前分支列表
 `grep` 是对 `git branch` 的输出结果进行匹配，匹配值当然就是 `branchName`
 `xargs` 的作用是将参数列表转换成小块分段传递给其他命令

因此，这条命令的意思就是:

```undefined
从分支列表中匹配到指定分支，然后一个一个(分成小块)传递给删除分支的命令，最后进行删除。
```

从而就达到了我们想要批量删除分支的目的。



### git更新远程分支列表

```shell
git remote update origin --prune
```



### git 本地仓库关联远程仓库

```shell
 git remote add origin https://github.com/gakkiyomi/study-log.git
```

### git 本地分支跟踪远程分支

```shell
 git branch --set-upstream-to=origin/master
```



### git diff 不显示修改的代码

```shell
git diff --cached src/main/java/net/skycloud/cmdb/common/utils/CommonUtils.java

```



### git commit message 提交错了， 对上次提交进行修改

```shell
git commit --amend -m 'feat:2020.6.16'
```



### git 删除本地分支和远程分支

```shell
git branch -D test.   #删除本地分支
git push origin --delete test  #删除远程分支s
```



### git 查看最近n次的提交内容

#### 指定n为1则可以查看最近一次修改的内容

```shell
git log -p -n
```

#### 知道commit id的情况

```shell
git show commit_id
```



### git 查看所有分支的提交修改

~~~shell
git log --all --graph --decorate
~~~



### git 合并冲突

 需要将dev1分支的内容合并到master分支

~~~shell
git checkout master #切换到master分支
git merge dev1
~~~

在将dev2合到master分支

~~~shell
git merge dev2
#此时如果出现情况，不想合并，可以使用一下命令
git merge --abort #返回合并前的状态
#再次执行合并
git merge dev2
#冲突,手动解决
vim xxx.txt
git add .
git merge --continue
~~~

### git message 格式

- feat：新功能（feature）
- fix：修补bug
- docs：文档（documentation）
- style： 格式（不影响代码运行的变动）
- refactor：重构（即不是新增功能，也不是修改bug的代码变动）
- test：增加测试
- chore：构建过程或辅助工具的变动

### git 历史commit总数

~~~shell
git rev-list --all --count
~~~

包含了所有分支中的提交。

### alias

上面的命令非常复杂难记

可以定义一个 alias:  

 打开 ~/.gitconfig 

在 alias 部分增加一行配置

~~~shell
[alias]
    count = rev-list --all --count
~~~

~~~shell
git count
~~~



### git log graph

>通过此命令可以图形的方式查看log

~~~shell
git log --graph --decorate --oneline --simplify-by-decoration --all
~~~

--decorate 标记会让*git log*显示每个commit的引用(如:分支、tag等) 

--oneline 一行显示

--simplify-by-decoration 只显示被branch或tag引用的commit

--all 表示显示所有的branch，这里也可以选择，比如我指向显示分支ABC的关系，则将--all替换为**branchA branchB branchC**



### 切换远程仓库地址

1. 直接修改

~~~shell
git remote set-url origin 新的项目路径
~~~

2. 先删除远程地址，然后添加新的仓库地址

~~~shell
git remote rm origin
git remote add origin url
~~~

3. 修改配置文件

修改 **.git**目录下config文件中的url



### 全局修改用户名

~~~shell
git config --local(global) user.name 'gakkiyomi'
~~~

### 仓库级(全局)修改用户邮箱

~~~shell
git config --local(global) user.email 'gakkiyomi@gmail.com'
~~~

