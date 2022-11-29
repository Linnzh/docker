## Usage - 使用

Docker镜像分了 PHP 7 和 PHP 8 两个版本，PHP 7 为 FPM 版本，PHP 8 则为 Swoole 版本，分别适用于不同的框架。


### PHP-FPM

一个在 ThinkPHP 框架下适用的 Dockerfile 示例：

```dockerfile

```

#### 配合 Nginx

// todo

### PHP with Swoole

// todo

#### 配合 Nginx

// todo

### FAQ

1. 镜像拉取或构建缓慢怎么办？
   
   造成构建缓慢可能有以下原因：
   1. 如果在 Windows 平台使用 Docker Desktop 进行构建，可能是因为使用了 WSL 2 为基础，它导致写入 IO 缓慢，可关闭该选项来优化构建速度；
   2. 可能是镜像构建过程中，apt/apk 镜像源网络问题导致。可根据所在网络更换镜像源。
      例如 Alpine 镜像可在 Dockerfile 中添加如下指令：
   ```dockerfile
   # 设置国内源
   # 阿里云镜像源：http://mirrors.aliyun.com/alpine/
   RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
   ```
      例如 Ubuntu 镜像源替换：`RUN sed -i 's/archive.ubuntu.com/mirrors.cloud.aliyuncs.com/g' /etc/apt/sources.list`

   国内镜像可用源：
   
   - 清华TUNA镜像源：https://mirror.tuna.tsinghua.edu.cn/alpine/
   - 中科大镜像源：http://mirrors.ustc.edu.cn/alpine/
   - 阿里云镜像源：http://mirrors.aliyun.com/alpine/

2. 如何指定 PHP 版本构建镜像？
   
   镜像均开放了名为 PHP_VERSION 的 ARG 构建参数，构建镜像时可使用形如`docker build -t=php --build-arg PHP_VERSION=8.0 -f=Dockerfile .`的命令来指定 PHP 版本

3. 多个容器间无法连通
   
   1. 请确保容器在运行时使用了同一个 network
   2. 创建 Docker Network 命令：`docker network create -d=bridge DefaultNetwork`，请注意，不可以使用已存在的 network 名称或者`default`等词创建网络
   3. network 选项为**运行时选项**，使用`docker run`命令时可使用`--network=DefaultNetwork`来进行容器互联
   
4. Windows 映射目录时怎么都不对，还会额外创建例如`;C:/Docker/Project`以分号开头的空目录
   
   在运行容器时，由于 Windows 路径的特殊性，应**在映射目录前加上斜杠**才能找到正确的目录，例如：`docker run -it --rm -v=/c:/code:/opt/www --name=php --network=defaultNet --platform=linux/amd64 -- php sh`，这里映射的是 C 盘下的 code 目录。
   另外请注意，docker 关于路径问题，使用的是 Unix 系统规则，不区分路径的大小写。
   
5. Windows 系统下，运行容器并使用`/bin/sh`或`bash`等终端时提示无此程序
   
   针对该问题，请始终使用`sh`终端进入容器。
   
