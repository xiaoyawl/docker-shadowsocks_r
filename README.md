# Docker-ShadowsocksR 服务端

##1、变量说明
| 变量名                  | 默认值                    | 描述                                       |
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


##2、 基于Arukas.io 的使用演示
