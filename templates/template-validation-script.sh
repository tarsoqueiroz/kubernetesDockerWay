#!/bin/bash
# ═══════════════════════════════════════════════════
# SCRIPT DE VALIDAÇÃO - ETAPA X
# Valida se todos os componentes da etapa estão OK
# ═══════════════════════════════════════════════════

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
PASSED=0
FAILED=0

# Função de validação
validate() {
    local test_name="$1"
    local command="$2"

    echo -n "Validando: ${test_name}... "

    if eval "${command}" &>/dev/null; then
        echo -e "${GREEN}✓ PASSOU${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FALHOU${NC}"
        ((FAILED++))
        return 1
    fi
}

# Banner
echo "════════════════════════════════════════════════"
echo "  VALIDAÇÃO - ETAPA X: [Nome da Etapa]"
echo "════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════
# VALIDAÇÕES
# ═══════════════════════════════════════════════════

validate "Serviço A rodando" \
    "systemctl is-active --quiet servico-a"

validate "Porta B escutando" \
    "netstat -tuln | grep -q ':porta'"

validate "Arquivo C existe" \
    "test -f /caminho/arquivo"

validate "Comando D disponível" \
    "command -v comando-d"

validate "Conectividade E" \
    "curl -sf http://localhost:porta/health"

# ═══════════════════════════════════════════════════
# RESULTADO FINAL
# ═══════════════════════════════════════════════════

echo ""
echo "════════════════════════════════════════════════"
echo "  RESULTADO"
echo "════════════════════════════════════════════════"
echo -e "Testes passados: ${GREEN}${PASSED}${NC}"
echo -e "Testes falhados: ${RED}${FAILED}${NC}"
echo ""

if [ ${FAILED} -eq 0 ]; then
    echo -e "${GREEN}✓ ETAPA X VALIDADA COM SUCESSO!${NC}"
    echo "Você pode prosseguir para a Etapa X+1"
    exit 0
else
    echo -e "${RED}✗ VALIDAÇÃO FALHOU${NC}"
    echo "Revise os itens acima antes de prosseguir"
    echo "Consulte: docs/troubleshooting-geral.md"
    exit 1
fi
