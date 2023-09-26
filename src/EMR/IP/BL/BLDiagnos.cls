/// 名称:	EMR.IP.BL.BLPatDisease
/// 描述:	住院病历 患者病种相关代码
/// 编写者：lifengbo
/// 编写日期: 2023-03-20
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLDiagnos Extends EMR.IP.COM.ActionBase
{

/// Desc:       依据诊断获取病种信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      argArray  命令参数  {"action":"GET_DISEASEBYDIAGNOS","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDiseaseByDiagnos(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (diagnosInfo,userLocID,userLocID)=""
	s diagnosInfo=argInJson.params.diagnosInfo
	s userLocID=argInJson.params.userLocID
	s text=argInJson.params.text
	
	
    s strRes = ##Class(EMR.IP.BL.BLDiagnos).GetPatDiseaseJson(diagnosInfo,userLocID,text,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入版本ID",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// /////////////////////////////////
/// JSON 组合代码
/// ////////////////////////////////
/// Desc:	获取患者病种信息
/// Input:	
/// Return:	患者病种信息
/// Debug:	
/// s argOutData = ##class(%GlobalBinaryStream).%New()
/// 	w ##Class(EMR.IP.BL.BLDiagnos).GetPatDiseaseJson("",191,"",.argOutData)
ClassMethod GetPatDiseaseJson(ADiagnosInfo As %String = "", ALocID As %String = "", AText As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr=[]
	
	s fromDiag="false"

	for i=1:1:$l(ADiagnosInfo,"$")
	{
		s tmpDiagnosInfo = $P(ADiagnosInfo,"$",i)
		
		s IcdCode = $P(tmpDiagnosInfo,"^",2)
		s RowId = ""
		
		continue:(IcdCode ="")
		for
		{	
			//诊断过滤
			s RowId=$O(^CF.EMR.DOC.DiagnosDiseaseI("IdxICDCode"," "_$zcvt(IcdCode,"U"),RowId))
			
			q:RowId=""
			
			s obj = ##class(CF.EMR.DOC.DiagnosDisease).%OpenId(RowId)
			s DiseaseCode = obj.DiagnosCode
			continue:DiseaseCode=""
			//科室过滤
			s CTLocRowID=""
			s CTLocIDFlag=0
			s DiagnosID=""
			s DiagnosID=$o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode"," "_DiseaseCode,DiagnosID))
			if (ALocID'=""){
				for
				{
					s CTLocRowID = $O(^CF.EMR.DOC.DiagnosCTLocI("IdxDiagnosID",DiagnosID,CTLocRowID))
					q:CTLocRowID=""
					s obj = ##class(CF.EMR.DOC.DiagnosCTLoc).%OpenId(CTLocRowID)
					s CTLocID = obj.CTLocID.%Id()
					s:CTLocID=ALocID CTLocIDFlag=1
					q:CTLocIDFlag=1
				}	
			}
			continue:(ALocID'="")&&(CTLocIDFlag=0)
			//IdxDiagnosCode ^DHCEMRM.DiagnosI
			s DiseaseRowID = ""
			s DiseaseRowID = $O(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode"," "_DiseaseCode,DiseaseRowID))
			continue:DiseaseRowID=""
			s DiseaseObj = ##class(CF.EMR.DOC.Diagnos).%OpenId(DiseaseRowID)
			continue:DiseaseObj.Status'="0"
			s Code = DiseaseObj.DiagnosCode
			s Name = DiseaseObj.DiagnosName
			
			
			continue:('(Name[AText) && '(Code[AText)&&(AText'=""))
			s jsonsub={}
			s jsonsub.Code = Code
			s jsonsub.Name = Name
			
			d jsonArr.%Push(jsonsub)

			s fromDiag="true"
		}	
	}

	if (fromDiag="false")
	{
		s DiseaseCode=""
		for
		{
			s DiseaseCode=$O(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode",DiseaseCode))
			q:DiseaseCode=""
			//科室过滤
			s CTLocRowID=""
			s CTLocIDFlag=0
			
			s DiagnosID=""
			s DiagnosID=$o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode",DiseaseCode,DiagnosID))
			
			if (ALocID'=""){
				for
				{
					s CTLocRowID = $O(^CF.EMR.DOC.DiagnosCTLocI("IdxDiagnosID",DiagnosID,CTLocRowID))
					q:CTLocRowID=""
					s obj = ##class(CF.EMR.DOC.DiagnosCTLoc).%OpenId(CTLocRowID)
					s CTLocID = obj.CTLocID.%Id()
					s:CTLocID=ALocID CTLocIDFlag=1
					q:CTLocIDFlag=1
				}
			}
			
			continue:(ALocID'="")&&(CTLocIDFlag=0)
			s DiseaseRowID=""
			s DiseaseRowID = $O(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode",DiseaseCode,DiseaseRowID))
			continue:(DiseaseRowID="")
			s DiseaseObj = ##class(CF.EMR.DOC.Diagnos).%OpenId(DiseaseRowID)
			continue:DiseaseObj.Status'="0"
			s Code = DiseaseObj.DiagnosCode
			s Name = DiseaseObj.DiagnosName
			
			continue:('(Name[AText) && '(Code[AText)&&(AText'=""))
			
			s jsonsub={}
			s jsonsub.Code = Code
			s jsonsub.Name = Name
			
			d jsonArr.%Push(jsonsub)
			
		}
	}
	
	d jsonArr.%ToJSON(argOutData)
	
	q 1
}

/// /////////////////////////////////
/// 服务代码
/// ////////////////////////////////
/// Desc:	获取患者病种信息
/// Input:	
/// Return:	患者病种信息
/// Debug:	w ##Class(EMR.IP.BL.BLDiagnos).GetDiagnosIDByCode("0034")
ClassMethod GetDiagnosIDByCode(ADiseaseCode As %String) As %String
{
	s ret=""
	q:(ADiseaseCode="") ret
	s DiagnosID=""
	s DiagnosID=$o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode"," "_ADiseaseCode,DiagnosID))
	q DiagnosID
}

}
