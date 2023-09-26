/// 名称: DHCMed.CCService.InPatientQry
/// 描述: 在院患者查询常用方法
/// 编写者：liuyh
/// 编写日期: 2010-06-08
Class DHCMed.CCService.InPatientQry Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-06-08
/// Description:  查询科室
/// Table：       CTLOC
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.InPatientQry","QueryCtloc","E")
Query QueryCtloc(locType As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryCtlocExecute(ByRef qHandle As %Binary, locType As %String) As %Status
{

	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:locType=""
	s Rowid=0
	f  s Rowid=$o(^CTLOC(Rowid)) q:Rowid=""  d
	.s LocDesc=$p($g(^CTLOC(Rowid)),"^",2)
	.s LocType=$p($g(^CTLOC(Rowid)),"^",13)
	.q:LocType'=locType
	.s Data=$lb(Rowid,LocDesc)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCtlocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// 查询当前在院病人
/// LocID : 科室ID   WardID : 病区ID
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.InPatientQry","QueryCurrentInPatient","",5)
Query QueryCurrentInPatient(LocID As %String, WardID As %String, CurrentAdmType As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,AdmitDate:%String:住院日期,Room:%String:病室,Bed:%String:病床,DoctorName:%String,Department:%String:就诊科室,Ward:%String:病区,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄")
{
}

ClassMethod QueryCurrentInPatientExecute(ByRef qHandle As %Binary, LocID As %String, WardID As %String, CurrentAdmType As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   Set ind=1
   Set qHandle=$lb(0,repid,0)
   s:CurrentAdmType="" CurrentAdmType="I"
   
   i +WardID>0 d   // 病区不为空
   .q:'$d(^PAADMi("CurrWard",+WardID))
   .s Room="" f  s Room=$o(^PAADMi("CurrWard",+WardID,Room)) q:Room=""  d
   ..s paadm="" f  s paadm=$o(^PAADMi("CurrWard",+WardID,Room,paadm)) q:paadm=""  d
   ...d OutputRow
   i ((+LocID>0)&(+WardID=0)) d   //科室不为空，病区为空
   .s DeptItem=LocID
   .f i=1:1:$l(CurrentAdmType,"/")  d
   ..s cAdmType=$p(CurrentAdmType,"/",i) 
   ..s Date=""
   ..f  s Date=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date)) q:(Date="")  d
   ...s Time=""
   ...f  s Time=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date,Time)) q:(Time="")  d
   ....s paadm=""
   ....f  s paadm=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date,Time,paadm)) q:(paadm="")  d
   .....d OutputRow
   q $$$OK

OutputRow
   s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
   q:$IsObject(objAdm)=0
   s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
   q:$IsObject(objPatient)=0
   q:((+WardID>0)&(+LocID>0)&(+LocID'=objAdm.DepartmentID)) // 科室病区都不为空
   s $li(data,1)=objAdm.AdmRowID
   s $li(data,2)=objAdm.PatientID
   s $li(data,3)=objAdm.AdmitDate
   s $li(data,4)=objAdm.Room
   s $li(data,5)=objAdm.Bed
   s $li(data,6)=objAdm.DoctorName
   s $li(data,7)=objAdm.Department
   s $li(data,8)=objAdm.Ward
   s $li(data,9)=objPatient.PapmiNo
   s $li(data,10)=objPatient.PatientName
   s $li(data,11)=objPatient.Sex
   s $li(data,12)=objPatient.Age
   d objAdm.%Close()
   d objPatient.%Close()
   s ^CacheTemp(repid,ind)=data
   s ind=ind+1
}

ClassMethod QueryCurrentInPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCurrentInPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCurrentInPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCurrentInPatientExecute ]
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

/// 查询所有病区
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.InPatientQry","QueryAllWard")
Query QueryAllWard() As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryAllWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllWardExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	   			
	s wardID=0 f  s wardID=$o(^PAWARD(wardID)) q:wardID=""  d
	.s objWard=##class(DHCMed.Base.PacWard).GetObjById(wardID)
	.q:'$IsObject(objWard)
	.;s:objWard.Descs["-" objWard.Descs=$p(objWard.Descs,"-",2)
    .s $li(data,1)=objWard.Rowid
    .s $li(data,2)=objWard.Descs
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d objWard.%Close()
    .k objWard
	Quit $$$OK
}

ClassMethod QueryAllWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllWardExecute ]
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
