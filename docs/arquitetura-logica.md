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

