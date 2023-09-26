Class DHCDoc.DHCDocConfig.HLYY Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FinDTDep(value As %String, HospId As %String = "") As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FinDTDepExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HLYY","FinDTDep","DTAdmDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",CTLOCRowID,HospId)
	.q:flag="N"
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLocHospDr=$p(str,"^",22)
 	.Q:(CTLocHospDr'=HospId)&&(HospId'="")
 	.s CTLOCType=$p(str,"^",13)
 	.s CTLOCDesc=$p(str,"^",2)
 	.q:##class(web.DHCDocCommon).CheckLocIsValid(CTLOCRowID)=0
 	.s selected=0
 	.i value'="" d
 	..s:("^"_..%GetConfig(value,HospId)_"^")[("^"_CTLOCRowID_"^") selected=1 //$g(^DHCDocConfig(value))
	.Do OutputRowFinDTDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFinDTDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FinDTDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinDTDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FinDTDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinDTDepExecute ]
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

ClassMethod GetConfigNode1(Node As %String, SubNode As %String, HospId As %String = "") As %String
{
	Q:SubNode="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s rtn=$g(^DHCDocConfig(HospCodeNode,Node,SubNode))
	}else{
		s rtn=$g(^DHCDocConfig(Node,SubNode))
	}
	s:rtn="" rtn="^^"
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

Query FindHLYYCompany() As %Query(ROWSPEC = "rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod FindHLYYCompanyExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HLYY","FindHLYYCompany","")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s rowid=0
    for {
	    s rowid=$o(^DHCDocHLYYCompanyConfig(rowid)) Q:rowid=""
	    s str=$g(^DHCDocHLYYCompanyConfig(rowid))
	    s Code=$p(str,"^",1)
	    s Desc=$p(str,"^",2)
	    Do OutputRowFindHLYYCompany
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindHLYYCompany
	set Data=$lb($g(rowid),$g(Code),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindHLYYCompanyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHLYYCompanyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHLYYCompanyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHLYYCompanyExecute ]
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

ClassMethod SaveHLYYCompanyConfig(rowid As %String, Code As %String, Desc As %String)
{
	s ID=0,Repeat=0
    for {
	    s ID=$o(^DHCDocHLYYCompanyConfig(ID)) Q:ID=""||(Repeat=1)
	    s str=$g(^DHCDocHLYYCompanyConfig(ID))
	    s ComCode=$p(str,"^",1)
	    if (ComCode=Code)&&((rowid="")||(rowid'="")&&(rowid'=ID)) {
		    s Repeat=1
		}
	}
	Q:Repeat=1 "-1"
	if (rowid'="") {
		s ^DHCDocHLYYCompanyConfig(rowid)=Code_"^"_Desc
	}else{
		s maxRowid=+$o(^DHCDocHLYYCompanyConfig(""),-1)
		s NewRowId=maxRowid+1
		s ^DHCDocHLYYCompanyConfig(NewRowId)=Code_"^"_Desc
	}
	Q 0
}

ClassMethod DelHLYYCompanyConfig(rowid As %String)
{
	k ^DHCDocHLYYCompanyConfig(rowid)
}

Storage Default
{
<Data name="HLYYDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.DHCDocConfig.HLYYD</DataLocation>
<DefaultData>HLYYDefaultData</DefaultData>
<IdLocation>^DHCDoc.DHCDocConfig.HLYYD</IdLocation>
<IndexLocation>^DHCDoc.DHCDocConfig.HLYYI</IndexLocation>
<StreamLocation>^DHCDoc.DHCDocConfig.HLYYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
