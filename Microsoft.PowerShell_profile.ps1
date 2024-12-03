Function lint {
	python -m pylint
}
Set-Alias -Name g  -Value git
Set-Alias -Name pylint  -Value lint
oh-my-posh init pwsh --config 'C:\Users\Yassine\AppData\Local\Programs\oh-my-posh\themes\avit.omp.json' | Invoke-Expression 
#Set-PSReadlineOption -EditMode vi

