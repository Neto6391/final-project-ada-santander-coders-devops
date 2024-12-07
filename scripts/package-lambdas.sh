#!/bin/bash

LAMBDA_DIR="./lambdas"

PACKAGE_DIR="./packages"
BASE_DIR="$(pwd)"

mkdir -p $PACKAGE_DIR
chmod -R 755 $PACKAGE_DIR

for LAMBDA in $(ls $LAMBDA_DIR); do
  echo "Iniciando empacotamento da $LAMBDA..."
  
  mkdir -p $BASE_DIR/$LAMBDA_DIR/$LAMBDA/package
  
  echo "Criando venv na $LAMBDA."
  python3 -m venv $BASE_DIR/$LAMBDA_DIR/$LAMBDA/venv
  
  echo "Ativando venv na $LAMBDA."
  source $BASE_DIR/$LAMBDA_DIR/$LAMBDA/venv/bin/activate
  
  echo "Instalando dependencias na $LAMBDA."
  pip install -r $BASE_DIR/$LAMBDA_DIR/$LAMBDA/requirements.txt
  
  echo "Empacotando dependencias da $LAMBDA."
  cp -r $BASE_DIR/$LAMBDA_DIR/$LAMBDA/venv/lib/python3.9/site-packages/* $BASE_DIR/$LAMBDA_DIR/$LAMBDA/package
  
  echo "Empacotando projeto da $LAMBDA."
  cd $BASE_DIR/$LAMBDA_DIR/$LAMBDA/package
  zip -r "$BASE_DIR/$PACKAGE_DIR/$LAMBDA.zip" .
  cd - > /dev/null
  
  zip -g $PACKAGE_DIR/$LAMBDA.zip $BASE_DIR/$LAMBDA_DIR/$LAMBDA/lambda_handler.py
  
  echo "Desativando venv na $LAMBDA."
  deactivate
  
  echo "Limpando venv na $LAMBDA para economizar espaço."
  rm -rf $BASE_DIR/$LAMBDA_DIR/$LAMBDA/venv
done