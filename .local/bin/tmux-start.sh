#!/bin/sh

session="doc"

tmux new-session -d -s $session

window=1
#tmux new-window -t $session:$window -n 'src'
tmux rename-window -t $session:$window 'src'
tmux send-keys -t $session:$window 'cd ~/Documents/Doctorado/temporary-skill-impact' Enter
tmux send-keys -t $session:$window  'source venv/bin/activate' Enter 'clear' Enter


window=2
tmux new-window -t $session:$window -n 'ssh'
tmux send-keys -t $session:$window 'ssh -i ~/.ssh/id_mininet mmazzanti@mininet.exp.dc.uba.ar' Enter  'clear' Enter
tmux send-keys -t $session:$window 'tmux'
tmux send-keys -t $session:$window 'cd ~/localia/WF_dataBase/Inglesa' Enter 'clear' Enter
tmux send-keys -t $session:$window  'source venv/bin/activate' Enter 'clear' Enter

window=3
tmux new-window -t $session:$window -n 'nvim'
tmux send-keys -t $session:$window 'cd ~/.config/nvim' Enter 'clear' Enter

tmux attach-session -t $session:1
