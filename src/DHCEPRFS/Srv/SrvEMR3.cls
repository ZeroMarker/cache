Class DHCEPRFS.Srv.SrvEMR3 Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvEMR3";

Parameter SOAPSESSION = 1;

/// 获取生成参数
/// debug: w ##class(DHCEPRFS.Srv.SrvEMR3).GetLoadRecordParam("20699767","82")
ClassMethod GetLoadRecordParam(AEpisodeID As %String, ATypeParam As %String) As %String [ WebMethod ]
{
	s mrItemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType("71",ATypeParam)
	s cgID = ##Class(DHCEPRFS.BL.BLMRSubCategory).GetTypeParamByMRItemID(mrItemID)
	//s catalogID = "CD_"_cgID_"_"_ATypeParam
	s mrItemObj = ##class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
	s mrItemCode = mrItemObj.Code
	s param = $e(mrItemCode,8,*)
	s catalogID = "CD_"_cgID_"_"_param
	
	s ret = ##class(EMRservice.HISInterface.CentralizedPrint).GetLoadRecordParam(AEpisodeID,catalogID)
	s retStr = ret.Read()
	q retStr
}

ClassMethod GetOptionByName(AOptionName As %String) As %String [ WebMethod ]
{
	s ret = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName(AOptionName)
	q ret
}

/// Desc: 获取HTTP链接参数
/// Creator: yejian
/// CreateDate: 2019-5-21
ClassMethod GetNetConnectJson(ByRef AServerPort As %String) As %String [ WebMethod ]
{
	s connectType = ##class(EMRservice.SystemParameter).GetNetConnectType()
	s AServerPort = ""
	if (connectType = "http")
	{
		//直接调用电子病历方法
		s paramsNum = ##class(DHCEPRFS.Util.ClassHelper).GetParamsNum("EMRservice.BOSysOption","GetNetConnectJson")
		if (paramsNum>1)
		{
			s webServiceUrl = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("DataServiceURL")
			s dbConnectType = $p(webServiceUrl,":",1)
			s netJson = ##class(EMRservice.BOSysOption).GetNetConnectJson(.AServerPort,dbConnectType)
		}
		else
		{
			s netJson = ##class(EMRservice.BOSysOption).GetNetConnectJson(.AServerPort)
		}
	}
	else
	{
		s netJson = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("NET_CONNECT")
	}
	q netJson
}

/// Desc: 获取3版病历连接方式
/// Creator: yangpeng
/// CreateDate: 20200304
/// debug: w ##class(DHCEPRFS.Srv.SrvEMR3).GetEMRConnectType()
ClassMethod GetEMRConnectType() As %String [ WebMethod ]
{
	//兼容有些项目如果非http连接的编辑器可能没有部署GetNetConnectType方法
	s $ZTRAP = "OnErrorHandler"
	s ret=##class(EMRservice.SystemParameter).GetNetConnectType()
	q ret
OnErrorHandler
	q ""
}

