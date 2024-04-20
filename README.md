# powershell_encrypt_kensho

## AES256暗号化  
https://www.vwnet.jp/windows/PowerShell/AES.htm  
◆ブロックサイズ  
AES のブロック サイズは **128 ビットに固定**されており、情報を 4 x 4 ブロックに分割します。  

◆モード  
今回は**cbc**「暗号化ブロック チェーン (Cipher Block Chaining)」を使用  
他に以下がある  
・ecb　電子コード ブック (Electronic Code Book)  
・cfb　暗号化フィードバック (Cipher Feedback)  
・ofb　出力フィードバック (Output Feedback)  

https://www.tohoho-web.com/ex/crypt.html#cbc  
https://www.ibm.com/docs/ja/informix-servers/12.10?topic=encryption-ciphers-modes  

◆パディング  
今回は**PKCS#7パディング**を使用  
データがブロックサイズの整数倍に1バイト足りない場合は末尾に 0x01 を、2バイト足りない場合は 0x02 0x02 を、3バイト足りない場合は 0x03 0x03 0x03 を付加します。最後の1バイトがパディングサイズを示します。データがブロックサイズの整数倍の場合は1ブロック余分にパディングが付加されます。AES の場合ブロック長は128ビット(16バイト)なので、パディングサイズは 0x01～0x10 のいずれかとなります。  
他には以下がある  
PKCS#5パディング  
ISO7816-4パディング  
ISO10126-2パディング  
OAEP(Optimal Asymmetric Encryption Padding)  

https://www.tohoho-web.com/ex/crypt.html#pkcs7  

## 実行コマンド
①共通鍵の作成  
PowerShell -ExecutionPolicy RemoteSigned .\Make256Key.ps1 .\share.key

②暗号化  
PowerShell -ExecutionPolicy RemoteSigned .\AESEncrypt.ps1 .\share.key .\plain.txt

③復号  
PowerShell -ExecutionPolicy RemoteSigned .\AESDecrypt.ps1 .\share.key .\EncryptString.txt .\IV.txt
