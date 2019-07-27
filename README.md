# docker-webmin
dockerfile for webmin

## Building the image
```
git clone https://github.com/chsliu/docker-webmin.git
cd docker-webmin
docker build -t chsliu/webmin .
```

## Running the container
```
docker run -d -p 10000:10000 -p 80 -p 21 chsliu/webmin
```

Log into webmin and manage your server
```
https://hostname.or.ip:10000
(root:pass)
```
