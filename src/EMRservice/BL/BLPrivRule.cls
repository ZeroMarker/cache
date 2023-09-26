Class EMRservice.BL.BLPrivRule Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Code:%String,Valid:%String,PrivRuleTypeDR:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_PrivRule_SELECTALL, SqlProc ]
{
 	SELECT ID,Name, Code, Valid,PrivRuleTypeDR
 	FROM EMRmeta.PrivRule
 	ORDER BY ID
}

/// Desc:           脚本计算逻辑
/// Modifier:       Candy
/// ModifyDateDime: 2015-3-9
/// InPut:          argoperators 操作符集合
///                 argEnviromentInfo 方法参数(userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67)
///                 argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// OutPut:         result  view^1!save^1!print^1!residentcheck^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0
ClassMethod ParsePrivRuleLogic(argoperators As %String, argEnviromentInfo As %String, argCode As %String) As %String
{
	s result = ""
	q:(argoperators = "")||(argEnviromentInfo = "")||(argCode = "")||(argCode = $c(0)) result
	
	s @argoperators
	s ruleCodes = argCode
	for i=1:1:$l(ruleCodes,$c(10)) {
		s aRuleCode = $p(ruleCodes,$c(10),i)
		continue:(($e(aRuleCode,1,2)="//")||(aRuleCode=""))	
		s finalCode = ""
		s ruleSegmentsCount = $l(aRuleCode,"$$")		
		if (ruleSegmentsCount<2) 
		{
			s finalCode = aRuleCode
		}
		else 
		{
			for j=1:1:ruleSegmentsCount 
			{
				if ((j#2)'=0) 
				{
					s finalCode = finalCode_$p(aRuleCode,"$$",j)
				}
				else 
				{
					;s finalCode = finalCode_""""_..ReplaceFunction($p(aRuleCode,"$$",j),argEnviromentInfo)_""""
					//脚本中"$$GetAppoint$$"脚本内容的返回值不能有双引号，否则会导致脚本校验失败，脚本不起作用  -- modify by 牛才才
					if ($p(aRuleCode,"$$",j) = "GetAppoint")
					{
						s finalCode = finalCode_..ReplaceFunction($p(aRuleCode,"$$",j),argEnviromentInfo)
					}
					else
					{
						s finalCode = finalCode_""""_..ReplaceFunction($p(aRuleCode,"$$",j),argEnviromentInfo)_""""
					}
				}
			}
		}
		x finalCode
	}
	for i=1:1:$l(argoperators,",")
	{
		s:(i '= 1) result = result_"!"
		s operator = $p($p(argoperators,",",i),"=",1)
		s result = result_operator_"^"_@operator
	}	
	q result
}

/// Desc:           运行权限脚本方法
/// Modifier:       Candy
/// ModifyDateDime: 2015-3-9
/// InPut:          argNominalFunc 脚本函数
///                 argEnviromentInfo 方法参数(userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67)
/// OutPut:         函数值
ClassMethod ReplaceFunction(argNominalFunc As %String, argEnviromentInfo As %String) As %String
{
	s execCode = "",envInfoName = "",envInfoData = ""
	s envInfoList = ..ParseEnvInfo(argEnviromentInfo,.envInfoName,.envInfoData)
	s userid = $lg(envInfoData,$lf(envInfoName,"userid"))
	s userloc = $lg(envInfoData,$lf(envInfoName,"userloc"))
	s ssgroupid = $lg(envInfoData,$lf(envInfoName,"ssgroupid"))
	s admid = $lg(envInfoData,$lf(envInfoName,"admid"))
	s patientid = $lg(envInfoData,$lf(envInfoName,"patientid"))
	s instanceid = $lg(envInfoData,$lf(envInfoName,"instanceid"))
	s docid = $lg(envInfoData,$lf(envInfoName,"docid"))
	s:(docid = "") docid = ..GetDocIDByInstanceID(instanceid)
	s templateid = $lg(envInfoData,$lf(envInfoName,"templateid"))
	s:(templateid = "") templateid = ..GetTemplateIDByInstanceID(instanceid)
	s sessionID = $lg(envInfoData,$lf(envInfoName,"sessionid"))	
	s titlename = $lg(envInfoData,$lf(envInfoName,"titlename"))
	s:(titlename = "") titlename = ..GetTitleNameByInstanceID(instanceid)
	s titleCode = $lg(envInfoData,$lf(envInfoName,"titleCode"))
	s createDataTime = $lg(envInfoData,$lf(envInfoName,"createDateTime"))
	//取登录医生的职称
	s Ctctp=""
	s Ctctp=##Class(EMRservice.BOPrivAssist).GetCTCPT(userid)
	
	//用户是否为患者的主管医生
    if argNominalFunc = "BelongToMe" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongDoc("_admid_","_userid_")"}
    
    //用户是否为指定患者主管医生的上级医生
	elseif argNominalFunc = "BelongToSubdoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongSubDocs("_admid_","_userid_")"}
    
    //病人是否属于科室
	elseif argNominalFunc = "BelongToLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToLoc("_admid_","_userloc_")"}
    
 	//病人是否属于相关科室
	elseif argNominalFunc = "BelongToLinkLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToLinkLoc("_admid_","_userloc_")"}   
    
 	//病历是否转移到用户登录科室
	elseif argNominalFunc = "BelongTransLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongTransLoc("_admid_","_userloc_")"}   
    
	//用户是否属于病区
	elseif argNominalFunc = "BelongToWard" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToWard("_admid_","_userloc_")"}    
    
 	//病人是否已出院
	elseif argNominalFunc = "IsDisCharge" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDisCharge("""_admid_""")"}   
    
 	//是否住院病人(原意是病人需要写病历，门诊或退院病人不需要写病历)
	elseif argNominalFunc = "PatNeedDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).PatNeedDoc("""_admid_""")"} 
	
	//用户是否为医生
	elseif argNominalFunc = "UserIsDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).UserIsDoc("""_userid_""")"}   
    
	//病人是否门诊病人
	elseif argNominalFunc = "OutPatient" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOutPatient("""_admid_""")"}
	
	//病人是否急诊病人
	elseif argNominalFunc = "EPatient" {s execCode="result=##class(EMRservice.BOPrivAssist).IsEPatient("""_admid_""")"}
	
	//病历是否为登录用户创建
	elseif argNominalFunc = "RecBelongToMe" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecBelongDoc("""_admid_""","""_instanceid_""","""_userid_""")"}	

	//病历是否保存
    elseif argNominalFunc = "IsSaved" {s execCode = "result=##class(EMRservice.BOPrivAssist).IsRecordInstanceSaved("""_instanceid_""")"}

	//病历是否打印
	elseif argNominalFunc = "IsPrinted" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordActioned("""_admid_""","""_instanceid_""",""Print"")"}
	
	//病历是否打印24小时
	elseif argNominalFunc = "Is24Printed" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordprinted("""_admid_""","""_instanceid_""",""Print"")"}
	
	//病历是否全部完成
	elseif argNominalFunc = "IsRecordCompleted" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordCompleted("""_admid_""")"}
	
	//病历是否住院医师审核
	elseif argNominalFunc = "IsResidentChecked" {s execCode="result=##class(EMRservice.BOPrivAssist).IsResidentChecked("""_admid_""","""_instanceid_""")"}
	
	//病历已主治医师审核
	elseif argNominalFunc = "IsAttendingChecked" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAttendingChecked("""_admid_""","""_instanceid_""")"}
	
	//病历已主任医师审核 
	elseif argNominalFunc = "IsChiefChecked" {s execCode="result=##class(EMRservice.BOPrivAssist).IsChiefChecked("""_admid_""","""_instanceid_""")"}

	//用户是否为病历创建人的上级医生
	elseif argNominalFunc = "IsUpUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsUpUser("""_admid_""","""_instanceid_""","""_userid_""")"}	

	//用户是否为病历操作者的上级医生
	elseif argNominalFunc = "IsUpLevelUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsUpLevelUser("""_admid_""","""_instanceid_""","""_userid_""")"}
	
	//用户是否为病历创建者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
	elseif argNominalFunc = "IsCreatorUpUserByGroup" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreatorUpUserByGroup("""_admid_""","""_instanceid_""","""_userid_""")"}
	
	//用户是否为病历操作者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
	elseif argNominalFunc = "IsOperateorUpUserByGroup" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOperateorUpUserByGroup("""_admid_""","""_instanceid_""","""_userid_""")"}
	
	//用户是否为病历创建者的上级医师(取HIS医疗组)
	elseif argNominalFunc = "IsCreatorUpUserByHISGroup" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreatorUpUserByHISGroup("""_instanceid_""","""_userid_""")"}
	
	//用户是否为病历操作者的上级医师(取HIS医疗组)
	elseif argNominalFunc = "IsOperaterUpUserByHISGroup" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOperaterUpUserByHISGroup("""_instanceid_""","""_userid_""")"}
	
	//取当前文档TemplateID
	elseif argNominalFunc = "TemplateID" {q templateid}
	
	//取当前文档TitleCode
	elseif argNominalFunc = "TitileCode" {s execCode="result=##class(EMRservice.BOPrivAssist).GetTitleCodeByInstanceID("""_instanceid_""")"}
	
	//患者是否出院超过2天
	elseif argNominalFunc = "IsDischargedTwoDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHours("""_admid_""",48)"}
	
	//患者是否出院超过3天
	elseif argNominalFunc = "IsDischargedThreeDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHours("""_admid_""",72)"}

	//患者是否出院超过5天
	elseif argNominalFunc = "IsDischargedFiveDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHours("""_admid_""",120)"}
	
	//患者是否出院超过7天
	elseif argNominalFunc = "IsDischargedSevenDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHours("""_admid_""",168)"}
	//患者是否已出院5个工作日
	elseif argNominalFunc = "IsDisFiveWorkDay" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsDisFiveWorkingDay("""_admid_""")"}
	
	//患者是否已出院7个工作日
	elseif argNominalFunc = "IsDisSevenWorkDay" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsDisSevenWorkingDay("""_admid_""")"}
	
	
	//急诊患者是否出院超过2天
	elseif argNominalFunc = "EPLeaveOver48Hours" {s execCode="result=##class(EMRservice.BOPrivAssist).EPLeaveOver48Hours("""_admid_""",48)"}
	
	//病案室是否将病历回收
	elseif argNominalFunc = "IsRecordRetrieve" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordRetrieve("""_admid_""")"}
	
	//病案室是否已将病历归档
	elseif argNominalFunc = "IsRecordArchived" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordArchived("""_admid_""")"}
	
	//病案室是否复印病历
	elseif argNominalFunc = "IsCopy" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCopy("""_admid_""")"}
	
	//出院日期(医生医疗结算,格式yyyy-mm-dd)
	elseif argNominalFunc = "DisDateByDoctor" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDisDate("""_admid_""",""ByDoctor"")"}
	
	//出院日期(护士最终结算,格式yyyy-mm-dd) 
	elseif argNominalFunc = "DisDateByNurse" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDisDate("""_admid_""",""ByNurse"")"}
	
	//入院时间间隔(单位:小时)
   	elseif argNominalFunc = "AdmTimeGap" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAdmTimeGap("_admid_")"}
	
	//出院时间间隔(单位:小时)
	elseif argNominalFunc = "DisTimeGap" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDisTimeGap("_admid_")"}
	
	//入院时间间隔[护士分床时间](单位:小时)
   	elseif argNominalFunc = "AdmTimeInBedGap" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAdmTimeInBedGap("_admid_")"}
	
	//入院时间间隔[护理组体温单记录的入院时间](单位:小时)
   	elseif argNominalFunc = "InhsAdmTimeGap" {s execCode="result=##class(EMRservice.BOPrivAssist).GetInhsAdmTimeGap("_admid_")"}

	//判断病人当前是否已出院[1-已出院,0-在院]
	elseif argNominalFunc = "IsPatientDischarge" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatientDischarge("_patientid_")"}
	
	///取创建者的安全组ID
	elseif argNominalFunc = "CreaterGroupID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCreaterGroupID("""_instanceid_""")"}
	
	///取最后一次操作者的安全组ID  
	elseif argNominalFunc = "LastModifierGroupID" { s execCode="result=##class(EMRservice.BOPrivAssist).GetLastModifierGroupID("""_instanceid_""")"}
	
	//获取病历授权功能赋予的操作权限 liuzhongwan 增加一个入参DocID
	elseif argNominalFunc = "GetAppoint" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAppiont("""_admid_""","""_userid_""","""_userloc_""","""_instanceid_""","""_docid_""")"}
	
	///返回用户ID 
	elseif argNominalFunc = "userid" {q userid}
	
	///返回安全组ID
	elseif argNominalFunc = "ssgroupid" {q ssgroupid}
	
	///返回科室ID
	elseif argNominalFunc = "userloc" {q userloc}
	
	///返回病人ID
	elseif argNominalFunc = "patientid" {q patientid}
		
	///返回就诊ID
	elseif argNominalFunc = "admid" {q admid}  
	
	///返回实例ID
	elseif argNominalFunc = "instanceid" {q instanceid} 
	
	///返回DocID
	elseif argNominalFunc = "docid" {q docid}
	
	//返回登录医生职称代码ID
	elseif argNominalFunc = "CTCTP" {q Ctctp}
    
    ///返回标题代码
	elseif ((argNominalFunc = "titlecode")&&(titleCode'="")) {q titleCode}

	///返回标题代码
	elseif ((argNominalFunc = "titlecode")&&(titleCode="")) {s execCode="result=##class(EMRservice.BOPrivAssist).GetTitleCode("""_instanceid_""")"}
	
	///可否复制粘贴
	elseif argNominalFunc = "CanCopyPaste"{q ##Class(EPRservice.Quality.BOUserCopyPastePower).GetUserCopyPastePower(userid)}
	
	//获取患者的当前科室id，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "GetCurrentDept" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCurrentDept("""_admid_""")"}
	
	//获取登录用户医疗小组（医疗单元）信息，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "userUnit" {s execCode="result=##class(EMRservice.BOPrivAssist).GetUserUnit("""_userloc_""","""_userid_""")"}
	
	//获取（ICU患者转入ICU之前科室的主管医生）医疗小组（医疗单元）信息，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "BefTransToICUMainDocUnit" {s execCode="result=##class(EMRservice.BOPrivAssist).GetBefTransToICUMainDocUnit("""_admid_""")"}
	
	//获取ICU患者转入ICU之前的科室信息，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "LocBefTransToICU" {s execCode="result=##class(EMRservice.BOPrivAssist).GetLocBefTransToICU("""_admid_""")"}
	
	//取手术病历术者
	elseif argNominalFunc = "GetOperationUser" {s execCode="result=##class(EMRservice.BOPrivAssist).GetOperationUser("""_instanceid_""")"}
	
	//取手术病历一助
	elseif argNominalFunc = "GetOperationAssistFirst" {s execCode="result=##class(EMRservice.BOPrivAssist).GetOperationAssistFirst("""_instanceid_""")"}

	//患者医嘱表是否被锁定
	elseif argNominalFunc = "OrdHasLocked" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOrdHasLocked("""_admid_""","""_userid_""","""_userloc_""","""_sessionID_""")"}

	//病历是否超时未完成  add by niucaicai 2016-08-31
	elseif argNominalFunc = "IsRecordOverRan" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordOverRan("""_instanceid_""")"}
	
	//青医判断是否可确认病历全部完成，即“送病案室”（只有做了最终结算才可确认病历全部完成）
	elseif argNominalFunc = "IsDocCommit" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDocCommit("""_admid_""")"}
	
	//无纸化医生病历是否提交
	elseif argNominalFunc = "MRstatus" {s execCode="result=##class(DHCEPRFS.BL.BLPrivilege).CheckDoc("""_admid_""")"}
	
	//病历是否有有效签名(任何级别都可以)  add by yan 2017-07-31
	elseif argNominalFunc = "HasValidSign" {s execCode="result=##class(EMRservice.BOPrivAssist).HasValidSign("""_instanceid_""")"}
	
	//转科时间间隔(单位:小时)
   	elseif argNominalFunc = "TransCTLOCGap" {s execCode="result=##class(EMRservice.BOPrivAssist).GetTransCTLOCGap("""_admid_""")"}
   	
   	//该科室是否为转科前科室
   	elseif argNominalFunc = "IsTransPreviousCTLOC" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTransPreviousCTLOC("""_admid_""","""_userloc_""")"}
   	
   	//用户是否为病历最后操作者
	elseif argNominalFunc = "IsOperateor" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOperateor("""_admid_""","""_instanceid_""","""_userid_""")"}
	
	//用户是否为病历操作者的HIS医疗组组长
	elseif argNominalFunc = "IsOperaterHISGroupLeader" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOperaterHISGroupLeader("""_instanceid_""","""_userid_""")"}
	
	//当前科室是否为检查检验病理医嘱接收科室
   	elseif argNominalFunc = "IsAdmRecDep" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmRecDep("""_admid_""","""_userloc_""")"}
   	
   	//该用户是否为患者的会诊医生
   	elseif argNominalFunc = "IscoustUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IscoustUser("""_admid_""","""_userid_""")"}

    	//患者是否有传染病未上报(未上报不能书写病历)
	elseif argNominalFunc = "IsEpdReport" {s execCode="result=##class(EMRservice.BOPrivAssist).IsEpdReport("""_admid_""")"}
 
	//当前科室是否为会诊科室
   	elseif argNominalFunc = "IsAdmConsultDep" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmConsultDep("""_admid_""","""_userloc_""")"}
 
    	//该用户是否为主刀医生
   	elseif argNominalFunc = "IsAdmOperInfo" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmOperInfoForEMR("""_admid_""","""_userid_""")"}
   
    	//护士确认病历是否完成
 	elseif argNominalFunc = "IsFinalNurseFlag" {s execCode="result=##class(EMRservice.BOPrivAssist).IsFinalNurseFlag("""_admid_""")"}
   
    	//是否当前用户为患者历次就诊中门诊就诊的接诊医师
	elseif argNominalFunc = "IsOPVisitDoctor" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOPVisitDoctor("""_patientid_""","""_admid_""","""_userid_""")"}

    //要引用的病历模板版本是否为当前最新版本
 	elseif argNominalFunc = "IsLatestVersion" {s execCode="result=##class(EMRservice.BOPrivAssist).IsLatestVersion("""_instanceid_""")"}
 
 	//要引用的病历就诊时间间隔(单位:小时)
   	elseif argNominalFunc = "OpHistoryAdmTimeGap" {s execCode="result=##class(EMRservice.BOPrivAssist).GetOpHistoryAdmTimeGap("""_instanceid_""")"}
    
    //指定模板控制当前模板是否可创建(例如：放疗观察表已经写完才可以创建放疗观察表续页)
	elseif argNominalFunc = "CanCreateByFisrtRecord" {s execCode="result=##class(EMRservice.BOPrivAssist).CanCreateByFisrtRecord("_admid_","_docid_")"}
	
	//是否触犯质控中的创建标准
	elseif argNominalFunc = "IsCreateDocQuality" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCreateDocQualityList("""_admid_""","""_templateid_""","""_titlename_""")"}
	
	//病人是否在当前科室就诊过
	elseif argNominalFunc = "RecentAdmBelongToLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatRecentAdmBelongToLoc("_patientid_","_userloc_")"}
	
	//患者手工质控条目是否完成
 	elseif argNominalFunc = "GetMessageFlagByEpisodeID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetMessageFlagByEpisodeID("""_admid_""")"}
	
 	//取病历创建者
   	elseif argNominalFunc = "RecCreator" {s execCode="result=##class(EMRservice.BOPrivAssist).GetRecCreator("""_instanceid_""")"}
 	
 	//登录用户是否为病历的签名医师
	elseif argNominalFunc = "IsRecSignUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecSignUser("""_instanceid_""","""_userid_""")"}	
	
	//是否为创建者的上级医师（取his的维护程序,安医附院，不分医疗组）
	elseif argNominalFunc = "IsCreatorUpUserByHISAY" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreatorUpUserByHISAY("""_instanceid_""","""_userid_""")"}
    
    //获取自动审批次数
    elseif argNominalFunc = "AutoApplyCount" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAutoApplyCount("""_instanceid_""","""_userid_""")"}

	//获取依据患者当前就诊，判定浏览选中就诊是否可以显示
    elseif argNominalFunc = "IsSameUserLocTypeWithSelEpisode" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSameUserLocTypeWithSelEpisode("""_userloc_""","""_admid_""")"}
	
	//获取日志打印操作用户的默认安全组数据
	elseif argNominalFunc = "getActionOperUserSSGroupID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetActionOperUserSSGroupID("""_admid_""","""_instanceid_""",""Print"")"}

	//病历是否封存
	elseif argNominalFunc = "IsSealed" {s execCode = "result=##class(EMRservice.BOPrivAssist).IsRecordInstanceSealed("""_admid_""","""_instanceid_""")"}

	//门诊历史病历，要引用的病历是否为当前就诊类型
	elseif argNominalFunc = "IsBelongToCurrentAdmType" {s execCode="result=##class(EMRservice.BOPrivAssist).IsBelongToCurrentAdmType("""_admid_""","""_instanceid_""")"}
	
	//病历是否与输血申请单关联
    elseif argNominalFunc = "IsLinkBlood" {s execCode = "result=##class(EMRservice.BOPrivAssist).IsLinkBlood("""_instanceid_""")"}
    
    //病历是否有住院及以上级别签名（EMRmeta.SignRole的RoleLevel大于0）
    elseif argNominalFunc = "HasAboveResidentLevelSign" {s execCode = "result=##class(EMRservice.BOPrivAssist).HasAboveResidentLevelSign("""_instanceid_""")"}
    
    //用户是否为病历创建者的上级医师(取HIS，不分医疗组)
	elseif argNominalFunc = "IsCreatorUpUserByHIS" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreatorUpUserByHIS("""_instanceid_""","""_userid_""")"}

	//病历是否有有效的患者签名
	elseif argNominalFunc = "HasValidAnySign" {s execCode="result=##class(EMRservice.BOPrivAssist).HasValidAnySign("""_instanceid_""")"}

	//转科患者，病历HappenDateTime时刻科室与当前登录科室是否一致。 非转科患者默认1。
	elseif argNominalFunc = "IsSameLocInstanceWithUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSameLocInstanceWithUser("""_instanceid_""","""_userloc_""")"}
	
	//病历HappenDateTime时刻所在科室ID
	elseif argNominalFunc = "LocIDAtInstanceFinish" {s execCode="result=##class(EMRservice.BOPrivAssist).GetLocIDAtInstanceFinish("""_instanceid_""")"}
	
	//IsCrossDay 是否是就诊当天创建的病历
	elseif argNominalFunc = "IsCrossDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCrossDay("""_admid_""","""_instanceid_""")"}
	
	//IsPatientBrowse 患者是否看过病历
	elseif argNominalFunc = "IsPatientBrowse" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatientBrowse("""_instanceid_""")"}
	
	//当前病历是否为质控回退病历
	elseif argNominalFunc = "GetGrantInstanceID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetGrantInstanceID("""_admid_""","""_instanceid_""")"}

	
	//安医附院 
	//患者是否已经护士结算 ##Class(EMRservice.BOPrivAssist).ISDisNurse(2)
   	elseif argNominalFunc = "ISDisNurse" {s execCode="result=##class(EMRservice.BOPrivAssist).ISDisNurse("""_admid_""")"}
 	
        //是否为新冠状病毒患者
   	elseif argNominalFunc = "CheckIsXGFluByAdm" {s execCode="result=##class(EMRservice.BOPrivAssist).CheckIsXGFluByAdm("""_admid_""")"}
   
   	//用户是否为病历的当前签名人
	elseif argNominalFunc = "IsCreaterAndUpUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreaterAndUpUser("""_admid_""","""_instanceid_""","""_userid_""")"}
	
	//病历是否本人创建
	elseif argNominalFunc = "IsCreator" {s execCode="result=##class(EMRservice.BOPrivAssist).GetIsCreator("""_instanceid_""","""_userid_""")"}	

	elseif argNominalFunc = "IsCanViewRecord" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCanViewRecord("""_patientid_""","""_userloc_""","""_admid_""")"}

	//实习医生不签名不能打印病历
    	elseif argNominalFunc = "IsPractice" {s execCode = "result=##class(EMRservice.BOPrivAssist).IsPractice("""_userid_""")"}
	
	//判断是否未转科前科室
   	elseif argNominalFunc = "IsTransPreDept" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTransPreDept("""_admid_""","""_userloc_""")"}
		
	//判断docid是否在知情告知书目录下
	elseif argNominalFunc = "IsZQRecordCategory" {s execCode="result=##class(EMRservice.BOPrivAssist).IsZQRecordCategory("""_docid_""")"}
	
	//门诊病历取患者最新一次就诊的当前时间减去就诊时间是否大于24小时
 	elseif argNominalFunc = "GetAdmOutStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAdmOutStatus("""_admid_""")"}	
 	
	elseif argNominalFunc = "IsDischargedNWordHours" {s execCode = "result=##class(EMRservice.BOPrivAssist).IsDischargedNWordHours("""_admid_""",72)"}
	//定位1 
	//是否通过转院审核
    	elseif argNominalFunc = "TransApprovePass" {s execCode = "result=##class(EMRservice.BOPrivAssist).TransApprovePass("""_admid_""")"}
	
	//门诊病历是否被当前用户创建
    	elseif argNominalFunc = "CreateOPRecordByUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreateOPRecordByUser("""_admid_""","""_userid_""","""_docid_""")"}

	//患者是否已死亡
    	elseif argNominalFunc = "IsPatDeath" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatDeath("""_admid_""")"}
	
	//门诊病历是否被当前用户创建
    	elseif argNominalFunc = "CreateOPRecordByUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreateOPRecordByUser("""_admid_""","""_userid_""","""_docid_""")"}

    	//急诊病人是否留察
   	elseif argNominalFunc = "ISEMRJZLC" {s execCode="result=##class(EMRservice.BL.opInterfaceBase).ISEMRJZLC("""_admid_""")"}
 
    	/////感染二门诊患者和VIP患者的病历只能指定用户查看,1受限，0不受限
   	elseif argNominalFunc = "ISCheckAccessLevel" {s execCode="result=##class(web.DHCBaseConfig).CheckAccessLevel("""_admid_""","""","""_userid_""")"}
    
    	////是否有通过会诊获得的病历查看权限 DHC_EmConsEmrAut
   	elseif argNominalFunc = "ISEmConsEmrAut" {s execCode="result=##class(web.DHCBaseConfig).EmConsEmrAut("""_admid_""","""_userloc_""")"}
    
    	////返回模板的前两级目录ID
   	elseif argNominalFunc = "Template2ParentID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetTemplate2ParentID("""_templateid_""")"}
    
    	//是否急诊病人
   	elseif argNominalFunc = "IsEmerPatient" {s execCode="result=##class(EMRservice.BOPrivAssist).IsEmerPatient("""_admid_""")"}

    	//是否门诊病人 (单纯的门诊就诊病人，不包括急诊)
   	elseif argNominalFunc = "IsOutPatientReal" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOutPatientReal("""_admid_""")"}

	//是否是病历签名者
	elseif argNominalFunc = "ISCurUserSign" {s execCode="result=##class(EMRservice.BOPrivAssist).ISCurUserSign("""_instanceid_""")"}
    	//病历是否签字
	elseif argNominalFunc = "IsChecked" {s execCode="result=##class(EMRservice.BOPrivAssist).IsResidentChecked("""_admid_""","""_instanceid_""")"}

    	//用户是否为指定患者主管医生的上级医生(取护士分床界面的三级医师)
	elseif argNominalFunc = "IsPatBelongSubDocsNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongSubDocsNew("""_admid_""","""_userloc_""","""_userid_""")"}
	
    	//【门诊】入院患者是否填写了【入院新冠肺炎筛查调查表】病历
   	elseif argNominalFunc = "ISEMRLXBXS" {s execCode="result=##class(EMRservice.BOPrivAssist).ISEMRLXBXS("""_admid_""")"}
	
    	////返回模板的上级目录ID
   	elseif argNominalFunc = "Template1ParentID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetTemplate1ParentID("""_templateid_""")"}
	
    	/// 判断就诊记录是否结算
   	elseif argNominalFunc = "CheckIPPay" {s execCode="result=##class(EMRservice.BOPrivAssist).CheckIPPay("""_admid_""")"}
	
	/// 病案首页是否传送病案编目
   	elseif argNominalFunc = "IsRecordToCatalog" {s execCode="result=##class(EMRservice.BOPrivAssist).GetRecordToCatalog("""_admid_""")"}
	//病历是否医务部控制不允许修改 panyan2021-11-29
	elseif argNominalFunc = "ISYWControl" {s execCode="result=##class(EMRservice.BOPrivAssist).ISYWControl("""_admid_""","""_instanceid_""")"}
	//患者是否有第一次修正诊断
	elseif argNominalFunc = "HasModDiag1" {s execCode="result=##Class(EMRservice.BOPrivAssist).HasModDiagByNum("""_admid_""",1)" }

	//是否男性患者
	elseif argNominalFunc = "IsMan" {s execCode="result=##class(EMRservice.BOPrivAssist).IsMan("""_admid_""")"}
	
	//是否男性患者
	elseif argNominalFunc = "Islock" {s execCode="result=##class(EMRservice.BOPrivAssist).IsLock("""_admid_""","""_templateid_""")"}
	
	//是否提交首页
	elseif argNominalFunc = "IsCommitSY" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsCommitSY("""_admid_""")"}

	//门诊病历是否被自助机打印
	elseif argNominalFunc = "HasOPPrintByZZJ" {s execCode="result=##class(EMRservice.BOPrivAssist).HasOPPrintByZZJ("""_instanceid_""")"}

	//当前登录用户是否为创建者的下级医师
	elseif argNominalFunc = "IsCreatorLowUserBySignRoleLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreatorLowUserBySignRoleLevel("""_admid_""","""_instanceid_""","""_userid_""")"}

	//当前病历是否被上级医生签名
	elseif argNominalFunc = "IsHasSignByUp" {s execCode="result=##class(EMRservice.BOPrivAssist).IsHasSignByUp("""_instanceid_""")"}

	//当前登录用户级别是否小于当签病历最高级别
	elseif argNominalFunc = "IsSignTopLevl" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSignTopLevl("""_instanceid_""","""_userid_""")"}
	
	//当前患者是否为急诊留观患者
	elseif argNominalFunc = "IsOStayStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOStayStatus("""_admid_""")"}
	
	//当前患者是否已经首次分床
	elseif argNominalFunc = "IsInBed" {s execCode="result=##class(EMRservice.BOPrivAssist).IsInBed("""_admid_""")"}
	
	//转科患者，病历HappenDateTime时刻科室与当前登录科室是否一致。 非转科患者默认1。
	elseif argNominalFunc = "IsSameLocInstanceWithUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSameLocInstanceWithUser("""_instanceid_""","""_userloc_""","""_userid_""")"}
	
	//病历HappenDateTime时刻所在科室ID
	elseif argNominalFunc = "LocIDAtInstanceFinish" {s execCode="result=##class(EMRservice.BOPrivAssist).GetLocIDAtInstanceFinish("""_instanceid_""")"}
	
	//患者是否死亡超过2天
	elseif argNominalFunc = "IsDeadTwoDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDisDeadNHours("""_admid_""",48)"}
	
	//患者是否术后超过2天
	elseif argNominalFunc = "SSEndTwoDay" {s execCode="result=##class(EMRservice.BOPrivAssist).SSEndHours("""_admid_""",48)"}
	
	//患者是否术后超过2天
	elseif argNominalFunc = "GetSSEndHours" {s execCode="result=##class(EMRservice.BOPrivAssist).GetSSEndHours("""_admid_""")"}
	
	//手术申请超过24小时
	elseif argNominalFunc = "SSAPPLYHours" {s execCode="result=##class(EMRservice.BOPrivAssist).SSAPPHours("""_admid_""",24)"}
	
	//患者是否抢救医嘱超过12小时
	elseif argNominalFunc = "QJYZHours" {s execCode="result=##class(EMRservice.BOPrivAssist).QJYZHours("""_admid_""",12)"}
	

	// 职业证书编号
	elseif argNominalFunc = "CTPCPUnit" {s execCode = "result=##class(EMRservice.BOPrivAssist).GetCTPCPUnit("""_userid_""")"}
	
	//当前登陆用户是否在OA里申请了授权并且已审批不超过24小时
	elseif argNominalFunc = "HasVaildOAAppoint" {s execCode="result=##class(EMRservice.BOPrivAssist).HasVaildOAAppoint("""_userid_""","""_admid_""")"}
	
	//患者是否分配床位
	elseif argNominalFunc = "IsAEpisodeInBed" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAEpisodeInBed("""_admid_""")"}

	//可重复模板指定InstanceID的病历是否打印
	elseif argNominalFunc = "IsPrintedByInstanceID" {s execCode="result=##class(EMRservice.BOPrivAssist).HasPrintByInstanceID("""_admid_""","""_docid_""","""_instanceid_""")"}
	
	//取患者状态
	elseif argNominalFunc = "VisitStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).GetVisitStatus("""_admid_""")"}
	
	//患者医嘱表是否被锁定
	elseif argNominalFunc = "IsPowerDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).GetPowerDoc("""_admid_""","""_userid_""")"}
	
	//取医师级别
	elseif argNominalFunc = "HasHighDocLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).HasHighDocLevel("""_admid_""","""_instanceid_""","""_userid_""")"}
	
	//判断是否签过名
	elseif argNominalFunc = "HasCommited" {s execCode="result=##class(EMRservice.BOPrivAssist).HasCommitByInstanceID("""_admid_""","""_docid_""","""_instanceid_""")"}
	
	//判断患者是否死亡并且没完成居民死亡报告卡
	elseif argNominalFunc = "HasCompleteDthRep" {s execCode="result=##class(EMRservice.BOPrivAssist).HasCompleteDthRep("""_admid_""")"}
	
	//病案室是否已装袋回收
	elseif argNominalFunc = "IsBianMu" {s execCode="result=##class(EMRservice.BOPrivAssist).IsBianMU("""_admid_""")"}
	
	//该模板是否保存过  xlq zsy add  20190311
   	elseif argNominalFunc = "HasTemSaved" {s execCode="result=##class(EMRservice.BOPrivAssist).HasTemSaved("""_admid_""")"}
	
	//用户是否有执业证书 add zsy yxp 2020-08-17
	elseif argNominalFunc = "IsRegDoctor" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRegDoctor("""_userid_""")"}
	
	//医师可以查看自己能登陆的所有科室的患者的病历
	elseif argNominalFunc = "IsHasPower" {s execCode="result=##class(EMRservice.BOPrivAssist).IsHasPower("""_admid_""","""_userid_""")"}
	
	//授权后，医师可以查看病历浏览
	elseif argNominalFunc = "HasConsult" {s execCode="result=##class(EMRservice.BOPrivAssist).HasConsult("""_admid_""","""_userid_""")"}
	
	//入院时间在某个时间点以后不允许打印病历
	elseif argNominalFunc = "AdmDateTime" {s execCode="result=##class(EMRservice.BOPrivAssist).AdmDateTime("""_admid_""")"}
	
	//“成人/儿童营养风险筛查表”是否完成
	elseif argNominalFunc = "IsUnifyScore" {s execCode="result=##class(EMRservice.BOPrivAssist).IsUnifyScore("""_admid_""")"}

	//是否是省直 和阜外的科室
	elseif argNominalFunc = "IsOtherLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOtherLoc("""_userloc_""")"}
	
	//门诊病历是否签名
	elseif argNominalFunc = "HasOPRecordSigned" {s execCode="result=##class(EMRservice.BOPrivAssist).HasOPRecordSigned("""_admid_""")"}
	
	//华西二院
	//当前科室是否为CA科室
 	elseif argNominalFunc = "IsCAloc" {s execCode="result=##Class(CA.DigitalSignatureService).IsCACTLoc("""_userloc_""")"}
 	
 	//病历是否签出
 	elseif argNominalFunc = "IsSignedOut" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSignedOut("""_admid_""")"}
 	//判断病人就诊是否为当日
 	elseif argNominalFunc = "IsCurrentVisit" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCurrentVisit("""_admid_""")"}
 	
 	//病历最外层父级目录
	elseif argNominalFunc = "TemplateCategory" {s execCode="result=##class(EMRservice.BOPrivAssist).GetTemplateCategory("""_templateid_""","""_admid_""")"}
	
	//病历最外层父级目录
	elseif argNominalFunc = "CurAdmLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCurAdmLoc("""_admid_""")"}
	
	//
	elseif argNominalFunc = "ProofCheckStatus" {s execCode="result=##class(HospModule.Entity.HXEYIllnessProof).CheckStatusByInstanceDataId("""_instanceid_""")"}
	
	//病历是否签名
	elseif argNominalFunc = "IsSigned" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSign("""_admid_""","""_instanceid_""")"}
	
	//是否总查房
	elseif argNominalFunc = "IsWardRound" {s execCode="result=##class(EMRservice.BOPrivAssist).IsWardRound("""_userid_""","""_userloc_""")"}
	
	//是否属于一个大科
	elseif argNominalFunc = "IsBelongPlat" {s execCode="result=##class(EMRservice.BOPrivAssist).IsBelongPlat("""_admid_""","""_userloc_""")"}
	
	//是否试点科室
	elseif argNominalFunc = "IsExamplCALoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsExamplCALoc("""_userloc_""")"}

    	//最后一次签名人级别
    	elseif argNominalFunc = "LastSingLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).LastSingLevel("""_instanceid_""")"}
    
    	//登录人级别
    	elseif argNominalFunc = "UserLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).UserLevel("""_userid_""")"}
	
	//是否完成接诊
	elseif argNominalFunc = "IsComplate" {s execCode="result=##class(EMRservice.BOPrivAssist).IsComplate("""_admid_""","""_instanceid_""")"}

	//华西医院
	//是否可创建抢救记录
   	 elseif argNominalFunc = "CanCreateRescueRecord" {s execCode="result=##class(EMRservice.BOPrivAssist).CanCreateRescueRecord("""_admid_""","""_templateid_""")"}
	
	//是否可创建接班记录
	elseif argNominalFunc = "isCanCarryOn" {s execCode="result=##class(EMRservice.BOPrivAssist).isCanCarryOn("""_admid_""","""_templateid_""")"}
	
	//是否可创建接收记录
	elseif argNominalFunc = "isReceive" {s execCode="result=##class(EMRservice.BOPrivAssist).isReceive("""_admid_""","""_templateid_""")"}

	//病案室是否已将病历归档平台组方法
	elseif argNominalFunc = "IsRecordArchivedByPlat" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordArchivedByPlat("""_admid_""")"}
	
	//是否是病人的术者
	elseif argNominalFunc = "IsAdmOperationUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmOperationUser("""_admid_""","""_userid_""")"}
	
	//是否是手术病人（术后）
	elseif argNominalFunc = "IsOperationAdm" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOperationAdm("""_admid_""")"}
	
	//页眉科室是否和登录科室一致
    	elseif argNominalFunc="IsSameForLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSameForLoc("""_instanceid_""","""_userloc_""",""L0004"")"}
	
	///用户是否是病人的专科医生
	elseif argNominalFunc="IsGoldCardForAdm" {s execCode="result=##class(EMRservice.BOPrivAssist).IsGoldCardForAdm("""_admid_""","""_userid_""")"}
	
	//用户是否是病人的专科医师
	elseif argNominalFunc="IsAdmPersionalDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmPersionalDoc("""_admid_""","""_userid_""")"}
	
	//登陆医生级别
	elseif argNominalFunc = "LoginUserlevel" {s execCode="result=##class(EMRservice.BOPrivAssist).GetLoginUserlevel("""_userid_""")"}
	
	//病历签名级别
    	elseif argNominalFunc = "SignUserLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).GetSignUserLevel("""_instanceid_""","""_admid_""")"}
	
	//是否是签名者的上级
	elseif argNominalFunc = "IsSignUserUper" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSignUserUper("""_instanceid_""","""_admid_""","""_userid_""")"}
	
	//出院病历是否保存
	elseif argNominalFunc = "OutRecordSaved" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSavedRecord("""_admid_""",""24"",""54"")"}
	
	//死亡病历是否保存
	elseif argNominalFunc = "DeathRecordSaved" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSavedRecord("""_admid_""",""19"",""56"")"}
	
	///登录用户是否是最后一个签名人
    	elseif argNominalFunc = "IsLastSigner" {s execCode="result=##class(EMRservice.BOPrivAssist).IsLastSigner("""_userid_""","""_instanceid_""")"}
	
	//患者是否已签名
	elseif argNominalFunc = "IsPatSign" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatientSign("""_admid_""","""_instanceid_""")"}

    	//病历是否审批
    	elseif argNominalFunc="IsApproval" {s execCode="result=##class(web.DHCVUE.MedAdt.Query).getKeyLinkAdtFlag("""_instanceid_""")"}
    
	//揭阳市人民医院
	//病人是否属于感染科科室
	elseif argNominalFunc = "BelongToInfect" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToLinkLoc("_admid_","_9_")"}  
   
   	//判断病人主诊断是否包含脑梗死（I63），且是否报卡 [0:不需要报卡，1:需要报卡]
	elseif argNominalFunc = "IsNGS" {s execCode="result=##class(DHCMA.CPW.CPS.InterfaceSrv).CheckIsNGS("_admid_")"}
	
	//南山人民
	//患者是否病案复印
	elseif argNominalFunc = "IsDisMedRecordDup" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsBAFYStatus("""_admid_""")"}
	
	//判断C-DRG病案首页是否上传
	elseif argNominalFunc = "IsCDRGSubmit" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCDRGSubmit("""_admid_""")"} 
	
	//病人是否属于同类型科室 相关门诊查看住院
	elseif argNominalFunc = "BelongToCaption" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToCaption("_admid_","_userloc_")"}   
	
	//病人是否存在手术
	elseif argNominalFunc = "LinkOperation" {s execCode="result=##class(EMRservice.BOPrivAssist).IsLinkOperation("_admid_")"}

	//设置权限 未设置的不做控制 逐步完善后完全控制
	elseif argNominalFunc = "NSOutpatOver24" {s execCode="result=##class(EMRservice.BOPrivAssist).NSOutpatOver24("""_admid_""","""_instanceid_""","""_userid_""")"}

	//大同三院
	//查房记录是否缺少上级医师签名
	elseif argNominalFunc = "IsAllSuperSing" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSuperSign("""_admid_""")"}
    
    	//是否最护士做终结算
	elseif argNominalFunc = "IsNurseJS" {s execCode="result=##class(EMRservice.BOPrivAssist).IsNurseJS("""_admid_""")"}
    	//门急诊病历首次保存超过24H不允许编辑
	elseif argNominalFunc = "IsRecordOverRanOP" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordOverRanOP("""_instanceid_""")"}
	
    	//是否转科前科室
	elseif argNominalFunc = "IsTransDept" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTransDept("_admid_","_userloc_")"}
   	//转科时间间隔(单位:小时)
   	elseif argNominalFunc = "InhsTransTimeGap" {s execCode="result=##class(EMRservice.BOPrivAssist).GetInhsTransTimeGap("""_admid_""")"}
	
	//西电集团
	//开立第一条医嘱时间
	elseif argNominalFunc = "IsoeordNHours" {s execCode="result=##class(EMRservice.BOPrivAssist).IsoeordNHours("""_admid_""")"}
	//开立手术医嘱是否超过24小时
	elseif argNominalFunc = "IsOperaNHours" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOperaNHours("""_admid_""",24)"}
	//开立死亡医嘱是否超过24小时
	elseif argNominalFunc = "IsDeadNHours" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDeadNHours("""_admid_""",24)"}

	//深圳大学总医院
	//患者是否出院超过3天不包含节假日
	elseif argNominalFunc = "IsDischargedThreeDayUnHoliday" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHoursUnHoliday("""_admid_""",168)"}

	//患者是否出院超过7天不包含节假日
	elseif argNominalFunc = "IsDischargedSevenDayUnHoliday" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHoursUnHoliday("""_admid_""",168)"}
	
	//患者是否出院超过10天不包含节假日
	elseif argNominalFunc = "IsDischargedTenDayUnHoliday" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHoursUnHoliday("""_admid_""",240)"}
	
	//患者是否死亡
	elseif argNominalFunc = "IsDead" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDead("""_admid_""")"}
	
	//转出是否超过48小时
	elseif argNominalFunc = "IsTransPrevious48Hours" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTransPreviousCTLOCHours("""_admid_""","""_userloc_""",48)"}
	
   	//当前登录用户跟病历创建者 是否能够登录同一个科室
	elseif argNominalFunc = "IsTheSameCTloc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTheSameCTloc("""_instanceid_""","""_userid_""")"}
	
   	//当前登录科室是否是 会诊科室
	elseif argNominalFunc = "IsConsultDept" {s execCode="result=##class(EMRservice.BOPrivAssist).IsConsultDept("""_admid_""","""_userloc_""")"}
	

	//病案室是否将病历撤销回收
	elseif argNominalFunc = "IsCXRecordRetrieve" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCXRecordRetrieve("""_admid_""")"}
	
	//患者是否分床
	elseif argNominalFunc = "IsHaveBed" {s execCode="result=##class(EMRservice.BOPrivAssist).IsHaveBed("""_admid_""")"}
	
	//深圳中医院
	//当前登录入户是否门诊患者挂号医生
	elseif argNominalFunc = "IsAdmDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmDoc("""_admid_""","""_userid_""")"}

	//当前登录入户是否门诊患者挂号医生
	elseif argNominalFunc = "IsFstDiagDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsFstDiagDoc("""_admid_""","""_userid_""")"}

	// 判断门急诊复诊病历病史资料是否填写
	elseif argNominalFunc = "GetFZZLStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).GetFZZLStatus("""_admid_""")"} 
	
	// 判断门急诊初诊病历主诉、现病史是否填写
	elseif argNominalFunc = "GetCZZLStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCZZLStatus("""_admid_""")"} 
	
	//取病历创建时间
   	elseif argNominalFunc = "RecCreateDateTime" {s execCode="result=##class(EMRservice.BOPrivAssist).GetRecCreateDateTime("""_instanceid_""")"}
	
	//患者是否已出院3个工作日  深圳中医院：普通病历一律3个工作日 死亡病历7个工作日
	elseif argNominalFunc = "IsDistreeWorkingDay" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsDistreeWorkingDay("""_admid_""")"}
	
	//是否有患者已签署的pdf病历 Add by houjian 2022-02-26
	elseif argNominalFunc="HasPatSignedPDF" {s execCode="result=##class(EMRservice.BOPrivAssist).HasPatSignedPDF("""_instanceid_""")"}
	
	//深圳肿瘤医院
	//判断当前登录科室是否病历创建者所在科室
	elseif argNominalFunc = "IsCreaterLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreaterLoc("_admid_","""_instanceid_""","_docid_","""_userloc_""")"}

	//判断就诊时间是否是当天
	elseif argNominalFunc = "IsToday" {s execCode="result=##class(EMRservice.BOPrivAssist).IsToday("""_admid_""")"}
	
	//判断出院七天
	elseif argNominalFunc = "IsDisSevenDay" {s execCode="result=##class(EPRservice.Privilege.BOPrivAssist).IsDisSevenDay("""_admid_""")"}
	
	// 主任、主治医师查房记录，需要有两个签名才能打印
	elseif argNominalFunc = "IsFinishChecked" {s execCode="result=##class(EMRservice.BOPrivAssist).IsFinishChecked("""_admid_""","""_instanceid_""")"}
	
	// 患者是否有了入院分床时间
	elseif argNominalFunc = "IsGetAdmDate" {s execCode="result=##class(EMRservice.BOPrivAssist).IsGetAdmDate("""_admid_""")"}
	
	//沈阳医大
	//返回总住院是否运行修改病历
   	elseif argNominalFunc = "ZZYYXXGBS" {s execCode="result=##Class(EMRservice.BOPrivAssist).EnableSubmitByMrStatus("""_admid_""")"}
	
	//太钢总医院
	//
 	elseif argNominalFunc = "LastIPDeptID" {s execCode="result=##class(EMRservice.BOPrivAssist).LastIPDept("_admid_","_userloc_")"}
 	//该患者最新一次就诊是否在本科室就诊过
	elseif argNominalFunc = "HasVaildAdmInCTLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).HasVaildAdmInCTLoc("""_admid_""","""_userloc_""")"}
	
	//当前科室是否为转科科室
   	elseif argNominalFunc = "IsAdmDep" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmDep("""_admid_""","""_userloc_""")"}
   	
	//泰安中心医院
	//登录用户是否为实习医生
	elseif argNominalFunc = "IsSXDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSXDoc("""_userid_""")"}
	
	//是否已签名【判断病历中是否保护了签名单元】
	elseif argNominalFunc = "IsSign" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSign("""_admid_""","""_instanceid_""")"}
	
	//护士是否已移交病案室
	elseif argNominalFunc = "FinishStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).GetFinishStatus("""_admid_""")"}
	
	//天津一中心
	//死亡记录、出院记录、24小时入出院记录、24小时入院死亡记录互斥
	elseif argNominalFunc = "HasCreateSampleTypeTemplate" {s execCode="result=##class(EMRservice.BOPrivAssist).HasCreateSampleTypeTemplate("""_templateid_""","""_admid_""")"}
	
	//死亡记录、出院小结
	elseif argNominalFunc = "HasCreateSampleTypeTemplate2" {s execCode="result=##class(EMRservice.BOPrivAssist).HasCreateSampleTypeTemplate2("""_templateid_""","""_admid_""")"}
	
	//会诊是否确认
	elseif argNominalFunc = "CstCurStatQR" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCstCurStatQR("""_instanceid_""")"}
	
	//抢救记录是否有签名权限
	elseif argNominalFunc = "HasSignPriv" {s execCode="result=##class(EMRservice.BOPrivAssist).HasSignPriv("""_instanceid_""","""_userid_""")"}
	
	//门诊诊断证明书当前状态
	elseif argNominalFunc = "OPDiagRecordStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).GetOPDiagRecordStatus("""_instanceid_""")"}
	
	//病历不签名也可以打印的模板集合
	elseif argNominalFunc = "CanPrint" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCanPrint("""_instanceid_""")"}
	
	//转入复苏室的患者，转入前一个科室一直有编辑权限
	elseif argNominalFunc = "IsTranToFSS" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTranToFSS("""_admid_""","""_userloc_""")"}
	
	//今创回传加锁标识
	elseif argNominalFunc = "EmrMark" {s execCode="result=##class(EMRservice.BOPrivAssist).GetEmrMark("""_admid_""")"}
	
	//病历封存后不能修改
	elseif argNominalFunc = "HasSeal" {s execCode="result=##class(EMRservice.BOPrivAssist).GetSealStatus("""_admid_""","""_instanceid_""")"}
	
	//24小时内是否存在有效的权限申请
	elseif argNominalFunc = "Appointed" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAppointinfo("""_admid_""")"}
	
	//今创回传解锁标识
	elseif argNominalFunc = "EmrMarkNew" {s execCode="result=##class(EMRservice.BOPrivAssist).GetEmrMarkNew("""_admid_""")"}
	
	//旧病案首页保存后，不能写新病案首页
	elseif argNominalFunc = "HasSaveFirstPageOld" {s execCode="result=##class(EMRservice.BOPrivAssist).GetSaveStatusOld("""_admid_""")"}
	
	//新病案首页保存后，不能写旧病案首页
	elseif argNominalFunc = "HasSaveFirstPageNew" {s execCode="result=##class(EMRservice.BOPrivAssist).GetSaveStatusNew("""_admid_""")"}
	
	//当前用户是否是该患者的接诊医师
	elseif argNominalFunc = "IsAdmDoctor" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmDoctor("""_admid_""","""_userid_""")"}
	
	//categoryid
	elseif argNominalFunc = "categoryid" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCategoryID("""_docid_""")"}
	
	//武汉一院
	//用户是否是病历创建者的科主任
	elseif argNominalFunc = "IsDepartmentHeader" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDepartmentHeader("""_admid_""","""_userid_""")"}
	
	//当前登录科室类型是否为门急诊
    	elseif argNominalFunc = "GetUserLocType" {s execCode="result=##class(EMRservice.BOPrivAssist).GetUserLocType("_userloc_")"}
	
	//在院患者并且当前科室一致
	elseif argNominalFunc = "IsCurrAdm" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCurrAdm("_patientid_","_userloc_")"}
	
	//转科6小时内自动授权
	elseif argNominalFunc = "BelongToZKQLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToZKQLoc("_admid_","_userloc_")"}
	
	//该用户是否为在院患者的会诊医生
   	elseif argNominalFunc = "IscoustUserNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IscoustUser("""_patientid_""","""_userid_""")"}

	//病人是否在转科科室就诊过
	elseif argNominalFunc = "IsTransDept" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTransDept("_patientid_","_userloc_")"}
	
    	//患者出院科室ID
    	elseif argNominalFunc = "DisLocID" {s execCode = "result=##Class(EMRservice.BOPrivAssist).GetDisLocID("""_admid_""")"}

    	//出院日期(护士最终结算,) 
	elseif argNominalFunc = "DisDateByNurNew" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDisDate2021("""_admid_""",""ByNurse"")"}
	
	//实例病历签名数量
	elseif argNominalFunc = "RecordSignCount" {s execCode="result=##class(EMRservice.BOPrivAssist).GetInstanceSignList("""_instanceid_""")"}
	
	//患者是否出院	---提交病案判断
    	elseif argNominalFunc = "IsDisOut" {s execCode = "result=##Class(EMRservice.BOPrivAssist).IsDisOut("""_admid_""")"}

	//获取病案状态	---提交病案判断
    	elseif argNominalFunc = "GetMRStatus" {s execCode = "result=##Class(EMRservice.BOPrivAssist).GetMRStatus("""_admid_""")"}
	
	//港大
	//病案室是否已将病历编目
	elseif argNominalFunc = "IsRecordCatalogued" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordCatalogued("""_admid_""")"}
	
	//病案是否上传
	elseif argNominalFunc = "IsGetUpStatus" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsGetUpStatus("""_admid_""")"}
	
	//是否上级医师已签名
	elseif argNominalFunc = "IsUpUserHasChecked" {s execCode = "result=##class(EMRservice.BOPrivAssist).IsUpUserChecked("""_admid_""","""_instanceid_""","""_userid_""")"}
    
    	//获取医生级别
    	elseif argNominalFunc = "DocLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDocLevel("""_userid_""","""_userloc_""")"}
	
	//病历创建者医生级别
	elseif argNominalFunc = "CreatorLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).GetCreatorLevel("""_admid_""","""_instanceid_""")"}
	
	//最后一次有效签名的医生级别
	elseif argNominalFunc = "LastSignerLevel" {s execCode="result=##class(EMRservice.BOPrivAssist).GetLastSignerLevel("""_admid_""","""_instanceid_""")"}
	
	//返回病人的就诊科室ID
	elseif argNominalFunc = "AdmLocID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAdmLocID("""_admid_""")"}
	
	///病人是否是绿色通道病人
	elseif argNominalFunc = "IsGreenRec" {s execCode="result=##class(EMRservice.BOPrivAssist).IsGreenRec("""_admid_""")"}
		
	///转科后是否超过24小时
	elseif argNominalFunc = "IsTransOver24Hours" {s execCode="result=##class(EMRservice.BOPrivAssist).IsTransOver24Hours("""_admid_""","""_userloc_""")"}
	
	///是否为体检患者
	elseif argNominalFunc = "IsAdmTypeH" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmTypeH("""_admid_""")"}
	
	///是否为住院患者
	elseif argNominalFunc = "InPatient" {s execCode="result=##class(EMRservice.BOPrivAssist).IsInPatient("""_admid_""")"}
	
	///是否为急诊患者
	elseif argNominalFunc = "EnsPatient" {s execCode="result=##class(EMRservice.BOPrivAssist).IsEnsPatient("""_admid_""")"}
	
	///病历创建时间是否超24小时
	elseif argNominalFunc = "IsCreate24Hours" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCreate24Hours("""_instanceid_""")"}
	
	///病历创建是否超过0点
	elseif argNominalFunc = "IsOver0Hours" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOver0Hours("""_instanceid_""")"}
	
	//病人是否在当前科室就诊过
	elseif argNominalFunc = "BelongAdmToLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsBelongAdmToLoc("_patientid_","_userloc_")"}
	
	//病历是否为登录用户创建(心理课专用)
	elseif argNominalFunc = "AdmBelongToMe" {s execCode="result=##class(EMRservice.BOPrivAssist).IsAdmBelongDoc("""_admid_""","""_instanceid_""","""_userid_""")"}	
	
	//当前登录用户是否是最后一次签名人
	elseif argNominalFunc = "IsSinUserid" {s execCode="result=##class(EMRservice.BOPrivAssist).GetLastSignerUserid("""_admid_""","""_instanceid_""","""_userid_""")"}

	//是否有本科未完成的会诊
	elseif argNominalFunc = "IsHaveValidCon" {s execCode="result=##class(EMRservice.BOPrivAssist).IsHaveValidCon("""_admid_""","""_userloc_""")"}

	//是否为特殊科室
	elseif argNominalFunc = "IsSpecialLocGroup1" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSpecialLocGroup1("""_userloc_""")"}

	//获取标题描述信息
	elseif argNominalFunc = "TitleName" {q titlename}
	
	//是否为特殊科室
	elseif argNominalFunc = "IsFinishFirstDispatchBed" {s execCode="result=##class(EMRservice.BOPrivAssist).IsFinishFirstDispatchBed("""_admid_""")"}

	//病人当前在院就诊是否属于科室
	elseif argNominalFunc = "IsCurAdmBelongToLocForBrowse" {s execCode="result=##class(EMRservice.BOPrivAssist).IsCurAdmBelongToLocForBrowse("_admid_","_userloc_")"}
    
    	//最近一次科室会诊时间
	elseif argNominalFunc = "GetLastConHours" {s execCode="result=##class(EMRservice.BOPrivAssist).GetLastConHours("_admid_","_userloc_")"}
	//病历最后一次有效操作(签名、保存)的科室是否与当前登录科室一致
	elseif argNominalFunc = "IsSameLocLogUserAndInstance" {s execCode="result=##class(EMRservice.BOPrivAssist).IsSameLocLogUserAndInstance("_admid_","""_instanceid_""","_userloc_")"}
    
    //登记号
	elseif argNominalFunc = "registerNo" {s execCode="result=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo("_patientid_")"}
    
    //门诊在有效期
	elseif argNominalFunc = "OPInValidityPeriod" {s execCode="result=##Class(EMRservice.BOPrivAssist).GetOPInValidityPeriod("_admid_")"}
    
    //当前病历为知情同意书 
	elseif argNominalFunc = "IsInformedConsentForm" {s execCode="result=##class(EMRservice.BOPrivAssist).IsInformedConsentForm("""_docid_""")"}
	
    //病历是否存在已签或者已推送、未签的病历PDF
	elseif argNominalFunc = "IsPushOrSignedPDF" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPushOrSignedPDF("""_instanceid_""")"}
    
	s @execCode
	q @"result"
}

/// Desc: 取脚本信息
/// Creator:Candy
/// CreateDate: 2016-8-24
/// InPut:      argEnviromentInfo 方法参数(userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67)
///            argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// OutPut:     脚本List
ClassMethod GetPrivRuleByType(argEnviromentInfo As %String, argType As %String) As %ArrayOfDataTypes
{
 
	s result = ##Class(%ArrayOfDataTypes).%New()
	s strPrivRule = ..ParsePrivRule(argEnviromentInfo,argType)
	s result = ..PrivStringToArray(strPrivRule)
	q result
}

/// Desc:           运行权限脚本
/// Modifier:       Candy
/// ModifyDateDime: 2015-3-9
/// InPut:          argEnviromentInfo 方法参数(userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67)
///                 argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// OutPut:         view^1!save^1!print^1!check^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0!revise^0!commit^1
ClassMethod ParsePrivRule(argEnviromentInfo As %String, argType As %String) As %String
{
	s result = "save^1!print^1!delete^1!check^1!recheck^0!revokcheck=0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^0!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0!patcheck^1!patrecheck^1"
	s PrivControl = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("PrivControl")
	q:(PrivControl '= "Y") result
	
	k SQLCODE
	s ruleID = ""
	&sql(SELECT ID into:ruleID FROM EMRmeta.PrivRule WHERE Valid='1' AND PrivRuleTypeDR=(SELECT ID FROM  EMRmeta.PrivRuleType WHERE NAME=:argType))
	q:(SQLCODE '= 0) ""
	q:(ruleID = "") ""
	s aPrivRule = ##class(EMRmeta.PrivRule).%OpenId(ruleID)
	q:(aPrivRule = "") ""
	s operators = "save=1"	                       //保存
	s operators = operators_",print=1"		       //打印
	s operators = operators_",delete=1"		       //删除
	s operators = operators_",check=1"	           //医师审核
	s operators = operators_",recheck=0"		   //改签
	s operators = operators_",revokcheck=0"		   //撤销签名
	s operators = operators_",reference=1"         //文档对照
	s operators = operators_",export=1"            //导出文档
	s operators = operators_",view=1"              //查看病历
	s operators = operators_",new=1"               //创建病历
	s operators = operators_",copypaste=1"         //复制粘贴
	s operators = operators_",revise=-1"           //留痕
	s operators = operators_",viewrevise=1"        //显示留痕
	s operators = operators_",appoint=1"           //病历授权
	s operators = operators_",authlevel=300"       //病历授权级别
	s operators = operators_",commit=1"			   //送病案室
	s operators = operators_",applyedit=0"		   //自动审批
	s operators = operators_",unlock=1"		   	   //手工解锁
	s operators = operators_",transfer=1"          //病历转移
    s operators = operators_",quote=0"             //门诊历史病历引用
    s operators = operators_",autoapply=0"		   //门诊自动审批功能
	s operators = operators_",patcheck=1"	   	   //患者签名
	s operators = operators_",patrecheck=1"		   //患者改签
	s result = ..ParsePrivRuleLogic(operators,argEnviromentInfo,aPrivRule.Code)
	q result
}

ClassMethod ParseEnvInfo(argEnvInfo As %String, ByRef argEnvInfoName As %List, ByRef argEnvInfoData As %List) As %Status
{
	for i=1:1:$l(argEnvInfo,"!") {
		s aInfo = $p($g(argEnvInfo),"!",i)
		s argEnvInfoName = argEnvInfoName_$lb($p($g(aInfo),"^",1))
		s argEnvInfoData = argEnvInfoData_$lb($p($g(aInfo),"^",2))
	}
	q 1
}

ClassMethod Add(argPrivRule As EMRservice.entity.EPrivRule, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q:($d(argPrivRule)=0)||(argPrivRule="") 0
	TSTART
	s aPrivRule=""
	s aPrivRule=##class(EMRmeta.PrivRule).%New()
	if (aPrivRule="")
	{
		TROLLBACK
		 quit 0
	}
	s aPrivRule.Name=argPrivRule.Name
	s aPrivRule.Code=argPrivRule.Code
	s aPrivRule.Valid=argPrivRule.Valid
	s aPrivRule.PrivRuleTypeDR=argPrivRule.PrivRuleTypeDR
	if '(aPrivRule.%Save())
	{
		TROLLBACK
		 quit 0
	} 
	//脚本院区分组关系
	if ((argPrivRule.hosGroupID'="")&&(argPrivRule.hosGroupID'=$c(0)))
	{
		s aPrivRuleHos=##class(EMRmeta.PrivRuleHospital).%New()
		s aPrivRuleHos.HospGroupID = argPrivRule.hosGroupID
		s aPrivRuleHos.PrivRule = aPrivRule
		if '(aPrivRuleHos.%Save())
		{
			TROLLBACK
			 quit 0
		} 
	}
	//日志
	s aPrivRuleLog=""
	s aPrivRuleLog=##class(EMRmeta.PrivRuleLog).%New()
	if (aPrivRuleLog="")
	{
		TROLLBACK
		 quit 0
	}
	s aPrivRuleLog.LogType = argPrivRuleLog.LogType
	s aPrivRuleLog.ModifyDate = argPrivRuleLog.ModifyDate
	s aPrivRuleLog.PrivRuleName = argPrivRuleLog.PrivRuleName
	s aPrivRuleLog.PrivRuleTypeDR = argPrivRuleLog.PrivRuleTypeDR
	s aPrivRuleLog.PrivRuleValid = argPrivRuleLog.PrivRuleValid
	s aPrivRuleLog.UserID = argPrivRuleLog.UserID
	s aPrivRuleLog.UserName = argPrivRuleLog.UserName
	s aPrivRuleLog.IP = argPrivRuleLog.IP
	s aPrivRuleLog.PrivRuleID = argPrivRuleLog.PrivRuleID
	s aPrivRuleLog.PrivRuleCode = argPrivRuleLog.PrivRuleCode
	//s result=""
	//s result=aPrivRule.%Save()
	//q result	
	if '(aPrivRuleLog.%Save())
	{
		TROLLBACK
		 quit 0
	} 
	TCOMMIT
	Quit aPrivRule.%Id()
}

ClassMethod Delete(argPrivRuleID As %String, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q:($d(argPrivRuleID)=0)||(argPrivRuleID="") 0
	TSTART
	s aPrivRule="",result=""
	s aPrivRule=##class(EMRmeta.PrivRule).%OpenId(argPrivRuleID)
	if (aPrivRule="")
	{
		TROLLBACK
		quit 0
	}
	s aPrivRule=""
	
	s aPrivRuleLog=""
	s aPrivRuleLog=##class(EMRmeta.PrivRuleLog).%New()
	if (aPrivRuleLog="")
	{
		TROLLBACK
		quit 0
	}
	s aPrivRuleLog.LogType = argPrivRuleLog.LogType
	s aPrivRuleLog.ModifyDate = argPrivRuleLog.ModifyDate
	s aPrivRuleLog.PrivRuleID = argPrivRuleLog.PrivRuleID
	s aPrivRuleLog.PrivRuleName = argPrivRuleLog.PrivRuleName
	s aPrivRuleLog.PrivRuleTypeDR = argPrivRuleLog.PrivRuleTypeDR
	s aPrivRuleLog.PrivRuleValid = argPrivRuleLog.PrivRuleValid
	s aPrivRuleLog.UserID = argPrivRuleLog.UserID
	s aPrivRuleLog.UserName = argPrivRuleLog.UserName
	s aPrivRuleLog.IP = argPrivRuleLog.IP
	s aPrivRuleLog.PrivRuleID = argPrivRuleLog.PrivRuleID
	s aPrivRuleLog.PrivRuleCode = argPrivRuleLog.PrivRuleCode
	
	if '(aPrivRuleLog.%Save())
	{
		TROLLBACK
		quit 0
	}
	s hosGroupID = $o(^DHCEMRM.PrivRuleHospitalI("IdxPrivRule",argPrivRuleID,""))
	if (hosGroupID'="")
	{
		s sc=##class(EMRmeta.PrivRuleHospital).%DeleteId(hosGroupID)
		if '(sc)
		{
			TROLLBACK
			quit 0
		}
	}
	 
	s result=##class(EMRmeta.PrivRule).%DeleteId(argPrivRuleID)
	if '(result)
	{
		TROLLBACK
		quit 0
	}
	TCOMMIT
	q result
}

ClassMethod Update(argPrivRule As EMRservice.entity.EPrivRule, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q:($d(argPrivRule)=0)||(argPrivRule="") 0
	s aPrivRule="",result=""
	s aPrivRule=##class(EMRmeta.PrivRule).%OpenId(argPrivRule.ID)
	q:(aPrivRule="") 0
	TSTART
	s aPrivRule.Name=argPrivRule.Name
	s aPrivRule.Code=argPrivRule.Code
	s aPrivRule.Valid=argPrivRule.Valid
	s aPrivRule.PrivRuleTypeDR=argPrivRule.PrivRuleTypeDR
	
	//先删除院区关系
	s strPrivRuleID = argPrivRule.ID
	&sql(DELETE  FROM EMRmeta.PrivRuleHospital WHERE PrivRule = :strPrivRuleID )
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q 0
	}
	//添加院区关系
	if ((argPrivRule.hosGroupID'="")&&(argPrivRule.hosGroupID'=$c(0)))
	{
		s aPrivRuleHos=##class(EMRmeta.PrivRuleHospital).%New()
		s aPrivRuleHos.HospGroupID = argPrivRule.hosGroupID
		s aPrivRuleHos.PrivRule = aPrivRule
		if '(aPrivRuleHos.%Save())
		{
			TROLLBACK
			 quit 0
		} 
	}
	s aPrivRuleLog=""
	s aPrivRuleLog=##class(EMRmeta.PrivRuleLog).%New()
	q:(aPrivRuleLog="") 0
	
	s aPrivRuleLog.LogType = argPrivRuleLog.LogType
	s aPrivRuleLog.ModifyDate = argPrivRuleLog.ModifyDate
	s aPrivRuleLog.PrivRuleID = argPrivRuleLog.PrivRuleID
	s aPrivRuleLog.PrivRuleName = argPrivRuleLog.PrivRuleName
	s aPrivRuleLog.PrivRuleTypeDR = argPrivRuleLog.PrivRuleTypeDR
	s aPrivRuleLog.PrivRuleValid = argPrivRuleLog.PrivRuleValid
	s aPrivRuleLog.UserID = argPrivRuleLog.UserID
	s aPrivRuleLog.UserName = argPrivRuleLog.UserName
	s aPrivRuleLog.IP = argPrivRuleLog.IP
	s aPrivRuleLog.PrivRuleID = argPrivRuleLog.PrivRuleID
	s aPrivRuleLog.PrivRuleCode = argPrivRuleLog.PrivRuleCode
	
	s result=""
	if '(aPrivRule.%Save())
	{
		TROLLBACK
		Quit 0
	} 
	if '(aPrivRuleLog.%Save())
	{
		TROLLBACK
		Quit 0
	} 
	TCOMMIT
	q 1
}

ClassMethod GetById(argPrivRuleID As %String) As EMRservice.entity.EPrivRule [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	&sql(select ID into :id from EMRmeta.PrivRule where ID=:argPrivRuleID)
	s result=##class(EMRservice.entity.EPrivRule).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EMRmeta.PrivRule).%OpenId(id)
		q:(tmpResult="") result
		
		s result.Name=tmpResult.Name
		s result.Code=tmpResult.Code
		s result.Valid=tmpResult.Valid
		s result.PrivRuleTypeDR=tmpResult.PrivRuleTypeDR
		s result.ID=id
	}
	q result
}

Query GetTemplateByPrivRuleDR(PrivRuleDR As %String) As %Query(ROWSPEC = "ID:%String,EMRTemplateName:%String,EMRCategoryName:%String")
{
}

ClassMethod GetTemplateByPrivRuleDRExecute(ByRef qHandle As %Binary, PrivRuleDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(PrivRuleDR="") $$$OK
	
	s PrivRuleDR=" "_PrivRuleDR
	
	s EMRTemplateID=""
	s EMRTemplateID = $O(^DHCEMRM.EMRTemplateI("IdxPrivRuleDR",PrivRuleDR,""))
	while EMRTemplateID'=""
	{
		s objEprTemplate=##Class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
		s EMRTemplateName=objEprTemplate.EMRTemplateName
	    s EMRCategoryID=objEprTemplate.EMRCategoryID
	    s objEprTemplateCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(EMRCategoryID)
	    s EMRCategoryAllPathString=##class(EMRservice.BOEMRTemplate).GetTemplateAllPathString(EMRTemplateID)
		s ^CacheTemp(repid, ind) = $LB(EMRTemplateID,EMRTemplateName,EMRCategoryAllPathString)
		s ind = ind + 1
	    s EMRTemplateID = $O(^DHCEMRM.EMRTemplateI("IdxPrivRuleDR",PrivRuleDR,EMRTemplateID))
	}
	Quit $$$OK
}

ClassMethod GetTemplateByPrivRuleDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTemplateByPrivRuleDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetTemplateByPrivRuleDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTemplateByPrivRuleDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid) //5.2.3 以下 Caceh 通过DataSet调用的自定义Query,不能调用Close方法,所以fetch后删除
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   获取规则数据集合,和是否使用的状态
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：      
/// Others
/// Debug:w ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrivRule","SelectPrivRuleAll","2")
Query SelectPrivRuleAll(aHosGroupID As %String = "") As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Valid:%String,ValidDesc:%String,IsUsed:%String,IsUsedDesc:%String,PrivRuleTypeDR:%String,PrivRuleTypeDesc:%String,hosGroupID:%String,hosGroupName:%String")
{
}

ClassMethod SelectPrivRuleAllExecute(ByRef qHandle As %Binary, aHosGroupID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s RowID="",Name="",Code="",Valid="",ValidDesc="",IsUsed="",IsUsedDesc="",PrivRuleTypeDR="Null",PrivRuleTypeDesc="Null"
	s objPrivRuletype="",hosGroupID=$c(0),hosGroupName=$c(0)
	s RowID = $O(^DHCEMRM.PrivRuleD(RowID))
	while RowID'=""
	{
		s PrivRuleName=""
		s objPrivRule=##Class(EMRmeta.PrivRule).%OpenId(RowID)
		s PrivRuleTypeDR=objPrivRule.PrivRuleTypeDR
		//s ^CacheTemp("Debug",RowID)=objPrivRule.PrivRuleTypeDR_"^"_$l(PrivRuleTypeDR)
	    i (PrivRuleTypeDR'="")
	    {
	    	s objPrivRuletype=##Class(EMRmeta.PrivRuleType).%OpenId(PrivRuleTypeDR)
	    	i (objPrivRuletype'="")
	    	{
	    		s PrivRuleTypeDesc=objPrivRuletype.Description
	    		s PrivRuleName=objPrivRuletype.Name
	    		d objPrivRuletype.%Close()
	    	}
	    }	
		s Name=objPrivRule.Name
	    s Code=objPrivRule.Code
	    s Valid=objPrivRule.Valid
	    i (Valid="1"){s ValidDesc="是"}
	    else {s ValidDesc="否"}
	    s PrivRuleDR=" "_RowID
	    if $d(^DHCEMRM.EMRTemplateI("IdxPrivRuleDR",PrivRuleDR))'=0
	    {
		    s IsUsed=1
		    s IsUsedDesc="是"
		}else 
		{
			s IsUsed=0
			s IsUsedDesc="否"
		}
		i (PrivRuleTypeDR="")
		{s PrivRuleTypeDR="Null"}
		s hosGroupID = $o(^DHCEMRM.PrivRuleHospitalI("IdxPrivRule",RowID,""))
		s hosGroupID = $TR(hosGroupID," ")
		//根据院区分组ID过滤
		if (aHosGroupID'="")&&(aHosGroupID'=$c(0))&&(hosGroupID'=aHosGroupID)
		{
			s RowID = $O(^DHCEMRM.PrivRuleD(RowID))
			continue
		}
		if (hosGroupID'="")
		{
			&sql(SELECT h.HOSP_Desc into :hosGroupName FROM SQLUser.CT_Hospital h where h.HOSP_RowId=:hosGroupID)
			s:(hosGroupName="") hosGroupName=$c(0)
		}
		else
		{
			s hosGroupID=$c(0),hosGroupName=$c(0)
		}
		
		s ^CacheTemp(repid, ind) = $LB(RowID,Name,Code,Valid,ValidDesc,IsUsed,IsUsedDesc,PrivRuleTypeDR,PrivRuleTypeDesc,hosGroupID,hosGroupName)
		s PrivRuleTypeDesc="Null"
		s ind = ind + 1
	    s RowID = $O(^DHCEMRM.PrivRuleD(RowID))
	}
	Quit $$$OK
}

ClassMethod SelectPrivRuleAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPrivRuleAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod SelectPrivRuleAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPrivRuleAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid) //5.2.3 以下 Caceh 通过DataSet调用的自定义Query,不能调用Close方法,所以fetch后删除
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   根据规则类型名称获取规则数据集合,和是否使用的状态
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：      
/// Others
/// Debug:d ##Class(%ResultSet).RunQuery("EMRservice.BOPrivRule","SelectPrivRuleByType","LoadTemplatePrivilege")
Query SelectPrivRuleByType(argRuleTypeName As %String) As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Valid:%String,ValidDesc:%String,IsUsed:%String,IsUsedDesc:%String,PrivRuleTypeDR:%String,PrivRuleTypeDesc:%String")
{
}

ClassMethod SelectPrivRuleByTypeExecute(ByRef qHandle As %Binary, argRuleTypeName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s RowID="",PrivRuleDR="",objPrivRuletype=""
	s RowID = $O(^DHCEMRM.PrivRuleD(RowID))
	while RowID'=""
	{
		s PrivRuleTypeDesc="" ,PrivRuleName=""
		s objPrivRule=##Class(EMRmeta.PrivRule).%OpenId(RowID)
	    s PrivRuleTypeDR=objPrivRule.PrivRuleTypeDR
	    i (PrivRuleTypeDR'="")
	    {
	    	s objPrivRuletype=##Class(EMRmeta.PrivRuleType).%OpenId(PrivRuleTypeDR)
	    	i (objPrivRuletype'="")
	    	{
	    		s PrivRuleTypeDesc=objPrivRuletype.Description
	    		s PrivRuleName=objPrivRuletype.Name
	    		d objPrivRuletype.%Close()
	    	}
	    }	
	    	
		i (PrivRuleName'=argRuleTypeName)
		{
			d objPrivRule.%Close()
			s RowID = $O(^DHCEMRM.PrivRuleD(RowID))
			continue
		}
		s Name=objPrivRule.Name
	    s Code=objPrivRule.Code
	    s Valid=objPrivRule.Valid
	    i (Valid="1"){s ValidDesc="是"}
	    else {s ValidDesc="否"}
	    s PrivRuleDR=" "_RowID
	    if $d(^DHCEMRM.EMRTemplateI("IdxPrivRuleDR",PrivRuleDR))'=0
	    {
		    s IsUsed=1
		    s IsUsedDesc="是"
		}else 
		{
			s IsUsed=0
			s IsUsedDesc="否"
		}
		s ^CacheTemp(repid, ind) = $LB(RowID,Name,Code,Valid,ValidDesc,IsUsed,IsUsedDesc,PrivRuleTypeDR,PrivRuleTypeDesc)
		s ind = ind + 1
	    s RowID = $O(^DHCEMRM.PrivRuleD(RowID))
	}
	Quit $$$OK
}

ClassMethod SelectPrivRuleByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPrivRuleByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid) //5.2.3 以下 Caceh 通过DataSet调用的自定义Query,不能调用Close方法,所以fetch后删除
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectPrivRuleByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPrivRuleByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:取DOCID
ClassMethod GetDocIDByInstanceID(argInstanceID As %String) As %String
{
	s result = ""
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.TheECRecord.RealChartItemID
	q result
}

/// Desc:取TemplateID
ClassMethod GetTemplateIDByInstanceID(argInstanceID As %String) As %String
{
	s result = ""
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.RealTemplateID
	q result
}

/// 增加维护程序脚本验证的方法
ClassMethod Test(argRuleID As %String, argEnviromentInfo As %String) As %String
{
	s aPrivRule=##class(EMRmeta.PrivRule).%OpenId(argRuleID)
	q:(aPrivRule="") "-1"
	s aPrivRuleType=##class(EMRmeta.PrivRuleType).%OpenId(aPrivRule.PrivRuleTypeDR)
	q:(aPrivRuleType="") "-1"
	s result=..TestPrivRule(argEnviromentInfo,aPrivRuleType.Name)
	
	s resultCode = $P(result, "^", 1)
	if (resultCode = "1")
	{
		q "1"
	}
	else
	{
		q result
	}
}

ClassMethod TestPrivRule(argEnviromentInfo As %String, argType As %String) As %String
{
	;s ^CacheTmpPrivRule("EMRmeta.PrivRule","argEnviromentInfo")=argEnviromentInfo
	
	s $zt="errhandle2"
	
	s result = ..ParsePrivRule(argEnviromentInfo,argType)
	q "1^"_result
	
errhandle2
	q "0^"_$zerror
}

/// Creator：      houj
/// CreatDate：    2014-11-18
/// Description:   获取授权级别权限规则
/// Table：        
/// Input：        
/// Output：      	
/// Return：      
/// Others
/// Debug:d ##Class(EMRservice.BL.BLPrivRule).GetAuthLevelPriv()
ClassMethod GetAuthLevelPriv(argEnvInfo As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	s result = ..ParsePrivRule(argEnvInfo,"AuthLevelPrivilege")
	q ..PrivStringToArray(result)
}

/// Creator：      houj
/// CreatDate：    2010-10-28
/// Description:   获取授权权限规则
/// Table：        
/// Input：        
/// Output：      	
/// Return：      
/// Others
/// Debug:d ##Class(EMRservice.BOPrivRule).GetAppointPriv()
ClassMethod GetAppointPriv(argEnvInfo As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	s result = ..ParsePrivRule(argEnvInfo,"AppointPrivilege")
	q ..PrivStringToArray(result)
}

ClassMethod PrivStringToArray(privString As %String) As %ArrayOfDataTypes
{
	s arr = ##class(%ArrayOfDataTypes).%New()
	
	if (privString '= "")
	{
		s count=$l(privString,"!")
		for i=1:1:count
		{
			d arr.SetAt($p($p(privString, "!", i), "^", 2), $p($p(privString, "!", i), "^", 1))		 
		}
	}
	
	q arr
}

/// Desc:取TitleName
ClassMethod GetTitleNameByInstanceID(argInstanceID As %String) As %String
{
	s result = ""
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.Title
	q result
}

}
