set positional-arguments
set dotenv-load

alias cc := create-component
alias cr := create-replicated-component
alias em := extract-models

create-component *args='':
	lune create-component $@

create-replicated-component name *args='':
	lune create-component {{name}} 'replicated' $@

