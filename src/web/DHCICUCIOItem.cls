Import SQLUSER

Class web.DHCICUCIOItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindICUCIOItem(desc As %String = "", ctlocId As %String, viewCatId As %String = "", code As %String = "", ynuse As %String = "") As %Query(ROWSPEC = "tIcucioiId,tIcucioiCode,tIcucioiDesc,tIcucioiTypeDesc,tAncoDesc,tAncvcDesc,tPhcinDesc,tIcucioiActiveDesc,tCtlocDesc,tIcucioiType,tAncoId,tAncvcId,tPhcinId,tIcucioiActive,tCtlocId,tIcucioiDrCode,tIcucioiDrDesc,tIcucioiDr,tIcucioiStrategyDesc,tIcucioiMultiple,tIcucioiValueField") [ SqlProc ]
{
}

ClassMethod FindICUCIOItemExecute(ByRef qHandle As %Binary, desc As %String = "", ctlocId As %String, viewCatId As %String = "", code As %String = "", ynuse As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tIcucioiId=0
	f  s tIcucioiId=$o(^DHCICUC("IOItem",tIcucioiId))  q:tIcucioiId=""  d
	.s tIcucioiCode=$p(^DHCICUC("IOItem",tIcucioiId),"^",1)
	.q:(code'="")&(tIcucioiCode'[code)
	.s tIcucioiDesc =$p(^DHCICUC("IOItem",tIcucioiId),"^",2)
	.q:(desc'="")&(tIcucioiDesc'[desc)
    .s tIcucioiType =$p(^DHCICUC("IOItem",tIcucioiId),"^",3)
	.s tIcucioiTypeDesc=##class(web.DHCCLCom).GetComDescByCode("InputOutput", tIcucioiType)
	.S tAncoId=$p(^DHCICUC("IOItem",tIcucioiId),"^",4)
	.S tAncoDesc=""
	.I tAncoId'=""  s tAncoDesc=$p($g(^DHCICUC("RecordItem",tAncoId)),"^",2)
	.s tAncvcId=$p(^DHCICUC("IOItem",tIcucioiId),"^",5)
	.q:(viewCatId'="")&(tAncvcId'=viewCatId)
	.I tAncvcId'="" S tAncvcDesc=$p($g(^DHCICUC("ViewCat",tAncvcId)),"^",2)
	.e  s tAncvcDesc=""
	.s tPhcinId=$p(^DHCICUC("IOItem",tIcucioiId),"^",6)
	.s tPhcinDesc=""
	.i tPhcinId'="" s tPhcinDesc=$p($g(^PHCIN(tPhcinId)),"^",2)
	.s tIcucioiActive=$p(^DHCICUC("IOItem",tIcucioiId),"^",7)
	.i tIcucioiActive="Y" s tIcucioiActiveValue=1
	.e  s tIcucioiActiveValue=0
	.q:(ynuse'="")&(tIcucioiActiveValue'=ynuse)
	.;s ^tmpzmy(11)=ynuse
	.s tIcucioiActiveDesc=##class(web.DHCCLCom).GetComDescByCode("YesNo", tIcucioiActiveValue)
	.s tCtlocId=$p(^DHCICUC("IOItem",tIcucioiId),"^",8)
	.q:(ctlocId'="")&(ctlocId'=tCtlocId)
	.s tCtlocDesc=$p($g(^CTLOC(+tCtlocId)),"^",2)
	.s tIcucioiDr=$p(^DHCICUC("IOItem",tIcucioiId),"^",9) //添加了ICUCIOI_MaiICUCIOI_Dr的查询
	.s tIcucioiDrCode="",tIcucioiDrDesc=""
	.i tIcucioiDr'=""  d
	..s tIcucioiDrCode=$p(^DHCICUC("IOItem",tIcucioiDr),"^",1)
	..s tIcucioiDrDesc=$p(^DHCICUC("IOItem",tIcucioiDr),"^",2)
	.s tIcucioiStrategyDesc=$p(^DHCICUC("IOItem",tIcucioiId),"^",10) //添加了ICUCIOI_Strategy的查询
	.s tIcucioiMultiple=$p(^DHCICUC("IOItem",tIcucioiId),"^",11)
	.s tIcucioiValueField=$p(^DHCICUC("IOItem",tIcucioiId),"^",12)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tIcucioiId,tIcucioiCode,tIcucioiDesc,tIcucioiTypeDesc,tAncoDesc,tAncvcDesc,tPhcinDesc,tIcucioiActiveDesc,tCtlocDesc,tIcucioiType,tAncoId,tAncvcId,tPhcinId,tIcucioiActive,tCtlocId,tIcucioiDrCode,tIcucioiDrDesc,tIcucioiDr,tIcucioiStrategyDesc,tIcucioiMultiple,tIcucioiValueField) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCIOItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCIOItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindICUCIOItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCIOItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 插入数据

ClassMethod InsertICUCIOItem(icucioiCode, icucioiDesc, icucioiType, ancoId, ancvcId, phcinId, icucioiActive, ctlocId, icucioiDr, icucioiStrategy, icucioiMultiple, icucioiValueField) As %String
{
	q:icucioiCode="" "代码不能为空!"
	q:icucioiDesc="" "描述不能为空!"
	;q:ancvcId="" "显示分类不能为空!"
	;q:icucioiType="" "出入量类型不能为空!"
	
	s icucioiId=0,retStr=0
	f  s icucioiId=$o(^DHCICUC("IOItem",icucioiId)) q:(icucioiId="")!(retStr'=0)  d
	    .i icucioiCode=$p(^DHCICUC("IOItem",icucioiId),"^",1),ctlocId=$p(^DHCICUC("IOItem",icucioiId),"^",8) s retStr="代码相同!"
	q:retStr'=0 retStr
	i icucioiActive="1" s icucioiActive="Y"
	i icucioiActive="0" s icucioiActive="N"
		
	s ^tmpYpz("insIOItem")=icucioiCode_"/"_icucioiDesc_"/"_icucioiType_"/"_ancoId_"/"_ancvcId_"/"_phcinId_"/"_icucioiActive_"/"_ctlocId_"/"_icucioiDr_"/"_icucioiStrategy_"/"_icucioiMultiple_"/"_icucioiValueField
    
	TSTART
	k PLIST
	s PLIST(2)=icucioiCode
	s PLIST(3)=icucioiDesc
	s PLIST(4)=icucioiType
	s PLIST(5)=ancoId
	s PLIST(6)=ancvcId	
	s PLIST(7)=phcinId
	s PLIST(8)=icucioiActive
	s PLIST(9)=ctlocId
	s PLIST(10)=icucioiDr           //添加了ICUCIOI_MaiICUCIOI_Dr的数据插入
	s PLIST(11)=icucioiStrategy     //添加了ICUCIOI_Strategy的数据插入
	s PLIST(12)=icucioiMultiple
	s PLIST(13)=icucioiValueField
	&SQL(insert into DHC_ICUC_IOItem Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
    s retStr=SQLCODE
	q retStr
}

// 更新数据

ClassMethod UpdateICUCIOItem(icucioiId, icucioiCode, icucioiDesc, icucioiType, ancoId, ancvcId, phcinId, icucioiActive, ctlocId, icucioiDr, icucioiStrategy, icucioiMultiple, icucioiValueField) As %String
{
 	q:icucioiId="" "记录Id为空!"
 	q:icucioiCode="" "代码不能为空!"
	q:icucioiDesc="" "描述不能为空!"
	;q:ancvcId="" "显示分类不能为空!"
	;q:icucioiType="" "出入量类型不能为空!"
	
	i icucioiActive="1" s icucioiActive="Y"
	i icucioiActive="0" s icucioiActive="N"
	
	
	s tmpIcucioiId=0,retStr=0
	f  s tmpIcucioiId=$o(^DHCICUC("IOItem",tmpIcucioiId)) q:(tmpIcucioiId="")!(retStr'=0)  d
	    .q:icucioiId=tmpIcucioiId
	    .i icucioiCode=$p(^DHCICUC("IOItem",tmpIcucioiId),"^",1),ctlocId=$p(^DHCICUC("IOItem",tmpIcucioiId),"^",8) s retStr="代码相同!"
	q:retStr'=0 retStr
	
	i (icucioiId'="")&&(icucioiCode'="")&&(icucioiDesc'="") d
	.k PLIST
	.s PLIST(2)=icucioiCode
	.s PLIST(3)=icucioiDesc
	.s PLIST(4)=icucioiType
	.s PLIST(5)=ancoId
	.s PLIST(6)=ancvcId
	.s PLIST(7)=phcinId
	.s PLIST(8)=icucioiActive
	.s PLIST(9)=ctlocId
	.s PLIST(10)=icucioiDr         //添加了ICUCIOI_MaiICUCIOI_Dr的数据更新
	.s PLIST(11)=icucioiStrategy   //添加了ICUCIOI_Strategy的数据更新
	.s PLIST(12)=icucioiMultiple
	.s PLIST(13)=icucioiValueField
	.&SQL(update DHC_ICUC_IOItem Values :PLIST() where ICUCIOI_RowId=:icucioiId)
	.s retStr=SQLCODE
	Q retStr
}

// 删除数据

ClassMethod DeleteICUCIOItem(icucioiId As %String) As %String
{
	q:icucioiId="" "输入Id错!"
	&SQL(delete from  DHC_ICUC_IOItem  where ICUCIOI_RowId=:icucioiId)
	Q SQLCODE
}

// 添加了获得主项数据

Query LookupIcucioiDr() As %Query(ROWSPEC = "tIcucioiId,tIcucioiDesc,tIcucioiCode") [ SqlProc ]
{
}

ClassMethod LookupIcucioiDrExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tIcucioiId=0
	f  s tIcucioiId=$o(^DHCICUC("IOItem",tIcucioiId))  q:tIcucioiId=""  d
	.s tIcucioiCode=$p(^DHCICUC("IOItem",tIcucioiId),"^",1)
	.s tIcucioiDesc =$p(^DHCICUC("IOItem",tIcucioiId),"^",2)
	.s tIcucioiDr=$p(^DHCICUC("IOItem",tIcucioiId),"^",9)
	.q:tIcucioiDr'=""
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(tIcucioiId,tIcucioiDesc,tIcucioiCode) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookupIcucioiDrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupIcucioiDrExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod LookupIcucioiDrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupIcucioiDrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookuIcucioiStrategy() As %Query(ROWSPEC = "Strategy,StrategyDesc") [ SqlProc ]
{
}

ClassMethod LookuIcucioiStrategyExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Strategy="N"
	s StrategyDesc="Normal"
	d OutputRow2
	s Strategy="T"
	s StrategyDesc="TimePoint"
	d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(Strategy,StrategyDesc) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookuIcucioiStrategyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookuIcucioiStrategyExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod LookuIcucioiStrategyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookuIcucioiStrategyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSummaryItems(locationId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT %ID As Id,
		   ICUCIOI_Code As Code,
		   ICUCIOI_Desc As Description,
		   ICUCIOI_ComOrd_Dr As RecordItemId,
		   ICUCIOI_ViewCat_Dr As RecordCatId,
		   ICUCIOI_Active As Active,
		   ICUCIOI_Ctloc_Dr As LocationId,
		   ICUCIOI_MainICUCIOI_Dr As SummaryItemId,
		   ICUCIOI_Strategy As Strategy,
		   ICUCIOI_Multiple As Multiple,
		   ICUCIOI_ValueField As ValueField
		   FROM DHC_ICUC_IOItem where ICUCIOI_Ctloc_Dr=:locationId
}

// 获取出入量汇总项

Query FindICUCIOItemDesc() As %Query(ROWSPEC = "itmDesc:%String,itmId:%String") [ SqlProc ]
{
}

ClassMethod FindICUCIOItemDescExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s IcucioiId=0
	f  s IcucioiId=$o(^DHCICUC("IOItem",IcucioiId))  q:IcucioiId=""  d
    .s IcucioiDesc=$p(^DHCICUC("IOItem",IcucioiId),"^",2)
	.d OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(IcucioiDesc,IcucioiId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCIOItemDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCIOItemDescExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindICUCIOItemDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCIOItemDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCICUCIOItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCICUCIOItemD</DataLocation>
<DefaultData>DHCICUCIOItemDefaultData</DefaultData>
<IdLocation>^web.DHCICUCIOItemD</IdLocation>
<IndexLocation>^web.DHCICUCIOItemI</IndexLocation>
<StreamLocation>^web.DHCICUCIOItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
