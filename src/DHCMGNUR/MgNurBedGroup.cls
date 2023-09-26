/// 床位分组
Class DHCMGNUR.MgNurBedGroup Extends %Persistent
{

/// 病区
Property WardId As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Ward_Id ];

/// 组代码
Property GroupCode As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Code ];

/// 组描述
Property GroupDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Desc ];

/// 关联床位
Property LinkBed As %String(MAXLEN = 5000) [ SqlColumnNumber = 5, SqlFieldName = Link_Bed ];

/// 标志字段
Property GroupValid As %String [ SqlColumnNumber = 6, SqlFieldName = Group_Valid ];

Index Ward On WardId;

ClassMethod Save(parr As %String) As %String
{
	q:parr="" 0
	s temp=""
	d ##class(web.DHCNurRosterComm).setTmp(parr,.temp)
	i $g(temp("ID"))="" d
	.s a=##class(DHCMGNUR.MgNurBedGroup).%New()
	.i $g(temp("WardId"))'="" s a.WardId=temp("WardId")
	else  d
	.s a=##class(DHCMGNUR.MgNurBedGroup).%OpenId(temp("ID"))
	i $g(temp("GroupCode"))'="" s a.GroupCode=temp("GroupCode")
	i $g(temp("GroupDesc"))'="" s a.GroupDesc=temp("GroupDesc")
	;i $g(temp("LinkBed"))'="" s a.LinkBed=temp("LinkBed")
	s a.GroupValid="Y"
	TStart
	s sc=a.%Save()
	i $$$ISERR(sc){ TRollBack  d $System.Status.DisplayError(sc) q 0 }
	else{  TCommit  q 1 }
}

ClassMethod getVal(ID As %String) As %String
{
	s ^TEMP("g02171518001")=ID
	q:ID="" ""
	s ret=""
	s a=##class(DHCMGNUR.MgNurBedGroup).%OpenId(ID)
	q:a.GroupValid="N" ""
	s ret="WardId|"_a.WardId
	s ret=ret_"^WardCode|"_$P(^CTLOC(a.WardId),"^",2)
	;s ret=ret_"^WardDesc|"_$P(^CTLOC(a.WardId),"^",2)
	s ret=ret_"^GroupCode|"_a.GroupCode
	s ret=ret_"^GroupDesc|"_a.GroupDesc
	s ret=ret_"^LinkBed|"_a.LinkBed
	s ret=ret_"^GroupValid|"_a.GroupValid
	s PAWardId=$O(^PAWARD(0,"WARD_LocationDR",a.WardId,""))
	i a.LinkBed="" s BedDesc=""
	else  d 
	.f i=1:1:$L(a.LinkBed,",") d
	..s BedId=$P(a.LinkBed,",",i)
	..s BedCode=$P($g(^PAWARD(PAWardId,"BED",BedId)),"^",1)
	..q:BedCode=""
	..i $g(BedDesc)="" s BedDesc=BedCode
	..else  s BedDesc=BedDesc_","_BedCode
	s ret=ret_"^BedDesc|"_BedDesc
	s ret=ret_"^ID|"_ID
	q ret
}

ClassMethod linkBed(parr As %String) As %String
{
	q:parr="" 0
	s ID=$P(parr,"^",1)
	s LinkBed=$P(parr,"^",2)
	q:ID="" 0
	s a=##Class(DHCMGNUR.MgNurBedGroup).%OpenId(ID)
	s a.LinkBed=LinkBed
	TStart
	s sc=a.%Save()
	i $$$ISERR(sc){ TRollBack  d $System.Status.DisplayError(sc) q 0 }
	else{  TCommit  q 1 }
}

ClassMethod setMark(parr As %String) As %String
{
	q:parr="" 0
	s ID=$P(parr,"^",1)
	s MarkVal=$P(parr,"^",2)
	s a=##class(DHCMGNUR.MgNurBedGroup).%OpenId(ID)
	s a.GroupValid=MarkVal
	TStart
	s sc=a.%Save()
	i $$$ISERR(sc){ TRollBack  d $System.Status.DisplayError(sc) q 0 }
	else{ TCommit  q 1 }
}

ClassMethod getGroupBed(WardId As %String) As %String
{
	q:WardId=""
	s ret=""
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurBedGroupI("Ward"," "_WardId,ID)) q:ID=""  d
	.s a=##class(DHCMGNUR.MgNurBedGroup).%OpenId(ID)
	.q:a.GroupValid="N"
	.i ret'="" s ret=ret_","_a.LinkBed
	.else  s ret=a.LinkBed
	q ret
}

ClassMethod isValue(WardId As %String, GroupCode As %String) As %String
{
	q:WardId=""
	s ret=0
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurBedGroupI("Ward"," "_WardId,ID)) q:ID=""  d
	.s a=##class(DHCMGNUR.MgNurBedGroup).%OpenId(ID)
	.i a.GroupCode=GroupCode s ret=1
	q ret
}

