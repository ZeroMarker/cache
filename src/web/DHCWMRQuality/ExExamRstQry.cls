Import SQLUser

Class web.DHCWMRQuality.ExExamRstQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod getExamRst(RstId, RstDtlSub, RstDtlPSub)
{
	n (RstId,RstDtlSub,RstDtlPSub)
	s ret=""
	
	s tmpRst=$g(^DHCWMRERST(RstId))
	s tmpRstDtl=$g(^DHCWMRERST(RstId,"D",RstDtlSub))
	s tmpRstDtlP=$g(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub))
	q:(tmpRst="")||(tmpRstDtl="")||(tmpRstDtlP="") ret
	
	s RRstDtlPId=RstId_"||"_RstDtlSub_"||"_RstDtlPSub
	s RLocId=$p(tmpRstDtlP,"^",3)                    //责任科室
	s RLocDesc=$p($g(^CTLOC(+RLocId)),"^",2)
	s:RLocDesc["-" RLocDesc=$p(RLocDesc,"-",2)
	s REmployeeId=$p(tmpRstDtlP,"^",1)               //责任人
	s REmployeeDesc=$p($g(^SSU("SSUSR",+REmployeeId)),"^",2)
	s RRSbilityId=$p(tmpRstDtlP,"^",2)               //责任人类型
	s RRSbilityDesc=$p($g(^DHCWMRDIC(+RRSbilityId)),"^",3)
	
	s REntryId=$p(tmpRstDtl,"^",1)                   //评估项目
	s REntryDicId=$p($g(^DHCWMRER(+$p(REntryId,"||",1),"S",+$p(REntryId,"||",2),"E",+$p(REntryId,"||",3))),"^",1)
	s REntryDesc=$p($g(^DHCWMREDIC(+REntryDicId)),"^",2)  //评估项目描述
	
	s RSectionDicId=$p($g(^DHCWMRER(+$p(REntryId,"||",1),"S",+$p(REntryId,"||",2))),"^",1)  //评估大类
	s RSectionDesc=$p($g(^DHCWMRSDIC(+RSectionDicId)),"^",2)  //评估大类描述
	
	s RRuleDicId=$p($g(^DHCWMRER(+REntryId)),"^",1)  //评估标准
	s RRuleDesc=$p($g(^DHCWMRRDIC(+RRuleDicId)),"^",2)  //评估标准描述
	
	s REntryScore=$p($g(^DHCWMRER(+$p(REntryId,"||",1),"S",+$p(REntryId,"||",2),"E",+$p(REntryId,"||",3))),"^",2)    //评估项扣分
	s RiNumber=$p(tmpRstDtl,"^",2)                   //触发次数
	s RTriggerDate=$p(tmpRstDtl,"^",5)               //触发日期
	s:RTriggerDate'="" RTriggerDate=$zd(+RTriggerDate,3)
	s RErrTypeId=$p(tmpRstDtl,"^",6)                 //问题类型
	s RErrTypeDesc=$p($g(^DHCWMRDIC(+RErrTypeId)),"^",3)
	s RResumeText=$p(tmpRstDtl,"^",8)                //备注
	
	s RSignUserId=$p(tmpRst,"^",10)                  //评估人
	s RSignUserDesc=$p($g(^SSU("SSUSR",+RSignUserId)),"^",2)
	s RExamDate=$p(tmpRst,"^",11)                    //评估日期
	s:RExamDate'="" RExamDate=$zd(+RExamDate,3)
	s RExamTime=$p(tmpRst,"^",12)                    //评估时间
	s:RExamTime'="" RExamTime=$zt(+RExamTime,1)
	s RPaadm=$p(tmpRst,"^",15)                        //Paadm
	
	s Data=$lb(RRstDtlPId,RLocId,RLocDesc,REmployeeId,REmployeeDesc,RRSbilityId,RRSbilityDesc,REntryId,REntryDicId,REntryDesc,RiNumber,RTriggerDate,RErrTypeId,RErrTypeDesc,RResumeText,RSignUserId,RSignUserDesc,RExamDate,RExamTime,RPaadm,REntryScore,RSectionDicId,RSectionDesc,RRuleDicId,RRuleDesc)
	;1RstDtlPId,2RLocId,3RLocDesc,4REmployeeId,5REmployeeDesc,6RRSbilityId,7RRSbilityDesc,8REntryId,9REntryDicId,10REntryDesc,11RiNumber,12RTriggerDate,13RErrTypeId,14RErrTypeDesc,15RResumeText,16RSignUserId,17RSignUserDesc,18RExamDate,19RExamTime,20RPaadm,21REntryScore,22RSectionDicId,23RSectionDesc,24RRuleDicId,25RRuleDesc
	;1RstDtlPId,2责任科室ID,3责任科室,4责任人ID,5责任人,6责任人类型ID,7责任人类型,8评估项目ID,9质控项目字典,10评估项目,11触发次数,12触发日期,13问题类型ID,14问题类型,15Dtl备注,16评估人ID,17评估人,18评估日期,19评估时间,20RPaadm,21REntryScore,22质控大类字典ID,23评估大类,24质控字典ID,25评估标准
	;w $list(Data),!
	s ret=Data
	q ret
}

