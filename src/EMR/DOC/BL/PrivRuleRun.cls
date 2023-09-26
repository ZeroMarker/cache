/// 名称:	EMR.DOC.BL.PrivRuleRun
/// 描述:	权限规则脚本运行业务类
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PrivRuleRun Extends EMR.DOC.COM.ActionBase [ Not ProcedureBlock ]
{

/// Desc:       测试脚本
/// Creator:    huhao
/// CreateDate: 2022-5-10
/// Input:      RuleCode：脚本内容
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: 	
ClassMethod TestRuleCode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorT"
	;s enviromentInfo ="userid^3928!admid^201871!patientid^1!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67!isnewframework^1!eprnum^1"
	s enviromentInfo=##class(EMR.DOC.DTO.PrivRuleData).%New()
	s ArrDocIds=##class(%DynamicArray).%New()
	s enviromentInfo.userid=3928
	s enviromentInfo.admid=201871
	s enviromentInfo.patientid=1
	s enviromentInfo.userloc=34
	s enviromentInfo.templateid=822
	s enviromentInfo.documentid=""
	s enviromentInfo.ssgroupid=576
	s enviromentInfo.documentids=ArrDocIds
	s enviromentInfo.categoryid=642
	s enviromentInfo.doccode=""
	s enviromentInfo.sessionid=""
	s enviromentInfo.docname=""
	s enviromentInfo.productcode="OP"
	
	s argType=argInJson.params.RuleType
	s HospGroupID=argInJson.params.HospGroupID
	
	s strRes = ##Class(EMR.DOC.BL.PrivRuleRun).ParsePrivRule(enviromentInfo,argType,HospGroupID,.argOutData) 
	 
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","脚本内容有误",2)
	}
ErrorT
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       取脚本信息
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// InPut:      aPrivRule 方法参数(userid^3928!admid^201871!patientid^1!documentid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!doccode^67)
///            argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// Output:     脚本List
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()      
ClassMethod GetPrivRuleByType(aPrivRule As EMR.DOC.DTO.PrivRuleData, argType As %String, ByRef argOutJson As %DynamicAbstractObject = "") As %String
{
 
	s strRes = "1"
	s strRes = ..ParsePrivRule(aPrivRule,argType,"",.argOutJson)
	q strRes
}

