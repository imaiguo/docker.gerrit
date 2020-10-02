1.Quickstart Start Gerrit Code Review in its demo/staging out-of-the-box setup:
    
    docker run -ti -p 8080:8080 -p 29418:29418 gerritcodereview/gerrit
    then open your browser to http://localhost:8080 and you will be in Gerrit Code Review.

2.Using persistent volumes
    Use docker persistent volumes to keep Gerrit data across restarts. See below a sample docker-compose.yaml per externally-mounted Lucene indexes, Caches and Git repositories.
    Example of /docker-compose.yaml
    version: '3'
    services:
      gerrit:
        image: gerritcodereview/gerrit
        volumes:
           - git-volume:/var/gerrit/git
           - index-volume:/var/gerrit/index
           - cache-volume:/var/gerrit/cache
        ports:
           - "29418:29418"
           - "8080:8080"
    
    volumes:
      git-volume:
      index-volume:
      cache-volume:
    Run docker-compose up to trigger the build and execution of your custom Gerrit docker setup.

3.修改配置文件 gerrit.config

4.一键创建用户-创建用户test密码abcd1234成功
    ssh -p 29418 admin@192.168.2.211 gerrit create-account --http-password "abcd"  test  

5.配置http代理软件
    a.安装软件[htpasswd 系apache的工具]
        apt install apache2-utils nginx

    b.修改nginx配置,添加代理        
        # htpasswd -c /var/gerrit/gerrit.password admin
    
    c.设置邮箱

参考资料:
https://hub.docker.com/r/gerritcodereview/gerrit
https://blog.csdn.net/zyaiwmy/article/details/54617544