/// 查询出院病人就诊列表
/// 就诊科室,就诊医生,就诊号排序
/// Loc--就诊科室,Doc--就诊医生，Date--出院日期
ClassMethod qryDischPaadmList(Node, JIndex, DateFrom, DateTo, Loc, Ward, Doc)
{
	n (Node,JIndex,DateFrom,DateTo,Loc,Ward,Doc)
	s ret=0,Count=0
	
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateFrom=+DateFrom
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s DateTo=+DateTo
	q:(DateFrom=0)||(DateTo=0)||(DateTo<DateFrom) ret
	;^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	f Date=DateFrom:1:DateTo d
	.q:'$d(^PAADMi("DischDate",Date))
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",Date,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..s AdmStatus=$p(tmpPaadm,"^",20)
	..q:AdmStatus'="D"   //查询出院病人就诊列表
	..s AdmLoc=$p(tmpPaadm,"^",4)
	..s AdmWard=$p(tmpPaadm,"^",70)
	..s AdmDoc=$p(tmpPaadm,"^",9)
	..q:(Loc'="")&&(AdmLoc'=Loc)
	..q:(Ward'="")&&(AdmWard'=Ward)
	..q:(Doc'="")&&(AdmDoc'=Doc)
	..s ^CacheTemp(Node,JIndex,+AdmLoc,+AdmWard,+AdmDoc,+Paadm)=""
	..s Count=Count+1
	
	s ret=Count
	q ret
}

