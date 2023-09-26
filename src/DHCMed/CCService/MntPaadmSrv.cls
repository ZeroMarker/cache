/// 名称: DHCMed.CCService.MntPaadmSrv
/// 描述: 以就诊记录作为监控对象
/// 编写者：zhufei
/// 编写日期: 2010-05-10
Class DHCMed.CCService.MntPaadmSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-28
/// Description:  就诊相关监控（监控记录与就诊相关联）
/// Input：       格式 "&AppCode=InPatient&AAA=1"
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.MntPaadmSrv","QryAdmByRegDate",aAdmType,aFromDate,aToDate,aLocID,aWardID,aConds,aAppCode)
Query QryAdmByRegDate(aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aWardID As %String, aConds As %String, aAppCode As %String) As %Query(ROWSPEC = "EpisodeID:%String,Result:%String")
{
}

ClassMethod QryAdmByRegDateExecute(ByRef qHandle As %Binary, aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aWardID As %String, aConds As %String, aAppCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set $ZT="QryAdmByRegDateErr"
	Quit:(aAppCode="")||(aFromDate="")||(aToDate="") $$$OK
	Set JIndex=$j
	
	//^PAADMi("TypeDate",{PAADM_Type},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	s:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	s:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	s aFromDate=+aFromDate
	s:aToDate["/" aToDate=$zdh(aToDate,4)
	s:aToDate["-" aToDate=$zdh(aToDate,3)
	s aToDate=+aToDate
	s AdmType=""
	f  s AdmType=$o(^PAADMi("TypeDate",AdmType)) q:AdmType=""  d
	.q:(aAdmType'="")&&(AdmType'=aAdmType)
	.s AdmDate=aFromDate-1
	.f  s AdmDate=$o(^PAADMi("TypeDate",AdmType,AdmDate)) q:(AdmDate="")||(AdmDate>aToDate)  d
	..s AdmTime=""
	..f  s AdmTime=$o(^PAADMi("TypeDate",AdmType,AdmDate,AdmTime)) q:AdmTime=""  d
	...s Paadm=0
	...f  s Paadm=$o(^PAADMi("TypeDate",AdmType,AdmDate,AdmTime,Paadm)) q:Paadm=""  d
	....s objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	....q:objPaadm=""
	....q:(aLocID'="")&&(objPaadm.Department'=aLocID)
	....q:(aWardID'="")&&(objPaadm.Ward'=aWardID)
	....//*************************************************
	....//执行条件检查,并输出结果
	....k ^TMP(JIndex,aAppCode,"Result")
	....//执行筛查类型监控项目
	....//s flg=##Class(DHCMed.CCService.MonitorSrv).ParseExpToPaadm(Paadm,aConds,aAppCode,JIndex,ZIndex,"F")
	....//q:flg<0
	....//执行普通类型监控项目
	....//s flg=##Class(DHCMed.CCService.MonitorSrv).ParseExpToPaadm(Paadm,aConds,aAppCode,JIndex,ZIndex,"N")
	....//q:flg<0
	....s Result="",Ind=0
	....f  s Ind=$o(^TMP(JIndex,aAppCode,"Result",Ind)) q:Ind=""  d
	.....s Result=Result_"; "_$g(^TMP(JIndex,aAppCode,"Result",Ind))
	....k ^TMP(JIndex,aAppCode,"Result")
	....//*************************************************
	....s Data=$lb(Paadm,Result)
	....s ^CacheTemp(repid,ind)=Data
	....s ind=ind+1
	
	Quit $$$OK
	
QryAdmByRegDateErr
	k ^TMP(JIndex,aAppCode,"Result")
	Quit $$$OK
}

ClassMethod QryAdmByRegDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmByRegDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmByRegDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmByRegDateExecute ]
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

}
