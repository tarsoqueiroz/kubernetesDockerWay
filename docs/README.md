# Documentação do Projeto

Esta pasta contém a documentação detalhada de cada etapa do projeto.

## 📋 Ordem de Execução

Execute as etapas na ordem numérica:

1. **etapa-01-planejamento.md** - Planejamento e Preparação do Ambiente
2. **etapa-02-infraestrutura.md** - Provisionamento da Infraestrutura Base e Networking
3. **etapa-03-bastion.md** - Configuração do Nó Bastion
4. **etapa-04-certificados.md** - Certificados e Segurança (PKI)
5. **etapa-05-etcd.md** - Bootstrapping do etcd Cluster
6. **etapa-06-control-plane.md** - Configuração dos Control Plane Components
7. **etapa-07-workers.md** - Configuração dos Worker Nodes
8. **etapa-08-cni.md** - Instalação e Configuração da CNI
9. **etapa-09-dns.md** - Configuração de DNS (CoreDNS)
10. **etapa-10-addons.md** - Addons Essenciais (Métricas e Dashboard)
11. **etapa-11-validacao.md** - Validação e Testes Operacionais

## 📖 Documentação Adicional

- **troubleshooting-geral.md**: Problemas comuns e soluções
- **referencias.md**: Links e materiais de referência
- **glossario.md**: Termos e conceitos importantes

## ✅ Checkpoints

Cada etapa possui um checkpoint de validação ao final. Não prossiga sem validar!

## 🆘 Suporte

Em caso de dúvidas ou problemas:
1. Consulte o troubleshooting da etapa específica
2. Verifique `troubleshooting-geral.md`
3. Revise os logs em `../logs/`
