Import SQLUser

Class web.DHCVISWarnQuery Extends %RegisteredObject
{

/// 楼层
Query FindFloorInfo(Name As %String) As %Query(ROWSPEC = "RowId:%String,FloorCode:%String,FloorName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindFloorInfo","")
ClassMethod FindFloorInfoExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s FloorId=""
	f  s FloorId=$O(^DHCVISFloor(FloorId)) q:FloorId=""  d
	.s FloorCode=$p(^DHCVISFloor(FloorId),"^",1)
	.s FloorName=$p(^DHCVISFloor(FloorId),"^",2)
	.q:(FloorName'[Name)&(Name'="")
	.s RowId=FloorId
 	.d OutFloorRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutFloorRow
	s Data=$lb(RowId,FloorCode,FloorName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindFloorInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFloorInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindFloorInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFloorInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 楼号
Query FindBuildingInfo(Name As %String) As %Query(ROWSPEC = "RowId:%String,BuildCode:%String,BuildName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindBuildingInfo","")
ClassMethod FindBuildingInfoExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s BuildId=""
	f  s BuildId=$O(^DHCVISBuild(BuildId)) q:BuildId=""  d
	.s BuildCode=$p(^DHCVISBuild(BuildId),"^",1)
	.s BuildName=$p(^DHCVISBuild(BuildId),"^",2)
	.q:(BuildName'[Name)&(Name'="")
	.s RowId=BuildId
 	.d OutBuildRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutBuildRow
	s Data=$lb(RowId,BuildCode,BuildName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBuildingInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBuildingInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBuildingInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBuildingInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 诊区
Query FindClinicalInfo(Name As %String) As %Query(ROWSPEC = "RowId:%String,ClinicalCode:%String,ClinicalName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindClinicalInfo","")
ClassMethod FindClinicalInfoExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s ClinicalId=""
	f  s ClinicalId=$O(^DHCVISClinical(ClinicalId)) q:ClinicalId=""  d
	.s ClinicalCode=$p(^DHCVISClinical(ClinicalId),"^",1)
	.s ClinicalName=$p(^DHCVISClinical(ClinicalId),"^",2)
	.q:(ClinicalName'[Name)&(Name'="")
	.s RowId=ClinicalId
 	.d OutClinicalRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutClinicalRow
	s Data=$lb(RowId,ClinicalCode,ClinicalName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindClinicalInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClinicalInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindClinicalInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClinicalInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 房间
Query FindRoomInfo(Name As %String) As %Query(ROWSPEC = "RowId:%String,RoomCode:%String,RoomName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindRoomInfo","")
ClassMethod FindRoomInfoExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s RoomId=""
	f  s RoomId=$O(^DHCVISRoom(RoomId)) q:RoomId=""  d
	.s RoomCode=$p(^DHCVISRoom(RoomId),"^",1)
	.s RoomName=$p(^DHCVISRoom(RoomId),"^",2)
	.q:(RoomName'[Name)&(Name'="")
	.s RowId=RoomId
 	.d OutRoomRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutRoomRow
	s Data=$lb(RowId,RoomCode,RoomName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindRoomInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoomInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRoomInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoomInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 科室
Query FindLocInfo(Name As %String = "", HosId As %String = "") As %Query(ROWSPEC = "RowId:%String,LocCode:%String,LocName:%String,LocHosId:%String,LocHosName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindLocInfo","")
ClassMethod FindLocInfoExecute(ByRef qHandle As %Binary, Name As %String = "", HosId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i Name'="" s Name=$$ALPHAUP^SSUTIL4(Name)
 	s LocId=""
 	f  s LocId=$O(^CTLOC(LocId)) q:LocId=""  d
 	.s LocCode=$p(^CTLOC(LocId),"^",1)
	.s HospitalId=$p($g(^CTLOC(LocId)),"^",22)
 	.q:(HospitalId'=HosId)&&(HosId'="")
 	.s LocName=$p($g(^CTLOC(LocId)),"^",2)
	.s LocName=$$ALPHAUP^SSUTIL4(LocName)
	.s CTContactName=$p($g(^CTLOC(LocId)),"^",43)
	.s DateActiveFrom=$p($g(^CTLOC(LocId)),"^",24)
	.s DateActiveTo=$p($g(^CTLOC(LocId)),"^",25)
	.q:((+$h<DateActiveFrom)&(DateActiveFrom'=""))
	.q:((+$h>DateActiveTo)&(DateActiveTo'=""))
	.s CTContactName=$$ALPHAUP^SSUTIL4(CTContactName)
	.s CTContactName=CTContactName_LocName
	.q:LocName=""
	.s LocHosId=$p($g(^CTLOC(LocId)),"^",22)
	.s LocHosName=""
	.i LocHosId'="" s LocHosName=$p(^CT("HOSP",LocHosId),"^",2)
	.q:((Name'="")&&(LocName'[Name))||(Name'="")&&(CTContactName'[Name)
	.s RowId=LocId
 	.d OutLocRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutLocRow
	s Data=$lb(RowId,LocCode,LocName,LocHosId,LocHosName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 院区
Query FindHosInfo(Name As %String) As %Query(ROWSPEC = "RowId:%String,HosCode:%String,HosName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindHosInfo","")
ClassMethod FindHosInfoExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s HosId=""
 	f  s HosId=$O(^CT("HOSP",HosId)) q:HosId=""  d
 	.q:HosId="0"
 	.s HosCode=$p(^CT("HOSP",HosId),"^",1)
 	.s HosName=$p(^CT("HOSP",HosId),"^",2)
 	.s dateFrom=$p(^CT("HOSP",HosId),"^",9)
 	.q:(dateFrom'="")&&(dateFrom>(+$h))
 	.s dateTo=$p(^CT("HOSP",HosId),"^",10)
 	.q:(dateTo'="")&&(dateTo<(+$h))
	.q:(HosName'[Name)&(Name'="")
	.s RowId=HosId
 	.d OutHosRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutHosRow
	s Data=$lb(RowId,HosCode,HosName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindHosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHosInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindHosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHosInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 预警信息维护数据
Query FindWarningInfo(ComputerName As %String = "", HospitalId As %String = "", CtlocId As %String = "", BuildId As %String = "", FloorId As %String = "", ClinicalId As %String = "", RoomId As %String = "") As %Query(ROWSPEC = "RowId:%String,WarnComputerName:%String,WarnHospitalId:%String,WarnHospitalName:%String,WarnBuildId:%String,WarnBuildName:%String,WarnFloorId:%String,WarnFloorName:%String,WarnClinicalId:%String,WarnClinicalName:%String,WarnRoomId:%String,WarnRoomName:%String,WarnLocId:%String,WarnLocDesc:%String,WarnSendAddress:%String,WarnSendToComputerName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindWarningInfo")
ClassMethod FindWarningInfoExecute(ByRef qHandle As %Binary, ComputerName As %String = "", HospitalId As %String = "", CtlocId As %String = "", BuildId As %String = "", FloorId As %String = "", ClinicalId As %String = "", RoomId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	i ComputerName'="" s ComputerName=$tr($$upper^SSUTIL4(ComputerName)," ")
 	s LocId=""
 	f  s LocId=$O(^DHCVISWarni(0,"WarnLocId",LocId)) q:LocId=""  d
 	.s WarnId=""
	.f  s WarnId=$O(^DHCVISWarni(0,"WarnLocId",LocId,WarnId)) q:WarnId=""  d
	..s WarnComputerName=$p(^DHCVISWarn(WarnId),"^",1)
	..q:(WarnComputerName'[ComputerName)&(ComputerName'="")
	..s WarnHospitalId=$p(^DHCVISWarn(WarnId),"^",2)
	..q:(WarnHospitalId'=HospitalId)&(HospitalId'="")
	..s WarnLocId=$p(^DHCVISWarn(WarnId),"^",7)
	..q:(WarnLocId'=CtlocId)&(CtlocId'="")
	..s WarnLocDesc=$p($g(^CTLOC(WarnLocId)),"^",2)
	..i WarnLocDesc="" s WarnLocId=""
	..s WarnHospitalName=$p($g(^CT("HOSP",WarnHospitalId)),"^",2)
	..s WarnBuildId=$p(^DHCVISWarn(WarnId),"^",3)
	..q:(WarnBuildId'=BuildId)&(BuildId'="")
	..s WarnBuildName=$p($g(^DHCVISBuild(WarnBuildId)),"^",2)
	..i WarnBuildName="" s WarnBuildId=""
	..s WarnFloorId=$p(^DHCVISWarn(WarnId),"^",4)
	..q:(WarnFloorId'=FloorId)&(FloorId'="")
	..s WarnFloorName=$p($g(^DHCVISFloor(WarnFloorId)),"^",2)
	..i WarnFloorName="" s WarnFloorId=""
	..s WarnClinicalId=$p(^DHCVISWarn(WarnId),"^",5)
	..q:(WarnClinicalId'=ClinicalId)&(ClinicalId'="")
	..s WarnClinicalName=$p($g(^DHCVISClinical(WarnClinicalId)),"^",2)
	..i WarnClinicalName="" s WarnClinicalId=""
	..s WarnRoomId=$p(^DHCVISWarn(WarnId),"^",6)
	..q:(WarnRoomId'=RoomId)&(RoomId'="")
	..s WarnRoomName=$p($g(^DHCVISRoom(WarnRoomId)),"^",2)
	..i WarnRoomName="" s WarnRoomId=""
	..s WarnSendAddress=$p(^DHCVISWarn(WarnId),"^",8)
	..s WarnSendToComputerName=$p(^DHCVISWarn(WarnId),"^",9)
	..s RowId=WarnId
 	..d OutWarningRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutWarningRow
	s Data=$lb(RowId,WarnComputerName,WarnHospitalId,WarnHospitalName,WarnBuildId,WarnBuildName,WarnFloorId,WarnFloorName,WarnClinicalId,WarnClinicalName,WarnRoomId,WarnRoomName,WarnLocId,WarnLocDesc,WarnSendAddress,WarnSendToComputerName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindWarningInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWarningInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWarningInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWarningInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 报警查询界面
Query FindWarnInfoByLoc(startDate As %String = "", endDate As %String = "", Loc As %String = "") As %Query(ROWSPEC = "RowId:%String,hospitalName:%String,locId:%String,locName:%String,roomName:%String,wranTime:%String,bulidName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISWarnQuery","FindWarnInfoByLoc","26/02/2020","26/02/2020","")
ClassMethod FindWarnInfoByLocExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", Loc As %String = "") As %Status
{
	s ^YJ("FindWarnInfoByLoc")=$lb(startDate,endDate,Loc)
	s repid=$i(^CacheTemp)
 	s ind=1
	i $l($p(startDate,"/",3))="4" d
    .s startDate=$zdh(startDate,4)
    .s endDate=$zdh(endDate,4)
    i $l($p(startDate,"-",1))="4" d
    .s startDate=$zdh(startDate,3)
    .s endDate=$zdh(endDate,3)
	s dateformat=$lg(^websys.ConfigurationD(1),10)
 	i startDate>endDate s startDate=endDate
 	f dateDate=startDate:1:endDate d
 	.s WarnId=""
 	.f  s WarnId=$O(^DHCVISVoicei(0,"WarnId",dateDate,"N",WarnId)) q:WarnId=""  d
 	..s VoiceId=""
 	..f  s VoiceId=$O(^DHCVISVoicei(0,"WarnId",dateDate,"N",WarnId,VoiceId)) q:VoiceId=""  d
	...s VoiceStr=$g(^DHCVISVoice(VoiceId))
	...s WarnId=$p(VoiceStr,"^",6)
	...s VoiceContent=$p(VoiceStr,"^",1)
	...q:VoiceContent'["!"
	...s wranDate=$p(VoiceStr,"^",3)
	...i dateformat="YMD" s wranDate=$zd(wranDate,3)
	...e  s wranDate=$zd(wranDate,4)
	...s wranTime=$p(VoiceStr,"^",4)
	...s wranTime=$zt(wranTime,1)
	...s wranTime=wranDate_" "_wranTime
	...//s locId=$p(^DHCVISWarn(WarnId),"^",7)
	...s locId=$p(VoiceContent,"!",2)
	...q:(Loc'="")&&(locId'=Loc)
	...s locName=$p($g(^CTLOC(locId)),"^",2)
	...s hospitalName=$p(VoiceContent,"!",1)
	...s locName=$p(VoiceContent,"!",3)
	...s bulidName=$p(VoiceContent,"!",5)
	...s roomName=$p(VoiceContent,"!",4)
	...//s HospitalId=$p(^DHCVISWarn(WarnId),"^",2)
	...//s hospitalName=$p($g(^CT("HOSP",HospitalId)),"^",2)
	...//s BuildId=$p(^DHCVISWarn(WarnId),"^",3)
	...//s bulidName=$p($g(^DHCVISBuild(BuildId)),"^",2)
	...//s RoomId=$p(^DHCVISWarn(WarnId),"^",6)
	...//s roomName=$p($g(^DHCVISRoom(RoomId)),"^",2)
	...s RowId=VoiceId
 	...d OutWarnInfoByLocRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutWarnInfoByLocRow
	s Data=$lb(RowId,hospitalName,locId,locName,roomName,wranTime,bulidName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindWarnInfoByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWarnInfoByLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWarnInfoByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWarnInfoByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCVISWarnQuery).CompareDate("2020-02-24","2020-02-24")
ClassMethod CompareDate(startDate As %String = "", endDate As %String = "")
{
    q:(startDate="")||(endDate="") "查询日期不能为空"
    s flag="Y"
    i $l($p(startDate,"/",3))="4" d
    .s startDate=$zdh(startDate,4)
    .s endDate=$zdh(endDate,4)
    i $l($p(startDate,"-",1))="4" d
    .s startDate=$zdh(startDate,3)
    .s endDate=$zdh(endDate,3)
    i startDate>endDate s flag="开始日期不能大于结束日期"
    q flag
}

/// w ##class(web.DHCVISWarnQuery).GetHosFlag("43","3")
ClassMethod GetHosFlag(locId As %String = "", hosId As %String = "")
{
	q:(locId="")||(hosId="") "N"
	s hosFlag="N"
	s locHosId=$p($g(^CTLOC(locId)),"^",22)
	q:locHosId="" hosFlag
	q:locHosId=hosId "Y"
	q hosFlag
}

}
