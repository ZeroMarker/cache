Class DHCEPRFS.Util.Encryption Extends %RegisteredObject
{

Parameter KEY = "0998C51D28804774948503E97A7555FB";

Parameter IV;

/// desc: 加密
/// debug: w ##class(DHCEPRFS.Util.Encryption).Encrypt("system")
ClassMethod Encrypt(AText As %String) As %String
{
	s text=$SYSTEM.Encryption.AESCBCEncrypt(AText,..#KEY,..#IV)
	s ciphertext=$SYSTEM.Encryption.Base64Encode(text)
	q ciphertext
}

/// desc: 解密
/// debug: w ##class(DHCEPRFS.Util.Encryption).Decrypt("U2HLAzXW+pt0xjhIKSqJ4Q==")
ClassMethod Decrypt(ACiphertext As %String) As %String
{
	s text=$SYSTEM.Encryption.Base64Decode(ACiphertext)
	s text=$SYSTEM.Encryption.AESCBCDecrypt(text,..#KEY,..#IV)
	s plaintext=$ZCONVERT(text,"I","UTF8")
	q plaintext
}

/// Desc: 用当天作为key加密
/// Debug: w ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("1")
ClassMethod EncryptWithDay(Atext As %String) As %String
{
	s key = $SYSTEM.Encryption.Base64Encode($zd($P($H,",",1),3))
	s text=$SYSTEM.Encryption.AESCBCEncrypt(Atext,key,..#IV)
	s ciphertext=$SYSTEM.Encryption.Base64Encode(text)
	q ciphertext
}

/// Desc: 用当天作为key解密
/// Debug: w ##class(DHCEPRFS.Util.Encryption).DecryptWithDay(##class(DHCEPRFS.Util.Encryption).EncryptWithDay("1"))
ClassMethod DecryptWithDay(ACiphertext As %String) As %String
{
	s key = $SYSTEM.Encryption.Base64Encode($zd($P($H,",",1),3))
	s text=$SYSTEM.Encryption.Base64Decode(ACiphertext)
	s text=$SYSTEM.Encryption.AESCBCDecrypt(text,key,..#IV)
	s plaintext=$ZCONVERT(text,"I","UTF8")
	q plaintext
}

}
