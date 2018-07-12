# ==================
# imports
use readline-binding

# ==================
# path
E:PATH=$E:PATH":/usr/share:"$E:HOME"/.stack/snapshots/x86_64-linux-tinfo6/lts-9.17/8.0.2/bin:"$E:HOME"/.stack/compiler-tools/x86_64-linux-tinfo6/ghc-8.0.2/bin:"$E:HOME"/.stack/programs/x86_64-linux/ghc-tinfo6-8.0.2/bin:"$E:HOME"/.local/bin"

# ==================
# ls aliases 
fn ls [@a]{ e:ls --color $@a }
fn ll [@a]{ e:ls -la --color $@a }
fn la [@a]{ e:ls -a --color $@a }
fn t [@a]{ e:todo.sh $@a }

# git aliases
fn g [@a]{ e:git $@a }
fn gadd [@a]{ e:git $@a add}
fn gpush []{ e:git push origin master }

# vim aliases - avoid nested nvim instances 
fn vim [@a]{ 
  if ([]{ eq (echo $E:NVIM_LISTEN_ADDRESS) '' }) {
    e:nvim $@a 
  } else {
    put 'Warning: Avoid Nesting NVIM Instances!!'
  }
}

# misc program aliases
fn tmux [@a]{ e:tmux -2 -f ~/.tmux/tmux.conf $@a}
fn rtv [@a]{ e:rtv --theme ~/.config/rtv/themes/dracula $@a }

# ==================
# prompt
edit:prompt = { tilde-abbr $pwd; put ' -> ' }
edit:rprompt = (constantly (edit:styled (whoami)@(hostname) "italic;green;bold"))

