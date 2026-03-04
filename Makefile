.PHONY: install ansible-install chezmoi-apply

install: ansible-install chezmoi-apply

ansible-install:
	cd ansible && ansible-playbook setup.yml --ask-become-pass

chezmoi-apply:
	chezmoi apply
