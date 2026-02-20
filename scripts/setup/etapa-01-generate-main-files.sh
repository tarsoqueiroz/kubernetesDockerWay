#!/bin/bash
# ═══════════════════════════════════════════════════
# GERAÇÃO DOS ARQUIVOS PRINCIPAIS - ETAPA 1
# Planejamento e Preparação do Ambiente
# ═══════════════════════════════════════════════════

set -euo pipefail

# PROJECT_ROOT="kubernetes-hard-way"
PROJECT_ROOT="."

if [ ! -d "${PROJECT_ROOT}" ]; then
  echo "Diretório ${PROJECT_ROOT} não encontrado. Execute a partir da pasta que contém o projeto."
  exit 1
fi

cd "${PROJECT_ROOT}"

# ═══════════════════════════════════════════════════
# 1) Inventário de Nós
#   configs/networking/nodes-inventory.yaml
# ═══════════════════════════════════════════════════

cat > configs/networking/nodes-inventory.yaml << 'EOF'
# configs/networking/nodes-inventory.yaml
# Inventário lógico dos nós do cluster

clusterName: k8s-hard-way-lab
environment: lab
provider: docker

nodes:
  - name: kdwbastion
    role: bastion
    storagePath: storage/bastion
    cpu: 1
    memoryMiB: 1024
    notes: "Nó administrativo, sem componentes Kubernetes."

  - name: kdwlb
    role: edge-load-balancer
    storagePath: storage/kdwlb
    cpu: 1
    memoryMiB: 1024
    notes: "Nó responsável por balancear API (6443) e tráfego HTTP/HTTPS de entrada."

  - name: kdwcp0
    role: control-plane
    storagePath: storage/cp-01
    cpu: 2
    memoryMiB: 2048
    notes: "Control Plane 1 (etcd + api-server + controller-manager + scheduler)."

  - name: kdwcp1
    role: control-plane
    storagePath: storage/cp-02
    cpu: 2
    memoryMiB: 2048
    notes: "Control Plane 2 (HA)."

  - name: kdwcp2
    role: control-plane
    storagePath: storage/cp-03
    cpu: 2
    memoryMiB: 2048
    notes: "Control Plane 3 (HA)."

  - name: kdwworker0
    role: worker
    storagePath: storage/worker-01
    cpu: 2
    memoryMiB: 2048
    notes: "Worker 1 para workloads gerais."

  - name: kdwworker1
    role: worker
    storagePath: storage/worker-02
    cpu: 2
    memoryMiB: 2048
    notes: "Worker 2 para workloads gerais."

  - name: kdwworker2
    role: worker
    storagePath: storage/worker-03
    cpu: 2
    memoryMiB: 2048
    notes: "Worker 3 focado em testes de resiliência."
EOF

echo "✓ configs/networking/nodes-inventory.yaml criado/atualizado."

# ═══════════════════════════════════════════════════
# 2) Planejamento de Rede
#   configs/networking/network-plan.yaml
# ═══════════════════════════════════════════════════

cat > configs/networking/network-plan.yaml << 'EOF'
# configs/networking/network-plan.yaml
# Planejamento de rede do cluster Kubernetes Hard Way

clusterNetwork:
  name: k8s-hard-way-net
  type: docker-bridge
  cidr: 172.171.0.0/16
  gateway: 172.171.0.1
  notes: "Rede Docker dedicada ao cluster (containers de nós + load balancer)."

kubernetes:
  podCIDR: 10.200.0.0/16
  serviceCIDR: 10.32.0.0/16
  dnsServiceIP: 10.32.0.10
  apiServerVirtualIP: 172.171.0.10

reservedIPs:
  - name: kdwbastion
    ip: 172.171.0.100
  - name: kdwlb
    ip: 172.171.0.10
  - name: kdwcp0
    ip: 172.171.0.11
  - name: kdwcp1
    ip: 172.171.0.12
  - name: kdwcp2
    ip: 172.171.0.13
  - name: kdwworker0
    ip: 172.171.0.21
  - name: kdwworker1
    ip: 172.171.0.22
  - name: kdwworker2
    ip: 172.171.0.23

