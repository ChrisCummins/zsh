DEST=~/.zshrc
BACKUP=$(PWD)/old-zshrc

install:
# Backup old config file
ifneq ($(wildcard $(DEST)),)
	mv $(DEST) $(BACKUP)
endif
	ln -s $(PWD)/zshrc $(DEST)

uninstall:
	rm $(DEST)
# Restore old config file
ifneq ($(wildcard $(BACKUP)),)
	mv $(BACKUP) $(DEST)
endif

help:
	@echo 'make (install|uninstall)'
