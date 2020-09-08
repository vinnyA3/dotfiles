lua << END
require'nvim_lsp'.tsserver.setup{
  on_attach=require'diagnostic'.on_attach
}
END

sign define LspDiagnosticsErrorSign text=❌
sign define LspDiagnosticsWarningSign text=⚠️
sign define LspDiagnosticsInformationSign text=💬
sign define LspDiagnosticsHintSign text=▶️
