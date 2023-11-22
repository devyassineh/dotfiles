# commands
CP = cp
RM = rm
MKDIR = mkdir

# config folders
SHELL := /bin/bash
GITCONFIG = $(HOME)
TERMCONFIG = $(HOME)/.config/alacritty
NVIMCONFIG = $(HOME)/.config/nvim
SHELLCONFIG = $(HOME)/.bashrc
REMOTESHELLCONFIG = .bashrc
UPDATESHELL = @source .bashrc

# windows specific settings
ifeq ($(OS),Windows_NT)
	SHELL := powershell.exe
	.SHELLFLAGS := -Command
	TERMCONFIG := $(HOME)/AppData/Roaming/alacritty
	SHELLCONFIG := $(HOME)/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
	REMOTESHELLCONFIG := Microsoft.PowerShell_profile.ps1
	NVIMCONFIG := $(HOME)/AppData/Local/nvim
        UPDATESHELL := $(SHELL) . $$profile
endif

all: $(TERMCONFIG)/alacritty.yml $(GITCONFIG)/.gitconfig $(NVIMCONFIG)/init.lua $(SHELLCONFIG)

$(TERMCONFIG)/alacritty.yml: alacritty.yml | $(TERMCONFIG)
	$(CP) ./alacritty.yml $(TERMCONFIG)

$(TERMCONFIG):
	mkdir -p $(TERMCONFIG)

$(GITCONFIG)/.gitconfig: ./.gitconfig
	$(CP) ./.gitconfig $(GITCONFIG)/.gitconfig

$(NVIMCONFIG)/init.lua: init.lua | $(NVIMCONFIG)
	$(CP)  ./init.lua $(NVIMCONFIG)/init.lua

$(NVIMCONFIG):
	$(MKDIR) -p $(NVIMCONFIG)

$(SHELLCONFIG): $(REMOTESHELLCONFIG)
	$(RM) $(SHELLCONFIG)
	$(CP) $(REMOTESHELLCONFIG) $(SHELLCONFIG)
	$(UPDATESHELL)

update:
	rm  ./init.lua 
	cp $(NVIMCONFIG)/init.lua ./init.lua
	
	install $(SHELLCONFIG) ./.bashrc

clean:
	$(RM) $(GITCONFIG)
	$(RM) $(NVIMCONFIG)
	$(RM) $(TERMCONFIG)
	$(RM) $(SHELLCONFIG)

