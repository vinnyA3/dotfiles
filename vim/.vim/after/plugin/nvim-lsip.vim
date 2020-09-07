lua << END
  require'nvim_lsp'.tsserver.setup{}
END

sign define LspDiagnosticsErrorSign text=❌
sign define LspDiagnosticsWarningSign text=b
sign define LspDiagnosticsInformationSign text=k
sign define LspDiagnosticsHintSign text=j
