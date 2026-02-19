# Kubernetes DOCKER Way - Cluster from Scratch

Projeto de estudo para montagem manual de cluster Kubernetes com foco em aprendizado profundo dos componentes e arquitetura.

## 🎯 Objetivo

Construir um cluster Kubernetes funcional desde o zero, entendendo cada componente e suas interações, sem uso de ferramentas automatizadas como kubeadm.

## 🏗️ Arquitetura

- **1 Bastion Node**: Ferramentas administrativas e ponto de controle
- **3 Control Plane Nodes**: Alta disponibilidade (HA)
- **3 Worker Nodes**: Camada de execução de workloads
- **CNI**: Com suporte a Network Policies (Cilium/Calico)
- **Infraestrutura**: Containers Docker simulando VMs

## 📂 Estrutura do Projeto

kubernetes-docker-way/
 ├── docs/ # Documentação detalhada de cada etapa
 ├── scripts/ # Scripts auxiliares e de validação
 │ ├── helpers/ # Scripts para tarefas repetitivas
 │ ├── validation/ # Scripts de validação por etapa
 │ └── setup/ # Scripts de setup inicial
 ├── configs/ # Arquivos de configuração
 │ ├── certificates/ # Certificados e chaves PKI
 │ ├── kubeconfigs/ # Arquivos kubeconfig
 │ ├── manifests/ # Manifestos Kubernetes (YAML)
 │ └── networking/ # Configurações de rede
 ├── backups/ # Backups críticos do cluster 
 │ ├── etcd/ # Snapshots do etcd 
 │ ├── configs/ # Backup de configurações 
 │ └── certificates/ # Backup de certificados 
 ├── logs/ # Logs de instalação e troubleshooting 
 ├── templates/ # Templates de documentação 
 └── storage/ # Volumes persistentes simulados 
   ├── bastion/ 
   ├── cp-01/ # Control Plane nodes 
   ├── cp-02/ 
   ├── cp-03/ 
   ├── worker-01/ # Worker nodes 
   ├── worker-02/ 
   └── worker-03/

## 🚀 Como Usar

### 1. Pré-requisitos

- Docker ou Podman instalado
- Mínimo 8GB RAM disponível
- 20GB de espaço em disco
- Sistema Linux ou WSL2

### 2. Seguir Documentação

Siga a documentação em ordem numérica dentro de `docs/`:

1. `etapa-01-planejamento.md`
2. `etapa-02-infraestrutura.md`
3. `etapa-03-bastion.md`
4. `etapa-04-certificados.md`
5. `etapa-05-etcd.md`
6. `etapa-06-control-plane.md`
7. `etapa-07-workers.md`
8. `etapa-08-cni.md`
9. `etapa-09-dns.md`
10. `etapa-10-addons.md`
11. `etapa-11-validacao.md`

### 3. Validação

Cada etapa possui um script de validação em `scripts/validation/`

<div class="widget code-container remove-before-copy"><div class="code-header non-draggable"><span class="iaf s13 w700 code-language-placeholder">bash</span><div class="code-copy-button"><span class="iaf s13 w500 code-copy-placeholder">Copiar</span><img class="code-copy-icon" src="data:image/svg+xml;utf8,%0A%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20viewBox%3D%220%200%2016%2016%22%20fill%3D%22none%22%3E%0A%20%20%3Cpath%20d%3D%22M10.8%208.63V11.57C10.8%2014.02%209.82%2015%207.37%2015H4.43C1.98%2015%201%2014.02%201%2011.57V8.63C1%206.18%201.98%205.2%204.43%205.2H7.37C9.82%205.2%2010.8%206.18%2010.8%208.63Z%22%20stroke%3D%22%23717C92%22%20stroke-width%3D%221.05%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M15%204.42999V7.36999C15%209.81999%2014.02%2010.8%2011.57%2010.8H10.8V8.62999C10.8%206.17999%209.81995%205.19999%207.36995%205.19999H5.19995V4.42999C5.19995%201.97999%206.17995%200.999992%208.62995%200.999992H11.57C14.02%200.999992%2015%201.97999%2015%204.42999Z%22%20stroke%3D%22%23717C92%22%20stroke-width%3D%221.05%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%2F%3E%0A%3C%2Fsvg%3E%0A" /></div></div><pre id="code-1lhchmlwk" style="color:#111b27;background:#e3eaf2;font-family:Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace;text-align:left;white-space:pre;word-spacing:normal;word-break:normal;word-wrap:normal;line-height:1.5;-moz-tab-size:4;-o-tab-size:4;tab-size:4;-webkit-hyphens:none;-moz-hyphens:none;-ms-hyphens:none;hyphens:none;padding:8px;margin:8px;overflow:auto;width:calc(100% - 8px);border-radius:8px;box-shadow:0px 8px 18px 0px rgba(120, 120, 143, 0.10), 2px 2px 10px 0px rgba(255, 255, 255, 0.30) inset"><code class="language-bash" style="white-space:pre;color:#111b27;background:none;font-family:Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace;text-align:left;word-spacing:normal;word-break:normal;word-wrap:normal;line-height:1.5;-moz-tab-size:4;-o-tab-size:4;tab-size:4;-webkit-hyphens:none;-moz-hyphens:none;-ms-hyphens:none;hyphens:none"><span class="token" style="color:#3c526d"># Exemplo: validar etapa 5</span><span>
</span>./scripts/validation/validate-etapa-05.sh
</code></pre></div>

## 📚 Referências

- [Kubernetes The Hard Way - Kelsey Hightower](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)
- [Kind - Kubernetes in Docker](https://kind.sigs.k8s.io/)

## ⚠️ Avisos Importantes

- Este é um ambiente de **estudo**, não para produção
- Certificados e chaves são sensíveis - não commitar em repos públicos
- Fazer backups regulares durante o processo
- Consultar `docs/troubleshooting-geral.md` em caso de problemas

## 📝 Licença

Projeto educacional - use livremente para aprendizado

---

**Criado por**: [Seu Nome]  
**Data**: $(date +%Y-%m-%d)
