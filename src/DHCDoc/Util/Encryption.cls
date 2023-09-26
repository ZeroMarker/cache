/// Creator：李旭  
/// CreatDate：2023-02-08
/// Description：加解密相关方法(迁移DHCDoc.Util.System)
Class DHCDoc.Util.Encryption Extends %RegisteredObject
{

/// Desc: 创建UUID(是一个16字节(128位)的全局唯一标识符)
/// w ##class(DHCDoc.Util.System).CreateUUID()
ClassMethod CreateUUID()
{
 	q $System.Util.CreateGUID()
}

/// Desc: 生成8位或10位的随机数
/// Input: Digit8:(Y/N):默认8位数，否则10位数
/// w ##class(DHCDoc.Util.System).GenCryptToken()
ClassMethod GenCryptToken(Digit8 = "Y")
{
	i Digit8="Y"{
		;产生8位数
		s CryptToken=##class(%SYSTEM.Encryption).GenCryptToken()
	}else{
		s CryptToken=$translate($j($ZLASCII($system.Encryption.GenCryptRand(4))#9999999999,10)," ","0")
	}
	q CryptToken
}

/// Desc：解密CSP加密的方法密文
/// Input: CipherText：加密后的密文
/// Debug：w ##class(DHCDoc.Util.System).MethodDecrypt("IqgCJBlVJt5CnGbqT2x53vyQ5aWVumvnG3iZLuBfrz225wUBRWP1CqipIrr6im3v")
ClassMethod MethodDecrypt(CipherText) As %String
{
	s PlainText=""
	i $d(^oddCOM("websys.Page","m","Decrypt")) {
		s PlainText=##Class(websys.Page).Decrypt(CipherText)
	}else{
		s PlainText=##Class(%CSP.Page).Decrypt(CipherText)
	}
	q $lg(PlainText)
}

/// Desc: base64加密
/// w ##class(DHCDoc.Util.System).Base64Encode("123你好")
ClassMethod Base64Encode(str As %String)
{
	s str=$zcvt(str, "O", "UTF8")
	s ret=$SYSTEM.Encryption.Base64Encode(str)
	q ret
}

/// Desc: base64解密
/// w ##class(DHCDoc.Util.System).Base64Decode("MTIz5L2g5aW9")
ClassMethod Base64Decode(str As %String)
{
	s ret=$SYSTEM.Encryption.Base64Decode(str)
	s ret=$zcvt(ret, "I", "UTF8")
	q ret
}

/// Desc: AES加密(CBC加密模式:需要偏移量、ECB加密模式:不需偏移量)
/// Input: plaintext:待加密明文、key:密钥、vector:偏移量(16位)
/// w ##class(DHCDoc.Util.System).AESCBCEncrypt("1233333","zmd_scan_pay_+++","8898157463587_ppp3mdj")
ClassMethod AESCBCEncrypt(plaintext As %String, key As %String = "", vector As %String = "")
{
	s:(vector'="") vector=$e(vector,1,16)
	s plaintext=$zcvt(plaintext,"O","UTF8")
	s text=$SYSTEM.Encryption.AESCBCEncrypt(plaintext,key,vector)
	s ciphertext=$SYSTEM.Encryption.Base64Encode(text)
	Q ciphertext
}

/// Desc: AES解密(CBC加密模式、密钥"zmd_scan_pay_+++"、偏移量"8898157463587_ppp3mdj")
/// Input: cipherText:待解密密文、key:密钥、vector:偏移量(16位)
/// w ##class(DHCDoc.Util.System).AESCBCDecrypt("3aKkzuoNMNjcw0Pd8bX8dg==","zmd_scan_pay_+++","8898157463587_ppp3mdj")
ClassMethod AESCBCDecrypt(cipherText As %String, key As %String = "", vector As %String = "")
{
	s:(vector'="") vector=$e(vector,1,16)
	s cipherText=$SYSTEM.Encryption.Base64Decode(cipherText)
	s plainText=$SYSTEM.Encryption.AESCBCDecrypt(cipherText,key,vector)
	s plainText=$zcvt(plainText,"I","UTF8")
	Q plainText
}

/// Desc: RSA加密(m中RSA加密，目前只支持证书加密(在线生成证书：https://www.gmcert.org/subForm#))
/// Input: plaintext:待加密明文、path:公钥证书路径、Encoding:编码方式
/// w ##class(DHCDoc.Util.System).RSAEncrypt("1233333","D:\Dthealth\app\dthis\web\key\rsa.cert.pem")
ClassMethod RSAEncrypt(plaintext As %String, path As %String, Encoding = "2")
{
	Set plaintext=$ZCONVERT(plaintext,"O","UTF8")
	Set filestream=##class(%FileCharacterStream).%New()
	Set filestream.Filename=path
	Set PublicKeyStr=filestream.Read(.len)

	set Encoding=$case(Encoding,2:2,:1)
	if $l($g(^oddCOM("%SYSTEM.Encryption","m","RSAEncrypt",50)),",")=5{  
		//2016 
        set Encoding=$s(Encoding=2:2,1:1)
        Set cipherText=##class(%SYSTEM.Encryption).RSAEncrypt(plaintext,PublicKeyStr,"","",Encoding)
    }else {  
    	//2010
        Set cipherText=##class(%SYSTEM.Encryption).RSAEncrypt(plaintext,PublicKeyStr,"","")
    }
	Set cipherText=##class(%SYSTEM.Encryption).Base64Encode(cipherText)
	Set ^templx("cipherText")=cipherText
	Quit cipherText
}

/// Desc: RSA解密
/// Input: cipherText:Base64密文、privatePath:私钥路径、Encoding:填充模式(1/2) 1 OAEP 2 RSA_PKCS1_PADDING、Password:签名密码
/// w ##class(DHCDoc.Util.System).RSADecrypt(^templx("cipherText"),"D:\Dthealth\app\dthis\web\key\rsa.key.pem")
ClassMethod RSADecrypt(cipherText As %String, privatePath As %String, Encoding = "2", Password = "")
{
	;s cipherText=$tr(cipherText,$c(10,13),"")
	Set cipherText=##class(%SYSTEM.Encryption).Base64Decode(cipherText)
	Set filestream=##class(%FileCharacterStream).%New()
	Set filestream.Filename=privatePath
	Set PrivateKeyStr=filestream.Read(.len)

	if $l($g(^oddCOM("%SYSTEM.Encryption","m","RSAEncrypt",50)),",")=5{  
		//2016 
        set Encoding=$case(Encoding,2:2,:1)
        Set plainText=##class(%SYSTEM.Encryption).RSADecrypt(cipherText,PrivateKeyStr,Password,Encoding)
    }else {  
    	//2010
        Set plainText=##class(%SYSTEM.Encryption).RSADecrypt(cipherText,PrivateKeyStr)
    }
    s plainText=$zcvt(plainText,"I","UTF8")
    Q plainText
}

/// Desc: MD5消息摘要算法生成16字节的哈希(HexMd5加密)。 
/// input: str:要加密的字符串、capital:U大写,L小写(默认大写)
/// output：包含哈希值的字符串，每个字符一个字节。
/// w ##class(DHCDoc.Util.System).MD5Encryption("123")
ClassMethod MD5Encryption(str As %String, capital As %String = "U")
{
	/* 字符串有汉字需要转换UTF-8 */
	s ret = $zcvt(str, "O", "UTF8")
	s ret = ##class(%SYSTEM.Encryption).MD5Hash(ret)
	s ret = ..Byte2Hex(ret)
	s ret = $zconvert(ret, capital)
	
	quit ret
}

/// Desc: Base64Md5加密
/// input: str:要加密的字符串、capital:U大写,L小写(默认大写)
/// w ##class(DHCDoc.Util.System).Base64Md5Encryption("123")
ClassMethod Base64Md5Encryption(str As %String, capital As %String = "U")
{
	/* 字符串有汉字需要转换UTF-8 */
	s ret = $zcvt(str, "O", "UTF8")
	s ret = ##class(%SYSTEM.Encryption).MD5Hash(ret)
	s ret = ##class(%SYSTEM.Encryption).Base64Encode(ret)
	s ret = $zconvert(ret, capital)
	q ret
}

/// Desc: HexHmacMd5加密
/// input: str:要加密的字符串、capital:U大写,L小写(默认大写)、key:密码
/// w ##class(DHCDoc.Util.System).HexHmacMd5Encryption("123",,"lixu")
ClassMethod HexHmacMd5Encryption(str As %String, capital As %String = "U", key)
{
	/* 字符串有汉字需要转换UTF-8 */
	s ret = $zcvt(str, "O", "UTF8")
	s ret = ##class(%SYSTEM.Encryption).HMACMD5(ret,key)
	s ret = ..Byte2Hex(ret)
	s ret = $zconvert(ret, capital)
	q ret
}

/// Desc: Base64HmacMd5加密
/// input: str:要加密的字符串、capital:U大写,L小写(默认大写)、key:密码
/// w ##class(DHCDoc.Util.System).Base64HmacMd5Encryption("123",,"lixu")
ClassMethod Base64HmacMd5Encryption(str As %String, capital As %String = "U", key)
{
	/* 字符串有汉字需要转换UTF-8 */
	s ret = $zcvt(str, "O", "UTF8")
	s ret = ##class(%SYSTEM.Encryption).HMACMD5(ret,key)
	s ret = ##class(%SYSTEM.Encryption).Base64Encode(ret)
	s ret = $zconvert(ret, capital)
	q ret
}

/// Desc: 将字符串转成16进制字符
/// w ##class(DHCDoc.Util.System).Byte2Hex(123)
ClassMethod Byte2Hex(str)
{
	set ret = ""
	for i = 1 : 1 : $length(str) {
		set ascii = $ascii($extract(str, i)) 
		if (ascii < 16) {
			/* 16进制转10进制需要补0 */
			set ret = ret _ "0" _ $zhex(ascii)
		} else {
			set ret = ret _ $zhex(ascii)
		}
	}
	quit ret
}

/// Desc: HMACSHA消息摘要算法加密。 
/// input: str:要加密的字符串、key:密码
/// w ##class(DHCDoc.Util.System).HMACSHA("123","default")
ClassMethod HMACSHA(str As %String, key As %String)
{
	/* 字符串有汉字需要转换UTF-8 */
	s ret = $zcvt(str, "O", "UTF8")
	s ret = ##class(%SYSTEM.Encryption).HMACSHA(256,str,key)
	s ret = ..Byte2Hex(ret)
	quit ret
}

/******************************* 以下国密算法为基础平台提供 cache版本需基础平台先部署 *********************************/
/// Desc: SM2加密
/// input: SrcStr:要加密的字符串、PubKey:公钥
/// s PubKey = "04AFDF1597EBE5B39B2458DE2273B7D426988FB7A9D88E098309C0DAF2D64FFB1DA1309DB5D78432BCA194AFC3855F4AEA22B168BBCDF7C85B7AAD61DFDFBF2282"
/// w ##class(DHCDoc.Util.System).SM2Encode("123",PubKey)
ClassMethod SM2Encode(SrcStr, PubKey)
{
	Q ##class(web.Util.Encryption).SM2Encode(SrcStr, PubKey)
}

/// Desc: SM2解密
/// input: EncStr:要解密的字符串、PriKey:私钥
/// s PriKey = "5817C323735FBB8DFB698B0BFC3D060132769C9C21FFD000A1CCA5B60DE54D06"
/// w ##class(DHCDoc.Util.System).SM2Decode(EncStr,PriKey)
ClassMethod SM2Decode(EncStr, PriKey)
{
	Q ##class(web.Util.Encryption).SM2Decode(EncStr, PriKey)
}

/// Desc: HmacSM3签名
/// Input: SrcStr:原消息字符串、Key:密钥、OutType:HEX|BASE64:转出成HEX或BASE64 默认HEX
/// w ##class(DHCDoc.Util.System).HmacSM3()
ClassMethod HmacSM3(SrcStr, Key, OutType = "HEX")
{
	Q ##class(web.Util.Encryption).HmacSM3(SrcStr, Key, OutType)
}

/// Desc: SM3签名
/// Input: SrcStr:原消息字符串、OutType:HEX|BASE64:转出成HEX或BASE64 默认HEX
/// w ##class(DHCDoc.Util.System).SM3Encode()
ClassMethod SM3Encode(SrcStr, OutType = "HEX")
{
	Q ##class(web.Util.Encryption).SM3Encode(SrcStr, OutType)
}

/// Desc: SM4加密
/// Input: SrcStr:原消息字符串、Key:密钥、OutType:HEX|BASE64:转出成HEX或BASE64 默认BASE64
/// w ##class(DHCDoc.Util.System).SM4Encode()
ClassMethod SM4Encode(SrcStr, Key, OutType = "BASE64")
{
	Q ##class(web.Util.Encryption).SM4Encode(SrcStr, Key, OutType)
	;默认先调用基础平台的方法,便于后期统一维护
	Q ##class(DHCDoc.Util.SM4).Encrypt(Key, SrcStr, OutType)
}

/// Desc: SM4解密
/// input: EncStr:要解密的字符串、Key:密钥、OutType:HEX|BASE64:转出成HEX或BASE64 默认BASE64
/// w ##class(DHCDoc.Util.System).SM4Decode()
ClassMethod SM4Decode(EncStr, Key, OutType = "BASE64")
{
	Q ##class(web.Util.Encryption).SM4Decode(EncStr, Key, OutType)
	;默认先调用基础平台的方法,便于后期统一维护
	Q ##class(DHCDoc.Util.SM4).Decrypt(Key, EncStr, OutType)
}

}
