/// 名称: DHCMed.CCService.MonitorSrv
/// 描述: 住院病人就诊监控
/// 编写者：zf
/// 编写日期: 2010-04-30
Class DHCMed.CCService.MonitorSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-04-30
/// Description:  监控入口程序
/// Input：       argMonitor 数据格式 "&AppCode=InPatient&AAA=1"
ClassMethod MonitorPortal(argAppCode As %String, argMonitor As %String) As %String
{
	New (argAppCode,argMonitor)
	Set ret=""
	Quit:argAppCode="" ret
	Set $zt="MonitorPortalErr"
	
	Set JIndex=$j
	//格式化入参
	Kill ^TMP(JIndex,argAppCode,"ARG")
	For aIndex=1:1:$l(argMonitor,$c(1)) {
		Set aMonitorSub=$p(argMonitor,$c(1),aIndex)
		Set aName=$p(aMonitorSub,"=",1)
		Set aValue=$p(aMonitorSub,"=",2)
		If (aName="")||(aValue="") Continue
		Set ^TMP(JIndex,argAppCode,"ARG",aName)=aValue
	}
	
	//实施主题监控(格式化输出结果)
	Kill ^TMP(argZIndex,argJIndex,argAppCode,"RST")
	Set objSubject=##class(DHCMed.CC.SubjectDic).GetObjByCode(argAppCode)
	Quit:objSubject="" ret
	Set aClassName=$p(objSubject.SDMethodName,":",1)
	Set aMethodName=$p(objSubject.SDMethodName,":",2)
	Set aInPut=objSubject.SDInPut
	Set aInPutVals=""
	For aIndex=1:1:$l(aInPut,",") {
		Set aInPutName=$p(aIndex,",",aIndex)
		If aInPutName="" Continue
		Set aInPutVal=$g(^TMP(argZIndex,argJIndex,"ARG",aInPutName))
		Set:aInPutVal="" aInPutVal=""""""
		Set aInPutVals=aInPutVals_","_aInPutVal
	}
	Set:aInPutVals'="" aInPutVals=$e(aInPutVals,2,$l(aInPutVals))
	Set aMonitorExp="Set flg=##Class("_aClassName_")."_aMethodName_"("_aInPutVals_",argAppCode,argZIndex,argJIndex)"
	Xecute aMonitorExp
	Kill ^TMP(argZIndex,argJIndex,argAppCode,"ARG")
	Quit:flg<0 -1
	
	Set ret=1
	Quit ret
	
MonitorPortalErr
	Kill ^TMP(argZIndex,argJIndex,argAppCode)
	Set ret=-100
	Quit ret
}

ClassMethod ParseExpToPaadm(argPaadm As %String, argConds As %String, argAppCode As %String, argZIndex As %String, argJIndex As %String, argItemType As %String) As %Integer
{
	New (argPaadm,argConds,argAppCode,argZIndex,argJIndex,argItemType)
	Set ret=0
	Set $zt="ParseExpToPaadmErr"
	
	//根据表达式筛选就诊记录
	If (argConds'="")
	{
		For Index=1:1:$l(argConds,$c(2))
		{
			Set AppSubID=$p(argConds,$c(2),Index)
			Set objAppSub=##class(DHCMed.CC.SubjectAppSub).GetObjById(AppSubID)
			Quit:objAppSub=""
			Quit:objAppSub.SASItemType'=argItemType
			Set ItemDr=objAppSub.SASItemDr
			//表达式解析
		}
	} Else {
		Set AppRowid=$o(^DHCMed.CC.SubjectAppI("SACodeIndex"," "_AppCode,0))
		Quit:AppRowid=""
		Set ChildSub=$o(^DHCMed.CC.SubjectAppD(AppRowid,"ChildAppSub",0))
		While (ChildSub'="")
		{
			Set AppSubID=AppRowid_"||"_ChildSub
			Set objAppSub=##class(DHCMed.CC.SubjectAppSub).GetObjById(AppSubID)
			Quit:objAppSub=""
			Quit:objAppSub.SASItemType'=argItemType
			Set ItemDr=objAppSub.SASItemDr
			//表达式解析
		}
	}
	
	Set ^TMP(argZIndex,argJIndex,argAppCode,"RST",Paadm)=""
	Set ret=1
	Quit ret
	
ParseExpToPaadmErr
	Set ret=-100
	Quit ret
}

}
