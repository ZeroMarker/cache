///  名称：		EMRservice.BOPrintToolService
///  描述：		批量打印BO层
///  编写者：	yejian
///  编写时间：	2018-4-3
Class EMRservice.BOPrintToolService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PrintToolServiceInfo";

/// 获取科室列表
ClassMethod GetCTLoc(CTLocName As %String, UserRoleCode As %String) As %XML.DataSet [ WebMethod ]
{
  
   if ($D(CTLocName)=0)||(CTLocName="")
  	{
	  	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetAllCTLoc")
	  	Do result.SetArgs("E","",UserRoleCode)
	}
	else 
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetAllCTLoc")
		Do result.SetArgs("E",CTLocName,UserRoleCode)
	}
	
	Quit result
}

/// 获取院区列表
ClassMethod GetHospitalList(HospitalDesc As %String, UserRoleCode As %String) As %XML.DataSet [ WebMethod ]
{
    s result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetHospitalList")
	d result.SetArgs(HospitalDesc,UserRoleCode)
	q result
}

/// 获取患者类型列表
ClassMethod GetPatTypeList(PatTypeDesc As %String, UserRoleCode As %String) As %XML.DataSet [ WebMethod ]
{
    s result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetPatTypeList")
	d result.SetArgs(PatTypeDesc,UserRoleCode)
	q result
}

/// 获取患者类型列表
ClassMethod GetInsuranceTypeList(InsuranceTypeDesc As %String, UserRoleCode As %String) As %XML.DataSet [ WebMethod ]
{
    s result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetInsuranceTypeList")
	d result.SetArgs(InsuranceTypeDesc,UserRoleCode)
	q result
}

/// Desc:	通过日期获取已书写门诊病历的患者列表
ClassMethod GetPatListByDate(AQueryJson As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(EMRservice.Parser.JsonStr).%New()
	s json = obj.Deserialize(AQueryJson)
	s startDate = json.GetAt("StartDate")
	s endDate   = json.GetAt("EndDate")
	s locID     = json.GetAt("CTLocID")
	s hospID    = json.GetAt("HospitalID")
	s patTypeID = json.GetAt("PatTypeID")
	s userRoleCode = json.GetAt("UserRoleCode")
	s HasRecordNo = json.GetAt("HasRecordNo")
	s InsuranceTypeID = json.GetAt("InsuranceTypeID")
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetOPPatList")
	d result.SetArgs(startDate,endDate,locID,hospID,patTypeID,HasRecordNo,userRoleCode,InsuranceTypeID)
	q result
}

/// Desc:	通过姓名、病案号、登记号、卡号获取已书写门诊病历的患者列表
/// 	就诊卡号 
/// 	AWardID ID号
/// 	AMedicareNo为病案号;
/// 	APatientName为患者姓名;
ClassMethod GetPatListByCondition(AQueryJson As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(EMRservice.Parser.JsonStr).%New()
	s json = obj.Deserialize(AQueryJson)
	s APatientName = json.GetAt("PatientName")
	s AMedicareNo   = json.GetAt("MedicareNo")
	s ARegNo     = json.GetAt("RegNo")
	s ACardNo    = json.GetAt("CardNo")
	s userRoleCode = json.GetAt("UserRoleCode")
	
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetOPPatListByCondition")
	d result.SetArgs(APatientName, AMedicareNo, ARegNo, ACardNo, userRoleCode)
	q result
}

/// Desc：	根据入库记录获取书写了门诊病历但未打印的门诊就诊记录
ClassMethod GetUnprintOPAdmByInbound(AStartDate As %String, AEndDate As %String, AClinetGuid As %String, AUserRoleCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetUnprintOPAdmByInbound")
	d result.SetArgs(AStartDate,AEndDate,AClinetGuid,AUserRoleCode)
	q result
}

/// 查询AEpisodeId获取病历实例ID
ClassMethod GetAllInstIDByEpisodeID(AEpisodeIdList As %String, AUserRoleCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetAllInstIDByEpisodeID")
	d result.SetArgs(AEpisodeIdList, AUserRoleCode)
	q result
}

/// Desc: 	获取未打印的病历记录
ClassMethod GetUnprintInstanceByAdm(AEpisodeID As %String, AUserRoleCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrintToolService:GetUnprintInstance")
	d result.SetArgs(AEpisodeID, AUserRoleCode)
	q result
}

ClassMethod CreatePrintRecord(userID As %String, pIntanceId As %String, pStartPageNum As %String, pStartRowNum As %String, pEndPageNum As %String, pEndRowNum As %String, pUserRoleCode As %String = "") As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPrintToolService).CreatePrintRecord(userID, pIntanceId,pStartPageNum,pStartRowNum,pEndPageNum,pEndRowNum,pUserRoleCode)
}

}
