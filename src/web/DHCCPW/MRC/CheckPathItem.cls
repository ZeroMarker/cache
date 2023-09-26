Class web.DHCCPW.MRC.CheckPathItem Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/*
/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  对一个病人所在的临床路径进行监控
/// Input：       EpisodeID ：Paadm
/// w ##class(web.DHCCPW.MRC.CheckPathItem).CheckCPWRule(9776)	
ClassMethod CheckCPWRule(EpisodeId As %String)
{
	s CurIndex=$i(^TEMPCURRENTITEM)
	S CheckIndex=$i(TEMPCHECKITEM)
	set admInfo=##class(web.DHCCPW.MR.PAADMSrv).GetAdmInfoByID(EpisodeId,"^")
	set MrADM=$p(admInfo,"^",13)
	set CurrentCPW=##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByadm(MrADM,"^")
	s CPWRowid=$p(CurrentCPW,"^",3)             //当的有效的入径记录里对应的临床路径id
	s currentStep=##class(web.DHCCPW.MR.ClinicalPathWays).GetCurrentStepInfo(EpisodeId,"^")  //当前所处的步骤
	s currentStepId=$p(currentStep,"^",3)	
	s stepList=##class(web.DHCCPW.MRC.ClinPathWaysSrv).BuildSteps(CPWRowid)
	s length=$ll(stepList)
	s i=0
	s stepSame=0
	for i=1:1:length q:stepSame=1  d
	.s stepRowid=$li($li(stepList,i),1)
	.i stepRowid=currentStepId d
	..s stepSame=1
	.s pathRowid=$p(stepRowid,"||",1)
	.s EpChild=$p(stepRowid,"||",2)
	.s StepChild=$p(stepRowid,"||",3)
	.s itemChild=0
	.f  s itemChild=$o(^DHCMRC("CPW",pathRowid,"EP",EpChild,"STEP",StepChild,"ITEM",itemChild)) q:itemChild=""  d
	..s itemRowid=stepRowid_"||"_itemChild
	..s ^TEMPCURRENTITEM(CurIndex,EpisodeId,itemRowid)=""
	
	s RuleChild=0
	f  s RuleChild=$o(^DHCMRC("CPW",CPWRowid,"RULE",RuleChild)) q:RuleChild=""  d
	.s RuleRowid=CPWRowid_"||"_RuleChild
	.s RuleObj=##class(User.DHCMRCClinPathWaysRule).%OpenId(RuleRowid)
	.q:'$IsObject(RuleObj)
	.s RuleActive=RuleObj.CPWRActiveFlag
	.q:RuleActive="N"         					//如果激活标志为"N"时不触发
	.s RuleStr=RuleObj.CPWRExpression
	.s RuleItemId=..GetItemIdByType(RuleStr)   //按监控规则类型取ItemId
	.i $d(^TEMPCURRENTITEM(CurIndex,EpisodeId,RuleItemId))  d
	..s checkVal=..CheckItemByRule(EpisodeId,RuleRowid,admInfo,CurrentCPW)
	..i checkVal=1 d
	...s ^TEMPCHECKITEM(CheckIndex,EpisodeId,RuleRowid)=1
	s RuleList=$LB()
	s ruleId=0
	s ind1=0 
	f  s ruleId=$o(^TEMPCHECKITEM(CheckIndex,EpisodeId,ruleId)) q:ruleId=""  Do
	.i ^TEMPCHECKITEM(CheckIndex,EpisodeId,ruleId)=1 d
	..s ind1=ind1+1
	..s $Li(RuleList,ind1)=ruleId
	Kill ^TEMPCURRENTITEM(CurIndex,EpisodeId)
	Kill ^TEMPCHECKITEM(CheckIndex)
	q RuleList
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  由规则id进行监控
/// Input：       EpisodeID    ：Paadm
///               RuleId       : 监控规则id号
///               admInfo      : 病人就诊信息字符串
///               CurrentCPW   : 病人当前有效的所处临床路径信息字符串
/// w ##class(web.DHCCPW.MRC.CheckPathItem).CheckItemByRule(,,,,)
ClassMethod CheckItemByRule(EpisodeId As %String, RuleId As %String, admInfo As %String, CurrentCPW As %String)
{
	new (EpisodeId,RuleId,admInfo,CurrentCPW)
	s checkVal=0
	s ind=$i
	s ruleObj=##class(User.DHCMRCClinPathWaysRule).%OpenId(RuleId)
	i $IsObject(ruleObj) d
	.s RuleStr=ruleObj.CPWRExpression
	Quit:RuleStr="" ""
	s ruleType=$p(RuleStr,$c(1),1)
	i ruleType="A" d
	.s checkVal=..ACheckRule(EpisodeId,RuleStr,admInfo,CurrentCPW)
	i ruleType="B" d
	.s checkVal=..BCheckRule(EpisodeId,RuleStr,admInfo,CurrentCPW)
	q checkVal
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  A类监控规则
/// Input：       EpisodeID    ：Paadm
///               RuleStr      : 监控规则表达式
///               admInfo      : 病人就诊信息字符串
///               CurrentCPW   : 病人当前有效的所处临床路径信息字符串
/// w ##class(web.DHCCPW.MRC.CheckPathItem).ACheckRule(,)
ClassMethod ACheckRule(EpisodeId As %String, RuleStr As %String, admInfo As %String, CurrentCPW As %String)
{
	
	new (EpisodeId,RuleStr,admInfo,CurrentCPW)
	s CPWRowid=$p(CurrentCPW,"^",1)                
	s pathItem=$p(RuleStr,$c(1),2)             //监控规则对应的项目id
	s TimeStandard=$p(RuleStr,$c(1),3)
	s TimeMin=$p(RuleStr,$c(1),4)
	s TimeMax=$p(RuleStr,$c(1),5)
	s TimeUnit=$p(RuleStr,$c(1),6)
	s checkTime=0
	i TimeStandard=1 d          //TimeStandard时间基准，1 入院时间，2 入径时间
	.;i paAdmRowid=$p(^MR(EpisoeId,"PRO",1),"^",9)
	.s date=$p(admInfo,"^",3) 
	.s time=$p(admInfo,"^",4) 
	.s date=$zdh(date,3)
	.s time=$zth(time,2)
	e  d
	.s Date=..GetCPWInDate(CurrentCPW)
	.s date=$p(Date,",",1)
	.s time=$p(Date,",",2)
	s checkTime=..CheckRuleTime(date,time,TimeMin,TimeMax,TimeUnit)
	q:checkTime=0 0
	i checkTime=1 d   //等于1时要检查临床路径执行记录和数量.
	.s checkItem=..CheckImplItem(CPWRowid,RuleStr,date_","_time)
	q checkItem
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  B类监控规则
/// Input：       EpisodeID    ：Paadm
///               RuleStr      : 监控规则表达式
///               admInfo      : 病人就诊信息字符串
///               CurrentCPW   : 病人当前有效的所处临床路径信息字符串
/// w ##class(web.DHCCPW.MRC.CheckPathItem).BCheckVal(,)
ClassMethod BCheckRule(EpisodeId As %String, RuleStr As %String, admInfo As %String, CurrentCPW As %String)
{
	new (Episode,RuleStr,admInfo,CurrentCPW)
	s CPWRowid=$p(CurrentCPW,"^",1)             //当的有效的入径记录的id号
	s pathItem=$p(RuleStr,$c(1),2)
	s TimeMin=$p(RuleStr,$c(1),4)
	s TimeMax=$p(RuleStr,$c(1),5)
	s TimeUnit=$p(RuleStr,$c(1),6)
	s StandardItem=$p(RuleStr,$c(1),3)
	s checkTime=0
	s ItemStandard=..CheckItemStandard(CPWRowid,StandardItem)
	q:ItemStandard="" 0
	s checkTime=..CheckRuleTime($p(ItemStandard,",",1),$p(ItemStandard,",",2),TimeMin,TimeMax,TimeUnit)
	q:checkTime=0 0                //不触发监控规则，返回。
	i checkTime=1 d
	.s checkItem=..CheckImplItem(CPWRowid,RuleStr,ItemStandard)
	q checkItem
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  检查基准项目是否发生
/// Input：       CPWRowid ：有效入径记录的id
///               StandardItem   : 基准项目的id
/// return        基准项目实施的时间。
/// w ##class(web.DHCCPW.MRC.CheckPathItem).ACheckRule(,)
ClassMethod CheckItemStandard(CPWRowid As %String, StandardItem As %String)
{
	new (CPWRowid,StandardItem)
	s ImplChild=0
	s Date=""
	f  s ImplChild=$o(^DHCMR("CPW",CPWRowid,"IMPL",ImplChild)) q:ImplChild=""  d
	.Set Impl=^DHCMR("CPW",CPWRowid,"IMPL",ImplChild)
	.s StepItem=$li(Impl,3) 
	.i StepItem=StandardItem d
	..s ImplDate=$li(Impl,4) 
	..s ImplTime=$li(Impl,5) 
	..s Date=ImplDate_","_ImplTime
	q Date
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  项目实施时间和基准时间进行判断
/// Input：       Date 		：基准日期
///               Time      : 基准时间
///               TimeMin   : 监控规则里的最小间隔时间
///               TimeMax   : 监控规则里的最大间隔时间
///               TimeUnit  : 监控规则里的时间单位
/// return        CheckVal  : 当前时间和基准时间之差是否超过最大时间间隔 1.否 0.是
/// w ##class(web.DHCCPW.MRC.CheckPathItem).CheckRuleTime(,,,,)
ClassMethod CheckRuleTime(Date As %String, Time As %String, TimeMin As %String, TimeMax As %String, TimeUnit As %String)
{
	new (Date,Time,TimeMin,TimeMax,TimeUnit)
	s CheckVal=0
	i TimeUnit="D" d
	.s days=$p($h,",",1)-Date
	.i days>TimeMax d
	..s CheckVal=1
	e  d
	.i TimeUnit="H" d
	..s day=$p($h,",",1)-Date
	..s times=day*86400+$p($h,",",2)-Time
	..s hours=$p(times/3600,".",1)
	..i hours>=TimeMax d
	...s CheckVal=1
	.e  d
	..s day=$p($h,",",1)-Date
	..s times=day*86400+$p($h,",",2)-Time
	..s minutes=$p(times/60,".",1)
	..i minutes>=TimeMax d
	...s CheckVal=1
	q CheckVal
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  项目实施时间和基准时间进行判断
/// Input：       ImplDate  ：项目实施时间(包括日期和时间)
///               AdmDate   : 监控规则的基准时间(包括日期和时间)
///               TimeMin   : 监控规则里的最小间隔时间
///               TimeMax   : 监控规则里的最大间隔时间
///               TimeUnit  : 监控规则里的时间单位
/// return        CheckVal  : 项目实施时间是否在基准时间的最小和最大时间间隔之间 1.否 0.是
/// w ##class(web.DHCCPW.MRC.CheckPathItem).CheckImplTime(,,,,)
ClassMethod CheckImplTime(ImplDate As %String, AdmDate As %String, TimeMin As %String, TimeMax As %String, TimeUnit As %String)
{
	new (ImplDate,AdmDate,TimeMin,TimeMax,TimeUnit)
	s CheckVal=0
	i TimeUnit="D" d
	.s days=$p(ImplDate,",",1)-$p(AdmDate,",",1)
	.i (days<TimeMin)||(days>TimeMax) d
	..s CheckVal=1
	e  d
	.i TimeUnit="H" d
	..s day=$p(ImplDate,",",1)-$p(AdmDate,",",1)
	..s times=day*86400+$p(ImplDate,",",2)-$p(AdmDate,",",2)
	..s hours=$p(times/3600,".",1)
	..i (hours<TimeMin)||(hours>TimeMax) d
	...s CheckVal=1
	.e  d
	..s day=$p(ImplDate,",",1)-$p(AdmDate,",",1)
	..s times=day*86400+$p(ImplDate,",",2)-$p(AdmDate,",",2)
	..s minutes=$p(times/60,".",1)
	..i (minutes<TimeMin)||(minutes>TimeMax) d
	...s CheckVal=1
	q CheckVal
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-03
/// Description:  得到病人的入径日期和时间
/// Input：       CurrentCPW ：有效入径记录的字符串
/// return        病人入径日期时间。
/// w ##class(web.DHCCPW.MRC.CheckPathItem).GetCPWInDate()
ClassMethod GetCPWInDate(CurrentCPW As %String)
{
	new (CurrentCPW)
	s date=$p(CurrentCPW,"^",13)
	s time=$p(CurrentCPW,"^",14)
	s date=$zdh(date,3)
	s time=$zth(time,2)
	s Date=date_","_time
	q Date
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-02
/// Description:  检查监控规则所对应项目是否在写定的时间内实施。
/// Input：       CPWRowid  ：有效入径记录的id
///               RuleStr   : 监控规则字符串
/// 			  admDate   : 判断日期
/// return        基准项目实施的时间。
/// w ##class(web.DHCCPW.MRC.CheckPathItem).CheckImplItem( , ,)
ClassMethod CheckImplItem(CPWRowid As %String, RuleStr As %String, admDate As %String)
{
	new (CPWRowid,RuleStr,admDate)
	s Qty=0
	s IsOrd=0
	s pathItem=$p(RuleStr,$c(1),2)
	s TimeMin=$p(RuleStr,$c(1),4)
	s TimeMax=$p(RuleStr,$c(1),5)
	s TimeUnit=$p(RuleStr,$c(1),6)
	s checkTimeVal=1
	s ImplChild=0
	f  s ImplChild=$o(^DHCMR("CPW",CPWRowid,"IMPL",ImplChild)) q:(ImplChild="")||(checkTimeVal=0)  d
	.Set Impl=^DHCMR("CPW",CPWRowid,"IMPL",ImplChild)
	.s StepItem=$li(Impl,3)
	.i StepItem=pathItem d
	..s ImplDate=$li(Impl,4)
	..s ImplTime=$li(Impl,5)
	..s ImplDate=ImplDate_"^"_ImplTime
	..s checkTimeVal=..CheckImplTime(ImplDate,admDate,TimeMin,TimeMax,TimeUnit)
	..;s checkTimeVal=0
	..i checkTimeVal=0 d
	...s Qty=Qty+1
	q:checkTimeVal=1 1
	s QtyMin=$p(RuleStr,$c(1),7)      //项目有没有医嘱项都要检查数量
	s QtyMax=$p(RuleStr,$c(1),8)
	i (QtyMin'=0)||(QtyMax'=0) d     //当QtyMin、QtyMax都为0时不检查数量
	.i (Qty<QtyMin)||(Qty>QtyMax) d    
	.s checkTimeVal=1
	q checkTimeVal
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-03
/// Description:  根据监控规则类型取项目Id
/// Input：       RuleStr   : 监控规则字符串               
/// return        项目Id
/// w ##class(web.DHCCPW.MRC.CheckPathItem).GetItemIdByType( )
ClassMethod GetItemIdByType(RuleStr As %String)
{
	s ItemId=""
	s type=$p(RuleStr,$c(1),1)
	i type="A" d
	.s ItemId=$p(RuleStr,$c(1),2)
	i type="B" d
	.s ItemId=$p(RuleStr,$c(1),2)
	q ItemId
}

ClassMethod GetCheckRulesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckRulesExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetCheckRulesExecute(ByRef qHandle As %Binary, EpisodeId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Rules=..CheckCPWRule(EpisodeId)
	s length=$ll(Rules)
	s index=1
	for index=1:1:length  d
	.Quit:'$ld(Rules,index)
	.s RuleId=$li(Rules,index)
	.s RuleObj=##class(User.DHCMRCClinPathWaysRule).%OpenId(RuleId)
	.s RuleDesc=RuleObj.CPWRDesc
	.d OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RuleId,RuleDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCheckRulesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckRulesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     李宇峰
/// CreatDate：   2010-06-03
/// Description:  由病人的paadm号取得触发监控的规则。
/// Input：       EpisodeId   : 病人的paadm               
/// return        项目Id
/// 调试 d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.CheckPathItem","GetCheckRules",73237)
/// 调用 ##class(%ResultSet).%New("web.DHCCPW.MRC.CheckPathItem:GetCheckRules")
///     .Execute(9776)
Query GetCheckRules(EpisodeId As %String) As %Query(ROWSPEC = "RuleId:%String,RuleDesc:%String:监控规则")
{
}
*/
Storage Default
{
<Data name="CheckPathItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MRC.CheckPathItemD</DataLocation>
<DefaultData>CheckPathItemDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MRC.CheckPathItemD</IdLocation>
<IndexLocation>^web.DHCCPW.MRC.CheckPathItemI</IndexLocation>
<StreamLocation>^web.DHCCPW.MRC.CheckPathItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
