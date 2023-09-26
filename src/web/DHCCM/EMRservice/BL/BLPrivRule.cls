Class web.DHCCM.EMRservice.BL.BLPrivRule Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
	
	//病历是否为登录用户创建
	elseif argNominalFunc = "RecBelongToMe" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecBelongDoc("""_admid_""","""_instanceid_""","""_userid_""")"}	

	//病历是否保存
    elseif argNominalFunc = "IsSaved" {s execCode = "result=##class(EMRservice.BOPrivAssist).IsRecordInstanceSaved("""_instanceid_""")"}

	//病历是否打印
	elseif argNominalFunc = "IsPrinted" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordActioned("""_admid_""","""_instanceid_""",""Print"")"}
	
	//病历是否全部完成
	elseif argNominalFunc = "IsRecordCompleted" {s execCode="result=##class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus("""_admid_""")"}
	
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
	
	//患者是否出院超过3天
	elseif argNominalFunc = "IsDischargedThreeDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHours("""_admid_""",72)"}

	//患者是否出院超过5天
	elseif argNominalFunc = "IsDischargedFiveDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDischargedNHours("""_admid_""",120)"}
	
	//患者是否已出院5个工作日
	elseif argNominalFunc = "IsDisFiveWorkDay" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsDisFiveWorkingDay("""_admid_""")"}
	
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
	elseif argNominalFunc = "titlecode" {s execCode="result=##class(EMRservice.BOPrivAssist).GetTitleCode("""_instanceid_""")"}
	
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
	s result = "save^1!print^1!delete^1!check^1!recheck^0!revokcheck=0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^0!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0"
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
	s aPrivRule=""
	s aPrivRule=##class(EMRmeta.PrivRule).%New()
	q:(aPrivRule="") 0
	

	
	s aPrivRule.Name=argPrivRule.Name
	s aPrivRule.Code=argPrivRule.Code
	s aPrivRule.Valid=argPrivRule.Valid
	s aPrivRule.PrivRuleTypeDR=argPrivRule.PrivRuleTypeDR
	
	s aPrivRuleLog=""
	s aPrivRuleLog=##class(EMRmeta.PrivRuleLog).%New()
	q:(aPrivRuleLog="") 0
	
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
	
	if '(aPrivRule.%Save())
	{
		Quit 0
	} 
	if '(aPrivRuleLog.%Save())
	{
		Quit 0
	} 
	Quit aPrivRule.%Id()
}

ClassMethod Delete(argPrivRuleID As %String, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q:($d(argPrivRuleID)=0)||(argPrivRuleID="") 0
	s aPrivRule="",result=""
	s aPrivRule=##class(EMRmeta.PrivRule).%OpenId(argPrivRuleID)
	q:(aPrivRule="") 0
	s aPrivRule=""
	
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
	
	if '(aPrivRuleLog.%Save())
	{
		Quit 0
	}
	 
	s result=##class(EMRmeta.PrivRule).%DeleteId(argPrivRuleID)
	q result
}

ClassMethod Update(argPrivRule As EMRservice.entity.EPrivRule, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q:($d(argPrivRule)=0)||(argPrivRule="") 0
	s aPrivRule="",result=""
	s aPrivRule=##class(EMRmeta.PrivRule).%OpenId(argPrivRule.ID)
	q:(aPrivRule="") 0
	
	s aPrivRule.Name=argPrivRule.Name
	s aPrivRule.Code=argPrivRule.Code
	s aPrivRule.Valid=argPrivRule.Valid
	s aPrivRule.PrivRuleTypeDR=argPrivRule.PrivRuleTypeDR
	
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
		Quit 0
	} 
	if '(aPrivRuleLog.%Save())
	{
		Quit 0
	} 
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
/// Debug:w ##Class(%ResultSet).RunQuery("EMRservice.BOPrivRule","SelectPrivRuleAll")
Query SelectPrivRuleAll() As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Valid:%String,ValidDesc:%String,IsUsed:%String,IsUsedDesc:%String,PrivRuleTypeDR:%String,PrivRuleTypeDesc:%String")
{
}

ClassMethod SelectPrivRuleAllExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s RowID="",Name="",Code="",Valid="",ValidDesc="",IsUsed="",IsUsedDesc="",PrivRuleTypeDR="Null",PrivRuleTypeDesc="Null"
	s objPrivRuletype=""
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
		s ^CacheTemp(repid, ind) = $LB(RowID,Name,Code,Valid,ValidDesc,IsUsed,IsUsedDesc,PrivRuleTypeDR,PrivRuleTypeDesc)
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
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.TheECRecord.ChartItemID
	q result
}

/// Desc:取TemplateID
ClassMethod GetTemplateIDByInstanceID(argInstanceID As %String) As %String
{
	s result = ""
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.TemplateID
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
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.Title
	q result
}

}
