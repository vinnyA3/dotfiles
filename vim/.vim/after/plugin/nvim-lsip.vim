lua << END
local fn = vim.fn

require('lspconfig').tsserver.setup{
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = true
      }
    ),
  }
}

fn.sign_define("LspDiagnosticsErrorSign", { text=✘, texthl = "LspDiagnosticsError" })
fn.sign_define("LspDiagnosticsWarningSign", { text=⚠️ , texthl = "LspDiagnosticsWarning" })
fn.sign_define("LspDiagnosticsInformationSign", { text=💬, texthl = "LspDiagnosticsInformation" })
fn.sign_define("LspDiagnosticsHintSign", { text=▶️ , texthl = "LspDiagnosticsHint" })

END
