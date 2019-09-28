FROM nginx:1.17-alpine

RUN set -eux \
  &&  apk add --no-cache openssl \
  &&  CA_DIR=/etc/ssl/demoCA \
  &&  mkdir -p ${CA_DIR}/private \
  &&  mkdir -p ${CA_DIR}/newcerts \
  &&  touch ${CA_DIR}/index.txt \
  &&  echo 00 > ${CA_DIR}/serial \
  &&  openssl req \
    -new \
    -nodes \
    -keyout ${CA_DIR}/private/cakey.pem \
    -out ${CA_DIR}/cacert.csr \
    -subj "/C=/ST=/L=/O=/OU=/CN=example.org" \
  &&  openssl x509 \
    -req \
    -in ${CA_DIR}/cacert.csr \
    -out ${CA_DIR}/cacert.pem \
    -signkey ${CA_DIR}/private/cakey.pem \
    -days 36500

copy openssl.cnf etc/ssl