/// 查询在院病人就诊列表
/// 就诊科室,就诊医生,就诊号排序
/// Loc--就诊科室,Doc--就诊医生,Date--就诊日期
ClassMethod qryInHospPaadmList(Node, JIndex, DateFrom, DateTo, Loc, Ward, Doc)
{
	n (Node,JIndex,DateFrom,DateTo,Loc,Ward,Doc)
	s ret=0,Count=0
	
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateFrom=+DateFrom
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s DateTo=+DateTo
	s:DateFrom=0 DateFrom=""
	s:DateTo=0 DateTo=""
	
	;^PAADMi("TypeLocDocDateTime",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDocCodeDR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	q:'$d(^PAADMi("TypeLocDocDateTime","I")) ret
	s AdmLoc=""
	f  s AdmLoc=$o(^PAADMi("TypeLocDocDateTime","I",AdmLoc)) q:AdmLoc=""  d
	.q:(Loc'="")&&(AdmLoc'=Loc)
	.s AdmDoc=""
	.f  s AdmDoc=$o(^PAADMi("TypeLocDocDateTime","I",AdmLoc,AdmDoc)) q:AdmDoc=""  d
	..q:(Doc'="")&&(AdmDoc'=Doc)
	..s AdmDate=""
	..f  s AdmDate=$o(^PAADMi("TypeLocDocDateTime","I",AdmLoc,AdmDoc,AdmDate)) q:AdmDate=""  d
	...q:(DateFrom'="")&&(AdmDate<DateFrom)
	...q:(DateTo'="")&&(AdmDate>DateTo)
	...s AdmTime=""
	...f  s AdmTime=$o(^PAADMi("TypeLocDocDateTime","I",AdmLoc,AdmDoc,AdmDate,AdmTime)) q:AdmTime=""  d
	....s Paadm=""
	....f  s Paadm=$o(^PAADMi("TypeLocDocDateTime","I",AdmLoc,AdmDoc,AdmDate,AdmTime,Paadm)) q:Paadm=""  d
	.....s tmpPaadm=$g(^PAADM(+Paadm))
	.....q:tmpPaadm=""
	.....s AdmStatus=$p(tmpPaadm,"^",20)
	.....q:AdmStatus'="A"   //查询在院病人就诊列表
	.....s AdmLoc=$p(tmpPaadm,"^",4)
	.....s AdmWard=$p(tmpPaadm,"^",70)
	.....s AdmDoc=$p(tmpPaadm,"^",9)
	.....q:(Ward'="")&&(AdmWard'=Ward)
	.....s ^CacheTemp(Node,JIndex,+AdmLoc,+AdmWard,+AdmDoc,+Paadm)=""
	.....s Count=Count+1
	
	s ret=Count
	q ret
}

/// 3--科室检查病历评估明细
/// 责任科室,责任医生排序
ClassMethod qryExRstPaadmDtl(Node, JIndex, DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
{
	n (Node, JIndex, DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
	s ret=0,Count=0
	
	s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateFrom=+DateFrom
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s DateTo=+DateTo
	q:(DateFrom=0)||(DateTo=0)||(DateTo<DateFrom) ret
	q:ExamRule="" ret
	s ExamRuleStr=ExamRule
	
	k ^CacheTemp(Node,JIndex)
	f i=1:1:$l(ExamRuleStr,"|") d
	.s ExamRule=$p(ExamRuleStr,"|",i)
	.;^DHCWMRERST(0,"RuleDate",{ExamRuleDr},{ExamDate},{Rowid})
	.q:'$d(^DHCWMRERST(0,"RuleDate",+ExamRule))
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRERST(0,"RuleDate",+ExamRule,Date))
	..s RstId=0
	..f  s RstId=$o(^DHCWMRERST(0,"RuleDate",+ExamRule,Date,RstId)) q:RstId=""  d
	...s tmpRst=$g(^DHCWMRERST(RstId))
	...q:tmpRst=""
	...s RstActive=$p(tmpRst,"^",13)
	...s RstExamType=$p(tmpRst,"^",16)
	...q:(IsActive'="")&&(RstActive'=IsActive)
	...q:(ExamType'="")&&(RstExamType'=ExamType)
	...s Paadm=$p(tmpRst,"^",15)
	...;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{ChildSub})
	...s RstDtlSub=0
	...f  s RstDtlSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub)) q:RstDtlSub=""  d
	....s tmpRstDtl=$g(^DHCWMRERST(RstId,"D",RstDtlSub))
	....q:tmpRstDtl=""
	....s RstDtlActive=$p(tmpRstDtl,"^",7)
	....q:(IsActive'="")&&(RstDtlActive'=IsActive)
	....;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{DHC_WMR_ExamRDtl.ChildSub},"P",{ChildSub})
	....s RstDtlPSub=0
	....f  s RstDtlPSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub)) q:RstDtlPSub=""  d
	.....s tmpRstDtlP=$g(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub))
	.....q:tmpRstDtlP=""
	.....s RstDtlPActive=$p(tmpRstDtlP,"^",4)
	.....q:(IsActive'="")&&(RstDtlPActive'=IsActive)
	.....s RstLoc=$p(tmpRstDtlP,"^",3)
	.....q:(Loc'="")&&(RstLoc'=Loc)
	.....s RstDoc=$p(tmpRstDtlP,"^",1)
	.....q:(Doc'="")&&(RstDoc'=Doc)
	.....
	.....s RstDtlPId=RstId_"||"_RstDtlSub_"||"_RstDtlPSub
	.....s ^CacheTemp(Node,JIndex,RstLoc,RstDoc,Paadm,RstDtlPId)=""
	.....s Count=Count+1
	
	s ret=Count
	q ret
}

/// 6--科室病历检查评估项目汇总
/// 责任科室,责任医生,评估项目排序
ClassMethod qryExRstEntryDtl(Node, JIndex, DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
{
	n (Node, JIndex, DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
	s ret=0,Count=0
	
	s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateFrom=+DateFrom
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s DateTo=+DateTo
	q:(DateFrom=0)||(DateTo=0)||(DateTo<DateFrom) ret
	q:ExamRule="" ret
	s ExamRuleStr=ExamRule
	
	k ^CacheTemp(Node,JIndex)
	f i=1:1:$l(ExamRuleStr,"|") d
	.s ExamRule=$p(ExamRuleStr,"|",i)
	.;^DHCWMRERST(0,"RuleDate",{ExamRuleDr},{ExamDate},{Rowid})
	.q:'$d(^DHCWMRERST(0,"RuleDate",+ExamRule))
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRERST(0,"RuleDate",+ExamRule,Date))
	..s RstId=0
	..f  s RstId=$o(^DHCWMRERST(0,"RuleDate",+ExamRule,Date,RstId)) q:RstId=""  d
	...s tmpRst=$g(^DHCWMRERST(RstId))
	...q:tmpRst=""
	...s RstActive=$p(tmpRst,"^",13)
	...s RstExamType=$p(tmpRst,"^",16)
	...q:(IsActive'="")&&(RstActive'=IsActive)
	...q:(ExamType'="")&&(RstExamType'=ExamType)
	...s Paadm=$p(tmpRst,"^",15)
	...;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{ChildSub})
	...s RstDtlSub=0
	...f  s RstDtlSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub)) q:RstDtlSub=""  d
	....s tmpRstDtl=$g(^DHCWMRERST(RstId,"D",RstDtlSub))
	....q:tmpRstDtl=""
	....s RstDtlActive=$p(tmpRstDtl,"^",7)
	....q:(IsActive'="")&&(RstDtlActive'=IsActive)
	....;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{DHC_WMR_ExamRDtl.ChildSub},"P",{ChildSub})
	....s RstDtlPSub=0
	....f  s RstDtlPSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub)) q:RstDtlPSub=""  d
	.....s tmpRstDtlP=$g(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub))
	.....q:tmpRstDtlP=""
	.....s RstDtlPActive=$p(tmpRstDtlP,"^",4)
	.....q:(IsActive'="")&&(RstDtlPActive'=IsActive)
	.....s RstLoc=$p(tmpRstDtlP,"^",3)
	.....q:(Loc'="")&&(RstLoc'=Loc)
	.....s RstDoc=$p(tmpRstDtlP,"^",1)
	.....q:(Doc'="")&&(RstDoc'=Doc)
	.....
	.....s ExamEntryId=$p(tmpRstDtl,"^",1)
	.....s iNumber=+$p(tmpRstDtl,"^",2)
	.....s RstDtlPId=RstId_"||"_RstDtlSub_"||"_RstDtlPSub
	.....s ^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId)=+$g(^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId))+iNumber
	.....s ^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId,RstDtlPId)=""
	.....s Count=Count+1
	
	s ret=Count
	q ret
}

