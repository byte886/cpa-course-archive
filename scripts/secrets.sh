#!/bin/bash
# 密钥管理工具 - 加密存储敏感凭证
# 用法:
#   ./scripts/secrets.sh encrypt <明文文件或字符串> <输出文件>
#   ./scripts/secrets.sh decrypt <加密文件>
# 加密密码: 如需解密请向用户询问密码，不要硬编码或猜测

SECRETS_DIR="$(cd "$(dirname "$0")/.." && pwd)/.secrets"
mkdir -p "$SECRETS_DIR"

encrypt_token() {
  local token="$1"
  local outfile="${2:-$SECRETS_DIR/gh_token.enc}"
  echo -n "$token" | openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:"$ENCRYPT_PASS" -base64 > "$outfile"
  echo "Encrypted to: $outfile"
}

decrypt_token() {
  local infile="${1:-$SECRETS_DIR/gh_token.enc}"
  openssl enc -aes-256-cbc -d -pbkdf2 -pass pass:"$ENCRYPT_PASS" -base64 -in "$infile"
}

case "${1:-}" in
  encrypt)
    read -s -p "Enter encryption password: " ENCRYPT_PASS; echo
    encrypt_token "$2" "$3"
    ;;
  decrypt)
    read -s -p "Enter encryption password: " ENCRYPT_PASS; echo
    decrypt_token "$2"
    ;;
  gh-auth)
    read -s -p "Enter encryption password: " ENCRYPT_PASS; echo
    decrypt_token | gh auth login --with-token
    echo "gh authenticated"
    ;;
  *)
    echo "Usage: $0 {encrypt|decrypt|gh-auth}"
    echo ""
    echo "  encrypt <token> [outfile]  - Encrypt and save a token"
    echo "  decrypt [infile]           - Decrypt and print token"
    echo "  gh-auth                    - Decrypt token and auth gh"
    exit 1
    ;;
esac
