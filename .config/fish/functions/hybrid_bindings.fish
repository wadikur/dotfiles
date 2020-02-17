function hybrid_bindings --description 'Vi-style that inherits emacs style'
	for mode in insert 
fish_default_key_bindings -M $mode
end
fish_vi_key_bindings --no-erase
end
