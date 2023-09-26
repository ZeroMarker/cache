Class web.DHCPE.GSDUnitRecord Extends %Persistent
{

/// 合并建议
ClassMethod Unit(HoldInfo, CancelIDs, UserID)
{
	s obj=##class(User.DHCPEGSDUnitRecord).%New()
	s obj.URHoldSource=$P(HoldInfo,"^",1)
	s obj.URHoldSourceConclusion=$P(HoldInfo,"^",2)
	s obj.URHoldSourceDetail=$P(HoldInfo,"^",3)
	d obj.URGSDDRSetObjectId(+obj.URHoldSource)
	s obj.URCancelSource=CancelIDs
	d obj.URUserDRSetObjectId(UserID)
	s obj.URDate=+$H
	s obj.URTime=$P($H,",",2)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// 撤销合并
ClassMethod CancelUnit(UnitRecordID)
{
	s obj=##class(User.DHCPEGSDUnitRecord).%OpenId(UnitRecordID)
	s HoldSource=obj.URHoldSource
	s Status=$p(^DHCPEGS(+HoldSource,"Diagnosis",$P(HoldSource,"||",2)),"^",11)
	//判断是否允许撤销合并
	
	
	s HoldJL=obj.URHoldSourceConclusion
	s HoldJY=obj.URHoldSourceDetail
	s CancelSource=obj.URCancelSource
	s CancelSourceLength=$L(CancelSource,",")
	TSTART
	&SQL(Update Sqluser.DHC_PE_GSDiagnosis Set GSD_Advice=:HoldJY where GSD_RowID=:HoldSource)
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	Set ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",HoldSource)=HoldJL
	for i=1:1:CancelSourceLength
	{
		s OneCancelID=$P(CancelSource,",",i)
		&SQL(Update Sqluser.DHC_PE_GSDiagnosis Set GSD_Status='0' where GSD_RowID=:OneCancelID)
		q:SQLCODE'=0
	}
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(Delete From Sqluser.DHC_PE_GSDUnitRecord where ID=:UnitRecordID)
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

// d ##class(web.DHCPE.GSDUnitRecord).OutCancelButton(UnitRecordID)

ClassMethod OutCancelButton(UnitRecordID)
{
	w "<button id='"_UnitRecordID_"' onclick='CancelUnitRecord(this)'>撤销</button>"
}

/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.GSDUnitRecord","FindUnitRecord",67)
Query FindUnitRecord(GSID As %Library.String = "") As %Query(ROWSPEC = "TURID:%String,THoldJL:%String,TUnitDate:%String,TUnitTime:%String")
{
}

ClassMethod FindUnitRecordExecute(ByRef qHandle As %Binary, GSID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i GSID=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s UnitRecord=0
	f  s UnitRecord=$O(^User.DHCPEGSDUnitRecordI("GSDIndex",GSID,UnitRecord)) q:UnitRecord=""  d
	.s THoldSource=$LG(^User.DHCPEGSDUnitRecordD(UnitRecord),3)
	.s THoldJL=$LG(^User.DHCPEGSDUnitRecordD(UnitRecord),5)
	.i THoldSource'="" s THoldJL=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",THoldSource))
	.s TUnitDate=$LG(^User.DHCPEGSDUnitRecordD(UnitRecord),8)
	.s:TUnitDate'="" TUnitDate=##class(websys.Conversions).DateLogicalToHtml(TUnitDate)
	.s TUnitTime=$LG(^User.DHCPEGSDUnitRecordD(UnitRecord),9)
	.s:TUnitTime'="" TUnitTime=$ZT(TUnitTime)
	.d FindBuild	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(UnitRecord,THoldJL,TUnitDate,TUnitTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindUnitRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUnitRecordExecute ]
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

ClassMethod FindUnitRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUnitRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="GSDUnitRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.GSDUnitRecordD</DataLocation>
<DefaultData>GSDUnitRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.GSDUnitRecordD</IdLocation>
<IndexLocation>^web.DHCPE.GSDUnitRecordI</IndexLocation>
<StreamLocation>^web.DHCPE.GSDUnitRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
