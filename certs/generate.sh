#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout dev.todo.key -out dev.todo.crt -subj "/CN=dev.todo.com" -days 365
openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout prod.todo.key -out prod.todo.crt -subj "/CN=prod.todo.com" -days 365


kubectl create secret tls dev-todo-tls-secret --cert=dev.todo.crt --key=dev.todo.key --dry-run=client -o yaml > dev.todo.secret.yaml

kubectl create secret tls prod-todo-tls-secret --cert=prod.todo.crt --key=prod.todo.key --dry-run=client -o yaml > prod.todo.secret.yaml

mkdir -p ../environments/dev/certs && cp {dev.todo.key,dev.todo.crt}  ../environments/dev/certs
mkdir -p ../environments/prod/certs && cp {prod.todo.key,prod.todo.crt}  ../environments/prod/certs