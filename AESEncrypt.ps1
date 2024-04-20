##################################################
# AES 暗号化
# 　引数1：鍵ファイルファイルパス
# 　引数2：平文ファイルパス
##################################################
Param($KeyPath, $PlainStringPath)

# AES 定数
$KeySize = 256
$BlockSize = 128
$Mode = "CBC"
$Padding = "PKCS7"

# ファイル内のBase64鍵文字列を取得
$Base64Key = Get-Content $KeyPath
# Base64鍵 をバイト配列にする
$ByteKey = [System.Convert]::FromBase64String($Base64Key)
$StringKey =  [System.Text.Encoding]::UTF8.GetString($ByteKey)


# ファイル内の平文パスワード文字列を取得
$PlainString = Get-Content $PlainStringPath

# 平文をバイト配列にする
$ByteString = [System.Text.Encoding]::UTF8.GetBytes($PlainString)

# アセンブリロード
Add-Type -AssemblyName System.Security

# AES オブジェクトの生成
$AES = New-Object System.Security.Cryptography.AesCryptoServiceProvider

# 各値セット
$AES.KeySize = $KeySize
$AES.BlockSize = $BlockSize
$AES.Mode = $Mode
$AES.Padding = $Padding

# IV 生成
$AES.GenerateIV()
echo $AES.IV
# 生成したIVをファイル出力
$IVFilePath = ".\IV.txt"
[System.IO.File]::WriteAllBytes($IVFilePath, $AES.IV)

# 鍵セット
$AES.Key = $ByteKey

# 暗号化オブジェクト生成
$Encryptor = $AES.CreateEncryptor()

# 暗号化
$EncryptByte = $Encryptor.TransformFinalBlock($ByteString, 0, $ByteString.Length)

# 暗号化した文字列
$EncryptString = [System.Convert]::ToBase64String($EncryptByte)

# オブジェクト削除
$Encryptor.Dispose()
$AES.Dispose()

# 暗号化した平文をファイル出力
$EncryptFilePath = ".\EncryptString.txt"
Set-Content -Path $EncryptFilePath -Value $EncryptString -Encoding UTF8
