/// 名称:	EMR.IP.BL.BLHIS
/// 描述:	取HIS中相关信息交互接口
/// 编写者：lifengbo
/// 编写日期: 2023-04-03
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLHIS Extends EMR.IP.COM.ActionBase
{

/// Desc:       保存文档
/// Creator:    lifengbo
/// CreateDate: 2023-04-03
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPatientInfoByEpisodeID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeId=""
	s episodeId=argInJson.params.episodeID
	
    s strRes = ##Class(EMR.IP.BL.BLHIS).GetPatientInfoByEpisodeIDJson(episodeId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","重要参数缺失",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未识别的返回值异常",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$ze,2)
}

/// Desc:	获取患者信息
/// Input:	argEpisodeID,就诊号
/// Return:	患者相关信息（patientID ,
/// 						  episodeID 就诊号,
/// 						  episodeType 就诊类型,
/// 						  mradm ,
/// 						  cardNo 就诊卡号,
/// 						  secCode 保密级别信息）
/// Debug:	s argOutData = ##class(%GlobalBinaryStream).%New()
/// 		w ##Class(EMR.IP.BL.BLHIS).GetPatientInfoByEpisodeIDJson(285,.argOutData)
ClassMethod GetPatientInfoByEpisodeIDJson(argEpisodeID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{

	s strRes ="-100"
	q:(argEpisodeID="") strRes
	
	s json = {}
	s json.patientID = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
	s json.episodeID = argEpisodeID
	s json.episodeType = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetType(argEpisodeID)
	s json.mradm = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMainMRADMDR(argEpisodeID)
	//卡号
	s json.cardNo = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetCardNo(argEpisodeID)
	
	//患者密级
	s SecurityData= ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetSecurity(argEpisodeID)
	s secCode = $p(SecurityData,"^",3)
	s json.secCode = secCode
	
	d json.%ToJSON(argOutData)
	
	q 1
}

}