/// Desc:           运行权限脚本
/// Modifier:       yejian
/// ModifyDateDime: 2022-9-27
/// InPut:          aPrivRule 方法参数(userid^3928!admid^201871!patientid^1!documentid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!doccode^67)
///                 argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// 				aHospGroupID 院区分组ID
/// 				argProductCode 项目标识（OP 门诊，IP 住院
/// OutPut:         view^1!save^1!print^1!check^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0!revise^0!commit^1
/// Return 			成功 1，失败 -1^失败信息
ClassMethod ParsePrivRule(aPrivRule As EMR.DOC.DTO.PrivRuleData, argType As %String, aHospGroupID As %String = "", ByRef argOutJson As %DynamicAbstractObject = "") As %String
{
	;s result = "save^1!print^1!delete^1!check^1!recheck^0!revokcheck=0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^0!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0!patcheck^1!patrecheck^1"
	s argOutJson = {"save":"1","print":"1","delete":"1","check":"1","recheck":"0","revokcheck":"0","reference":"1","export":"1","view":"1","new":"1","copypaste":"1","revise":"-1","viewrevise":"1","appoint":"1","authlevel":"300","commit":"1","applyedit":"0","unlock":"1","transfer":"1","quote":"0","autoapply":"0","patcheck":"1","patrecheck":"1"}
	s strRes = "1"
	s PrivControl = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("PrivControl",aPrivRule.productcode)
	q:(PrivControl '= "Y") strRes
	//院区ID为空根据科室ID获取院区分组ID
	if (aHospGroupID="")&&(aPrivRule.userloc'="")
	{
		s HospID=$p($g(^CTLOC(aPrivRule.userloc)),"^",22)
		s:(HospID'="") aHospGroupID=$p($g(^CT("HOSP",HospID)),"^",41)
	}
	;k SQLCODE
	s ruleID = ""
	&sql(SELECT ID into:ruleID FROM CF_EMR_DOC.PrivRule WHERE Valid='1' AND RuleType->Name=:argType AND HospGroupID=:aHospGroupID)
	//如果根据院区分组ID没有取到，则取没有院区的规则ID
	if (ruleID="")
	{
		&sql(SELECT ID into:ruleID FROM CF_EMR_DOC.PrivRule WHERE Valid='1' AND RuleType->Name=:argType AND HospGroupID is null)
	}
	q:(ruleID = "") ""
	s objPrivRule = ##class(CF.EMR.DOC.PrivRule).%OpenId(ruleID)
	q:(objPrivRule = "") ""
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
	s operators = operators_",revise=-1"           //留痕(-1 签名后自动启用留痕,0 是关闭,1 是启用)
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
	s strRes = ..ParsePrivRuleLogic(operators,aPrivRule,objPrivRule.Code,.argOutJson)
	q strRes
}

/// Desc:           脚本计算逻辑
/// Modifier:       Candy
/// ModifyDateDime: 2015-3-9
/// InPut:          argoperators 操作符集合
///                 aPrivRule 方法参数(userid^3928!admid^201871!patientid^1!documentid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!doccode^67)
///                 argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// OutPut:         result  {view:1,save^1!print^1!residentcheck^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0}
/// Return 			成功 1，失败 -1^失败信息
ClassMethod ParsePrivRuleLogic(argoperators As %String, aPrivRule As EMR.DOC.DTO.PrivRuleData, argCode As %String, ByRef resJson As %DynamicAbstractObject = "") As %String
{
	s $zt = "ErrorParse"
	s strRes = "1"
	q:(argoperators = "")||(aPrivRule = "") "-1^规则脚本对象或规则类型为空"
	q:(aPrivRule.admid="")||(aPrivRule.productcode="") "-1^就诊号、项目标识不能为空"
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
				s curRule = $p(aRuleCode,"$$",j)
				if ((j#2)'=0) 
				{
					s finalCode = finalCode_curRule
				}
				else 
				{
					s runRes = ..ReplaceFunction(curRule,aPrivRule)
					if (runRes [ "-1^") 
					{
						s strRes = runRes
						q
					}
					//脚本中"$$GetAppoint$$"脚本内容的返回值不能有双引号，否则会导致脚本校验失败，脚本不起作用  -- modify by 牛才才
					if ($p(aRuleCode,"$$",j) = "GetAppoint")
					{
						s finalCode = finalCode_runRes
					}
					else
					{
						s finalCode = finalCode_""""_runRes_""""
					}
				}
			}
		}
		x finalCode
	}

	s:(resJson="") resJson = ##class(%DynamicObject).%New()
	for i=1:1:$l(argoperators,",")
	{
		s operator = $p($p(argoperators,",",i),"=",1)
		//输出为字符拼接格式
		;s:(i '= 1) result = result_"!"
		;s result = result_operator_"^"_@operator
		//输出为JSON格式数据
		s itemValue = "s resJson."_operator_"="""_@operator_""""
		x itemValue
	}	
	d aPrivRule.%Close()
	q strRes
ErrorParse
	s:(strRes'["-1^") strRes = "-1^"
	s strError = $tr($zerror,"^",",")
	q strRes_strError
}

/// Desc:           运行权限脚本方法
/// Modifier:       Candy
/// ModifyDateDime: 2015-3-9
/// InPut:          argNominalFunc 脚本函数
///                 aPrivRule 方法参数(userid^3928!admid^201871!patientid^1!documentid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!doccode^67)
/// OutPut:         函数值
ClassMethod ReplaceFunction(argNominalFunc As %String, aPrivRule As EMR.DOC.DTO.PrivRuleData) As %String
{
	s $zt = "Error"
	s execCode = ""
	s userid = aPrivRule.userid
	s userloc = aPrivRule.userloc
	s ssgroupid = aPrivRule.ssgroupid
	s admid = aPrivRule.admid
	s patientid = aPrivRule.patientid
	s documentid = aPrivRule.documentid
	s doccode = aPrivRule.doccode
	s:(doccode = "") doccode = ..GetDocCodeByDocumentID(documentid)
	s templateid = aPrivRule.templateid
	s:(templateid = "") templateid = ..GetTemplateIDByDocumentID(documentid)
	s sessionID = aPrivRule.sessionid
	s docname =aPrivRule.docname
	s:(docname = "") docname = ..GetDocNameByDocumentID(documentid)
	s productcode = aPrivRule.productcode
	//取登录医生的职称
	s Ctctp=""
	s Ctctp=##Class(EMR.DOC.BL.PrivAssist).GetCTCPT(userid)
	
	///返回实例ID
	if argNominalFunc = "documentid" {q documentid} 
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
	
	///返回DocID
	elseif argNominalFunc = "doccode" {q doccode}
	
	//返回登录医生职称代码ID
	elseif argNominalFunc = "CTCTP" {q Ctctp}
	
	//取当前文档TemplateID
	elseif argNominalFunc = "TemplateID" {q templateid}
	
	//用户是否为患者的主管医生
    elseif argNominalFunc = "BelongToMe" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatBelongDoc("_admid_","_userid_")"}
    
    //用户是否为指定患者主管医生的上级医生
	elseif argNominalFunc = "BelongToSubdoc" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatBelongSubDocs("_admid_","_userid_")"}
    
    //病人是否属于科室
	elseif argNominalFunc = "BelongToLoc" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatBelongToLoc("_admid_","_userloc_","""_productcode_""")"}
    
 	//病人是否属于相关科室
	elseif argNominalFunc = "BelongToLinkLoc" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatBelongToLinkLoc("_admid_","_userloc_","""_productcode_""")"}  
    
 	//病历是否转移到用户登录科室
	elseif argNominalFunc = "BelongTransLoc" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatBelongTransLoc("_admid_","_userloc_","""_productcode_""")"}  
    
	//用户是否属于病区
	elseif argNominalFunc = "BelongToWard" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatBelongToWard("_admid_","_userloc_")"}    
    
 	//病人是否已出院
	elseif argNominalFunc = "IsDisCharge" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsDisCharge("""_admid_""")"}   
    
 	//是否住院病人(原意是病人需要写病历，门诊或退院病人不需要写病历)
	elseif argNominalFunc = "PatNeedDoc" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).PatNeedDoc("""_admid_""")"} 
	
	//用户是否为医生
	elseif argNominalFunc = "UserIsDoc" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).UserIsDoc("""_userid_""")"}   
    
	//病人是否门诊病人
	elseif argNominalFunc = "OutPatient" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsOutPatient("""_admid_""")"}
	
	//病历是否为登录用户创建
	elseif argNominalFunc = "RecBelongToMe" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsRecBelongDoc("""_admid_""","""_documentid_""","""_userid_""")"}	

	//病历是否保存
    elseif argNominalFunc = "IsSaved" {s execCode = "runRes=##class(EMR.DOC.BL.PrivAssist).IsRecordInstanceSaved("""_documentid_""")"}
	//病历是否打印
	elseif argNominalFunc = "IsPrinted" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsRecordActioned("""_admid_""","""_documentid_""",""Print"")"}

	//病历是否全部完成
	elseif argNominalFunc = "IsRecordCompleted" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsRecordCompleted("""_admid_""")"}
	
	//病历是否住院医师审核
	elseif argNominalFunc = "IsResidentChecked" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsResidentChecked("""_admid_""","""_documentid_""")"}
	
	//病历已主治医师审核
	elseif argNominalFunc = "IsAttendingChecked" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsAttendingChecked("""_admid_""","""_documentid_""")"}
	
	//病历已主任医师审核 
	elseif argNominalFunc = "IsChiefChecked" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsChiefChecked("""_admid_""","""_documentid_""")"}

	//用户是否为病历创建人的上级医生
	elseif argNominalFunc = "IsUpUser" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsUpUser("""_admid_""","""_documentid_""","""_userid_""")"}	

	//用户是否为病历操作者的上级医生
	elseif argNominalFunc = "IsUpLevelUser" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsUpLevelUser("""_admid_""","""_documentid_""","""_userid_""")"}
	//用户是否为病历创建者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
	elseif argNominalFunc = "IsCreatorUpUserByGroup" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByGroup("""_admid_""","""_documentid_""","""_userid_""")"}
	
	//用户是否为病历操作者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
	elseif argNominalFunc = "IsOperateorUpUserByGroup" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsOperateorUpUserByGroup("""_admid_""","""_documentid_""","""_userid_""")"}
	//用户是否为病历创建者的上级医师(取HIS医疗组)
	elseif argNominalFunc = "IsCreatorUpUserByHISGroup" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByHISGroup("""_documentid_""","""_userid_""")"}
	
	//用户是否为病历操作者的上级医师(取HIS医疗组)
	elseif argNominalFunc = "IsOperaterUpUserByHISGroup" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsOperaterUpUserByHISGroup("""_documentid_""","""_userid_""")"}
	
	//患者是否出院超过3天
	elseif argNominalFunc = "IsDischargedThreeDay" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsDischargedNHours("""_admid_""",72)"}

	//患者是否出院超过5天
	elseif argNominalFunc = "IsDischargedFiveDay" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsDischargedNHours("""_admid_""",120)"}
	
	//患者是否已出院5个工作日
	elseif argNominalFunc = "IsDisFiveWorkDay" {s execCode="runRes=##Class(EMR.DOC.BL.PrivAssist).IsDisFiveWorkingDay("""_admid_""")"}
	
	//病案室是否将病历回收
	elseif argNominalFunc = "IsRecordRetrieve" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsRecordRetrieve("""_admid_""")"}
	
	//病案室是否已将病历归档
	elseif argNominalFunc = "IsRecordArchived" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsRecordArchived("""_admid_""")"}
	
	//病案室是否复印病历
	
	elseif argNominalFunc = "IsCopy" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsCopy("""_admid_""")"}
	//出院日期(医生医疗结算,格式yyyy-mm-dd)
	
	elseif argNominalFunc = "DisDateByDoctor" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetDisDate("""_admid_""",""ByDoctor"")"}
	
	//出院日期(护士最终结算,格式yyyy-mm-dd) 
	elseif argNominalFunc = "DisDateByNurse" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetDisDate("""_admid_""",""ByNurse"")"}
	
	//入院时间间隔(单位:小时)
   	elseif argNominalFunc = "AdmTimeGap" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetAdmTimeGap("_admid_")"}
	
	//出院时间间隔(单位:小时)
	elseif argNominalFunc = "DisTimeGap" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetDisTimeGap("_admid_")"}
	
	//入院时间间隔[护士分床时间](单位:小时)
   	elseif argNominalFunc = "AdmTimeInBedGap" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetAdmTimeInBedGap("_admid_")"}
	
	//入院时间间隔[护理组体温单记录的入院时间](单位:小时)
   	elseif argNominalFunc = "InhsAdmTimeGap" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetInhsAdmTimeGap("_admid_")"}

	//判断病人当前是否已出院[1-已出院,0-在院]
	elseif argNominalFunc = "IsPatientDischarge" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatientDischarge("_patientid_")"}
	
	///取创建者的安全组ID
	elseif argNominalFunc = "CreaterGroupID" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetCreaterGroupID("""_documentid_""")"}
	
	///取最后一次操作者的安全组ID  
	elseif argNominalFunc = "LastModifierGroupID" { s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetLastModifierGroupID("""_documentid_""")"}
	
	//获取病历授权功能赋予的操作权限 liuzhongwan 增加一个入参DocID
	elseif argNominalFunc = "GetAppoint" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetAppiont("""_admid_""","""_userid_""","""_userloc_""","""_documentid_""","""_doccode_""")"}
	
	///可否复制粘贴
	elseif argNominalFunc = "CanCopyPaste"{q ##Class(EPRservice.Quality.BOUserCopyPastePower).GetUserCopyPastePower(userid)}
	
	//获取患者的当前科室id，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "GetCurrentDept" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetCurrentDept("""_admid_""")"}
	
	//获取登录用户医疗小组（医疗单元）信息，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "userUnit" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetUserUnit("""_userloc_""","""_userid_""")"}
	
	//获取（ICU患者转入ICU之前科室的主管医生）医疗小组（医疗单元）信息，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "BefTransToICUMainDocUnit" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetBefTransToICUMainDocUnit("""_admid_""")"}
	
	//获取ICU患者转入ICU之前的科室信息，不区分新框架  add by niucaicai 2016-01-12
	elseif argNominalFunc = "LocBefTransToICU" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetLocBefTransToICU("""_admid_""")"}

	//取手术病历术者
	elseif argNominalFunc = "GetOperationUser" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetOperationUser("""_documentid_""")"}

	//取手术病历一助
	elseif argNominalFunc = "GetOperationAssistFirst" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetOperationAssistFirst("""_documentid_""")"}

	//患者医嘱表是否被锁定
	elseif argNominalFunc = "OrdHasLocked" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsOrdHasLocked("""_admid_""","""_userid_""","""_userloc_""","""_sessionID_""")"}

	//病历是否超时未完成  add by niucaicai 2016-08-31
	elseif argNominalFunc = "IsRecordOverRan" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsRecordOverRan("""_documentid_""")"}
	
	//青医判断是否可确认病历全部完成，即“送病案室”（只有做了最终结算才可确认病历全部完成）
	elseif argNominalFunc = "IsDocCommit" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsDocCommit("""_admid_""")"}
	
	//无纸化医生病历是否提交
	elseif argNominalFunc = "MRstatus" {s execCode="runRes=##class(DHCEPRFS.BL.BLPrivilege).CheckDoc("""_admid_""")"}
	
	//病历是否有有效签名(任何级别都可以)  add by yan 2017-07-31
	elseif argNominalFunc = "HasValidSign" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).HasValidSign("""_documentid_""")"}
	
	//转科时间间隔(单位:小时)
   	elseif argNominalFunc = "TransCTLOCGap" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetTransCTLOCGap("""_admid_""")"}
   	
   	//该科室是否为转科前科室
   	elseif argNominalFunc = "IsTransPreviousCTLOC" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsTransPreviousCTLOC("""_admid_""","""_userloc_""")"}
   	
   	//用户是否为病历最后操作者
	elseif argNominalFunc = "IsOperateor" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsOperateor("""_admid_""","""_documentid_""","""_userid_""")"}
	
	//用户是否为病历操作者的HIS医疗组组长
	elseif argNominalFunc = "IsOperaterHISGroupLeader" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsOperaterHISGroupLeader("""_documentid_""","""_userid_""")"}
	
	//当前科室是否为检查检验病理医嘱接收科室
   	elseif argNominalFunc = "IsAdmRecDep" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsAdmRecDep("""_admid_""","""_userloc_","""_productcode_""")"} 
   	
   	//该用户是否为患者的会诊医生
   	elseif argNominalFunc = "IscoustUser" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IscoustUser("""_admid_""","""_userid_""")"}

    	//患者是否有传染病未上报(未上报不能书写病历)
	elseif argNominalFunc = "IsEpdReport" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsEpdReport("""_admid_""")"}
 
	//当前科室是否为会诊科室
   	elseif argNominalFunc = "IsAdmConsultDep" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsAdmConsultDep("""_admid_""","""_userloc_""")"}
 
    	//该用户是否为主刀医生
   	elseif argNominalFunc = "IsAdmOperInfo" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsAdmOperInfoForEMR("""_admid_""","""_userid_""")"}
   
    	//护士确认病历是否完成
 	elseif argNominalFunc = "IsFinalNurseFlag" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsFinalNurseFlag("""_admid_""")"}
   
    	//是否当前用户为患者历次就诊中门诊就诊的接诊医师
	elseif argNominalFunc = "IsOPVisitDoctor" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsOPVisitDoctor("""_patientid_""","""_admid_""","""_userid_""")"}

    //要引用的病历模板版本是否为当前最新版本
 	elseif argNominalFunc = "IsLatestVersion" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsLatestVersion("""_documentid_""")"}
 
 	//要引用的病历就诊时间间隔(单位:小时)
   	elseif argNominalFunc = "OpHistoryAdmTimeGap" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetOpHistoryAdmTimeGap("""_documentid_""")"}

    //指定模板控制当前模板是否可创建(例如：放疗观察表已经写完才可以创建放疗观察表续页)
	elseif argNominalFunc = "CanCreateByFisrtRecord" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).CanCreateByFisrtRecord("_admid_","_doccode_","""_productcode_""")"}  
	
	//是否触犯质控中的创建标准
	elseif argNominalFunc = "IsCreateDocQuality" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetCreateDocQualityList("""_admid_""","""_templateid_""","""_docname_""")"}
	
	//病人是否在当前科室就诊过
	elseif argNominalFunc = "RecentAdmBelongToLoc" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsPatRecentAdmBelongToLoc("_patientid_","_userloc_")"}
	
	//患者手工质控条目是否完成
 	elseif argNominalFunc = "GetMessageFlagByEpisodeID" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetMessageFlagByEpisodeID("""_admid_""")"}
	
 	//取病历创建者
   	elseif argNominalFunc = "RecCreator" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetRecCreator("""_documentid_""")"}
 	
 	//登录用户是否为病历的签名医师
	elseif argNominalFunc = "IsRecSignUser" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsRecSignUser("""_admid_""","""_documentid_""","""_userid_""")"}	
	
	//是否为创建者的上级医师（取his的维护程序,安医附院，不分医疗组）
	elseif argNominalFunc = "IsCreatorUpUserByHISAY" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByHISAY("""_documentid_""","""_userid_""")"}
    
    //获取自动审批次数
    elseif argNominalFunc = "AutoApplyCount" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetAutoApplyCount("""_documentid_""","""_userid_""")"}

	//获取依据患者当前就诊，判定浏览选中就诊是否可以显示
    elseif argNominalFunc = "IsSameUserLocTypeWithSelEpisode" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsSameUserLocTypeWithSelEpisode("""_userloc_""","""_admid_""")"}
	
	//获取日志打印操作用户的默认安全组数据
	elseif argNominalFunc = "getActionOperUserSSGroupID" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetActionOperUserSSGroupID("""_admid_""","""_documentid_""",""Print"")"}

	//病历是否封存
	elseif argNominalFunc = "IsSealed" {s execCode = "runRes=##class(EMR.DOC.BL.PrivAssist).IsRecordInstanceSealed("""_admid_""","""_documentid_""")"}

	//门诊历史病历，要引用的病历是否为当前就诊类型
	elseif argNominalFunc = "IsBelongToCurrentAdmType" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsBelongToCurrentAdmType("""_admid_""","""_documentid_""")"}
	
	//病历是否与输血申请单关联
    elseif argNominalFunc = "IsLinkBlood" {s execCode = "runRes=##class(EMR.DOC.BL.PrivAssist).IsLinkBlood("""_documentid_""")"}
    
    //病历是否有住院及以上级别签名（EMRmeta.SignRole的RoleLevel大于0）
    elseif argNominalFunc = "HasAboveResidentLevelSign" {s execCode = "runRes=##class(EMR.DOC.BL.PrivAssist).HasAboveResidentLevelSign("""_admid_""","""_documentid_""")"}
    
    //用户是否为病历创建者的上级医师(取HIS，不分医疗组)
	elseif argNominalFunc = "IsCreatorUpUserByHIS" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByHIS("""_documentid_""","""_userid_""")"}

	//病历是否有有效的患者签名
	elseif argNominalFunc = "HasValidAnySign" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).HasValidAnySign("""_admid_""","""_documentid_""")"}

	//转科患者，病历HappenDateTime时刻科室与当前登录科室是否一致。 非转科患者默认1。
	elseif argNominalFunc = "IsSameLocInstanceWithUser" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).IsSameLocInstanceWithUser("""_documentid_""","""_userloc_""")"}
	
	//病历HappenDateTime时刻所在科室ID
	elseif argNominalFunc = "LocIDAtInstanceFinish" {s execCode="runRes=##class(EMR.DOC.BL.PrivAssist).GetLocIDAtInstanceFinish("""_documentid_""")"}
	
	s @execCode
	q @"runRes"
Error
	s strError = $tr($zerror,"^",",")
	q "-1^脚本运行错误,"_"NominalFunc:"_argNominalFunc_","_strError
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

ClassMethod ParseEnvInfo(argEnvInfo As %String, ByRef argEnvInfoName As %List, ByRef argEnvInfoData As %List) As %Status
{
	for i=1:1:$l(argEnvInfo,"!") {
		s aInfo = $p($g(argEnvInfo),"!",i)
		s argEnvInfoName = argEnvInfoName_$lb($p($g(aInfo),"^",1))
		s argEnvInfoData = argEnvInfoData_$lb($p($g(aInfo),"^",2))
	}
	q 1
}

/// Desc:取TemplateID
ClassMethod GetTemplateIDByDocumentID(ADocumentID As %String) As %String
{
	s result = ""
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s result = objDocument.TemplateID.%Id()
	q result
}

/// Desc:取DOCID
ClassMethod GetDocCodeByDocumentID(ADocumentID As %String) As %String
{
	s result = ""
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s result = objDocument.DOCCode
	q result
}

/// Desc:取DocName
ClassMethod GetDocNameByDocumentID(ADocumentID As %String) As %String
{
	s result = ""
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s result = objDocument.DOCName
	q result
}

}
