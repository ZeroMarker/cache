/// 名称:	EMR.IP.BL.BLPatDisease
/// 描述:	住院病历 患者病种相关代码
/// 编写者：lifengbo
/// 编写日期: 2023-03-20
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLPatDisease Extends EMR.IP.COM.ActionBase
{

/// Desc:       获取患者病种信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPatDisease(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeId=""
	s episodeId=argInJson.params.episodeID
	
    s strRes = ##Class(EMR.DOC.BL.AdmPatType).GetPatDiseaseJson(episodeId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未捕获异常：GetPatDisease",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$ze,2)
}

/// Desc:       保存患者病种信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveAdmPatType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeId="",diseaseCode="",userID=""
	s episodeId=argInJson.params.episodeID


	s dtoItem = ##class(EMR.DOC.DTO.AdmPatType).%New()
	
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.PatType = ""
	
	s userID = argInJson.params.userID
	s dtoItem.AppointUserID = userID
	
	s diseaseCode=argInJson.params.diseaseCode
	s EMRDOCDiagnosID = ##Class(EMR.IP.BL.BLDiagnos).GetDiagnosIDByCode(diseaseCode)
	s dtoItem.EMRDOCDiagnosID = EMRDOCDiagnosID
	
	
    s strRes = ##Class(EMR.DOC.BL.AdmPatType).AddAdmPatTypeJson(dtoItem,.argOutData)
    
	if (strRes >0)
	{ 
		q "1"
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","检查必填项",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常"_$zerror,2)
}

}
