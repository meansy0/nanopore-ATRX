# 下载管理员已下载的软件
## 加载
+ ```module avail``` 显示所有管理员已下载的包
+ ```module load path``` 加载对应的软件，后面为路径
+ ```module list``` 显示所有已加载的包
+ 完成后可直接使用
## 卸载
+ ```module unload path``` 卸载某个已加载的包
+ ```module purge``` 卸载所有加载的包

## 问题说明
+ 每次新开窗口似乎需要重新加载所有的包，建议写到脚本里

# 下载软件
+ 可以直接从登录节点完成下载
+ 推荐使用conda下载软件

# lib问题
+ 报错：
+ ```echo $LD_LIBRARY_PATH```  确认lib是否被加到了环境里
+ ```LD_LIBRARY_PATH="/public/home/xiayini/software/opt/ont/quppy/lib:$LD_LIBRARY_PATH"``` 将其加入环境变量
+ 直接解压等操作进行安装的软件需要手动添加环境变量

# singularity
+ 类似于一个docker，用于下载软件，可以摆脱没有sudo权限的困扰进行软件的下载，在docker环境内用户拥有sudo权限
+ ```module load apps/singularity/3.8.7```
+ reference:https://www.jianshu.com/p/056bff2558b0