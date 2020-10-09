
# gerrit服务的一键部署  

1. 配置服务器的ip 对外的http地址  
    修改配置文件:./data/etc/gerrit.config中canonicalWebUrl默认为canonicalWebUrl=192.168.1.100:8080  

2. init会重置./data/etc/gerrit.config的内容

3. gerrit.3.2.3.tar文件从dockerhub拉取
    docker pull gerritcodereview/gerrit:3.2.3-ubuntu20  
    或者这里下载:链接: https://pan.baidu.com/s/1dz-Tn4caVOMDYUl2Wb67Ag  密码: k3i3  
    放到install文件夹里即可  

4. 一键创建用户-创建用户test密码abcd1234成功  
    ssh -p 29000 admin@192.168.1.100 gerrit create-account --http-password "abcd1234"  test  