/// Desc:取电子病历运行环境参数 
///  （复制自电子病历，如果电子病历有此方法，直接引用）
/// Creator:Donglulu
/// CreateDate:2019-4-10
/// Input:Type :电子病历版本（非融合版：UnHisui）
/// Debug: w ##Class(DHCEPRFS.Srv.SrvEMR3).GetRunEMRParams()	
ClassMethod GetRunEMRParams() As %String [ WebMethod ]
{
	
	//Input:Type :电子病历版本（非融合版：UnHisui）
	s Type  = ""
	s result = ""
	
	//首先从电子病历方法获取，如果获取不到，通过本方法自己取
	try
	{
		s result = ##Class(EMRservice.BL.BLSysOption).GetRunEMRParams(Type)
	}
	catch
	{}
	
	q:(result '= "") result
	
	//取值
	try
	{
		s flagExternalData = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_PASTE_NON_EDITOR","Y")
		s flagExternalData = $case(flagExternalData,"N":"true",:"false")
		s flagAcrossPatient = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ENABLE_PASTE_LIMIT","Y")
		s flagAcrossPatient = $case(flagAcrossPatient,"N":"true",:"false")
		s enableEditMultiRecord = ##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord()
		s EMRHeart = ##class(EMRservice.SystemParameter).GetEMRHeartBeatTime()
		s menuEditParagraphVisible = ##Class(EMRservice.SystemParameter).SetMenuEditParagraphVisible()
		s revisionSettings = ##Class(EMRservice.SystemParameter).GetRevisionSettings()
		s isJsUpdateTitleInfo = "false"
		if (Type '= "UnHisui")
		{
			s isJsUpdateTitleInfo = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("IsJsUpdateTitleInfo")
			s isJsUpdateTitleInfo = $case(isJsUpdateTitleInfo,"Y":"true",:"false")
		}
		s result = "{""EnablePasteCopyExternalData"":"""_flagExternalData_""",""EnablePasteCopyAcrossPatient"":"""_flagAcrossPatient_""""
		s result = result_",""EnableEditMultiRecord"":"""_enableEditMultiRecord_""""
		s result = result_",""EMRHeartBeatTimeCycle"":"""_EMRHeart_""""
		s result = result_",""MenuEditParagraphVisible"":"""_menuEditParagraphVisible_""""
		s result = result_",""RevisionSettings"":"_revisionSettings_""
		s result = result_",""JsUpdateTitleInfo"":"""_isJsUpdateTitleInfo_""""
		s result = result_"}"
		s result = "{""action"":""SET_RUNEMR_PARAMS"",""args"":"_result_"}"
	}
	catch
	{
		s result = ""
	}
	q result
}

/// Desc:     	判断患者PDF签署状态
/// Creator:   	
/// CreateDate:	2021-09-13
/// Input:      AEpisodeId			就诊号
///           	AInstanceID			实例ID
/// Output:    	0 未签署  1 已签署 N 非患者签名模板无须判断
/// Debug: w ##Class(DHCEPRFS.Srv.SrvEMR3).CheckPatPDFSignStatus("5759456","6051612||1")
ClassMethod CheckPatPDFSignStatus(AEpisodeID As %String, AInstanceDataID As %String) As %String [ WebMethod ]
{
	s chkRet = "N"
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInstance = "") chkRet
	s EcrecordID = $p(AInstanceDataID,"||",1)
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(EcrecordID)
	q:(objRecord = "") chkRet
	s episodeId = objRecord.EpisodeID
	s:$IsObject(objRecord.EpisodeID) episodeId = objRecord.RealEpisodeID
	s docId = objRecord.ChartItemID
	s:$IsObject(objRecord.ChartItemID) docId = objRecord.RealChartItemID
	s num = objInstance.ListNo
	s templateId = objInstance.TemplateID
	s:$IsObject(objInstance.TemplateID) templateId = objInstance.RealTemplateID
	//w templateId_"^"_objInstance.TemplateVersion_"^"_episodeId_"^"_docId_"^"_num_"^"_AInstanceDataID,!
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") chkRet
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") chkRet
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	q:(objTemplate = "") chkRet
	
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(episodeId,docId,num)
	s status = $p(log,"^",11)
	s chartItemType = objInstance.TheECRecord.ChartItemType
	//s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(episodeId,docId,num)
	//下面这个参数用于电子病历的提示信息，对于归档没有用，为兼容保留
	s waitTitleCode = objInstance.TitleCode
	s:(waitTitleCode = "") waitTitleCode = $zcvt(chartItemType,"U")
	//w hasSign_"^"_waitTitleCode
	//w ##Class(EMRservice.BL.BLTemplateSign).GetPatientPDFSignWaitStatus(151,81,"Single","PATIENT",1,5759456,277,1,"6051612||1")
	//if (##Class(EMRservice.SystemParameter).IsPatientSignPDF() = "Y") {  //普仁设置的Y
		/*s patientwait = ##Class(EMRservice.BL.BLTemplateSign).GetPatientPDFSignWaitStatus(templateId,objInstance.TemplateVersion,waitTitleCode,"PATIENT",hasSign,episodeId,docId,num,AInstanceDataID)
		//w patientwait,!
		//s:(patientwait=0) chkRet = 1
		s:(patientwait=1) chkRet = 0*/
		s pdfstatus = ##class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(AInstanceDataID,AEpisodeID)
		s:(pdfstatus = "SIGNED") chkRet = "1"
		s tver = ""
		for {//^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," 78",28," MULTIPLE"," PATIENT"," Y"," PATIENTSIGN",7)
			s tver = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_templateId,tver))
			q:(tver = "")
			q:(objInstance.TemplateVersion < tver)
			//w tver
			if ($o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceAction"," "_templateId,tver," "_waitTitleCode," PATIENT"," Y","")) '= "") {
				s:(##class(%Dictionary.CompiledClass).%ExistsId("EMRservice.BL.BLPDFAuditSignLog") = "0") chkRet = "N"
				s:(##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLPDFAuditSignLog||GetPDFStatus") = "0") chkRet = "N"
				s chkRet = 0
				s pdfstatus = ##class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(AInstanceDataID,AEpisodeID)
				s:(pdfstatus = "SIGNED") chkRet = "1"
			} else {
				s chkRet = 0
			}
		}
	//}
	//s:((hasSign=1)&&(patientwait=0)) chkRet = N
	q chkRet
}

ClassMethod GetSignedPDFBase64Stream(AEpisodeID As %String, AInstanceDataID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s streamObj = ##class(EMRservice.HISInterface.CentralizedPrint).GetSignedPDFBase64Stream(AEpisodeID,AInstanceDataID)
	q:(streamObj = "") ""
	//s ret = streamObj.Read()
	q streamObj
}

}
