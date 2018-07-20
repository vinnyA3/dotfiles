# ==================
# imports
use readline-binding

# ==================
# path
E:PATH=$E:PATH":/usr/share:"$E:HOME"/.local/bin"
E:TERM="xterm-256color"

# ==================
# ls aliases 
fn ls [@a]{ e:ls --color $@a }
fn ll [@a]{ e:ls -la --color $@a }
fn la [@a]{ e:ls -a --color $@a }
fn rtv [@a]{ e:rtv --theme .config/rtv/themes/dracula $@a }
# fn t [@a]{ e:todo.sh $@a }

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
# fn rtv [@a]{ e:rtv --theme ~/.config/rtv/themes/dracula $@a }

# ==================
# prompt
edit:prompt = { tilde-abbr $pwd; put ' -> ' }
edit:rprompt = (constantly (edit:styled (whoami)@(hostname) "green;bold"))

