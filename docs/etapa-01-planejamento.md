# Etapa 1: Planejamento e Preparação do Ambiente

## Objetivo

Definir a arquitetura do cluster, alocar recursos, mapear portas e preparar as ferramentas necessárias para a construção do Kubernetes do zero, incluindo um nó dedicado para balanceamento de carga e gateway de aplicação.

## Pré-requisitos

- [ ] Docker ou Podman instalado na máquina host
- [ ] Mínimo de 10 GB de RAM disponível (considerando o nó adicional)
- [ ] 25 GB de espaço em disco
- [ ] Sistema Linux (ou WSL2 no Windows)
- [ ] Acesso à internet para download de binários e imagens

## Visão Geral

Nesta etapa, planejaremos a topologia do cluster, definindo os nomes dos nós, endereços IP, ranges de rede e as versões dos componentes. Além dos nós tradicionais (bastion, control planes, workers), incluiremos um nó específico para atuar como **Edge Load Balancer**, responsável por:

- Balancear o tráfego para a API do Kubernetes (porta 6443) entre os três control planes.
- Servir como porta de entrada para aplicações (HTTP/HTTPS) expostas no cluster, redirecionando tráfego do host para os workers (via NodePort ou futuramente para um Ingress Controller).

## Atividades

### 1.1 Definição da Arquitetura

**Descrição:**  

O cluster será composto por:

- 1 nó bastion (administração)
- 1 nó edge load balancer (balanceador/gateway)
- 3 nós de controle (control plane)
- 3 nós workers

Todos serão containers Docker rodando na mesma máquina host, conectados por uma rede bridge isolada.

**Nomes dos containers:**

- Bastion: `kdwbastion`
- Edge Load Balancer: `kdwlb`
- Control Plane 1: `kdwcp0`
- Control Plane 2: `kdwcp1`
- Control Plane 3: `kdwcp2`
- Worker 1: `kdwworker0`
- Worker 2: `kdwworker1`
- Worker 3: `kdwworker2`

### 1.2 Definição dos Ranges de Rede

**Descrição:**  

Para garantir isolamento e evitar conflitos com a rede host, utilizaremos os seguintes ranges:

- Rede dos containers (bridge): `172.171.0.0/16`
- Pods CIDR (usado pela CNI): `10.200.0.0/16`
- Services CIDR (usado pelo Kubernetes): `10.32.0.0/16`
- IP do serviço de DNS interno: `10.32.0.10`

**Alocação de IPs estáticos:**

- Bastion: `172.171.0.100`
- Edge Load Balancer: `172.171.0.10`   # IP usado como entrada para o cluster
- Control Plane 1: `172.171.0.11`
- Control Plane 2: `172.171.0.12`
- Control Plane 3: `172.171.0.13`
- Worker 1: `172.171.0.21`
- Worker 2: `172.171.0.22`
- Worker 3: `172.171.0.23`

### 1.3 Versões dos Componentes

| Componente       | Versão         | Observação                          |
|------------------|----------------|-------------------------------------|
| Kubernetes       | 1.33.8         | Release estável mais recente        |
| etcd             | v3.5.21        | Banco de dados do cluster           |
| containerd       | 2.x            | Container runtime                   |
| Calico           | Última estável | CNI com suporte a Network Policies  |
| CoreDNS          | 1.11.x         | Service discovery                   |
| metrics-server   | Última estável | Coleta de métricas                  |
| HAProxy          | 2.8.x          | Load balancer e proxy reverso       |

### 1.4 Mapeamento de Portas

#### Portas internas entre os nós (necessárias para funcionamento do cluster)

| Componente          | Porta       | Protocolo | Descrição                          |
|---------------------|-------------|-----------|------------------------------------|
| etcd client         | 2379        | TCP       | Comunicação com etcd               |
| etcd peer           | 2380        | TCP       | Comunicação entre membros etcd     |
| Kubernetes API      | 6443        | TCP       | API Server                         |
| kubelet API         | 10250       | TCP       | Kubelet (métricas, exec)           |
| kube-scheduler      | 10259       | TCP       | Scheduler                          |
| kube-controller-man | 10257       | TCP       | Controller Manager                 |
| NodePort Services   | 30000-32767 | TCP       | Range para serviços NodePort       |

#### Portas expostas no Edge Load Balancer (kdwlb) e encaminhamento

O nó `kdwlb` receberá conexões do host físico e as redirecionará para os componentes internos conforme a tabela abaixo:

| Porta no Host | Porta no kdwlb | Destino Interno (Cluster)                            | Finalidade                                   |
|---------------|----------------|------------------------------------------------------|----------------------------------------------|
| 6443          | 6443           | kdwcp0:6443, kdwcp1:6443, kdwcp2:6443                | Acesso à API Kubernetes (balanceado)         |
| 8080          | 80             | kdwworker0:30080, kdwworker1:30080, kdwworker2:30080 | Tráfego HTTP para aplicações (via NodePort)  |
| 8443          | 443            | kdwworker0:30443, kdwworker1:30443, kdwworker2:30443 | Tráfego HTTPS para aplicações (via NodePort) |

> **Nota:** As portas 30080 e 30443 nos workers são exemplos de NodePorts que serão configuradas posteriormente para expor um Ingress Controller ou serviços diretamente. O balanceador fará o proxy reverso (camada 7) ou apenas encaminhamento TCP, conforme necessidade.

### 1.5 Ferramentas Necessárias

- `cfssl` e `cfssljson` (para geração de certificados)
- `kubectl` (cliente Kubernetes)
- `jq` (processamento JSON)
- `openssl` (utilitário de criptografia)
- `curl`, `wget` (download de binários)
- `git` (opcional, para clonar repositórios)

## Backup Crítico desta Etapa

Nenhum backup necessário nesta etapa, apenas o registro das configurações.

## Checkpoint de Validação

- [ ] Nomes dos containers definidos
- [ ] Ranges de IP anotados, com IP do load balancer definido como `172.171.0.10`
- [ ] Versões dos componentes escolhidas
- [ ] Mapeamento de portas documentado (`host` → `kdwlb` → `nós internos`)
- [ ] Ferramentas instaladas no host (verificar com `which`)

## Próximos Passos

Agora com o planejamento atualizado, siga para a **Etapa 2: Provisionamento da Infraestrutura Base e Networking**, onde criaremos todos os containers previstos.
