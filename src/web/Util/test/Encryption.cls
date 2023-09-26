Class web.Util.test.Encryption Extends %RegisteredObject
{

/// 测试ASE7Padding加密码链接功能
ClassMethod SignUrlTest(UserCode, AESKey = "")
{
	/// A76B35C6D6831286C104765F2641D4CD
 Set url = "http://172.17.201.174/imedical/web/form.htm"
 Set timeStamp = ##class(BSP.SYS.UTIL.String).NowTimeStamp()
 Set AES7UserCode = ##class(web.Util.Encryption).AESEncode7Padding(UserCode_","_timeStamp,AESKey,"HEX")
 Set Param = "TPSID=20000&AES7UserCode="_AES7UserCode_"&USERNAME="_UserCode_"&EpisodeID=1&InstanceID=12||11"
 Set Salt = timeStamp_AESKey
 Set Sign = ##class(web.Util.Encryption).HMACSHA256Sign(Param,AESKey,Salt)
 Set NewUrl = url_"?"_Param_"&signature="_Sign_"&timeStamp="_timeStamp
 Quit NewUrl
}

/// w ##class(web.Util.Encryption).Test("1","HL")
/// w ##class(web.Util.Encryption).Test("[127.0.0.1][1972]","IMedical")
/// lacideMi+key
ClassMethod Test(Src, Key)
{
	Set rtn = ##class(web.Util.Encryption).SimpleEncrypt(Src,Key)
	write "加密后:",rtn
	Set rtn = ##class(web.Util.Encryption).SimpleDecrypt(rtn,Key)
	write !,"解密后:",rtn
	
	Write !,"http://10.120.7.2/orgview.aspx?org="_##class(web.Util.Encryption).HealthDocEncrypt("350825100")
	_"&user="_##class(web.Util.Encryption).HealthDocEncrypt("lfsqwssq")
	_"&key="_##class(web.Util.Encryption).HealthDocEncrypt("lfsqwssq")
	_"&ssid="_##class(web.Util.Encryption).HealthDocEncrypt("F03648696")
	_"&idno="_##class(web.Util.Encryption).HealthDocEncrypt("汪濂")
	_"&type=jyjc"
	Quit ""
}

/// w ##class(web.Util.test.Encryprion).EncryptDecryptBase64Test(2)
ClassMethod EncryptDecryptBase64Test(insrc)
{
	
	set enc = ##class(web.Util.Encryption).RSAEncrypt(insrc,"E:\DtHealth\app\dthis\web\key\HIS_Public.csr")
	w insrc,"加密码后:",enc,!
	set src = ##class(web.Util.Encryption).RSADecrypt(enc,"E:\DtHealth\app\dthis\web\key\HIS_Privatekey.pem")
	w "解密后:",src,!
	q ""
}

/// w ##class(web.Util.test.Encryprion).EncryptDecryptHexTest(2)
ClassMethod EncryptDecryptHexTest(insrc)
{
	s publicPath = "E:\DtHealth\app\dthis\web\key\HIS_Public.csr"
	w "公钥modulus=",##class(web.Util.Encryption).GetRSAPublicKeyModulus(publicPath),!
	w "公钥exponent=",##class(web.Util.Encryption).GetRSAPublicKeyExponent(publicPath),!
	;w "私钥exponent=",##class(web.Util.Encryption).GetRSAPublicKeyExponent("E:\DtHealth\app\dthis\web\key\HIS_Privatekey.pem"),!,!
	set enc = ##class(web.Util.Encryption).Encrypt(insrc,publicPath)
	w insrc,"->",enc,!
	set src = ##class(web.Util.Encryption).Decrypt(enc,"E:\DtHealth\app\dthis\web\key\HIS_Privatekey.pem")
	w "->",src,!
	q ""
}

/// 0C0FAA2C8A2083524139CE448B49A69976CFE95B6615F440811E6031E0D819A32992FFE790E082BDEBD2CF22F16E625584AF78823494C5B2D7ED8B4EFA5ED9CAD38F87F0335A5ED6F5BA4327E8C0D18884DAA5B79E521E8031B9142C2D3AFD4E48BD457EF6580339DEDC1D3939A1E093733284AA3F1BD28A7F980522C83A0B4B
/// 23D851947F8F7F19F1FBC2FFDB2825BEF1BF223FB534A9060692857B11A4BAFF7A26009295426DB3D0484348D5C740B453325B7587CD6D684FF0F41B023C507ABE49D69AC1E0ADD445F7620AC791DBF99B5D8D8C9E7903240DF6F04B33B87CCCEADC0B476158107D7CD7B573E7E7631DB2A54A0F078AAFBEEA73A518DFA0316E
/// w ##class(web.Util.test.Encryprion).DecryptTest("3755fed1c72f7961dfdda67572ddbd66471117a3b1e6a27cc28a1da621c5e9b9b43b3a70f8bfd295377e31e942c8c7e806c1fd8a89646d63f0ebc312c9d0b474c0be175859973ed0ed757d874cf4fa0c3f90ec91c49ce5e78ef35d4c72abab3c5942963b0c35bf9fcc1a2f168122990501447888a4f9df53767e6e8224f11376")
/// w ##class(web.Util.test.Encryprion).DecryptTest(enc)
ClassMethod DecryptTest(enc)
{
	set src = ##class(web.Util.Encryption).Decrypt(enc,"E:\DtHealth\app\dthis\web\key\HIS_Privatekey.pem")
	w ##class(%SYSTEM.Encryption).RSAGetLastError()
	q src
}

/// Base64及MD5Hex测试
ClassMethod Base64EncodeTest(str)
{
	;Set str=##class(ext.util.String).#SimplifiedCh_"0123456789"
	set o = ##class(%GlobalCharacterStream).%New()
	d o.Write(str)
	d o.%Close()
	W "------------ GB18030 -------------",!
	Set enObj = ##class(web.Util.Encryption).Base64Encode(o,"GB18030")
	While('enObj.AtEnd){ w enObj.Read(32000)}
	do enObj.%Close()
	w !
	Set srcObj = ##class(web.Util.Encryption).Base64Decode(enObj,"GB18030")
	While('srcObj.AtEnd){ w srcObj.Read(32000) }
	do srcObj.%Close()
	
	w !,!,"--------- UTF8 ------------"
	Set enStr = ##class(web.Util.Encryption).Base64Encode(str)
	Set Src = ##class(web.Util.Encryption).Base64Decode(enStr)
	w !, enStr
	W !,Src
	w !,"----------- MD5 ------------"
	w !,"字符串MD5:"_##class(web.Util.Encryption).MD5HexStr(str)
	w !,"流对象MD5(版本>=2016时才有值):"_##class(web.Util.Encryption).MD5HexStr(o)
	Q ""
}

/// w ##class(web.Util.Encryption).DESTest()
ClassMethod DESTest()
{
	s PlainText="a"  //"{""birthday"":""19750908"",""medical_treat_type"":""11"",""fund_info"":""55.0|55.0|0.0|0.0|0.0|0.0|0.0|0.0|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|0.0|*|0.0|0.0|"",""si_card_no"":""210100D156000005A006AC0A00C7E7B3"",""nation"":""01"",""year"":""2018"",""post_balance"":""1535.3"",""sex"":""1"",""other_city_person"":""0"",""bis_code"":""2027-00099993-20180516784698"",""overall_area_code"":""210100"",""si_status"":""1"",""receiver_serial_no"":""2027-20180517073826-921"",""medical_card_no"":"""",""sender_serial_no"":""20180517081426-2027-6855"",""person_no"":""1002839949"",""insurance_type"":""31"",""id_no"":""210122197509080635"",""balance_time"":""20180517075309"",""name"":""李春涛"",""pre_balance"":""1590.3"",""company_code"":""00121008""}"
	Set PlainText = ##class(web.Util.Encryption).PKCS7Padding(PlainText)
	Set PlainText=$ZCONVERT(PlainText,"O","UTF8") 
	s key = "bzWtRtISoc0=" //"6F35AD46D212A1CD"
	;set keyByte = ..Hex2Byte(key)
	b ;
	Set keyByte = ##class(%SYSTEM.Encryption).Base64Decode(key)
	s p = ##class(%SYSTEM.Encryption).AESEncode(PlainText,keyByte) //AESEncode(src,keyByte) //CBC CRC AESEncode 
	b ;p
	S p = ##class(%SYSTEM.Encryption).Base64Encode(p)
	q p
}

/// w ##class(web.Util.Encryption).Test("1","HL")
/// w ##class(web.Util.Encryption).Test("[127.0.0.1][1972]","IMedical")
/// lacideMi+key
/// 自主对称算法测试，健康档案加密测试
ClassMethod SimpleAndHealthDocTest(Src, Key)
{
	Set rtn = ##class(web.Util.Encryption).SimpleEncrypt(Src,Key)
	write "加密后:",rtn
	Set rtn = ##class(web.Util.Encryption).SimpleDecrypt(rtn,Key)
	write !,"解密后:",rtn
	
	Write !,"http://10.120.7.2/orgview.aspx?org="_##class(web.Util.Encryption).HealthDocEncrypt("350825100")
	_"&user="_##class(web.Util.Encryption).HealthDocEncrypt("lfsqwssq")
	_"&key="_##class(web.Util.Encryption).HealthDocEncrypt("lfsqwssq")
	_"&ssid="_##class(web.Util.Encryption).HealthDocEncrypt("F03648696")
	_"&idno="_##class(web.Util.Encryption).HealthDocEncrypt("汪濂")
	_"&type=jyjc"
	Quit ""
}

/// W ##class(web.Util.test.Encryprion).InitWS()
ClassMethod InitWS(wsdl = "", SSLConfig = "")
{
	Set WSClassName = "dhcserviceclient.EncryptorWSImplPort"
	if (wsdl="") Set wsdl="http://127.0.0.1:31996/mediway/encryptor?wsdl"
	if ##class(websys.Conversions).IsValidClassName(WSClassName) Do $system.OBJ.Delete(WSClassName,"/displaylog=0")
	set reader = ##class(%SOAP.WSDL.Reader).%New()
	Set reader.CompileFlags="ck/displaylog=0"
	set soapsc = reader.Process(wsdl,"dhcserviceclient")
	Set CN=$order(reader.ClientClassList(""))
	set reader=""
	Quit CN
}

/// 初始化国密算法环境
ClassMethod InitSMEnv(wsdl = "", SSLConfig = "")
{
	Q ..InitWS(wsdl,SSLConfig)
}

/// W ##class(web.Util.test.Encryprion).SMTest()
/// ANU3/p6sTxr3x2hRYlGH84hfLNnv3T8dAHwWsLkV+cn6
ClassMethod SMTest()
{
	
	S PubKey = "04AFDF1597EBE5B39B2458DE2273B7D426988FB7A9D88E098309C0DAF2D64FFB1DA1309DB5D78432BCA194AFC3855F4AEA22B168BBCDF7C85B7AAD61DFDFBF2282"
	S PriKey = "5817C323735FBB8DFB698B0BFC3D060132769C9C21FFD000A1CCA5B60DE54D06"
	S EncStr = "" //##class(web.Util.Encryption).SM2Encode("123",PubKey)
	;W "|-SM2加解密测试----------------------------------------------------------------|",!
	;W "|公钥："_PubKey,!
	;W "|私钥："_PriKey,!,!
	;W "|加密123得到：",EncStr,!
	;W "|解密结果：",##class(web.Util.Encryption).SM2Decode(EncStr,PriKey),!
	;W "|                                                                              |",!
	;W "|                                                                              |",!
	W "|-SM3哈希测试------------------------------------------------------------------|",!
	W "|哈希123得到：",##class(web.Util.Encryption).SM3("123","HEX"),!
	W "|哈希123得到：",##class(web.Util.Encryption).SM3("123","BASE64"),!
	W "|                                                                              |",!
	W "|SM4加解密测试(Key=6AsIYw2s+4tfT/Kf)-------------------------------------------|",!
	Set EncStr = ##class(web.Util.Encryption).SM4Encode("123","6AsIYw2s+4tfT/Kf","BASE64")
	W ##class(web.Util.Encryption).SM4Encode("1FM99V9JP0009A23A8C00000D445BA03","1FM99V9JP0009A23","HEX")
	W "|加密123结果：",EncStr,!
	W "|解密结果：",##class(web.Util.Encryption).SM4Decode(EncStr,"6AsIYw2s+4tfT/Kf","BASE64"),!
	W "|                                                                              |",!
	W "|------------------------------------------------------------------------------|",!
	Q ""
}

/// W ##class(web.Util.test.Encryprion).HsafSMTest()
ClassMethod HsafSMTest()
{
	Set PubKey64 = "BDbdxtpTCm4C7btIURBuuJFIKcbjdp4Uq8yKM2chXE67+iD3vPZfQqaZAqmwHUGEsHG/tPqc4qRkFuf9FpjGOBg="
	Set PriKey64 = "ANU3/p6sTxr3x2hRYlGH84hfLNnv3T8dAHwWsLkV+cn6"
	Set appSecret= "42F58A9A6D7A4140AA09BE864D36FF1F"
	Set appId    = "AE03EF6F8B9649CA86E0C26960803C87"
	W "appSecret：",appSecret,!
	W "appId：",appId,!
	W "公钥："_PubKey64,!
	W "私钥："_PriKey64,!
	Set HsafEncodeStr = ##class(web.Util.HsafEncryption).Encrypt("abc",appId,appSecret)
	W "电子处方加密abc结果：" , HsafEncodeStr,!
	W "电子处方解密结果：", ##class(web.Util.HsafEncryption).Decrypt(HsafEncodeStr,appId,appSecret)
	W !,"--------------------------",!
	Set data = "{""adm"":""1""}"
	W "Data：",data,!
	Set sign = ##class(web.Util.HsafEncryption).Sign(data,appSecret,PriKey64)
	W "私钥签名abc：", sign,!
	W "公钥验签：", ##class(web.Util.HsafEncryption).Verify(data,appSecret,PubKey64,sign)
	w !,"-----------------------------"
	Set en = ##class(web.Util.HsafEncryption).Sm4EncryptWithSm2(appId,appSecret,PriKey64,data)
	W !,"签名及加密Sm4EncryptWithSm2：", en
	
	W !,"解密及验签Sm4DecryptWithSm2：",##class(web.Util.HsafEncryption).Sm4DecryptWithSm2(en,appId,appSecret,PubKey64)
	Q ""
}

///  W ##class(web.Util.test.Encryption).AESCBCTest()
ClassMethod AESCBCTest()
{
	Set Key = "1234567890654321"
	Set IV =  "1234567890654321"
	
	Set txt = "1234567890abcdefg我"
	
	
	Set Enc =  ##class(web.Util.Encryption).AESCBCPKCS7Encode(txt,Key,IV,"ORIGIN/BASE64/UTF8")
	If Enc="ZJazJChfbNrI6c1oKPMKy4cQljD+chsVmVu9KZZSsF4="{
		W "与https://the-x.cn/cryptography/Aes.aspx结果【一样】",!!
	}else{
		W "与https://the-x.cn/cryptography/Aes.aspx结果【不一样】",!!
	}
	W """"_txt_"""加密得到:",!  
	W Enc,!
	W ##class(web.Util.Encryption).AESCBCPKCS7Decode(Enc,Key,IV,"ORIGIN/BASE64/UTF8"),!
	q ""
}

///  W ##class(web.Util.test.Encryption).AESECBTest()
ClassMethod AESECBTest()
{
	Set Key = "1234567890654321"
	Set txt = "1234567890abcdefg我"
	Set Enc =  ##class(web.Util.Encryption).AESECBPKCS7Encode(txt,Key)	;HvxuGiq70Oz1MU3HOI0cX5Owu/IaCjbHFBIN/xwca3w=
	If Enc="HvxuGiq70Oz1MU3HOI0cX5Owu/IaCjbHFBIN/xwca3w="{
		W "与https://the-x.cn/cryptography/Aes.aspx结果【一样】",!!
	}else{
		W "与https://the-x.cn/cryptography/Aes.aspx结果【不一样】",!!
	}
	Set Key = "s4t91vyn7sl23cta"
	Set txt ="[{""name"":""吕巧英"",""cardNumber"":""370602195608115220"",""sampleTime"":""2022-09-16 04:05:02"",""samplingOrgPcr"":""烟台市中医医院"",""samplingOrgPcrCode"":""烟台市中医医院"",""infoSrc"":""烟台市"",""countyName"":""芝罘区""}]"
	Set Enc =  ##class(web.Util.Encryption).AESECBPKCS7Encode(txt,Key)
	W Enc,!,!,!
	s src = ##class(web.Util.Encryption).AESECBPKCS7Decode(Enc,Key)
	w src,!
	q ""
}

///  W ##class(web.Util.test.Encryption).AESECBTest()
ClassMethod Base64Test()
{
	s str2=""
	for i=1:1:3073{Set str2=str2_"a我"}
	s InStr=##class(%GlobalCharacterStream).%New()
	
	d InStr.Write(str2)
	w "src length: ",$l(str2),!
	
	s OutStr=##class(web.Util.Encryption).Base64Encode(InStr,"UTF8")
	w !,"out stream length: ",OutStr.Size,!
	;s resulEnCode=OutStr.Read()
	//w OutStr.Read(),!
	
	s resultDnCode=##class(web.Util.Encryption).Base64Decode(OutStr,"UTF8")
	W "解密 length: ",resultDnCode.Size,!
	//s resultDnCode=resultDnCode.Read()
	
	q resultDnCode
}

}
