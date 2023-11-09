# commands
CP = cp
RM = rm
MKDIR = mkdir

# config folders
GITCONFIG = $(HOME)
TERMCONFIG = $(HOME)/.config/alacritty
NVIMCONFIG = $(HOME)/.config/nvim

# windows specific settings
ifeq ($(OS),Windows_NT)
	SHELL := powershell.exe
	.SHELLFLAGS := -Command
	TERMCONFIG := $(HOME)/AppData/Roaming/alacritty
	PWSHCONFIG := $(HOME)/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
	NVIMCONFIG := $(HOME)/AppData/Local/nvim
endif

all: $(TERMCONFIG)/alacritty.yml $(GITCONFIG)/.gitconfig $(NVIMCONFIG)/init.lua

$(TERMCONFIG)/alacritty.yml: alacritty.yml | $(TERMCONFIG)
#	$(RM) $(TERMCONFIG)/alacritty.yml
	$(CP) ./alacritty.yml $(TERMCONFIG)

$(TERMCONFIG):
	mkdir -p $(TERMCONFIG)

$(GITCONFIG)/.gitconfig: ./.gitconfig
	$(CP) ./.gitconfig $(GITCONFIG)/.gitconfig

$(NVIMCONFIG)/init.lua: init.lua | $(NVIMCONFIG)
	$(CP)  ./init.lua $(NVIMCONFIG)/init.lua

$(NVIMCONFIG):
	$(MKDIR) -p $(NVIMCONFIG)

update:
	rm  ./init.lua 
	cp $(NVIMCONFIG)/init.lua ./init.lua

clean:
	$(RM) $(GITCONFIG)
	$(RM) $(NVIMCONFIG)
	$(RM) $(TERMCONFIG)


windows:
	$(RM) $(PWSHCONFIG)
	$(CP) ./Microsoft.PowerShell_profile.ps1 $(PWSHCONFIG)
	. $$profile
