$department_like = Read-Host -Prompt "Department like (^ = start by. Ex: ^IT doesn't return ...it.) "


Write-Host "`nChargement de tous les utilisateurs...`nCette operation peut durer plusieurs minutes...`n" -ForegroundColor "yellow"

# Afficher les résultats de "department_like"




$test = @()
$test = {$test}.Invoke()

$ADUsers = Get-ADUSer -Filter * -Properties * # On stocke les utilisateurs dans la variable ADUsers

$chargement = 1
$TotalUsers = $ADUSers.count




# Lister les utilisateurs du département
foreach ($user in $ADUsers) {

    Write-Progress -Activity "Recherche des utilisateurs" -status "Checked : $chargement / $TotalUsers users." -PercentComplete ($chargement / $TotalUsers * 100)

    if ($user.department -match $department_like){ # Pour chaque utilisateur, si le département est = au résultat de "department_like"
        $SamAccountName = $user.samaccountname
        $department = $user.department
        $username = $user.name
        Write-Host "$username ----------------- $department" # On affiche les utilisateur et le nom de leur département afin de vérifier les informations qui vont êtres changées
        $test += $SamAccountName # On ajoute le SamAccountName des utilisateurs à l'objet "test"
    }
    $chargement ++
}

$chargement = 0 # On rétabli le compteur pour la prochaine barre de chargement

$compteur = $test.count # Retourne le nombre d'utilisateurs à affecter
$sure = Read-Host -Prompt "`nVoulez-vous remplacer les departements pour $compteur utilisateurs`n[Y/n] "


# Si l'utilisateur confirme l'opération,
if ($sure -ieq "y"){

    $nouveauDep = Read-Host -Prompt "`nEntrez le nom du nouveau departement "

    foreach ($sam in $test) {
        Write-Progress -Activity "Changement des departements" -status "Chaned : $chargement / $compteur" -PercentComplete ($chargement / $compteur * 100)

        
        Set-ADUser -Identity $sam -Department "$nouveauDep"

        $chargement ++
    }
}else{Write-Host "Aborting !" -ForegroundColor "red"}
