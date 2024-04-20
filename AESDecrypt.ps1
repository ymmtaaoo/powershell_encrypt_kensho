##################################################
# AES 復号化
# 　引数1：鍵ファイルファイルパス
# 　引数2：暗号ファイルパス
# 　引数3：IVファイルパス
##################################################
Param($KeyPath, $EncryptStringPath, $IVPath)

$KeySize = 256
$BlockSize = 128
$Mode = "CBC"
$Padding = "PKCS7"

# ファイル内のBase64鍵文字列を取得
$Base64Key = Get-Content $KeyPath
# Base64鍵 をバイト配列にする
$ByteKey = [System.Convert]::FromBase64String($Base64Key)

# ファイル内のBase64暗号文字列を取得
$Base64Encrypt = Get-Content $EncryptStringPath
# 暗号文をバイト配列にする
$ByteEncrypt = [System.Convert]::FromBase64String($Base64Encrypt)

# アセンブリロード
Add-Type -AssemblyName System.Security

# オブジェクトの生成
$AES = New-Object System.Security.Cryptography.AesCryptoServiceProvider

# 各値セット
$AES.KeySize = $KeySize
$AES.BlockSize = $BlockSize
$AES.Mode = $Mode
$AES.Padding = $Padding

# IV セット
$AES.IV = [System.IO.File]::ReadAllBytes($IVPath)

# 鍵セット
$AES.Key = $ByteKey

# 復号化オブジェクト生成
$Decryptor = $AES.CreateDecryptor()

# 復号
$DecryptoByte = $Decryptor.TransformFinalBlock($ByteEncrypt, 0, $ByteEncrypt.Length)

# 平文にする
$PlainString = [System.Text.Encoding]::UTF8.GetString($DecryptoByte)

# オブジェクト削除
$Decryptor.Dispose()
$AES.Dispose()

echo $PlainString
