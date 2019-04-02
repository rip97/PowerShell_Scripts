#Programmer: rip97  
#Purpose: A basic script that will create a user shared drive that they will only have access too and will remove all inheritance to that folder
#         Feel free to modify, it's written too how my organization sets up share drives for specfic for only that user and a Domain Admin  
#
#
#Note: Run this script as an administrator 
#

$doAnother = 'Y' 
Do{ 
    Write-Host "" # space for clarity 

    $foldername = Read-Host -Prompt "Please Enter the name of the folder " # ask for name of folder 
    

    #set location to create folder
    
    Set-Location '\\fileserver_where_share_folders_reside'
    New-Item $foldername -ItemType directory 
    $username = Read-Host -Prompt "Please enter the user name of the folder in the format of 'domain\username' "

    #create path of the folder 
    $location = '\\fileserver_where_share_folders_reside\' + $foldername #adds the folder to the path
    $folder = $location #not nesscary, can remove if you want 
    Write-Host $folder 
    
    #set access control for the folder with NTFS permissions
    
    $acl = Get-Acl -Path $folder
    Get-Acl $folder | fl
    $username1 = 'domain\username'
    $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule($username,'FullControl','ContainerInherit,ObjectInherit','None','Allow') 
    $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule($username1,'FullControl','ContainerInherit,ObjectInherit','None','Allow')
    $acl.SetAccessRule($rule1) 
    $acl.SetAccessRule($rule2) 
    Set-Acl -Path $folder -AclObject $acl
    $acl.SetAccessRuleProtection($true, $false) 
    Set-Acl -Path $folder -AclObject $acl 
    
    #show permission changes on the folder
    Write-Host "" # space for clarity 
    Write-Host "==================== Folder Permissions ===================="
    Get-Acl $folder | fl

    # ask user if they want to create another user folder 
    $doAnother = Read-Host -Prompt "Would you like to create another folder? (y/n) >>>"
    $doAnother.ToUpper() 
}Until ($doAnother -eq "N") 

cd C:\ 





