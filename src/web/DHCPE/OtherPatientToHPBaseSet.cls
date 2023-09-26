/// 住院体检其它数据设置，总检会诊费人员设置、会诊费医嘱、会诊费接受科室、默认会诊费、住院医生（不允许提交）
Class web.DHCPE.OtherPatientToHPBaseSet Extends (%RegisteredObject, %XML.Adaptor)
{

// 设置职称和会诊医嘱的对应

ClassMethod SetCarPrvTpConOrder(CarPrvTpID, LocID, OrderID)
{
	i OrderID="" d
	.k ^DHCPEOtherPatientToHPBase("CarPrvTpConOrder",LocID,CarPrvTpID)
	e  d
	.s ^DHCPEOtherPatientToHPBase("CarPrvTpConOrder",LocID,CarPrvTpID)=OrderID
	q 0
}

// 设置默认会诊医嘱，对应职称没设置会诊费时使用，没设置就不插入会诊费

ClassMethod SetConOrderDefault(LocID, OrderID)
{
	s ^DHCPEOtherPatientToHPBase("ConOrderDefault",LocID)=OrderID
	q 0
}

// 设置总检会诊费（初检提交时插入），没设置就不插入会诊费

ClassMethod SetGenConUser(LocID, UserID)
{
	i UserID="" d
	.k ^DHCPEOtherPatientToHPBase("GenConUser",LocID)
	e  d
	.s ^DHCPEOtherPatientToHPBase("GenConUser",LocID)=UserID
	q 0
}

// 设置提交站点时对应会诊费的接受科室,如果没设置提交时不插入会诊费

ClassMethod SetStationConRecLoc(LocID, StationID, RecLocID)
{
	s DocID=$P(RecLocID,"^",2)
	s RecLocID=$P(RecLocID,"^",1)
	i RecLocID="" d
	.k ^DHCPEOtherPatientToHPBase("ConRecLoc",LocID,StationID)
	e  d
	.s ^DHCPEOtherPatientToHPBase("ConRecLoc",LocID,StationID)=RecLocID_"^"_DocID
	q 0
}

// 设置某些人员为住院医生、如果为住院医生、不允许体检录入提交

ClassMethod SetInDoc(LocID, UserID, DeleteFlag As %String = "N")
{
	i DeleteFlag="Y" d
	.k ^DHCPEOtherPatientToHPBase("InDoc",LocID,UserID)
	e  d
	.s ^DHCPEOtherPatientToHPBase("InDoc",LocID,UserID)=""
	q 0
}

Query FindInDoc() As %Query(ROWSPEC = "UserID:%String,UserCode:%String,UserName:%String")
{
}

ClassMethod FindInDocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s curLoc=%session.Get("LOGON.CTLOCID")
 	s ind=1
 	s UserID=""
 	f  s UserID=$O(^DHCPEOtherPatientToHPBase("InDoc",curLoc,UserID)) q:UserID=""  d
 	.s UserCode=$P($g(^SSU("SSUSR",UserID)),"^",1)
 	.s UserName=$P($g(^SSU("SSUSR",UserID)),"^",2)
 	.d FindBuild	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(UserID,UserCode,UserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInDocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query LookUpWithType(val As %String, date As %Library.String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,hidden,Code:%String,IntType:%String")
{
SELECT CTCPT_Desc, CTCPT_RowID As RowID, CTCPT_Code, CTCPT_InternalType
FROM SQLUser.CT_CarPrvTp
WHERE ((CTCPT_Desc %STARTSWITH :val) OR (CTCPT_Code =:val))
 AND ((:date IS NULL) OR ((CTCPT_DateFrom IS NULL OR CTCPT_DateFrom <= :date) AND (CTCPT_DateTo IS NULL OR CTCPT_DateTo >= :date)))
AND (CTCPT_InternalType="DOCTOR")
ORDER BY CTCPT_Desc
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.OtherPatientToHPBaseSet","FindCarPrvTp")
Query FindCarPrvTp() As websys.Query(ROWSPEC = "CarPrvTpID:%String,Desc:%String,InternalType:%String,ARCIMDesc:%String,DefaultARCIMDesc:%String")
{
}

ClassMethod FindCarPrvTpExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s curLoc=%session.Get("LOGON.CTLOCID")
    
    s id=0
	f  s id=$O(^CT("CPT",id)) q:id=""  d
	.s Desc=$p($g(^CT("CPT",id)),"^",2)
    .s InternalType=$p($g(^CT("CPT",id)),"^",4)
    .s Active=$p($g(^CT("CPT",id)),"^",3)
    .q:InternalType'="DOCTOR"
    .q:(Active'="Y")
    .s DateFrom=$p($g(^CT("CPT",id)),"^",5)
    .q:DateFrom=""
    .q:(DateFrom'="")&&(DateFrom>+$H) 
    .s DateTo=$p($g(^CT("CPT",id)),"^",6)
    .i DateTo="" s DateTo=+$H+1
	.q:DateTo<+$H

    .s ARCIMID=$G(^DHCPEOtherPatientToHPBase("CarPrvTpConOrder",curLoc,id))
    .s ARCIMDesc=""
    .i ARCIMID'="" S ARCIMDesc=$P($g(^ARCIM(+ARCIMID,1,1)),"^",2)
    .s DefaultItem=$g(^DHCPEOtherPatientToHPBase("ConOrderDefault",curLoc))
    .s DefaultARCIMDesc=""
    .i DefaultItem'="" S DefaultARCIMDesc=$P($g(^ARCIM(+DefaultItem,1,1)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb($g(id),Desc,InternalType,ARCIMDesc,DefaultARCIMDesc)
	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.OtherPatientToHPBaseSet","FindStation")
Query FindStation() As websys.Query(ROWSPEC = "StationID:%String,StationDesc:%String,RecLocDesc:%String,DefaultDoc:%String,GenConUserDesc:%String,GenConUserID:%String,ReclocID:%String,UserID:%String")
{
}

ClassMethod FindStationExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s curLoc=%session.Get("LOGON.CTLOCID") 
    s id=0
	f  s id=$O(^DHCPEST(id)) q:id=""  d
	.s Desc=$p($g(^DHCPEST(id)),"^",2)
    .s Code=$p($g(^DHCPEST(id)),"^",1)
    .s Active=$p($g(^DHCPEST(id)),"^",5)
    .q:(Active'="Y")
    .s ConRecLocInfo=$G(^DHCPEOtherPatientToHPBase("ConRecLoc",curLoc,id))
    .s ReclocID=""
    .s ReclocID=$p(ConRecLocInfo,"^",1)
    .s ReclocDesc=""
    .i ReclocID'="" s ReclocDesc=$P($g(^CTLOC(ReclocID)),"^",2)
    .s UserID=""
    .s UserID=$p(ConRecLocInfo,"^",2)
    .s UserName=""
    .i UserID'="" s UserName=$P($g(^SSU("SSUSR",UserID)),"^",2)
    .S GenConUserID=$G(^DHCPEOtherPatientToHPBase("GenConUser",curLoc))
    .s GenConUserDesc=""
    .i GenConUserID'="" s GenConUserDesc=$P($g(^SSU("SSUSR",GenConUserID)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb($g(id),Desc,ReclocDesc,UserName,GenConUserDesc,GenConUserID,ReclocID,UserID)
	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