ClassMethod QryExamRstByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExamRstByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExamRstByPaadmExecute(ByRef qHandle As %Binary, ExamRule As %String, Paadm As %String, IsActive As %String, ExamType As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
	s ExamRuleStr=ExamRule
	f i=1:1:$l(ExamRuleStr,"|") d
	.s ExamRule=$p(ExamRuleStr,"|",i)
	.q:'$d(^DHCWMRERST(0,"RuleAdm",+ExamRule,+Paadm))
	.;^DHCWMRERST(0,"RuleAdm",{ExamRuleDr},{PaadmDr},{Rowid})
	.s RstId=0
	.f  s RstId=$o(^DHCWMRERST(0,"RuleAdm",+ExamRule,+Paadm,RstId)) q:RstId=""  d
	..s tmpRst=$g(^DHCWMRERST(RstId))
	..q:tmpRst=""
	..s RstActive=$p(tmpRst,"^",13)
	..s RstExamType=$p(tmpRst,"^",16)
	..q:(IsActive'="")&&(RstActive'=IsActive)
	..q:(ExamType'="")&&(RstExamType'=ExamType)
	..;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{ChildSub})
	..s RstDtlSub=0
	..f  s RstDtlSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub)) q:RstDtlSub=""  d
	...s tmpRstDtl=$g(^DHCWMRERST(RstId,"D",RstDtlSub))
	...q:tmpRstDtl=""
	...s RstDtlActive=$p(tmpRstDtl,"^",7)
	...q:(IsActive'="")&&(RstDtlActive'=IsActive)
	...;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{DHC_WMR_ExamRDtl.ChildSub},"P",{ChildSub})
	...s RstDtlPSub=0
	...f  s RstDtlPSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub)) q:RstDtlPSub=""  d
	....s tmpRstDtlP=$g(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub))
	....q:tmpRstDtlP=""
	....s RstDtlPActive=$p(tmpRstDtlP,"^",4)
	....q:(IsActive'="")&&(RstDtlPActive'=IsActive)
	....;1RstDtlPId,2责任科室ID,3责任科室,4责任人ID,5责任人,6责任人类型ID,7责任人类型,8评估项目ID,9质控项目字典,10评估项目,11触发次数,12触发日期,13问题类型ID,14问题类型,15Dtl备注,16评估人ID,17评估人,18评估日期,19评估时间,23评估大类
	....s Data=..getExamRst(RstId,RstDtlSub,RstDtlPSub)
	....q:Data=""
	....s Data=$list(Data,1,19)_$list(Data,23,23)
	....s ^CacheTemp(repid,ind)=Data
	....s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryExamRstByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExamRstByPaadmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ****************************************************************
/// 功能说明   : 查询就诊对应电子病历评估结果
/// 入参       : 
/// ExamRule   : 评估标准
/// Paadm      : 就诊号
/// IsActive   : 是否有效  Y/N/""
/// ExamType   : 质控类型  M:运行,F:终末,"":全部
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamRstQry","QryExamRstByPaadm",ExamRule,Paadm,IsActive,ExamType)
/// ****************************************************************
Query QryExamRstByPaadm(ExamRule As %String, Paadm As %String, IsActive As %String, ExamType As %String) As %Query(ROWSPEC = "RRstDtlPId:%String,RLocId:%String,RLocDesc:%String,REmployeeId:%String,REmployeeDesc:%String:%String,RRSbilityId:%String,RRSbilityDesc:%String,REntryId:%String,REntryDicId:%String,REntryDesc:%String,RiNumber:%String,RTriggerDate:%String,RErrTypeId:%String,RErrTypeDesc:%String,RResumeText:%String,RSignUserId:%String,RSignUserDesc:%String,RExamDate:%String,RExamTime:%String,RSectionDesc:%String")
{
}

