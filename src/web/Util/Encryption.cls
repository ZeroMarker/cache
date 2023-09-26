/// 名称: 		icare.Encryption
/// 描述: 		加密解密方法(RSA)
/// 编写者：	周志强
/// 编写日期:	2013-08-29
Class web.Util.Encryption Extends %RegisteredObject [ LegacyInstanceContext ]
{

/// Creator：     周志强
/// CreatDate：   2013-08-29
/// Description:  RSA解密
/// Input：       Ciphertext : Base64编码的密文
///               PrivateKeyFile   ：私钥文件(PEM)的路径
/// Return：      解密的明文
/// w ##class(web.Util.Encryption).RSADecrypt("oXw0zHQO8hlRCB0Yy9kZUOC2ap21Cy2U869JtvO/WFRK9kFfpM+sXW6ndkME31VL1KEkgAO9u2jKVpDot/jLdSYla0ddKmKcti7XmUEm2aQqcMI7pfDeHHoWbKwBxV91Y773nFAvW3tJ4z87IXd3hq45mumwURoXVIBWZxZ0jew=","E:\DtHealth\app\dthis\web\key\HIS_Privatekey.pem")
/// w ##class(web.Util.Encryption).RSADecrypt("ST+z3wvCLFKmSQOiIrN5h1UHddqzhTypHOP5F55pJnUWYDQZYaIhDEHzaIRgbAhxieE/E0t3FzlloaRD77fFSQuw5axzgX1UfSb8qhXLs6DRKGTuibhuAZ9JXOmQdRCCGCuIXrJWW78l3ixXNbR3Qay4OgabOO74hKJ0l61e/S8=","E:\DtHealth\app\dthis\web\key\HIS_Privatekey.pem")
/// w ##class(web.Util.Encryption).RSADecrypt("TrVmWQI1/nEhl3RGPd1sSUyeCaUmIdRsaQXNahGeNQAT3n2sNAKrD/NIoSKg0gfvfUgJHmmpBeNP536Rggou3ZsC99Age3BMHX/xUcBePB87NSUfwqZ7lgnN+aFagUr1LxcPgQ+LAoKYlM8egaze1eclD2EGBIFVKfKI8Ag0ZIE=","E:\DtHealth\app\dthis\web\key\HIS_Privatekey.pem")
/// Other ：      w ##class(web.Util.Encryption).RSADecrypt("JxdfsVT7kBCApTTZTqU5tWyneMSJNxkXbKY9lwyIqeUzJOWeJGShJNk/Rr4Mhpnml6ahmamcoGHRlvQGsPA4oplDTLXj2F9Pfd1FTzqCYPfX/19IOp7n4t3Ri95/PabPVZ81lBG7xtMWWtyZ9cJXy53GMr6lMYtoHRn+PEa8+CQ=","E:\DtHealth\app\dthis\web\key\LIC_Publickey.pem")
/// w ##class(web.Util.Encryption).RSADecrypt("rqSudEWXDytZ1E1dd/gXsWirGfzangTJw8EgeEUFZyCm2IokxSUi4fdgFVE+XV+bMF+ENejBFL+ysvXKBoJz8bCFSNNKsGnCVwyg+pP510XbFH1HHW2NgLlAcXiz2bdVVT+e7gBnF7wEFLjW5qn8IxXveCMCHE9P0wV7wG4TwOk=","E:\DtHealth\app\dthis\web\key\lic\bizKey\LIS_LIC_PublickKey.pem")
ClassMethod RSADecrypt(Ciphertext As %String, PrivateKeyFile As %String) As %String
{
}

/// 
/// 用openssl生成的证书加密原文,Cache只支持证书加密
/// 
/// Creator：     周志强
/// CreatDate：   2013-08-29
/// Description:  RSA加密
/// Input：       Plaintext : 明文
///               PublicKeyFile : 包含公钥的证书(PEM)的路径
/// Return：      解密的明文
/// Other ：      w ##class(web.Util.Encryption).RSAEncrypt("1","E:\DtHealth\app\dthis\web\key\LIC_Public.csr")
/// Cache加密码不支持pem w ##class(web.Util.Encryption).RSAEncrypt("1","XXXX\OA_PublicKey.pem")
/// 
ClassMethod RSAEncrypt(Plaintext As %String, PublicKeyFile As %String) As %String
{
}

/// Creator: 汪会财
/// Creator: 2014-10-11
/// Description: 把val进行md5加密并返回结果
/// Input : val 字符串/流对象
/// Return: 加密后结果
/// Other: w ##class(web.Util.Encryption).MD5HexStr(1)
ClassMethod MD5HexStr(val, CharSet = "")
{
}

/// Creator: 汪会财
/// Creator: 2014-10-11
/// Description: 将字节转成16进制字符
/// Input : val 字节
/// Return: 16进制字符
/// Other: zzdump websys.Conversions.BinHexS
/// w ##class(web.Util.Encryption).Byte2Hex("1检查报告")
ClassMethod Byte2Hex(val)
{
}

/// Creator: 汪会财
/// Creator: 2014-10-11
/// Description: 将16进制字符 转成 字节
/// Input : hex 16进制字符
/// Return: 字节
/// Other: 用于加密转换
/// w ##class(web.Util.Encryption).Hex2Byte("68C067E562A5544A")
ClassMethod Hex2Byte(hex)
{
}

/// 一位一转 
ClassMethod Hex1ToByte(hex)
{
}

/// 字节转成10进制字符 2019-10-17 wanghc
ClassMethod Byte2Dec(val)
{
}

/// 10进制转字节 2019-10-17 wanghc
ClassMethod Dec2Byte(dec)
{
}

/// 未调通
ClassMethod hexString2Bytes(hexstr)
{
}

/// Creator: 汪会财
/// Creator: 2014-10-11
/// Description: 将32进制字符 转成 字节
/// Input : hex 32进制字符
/// Return: 字节
/// Other: 用于加密转换
/// 有汉字得用此方法
/// w ##class(web.Util.Encryption).Hex2Byte32("3168C067E562A5544A")
ClassMethod Hex2Byte32(hex)
{
}

/// Creator: 汪会财
/// Creator: 2015-04-03
/// Input : Str  
/// Return: $zbitstr
/// Description: 将字符串 转成 $zbitstr
/// Other:  String->bit
ClassMethod ToBit(Str)
{
}

/// Creator: 汪会财
/// Creator: 2015-04-03
/// Input : Src 要加密的串
/// Input : Key 密钥(任选,解密时也用相同的Key才能解开) .默认为 IMedical
/// Return: 加密后的字符串
/// Description: 加密字符串
/// 不能字母与汉字混用
/// w ##Class(web.Util.Encryption).SimpleEncrypt("abc东","Key")
ClassMethod SimpleEncrypt(Src, Key = "IMedical")
{
}

/// Creator: 汪会财
/// Creator: 2015-04-03
/// Input : EncSrc 要解密的串
/// Input : Key    密钥(加密时的Key) .默认为 IMedical
/// Return: 解密后的字符串
/// Description: 解密字符串
/// w ##Class(web.Util.Encryption).SimpleDecrypt("AFDDE5AEE8F7A3D8D6AFDECFAEE9C2ACF3EEAFDFF2AFDDE3A2E6D1","Key")
ClassMethod SimpleDecrypt(EncStr, Key = "IMedical")
{
}

/// 
/// @Author     : wanghc  
/// @CreateDate : 2015-12-29
/// @Input      : Str    String
/// @Return     : EncStr 加密码后字符串
/// 	@Description: 福建健康档案接口加密算法,内蒙古区域的双向转诊接口
///   1. ASCII不满3位,补0
///   2. 奇偶位数字交换
ClassMethod HealthDocEncrypt(Str)
{
}

/// Creator: wanghc
/// Creator: 2016-10-13
/// Input : Src 原始字符串/流对象
/// Input : CharSet 编码 .默认为 UTF8
/// Return: BASE64后的字符串/流对象
/// Other: 20200102 入参为流时,返回值也为流
/// w ##class(web.Util.Encryption).Base64Encode("上网ABCD")   => 5LiK572RQUJDRA==
/// w ##class(web.Util.Encryption).Base64Encode("上网ABCD","UTF8")
/// w ##class(web.Util.Encryption).Base64Encode("上网ABCD","GB18030")
ClassMethod Base64Encode(Src, CharSet = "UTF8")
{
}

/// Creator: wanghc
/// Creator: 2016-10-13
/// Input : Base64Str 要解密的Base64的串/流对象
/// Input : CharSet 编码 .默认为 UTF8
/// Return: 原始串/流对象
/// w ##class(web.Util.Encryption).Base64Decode("5LiK572RQUJDRA==")
/// w ##class(web.Util.Encryption).Base64Decode("5LiK572RQUJDRA==","UTF8")
/// w ##class(web.Util.Encryption).Base64Decode("yc/N+EFCQ0Q=","GB18030")
ClassMethod Base64Decode(Base64Str, CharSet = "UTF8")
{
}

/// w ##class(web.Util.Encryption).RSAE("5D563B76532435FF3F7615161C3A1AE43248075E863F18F5FEBCA142903A0D84486957794BEB487008F0563381D484D92496751B2A28AB3C1208D1C3DCC2732E2450AD794E58349F6A27BA3EDC014823386D400C7DB99F9FF1DEBB844DBFDC1E9B9AB74280351D96C738359B169A529866394479006A9C5416823BFE522D5455","E:\DtHealth\app\dthis\web\key\OA_Privatekey.pem")
/// w ##class(web.Util.Encryption).RSAE(EncStr,"E:\DtHealth\app\dthis\web\key\OA_Privatekey.pem")
/// w ##class(web.Util.Encryption).RSAE(EncStr,"E:\DtHealth\app\dthis\web\key\LIC_Publickey.pem")
ClassMethod HexRSADecrypt(Ciphertext, PrivateKeyFile As %String)
{
}

ClassMethod PKCS5Padding(PlainText)
{
}

ClassMethod PKCS7Padding(PlainText)
{
}

/// 安徽华泽中西医的体检健康小管家接口对接要使用到Zero补位 3140906 
/// 字节不满blockSize补$char(0)
/// @date 2022-12-12
/// @author wanghc
ClassMethod ZeroPadding(PlainText)
{
}

/// 反转
ClassMethod PKCS7PaddingDe(PlainText)
{
}

/// w ##class(web.Util.Encryption).AES("",sha256,7)
ClassMethod AESEnc(PlainText, Key, Padding)
{
}

ClassMethod AESDec(EncData, Key, Padding)
{
}

ClassMethod AESEncode7PaddingToBase64(pwd = "", crypt = "")
{
}

/// @Param {String} src  需加密串
/// @Param {String} crypt 密钥
/// @Param {String} Type Base64 | HEX 转成Base64还是16进制字符
ClassMethod AESEncode7Padding(src = "", crypt = "", Type = "Base64")
{
}

/// InOutType String  默认"ORIGIN/BASE64/UTF8" "key值类型ORIGIN|HEX|BASE64 / 返回值类型HEX|BASE64 / 原文编码UTF8"
ClassMethod AESECBPKCS7Encode(Src = "", Key = "", InOutType = "ORIGIN/BASE64/UTF8")
{
}

/// InOutType String  默认"ORIGIN/BASE64/UTF8" /的第一位为：key值类型ORIGIN|HEX|BASE64， 第二位：返回值类型HEX|BASE64， 第三位：原文编码UTF8
ClassMethod AESECBPKCS7Decode(EncStr = "", Key = "", InOutType = "ORIGIN/BASE64/UTF8")
{
}

/// 山东省慢病上报时需要加密码  Wanghc  2020-06-18
/// @param Plaintext 需加密数据
/// @param Key        密钥
/// @param IV        偏移量
/// @param Type   返回值类型 /HEX/GB18030 | HEX/HEX/ | HEX/Base64/
/// 入参类型/返回值类型/编码
/// HEX/HEX表示 密钥是HEX，返回值是HEX
/// /HEX表示    密钥是真实字符，返回值是HEX
/// Key与Java中随机数不一样，是Java中的摘要KEY值
/// Set Key = $c(4,44,249,203,197,10,103,206,155,211,95,121,200,76,174,22)
/// w ##class(web.Util.Encryption).AESCBCEncode5Padding(text,"33997828769E6C7F513A2D85FAEF238B","jssjbyfkzzxsyjcs")
/// w ##class(web.Util.Encryption).AESCBCEncode5Padding("1abc东华","042CF9CBC50A67CE9BD35F79C84CAE16","jssjbyfkzzxsyjcs")
/// 
/// w ##class(web.Util.Encryption).AESCBCEncode5Padding("012345东华软件","7451321547ec4fb5b8baf03329d90158","010002700625408a","ORIGIN/HEX/UTF8")
ClassMethod AESCBCEncode5Padding(Plaintext, Key, IV, InOutType = "HEX/HEX/GB18030")
{
}

/// 上海市健康云核酸检测解密
/// ORIGIN/HEX/GB18030 表示Key是原始Key,EncStr是HEX,最终转出GB18030
/// w ##class(web.Util.Encryption).AESCBCDecode5Padding("083CE8146F5CED43782F36091FB654F8C42E72A1D26BE4DA1E23561F9AE84583","7451321547ec4fb5b8baf03329d90158","010002700625408a","ORIGIN/HEX/UTF8")
ClassMethod AESCBCDecode5Padding(EncStr, Key, IV, InOutType = "HEX/HEX/GB18030")
{
}

/// http://tool.chacuo.net/cryptaes
/// CBC PKCS7Padding 128位
/// EncStr String 原文
/// Key    String 密钥  16位长字符
/// IV     String 偏移量 16位长字符
/// InOutType String  默认"ORIGIN/BASE64/UTF8" "key值类型ORIGIN|HEX|BASE64 / 返回值类型HEX|BASE64 / 原文编码UTF8"
/// w ##class(web.Util.Encryption).AESCBCPKCS7Encode("1234567890abcdefghijklmn原文","1234567890654321","1234567890654321")
/// w ##class(web.Util.Encryption).AESCBCPKCS7Encode("1234567890abcdefghijklmn原文","1234567890654321","1234567890654321","ORIGIN/HEX/UTF8")
/// 20220913 by wanghc 浠水人民云影像
ClassMethod AESCBCPKCS7Encode(EncStr, Key, IV, InOutType = "ORIGIN/BASE64/UTF8")
{
}

/// 安徽华泽中西医的体检健康小管家接口对接要使用到Zero补位 [3140906]
/// 字节不满blockSize补$char(0)
/// @date: 2022-12-12
/// @author: wanghc
/// @other: w ##class(web.Util.Encryption).AESCBCZeroEncode("汉字","1234567887654321","1234567890123456","ORIGIN/BASE64/UTF8")
/// 得到mKD4kHVZa36eSK7uZ+2hkhEy9SgH5ZOfmLAaB8aVJ4k=
/// 把结果放到网上可以解密成功，但会多出16个$char(10),应该是AESCBCEncrypt自身导致
ClassMethod AESCBCZeroEncode(EncStr, Key, IV, InOutType = "ORIGIN/BASE64/UTF8")
{
}

/// http://tool.chacuo.net/cryptaes
/// CBC PKCS7Padding 128位 
/// EncStr String 原文
/// Key    String 密钥  16位长字符
/// IV     String 偏移量 16位长字符
/// InOutType String 默认"ORIGIN/BASE64/UTF8" "key值类型ORIGIN|HEX|BASE64  /  加密串类型HEX|BASE64 /  原文编码UTF8"
/// w ##class(web.Util.Encryption).AESCBCPKCS7Decode("ZJazJChfbNrI6c1oKPMKy6tcuJcTcirWzM/51vuSPqo=","1234567890654321","1234567890654321")
/// w ##class(web.Util.Encryption).AESCBCPKCS7Decode("","1234567890654321","1234567890654321","ORIGIN/HEX/UTF8")
/// 20220913 by wanghc 浠水人民云影像
ClassMethod AESCBCPKCS7Decode(Chiper, Key, IV, InOutType = "ORIGIN/BASE64/UTF8")
{
}

/// 解码 Type可为ORIGIN(不转换),BASE64,HEX
ClassMethod D(Src, Type, CharSet = "UTF8")
{
}

/// 编码 Type可为ORIGIN(不转换),BASE64,HEX
ClassMethod E(Src, Type, CharSet = "UTF8")
{
}

/// w ##class(web.Util.Encryption).AESECBPKCS5PaddingEncode(123456,"fh808xWLl8GpRDcI","","ORIGIN/HEX/GB18030")
ClassMethod AESECBPKCS5PaddingEncode(EncStr, Key, IV, InOutType = "HEX/HEX/GB18030")
{
}

/// @Param {String} EnStr  需解密串
/// @Param {String} crypt  密钥
/// @Param {String} Type   Base64 | HEX 转成Base64还是16进制字符
ClassMethod AESDecode7Padding(EnStr = "", crypt = "", Type = "Base64")
{
}

/// 大长度解密
/// W ##class(web.Util.Encryption).AESDecode7PaddingEx("4390CDAC50952245FC123CFD4A110C8A7E90A04F7F86EF4864C67BE916F2555B","ABCDEF0123456789","HEX")
ClassMethod AESDecode7PaddingEx(EncStr, crypt, Type = "Base64")
{
}

ClassMethod DESByNY()
{
}

///  w ##class(web.Util.Encryption).SDecrypt()
ClassMethod SDecrypt(EncStr, Key = "IMedical")
{
}

/// W ##class(web.Util.Encryption).SHA256("AccountId=yanfa001&PhoneNos=13699999999&Password=B54B89712EB997BE99114478E3673E3F&Random=6203922&Timestamp=1532928860","HEX")
/// w ##class(web.Util.Encryption).SHA256("AccountId=yanfa001&PhoneNos=13699999999&Password=B54B89712EB997BE99114478E3673E3F&Random=6203922&Timestamp=1532928860&content=在线加密","HEX")
ClassMethod SHA256(Src, OutType = "HEX")
{
}

/// D ##class(web.Util.Encryption).HMACSHA256("签","XTka8lO2NMH9PCffiFWLE1HV4UPYCWMu",1)
/// w ##class(web.Util.Encryption).HMACSHA256("a","dfbd6014e29f4656965fe0d76ebecae8",2)
/// param IsBase64Key 是不是base64格式密钥 
/// 0. input|output                  转出字节
/// 1. base64->input|output->base64  入参为base64转成base64
/// 2. input|output->hex             转成十六进制
ClassMethod HMACSHA256(Src, Key, IsBase64Key = 0)
{
}

/// D ##class(web.Util.Encryption).HMACSHA1("签","09kEgZIHYDuWn0Ay/eFCESykZB0=",1)
/// w ##class(web.Util.Encryption).HMACSHA1("_api_access_key=65ce75d08e8744fd8a9978daa3d5dc86&_api_name=svc1&_api_timestamp=11111&_api_version=1.0.0","09kEgZIHYDuWn0Ay/eFCESykZB0=",2)
/// param IsBase64Key 是不是base64格式密钥 
/// 0. input|output                  转出字节
/// 1. base64->input|output->base64  入参为base64转成base64
/// 2. input|output->hex             转成十六进制
ClassMethod HMACSHA1(Src, Key, IsBase64Key = 0)
{
}

/// Creator:		Cryze
/// CreatDate:		2019-06-24
/// Description:	对文件进行MD5
/// Input:			filepath 文件物理路径
/// Output:			ErrMsg 错误信息
/// Return:			成功返回MD5(16进制大写) 错误返回空
/// Debugger:		w ##class(web.Util.Encryption).File2MD5HexStr("D:\dthealth\app\dthis\web\images\logon_bg7.0.png",.ErrMsg)
ClassMethod File2MD5HexStr(filepath As %String, ByRef ErrMsg)
{
}

/// 加密数据返回数字 by wanghc 2019-10-17
/// 卡号保密时使用
/// w ##Class(web.Util.Encryption).SimpleEncryptDEC("123456789")
ClassMethod SimpleEncryptDEC(Src, Key = "CardKey")
{
}

/// SimpleEncryptDEC的解密方法 by wanghc 2019-10-17
/// w ##Class(web.Util.Encryption).SimpleDecryptDEC("114083065080118087069092122")
ClassMethod SimpleDecryptDEC(EncStr, Key = "CardKey")
{
}

/// 数字到数字，且长度控制
/// 增加存储卡卡号加密方法(a.偶数个数字转出数。b.相邻的两个卡号加密后的密文相似度不能太少 至少有三到四位数字不一样或者位置不同。C.加密码后长度在22-25之间)
/// w ##Class(web.Util.Encryption).NumberEnc("1256891911")
/// w ##Class(web.Util.Encryption).NumberEnc("1000010000")
ClassMethod NumberEnc(Number)
{
}

/// 是NumberEnc的解密方法
/// w ##Class(web.Util.Encryption).NumberDec("079069061109095115")
ClassMethod NumberDec(PNumber)
{
}

/// @param ParamStr 需要签名的参数 如: EpisodeID=1&InstanceID=12||11
/// @return 签名值 Signature
/// 对参数排序然后加Salt，最后使用ASEKey做HMACSHA256
/// 示例
/// Set url = "mypage.html"
/// Set timeStamp = ##class(BSP.SYS.UTIL.String).NowTimeStamp()
/// Set Param = "EpisodeID=1&InstanceID=12||11"
/// Set Salt = timeStamp_AESKey
/// Set Sign = ##class(web.Util.Encryption).ParamSignature(Param,Salt,AESKey)
/// Set NewUrl = url_"?"_Param_"&signature="_Sign_"&timeStamp="_timeStamp
ClassMethod SHA256Sign(ParamStr, OutType = "HEX")
{
}

/// @param ParamStr 需要签名的参数 如: EpisodeID=1&InstanceID=12||11
/// @param ASEKey   签名Key
/// @param Salt     加盐值
/// @return 签名值 Signature
/// 对参数排序然后加Salt，最后使用ASEKey做HMACSHA256
/// 示例
/// Set url = "mypage.html"
/// Set timeStamp = ##class(BSP.SYS.UTIL.String).NowTimeStamp()
/// Set Param = "EpisodeID=1&InstanceID=12||11"
/// Set Salt = timeStamp_AESKey
/// Set Sign = ##class(web.Util.Encryption).ParamSignature(Param,Salt,AESKey)
/// Set NewUrl = url_"?"_Param_"&signature="_Sign_"&timeStamp="_timeStamp
ClassMethod HMACSHA256Sign(ParamStr, ASEKey, Salt = "")
{
}

/// @param Sign    签名值
/// @param SrcData 源数据 可为空  SrcData为空时从%request中取值组合成源数据
/// @param ASEKey  签名Key  与签名时一致
/// @param Salt    盐值     与签名时一致
/// @return 大于0表示验证签名成功
///         小于0表示验证签名失败
///         1^验证签名成功.
///         120^验证签名成功.   120表示签名到验签过了120秒，通过请求中的timeStamp来计算过了多久
///         -1^数据签名错误. 
ClassMethod HMACSHA256ValidSign(Sign, SrcData, ASEKey, Salt = "")
{
}

/// 公钥SM2加密
/// Set PubKey = "04AFDF1597EBE5B39B2458DE2273B7D426988FB7A9D88E098309C0DAF2D64FFB1DA1309DB5D78432BCA194AFC3855F4AEA22B168BBCDF7C85B7AAD61DFDFBF2282"
/// w ##class(web.Util.Encryption).SM2Encode("123",Key)
ClassMethod SM2Encode(SrcStr, PubKey)
{
}

/// SM2解密
/// 私钥：
/// Set PriKey = "5817C323735FBB8DFB698B0BFC3D060132769C9C21FFD000A1CCA5B60DE54D06"
/// w ##class(web.Util.Encryption).SM2Decode(EncStr,PriKey)
ClassMethod SM2Decode(EncStr, PriKey)
{
}

/// HmacSM3签名
/// @Param {String} SrcStr  原消息字符串
/// @Param {String} Key  加密钥
/// @Param {String} OutType HEX|BASE64   转出成HEX或BASE64 默认HEX
ClassMethod HmacSM3(SrcStr, Key, OutType = "HEX")
{
}

/// SM3签名
/// @Param {String} SrcStr  原消息字符串
/// @Param {String} OutType HEX|BASE64   转出成HEX或BASE64 默认HEX
ClassMethod SM3(SrcStr, OutType = "HEX")
{
}

/// SM4加密
ClassMethod SM4Encode(SrcStr, Key, OutType = "BASE64")
{
}

/// SM4解密
ClassMethod SM4Decode(EncStr, Key, OutType = "BASE64")
{
}

/// 调用WS服务实现国密算法
ClassMethod EncryptorWS(Method, P1 = "", P2 = "", P3 = "", P4 = "", P5 = "")
{
}

}