Query FindGroupLinkBed(ID As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindGroupLinkBedExecute(ByRef qHandle As %Binary, ID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i ID="" {Set qHandle=$lb(0,repid,0) Quit $$$OK}
	s a=##class(DHCMGNUR.MgNurBedGroup).%OpenId(ID)
	s LinkBed=a.LinkBed
	s WardId=a.WardId
	s GroupCode=a.GroupCode
	s GroupDesc=a.GroupDesc
	s PAWardId=$O(^PAWARD(0,"WARD_LocationDR",WardId,""))
	i PAWardId="" {Set qHandle=$lb(0,repid,0) Quit $$$OK}
	i LinkBed="" {Set qHandle=$lb(0,repid,0) Quit $$$OK}
	f i=1:1:$L(LinkBed,",") d
	.s BedId=$P(LinkBed,",",i)
	.s BedCode=$P(^PAWARD(PAWardId,"BED",BedId),"^",1)
	.s BedRoomDR=$P(^PAWARD(PAWardId,"BED",BedId),"^",3)
	.s BedRoom=$P(^PAROOM(BedRoomDR),"^",1)
	.s ret="GroupId|"_ID_"^GroupCode|"_GroupCode_"^GroupDesc|"_GroupDesc_"^WardId|"_WardId_"^PAWardId|"_PAWardId_"^BedCode|"_BedCode_"^BedId|"_BedId_"^BedRoom|"_BedRoom
	.d OutPutBedRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutBedRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGroupLinkBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupLinkBedExecute ]
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

ClassMethod FindGroupLinkBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupLinkBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurBedGroup","FindGroupData","76")

Query FindGroupData(WardId As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindGroupDataExecute(ByRef qHandle As %Binary, WardId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i WardId="" {Set qHandle=$lb(0,repid,0) Quit $$$OK}
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurBedGroupI("Ward"," "_WardId,ID)) q:ID=""  d
	.s ret=..getVal(ID)
	.i ret'="" d OutputGroupRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputGroupRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGroupDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupDataExecute ]
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

ClassMethod FindGroupDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurBedGroup","FindPACBed","1018^N")
Query FindPACBed(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPACBedExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if parr="" 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s WardId=$P(parr,"^",1)
	s LinkValid=$P(parr,"^",2)
	s WardCode=$P(^CTLOC(WardId),"^",1)
	s PAWardId=$O(^PAWARD(0,"WARD_LocationDR",WardId,""))
	if PAWardId="" 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s GroupBed=..getGroupBed(WardId)
	;w !,GroupBed
	s number=0
	s BedId=0 f  s BedId=$O(^PAWARD(PAWardId,"BED",BedId)) q:BedId=""  d
	.q:$P(^PAWARD(PAWardId,"BED",BedId),"^",4)'="Y"
	.s BedStatusDR=$P(^PAWARD(PAWardId,"BED",BedId),"^",5)
	.i BedStatusDR'="" d
	..s BedStatus=$P(^PAC("BSTAT",BedStatusDR),"^",1)
	..q:BedStatus="U"
	.i LinkValid="N" q:$F(","_GroupBed_",",BedId)'=0
	.s BedCode=$P(^PAWARD(PAWardId,"BED",BedId),"^",1)
	.s BedRoomDR=$P(^PAWARD(PAWardId,"BED",BedId),"^",3)
	.s BedRoom=$P(^PAROOM(BedRoomDR),"^",1)
	.s number=number+1
	.s ret="PAWardId|"_PAWardId_"^WardId|"_WardId_"^WardCode|"_WardCode_"^BedId|"_BedId_"^BedRoom|"_BedRoom_"^BedCode|"_BedCode_"^number|"_number
	.d OutputBedRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputBedRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPACBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPACBedExecute ]
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

ClassMethod FindPACBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPACBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取已选择的床位
/// w ##class(DHCMGNUR.MgNurBedGroup).getSelectedBed("1018^2014-08-11")
ClassMethod getSelectedBed(parr As %String) As %String
{
	q:parr=""
	s WardId=$P(parr,"^",1)
	s AdmDate=$zdh($P(parr,"^",2),3)
	s ret=""
	s PRId="" f  s PRId=$O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_WardId," "_AdmDate,PRId)) q:PRId=""  d
	.s a=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(PRId)
	.q:a.AJConnBed=""
	.i ret="" s ret=a.AJConnBed
	.e  s ret=ret_","_a.AJConnBed
	q ret
}

Storage Default
{
<Data name="MgNurBedGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardId</Value>
</Value>
<Value name="3">
<Value>GroupCode</Value>
</Value>
<Value name="4">
<Value>GroupDesc</Value>
</Value>
<Value name="5">
<Value>LinkBed</Value>
</Value>
<Value name="6">
<Value>GroupValid</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurBedGroupD</DataLocation>
<DefaultData>MgNurBedGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurBedGroupD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurBedGroupI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurBedGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