ClassMethod QryExRstPaadmDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExRstPaadmDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExRstPaadmDtlExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, ExamRule As %String, IsActive As %String, ExamType As %String, Loc As %String, Doc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:IsActive="1" IsActive="Y"
	s:IsActive="2" IsActive="N"
	s:IsActive="3" IsActive=""
	s:ExamType="1" ExamType="M"
	s:ExamType="2" ExamType="F"
	s:ExamType="3" ExamType=""
	
	s Node="qryExamRstDtl3",JIndex=$j
	k ^CacheTemp(Node,JIndex)
	s flg=..qryExRstPaadmDtl(Node,JIndex,DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
	q:flg<1 $$$OK
	
	;^CacheTemp(Node,JIndex,RstLoc,RstDoc,Paadm,RstDtlPId)
	s RstLoc=""
	f  s RstLoc=$o(^CacheTemp(Node,JIndex,RstLoc)) q:RstLoc=""  d
	.s RstDoc=""
	.f  s RstDoc=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc)) q:RstDoc=""  d
	..s Paadm=""
	..f  s Paadm=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc,Paadm)) q:Paadm=""  d
	...s RstDtlPId=""
	...f  s RstDtlPId=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc,Paadm,RstDtlPId)) q:RstDtlPId=""  d
	....s RstData=..getExamRst($p(RstDtlPId,"||",1),$p(RstDtlPId,"||",2),$p(RstDtlPId,"||",3))
	....q:RstData=""
	....s tmpPaadm=$g(^PAADM(Paadm))
	....s IPNo=$p(tmpPaadm,"^",81)
	....s Papmi=$p(tmpPaadm,"^",1)
	....s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	....s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	....//3RLocDesc,5REmployeeDesc
	....//3责任科室|5责任人|登记号|病人姓名|就诊号
	....s Data1=$lb($list(RstData,3),$list(RstData,5),RegNo,PatName,IPNo)
	....//1评估号,7责任人类型,10评估项目,11触发次数,12触发日期,14问题类型,15Dtl备注,17评估人,18评估日期,19评估时间,23评估大类,25评估标准
	....s Data2=$lb($list(RstData,1),$list(RstData,7),$list(RstData,10),$list(RstData,11),$list(RstData,12),$list(RstData,14),$list(RstData,15),$list(RstData,17),$list(RstData,18),$list(RstData,19),$list(RstData,23),$list(RstData,25))
	....s Data=Data1_Data2
	....s ^CacheTemp(repid,ind)=Data
	....s ind=ind+1
	
	k ^CacheTemp(Node,JIndex)
	Quit $$$OK
}

ClassMethod QryExRstPaadmDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExRstPaadmDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ****************************************************************
/// 功能说明   : 科室检查病历评估明细
///            : 责任科室,责任医生排序
/// 入参       : 
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// ExamRule   : 评估标准
/// IsActive   : 是否有效  Y/N/""
/// ExamType   : 质控类型  M:运行,F:终末,"":全部
/// Loc        : 科室
/// Doc        : 医生
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamRstQry","QryExamRstDtl3",DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
/// ****************************************************************
Query QryExRstPaadmDtl(DateFrom As %String, DateTo As %String, ExamRule As %String, IsActive As %String, ExamType As %String, Loc As %String, Doc As %String) As %Query(ROWSPEC = "RLocDesc:%String:责任科室,REmployeeDesc:%String:责任人,RegNo:%String:登记号,PatName:%String:姓名,IPNo:%String:就诊号,RRstDtlPId:%String:评估号,RRSbilityDesc:%String:责任人类型,REntryDesc:%String:评估项目,RiNumber:%String:触发次数,RTriggerDate:%String:触发日期,RErrTypeDesc:%String:问题类型,RResumeText:%String:备注,RSignUserDesc:%String:评估人,RExamDate:%String:评估时间,RExamTime:%String:评估时间,RSectionDesc:%String:评估大类,RRuleDesc:%String:评估标准")
{
}

