#!/bin/bash

LAMBDA_DIR="./lambdas"

PACKAGE_DIR="./packages"

mkdir -p $PACKAGE_DIR

for LAMBDA in $(ls $LAMBDA_DIR); do
  echo "Iniciando empacotamento da $LAMBDA..."
  
  mkdir -p $LAMBDA_DIR/$LAMBDA/package
  
  echo "Criando venv na $LAMBDA."
  python3 -m venv $LAMBDA_DIR/$LAMBDA/venv
  
  echo "Ativando venv na $LAMBDA."
  source $LAMBDA_DIR/$LAMBDA/venv/bin/activate
  
  echo "Instalando dependencias na $LAMBDA."
  pip install -r $LAMBDA_DIR/$LAMBDA/requirements.txt
  
  echo "Empacotando dependencias da $LAMBDA."
  cp -r $LAMBDA_DIR/$LAMBDA/venv/lib/python3.9/site-packages/* $LAMBDA_DIR/$LAMBDA/package
  
  echo "Empacotando projeto da $LAMBDA."
  cd $LAMBDA_DIR/$LAMBDA/package
  zip -r $PACKAGE_DIR/$LAMBDA.zip .
  cd - > /dev/null
  
  zip -g $PACKAGE_DIR/$LAMBDA.zip $LAMBDA_DIR/$LAMBDA/lambda_handler.py
  
  echo "Desativando venv na $LAMBDA."
  deactivate
  
  echo "Limpando venv na $LAMBDA para economizar espaço."
  rm -rf $LAMBDA_DIR/$LAMBDA/venv
done