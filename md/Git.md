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



### git 本地关联远程分支

```shell
 git remote add origin https://github.com/gakkiyomi/study-log.git
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