ports:
  apiServer:
    port: 6443
    description: "Porta da API do Kubernetes."
  etcd:
    clientPort: 2379
    peerPort: 2380
  kubelet:
    port: 10250
  scheduler:
    port: 10259
  controllerManager:
    port: 10257
  nodePortRange:
    from: 30000
    to: 32767

notes:
  - "A rede 172.171.0.0/16 será criada como bridge Docker dedicada na Etapa 2."
  - "O IP 172.171.0.10 será usado pelo nó kdwlb e como VIP da API."
EOF

echo "✓ configs/networking/network-plan.yaml criado/atualizado."

# ═══════════════════════════════════════════════════
# 3) Versões dos Componentes
#   configs/cluster-versions.yaml
# ═══════════════════════════════════════════════════

cat > configs/cluster-versions.yaml << 'EOF'
# configs/cluster-versions.yaml
# Versões dos componentes do cluster

kubernetes:
  version: "1.33.8"
  imageRepository: "registry.k8s.io"
  notes:
    - "Verificar matriz de compatibilidade oficial com etcd e containerd."
    - "Usar sempre a mesma versão para todos os control planes e componentes centrais."

etcd:
  version: "3.5.21"
  image: "registry.k8s.io/etcd/etcd:3.5.21"
  notes:
    - "Cluster etcd em 3 nós (kdwcp0, kdwcp1, kdwcp2)."

containerRuntime:
  name: "containerd"
  version: "2.0.0"  # ajustar para versão exata que você escolher instalar
  notes:
    - "Runtime padrão recomendado pelo Kubernetes."
    - "Configuração será feita em cada nó (control planes e workers)."

cni:
  name: "calico"
  version: "v3.27.0"  # exemplo; na Etapa 8 podemos ajustar pra última estável compatível
  notes:
    - "Deve suportar NetworkPolicies."
    - "Configuração aplicada via manifestos YAML na Etapa 8."

addons:
  coreDNS:
    version: "1.11.0"  # exemplo
  metricsServer:
    version: "0.7.0"   # exemplo
  kubernetesDashboard:
    version: "v2.7.0"  # exemplo

notes:
  - "As versões marcadas como exemplo podem ser atualizadas conforme necessidade."
  - "Antes de alterar versões, revisar impacto em todas as etapas já concluídas."
EOF

echo "✓ configs/cluster-versions.yaml criado/atualizado."

# ═══════════════════════════════════════════════════
# 4) Arquitetura Lógica
#   docs/arquitetura-logica.md
# (somente Markdown tradicional, sem HTML)
# ═══════════════════════════════════════════════════

cat > docs/arquitetura-logica.md << 'EOF'
# Arquitetura Lógica - Kubernetes Hard Way (Lab)

## Visão Geral

Este ambiente simula um cluster Kubernetes completo utilizando containers Docker como nós (bastion, load balancer, control planes e workers), permitindo estudo detalhado de cada componente.

Os containers serão executados em um único host Linux, conectados por uma rede bridge dedicada, isolada da rede principal do host.

## Componentes Principais

### Bastion Node

- Nome: kdwbastion
- Função: ponto de administração
- Características:
  - Não participa do cluster como node Kubernetes.
  - Acessa o cluster via API exposta pelo load balancer.
  - Armazena ferramentas administrativas e artefatos sensíveis (certificados, kubeconfigs, scripts).

Ferramentas principais previstas:

- kubectl
- cfssl e cfssljson, ou openssl
- etcdctl
- jq, curl, wget e ferramentas básicas de diagnóstico

### Edge Load Balancer

- Nome: kdwlb
- Função: balanceador de carga e gateway de entrada
- Responsabilidades:
  - Balancear o tráfego da API do Kubernetes (porta 6443) entre os três control planes.
  - Servir como ponto de entrada HTTP/HTTPS para aplicações expostas no cluster.
  - Fazer proxy reverso ou encaminhamento TCP para serviços NodePort ou, futuramente, para um Ingress Controller.

IP planejado: 172.171.0.10

Portas principais:

- 6443: API Kubernetes (do host para kdwlb, e de kdwlb para kdwcp0-2)
- 80 e 443 internos em kdwlb, mapeados em portas do host (por exemplo 8080 e 8443)

### Control Plane Nodes

