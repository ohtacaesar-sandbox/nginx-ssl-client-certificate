set -eux

CA_DIR=/etc/ssl/demoCA

create() {
  BASE_DIR=/etc/ssl/$1
  mkdir -p ${BASE_DIR} 
  openssl req \
    -new \
    -nodes \
    -keyout ${BASE_DIR}/privkey.pem \
    -out ${BASE_DIR}/cert.csr \
    -subj "/C=JP/ST=/L=/O=/OU=/CN=$1"

  openssl ca \
    -in  ${BASE_DIR}/cert.csr \
    -out ${BASE_DIR}/cert.pem \
    -policy policy_anything \
    -batch \
    -days 3650

  openssl pkcs12 \
    -export \
    -nodes \
    -password pass: \
    -inkey ${BASE_DIR}/privkey.pem \
    -in ${BASE_DIR}/cert.pem \
    -certfile ${CA_DIR}/cacert.pem \
    -out ${BASE_DIR}/$1.pfx
}


create $1

