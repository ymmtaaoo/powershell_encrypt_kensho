##################################################
# AES �Í���
# �@����1�F���t�@�C���t�@�C���p�X
# �@����2�F�����t�@�C���p�X
##################################################
Param($KeyPath, $PlainStringPath)

# AES �萔
$KeySize = 256
$BlockSize = 128
$Mode = "CBC"
$Padding = "PKCS7"

# �t�@�C������Base64����������擾
$Base64Key = Get-Content $KeyPath
# Base64�� ���o�C�g�z��ɂ���
$ByteKey = [System.Convert]::FromBase64String($Base64Key)
$StringKey =  [System.Text.Encoding]::UTF8.GetString($ByteKey)


# �t�@�C�����̕����p�X���[�h��������擾
$PlainString = Get-Content $PlainStringPath

# �������o�C�g�z��ɂ���
$ByteString = [System.Text.Encoding]::UTF8.GetBytes($PlainString)

# �A�Z���u�����[�h
Add-Type -AssemblyName System.Security

# AES �I�u�W�F�N�g�̐���
$AES = New-Object System.Security.Cryptography.AesCryptoServiceProvider

# �e�l�Z�b�g
$AES.KeySize = $KeySize
$AES.BlockSize = $BlockSize
$AES.Mode = $Mode
$AES.Padding = $Padding

# IV ����
$AES.GenerateIV()
echo $AES.IV
# ��������IV���t�@�C���o��
$IVFilePath = ".\IV.txt"
[System.IO.File]::WriteAllBytes($IVFilePath, $AES.IV)

# ���Z�b�g
$AES.Key = $ByteKey

# �Í����I�u�W�F�N�g����
$Encryptor = $AES.CreateEncryptor()

# �Í���
$EncryptByte = $Encryptor.TransformFinalBlock($ByteString, 0, $ByteString.Length)

# �Í�������������
$EncryptString = [System.Convert]::ToBase64String($EncryptByte)

# �I�u�W�F�N�g�폜
$Encryptor.Dispose()
$AES.Dispose()

# �Í��������������t�@�C���o��
$EncryptFilePath = ".\EncryptString.txt"
Set-Content -Path $EncryptFilePath -Value $EncryptString -Encoding UTF8
