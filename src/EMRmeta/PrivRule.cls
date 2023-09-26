Class EMRmeta.PrivRule Extends %Persistent
{

Index IdxName On Name [ Data = Name, Unique ];

Property Name As %String(TRUNCATE = 1);

Property Code As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Valid As %String(TRUNCATE = 1);

Property PrivRuleTypeDR As %String(TRUNCATE = 1);

/*
Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Code:%String,Valid:%String,PrivRuleTypeDR:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_PrivRule_SELECTALL, SqlProc ]
{
 	SELECT ID,Name, Code, Valid,PrivRuleTypeDR
 	FROM EMRmeta.PrivRule
 	ORDER BY ID
}

/// parse the privilege rule, and return the privilege result
/// argEnviromentInfo(temporary): userid, patid, instanceid. format: userid^1!patid^22!instanceid^65||1
/// return value format: view^1!save^1!print^0!commit^0
Method ParsePrivRule(argEnviromentInfo As %String) As %String
{
	s ^CacheTmpPrivRule("EMRmeta.PrivRule","argEnviromentInfo")=argEnviromentInfo
	
	s $zt="errhandle"
	
	q ..ParsePrivRuleLogic(argEnviromentInfo)
	
errhandle
	q "view^1!save^1!print^1!commit^1!switch^1!switchtemplate^1!chiefcheck^1!attendingcheck^1!browse^1!printaftercommit^0!load^1"_"!appoint^0"_"!reference^0!export^0!new^1"
}

Method TestPrivRule(argEnviromentInfo As %String) As %String
{
	s ^CacheTmpPrivRule("EMRmeta.PrivRule","argEnviromentInfo")=argEnviromentInfo
	
	s $zt="errhandle2"
	
	s result = ..ParsePrivRuleLogic(argEnviromentInfo)
	q "1^"_result
	
errhandle2
	q "0^"_$zerror
}

Method ParsePrivRuleLogic(argEnviromentInfo As %String) As %String
{
	s ruleCodes=##this.Code
	
	//gjb add 2008-8-14
	//set default value for every action
	s @"view=1"					//界面模板查看
	s @"save=1"					//保存
	s @"print=1"				//打印
	s @"commit=1"				//提交
	s @"switch=1"				//
	s @"switchtemplate=1"		//
	s @"chiefcheck=0"			//主任医师审核
	s @"attendingcheck=0"		//主治医师审核
	s @"browse=1"				//浏览病历图片
	s @"printaftercommit=0"		//病历提交后才可打印
	s @"load=1"   				//病历结构打印模板下界面模板是否加载,1:加载,0:不加载
	s @"appoint=0"				//授权操作<+added on 2010-10-25 by houj>
	
	s @"quitscript=0"			//临时操作关键字：结束脚本
	s @"reference=0"			//病历引用
	s @"export=0"				//病历导出
	s @"caSign=0"               //数字签名
	s @"caVerify=0"             //验证签名	
	s @"new=1"                  //新建 <add by Candyxu 2013-01-17>
	///loop every line of rule code
	for i=1:1:$l(ruleCodes,$c(10)) {
		;b "s"
		quit:(@"quitscript"=1)		//<+added on 2010-10-25 by houj:结束脚本>
		s aRuleCode=$p(ruleCodes,$c(10),i)
		continue:($e(aRuleCode,1,2)="//")||(aRuleCode="")	
		s finalCode=""
		
		s ruleSegmentsCount=$l(aRuleCode,"$$")		
		///parse one rule code, replace function definition to real value
		if ruleSegmentsCount<2 {s finalCode=aRuleCode}
		else {
			for j=1:1:ruleSegmentsCount 
			{
				;b "s"
				if ((j#2)'=0) {s finalCode=finalCode_$p(aRuleCode,"$$",j)}
				else 
				{
					s finalCode=finalCode_##this.ReplaceFunction($p(aRuleCode,"$$",j),argEnviromentInfo)
				}	
			}
		}
		;s ^gjbtest("finalCode",i)=finalCode
		
		x finalCode
	}	
	//gjb edit 2008-8-14
	;s ^gjbtest("priv")="view^"_@"view"_"!save^"_@"save"_"!print^"_@"print"_"!commit^"_@"commit"_"!switch^"_@"switch"
	q "view^"_@"view"_"!save^"_@"save"_"!print^"_@"print"_"!commit^"_@"commit"_"!switch^"_@"switch"_"!switchtemplate^"_@"switchtemplate"_"!chiefcheck^"_@"chiefcheck"_"!attendingcheck^"_@"attendingcheck"_"!browse^"_@"browse"_"!printaftercommit^"_@"printaftercommit"_"!load^"_@"load"_"!appoint^"_@"appoint"_"!reference^"_@"reference"_"!export^"_@"export"_"!new^"_@"new"
	//edit end
}

Method ReplaceFunction(argNominalFunc As %String, argEnviromentInfo As %String) As %String
{
	s execCode="",envInfoName="",envInfoData=""
	s userid="",admid="",instanceid=""
	s envInfoList=##this.ParseEnvInfo(argEnviromentInfo,.envInfoName,.envInfoData)
	
	s userid=$lg(envInfoData,$lf(envInfoName,"userid"))
	s admid=$lg(envInfoData,$lf(envInfoName,"admid"))
	s instanceid=$lg(envInfoData,$lf(envInfoName,"instanceid"))
	s userloc=$lg(envInfoData,$lf(envInfoName,"userloc"))
	s categoryid=$lg(envInfoData,$lf(envInfoName,"categoryid"))
	s templateid=$lg(envInfoData,$lf(envInfoName,"templateid"))
	s:(templateid="") templateid="0" 	//gaojb 20090906
	s ssgroupid=$lg(envInfoData,$lf(envInfoName,"ssgroupid")) 	//gaojb 20090729
	s isnewframework=$lg(envInfoData,$lf(envInfoName,"isnewframework"))  //gaojb 20090906
	s:(isnewframework="") isnewframework="0" 	//gaojb 20090906
	s patientid=$lg(envInfoData,$lf(envInfoName,"patientid"))
	s docid=$lg(envInfoData,$lf(envInfoName,"docid"))	 //PrintTemplateDocID
	s eprnum=$lg(envInfoData,$lf(envInfoName,"eprnum"))

  	//用户是患者的主管医生，不区分新框架
	if argNominalFunc="BelongToMe" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongDoc("_admid_","_userid_")"}
	//用户是指定患者主管医生的上级医生，不区分新框架
	elseif argNominalFunc="BelongToSubdoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongSubDocs("_admid_","_userid_")"}
	//病人属于科室，不区分新框架
	elseif argNominalFunc="BelongToLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToLoc("_admid_","_userloc_")"}
	//病人属于相关科室，不区分新框架
	elseif argNominalFunc="BelongToLinkLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToLinkLoc("_admid_","_userloc_")"}
	//病历转移到用户登录科室
	elseif argNominalFunc="BelongTransLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongTransLoc("_admid_","_userloc_")"} //gaojb add 2009-12-9
	//用户属于病区，不区分新框架 houj add 2008-12-24
	elseif argNominalFunc="BelongToWard" {s execCode="result=##class(EMRservice.BOPrivAssist).IsPatBelongToWard("_admid_","_userloc_")"}
	//病人已出院，不区分新框架
	elseif argNominalFunc="IsDisCharge" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDisCharge("""_admid_""")"}
	//病人是住院病人（原意是病人需要写病历，门诊或退院病人不需要写病历），不区分新框架
	elseif argNominalFunc="PatNeedDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).PatNeedDoc("""_admid_""")"} 
	//用户是医生，不区分新框架 Modify by lwp 2009-07-10
	elseif argNominalFunc="UserIsDoc" {s execCode="result=##class(EMRservice.BOPrivAssist).UserIsDoc("""_userid_""")"}
	//病人是门诊病人，不区分新框架 added on 2009-08-03 by houj -- 用于门诊医生权限
	elseif argNominalFunc="OutPatient" {s execCode="result=##class(EMRservice.BOPrivAssist).IsOutPatient("""_admid_""")"}
	//病历已保存
	elseif argNominalFunc="HasSaved" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordInstanceSaved("""_instanceid_""")"}
	elseif argNominalFunc="HasSavedNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordFinishedNew("""_admid_""","""_docid_""","""_eprnum_""")"}
	//病历由用户首次保存
	elseif argNominalFunc="RecBelongToMe" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecBelongDoc("""_instanceid_""","""_userid_""")"}
	elseif argNominalFunc="RecBelongToMeNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecBelongDocNew("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	//病历已打印 gjb add 2008-8-14
	elseif argNominalFunc="HasPrinted" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordPrinted("""_instanceid_""")"}
	elseif argNominalFunc="HasPrintedNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordPrintedNew("""_admid_""","""_docid_""","""_eprnum_""")"}
	//病历已被病案室打印  Modify by EMRmengsx 2013-06-21
     elseif argNominalFunc="HasPrintedByLoc" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordPrintedByLocNew("""_admid_""","""_docid_""","""_eprnum_""")"}
	//病历已提交 Modify by EMRwangwt 2008-10-15
	elseif argNominalFunc="HasCommited" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordInstanceCommited("""_instanceid_""")"}
	elseif argNominalFunc="HasCommitedNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordCommitedNew("""_admid_""","""_docid_""","""_eprnum_""")"}
	//用户是否为病历创建人的上级医生 Add by Liaowp 2009-06-16
	elseif argNominalFunc="ISUpUser" {s execCode="result=##class(EMRservice.BOPrivAssist).ISUpUser("""_admid_""","""_userid_""","""_userloc_""","""_instanceid_""")"}
	elseif argNominalFunc="ISUpUserNew" {s execCode="result=##class(EMRservice.BOPrivAssist).ISUpUserNew("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	//是否为病历创建人的高级别医生
	elseif argNominalFunc="ISUpLevelUser" {s execCode="result=##class(EMRservice.BOPrivAssist).ISUpLevelUser("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	elseif argNominalFunc="ISUpUserOfAttending" {s execCode="result=##class(EMRservice.BOPrivAssist).ISUpUserOfAttending("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	//取得新框架病历结构中“章”（维护程序中目录的下级）的ID，仅用于新框架
	elseif argNominalFunc="EMRChapterID" {s execCode="result=##class(EMRservice.BOPrivAssist).EMRChapterID("""_docid_""")"}
	//取得新框架病历结构中“目录”的ID，仅用于新框架
	elseif argNominalFunc="EMRCategoryID" {s execCode="result=##class(EMRservice.BOPrivAssist).EMRCategoryID("""_docid_""")"}
	//登陆用户为主任医师或主治医师<+added by houj, supposed by liaowp on 2010-02-22>
	elseif argNominalFunc="UserLevel"  {s execCode="result=##class(EMRmeta.PowerUser).GetUserLevelNew("""_userid_""")"}
	//男性患者不加载月经生育史<+add by guozongtao 2010-04-27>
	elseif argNominalFunc="LoadEprTmpByGender"  {s execCode="result=##class(EMRservice.BOPrivAssist).Gender("""_patientid_""")"}
	//是否出院三天
	elseif argNominalFunc="IsDisThreeDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDisThreeDay("""_admid_""")"} 
	//是否出院五天 wangwentao 20120823 add
	elseif argNominalFunc="IsDisFiveDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDisFiveDay("""_admid_""")"} 
	//是否出院七天  20130530 add
	elseif argNominalFunc="IsDisSevenDay" {s execCode="result=##class(EMRservice.BOPrivAssist).IsDisSevenDay("""_admid_""")"} 
	//取病案室病历是否回收的状态 [ EMRmeta.PrivRule]
	elseif argNominalFunc="RetStatus" {s execCode="result=##class(EMRservice.BOPrivAssist).GetMrRetrieveStatus("""_admid_""")"}
	//出院日期医生医疗结算(格式yyyy-mm-dd) wangwentao 20111225 add
	elseif argNominalFunc="DisDateDoctor" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDisDateDoctor("""_admid_""")"}
	//出院日期护士最终结算(格式yyyy-mm-dd) wangwentao 20111225 add
	elseif argNominalFunc="DisDateNurse" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDisDate("""_admid_""")"}
	//入院时间间隔(单位:小时)<+added on 2010-10-25 by houj>
   	elseif argNominalFunc="AdmTimeSpan" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAdmTimeSpan("_admid_")"}
	//出院时间间隔(单位:小时)<+added on 2010-10-25 by houj>
	elseif argNominalFunc="DisTimeSpan" {s execCode="result=##class(EMRservice.BOPrivAssist).GetDisTimeSpan("_admid_")"}
	//入院时间间隔[护士分床时间](单位:小时)<+added on 2010-11-03 by houj>
   	elseif argNominalFunc="AdmTimeInBedSpan" {s execCode="result=##class(EMRservice.BOPrivAssist).GetAdmTimeInBedSpan("_admid_")"}
	//入院时间间隔[护理组体温单记录的入院时间](单位:小时)<+added on 2010-11-03 by houj>
   	elseif argNominalFunc="InhsAdmTimeSpan" {s execCode="result=##class(EMRservice.BOPrivAssist).GetInhsAdmTimeSpan("_admid_")"}
	//判断病人当前是否已出院[1-已出院,0-在院]<+add by loo on 2010-09-13>
	elseif argNominalFunc="IsPatDis"{s execCode="result=##class(EMRservice.BOPrivAssist).IsPatDis("_patientid_")"}	
	//获取授权得到的操作权限[格式:一行cache代码]<+add by loo on 2010-9-25>
	elseif argNominalFunc="GetAppoint"{s execCode="result=##class(EMRservice.BOPrivAssist).GetAppiont("_admid_","_userid_","_userloc_","_docid_")"}
	//病历已主治医师审核 wangwentao 20101029 add
	elseif argNominalFunc="HasAttendingCheckedNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordAttendingCheckedNew("""_admid_""","""_docid_""","""_eprnum_""")"}
	//病历已主任医师审核 wangwentao 20101029 add
	elseif argNominalFunc="HasChiefCheckedNew" {s execCode="result=##class(EMRservice.BOPrivAssist).IsRecordChiefCheckedNew("""_admid_""","""_docid_""","""_eprnum_""")"}
	/// 取创建者的安全组ID LingChen  
	elseif argNominalFunc="CreaterGrpID" 
	{ s execCode="result=##class(EMRservice.BOPrivAssist).GetCreaterGrpID("""_admid_""","""_docid_""","""_eprnum_""")"}
	/// 取最后一次保存者的安全组ID LingChen  
	elseif argNominalFunc="LastSaverGrpID" 
	{ s execCode="result=##class(EMRservice.BOPrivAssist).GetLastSaverGrpID("""_admid_""","""_docid_""","""_eprnum_""")"}
	//取病历类型ID wangwentao 20110315 add
	elseif argNominalFunc="PatTpyeID" {s execCode="result=##class(EMRservice.BOPrivAssist).GetPatTpyeID("""_admid_""")"}
	//病案室是否已将病历归档
	elseif argNominalFunc="HasMRArchived" {s execCode="result=##class(EMRservice.BOPrivAssist).HasMRArchived("""_admid_""")"}
	//患者是否已出院5个工作日
	elseif argNominalFunc="IsDisFiveWorkDay" {s execCode="result=##Class(EMRservice.BOPrivAssist).IsDisFiveWorkingDay("""_admid_""")"}
	//科室是否开启ca服务
	elseif argNominalFunc="IsCACTLoc"{s execCode="result=##class(EMRservice.BOPrivAssist).IsCACTLoc("""_userloc_""")"}
	//是否有有效的数字签名
	elseif argNominalFunc="HasValidSign"{s execCode="result=##class(EMRservice.BOPrivAssist).HasValidSign("""_admid_""","""_docid_""","""_eprnum_""")"}
	//[补]获取病历书写操作权限通过医嘱项字串 wangwentao 20111012 add
	elseif argNominalFunc="PrivByOrdItem" {
		s execCode="result=##class(EMRservice.BOPrivAssist).GetPrivilegeByOrdItem("""_admid_""")"
	}	
	//是否有科主任审核	
	elseif argNominalFunc="HasChairmanCheck"{s execCode="result=##Class(EMRservice.BOPrivAssist).HasChairmanCheck("""_admid_""","""_docid_""","""_eprnum_""")"}		
	//是否包括全部签名 大同三院需求 	
	elseif argNominalFunc="HasAllSign"{s execCode="result=##Class(EMRservice.BOPrivAssist).HasAllSign("""_admid_""","""_docid_""","""_eprnum_""")"}
	//是否完成三级医师审核
	elseif argNominalFunc="Has3LvlsAudit"{s execCode="result=##Class(EMRservice.BOPrivAssist).Has3LvlsAudit("""_admid_""","""_docid_""","""_eprnum_""")"}
	//根据唯一模板单元的值判断可重复模板是否可以操作
	elseif argNominalFunc="GetFlagByItemValue"{s execCode="result=##Class(EMRservice.BOPrivAssist).GetFlagByItemValue("""_admid_""","""_docid_""")"}
    //取登陆医生职称 liaowp 20110917 add
	elseif argNominalFunc="UserCareer" {s execCode="result=##Class(EMRservice.BOPrivAssist).CurUserCareer("""_userid_""")"}
	//是否在集中打印中打印过
	elseif argNominalFunc="HasCentralizePrinted"{s execCode="result=##Class(EMRservice.BOPrivAssist).HasCentralizePrinted("""_admid_""","""_docid_""")"}
	//病案室是否在一键打印中打印过
	elseif argNominalFunc="HasMROneStepPrinted"{s execCode="result=##Class(EMRservice.BOPrivAssist).HasMROneStepPrinted("""_admid_""","""_docid_""")"}
	//病历提交据现在时间段（小时）（新框架）
	elseif argNominalFunc="RecordCommitedSpanHourNew"{s execCode="result=##Class(EMRservice.BOPrivAssist).RecordCommitedSpanHourNew("""_admid_""","""_docid_""","""_eprnum_""")"}
	//病历完成距现在的时间段(小时或天数,默认返回小时数) (新框架) hanxf20130805
    elseif argNominalFunc="RecordCmpSpanHoursNew"{s execCode="result=##Class(EMRservice.BOPrivAssist).RecordCmpSpanHoursNew("""_admid_""","""_docid_""","""_eprnum_""","""_0_""")"}
	//无纸化医生病历是否提交
	elseif argNominalFunc="MRstatus"{s execCode="result=##class(EMRservice.BOPrivAssist).IsMRCommit("""_admid_""")"}
	//用户是否为病历的提交者 Add by zengweishan 2013-9-24
	elseif argNominalFunc="IsFirstCommitUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsFirstCommitUser("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	//用户是否为病历最后一次提交者 Add by zengweishan 2013-9-24
	elseif argNominalFunc="IsLastCommitUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsLastCommitUser("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	//用户是否为病历最后一次提交者的上级医师 Add by zengweishan 2013-9-27
	elseif argNominalFunc="IsLastCommitUpUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsLastCommitUpUser("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	//用户是否为病历最后一次主治医师审核者 Add by zengweishan 2013-9-27
	elseif argNominalFunc="IsLastAttendingCheckUser" {s execCode="result=##class(EMRservice.BOPrivAssist).IsLastAttendingCheckUser("""_admid_""","""_docid_""","""_eprnum_""","""_userid_""")"}
	elseif argNominalFunc="userid" {q userid} ;
	elseif argNominalFunc="docid" {q docid} ;
	elseif argNominalFunc="admid" {q admid} ;
	elseif argNominalFunc="instanceid" {q instanceid} ;patient id
	elseif argNominalFunc="userloc" {q userloc} ;
	elseif argNominalFunc="categoryid" {q categoryid} ;
	elseif argNominalFunc="templateid" {q templateid} ;print template docid
	elseif argNominalFunc="ssgroupid" {q ssgroupid} //gaojb 20090729 ;
	elseif argNominalFunc="isnewframework" {q isnewframework} //gaojb 20090906
	
	;s ^gjbtest("execCode",argNominalFunc)=execCode
	s @execCode
	q @"result"
}

Method ParseEnvInfo(argEnvInfo As %String, ByRef argEnvInfoName As %List, ByRef argEnvInfoData As %List) As %Status
{
	for i=1:1:$l(argEnvInfo,"!") {
		;b "s"
		s aInfo=$p($g(argEnvInfo),"!",i)
		s argEnvInfoName=argEnvInfoName_$lb($p($g(aInfo),"^",1))
		s argEnvInfoData=argEnvInfoData_$lb($p($g(aInfo),"^",2))
	}
	q 1
}

/// w ##class(EMRmeta.PrivRule).test()
ClassMethod test() As %String
{
	s info = ^gjbtest("argEnviromentInfo")
	s a=##class(EMRmeta.PrivRule).%OpenId(5)
	//s r=a.ParsePrivRule("userid^83!admid^66!instanceid^148||1")
	//s r=a.ParsePrivRule("userid^83!admid^65!patientid^431!userloc^988!templateid^12!ssgroupid^207!categoryid^!docid^3!isnewframework^1")
	s r=a.ParsePrivRule(info)
	q r
}
*/
Storage Default
{
<Data name="PrivRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Valid</Value>
</Value>
<Value name="5">
<Value>PrivRuleTypeDR</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PrivRuleD</DataLocation>
<DefaultData>PrivRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.PrivRuleD</IdLocation>
<IndexLocation>^DHCEMRM.PrivRuleI</IndexLocation>
<StreamLocation>^DHCEMRM.PrivRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
