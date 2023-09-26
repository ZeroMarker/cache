/// 名称:	EMR.DOC.BL.PatientSign
/// 描述:	患者数据签名业务
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PatientSign Extends EMR.DOC.COM.ActionBase
{

/// Desc:      保存患者数据签名
/// Creator:    yejian
/// CreateDate: 2022-9-28
/// Table:		
/// Input: 		aItem 签名对象
/// 			argInData 签名原文
/// Output:     成功：1^ID  失败：0^ErrMsg	
/// debug:  	w ##Class(EMR.DOC.BL.PatientSign).SaveDoctorSignStream()
ClassMethod SavePatientSign(aItem As EMR.DOC.DTO.SignData, argInData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem = "")||(aItem.EpisodeID="")||(aItem.EpisodeID="") "-1^保存医护签参数有误！"
	s objPatient = ##class(EMR.DAO.PatientSign).doCreateInstance(aItem.EpisodeID)
	s objPatient.CreateDate = aItem.SignDate
	s objPatient.CreateTime = aItem.SignTime
	s objPatient.Version = aItem.Version
	s objPatient.Algorithm = aItem.Algorithm
	s objPatient.EventCert = aItem.EventCert
	s objPatient.SignValue = aItem.SignValue
	s objPatient.TSValue = aItem.TSValue
	s objPatient.Digest = aItem.Digest
	d objPatient.BioFeature.CopyFrom(aItem.BioFeature)
	d objPatient.SignScript.CopyFrom(aItem.SignScript)
	d objPatient.HeaderImage.CopyFrom(aItem.HeaderImage)
	d objPatient.FingerPrint.CopyFrom(aItem.FingerPrint)
	d objPatient.SignData.CopyFrom(aItem.SignData)
	s sc =  objPatient.%Save()
	q:$$$ISERR(sc) "-1^DocumentID:"_aItem.DocumentID_",保存患签名原文失败"
	s patSignStream = ##class(EMR.DAO.PatientSignStream).doCreateInstance(aItem.EpisodeID)
	s patSignStream.SignID = objPatient
	s patSignStream.Digest =aItem.Digest
	d patSignStream.DocumentData.Clear()
	//数据压缩存储
	s temStream = ##class(EMR.DOC.COM.Parser.StreamData).CompressStream(argInData)
	d patSignStream.DocumentData.CopyFrom(temStream)
	s scStream =  patSignStream.%Save()
	if ($$$ISERR(scStream))
	{
		q "-1^DocumentID:"_aItem.DocumentID_",保存患签名原文失败"
	}
	q "1^"_objPatient.%Id()
}

/// Desc:       获取可用患者签名方式列表
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"episodeID":"6","documentID":"6"},"product":"OP","action":"GET_HANDSIGN_TYPE"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetHandSignType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s episodeID = argInJson.params.episodeID
	s documentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.PatientSign).GetHandSignTypeJson(episodeID,documentID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取可用患者签名方式列表
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:	aEpisodeID : 就诊ID
/// 		aDocumentID : 病历实例数据ID
/// Output:     成功：{"err":"","DataBoard":"1","PDFBoard":"1","PDFPad":"1","PDFWeChat":"1"}
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.PatientSign).GetHandSignTypeJson("","")
ClassMethod GetHandSignTypeJson(aEpisodeID As %String, aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	//q ##class(EMRservice.Util.Json).Instance().Put("err","").Put("DataBoard","0").Put("PDFBoard","0").Put("PDFPad","1").Put("PDFWeChat","0").ToJson()
	s jsonItem = ##class(%DynamicObject).%New()
	s jsonItem.DataBoard = "0"
	s jsonItem.PDFBoard = "0"
	s jsonItem.PDFPad = "1"
	s jsonItem.PDFWeChat="0"
	s jsonItem.err=""
   	d jsonItem.%ToJSON(argOutData)
   	q strRes
	
Error 
	q "-1^"_$zerror
}

}