- Nomes: kdwcp0, kdwcp1, kdwcp2
- Função: plano de controle do cluster
- Componentes previstos em cada nó:
  - etcd (membro do cluster etcd)
  - kube-apiserver
  - kube-controller-manager
  - kube-scheduler
- Objetivo:
  - Garantir alta disponibilidade do plano de controle.
  - Cada control plane roda um membro etcd e uma instância dos componentes de controle.

IPs planejados:

- kdwcp0: 172.171.0.11
- kdwcp1: 172.171.0.12
- kdwcp2: 172.171.0.13

### Worker Nodes

- Nomes: kdwworker0, kdwworker1, kdwworker2
- Função: executar workloads (pods) e expor serviços
- Componentes principais:
  - containerd (runtime)
  - kubelet
  - kube-proxy

IPs planejados:

- kdwworker0: 172.171.0.21
- kdwworker1: 172.171.0.22
- kdwworker2: 172.171.0.23

## Rede

### Rede de Nós (Containers)

- Tipo: bridge Docker dedicada
- CIDR: 172.171.0.0/16
- Gateway: 172.171.0.1
- Todos os containers (kdwbastion, kdwlb, kdwcp0-2, kdwworker0-2) estarão conectados a esta rede.

### Rede de Pods

- CIDR: 10.200.0.0/16
- Fornecida pela CNI (Calico).
- Cada nó receberá um subconjunto do CIDR de pods.

### Rede de Services (ClusterIP)

- CIDR: 10.32.0.0/16
- Endereço reservado para o serviço de DNS interno:
  - DNS Service IP: 10.32.0.10

### API Server Virtual IP

- IP virtual da API exposto pelo load balancer:
  - 172.171.0.10
- Este IP será usado pelo kubeconfig e pelos componentes internos para acessar o kube-apiserver de forma estável.

## Alta Disponibilidade

- etcd:
  - Cluster de 3 nós executando em kdwcp0, kdwcp1 e kdwcp2.
- kube-apiserver:
  - Rodando em todos os três control planes.
  - Acesso sempre via IP virtual 172.171.0.10, balanceado pelo kdwlb.
- Objetivo:
  - Garantir que a falha de um único control plane não torne o cluster indisponível.

## CNI e Políticas de Rede

- CNI escolhida: Calico
- Funcionalidades esperadas:
  - Criação e gerenciamento da rede de pods (CIDR 10.200.0.0/16).
  - Suporte a NetworkPolicies para isolamento de tráfego entre namespaces e aplicações.
- A CNI será instalada após o bootstrap do control plane e join dos workers.

## Versões Alvo

Principais versões definidas para o ambiente:

- Kubernetes: 1.33.8
- etcd: v3.5.21
- Container runtime: containerd (linha 2.x)
- CNI: Calico (versão estável compatível com Kubernetes 1.33.8)
- Addons principais:
  - CoreDNS
  - metrics-server
  - Kubernetes Dashboard

Os detalhes de versão e imagem estão documentados em configs/cluster-versions.yaml.

## Objetivos de Estudo

Este laboratório tem como principais objetivos:

- Compreender a montagem manual de um cluster Kubernetes, sem uso de ferramentas como kubeadm.
- Entender como os componentes se relacionam:
  - kube-apiserver, etcd, controller-manager, scheduler, kubelet, kube-proxy.
- Estudar em detalhes:
  - Geração e uso de certificados (PKI).
  - Configuração de rede de pods e services via CNI.
  - Funcionamento de um cluster etcd em alta disponibilidade.
  - Exposição de serviços (NodePort, futuramente Ingress) via nó edge load balancer.
- Praticar:
  - Diagnóstico e troubleshooting de problemas em cada camada.
  - Procedimentos de backup e restore (principalmente etcd e certificados).
  - Validações e testes de resiliência (falha de nós de controle e workers).

EOF

echo "✓ docs/arquitetura-logica.md criado/atualizado."

echo
echo "Arquivos principais da Etapa 1 gerados com sucesso:"
echo "  - configs/networking/nodes-inventory.yaml"
echo "  - configs/networking/network-plan.yaml"
echo "  - configs/cluster-versions.yaml"
echo "  - docs/arquitetura-logica.md"
echo
