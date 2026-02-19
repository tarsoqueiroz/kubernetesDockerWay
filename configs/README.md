# Configurações do Cluster

## 📂 Estrutura

- **certificates/**: Certificados e chaves PKI (CA, componentes, nodes)
- **kubeconfigs/**: Arquivos kubeconfig para componentes e usuários
- **manifests/**: Manifestos Kubernetes (YAML) para deployments
- **networking/**: Configurações de rede (CNI, ranges, políticas)

## 🔐 Segurança

⚠️ **ATENÇÃO**: Certificados e chaves privadas são **ALTAMENTE SENSÍVEIS**!

### Boas Práticas

- ❌ **NUNCA** commitar certificados/chaves em repositórios públicos
- ✅ Manter backups criptografados em local seguro
- ✅ Rotacionar certificados periodicamente (antes do vencimento)
- ✅ Usar permissões restritivas (600 para chaves, 644 para certs)
- ✅ Documentar data de criação e validade

### Permissões Recomendadas

<div class="widget code-container remove-before-copy"><div class="code-header non-draggable"><span class="iaf s13 w700 code-language-placeholder">bash</span><div class="code-copy-button"><span class="iaf s13 w500 code-copy-placeholder">Copiar</span><img class="code-copy-icon" src="data:image/svg+xml;utf8,%0A%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20viewBox%3D%220%200%2016%2016%22%20fill%3D%22none%22%3E%0A%20%20%3Cpath%20d%3D%22M10.8%208.63V11.57C10.8%2014.02%209.82%2015%207.37%2015H4.43C1.98%2015%201%2014.02%201%2011.57V8.63C1%206.18%201.98%205.2%204.43%205.2H7.37C9.82%205.2%2010.8%206.18%2010.8%208.63Z%22%20stroke%3D%22%23717C92%22%20stroke-width%3D%221.05%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M15%204.42999V7.36999C15%209.81999%2014.02%2010.8%2011.57%2010.8H10.8V8.62999C10.8%206.17999%209.81995%205.19999%207.36995%205.19999H5.19995V4.42999C5.19995%201.97999%206.17995%200.999992%208.62995%200.999992H11.57C14.02%200.999992%2015%201.97999%2015%204.42999Z%22%20stroke%3D%22%23717C92%22%20stroke-width%3D%221.05%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%2F%3E%0A%3C%2Fsvg%3E%0A" /></div></div><pre id="code-0ukzy1raf" style="color:#111b27;background:#e3eaf2;font-family:Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace;text-align:left;white-space:pre;word-spacing:normal;word-break:normal;word-wrap:normal;line-height:1.5;-moz-tab-size:4;-o-tab-size:4;tab-size:4;-webkit-hyphens:none;-moz-hyphens:none;-ms-hyphens:none;hyphens:none;padding:8px;margin:8px;overflow:auto;width:calc(100% - 8px);border-radius:8px;box-shadow:0px 8px 18px 0px rgba(120, 120, 143, 0.10), 2px 2px 10px 0px rgba(255, 255, 255, 0.30) inset"><code class="language-bash" style="white-space:pre;color:#111b27;background:none;font-family:Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace;text-align:left;word-spacing:normal;word-break:normal;word-wrap:normal;line-height:1.5;-moz-tab-size:4;-o-tab-size:4;tab-size:4;-webkit-hyphens:none;-moz-hyphens:none;-ms-hyphens:none;hyphens:none"><span class="token" style="color:#3c526d"># Chaves privadas</span><span>
</span><span></span><span class="token" style="color:#7c00aa">chmod</span><span> </span><span class="token" style="color:#755f00">600</span><span> certificates/*.key
</span>
<span></span><span class="token" style="color:#3c526d"># Certificados públicos</span><span>
</span><span></span><span class="token" style="color:#7c00aa">chmod</span><span> </span><span class="token" style="color:#755f00">644</span><span> certificates/*.crt
</span>
<span></span><span class="token" style="color:#3c526d"># Kubeconfigs</span><span>
</span><span></span><span class="token" style="color:#7c00aa">chmod</span><span> </span><span class="token" style="color:#755f00">600</span><span> kubeconfigs/*.kubeconfig
</span></code></pre></div>

## 📋 Inventário

Manter um inventário de certificados em `certificates/INVENTORY.md`:
- Nome do certificado
- Data de criação
- Data de expiração
- Propósito
- Nodes/componentes que utilizam
