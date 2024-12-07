#!/bin/bash
set -e

LAMBDA_DIR="./lambdas"
PACKAGE_DIR="./packages"
BASE_DIR="$(pwd)"

rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR"
chmod 755 "$PACKAGE_DIR"

for LAMBDA in $(ls "$LAMBDA_DIR"); do
  echo "Empacotando $LAMBDA..."
  
  TEMP_VENV=$(mktemp -d)
  python3 -m venv "$TEMP_VENV"
  source "$TEMP_VENV/bin/activate"
  
  pip install \
    --no-cache-dir \
    --no-deps \
    --target="$BASE_DIR/$LAMBDA_DIR/$LAMBDA/package" \
    -r "$BASE_DIR/$LAMBDA_DIR/$LAMBDA/requirements.txt"
  
  cd "$BASE_DIR/$LAMBDA_DIR/$LAMBDA/package"
  zip -qr "$BASE_DIR/$PACKAGE_DIR/$LAMBDA.zip" .
  
  zip -qj "$BASE_DIR/$PACKAGE_DIR/$LAMBDA.zip" "$BASE_DIR/$LAMBDA_DIR/$LAMBDA/lambda_handler.py"
  
  deactivate
  rm -rf "$TEMP_VENV"
  
  echo "Pacote $LAMBDA criado com sucesso."
done

echo "Empacotamento concluído!"