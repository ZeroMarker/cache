/// 根据出院日期查询某段时间的病案已经回收了的死亡病历
/// 创建者：李阳
/// 创建日期：2011-02-21
Class web.DHCWMRDeathQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 判断一个病人是否死亡
/// 返回值：1--死亡 2--活着
ClassMethod IsPatientDead(PatientID, PaadmDR As %String = "")
{
	n (PatientID,PaadmDR)
	s ret=0
	s admType="" f  s admType=$o(^PAPERdr(PatientID,"ADM",admType)) q:admType=""  d
	.s paadm="" f  s paadm=$o(^PAPERdr(PatientID,"ADM",admType,paadm),-1) q:paadm=""  d
	..q:(PaadmDR'="")&(paadm'=PaadmDR)
	..s mradmid=$p($g(^PAADM(paadm)),"^",61)
    ..q:mradmid=""                                   
    ..s diccharDescID=$p(^MR(+mradmid,"PRO",1),"^",10)      
    ..s discharDesc=$p($g(^PAC("DISCON",+diccharDescID)),"^",2)
    ..q:discharDesc'["死"                             ;死亡		.
    ..s ret=1
    s ^CacheTemp("IsDead")=diccharDescID
    q ret
}

/// 查询死亡病历
Query QueryDeathCase(AdmType As %String, MrType As %String, FromDate As %String, ToDate As %String, CollectWorkID As %String) As %Query(ROWSPEC = "PatientID:%String,MainID:%String,VolID:%String,MrType:%String:病案类型,MrNo:%String:病案号,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:住院日期,DisDate:%String:出院日期,Loc:%String:科室,CurrStatus:%String:当前状态,CollectDate:%String:回收日期,CollectTime:%String:回收时间")
{
}

ClassMethod QueryDeathCaseExecute(ByRef qHandle As %Binary, AdmType As %String, MrType As %String, FromDate As %String, ToDate As %String, CollectWorkID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)	
	
	q:((AdmType="")!(MrType="")!(FromDate="")!(ToDate="")!(CollectWorkID="")) $$$OK
	
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate'="" FromDate=+FromDate
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate'="" ToDate=+ToDate
	
	f tmpDate=FromDate:1:ToDate  d
	.s paadm="" f  s paadm=$o(^PAADMi("DisDateT",AdmType,tmpDate,paadm)) q:paadm=""  d
    ..s patientID=$p($g(^PAADM(paadm)),"^",1)
    ..;w patientID,!
	..q:..IsPatientDead(patientID)=0
	..s VolID="" f  s VolID=$o(^DHCWMRVOL(0,"VolAdm",paadm,VolID)) q:VolID=""  d
	...s StatusChildSub=$o(^DHCWMRVOL(VolID,"S",0,"Status",CollectWorkID,""))
	...q:StatusChildSub=""
	...s ^CacheTemp(repid,ind)=$$BuildQueryDeathCaseExecute(VolID,StatusChildSub)
	...s ind=ind+1
	Quit $$$OK
	
BuildQueryDeathCaseExecute(VolID,StatusChildSub)
	n (VolID,StatusChildSub)
	s data=$lb("")
	s VolData=$g(^DHCWMRVOL(+VolID))
	s MainID=$p(VolData,"^",1)
	s MainData=$g(^DHCWMRMAIN(+MainID))
	s MrTypeData=$g(^DHCWMRDIC(+$p(MainData,"^",1)))
	s PatientData=##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainID)
	s AdmData=##class(web.DHCWMRBaseInfoCtl).GetAdmListInfo(VolID)
	s CurrWorkItemData=$g(^DHCWMRWITM(+$p(VolData,"^",6)))
	s CollectStatusData=$g(^DHCWMRVOL(VolID,"S",StatusChildSub))
	s $li(data,1)=$p(MainData,"^",3) //PatientID:%String
	s $li(data,2)=MainID //MainID:%String
	s $li(data,3)=VolID //VolID:%String
	s $li(data,4)=$p(MrTypeData,"^",3) //病案类型
	s $li(data,5)=$p(MainData,"^",2) //MrNo:%String:病案号
	s $li(data,6)=$p(PatientData,"^",27) //RegNo:%String:登记号
	s $li(data,7)=$p(PatientData,"^",2) //PatientName:%String:患者姓名
	s $li(data,8)=$p(PatientData,"^",4) //Sex:%String:性别
	s $li(data,9)=$p(PatientData,"^",6) //Age:%String:年龄
	s $li(data,10)=$p(AdmData,"^",3) //AdmitDate:%String:住院日期
	s $li(data,11)=$p(AdmData,"^",7) //DisDate:%String:出院日期
	s $li(data,12)=$p(AdmData,"^",9) //Loc:%String:科室
	s $li(data,13)=$p(CurrWorkItemData,"^",2) //CurrStatus:%String:当前状态
	s $li(data,14)=$zd(+$p(CollectStatusData,"^",3),3) //CollectDate:%String:回收日期
	s $li(data,15)=$zt(+$p(CollectStatusData,"^",4),1) //CollectTime:%String:回收时间	
	q data
}

ClassMethod QueryDeathCaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDeathCaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDeathCaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDeathCaseExecute ]
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

ClassMethod Test()
{
	d ##class(%Library.ResultSet).RunQuery("web.DHCWMRDeathQuery","QueryDeathCase",7,"2011-1-1","2011-2-25",2)
	q "OK"
}

}
