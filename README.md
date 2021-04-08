# magento-stack-docker

This repository is scratch dockerfile using  ubuntu:18.04 image 
as way to install a Magento 2 development environment.

### For Security reason I haven't deploy this image in docker hub but ofcourse you can build it!
```
        docker build . -t yourrepo/NAME:tagname
```
#
Using Magento DevBox and needed
 - support for PHP 7.2 with required extensions
 - support for mysql with prebuild installed magento db
 - support ssh to container
 
 #
 
```
- ssh tunnel port 22
