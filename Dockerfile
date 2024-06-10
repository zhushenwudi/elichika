FROM ubuntu:latest

# 设置环境变量
ENV GO_VERSION 1.20.6
ENV GIT_SSL_NO_VERIFY=true
ENV GOPROXY=https://goproxy.cn

# 设置工作目录
WORKDIR /llas

# 将源代码复制到容器中
COPY . /llas

# 国外无法访问切换阿里镜像源，速度比较慢
#RUN echo "deb http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse" > /etc/apt/sources.list \
#    && echo "deb http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse" >> /etc/apt/sources.list \
#    && echo "deb http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse" >> /etc/apt/sources.list \
#    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse" >> /etc/apt/sources.list \
#    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse" >> /etc/apt/sources.list \
#    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 更新并安装依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    gcc \
	tzdata \
	vim \
    libc6-dev \
    make \
    pkg-config \
    git \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN rm -rf /etc/localtime
RUN ln -sv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 下载并安装Go
RUN wget --no-check-certificate -O go$GO_VERSION.linux-amd64.tar.gz "https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz" \
    && tar -xzf "go$GO_VERSION.linux-amd64.tar.gz" -C /usr/local
ENV PATH="/usr/local/go/bin:${PATH}"

# 运行Go程序
CMD ["go", "run", "main.go"]