ClassMethod QryExRstEntryDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExRstEntryDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExRstEntryDtlExecute(ByRef qHandle As %Binary, DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:IsActive="1" IsActive="Y"
	s:IsActive="2" IsActive="N"
	s:IsActive="3" IsActive=""
	s:ExamType="1" ExamType="M"
	s:ExamType="2" ExamType="F"
	s:ExamType="3" ExamType=""
	
	s Node="QryExRstEntryDtl",JIndex=$j
	k ^CacheTemp(Node,JIndex)
	s flg=..qryExRstEntryDtl(Node,JIndex,DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
	q:flg<1 $$$OK
	
	;^CacheTemp(Node,JIndex,RstLoc,RstDoc,Paadm,RstDtlPId)
	s RstLoc=""
	f  s RstLoc=$o(^CacheTemp(Node,JIndex,RstLoc)) q:RstLoc=""  d
	.s RstDoc=""
	.f  s RstDoc=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc)) q:RstDoc=""  d
	..s ExamEntryId=""
	..f  s ExamEntryId=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId)) q:ExamEntryId=""  d
	...s RstDtlPId=""
	...f  s RstDtlPId=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId,RstDtlPId)) q:RstDtlPId=""  d
	....s RstData=..getExamRst($p(RstDtlPId,"||",1),$p(RstDtlPId,"||",2),$p(RstDtlPId,"||",3))
	....q:RstData=""
	....s Paadm=$list(RstData,20)
	....s tmpPaadm=$g(^PAADM(Paadm))
	....s IPNo=$p(tmpPaadm,"^",81)
	....s Papmi=$p(tmpPaadm,"^",1)
	....s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	....s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	....//3责任科室|5责任人|10评估项目|登记号|病人姓名|就诊号
	....s Data1=$lb($list(RstData,3),$list(RstData,5),$list(RstData,10),RegNo,PatName,IPNo)
	....//1评估号,7责任人类型,12评估项目分值,11触发次数,12触发日期,14问题类型,15Dtl备注,17评估人,18评估日期,19评估时间,23评估大类,25评估标准
	....s Data2=$lb($list(RstData,1),$list(RstData,7),$list(RstData,21),$list(RstData,11),$list(RstData,12),$list(RstData,14),$list(RstData,15),$list(RstData,17),$list(RstData,18),$list(RstData,19),$list(RstData,23),$list(RstData,25))
	....s Data=Data1_Data2
	....s ^CacheTemp(repid,ind)=Data
	....s ind=ind+1
	
	k ^CacheTemp(Node,JIndex)
	Quit $$$OK
}

ClassMethod QryExRstEntryDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExRstEntryDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ****************************************************************
/// 功能说明   : 科室检查病历评估项目汇总
///            : 责任科室,责任医生,评估项目排序
/// 入参       : 
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// ExamRule   : 评估标准
/// IsActive   : 是否有效  Y/N/""
/// ExamType   : 质控类型  M:运行,F:终末,"":全部
/// Loc        : 科室
/// Doc        : 医生
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamRstQry","QryExRstEntryDtl",DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
/// ****************************************************************
Query QryExRstEntryDtl(DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc) As %Query(ROWSPEC = "RLocDesc:%String:责任科室,REmployeeDesc:%String:责任人,REntryDesc:%String:评估项目,RegNo:%String:登记号,PatName:%String:姓名,IPNo:%String:就诊号,RRstDtlPId:%String:评估号,RRSbilityDesc:%String:责任人类型,REntryScore:%String:评估项目分值,RiNumber:%String:触发次数,RTriggerDate:%String:触发日期,RErrTypeDesc:%String:问题类型,RResumeText:%String:备注,RSignUserDesc:%String:评估人,RExamDate:%String:评估时间,RExamTime:%String:评估时间,RSectionDesc:%String:评估大类,RRuleDesc:%String:评估标准")
{
}

