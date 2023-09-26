Class DHCDoc.DHCDocConfig.PrescriptSet Extends %RegisteredObject
{

/// creator:屈坚
/// date:2020-10-12
/// desc:医生站设置程序->处方类型设置 
Query GetPrescriptSetList(HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,PSCode:%String,PSDesc:%String,PSType:%String,PSTypeDesc:%String")
{
}

ClassMethod GetPrescriptSetListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PrescriptSet","GetPrescriptSetList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s RowID=""
    for {
	    s RowID=$O(^DHCPRESCRIPTSET(RowID))
	    q:RowID=""
	    s PSCode=$P(^DHCPRESCRIPTSET(RowID),"^",1)
	    s PSDesc=$P(^DHCPRESCRIPTSET(RowID),"^",2)
	    s PSType=$P(^DHCPRESCRIPTSET(RowID),"^",3)
	    if (PSType="CM"){s PSTypeDesc="草药"}else {s PSTypeDesc="西药"}
	    s ActiveFlag=$P(^DHCPRESCRIPTSET(RowID),"^",5)
	    continue:ActiveFlag'="Y"
	    s Hospdr=$P(^DHCPRESCRIPTSET(RowID),"^",7)
	    continue:Hospdr'=HospId
	    d OutputRowGetPrescriptSetList
	    }

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPrescriptSetList
	set Data=$lb(RowID,PSCode,PSDesc,PSType,PSTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPrescriptSetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescriptSetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrescriptSetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrescriptSetListExecute ]
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

ClassMethod insert(Str As %String, HospId As %String = "") As %String
{
	s ^Tempscl("str")=Str
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	k PLIST
	s PLIST(2)=$p(Str,"^",1)
	s PLIST(3)=$p(Str,"^",2)
	s PLIST(4)=$p(Str,"^",3)
	s PLIST(5)=$p(Str,"^",4)
	s PLIST(6)=$p(Str,"^",5)
	s PLIST(8)=HospId
	s count=0
	&sql(select count(RowID) into :count from SQLUser.DHC_PrescriptSet where PSCode=:PLIST(2) and PSDesc=:PLIST(3) and PSType=:PLIST(4) and PSActive=:PLIST(6) and PSHospDr=:HospId)
	Q:count'=0 "记录重复!"
	&sql(insert into SQLUser.DHC_PrescriptSet values :PLIST())
	q SQLCODE
}

ClassMethod delete(Rowid) As %String
{
	s findPrescTypeDr=""
	&sql(update SQLUser.DHC_PrescriptSet set PSActive="N" where RowID=:Rowid)
    q SQLCODE
}

/// w ##class(DHCDoc.DHCDocConfig.PrescriptSet).Update(5,"藏药^藏药^CM^1^Y")
ClassMethod Update(Rowid As %String, str As %String) As %String
{
	s PSHospDr=$p(^DHCPRESCRIPTSET(Rowid),"^",7)
	s PSCode=$p(str,"^",1)
    s PSDesc=$p(str,"^",2)
    s PSType=$p(str,"^",3)
    s PSCreatUser=$p(str,"^",4)
    s PSActive=$p(str,"^",5)
    s count=0
	&sql(select count(RowID) into :count from SQLUser.DHC_PrescriptSet where PSCode=:PSCode and PSDesc=:PSDesc and PSType=:PSType and PSActive=:PSActive and PSHospDr=:PSHospDr and RowID<>:Rowid)
	Q:count'=0 "记录重复!"
	&sql(update SQLUser.DHC_PrescriptSet 
           set PSCode=:PSCode,PSDesc=:PSDesc,PSType=:PSType,PSCreatUser=:PSCreatUser,
               PSActive=:PSActive
           where RowID=:Rowid )
      q SQLCODE
}

Query GetPrescriptSet() As %Query(ROWSPEC = "PSType:%String,PSTypeDesc:%String")
{
}

ClassMethod GetPrescriptSetExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PrescriptSet","GetPrescriptSet")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PSType="XM"
    s PSTypeDesc="西药"
	Do OutputRowGetLimitType
	s PSType="CM"
    s PSTypeDesc="草药"
    Do OutputRowGetLimitType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetLimitType
	set Data=$lb($g(PSType),$g(PSTypeDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPrescriptSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescriptSetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrescriptSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrescriptSetExecute ]
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

/// creator:屈坚
/// date:2020-10-12
ClassMethod SavePrescriptCat(RowID As %String, CatIDStr As %String)
{
	&sql(update SQLUser.DHC_PrescriptSet set PSItemCatStr=:CatIDStr where RowID=:RowID)
    q SQLCODE
}

Query GetAllowItemCatIDList(RowID As %String, value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod GetAllowItemCatIDListExecute(ByRef qHandle As %Binary, RowID As %String, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PrescriptType","GetAllowItemCatIDList","QuickAdmDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
    f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
    .s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
    .s selected=0
    .i ("$"_$P(^DHCPRESCRIPTSET(RowID),"^",6)_"$")[("$"_ARCICRowId_"$")  s selected=1 //$g(^DHCDocConfig(value,PTRowid))
	.Do OutputRowGetAllowItemCatIDList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAllowItemCatIDList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllowItemCatIDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllowItemCatIDListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllowItemCatIDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllowItemCatIDListExecute ]
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

/// 判断某个用户是否有开医嘱项的权限
/// 入参 :医生Docid,医嘱项,医院,类型(西药XM，中药CM)
/// 出参 :1有0没有
/// w ##class(DHCDoc.DHCDocConfig.PrescriptSet).CheckForAllowArcItem(859,"1616||1",2,"XM")
ClassMethod CheckForAllowArcItem(DocID, ArcimRowid, HospId, Type = "")
{
	s ^Tempscl("CheckForAllowArcItem")=DocID_","_ArcimRowid_","_HospId_","_Type
	Q:DocID="" 1 //非医护人员默认有权限
	s ret=0
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	Q:OrderType'="R" 1
	s FindRMOsFlag=0 //医护人员是否维护了处方权,0 未维护 1 维护，未维护关联处方权时则默认该用户有权限
	s DocSub=0
	for{
		s DocSub=$O(^CTPCP(DocID,"CPPS",DocSub))
		q:DocSub=""
		s RowID=$P(^CTPCP(DocID,"CPPS",DocSub),"^",1)
		continue:$G(^DHCPRESCRIPTSET(RowID))=""
		s PSActive=$P(^DHCPRESCRIPTSET(RowID),"^",5)
		continue:PSActive'="Y"
		s Hospdr=$P(^DHCPRESCRIPTSET(RowID),"^",7)
	    continue:Hospdr'=HospId
	    s PSType=$P(^DHCPRESCRIPTSET(RowID),"^",3)
	    s FindRMOsFlag=1
		continue:((Type'="")&&(PSType'=Type))
		i ("$"_$P(^DHCPRESCRIPTSET(RowID),"^",6)_"$")[("$"_ItemCatDR_"$")  s ret=1 
	}
	Q:FindRMOsFlag=0 1
	Q ret
}

}
