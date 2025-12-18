# Installing with Ansible

Just run the command:

```bash
ansible-playbook -i localhost, setup.yml --ask-become-pass
```

- *-i localhost* means run locally in the invetory localhost
- *--ask-become-pass* means that the prompt will ask the root password for user
