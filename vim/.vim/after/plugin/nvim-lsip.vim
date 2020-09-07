lua << END
  require'nvim_lsp'.tsserver.setup{}
END

sign define LspDiagnosticsErrorSign text=❌
sign define LspDiagnosticsWarningSign text=⚠️
sign define LspDiagnosticsInformationSign text=💬
sign define LspDiagnosticsHintSign text=▶️
