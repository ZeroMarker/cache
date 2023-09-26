Class EPRservice.Quality.BOQualityService Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

Parameter SERVICENAME = "QualityService";

ClassMethod GetQuaExamResult(job As %String) As EPRservice.dataset.EQualityExamDataSet [ WebMethod ]
{
 	s result=##class(EPRservice.dataset.EQualityExamDataSet).%New()
 	d result.SetArgs(job)
 	q result
}

ClassMethod CheckTemplate(TemplateID As %String, EpisodeID As %String) As %String [ WebMethod ]
{
 	//备注：由检查模板和患者调整为只检查患者,将患者本次就诊所有触犯质控条目均放入临时globals 
	s ExamRuleRowid=""
 	s ExamRuleRowid=##class(EPRmeta.SysOption).GetOptionValueByName("EPRExamRuleDr")	
 	q:ExamRuleRowid="" $j
 
 	//增加检测电子病历运行态病历质控监测标准作用范围
 	s EPRExamRuleTIDList=##class(EPRmeta.SysOption).GetOptionValueByName("EPRExamRuleTIDList")	
 	q:EPRExamRuleTIDList="" $j
 
 	//当传入的TemplateID不包含在"电子病历运行态病历质控监测标准作用范围"内时，不进行质控规则检测.
 	q:('(+($f(EPRExamRuleTIDList,"^"_TemplateID_"^"))>0)) $j

 	s aTable=""
 	
 	//如果是医政组的质控
 	//s aTable=##class(%Dictionary.CompiledClass).%OpenId("web.DHCWMRQuality.BOInterfaceEPR")
 	//如果是电子病历的质控
 	s aTable=##class(%Dictionary.CompiledClass).%OpenId("EPRservice.Quality.BORunTimeQuality")
 	if (aTable'="")
 	{
	 	//如果是医政组的质控
	 	//Set strJob=##class(web.DHCWMRQuality.BOInterfaceEPR).GetRunTimeQuality(ExamRuleRowid,EpisodeID)
	 	//如果是电子病历的质控
	 	Set strJob=##class(EPRservice.Quality.BORunTimeQuality).GetRunTimeQuality(ExamRuleRowid,EpisodeID)
	 }
 	else
 	{
	 	s strJob=$j
	 }
	q strJob
}

ClassMethod QuaSendMsgToUser(strMsg As %String, UserDr As %String) As %String [ WebMethod ]
{
	//Set outstr=##class(EPRmeta.Quality.QualityExamSet).QuaSendMsgToUser(strMsg,UserDr)
	//Do result.SetArgs(strMsg,UserDr)
	s outstr=""
 	q outstr
}

/// 取得模板和操作对应的质控标准的类型，即是否允许操作继续进行 gaojb 20090525
/// 参数：argTemplateId--模板Id； argEventType--事件类型，Save（保存），Print（打印）
/// 返回值：0--不能继续操作; 1--可以继续操作
ClassMethod GetControlType(argTemplateId As %String, argEventType As %String) As %String [ WebMethod ]
{
	;s ^gjbtest("GetControlType")=argTemplateId_"--"_argEventType
	s result=""
	//如果是医政组的质控
	//s result=##class(web.DHCWMRQuality.BOInterfaceEPR).GetControlType(argTemplateId,argEventType)
	//如果是电子病历的质控
	s result=##class(EPRservice.Quality.BORunTimeQuality).GetControlType(argTemplateId,argEventType)
	q result
}

/// Desc:	执行质控标准的检查
/// Input:	argEpisodeID--病人就诊Id； argEventType--事件类型，argTemplateID--模板ID, argInstanceIDs--病历数据id（普通模板打印时为空，其它情况均不为空）
/// Return:	存储质控检查结果的临时globa的节点值
/// Debug:	w ##Class(EPRservice.Quality.BOQualityService).GetRunTimeQuality()
ClassMethod GetRunTimeQuality(argEpisodeID As %String, argEventType As %String, argTemplateID As %String, argInstanceIDs As %String, argPrintTemplateDocId As %String) As %String [ WebMethod ]
{
	;s ^gjbtest("GetRunTimeQuality")=argEpisodeID_"--"_argEventType_"--"_argTemplateID_"--"_argInstanceIDs
	q:((argEpisodeID="")||(argEventType="")||(argTemplateID="")) ""
	
	s $zt = "finally"
	s result = ""
	//s ^CacheTempEPRQ("args",argEpisodeID,argEventType)=argEpisodeID_"--"_argEventType_"--"_argTemplateID_"--"_argInstanceIDs_"--"_argPrintTemplateDocId
	
	//如果是医政组的质控
	//s result=##class(web.DHCWMRQuality.BOInterfaceEPR).GetRunTimeQualityNew(argEpisodeID,argTemplateID,argEventType,argInstanceIDs)
	//如果是电子病历的质控
	s result = ##Class(EPRservice.Quality.BORunTimeQuality).GetRunTimeQuality(argEpisodeID,argTemplateID,argEventType,argInstanceIDs,argPrintTemplateDocId)
	
	q result
	
finally
	q ""
}

/// Desc:	判断当前就诊病历是否已归档, 归档策略为出院患者出院超过指定的天数后即认为已归档;
/// Input:	AEpisodeID为当前就诊号;
/// Return:	isArchived=1为已归档;isArchived=0为未归档;
/// Debug:	w ##Class(EPRservice.Quality.BOQualityService).CheckArchived(2419520)
ClassMethod CheckArchived(AEpisodeID As %String) As %Integer
{
	s isArchived = 0
	s HasSecondRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","HasSecondPhase",""))
	q:(+HasSecondRowID = 0) isArchived
	s HasSecond = $list($g(^DHCEPRM.QualityParamsD(HasSecondRowID)),2) 
	q:(HasSecond = "")||(HasSecond = "N") isArchived
	s ParamID = +$o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
	if (ParamID '= "")
	{
		s HISDischTime = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityParamValue(AEpisodeID,"HISDischTime")
		s DisDateTime = $p(HISDischTime,"^",2)
		if (DisDateTime '= "")
		{
			s Days = +$list($g(^DHCEPRM.QualityParamsD(ParamID)),2)
			s DisDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(DisDateTime)
			s DisDate = $p(DisDateTime," ",1)
			s DisTime = $p(DisDateTime," ",2)
			s CurDate = $p($h," ",1)
			s CurTime = $p($h," ",2)
			if (CurDate-DisDate >= Days) 
			{
				s isArchived = 1	
			}	
		}	
	}
	q isArchived
}

}