ClassMethod QryExRstScoreCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExRstScoreCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExRstScoreCountExecute(ByRef qHandle As %Binary, DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:IsActive="1" IsActive="Y"
	s:IsActive="2" IsActive="N"
	s:IsActive="3" IsActive=""
	s:ExamType="1" ExamType="M"
	s:ExamType="2" ExamType="F"
	s:ExamType="3" ExamType=""
	
	s Node="QryExRstScoreCount",JIndex=$j
	k ^CacheTemp(Node,JIndex)
	s flg=..qryExRstEntryDtl(Node,JIndex,DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
	q:flg<1 $$$OK
	
	;^CacheTemp(Node,JIndex,RstLoc,RstDoc,Paadm,RstDtlPId)
	s RstLoc=""
	f  s RstLoc=$o(^CacheTemp(Node,JIndex,RstLoc)) q:RstLoc=""  d
	.s RstDoc=""
	.f  s RstDoc=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc)) q:RstDoc=""  d
	..s ExamEntryId="",RstScore=0,FScore=0,MScore=0
	..f  s ExamEntryId=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId)) q:ExamEntryId=""  d
	...s EntryScore=$p($g(^DHCWMRER(+$p(ExamEntryId,"||",1),"S",+$p(ExamEntryId,"||",2),"E",+$p(ExamEntryId,"||",3))),"^",2)    //评估项扣分
	...s iNumber=$g(^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId))
	...s RstScore=RstScore+((+EntryScore)*(+iNumber))
	...s RstDtlPId=""
	...f  s RstDtlPId=$o(^CacheTemp(Node,JIndex,RstLoc,RstDoc,ExamEntryId,RstDtlPId)) q:RstDtlPId=""  d
	....s iNumber=+$p($g(^DHCWMRERST(+RstDtlPId,"D",$p(RstDtlPId,"||",2))),"^",2)
	....s ExamType=$p($g(^DHCWMRERST(+RstDtlPId)),"^",16)
	....s:ExamType="F" FScore=FScore+((+EntryScore)*(+iNumber))
	....s:ExamType="M" MScore=MScore+((+EntryScore)*(+iNumber))
	..//3责任科室|5责任人|病历质量分值|自动评估分数|主动评估分数
	..s LocDesc=$p($g(^CTLOC(RstLoc)),"^",2)
	..s DocDesc=$p($g(^SSU("SSUSR",RstDoc)),"^",2)
	..s Data=$lb(LocDesc,DocDesc,0-RstScore,0-FScore,0-MScore)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	k ^CacheTemp(Node,JIndex)
	Quit $$$OK
}

ClassMethod QryExRstScoreCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExRstScoreCountExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ****************************************************************
/// 功能说明   : 科室病历质量成绩单(检查日期)
///            : 责任科室,责任医生
/// 入参       : 
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// ExamRule   : 评估标准
/// IsActive   : 是否有效  Y/N/""
/// ExamType   : 质控类型  M:运行,F:终末,"":全部
/// Loc        : 科室
/// Doc        : 医生
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamRstQry","QryExamRstDtl6",DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc)
/// ****************************************************************
Query QryExRstScoreCount(DateFrom, DateTo, ExamRule, IsActive, ExamType, Loc, Doc) As %Query(ROWSPEC = "RLocDesc:%String:责任科室,REmployeeDesc:%String:责任人,RRstScore:%String:病历质量分值,RFScore:%String:主动评估分值,RMScore:%String:自动评估分值")
{
}

