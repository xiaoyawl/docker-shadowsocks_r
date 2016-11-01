[![](https://images.microbadger.com/badges/image/benyoo/shadowsocks.svg)](http://microbadger.com/images/benyoo/shadowsocks "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/benyoo/shadowsocks.svg)](http://microbadger.com/images/benyoo/shadowsocks "Get your own version badge on microbadger.com")

# 一、Docker-ShadowsocksR 服务端
##1、介绍
基于Dockerfile文件编译出一个ShadowsocksR服务端的容器镜像。
##2、版本
当前版本：[benyoo/shadowsocks:3.8.5.2](https://hub.docker.com/r/benyoo/shadowsocks/)
##3、问题
如何安装Docker
```bash
curl -Lk https://get.docker.com/ | sh
```
RHEL、CentOS、Fedora的用户可以使用`setenforce 0`来禁用selinux以达到解决一些问题

如果你已经禁用了selinux并且使用的是最新版的Docker，如果还有疑问，你可以尝试通过 [issues](https://github.com/xiaoyawl/docker-shadowsocks_r/issues) 页面来寻求帮助

当你在issue 提交问题的时候请注意提供一下信息:
- 宿主机的发行版和版本号.
- 使用 `docker version` 命令来给出Docker版本信息.
- 使用 `docker info` 命令来给出进一步信息.
- 提供 `docker run` 命令的详情 (注意打码你的隐私信息).

# 二、安装&使用
##1、基于docker的ShadowsocksR服务端安装方法
直接使用我们在 [Dockerhub](https://hub.docker.com/r/benyoo/shadowsocks/) 上通过自动构建生成的镜像是最为推荐的方式

> **Note**: 也可以在 [Quay.io](https://quay.io/repository/benyoo/shadowsocks)上构建

```bash
docker pull benyoo/shadowsocks:latest
```
##2、使用docker-compose来快速部署
```bash
curl -LkO https://github.com/xiaoyawl/docker-shadowsocks_r/raw/master/docker-compose.yml
docker-compose up -d
```
###使用演示
```bash
[root@DS-VM-Node170 ~]# curl -LkO https://github.com/xiaoyawl/docker-shadowsocks_r/raw/master/docker-compose.yml
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   155  100   155    0     0     22      0  0:00:07  0:00:06  0:00:01    47
100   268  100   268    0     0     20      0  0:00:13  0:00:13 --:--:--    67
[root@DS-VM-Node170 ~]# docker-compose up -d
Creating network "dockershadowsocksr_default" with the default driver
Pulling shadowsocks (benyoo/shadowsocks:latest)...
latest: Pulling from benyoo/shadowsocks

e110a4a17941: Already exists
9afdf360130b: Pull complete
03fe7695267b: Pull complete
61cfeeb7ee42: Pull complete
Digest: sha256:bfb2c014d1a828430fa567286101f78906b6472183b81479d535b2dc750f57dd
Status: Downloaded newer image for benyoo/shadowsocks:latest
Creating shadowsocks_server
[root@DS-VM-Node170 ~]# docker logs shadowsocks_server 
loaded collections.OrderedDict
INFO: loading config from user-config.json
2016-09-02 13:02:31 INFO     util.py:85 loading libcrypto from libcrypto.so.1.0.0
2016-09-02 13:02:31 INFO     asyncdns.py:324 dns server: [('127.0.0.11', 53)]
2016-09-02 13:02:31 INFO     server.py:98 server start with protocol[auth_sha1_compatible] password [lookback] method [aes-256-cfb] obfs [http_simple_compatible] obfs_param []
2016-09-02 13:02:31 INFO     server.py:114 starting server at [::]:10000
2016-09-02 13:02:31 INFO     server.py:134 starting server at 0.0.0.0:10000
[root@DS-VM-Node170 ~]# 
```
##3、变量说明
|         变量名        |          默认值         |       描述                                |
| -------------------- | ---------------------- | ---------------------------------------- |
| SERVER               | 0.0.0.0                | 当服务器上有多IP的时候之允许单个IP的时候使用，在Docker环境中不建议使用。 |
| SERVER_IPV6          | ::                     | 同上                                       |
| SERVER_PORT          | 8388                   |                                          |
| LOCAL_ADDRESS        | 127.0.0.1              |                                          |
| LOCAL_PORT           | 1080                   |                                          |
| PASSWORD             | m                      | 建议修改密码                                   |
| TIMEOUT              | 120                    |                                          |
| UDP_TIMEOUT          | 60                     |                                          |
| METHOD               | aes-256-cfb            | 建议修改为其他加密模式                              |
| PROTOCOL             | auth_sha1_compatible   |                                          |
| PROTOCOL_PARAM       |                        |                                          |
| OBFS                 | http_simple_compatible |                                          |
| OBFS_PARAM           |                        |                                          |
| DNS_IPV6             | false                  |                                          |
| CONNECT_VERBOSE_INFO |                        |                                          |
| REDIRECT             |                        |                                          |
| FAST_OPEN            | false                  |                                          |
| MANYUSER             |                        | 当值为Yes的时候启用多用户模式，为No时为单用户模式              |
| API_INTERFACE        | mudbjson               | 只有当MANYUSER=yes的时候才生效                    |
| SSR_SQL              |                        | 当MANYUSER=yes的时候SSR_SQL或者SSR_JSON必须有值    |
| SSR_JSON             |                        |                                          |


##4、 基于Arukas.io 的使用演示
222
```

```
