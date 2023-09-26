Class web.DHCBldCommonQuery Extends %Persistent
{

//获取病区描述

Query BloodPurpose(PurposeCode As %String) As %Query(ROWSPEC = "PurposeDesc:%String,Purpose:%String") [ SqlProc ]
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","BloodPurpose","")
ClassMethod BloodPurposeExecute(ByRef qHandle As %Binary, PurposeCode As %String) As %Status
{
 	S repid=$I(^CacheTemp)
 	I $g(ind)="" S ind=1
	S rowid=0
	S PurposeCode=$G(PurposeCode)
	S Purpose=""
	F  S Purpose=$O(^DHCBLDSTDCOMMENT(Purpose)) Q:Purpose=""  D
	.S PurposeTpye=$P(^DHCBLDSTDCOMMENT(Purpose),"\",3)
	.S PurposeDesc=$P(^DHCBLDSTDCOMMENT(Purpose),"\",2)
	.S PurposeTpye=$P(PurposeTpye,"||",1)
	.I PurposeTpye'="P" Q
	.I $L(PurposeCode),Purpose_PurposeDesc'[PurposeCode Q
	.S Data=$lb(PurposeDesc,Purpose)
 	.D OutputRow 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow
	set Data=$lb(PurposeDesc,Purpose)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod BloodPurposeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BloodPurposeExecute ]
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

ClassMethod BloodPurposeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BloodPurposeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Doctor(Doctor As %String) As %Query(ROWSPEC = "DoctorDesc:%String,DoctorCode:%String") [ SqlProc ]
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","Doctor","")
ClassMethod DoctorExecute(ByRef qHandle As %Binary, Doctor As %String) As %Status
{
 	S repid=$I(^CacheTemp)
 	I $g(ind)="" S ind=1
	S Doctor=$G(Doctor)
	S DoctorCode="null"
	S DoctorDesc="全部医生"
	S Data=$lb(DoctorDesc,DoctorCode)
 	D OutputRow1
	S DoctorId=""
	F  S DoctorId=$O(^CTPCP(DoctorId)) Q:DoctorId=""  D
	.I DoctorId=0 Q
	.I '$D(^CTPCP(DoctorId,1)) Q
	.S DoctorCode=$P(^CTPCP(DoctorId,1),"^",1)
	.S DoctorDesc=$P(^CTPCP(DoctorId,1),"^",2)
	.I $L(Doctor),DoctorCode_DoctorDesc'[Doctor Q
	.S Data=$lb(DoctorDesc,DoctorCode)
 	.D OutputRow1 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow1
	set Data=$lb(DoctorDesc,DoctorCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DoctorExecute ]
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

ClassMethod DoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BloodPurposeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","CliDep","")
Query CliDep(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "desc:%String,dep:%String") [ SqlProc ]
{
}

ClassMethod CliDepExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
	s rowid=0
	s clidep=""
	S clidesc="全部科室"
    S Data=$lb(clidesc,clidep)
    S depcode=$ZCVT(depcode,"U")
    S USERCODE=$G(USERCODE)
 	Do OutputRow2 
	f  s clidep=$O(^CTLOC(0,"Code",clidep)) Q:clidep=""  D
	.S rowid=$O(^CTLOC(0,"Code",clidep,""))
	.S clidesc=$P(^CTLOC(rowid),"^",2)
	.I $L(depcode),clidep_clidesc'[depcode Q
	.S Data=$lb(clidesc,clidep)
	.//b ;2
 	.Do OutputRow2 	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(clidesc,clidep)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CliDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CliDepExecute ]
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

ClassMethod CliDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CliDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","wardlookup","")
Query wardlookup(desc As %String, USERCODE As %String) As %Query(ROWSPEC = "ward:%String,wardid:%String") [ SqlProc ]
{
}

ClassMethod wardlookupExecute(ByRef qHandle As %Binary, desc As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=desc
 	If $g(ind)="" Set ind=1
	s rowid=0
	s desc=$$ALPHAUP^SSUTIL4(desc)
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=desc_"%"
	&sql(declare ward cursor  for 
	select WARD_rowid,WARD_desc,ward_code from SQLUser.PAC_WARD where %UPPER(WARD_desc) like :desc)
	&sql(open ward)
	f  &sql(fetch ward into :WARDrowid,:WARDdesc,:wardcode) q:SQLCODE  d
 	.Do OutputRow3 	 	
 	&sql(close ward)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
    i $f(WARDdesc,"-")'=0  d
    .s WARDdesc=$p(WARDdesc,"-",2)
	set Data=$lb(WARDdesc,WARDrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod wardlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = wardlookupExecute ]
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

ClassMethod wardlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = wardlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","Supplier","")
Query Supplier(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "SupplierDesc:%String,SupplierCode:%String") [ SqlProc ]
{
}

ClassMethod SupplierExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
	S rowid=0
	S SupplierCode=""
	S SupplierDesc="全部血站"
    S Data=$lb(SupplierDesc,SupplierCode)
    S depcode=$ZCVT(depcode,"U")
    S USERCODE=$G(USERCODE)
 	D OutputRow4 
	F  S SupplierCode=$O(^TTAB("BB-SUP",SupplierCode)) Q:'$L(SupplierCode)  D
	.S SupplierDesc=$P(^TTAB("BB-SUP",SupplierCode),"\",1)
	.S Data=$lb(SupplierDesc,SupplierCode)
 	.D OutputRow4 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow4
	set Data=$lb(SupplierDesc,SupplierCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SupplierFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SupplierExecute ]
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

ClassMethod SupplierClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SupplierExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","Product","")
Query Product(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "ProductDesc:%String,ProductCode:%String") [ SqlProc ]
{
}

ClassMethod ProductExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
	S rowid=0
	S ProductCode="null"
	S ProductDesc="全部血制品"
    S Data=$lb(ProductDesc,ProductCode)
    S depcode=$ZCVT(depcode,"U")
    S USERCODE=$G(USERCODE)
 	D OutputRow5 
 	S ProductCode=""
 	S Num=1
	F  S ProductCode=$O(^TTAB("BB-BP",ProductCode)) Q:'$L(ProductCode)  D
	.S ProductDesc=$P(^TTAB("BB-BP",ProductCode),"\",1)
	.S ActiveFlag=$P(^TTAB("BB-BP",ProductCode),"\",9)
	.I ActiveFlag="N" Q
	.S Data=$lb(ProductDesc,ProductCode)
 	.D OutputRow5 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow5
	set Data=$lb(ProductDesc,ProductCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProductExecute ]
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

ClassMethod ProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProductExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","ProductGroup","")
Query ProductGroup(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "ProductGroupDesc:%String,ProductGroupCode:%String") [ SqlProc ]
{
}

ClassMethod ProductGroupExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
	S rowid=0
	S ProductGroupCode="null"
	S ProductGroupDesc="全部血成份"
    S Data=$lb(ProductGroupDesc,ProductGroupCode)
    S depcode=$ZCVT(depcode,"U")
    S USERCODE=$G(USERCODE)
 	D OutputRow6 
 	S ProductGroupCode=""
	F  S ProductGroupCode=$O(^TTAB("BB-PG",ProductGroupCode)) Q:'$L(ProductGroupCode)  D
	.S ProductGroupDesc=$P(^TTAB("BB-PG",ProductGroupCode),"\",1)
	.S Data=$lb(ProductGroupDesc,ProductGroupCode)
 	.D OutputRow6 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow6
	set Data=$lb(ProductGroupDesc,ProductGroupCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ProductGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProductGroupExecute ]
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

ClassMethod ProductGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProductGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","TransType","")
Query TransType(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "TransTypeDesc:%String,TransTypeCode:%String") [ SqlProc ]
{
}

ClassMethod TransTypeExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
	S rowid=0
	S TransTypeCode="null"
	S TransTypeDesc="全部出库类型"
    S Data=$lb(TransTypeDesc,TransTypeCode)
    S depcode=$ZCVT(depcode,"U")
    S USERCODE=$G(USERCODE)
 	D OutputRow7 
 	S TransTypeCode=""
	F  S TransTypeCode=$O(^TTAB("BB-TR",TransTypeCode)) Q:'$L(TransTypeCode)  D
	.S TransTypeDesc=$P(^TTAB("BB-TR",TransTypeCode),"\",1)
	.I TransTypeCode="PGC" Q
	.I TransTypeCode="REC1" Q
	.I TransTypeCode="REC2" Q
	.I TransTypeCode="RTS" Q
	.I TransTypeCode="RTS1" Q
	.I TransTypeCode="SPLIT" Q
	.I TransTypeCode="SPTOUT" Q
	.I TransTypeCode="XM1" Q
	.I TransTypeCode="XM2" Q
	.S Data=$lb(TransTypeDesc,TransTypeCode)
 	.D OutputRow7 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow7
	set Data=$lb(TransTypeDesc,TransTypeCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TransTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TransTypeExecute ]
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

ClassMethod TransTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TransTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","BloodGroup","")
Query BloodGroup(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "BloodGroupDesc:%String,BloodGroupCode:%String") [ SqlProc ]
{
}

ClassMethod BloodGroupExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
	S rowid=0
	S BloodGroupCode="null"
	S BloodGroupDesc="全部血型"
    S Data=$lb(BloodGroupDesc,BloodGroupCode)
    S depcode=$ZCVT(depcode,"U")
    S USERCODE=$G(USERCODE)
 	D OutputRow8
    S BloodGroupCode="DC"
	S BloodGroupDesc="血型待测"
    S Data=$lb(BloodGroupDesc,BloodGroupCode)
 	D OutputRow8
 	S BloodGroupCode=""
	F  S BloodGroupCode=$O(^TTAB("BB-BG",BloodGroupCode)) Q:'$L(BloodGroupCode)  D
	.S BloodGroupDesc=$P(^TTAB("BB-BG",BloodGroupCode),"\",1)
	.I BloodGroupCode="A" Q
	.I BloodGroupCode="AB" Q
	.I BloodGroupCode="O" Q
	.I BloodGroupCode="B" Q
	.S Data=$lb(BloodGroupDesc,BloodGroupCode)
 	.D OutputRow8	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow8
	set Data=$lb(BloodGroupDesc,BloodGroupCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod BloodGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BloodGroupExecute ]
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

ClassMethod BloodGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BloodGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","Diagnose","")
Query Diagnose(depcode As %String, USERCODE As %String) As %Query(ROWSPEC = "DiagnoseDesc:%String,DiagnoseCode:%String") [ SqlProc ]
{
}

ClassMethod DiagnoseExecute(ByRef qHandle As %Binary, depcode As %String, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    S ^TMP("Ward")=depcode
 	If $g(ind)="" Set ind=1
	S rowid=0
	S DiagnoseCode=""
	;S DiagnoseDesc="全部血型"
    ;S Data=$lb(DiagnoseDesc,DiagnoseCode)
    S depcode=$ZCVT(depcode,"U")
    S USERCODE=$G(USERCODE)
 	;D OutputRow9
	F  S DiagnoseCode=$O(^MRC("ID",DiagnoseCode)) Q:'$L(DiagnoseCode)  D
	.I $L(^MRC("ID",DiagnoseCode),"^")<5 Q
	.S DiagnoseDesc=$P(^MRC("ID",DiagnoseCode),"^",2)
	.I $L(depcode),DiagnoseCode_DiagnoseDesc'[depcode Q
	.S Data=$lb(DiagnoseDesc,DiagnoseCode)
 	.D OutputRow9	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow9
	set Data=$lb(DiagnoseDesc,DiagnoseCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnoseExecute ]
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

ClassMethod DiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","TransType","")
Query AppFormTransType(USERCODE As %String) As %Query(ROWSPEC = "transTypeID:%String,transTypeDesc:%String") [ SqlProc ]
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","AppFormTransType")
ClassMethod AppFormTransTypeExecute(ByRef qHandle As %Binary, USERCODE As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	S rowid=0
	S transTypeID="null"
	S transTypeDesc="所有类型"
    S Data=$lb(transTypeID,transTypeDesc)
 	D OutputRow17 
	S transTypeID="" F  S transTypeID=$O(^DHCBLDSTDCOMMENTi(0,"TYPE","T||输血类型",transTypeID))  Q:transTypeID=""  D
	.I $D(^DHCBLDSTDCOMMENT(transTypeID)) S data=$G(^DHCBLDSTDCOMMENT(transTypeID))
	.S transTypeDesc=$P(data,"\",2)
	.;B ;001
	.S Data=$lb(transTypeID,transTypeDesc)
 	.D OutputRow17 
 		 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow17
	set Data=$lb(transTypeID,transTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AppFormTransTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AppFormTransTypeExecute ]
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

ClassMethod AppFormTransTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AppFormTransTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","AppFormTransPurpose","")
Query AppFormTransPurpose() As %Query(ROWSPEC = "transPurposeDesc:%String,transPurposeID:%String") [ SqlProc ]
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldCommonQuery","AppFormTransPurpose")
ClassMethod AppFormTransPurposeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	S rowid=0
	S transPurposeID="" F  S transPurposeID=$O(^DHCBLDSTDCOMMENTi(0,"TYPE","P||输血目的",transPurposeID))  Q:transPurposeID=""  D
	.I $D(^DHCBLDSTDCOMMENT(transPurposeID)) S data=$G(^DHCBLDSTDCOMMENT(transPurposeID))
	.S transPurposeDesc=$P(data,"\",2)
	.;B ;001
	.S Data=$lb(transPurposeDesc,transPurposeID)
 	.D OutputRow10 
 		 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow10
	set Data=$lb(transPurposeDesc,transPurposeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AppFormTransPurposeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AppFormTransTypeExecute ]
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

ClassMethod AppFormTransPurposeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AppFormTransTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCBldCommonQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldCommonQueryD</DataLocation>
<DefaultData>DHCBldCommonQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldCommonQueryD</IdLocation>
<IndexLocation>^web.DHCBldCommonQueryI</IndexLocation>
<StreamLocation>^web.DHCBldCommonQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
