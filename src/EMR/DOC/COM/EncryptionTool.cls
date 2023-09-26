/// 名称:	EMR.DOC.COM.EncryptionTool
/// 描述:	加密公用方法类
/// 编写者:	yejian
/// 编写日期: 	2022-9-16
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.EncryptionTool Extends %RegisteredObject
{

/// Desc:       返回哈希内容
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input：		aData:原文（流数据）
/// 			
/// Output：	成功 返回哈希值
/// 			失败 -1^失败信息
/// debug: 		w ##class(EMR.DOC.COM.EncryptionTool).GetMD5HashData()
ClassMethod GetMD5HashData(aData As %GlobalBinaryStream) As %String
{
	s strRes=""
	q:(signData.Size<1) strRes
	s MD5Data = ##class(%SYSTEM.Encryption).MD5HashStream(aData,.sc)
	q:($$$ISERR(sc)) "-1^哈希转换失败"
	s strMD5 = ##class(web.Util.Encryption).Byte2Hex(MD5Data)
	s strRes = $zcvt(strMD5,"L")
	q strRes
}

/// Desc:       返回加密病历ID
/// Creator:    yejian
/// CreateDate: 2022-12-8
/// Input：		AID:文档ID
/// 			
/// Output：	成功 返回加密ID值
/// 			失败 -1^失败信息
/// debug: 		w ##class(EMR.DOC.COM.EncryptionTool).GetEncDocId("22")
ClassMethod GetEncDocId(AID As %String, AType As %String = "") As %String
{
	s result = ""
	s id = AID
   	s encKey = "GlobaEMRBSBrowse"
   	s ts = $$GetTS()
   	s ran = $$GetRandom()
   	s encData = ran_"-"_AID_"-"_ts_"-"_AType
   	s encData = ##class(%SYSTEM.Encryption).AESCBCEncrypt(encData,encKey,"")
   	s encData = ##Class(web.Util.Encryption).Byte2Hex(encData)
   	s result = encData
   	q result
   	
GetTS(a)
	s dt = $zdt($NOW(),3,1,3)
	s dt = $extract(dt,3,*)
	s dt = $replace(dt,"-","")
	s dt = $replace(dt,":","")
	s dt = $replace(dt,".","")
	s dt = $replace(dt," ","")
	q dt
	
GetRandom(a)
	q $r(999999999999999)
}

/// Desc:       返回解密病历ID
/// Creator:    yejian
/// CreateDate: 2022-12-8
/// Input：		AID:加密ID
/// 			
/// Output：	成功 返回ID值
/// 			失败 -1^失败信息
/// debug: 		w ##class(EMR.DOC.COM.EncryptionTool).GetUnEncDocId("48A4FF03467410778BFB09F69A7CA6DB4DFF88E92F9E97AB124CA6814DA8615CCDCBD9AE0A0EEA39A29DA257D81FDBE1")
ClassMethod GetUnEncDocId(AID As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s encKey = "GlobaEMRBSBrowse"
	s UnenData = ##Class(web.Util.Encryption).Hex2Byte(AID)
	s UnenData = ##class(%SYSTEM.Encryption).AESCBCDecrypt(UnenData,encKey)
	q:($l(UnenData,"-") '= 4) result 
	s result = $p(UnenData,"-",2)
	q result
}

}