ClassMethod QryMRExamRstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRExamRstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRExamRstExecute(ByRef qHandle As %Binary, ExamRule As %String, Loc As %String, Ward As %String, Doc As %String, DateFrom As %String, DateTo As %String, IsDisch As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//s ^ZF(10)=$lb(ExamRule, Loc, Ward, Doc, DateFrom, DateTo, IsDisch)
	q:(ExamRule="")||(IsDisch="") $$$OK
	s ExamRuleStr=ExamRule
	s IsDisch=$s(IsDisch["Y":"Y",1:"N")
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateFrom=+DateFrom
	s:DateFrom=0 DateFrom=""
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s DateTo=+DateTo
	s:DateTo=0 DateTo=""
	q:(IsDisch="Y")&&((DateFrom="")||(DateTo="")) $$$OK
	
	s Node="qryMRExamRst",JIndex=$j
	k ^CacheTemp(Node,JIndex)
	s:IsDisch="Y" flg=..qryDischPaadmList(Node, JIndex, DateFrom, DateTo, Loc, Ward, Doc)
	s:IsDisch="N" flg=..qryInHospPaadmList(Node, JIndex, DateFrom, DateTo, Loc, Ward, Doc)
	q:flg<1 $$$OK
	
	k ^CacheTemp("QryMRExamRst",JIndex)
	s AdmLoc=""
	f  s AdmLoc=$o(^CacheTemp(Node,JIndex,AdmLoc)) q:AdmLoc=""  d
	.s AdmWard=""
	.f  s AdmWard=$o(^CacheTemp(Node,JIndex,AdmLoc,AdmWard)) q:AdmWard=""  d
	..s AdmDoc=""
	..f  s AdmDoc=$o(^CacheTemp(Node,JIndex,AdmLoc,AdmWard,AdmDoc)) q:AdmDoc=""  d
	...s Paadm=""
	...f  s Paadm=$o(^CacheTemp(Node,JIndex,AdmLoc,AdmWard,AdmDoc,Paadm)) q:Paadm=""  d
	....f i=1:1:$l(ExamRuleStr,"|") d
	.....s ExamRule=$p(ExamRuleStr,"|",i)
	.....q:'$d(^DHCWMRERST(0,"RuleAdm",+ExamRule,+Paadm))
	.....;^DHCWMRERST(0,"RuleAdm",{ExamRuleDr},{PaadmDr},{Rowid})
	.....s RstId=0
	.....f  s RstId=$o(^DHCWMRERST(0,"RuleAdm",+ExamRule,+Paadm,RstId)) q:RstId=""  d
	......s tmpRst=$g(^DHCWMRERST(RstId))
	......q:tmpRst=""
	......s RstActive=$p(tmpRst,"^",13)
	......s RstExamType=$p(tmpRst,"^",16)
	......q:RstActive'="Y"
	......;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{ChildSub})
	......s RstDtlSub=0
	......f  s RstDtlSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub)) q:RstDtlSub=""  d
	.......s tmpRstDtl=$g(^DHCWMRERST(RstId,"D",RstDtlSub))
	.......q:tmpRstDtl=""
	.......s RstDtlActive=$p(tmpRstDtl,"^",7)
	.......q:RstDtlActive'="Y"
	.......;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{DHC_WMR_ExamRDtl.ChildSub},"P",{ChildSub})
	.......s RstDtlPSub=0,Flg=0
	.......f  s RstDtlPSub=$o(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub)) q:(RstDtlPSub="")||(Flg=1)  d
	........s tmpRstDtlP=$g(^DHCWMRERST(RstId,"D",RstDtlSub,"P",RstDtlPSub))
	........q:tmpRstDtlP=""
	........s RstDtlPActive=$p(tmpRstDtlP,"^",4)
	........q:RstDtlPActive'="Y"
	........s Flg=1
	.......q:Flg=0
	......s ExamEntryId=$p(tmpRstDtl,"^",1)
	......s EntryScore=+$p($g(^DHCWMRER(+$p(ExamEntryId,"||",1),"S",+$p(ExamEntryId,"||",2),"E",+$p(ExamEntryId,"||",3))),"^",2)    //评估项扣分
	......s iNumber=+$p(tmpRstDtl,"^",2)
	......s RstScore=EntryScore*iNumber
	......s ^CacheTemp("QryMRExamRst",JIndex,Paadm,RstExamType)=$g(^CacheTemp("QryMRExamRst",$j,Paadm,RstExamType))+RstScore
	k ^CacheTemp(Node,JIndex)
	
	s Paadm=0
	f  s Paadm=$o(^CacheTemp("QryMRExamRst",JIndex,Paadm)) q:Paadm=""  d
	.s tmpADM=$g(^PAADM(+Paadm))
	.q:tmpADM=""
	.s Papmi=$p(tmpADM,"^",1)
	.s LocId=$p(tmpADM,"^",4)
	.s LocDesc=$s(LocId'="":$p($g(^CTLOC(+LocId)),"^",2),1:"")
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s WardId=$p(tmpADM,"^",70)
	.s WardDesc=$s(WardId'="":$p($g(^PAWARD(+WardId)),"^",2),1:"")
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s DocId=$p(tmpADM,"^",9)
	.s DocDesc=$p($g(^CTPCP(+DocId,1)),"^",2)
	.s AdmDate=$zd($p(tmpADM,"^",6),3)
	.s AdmTime=$zt($p(tmpADM,"^",7),2)
    .s DischDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+Paadm)
    .s DischDate=$p(DischDateTime," ",1),DischTime=$p(DischDateTime," ",2)
	.s IsDeath=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
    .s IsDeath=$s(IsDeath="Y":"已故",1:"")
	.s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
    .s PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
    .s IPNo=$p(tmpADM,"^",81)
    .s FScore=0-(+$g(^CacheTemp("QryMRExamRst",JIndex,Paadm,"F")))
    .s MScore=0-(+$g(^CacheTemp("QryMRExamRst",JIndex,Paadm,"M")))
    .s RstScore=FScore+MScore
    .s Data=$lb(ExamRuleStr,Paadm,Papmi,LocDesc,WardDesc,DocDesc,AdmDate,AdmTime,DischDate,DischTime,IsDeath,IPNo,RegNo,PatName,FScore,MScore,RstScore)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryMRExamRstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRExamRstExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ****************************************************************
/// 功能说明   : 在院/出院病人质控结果查询
/// 入参       : 
/// ExamRule   : 评估标准
/// Loc        : 就诊科室
/// Ward       : 就诊病区
/// Doc        : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// IsDisch    : 是否出院
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamRstQry","QryMRExamRst",ExamRule,Loc,Ward,Doc,DateFrom,DateTo,IsDisch)
/// ****************************************************************
Query QryMRExamRst(ExamRule As %String, Loc As %String, Ward As %String, Doc As %String, DateFrom As %String, DateTo As %String, IsDisch As %String) As %Query(ROWSPEC = "ExamRule:%String,Paadm:%String,Papmi:%String,LocDesc:%String,WardDesc:%String,DocDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,IsDeath:%String,IPNo:%String,RegNo:%String,PatName:%String,FScore:%String,MScore:%String,RstScore:%String")
{
}

}
