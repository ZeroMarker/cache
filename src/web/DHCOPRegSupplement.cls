Class web.DHCOPRegSupplement Extends %RegisteredObject
{

ClassMethod FindBordBorByDep(Dep As %String) As %String
{
	s BorRowId="",BordAddress="",BordBorDr=""
	s BorRowId=$O(^User.DHCExaBorDepI("BordDepDrIndex"," "_Dep,BorRowId))
	if BorRowId'="" s BordBorDr=$List(^User.DHCExaBorDepD(BorRowId),6)
	if BordBorDr'="" s BordAddress=$List(^User.DHCExaBoroughD(BordBorDr),4)
	
	Q BordAddress
}

Query OPDept() As %SQLQuery(ROWSPEC = "CTLOCDesc:%String,CTLOCRowId:%String")
{
	Select CTLOC_Desc,CTLOC_RowId From SQLUser.CT_LOC where (CTLOC_TYPE='E')
}

ClassMethod PrintTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrintTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s ^UDHCPrescriptPrintType("PrintType",1)=1_"^"_"儿科格式"
	s ^UDHCPrescriptPrintType("PrintType",2)=2_"^"_"急诊格式"
	
	s PrintTypeID=""
	f  s PrintTypeID=$O(^UDHCPrescriptPrintType("PrintType",PrintTypeID)) q:PrintTypeID=""  d
	.s PrintTypeDesc=$p(^UDHCPrescriptPrintType("PrintType",PrintTypeID),"^",2)
	.d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
    
	set Data=$lb(PrintTypeDesc,PrintTypeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PrintTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintTypeExecute ]
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

Query PrintType() As %Query(ROWSPEC = "PrintTypedesc:%String,rowid:%String")
{
}

ClassMethod insertPrintType(LocID, PrintTypeID)
{
	s ^guo("insertPrintType")=LocID_"^"_PrintTypeID
	Q:(LocID="")||(PrintTypeID="") "200"
	Q:PrintTypeID=$g(^UDHCPrescriptPrintConfig("PrintConfig",LocID)) "201"
	s ^UDHCPrescriptPrintConfig("PrintConfig",LocID)=PrintTypeID
	q 0
}

ClassMethod updatePrintType(TLocID, TPrintTypeID)
{
}

ClassMethod deletePrintType(TLocID)
{
	Q:TLocID="" "201"
	k ^UDHCPrescriptPrintConfig("PrintConfig",TLocID)
	q 0
}

// 配置好的数据展示

// d ##class(%ResultSet).RunQuery("web.DHCOPRegSupplement","PrintConfig")

ClassMethod PrintConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrintConfigExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	
	s TLocID=""
	f  s TLocID=$O(^UDHCPrescriptPrintConfig("PrintConfig",TLocID)) q:TLocID=""  d
	.s LocDesc=$p(^CTLOC(TLocID),"^",2)
	.s PrintTypeID=$g(^UDHCPrescriptPrintConfig("PrintConfig",TLocID))
	.s PrintTypeDesc=$p(^UDHCPrescriptPrintType("PrintType",PrintTypeID),"^",2)
	.d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
    
	set Data=$lb(PrintTypeDesc,LocDesc,TLocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PrintConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintConfigExecute ]
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

Query PrintConfig() As %Query(ROWSPEC = "TPrescriptType:%String,TLoc:%String,TLocID:%String")
{
}

// 取打印配置找格式

// w ##class(web.DHCOPRegSupplement).GetPrintConfigByAdm(63)

ClassMethod GetPrintConfigByAdm(AdmID)
{
	q:AdmID="" "203"
	s PrintTypeID=""
	s AdmdepID=$p(^PAADM(AdmID),"^",4)
	s DepDesc=$p(^CTLOC(AdmdepID),"^",2)
	S Config=$G(^UDHCPrescriptPrintConfig("PrintConfig",AdmdepID))
	q:Config="" ""
	s PrintTypeID=^UDHCPrescriptPrintConfig("PrintConfig",AdmdepID)
	q PrintTypeID
}

// 处方打印上收费类型显示

ClassMethod PrescriptExtantClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrescriptExtantExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PrescriptExtantExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s REARowId=0
	f  s REARowId=$o(^PAC("ADMREA",REARowId)) q:REARowId=""  d
	.s READesc=$p(^PAC("ADMREA",REARowId),"^",2)
	.s PrintName=$p($G(^PAC("ADMREA",REARowId,"DOC")),"^",1)
	.d OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    
	set Data=$lb(REARowId,READesc,PrintName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PrescriptExtantFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrescriptExtantExecute ]
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

Query PrescriptExtant() As %Query(ROWSPEC = "ADMReasonID:%String,ADMReason:%String,PrintName:%String")
{
}

ClassMethod SavePrescriptExtant(Str)
{
	s ADMReasonsLength=$l(Str,"$")
	for i=1:1:ADMReasonsLength  
	{
		s OneInfo=$p(Str,"$",i)
		s REARowId=$p(OneInfo,"^",1)
		s PrintName=$p(OneInfo,"^",2)
		s $p(^PAC("ADMREA",REARowId,"DOC"),"^",1)=PrintName
	}
	
	q 0
}

}
