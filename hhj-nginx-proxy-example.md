```
server {
  listen      [::]:80;
  listen      80;
  server_name ~^dohlestr(?<subtype>[^.]+)\.?.*;
  access_log  /var/log/nginx/dohlestr-f-hot-access.log;
  error_log   /var/log/nginx/dohlestr-f-hot-error.log;

  location    / {

    gzip on;
    gzip_min_length  1100;
    gzip_buffers  4 32k;
    gzip_types    text/css text/javascript text/xml text/plain text/x-component application/javascript application/x-javascript application/json application/xml  application/rss+xml font/truetype application/x-font-ttf font/opentype application/vnd.ms-fontobject image/svg+xml;
    gzip_vary on;
    gzip_comp_level  6;

    proxy_pass  http://dohlestr$subtype;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Port $server_port;
    proxy_set_header X-Request-Start $msec;
  }
}

upstream dohlestr-b-dev {
  server 172.20.0.6:80;
}

upstream dohlestr-f-hot {
  server 172.20.0.180:80;
}

upstream dohlestr-f-dev {
  server 172.20.0.181:80;
}

upstream dohlestr-f-stage {
  server 172.20.0.182:80;
}

upstream dohlestr-f-prod {
  server 172.20.0.183:80;
}
```