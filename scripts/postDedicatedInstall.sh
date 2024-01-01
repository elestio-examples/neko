#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

echo "         
map \$http_upgrade \$connection_upgrade {
  default upgrade;
  '' close;
}

proxy_cache_path /tmp levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m use_temp_path=off;
limit_req_zone  \$binary_remote_addr\$http_x_forwarded_for zone=iprl:16m rate=500r/m;

server {
  listen 443 ssl http2;
  ssl_certificate /etc/nginx/certs/cert.pem;
  ssl_certificate_key /etc/nginx/certs/key.pem;
  server_name ${DOMAIN};

  client_header_buffer_size 32k;
  large_client_header_buffers 4 32k;

  access_log flush=1s;
  #access_log  /var/log/nginx/access_log;
  #error_log /var/log/nginx/error_log;
  
  location = / {

    content_by_lua_block {
        ngx.header['server'] = 'Elestio'
    }
    access_by_lua_block {
        ngx.header['server'] = 'Elestio'
    }


    auth_basic "Authentication";
    auth_basic_user_file /etc/nginx/conf.d/.htpasswd;


    limit_req zone=iprl burst=500 nodelay;
    limit_req_log_level warn;

    

    add_header X-Cache-Status \$upstream_cache_status;
    proxy_ignore_headers Cache-Control;

    #proxy_cache_valid any 0s;
    #proxy_cache my_cache;
    #proxy_cache_lock on;
    #proxy_cache_methods GET HEAD;
    #proxy_cache_bypass \$cookie_nocache \$arg_nocache;
    #proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
    #proxy_cache_bypass \$http_upgrade;

    proxy_http_version 1.1;
    proxy_pass http://172.17.0.1:7097/;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-Port  \$server_port;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;

    proxy_set_header Authorization \$http_authorization;
    proxy_pass_header  Authorization;

    proxy_hide_header x-powered-by;

  }

  location = /api {

    content_by_lua_block {
        ngx.header['server'] = 'Elestio'
    }
    access_by_lua_block {
        ngx.header['server'] = 'Elestio'
    }


    auth_basic "Authentication";
    auth_basic_user_file /etc/nginx/conf.d/.htpasswd;


    limit_req zone=iprl burst=500 nodelay;
    limit_req_log_level warn;

    

    add_header X-Cache-Status \$upstream_cache_status;
    proxy_ignore_headers Cache-Control;

    #proxy_cache_valid any 0s;
    #proxy_cache my_cache;
    #proxy_cache_lock on;
    #proxy_cache_methods GET HEAD;
    #proxy_cache_bypass \$cookie_nocache \$arg_nocache;
    #proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
    #proxy_cache_bypass \$http_upgrade;

    proxy_http_version 1.1;
    proxy_pass http://172.17.0.1:7097/;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-Port  \$server_port;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;

    proxy_set_header Authorization \$http_authorization;
    proxy_pass_header  Authorization;

    proxy_hide_header x-powered-by;

  }

location / {

    content_by_lua_block {
        ngx.header['server'] = 'Elestio'
    }
    access_by_lua_block {
        ngx.header['server'] = 'Elestio'
    }
    
    auth_basic off;


    limit_req zone=iprl burst=500 nodelay;
    limit_req_log_level warn;

    

    add_header X-Cache-Status \$upstream_cache_status;
    proxy_ignore_headers Cache-Control;

    #proxy_cache_valid any 0s;
    #proxy_cache my_cache;
    #proxy_cache_lock on;
    #proxy_cache_methods GET HEAD;
    #proxy_cache_bypass \$cookie_nocache \$arg_nocache;
    #proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
    #proxy_cache_bypass \$http_upgrade;

    proxy_http_version 1.1;
    proxy_pass http://172.17.0.1:7097/;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-Port  \$server_port;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;

    proxy_set_header Authorization \$http_authorization;
    proxy_pass_header  Authorization;

    proxy_hide_header x-powered-by;

  }
}" > /opt/elestio/nginx/conf.d/${DOMAIN}.conf
docker exec elestio-nginx nginx -s reload;
