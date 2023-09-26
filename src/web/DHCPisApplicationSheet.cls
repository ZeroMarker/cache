Import SQLUser

Class web.DHCPisApplicationSheet Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

// w ##class(web.DHCPisApplicationSheet).SetPISNameSpace()

ClassMethod SetPISNameSpace()
{
	;set Config=##Class(websys.Configuration).%OpenId(1)
	;s PIS=Config.DataNamespace
	;zn PIS
	zn "dhc-pis"
}

ClassMethod SetMedDataNameSpace()
{
	ZN "dhc-data"
	//ZN "meddata"
}

ClassMethod SetWebSourceNameSpace()
{
	//ZN "websrc"
	ZN "dhc-app"
}

// w ##class(web.DHCPisApplicationSheet).GetPaadmInfo(69)

ClassMethod GetPaadmInfo(paadmdr As %String) As %String
{
     s paadmdr=$g(paadmdr)
     s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Info=##class(Src.DPIS3InInterface).GetPaadmInfo(paadmdr)
     s $NAMESPACE=CurrentNameSpace   
     i $p(Info,"^",19)="" d
     .s $p(Info,"^",19)=##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(paadmdr,"5511")
     i $p(Info,"^",22)="" d
     .s $p(Info,"^",22)=##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(paadmdr,"5510")
     i $p(Info,"^",25)=""  d  
     .d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     .s patmasDr=##class(Src.PIS3Common).GetPatmasRowIdbyPaadmRowId(paadmdr)    
     .;s MJJB=""
     .;d ##class(Src.DPIS3InInterface).GetPatMJJB(.MJJB,patmasDr,"")
     .s $NAMESPACE=CurrentNameSpace 
     .;i MJJB'=""  d
     ..;s $p(Info,"^",25)=$p(MJJB,"^",1) //密集字符 
     ..;s $p(Info,"^",26)=$p(MJJB,"^",2) //密集级别
     
     q Info
}

// w ##class(web.DHCPisApplicationSheet).GetLocName(6)

ClassMethod GetLocName(LocDR As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Data=""
	s Info=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.DPIS3InInterface).GetLocName(.Data,LocDR)
	s Info=$p(Data,"*",1)	
	s $NAMESPACE=CurrentNameSpace
	q Info
}

// w ##class(web.DHCPisApplicationSheet).GetMainDiaginfo(457)

ClassMethod GetMainDiaginfo(ADMdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s ADMdr=$g(ADMdr)
     s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Info=##class(Src.DPIS3InInterface).GetMainZD(ADMdr)  //2013-11-27修改
     s $NAMESPACE=CurrentNameSpace
     q Info
}

// w ##class(web.DHCPisApplicationSheet).GetTmRowIdByOrderDr("","430||204")

ClassMethod GetTmRowIdByOrderDr(Locdr As %String, OrderDr As %String) As %String
{
    s OrderDr=$g(OrderDr)
    i OrderDr="" q -901
    s rowId=$o(^DHCPISTestMasteri("ORDER",Locdr,OrderDr,""))
	q $g(rowId)
}

// w ##class(web.DHCPisApplicationSheet).GetUserNameBySSUserRowId("1")

ClassMethod GetUserNameBySSUserRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s rowId=$g(rowId)
	s rtn=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s rtn=##class(Src.DPIS3InInterface).GetUserNameBySSUserRowId(rowId)
	s $NAMESPACE=CurrentNameSpace
	q rtn
}

ClassMethod UpdateTmLocDr(Info As %String, rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	 s rowId=$g(rowId)
     s Info=$g(Info)
     s data=""   
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).UpdateTmLocDr(data,Info,rowId)
     s $NAMESPACE=CurrentNameSpace
     q data
}

ClassMethod UpdatePatInfo(Info As %String, rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=$g(Info)
     s data=""   
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).UpdatePatInfo(data,Info,rowId)
     s $NAMESPACE=CurrentNameSpace
     q data
}

ClassMethod UpdatePatInfo2(Info As %String, rowId As %String) As %String
{
	s ^test=Info_"^"_rowId
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=$g(Info)    
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).UpdatePatientInfo(data,Info,rowId)
     s $NAMESPACE=CurrentNameSpace
     q data
}

// w ##class(web.DHCPisApplicationSheet).GetPatInfoByTmRowId(21)

ClassMethod GetPatInfoByTmRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	 s rowId=$g(rowId)
	 s data=""  //2013-11-27
     s Info="",paadmdr="",chargeType="",papatmasmdr="",AdmNo="",IPNo="",socialStatusDr="",feetype=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetPatInfoByRowId(.data,rowId)  //2013-11-27修改    
     s Info=data //2013-11-27
     s $NAMESPACE=CurrentNameSpace
     s paadmdr=$p(Info,"^",1)    
     s chargeType=$p(Info,"^",9)      
     i paadmdr'="" d	;下面两个获取电话和地址
     .i $p(Info,"^",11)="" s $p(Info,"^",11)=##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(paadmdr,"5510")
     .i $p(Info,"^",10)="" s $p(Info,"^",10)=##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(paadmdr,"5511")    
     .s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
     .i papatmasmdr'="" d
     ..i AdmNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1) d
     ...s AdmNo=$P($g(^DHCPISTestMaster(rowId)),"^",33)
     ...s IPNo=$P($g(^DHCPISTestMaster(rowId)),"^",34)
     ...i IPNo="" s IPNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
     ...s $p(Info,"^",12)=IPNo
     ...s $p(Info,"^",13)=AdmNo
  
     q Info
}

ClassMethod UpdateAppInfo(Info As %String, rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=$g(Info)
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).UpdateAppInfo(.data,Info,rowId)
     s $NAMESPACE=CurrentNameSpace
     q data
}

ClassMethod UpdateAppInfo2(Info As %String, rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=$g(Info)
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).UpdateAppPatInfo(.data,Info,rowId)
     s $NAMESPACE=CurrentNameSpace
     q data
}

// w ##class(web.DHCPisApplicationSheet).GetAppInfoByTmRowId(295)

ClassMethod GetAppInfoByTmRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetAppInfoByRowId(.data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     
     q Info
}

ClassMethod UpdateSpecimenInfo(info As %String, rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s info=$g(info)
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()     
     d ##class(Src.PIS3Register).UpdateSpecimenInfo(.data,info,rowId)
     s $NAMESPACE=CurrentNameSpace
     q data
}

Query QuerySpecimenByParref(TMrowid As %String) As %Query(ROWSPEC = "TSpeNum:%String,TSpePos:%String,TSpeMemo:%String,TSpeRowId:%String")
{
}

ClassMethod QuerySpecimenByParrefExecute(ByRef qHandle As %Binary, TMrowid As %String) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s ^lff=TMrowid
 //s TMrowid=3
 s TMrowid=$p(TMrowid,$c(0))
 i TMrowid'="" d
 .s speciNo="",speciName="",speciClass="",acceptorDr="",acceptDate="",acceptTime=""
 .s info="",child=0,tsRowId=""
 .f  s child=$o(^DHCPISTestMaster(TMrowid,"TS",child)) q:child=""  d
 ..s info=^DHCPISTestMaster(TMrowid,"TS",child)
 ..s speciNo=$p(info,"^",1)
 ..s speciName=$p(info,"^",3)
 ..s speciMemo=$p(info,"^",6)
 ..Do OutQuerySpecimenByParref
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQuerySpecimenByParref
 //set Data=$lb(speciNo,speciName,speciClass,acceptorDr,acceptDate,acceptTime,tsRowId)
 set Data=$lb(speciNo,speciName,speciMemo,TMrowid_"||"_child)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
quit
}

ClassMethod QuerySpecimenByParrefFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySpecimenByParrefExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySpecimenByParrefClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySpecimenByParrefExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateStatus(Info As %String, rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).UpdateStatus(.data,Info,rowId)
     s $NAMESPACE=CurrentNameSpace
     q data
}

ClassMethod TestMasterAdd(Locdr As %String, classDr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s classDr=$g(classDr)
     s Info=""
     s data="" //2013-11-27修改
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace() 
     d ##class(Src.PIS3Register).TestMasterAdd(.data,Locdr_"^"_classDr) //2013-11-27修改
     s Info=data //2013-11-27
     s $NAMESPACE=CurrentNameSpace //2013-11-27修改
     q Info
}

ClassMethod TestMasterDel(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=""
     s data="" //2013-11-27修改
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).TestMasterDel(.data,rowId) //2013-11-27修改
     s Info=data //2013-11-27
     s $NAMESPACE=CurrentNameSpace //2013-11-27修改
     q Info
}

// w ##class(web.DHCPisApplicationSheet).GetRowIdByOrderDr("57||22||1")

ClassMethod GetRowIdByOrderDr(OrderDr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
    s OrderDr=$g(OrderDr)
    i OrderDr="" q -901
    s Locdr=""
    ;s Locdr=$o(^CTLOC(0,"Desc","BLK病理科",""))
    d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    s sysid=0 f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	.i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
    .s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	.s Locdr=sysInfo.SYSDEPTCODE
	.q:Locdr=""
	s $NAMESPACE=CurrentNameSpace  
    s rowId=$o(^DHCPISTestMasteri("ORDER",Locdr,OrderDr,""))
	q $g(rowId)
}

ClassMethod GetRSIdByCode(code As %String) As %String
{
	i code="" q -901
	s RowId=""
	s RowId=$o(^DHCPISResultStatusi("CODE",code,""))
	q RowId
}

ClassMethod GetRSCodeById(rowId As %String) As %String
{
	i rowId="" q -901
	i '$d(^DHCPISResultStatus(rowId)) q -911
	s scode=""
	s scode=$p(^DHCPISResultStatus(rowId),"^",2)
	q scode
}

ClassMethod ChangeAppStatusByOrderDoc(orderDr As %String, docDr As %String) As %String
{
	s orderDr=$g(orderDr)
	s docDr=$g(docDr)
	i (orderDr="")||(docDr="") q -901
	/*d ##class(web.DHCPisApplicationSheet).SetMedDataNameSpace()
    s SQLCODE=$$UpDateBillStatus^PISRISInterFace(orderDr,docDr) //???
    ;d ##class(Src.DHCPisCommon).SetPISNameSpace()
    zn "websrc"*/
    s xdate=$zd(+$h,4)
	s SQLCODE=##class(web.DHCRisApplicationBill).SaveAppBill("", orderDr, xdate, docDr,"","")
	q SQLCODE
}

ClassMethod CancelAppToENS(orderDr As %String, docDr As %String) As %String
{
	s orderDr=$g(orderDr)
	s docDr=$g(docDr)
	i (orderDr="")||(docDr="") q -901
    s xdate=$zd(+$h,4)
	s SQLCODE=..SaveAppBill("", orderDr, xdate, docDr,"","")
	s bb=##Class(DHCENS.PIS.BS.WebPISService).SendCancelAppBill(orderDr)
	q SQLCODE
}

ClassMethod GetWomenInfoByTmRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetWomanInfoByParref(data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

ClassMethod GetTumourInfoByTmRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetTumourInfoByParref(.data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

ClassMethod ChangeDate3to4(strDate As %String) As %String
{
	// 格式2006-12-1 to 1/12/2006
	s strDate=$g(strDate)
	i $p(strDate,"-",2)'="" d
	.s strDate=$zdh(strDate,3)
	q $zd(strDate,4)
}

ClassMethod ChangeDate4to3(strDate As %String) As %String
{
	// 格式1/12/2006 to 2006-12-1
	s strDate=$g(strDate)
	i $p(strDate,"/",2)'="" d
	.s strDate=$zdh(strDate,4)
	q $zd(strDate,3)
}

ClassMethod TestSpeciAdd(speInfo As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s speInfo=$g(speInfo)
     s data=""  //2013-11-27
     s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s ^specimen("lll")=speInfo
     d ##class(Src.PIS3Register).TestSpeciAdd(.data,speInfo) //2013-11-27
     s Info=data
     s $NAMESPACE=CurrentNameSpace //2013-11-27
     q Info
}

ClassMethod TestSpeciDel(speInfo As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s speInfo=$g(speInfo)
     s Info=""    
     s data="" //2013-11-27
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()   
     d ##class(Src.PIS3Register).TestSpeciDel(.data,speInfo) //2013-11-27
     s Info=data
     s $NAMESPACE=CurrentNameSpace  //2013-11-27
     q Info
}

// w ##class(web.DHCPisApplicationSheet).TestTumourAdd("20^2010-01-02^1^2^3^4^5^6^7")

// 

ClassMethod TestTumourAdd(tumourInfo As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s tumourInfo=$g(tumourInfo)
     s Info=""
     s data=""    
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).TestTumoAdd(.data,tumourInfo)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

Query QueryPart() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QueryPartExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s name="全部"
 Do OutQueryPart
 s name="部分"
 Do OutQueryPart
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQueryPart
 set Data=$lb(name)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPartExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPartExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryDealMethod() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QueryDealMethodExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s name="由亲属领回"
 Do OutQueryDealMethod
 s name="由院方处置"
 Do OutQueryDealMethod
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQueryDealMethod
 set Data=$lb(name)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryDealMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDealMethodExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryDealMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDealMethodExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryTestResult() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QueryTestResultExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s name="-"
 Do OutQueryTestResult
 s name="+"
 Do OutQueryTestResult
 s name="-"
 Do OutQueryTestResult
 s name="++"
 Do OutQueryTestResult
 s name="+++"
 Do OutQueryTestResult
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQueryTestResult
 set Data=$lb(name)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryTestResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTestResultExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryTestResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTestResultExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QuerySpeType() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QuerySpeTypeExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s name="玻片"
 Do OutQuerySpeType
 s name="蜡块"
 Do OutQuerySpeType
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQuerySpeType
 set Data=$lb(name)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QuerySpeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySpeTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySpeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySpeTypeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryOpeType")

Query QueryOpeType() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QueryOpeTypeExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s name="病变器官全切"
 Do OutQueryOpeType
 s name="器官部分切除"
 Do OutQueryOpeType
 s name="病灶全切"
 Do OutQueryOpeType
 s name="病灶部分切除"
 Do OutQueryOpeType
 s name="窥镜或针吸活检"
 Do OutQueryOpeType
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQueryOpeType
 set Data=$lb(name)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryOpeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOpeTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryOpeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOpeTypeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QuerySliceType() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QuerySliceTypeExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s name="HE染色"
 Do OutQuerySliceType
 s name="白片"
 Do OutQuerySliceType
 s name="分子病理染色"
 Do OutQuerySliceType
 s name="免疫组化染色"
 Do OutQuerySliceType
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQuerySliceType
 set Data=$lb(name)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QuerySliceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySliceTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySliceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySliceTypeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QuerySendHospital() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QuerySendHospitalExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s name="北京女子医院"
 Do OutQuerySendHospital
 s name="北京医院"
 Do OutQuerySendHospital
 s name="和睦家医院"
 Do OutQuerySendHospital
 s name="..."
 Do OutQuerySendHospital
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQuerySendHospital
 set Data=$lb(name)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QuerySendHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySendHospitalExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySendHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySendHospitalExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryTime() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QueryTimeExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 
 f i=0:1:23 d
 .f j=0:1:59 d
 ..Do OutQueryTime
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQueryTime
 set Data=$lb(i_":"_j)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTimeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTimeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryCareProv",787)

Query QueryCareProv(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,CareDR:%String,DocDR:%String,userCode:%String")
{
}

ClassMethod QueryCareProvExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	;s ^TempLocid=Locrowid
	Set repid=$I(^CacheTemp)
	i $g(^DHCPisGetNameSet)="" s ^DHCPisGetNameSet="Desc"
	s ind=1
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.s ssusercode=""
	.i CareProvrowid'=""  d
	..s ssuserrowid=$o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,0)) //SS_User:^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId}) 
	..i ssuserrowid'="" s ssusercode=$p(^SSU("SSUSR",ssuserrowid),"^",1)
	..i ^DHCPisGetNameSet="ID" d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",3) //CT_CareProv
	..else  d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2) //CT_CareProv
	..s DocDR = 0
	..s DocDR = $o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,DocDR)) q:(DocDR="") //SS_User:^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId}) 
 	..Do OutCareProv 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutCareProv
	set Data=$lb(CareProvDesc,CareProvrowid,DocDR,ssusercode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCareProvExecute ]
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

ClassMethod QueryCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator CYQ 2012-09-21
/// function 为会诊申请单的打印功能增加一个原病理号项目
ClassMethod GetSpecimensHZ(tmrowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(tmrowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetSpeHZByRowId(.data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

// w ##class(web.DHCPisApplicationSheet).GetSpecimens(75)

ClassMethod GetSpecimens(tmrowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(tmrowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetSpecimensByRowId(.data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

// w ##class(web.DHCPisApplicationSheet).GetStatusByRowId(4)

ClassMethod GetStatusByRowId(tmrowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	 s rowId=$g(tmrowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetStatusByRowId(.data,tmrowId)    
     s Info=$p(data,"^",1)
     s $NAMESPACE=CurrentNameSpace 
     q Info
}

// w ##class(web.DHCPisApplicationSheet).GetOrderName("430||203")

ClassMethod GetOrderName(OrderDr As %String) As %String
{
    s OrderDr=$g(OrderDr)
    s OrderRowid=$p(OrderDr,"||",1)
    s itemsub=$p(OrderDr,"||",2)
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s OrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    q OrderName
}

ClassMethod ClassMethod(OrderDr As %String) As %String
{
    s OrderDr=$g(OrderDr)
    s OrderRowid=$p(OrderDr,"||",1)
    s itemsub=$p(OrderDr,"||",2)
    b
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s OrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    q OrderName
}

// w ##class(web.DHCPisApplicationSheet).GetNameByUserCode("093")

ClassMethod GetNameByUserCode(UserCode As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
  	 s UserCode=$g(UserCode)
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s data=##class(Src.DPIS3InInterface).GetHISUserNameByCode(UserCode)
     s $NAMESPACE=CurrentNameSpace 
     q data
}

/// w ##class(web.DHCPisApplicationSheet).IsOpenFrostRpt("Z0000017",616,0)
ClassMethod IsOpenFrostRpt(pathId As %String, locdr As %String, rptcls As %String) As %String
{
	
	s pathId=$g(pathId)
	s locdr=$g(locdr)
	s rptcls=$g(rptcls)
	s date=+$h
	s time=$p($h,",",2)
	s flag=0
	
	s doRowId=0 f  s doRowId=$o(^DHCPISDiagnosisOwneri("PATH-CLS",pathId,rptcls,doRowId)) q:(doRowId="")  d
	 .q:('$d(^DHCPISDiagnosisOwner(doRowId)))
	 .s doInfo=^DHCPISDiagnosisOwner(doRowId)
	 .s doFinish=$p(doInfo,"^",6)
	 .q:(doFinish'=1)
	 .s rptRowId=0 f  s rptRowId=$o(^DHCPISReporti("DATEPATHID",locdr,date,pathId,rptRowId)) q:(rptRowId="")  d
	  ..q:('$d(^DHCPISReport(rptRowId)))
	  ..s rptInfo=^DHCPISReport(rptRowId)
 	  ..s rptClass=$p(rptInfo,"^",2)
 	  ..q:(rptClass'=rptcls)
	  ..s rptTime=$p(rptInfo,"^",8)
	  ..s test=time-rptTime
	  ..i ((test>=0)&&(test<=600)) s flag=1

	q flag
}

// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QuerySpecimenByParrefHZ",5)

/// /////////////////////////////////////////////CYQ///////////////////////////////////////////
Query QuerySpecimenByParrefHZ(TMrowid As %String) As %Query(ROWSPEC = "TSpeNum:%String,TSpePos:%String,TSpeMemo:%String,TSpeRowId:%String,TBLnum:%String")
{
}

ClassMethod QuerySpecimenByParrefHZExecute(ByRef qHandle As %Binary, TMrowid As %String) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 //s ^lff=TMrowid
 //s TMrowid=3
 s TMrowid=$p(TMrowid,$c(0))
 i TMrowid'="" d
 .s speciNo="",speciName="",speciClass="",acceptorDr="",acceptDate="",acceptTime="",XinJian=""
 .s info="",child=0,tsRowId=""
 .f  s child=$o(^DHCPISTestMaster(TMrowid,"TS",child)) q:child=""  d
 ..s info=^DHCPISTestMaster(TMrowid,"TS",child)
 ..s speciNo=$p(info,"^",1)
 ..s speciName=$p(info,"^",3)
 ..s speciMemo=$p(info,"^",6)
 ..s XinJian=$p(info,"^",8)
 ..Do OutQuerySpecimenByParrefHZ
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQuerySpecimenByParrefHZ
 //set Data=$lb(speciNo,speciName,speciClass,acceptorDr,acceptDate,acceptTime,tsRowId)
 set Data=$lb(speciNo,speciName,speciMemo,TMrowid_"||"_child,XinJian)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QuerySpecimenByParrefHZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySpecimenByParrefHZExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySpecimenByParrefHZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySpecimenByParrefHZExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 根据PAADMDR--登记号，通过登记号倒叙检索,接收科室从system_set中循环取出

// zyj修改QueryStudyByPaadmDR2012-2-9 针对合并报告时，屏蔽掉诊断为空的报告记录

// 117^^^337

// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryStudyByPaadmDR",40,"","")

Query QueryStudyByPaadmDR(EpisodeID As %String, StDate As %String, EndDate As %String) As %Query(ROWSPEC = "TRegNo:%String,Tpathid:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TLocName:%String,TreplocDr:%String,TRptCls:%String,TRptClsDesc:%String,TOpenRpt:%String,TOpenAllRpt:%String,TIsOpenFrostRpt:%String,TIfRead:%String,TReadFlag:%String,TChangeStatus:%String,TRptRowid:%String,IsdelayReport:%String,TReadFlag2:%String,Name:%String")
{
}

ClassMethod QueryStudyByPaadmDRExecute(ByRef qHandle As %Binary, EpisodeID As %String, StDate As %String, EndDate As %String) As %Status
{
	 s ^DHCSYLOOOOO=EpisodeID_","_StDate_","_EndDate
	 Set repid=$I(^CacheTemp) 
	 Set qHandle=$lb(0,repid,0)
	 s ind=1
	
	s paadmdr=$g(EpisodeID)
	i (paadmdr="") s paadmdr=%request.Get("EpisodeID")
	s StDate=$p(StDate,$c(0))
	s EndDate=$p(EndDate,$c(0))
	Set docCode=%session.Get("LOGON.USERCODE")
    s CurrentNameSpace =$ZNSPACE
	
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	.i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	.s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	.s Locdr=sysInfo.SYSDEPTCODE
	.d sysInfo.%Close()
	.q:Locdr="" 
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)      
    .s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
    .s ItemStatus="",delay="",RptRowid="",report=""
    .s tmid="" f  s tmid=$o(^DHCPISTestMasteri("IPNO",Locdr,RegNo,tmid))  q:tmid=""  d
    ..i '$d(^DHCPISTestMaster(tmid)) q
    ..s tmInfo=^DHCPISTestMaster(tmid)
    ..s oeorditemdr=$p(tmInfo,"^",32)
    ..s Name=$p(tmInfo,"^",14)
  	..q:oeorditemdr=""
  
    ..s OrderRowid=$p(oeorditemdr,"||",1),itemsub=$p(oeorditemdr,"||",2)
    ..i '$d(^OEORD(OrderRowid,"I",itemsub,1)) q
    ..s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2) 
	..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	..s rsDr=$p(tmInfo,"^",41)
	..q:rsDr=""
	..i rsDr'=""  d
	...s rsId="" s rsId=$o(^DHCPISResultStatusi("CODE",rsDr,rsId)) q:rsId=""
	...i '$d(^DHCPISResultStatus(rsId))
	...s ItemStatus=$p(^DHCPISResultStatus(rsId),"^",2)
	...i ItemStatus["迟发" s delay="迟发原因"
	..s pathid=$p(tmInfo,"^",4)
	..s LocName=$p(tmInfo,"^",28)
	..s strDate=$p(tmInfo,"^",26)
	..s $NAMESPACE=CurrentNameSpace 
	..s sysdate=##class(websys.Conversions).DateFormat()
	..d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	..i strDate'="" d
	...i sysdate=3 s strDate=$zd(strDate,3)
	...i sysdate=4 s strDate=$zd(strDate,4)
	..i ..ReportViewLog(oeorditemdr)=0 s ReadFlag2="已阅读"
	..else  s ReadFlag2=""
	..i pathid="" d
	...s RptClsDesc="报告未发布"
	...s pathid="病理科尚未登记"
	...s ReadFlag="",report="",ChangeStatus=""
	...Do OutStudy
	
	..else  i $d(^DHCPISReporti("PATHID",Locdr,tmid))   d
	...b ; else
	...s RptRowid="" f  s RptRowid=$o(^DHCPISReporti("PATHID",Locdr,tmid,RptRowid)) q:RptRowid=""  d
	....s report=""
	....s RptCls=$p(^DHCPISReport(RptRowid),"^",2)
	....i RptCls=0 s RptClsDesc="病理冰冻切片报告"
	....i RptCls=1 s RptClsDesc="病理标本检查报告"
	....i RptCls=2 s RptClsDesc="病理会诊报告"
	....i RptCls=3 s RptClsDesc="病理检查补充报告"
	....i RptCls=4 s RptClsDesc="尸体检查报告"
	....i RptCls=5 s RptClsDesc="细胞学检查报告"
	....i RptCls=6 s RptClsDesc="液基细胞学检查报告"
	....i RptCls=8 s RptClsDesc="HPV检查报告"
	....i RptCls=9 s RptClsDesc="TSPOT检查报告"
	....i RptCls=10 s RptClsDesc="EGFR基因突变检测报告"
	....i RptCls=11 s RptClsDesc="KRAS基因突变检测报告"
	....i RptCls=12 s RptClsDesc="KRAS+BRAF基因检测报告"	
	....s IsOpenFrostRpt=..IsOpenFrostRpt(pathid,Locdr,RptCls)
	....s examno=""
	....s examno=pathid_"|"_RptRowid
	....zn "dhc-app"
	....s yninfo=##class(RISService.ReadReportInfo).GetRPTCMStatus(oeorditemdr, examno, docCode)
	....zn "pis"
	....s ReadFlag=$p(yninfo,"^",1)
	....s ChangeStatus=$p(yninfo,"^",2)
	....i ReadFlag="Y" s ReadFlag="已阅读"
	....e  s ReadFlag=""
	....i ChangeStatus="Y"  s ChangeStatus="已修改"
	....e  s ChangeStatus=""	
	....s temp=""
	....s imageRowid=0 f  s imageRowid=$o(^DHCPISImageIndexi("PATHID",Locdr,tmid,imageRowid)) q:imageRowid=""  d
	.....s temp=$p(^DHCPISImageIndex(imageRowid),"^",6)
	.....i temp="IMG" s temp=""
	.....s rptid=$p(^DHCPISImageIndex(imageRowid),"^",12)
	.....q:RptRowid'=rptid
	.....s handout=$p(^DHCPISReport(RptRowid),"^",11)
	.....i ((temp [ "PDF")&(handout'="")) d
	......s report="Report"
	.....i ((temp [ "PDF")&(handout="")) d
	......s RptClsDesc="报告未发布",ReadFlag="",report=""
	.....i (temp'[ "PDF") && (temp'="")  d
	......s RptClsDesc="报告未发布",ReadFlag="",report=""	
	.....Do OutStudy
	....i (imageRowid="") &&(temp="") d
	.....s RptClsDesc="报告未发布",ReadFlag="",report=""
	.....Do OutStudy
	
	..e  d
	...s RptClsDesc="报告未发布",ReadFlag="",report=""
	...Do OutStudy
	
	 s $NAMESPACE=CurrentNameSpace  
	 Quit $$$OK
OutStudy
	set Data=$lb(RegNo,pathid,strOrderName,strDate,ItemStatus,oeorditemdr,LocName,replocdr,RptCls,RptClsDesc,report,"AllReport",IsOpenFrostRpt,"",ReadFlag,ChangeStatus,RptRowid,delay,ReadFlag2,Name)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1 	 
	quit
}

ClassMethod QueryStudyByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
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

ClassMethod QueryStudyByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCPisApplicationSheet).GetClinicSet("669")

ClassMethod GetClinicSet(LocDr As %String)
{
	
	s ResInfo=""
	s ClinicDr=0
	s ClinicDr=$o(^DHCRBCi("LocClinicSet",LocDr,ClinicDr)) q:(ClinicDr="")
	s ReportFullFil=$P(^DHCRBC("ClinicSet",ClinicDr),"^",2)
	s RhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",3)
	s RRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",4)
	s RhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",5)
	s RStuyParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",6)
	s RDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",7)
	s ImageFullFile=$P(^DHCRBC("ClinicSet",ClinicDr),"^",8)
	s IhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",9)
	s IRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",10)
	s IhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",11)
	s IStudyNoParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",12)
	s IDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",13)
	
	s ResInfo = ReportFullFil_"^"_RhasReg_"^"_RRegParam_"^"_RhasStudyNo_"^"_RStuyParam_"^"_RDelim_"^"_ImageFullFile_"^"_IhasReg_"^"_IRegParam_"^"_IhasStudyNo_"^"_IStudyNoParam_"^"_IDelim
	b //ResInfo
	q ResInfo
}

ClassMethod FrostInfo(tmRowid As %String)
{
	s tmRowid=$g(tmRowid)
	i (tmRowid="") q ""
	i '$d(^DHCPISTestMaster(tmRowid)) q ""
	s frost=$p(^DHCPISTestMaster(tmRowid),"^",1)
	q frost
}

ClassMethod GetDirRowIdbyType(Type As %String, UserId As %String, TopDr As %String)
{
	s Type=$g(Type)
	s UserId=$g(UserId)
	s TopDr=$g(TopDr)
	s Info="",memo="",RowId=""
	s Rowid=0 f  s Rowid=$o(^DHCPISDiagDiri("Type",Type,Rowid)) q:(Rowid="")  d
	.i '$d(^DHCPISDiagDir(Rowid)) q 
	.s Info=^DHCPISDiagDir(Rowid)
	.s memo=$p(Info,"^",7)
	.s topdr=$p(Info,"^",4)
	.i (TopDr="") d
	..i UserId'=memo q
	..s RowId=Rowid
	.e  d
	.i TopDr=topdr d
	..s RowId=Rowid
	q RowId
}

// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryContentByDir","","","")

Query QueryContentByDir(DirDR As %String, UserID As %String, Code As %String) As %Query(ROWSPEC = "DCRowid:%String,DCDIRDR:%String,DCCode:%String,DCName:%String,DCContent:%String,DCMemo:%String,DCType:%String")
{
}

ClassMethod QueryContentByDirExecute(ByRef qHandle As %Binary, DirDR As %String, UserID As %String, Code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s userid=$p(UserID,$c(0))
 	s Code=$g(Code)
 	
 	s DCRowid="",DCDIRDR="",DCCode="",DCName="",DCContent="",DCMemo="",DCType=""
    i DirDR'="" d
 	.s rowid=0 f  s rowid=$o(^DHCPISDiagContenti("DIRDR",DirDR,rowid)) q:(rowid="")  d
 	..i '$d(^DHCPISDiagContent(rowid)) q
 	..s DCRowid=rowid
 	..s DCDIRDR=$p(^DHCPISDiagContent(rowid),"^",1)
 	..s DCCode=$p(^DHCPISDiagContent(rowid),"^",2)
 	..s DCName=$p(^DHCPISDiagContent(rowid),"^",3)
 	..s DCType=$p(^DHCPISDiagContent(rowid),"^",4)
 	..i $g(^DHCPISDiagContent(rowid,"Content"))'="" d
 	...s DCContent =^DHCPISDiagContent(rowid,"Content") 
 	..i $g(^DHCPISDiagContent(rowid,"Memo"))'="" d
 	...s DCMemo =^DHCPISDiagContent(rowid,"Memo")
 	..q:((DCMemo'="")&(userid'="")&(DCMemo'=userid))
 	..i Code=DCCode d
    ...Do OutContentByDir
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutContentByDir
  	set Data=$lb($g(DCRowid),$g(DCDIRDR),$g(DCCode),$g(DCName),$g(DCContent),$g(DCMemo),$g(DCType))
  	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryContentByDirFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContentByDirExecute ]
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

ClassMethod QueryContentByDirClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContentByDirExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryContentByLoc","151","2")

Query QueryContentByLoc(LocDr As %String, Code As %String) As %Query(ROWSPEC = "DCRowid:%String,DCDIRDR:%String,DCCode:%String,DCName:%String,DCContent:%String,DCMemo:%String,DCType:%String")
{
}

ClassMethod QueryContentByLocExecute(ByRef qHandle As %Binary, LocDr As %String, Code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s LocDr=$p(LocDr,$c(0))
 	s Code=$g(Code)
 	
 	s DCRowid="",DCDIRDR="",DCCode="",DCName="",DCContent="",DCMemo="",DCType=""
    i LocDr'="" d
 	.s rowid=0 f  s rowid=$o(^DHCPISDiagContenti("LOC",LocDr,rowid)) q:(rowid="")  d
 	..i '$d(^DHCPISDiagContent(rowid)) q
 	..s DCRowid=rowid
 	..s DCDIRDR=$p(^DHCPISDiagContent(rowid),"^",1)
 	..s DCCode=$p(^DHCPISDiagContent(rowid),"^",2)
 	..s DCName=$p(^DHCPISDiagContent(rowid),"^",3)
 	..s DCType=$p(^DHCPISDiagContent(rowid),"^",4)
 	..i $g(^DHCPISDiagContent(rowid,"Content"))'="" d
 	...s DCContent =^DHCPISDiagContent(rowid,"Content") 
 	..i $g(^DHCPISDiagContent(rowid,"Memo"))'="" d
 	...s DCMemo =^DHCPISDiagContent(rowid,"Memo")
 	..i Code=DCCode d
    ...Do OutQueryContentByLoc
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutQueryContentByLoc
  	set Data=$lb($g(DCRowid),$g(DCDIRDR),$g(DCCode),$g(DCName),$g(DCContent),$g(DCMemo),$g(DCType))
  	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryContentByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContentByLocExecute ]
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

ClassMethod QueryContentByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContentByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLastTMID(LocDr As %String, RegNo As %String, AppDeptDr As %String)
{
 s RegNo=$g(RegNo),AppDeptDr=$g(AppDeptDr),LocDr=$g(LocDr)
 s Info=""
 i RegNo="" || AppDeptDr=""|| LocDr="" q Info
 
 s tmid="" f  s tmid=$o(^DHCPISTestMasteri("APPDATE",LocDr,+$h,tmid)) q:tmid=""  d
 .i '$d(^DHCPISTestMaster(tmid)) q
 .s tmInfo=^DHCPISTestMaster(tmid)
 .s tmAppDetpDr=$p(tmInfo,"^",29)
 .i tmAppDetpDr'=AppDeptDr q
 .s tmRegNo=$p(tmInfo,"^",33)
 .i tmRegNo'=RegNo q
 .i $p(tmInfo,"^",41)="" q
 .s Info=tmid
 q Info
}

// w ##class(web.DHCPisApplicationSheet).GetIsSatByAdmNo(457)

ClassMethod GetIsSatByAdmNo(paadmdr As %String) As %String
{
 
 	s CurrentNameSpace =$ZNSPACE
	s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	.i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    .s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	.s Locdr=sysInfo.SYSDEPTCODE
	.s $NAMESPACE=CurrentNameSpace  
	.q:Locdr=""
     s paadmdr=$g(paadmdr)
     s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Sat=##class(Src.PIS3Interface).GetIsSatByAdmNo(Locdr,paadmdr)
     s $NAMESPACE=CurrentNameSpace
     
     i Sat=0 d 
     .s Info=1
     e  d
     .s Info=0
     q Info
}

/// w ##class(web.DHCPisApplicationSheet).GetSatByAdmNo(67)
ClassMethod GetSatByAdmNo(paadmdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s paadmdr=$g(paadmdr)
	s data=""
	s Info=""
	s Sat=""
	i (paadmdr="") s paadmdr=%request.Get("EpisodeID")
	;s LocDr=$o(^CTLOC(0,"Desc","BLK病理科",""))
	s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	.i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    .s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	.s LocDr=sysInfo.SYSDEPTCODE
	.s $NAMESPACE=CurrentNameSpace  
	.q:LocDr=""
	s tmid="" f  s tmid=$o(^DHCPISTestMasteri("PAADM",LocDr,paadmdr,tmid)) q:(tmid="")  d
	.i '$d(^DHCPISTestMaster(tmid)) q
	.i Sat=0 q
	.s tmInfo=^DHCPISTestMaster(tmid)
	.s Sat=$p(tmInfo,"^",7)
	.s appDoc=$p(tmInfo,"^",30)
	.s Reason=$p(tmInfo,"^",8)
	.s exeDate=$p(tmInfo,"^",39)
	.i exeDate'="" s exeDate=$zd(exeDate,3)
	.s exeTime=$p(tmInfo,"^",40)
	.i exeTime'="" s exeTime=$zt(exeTime)
	.s exeDocDr=$p(tmInfo,"^",38) 
	.;s exeDoc=..GetUserNameBySSUserRowId(exeDocDr)
	.s exeDoc=""
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	.i exeDocDr'="" d
	..d ##class(Src.PIS3SystemInit).GetUserNameByCode(.name,LocDr_"^"_exeDocDr)
	..s exeDoc=$p(name,"^",1)
	.s orderDr=$p(tmInfo,"^",32)
	.d ##class(Src.DPIS3InInterface).GetORDERNAME(.data,orderDr) 
	.s $NAMESPACE=CurrentNameSpace 
	.s orderName=$p(data,"^",1)
	.s Info=tmid_"^"_appDoc_"^"_orderName_"^"_Reason_"^"_exeDoc_"^"_exeDate_"^"_exeTime
	q Info
}

// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryGetSatByAdmNo","^457")

/// 平台组调用拒收原因
Query QueryGetSatByAdmNo(Info As %String) As %Query(ROWSPEC = "tmid:%String,appDoc:%String,orderName:%String,Reason:%String,exeDoc:%String,exeDateTime:%String")
{
}

ClassMethod QueryGetSatByAdmNoExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 Set repid=$I(^CacheTemp) 
 Set qHandle=$lb(0,repid,0)
 s ind=1
 
 s Info=$g(Info)
 s LocDr=$p(Info,"^",1)
 s paadmdr=$p(Info,"^",2)
 i paadmdr="" s paadmdr=%request.Get("EpisodeID")
 s Sat=""
 
 s CurrentNameSpace =$ZNSPACE
 s PAPMIDR = $p(^PAADM(paadmdr),"^",1)
 s PaadmdrOne=paadmdr
 s OrderRowid=""
 s OrderRowid=$o(^OEORD(0,"Adm",PaadmdrOne,OrderRowid)) 
 q:OrderRowid=""

 s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
 .s LocDr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
 .q:(LocDr="")
 .s OrId=OrderRowid_"||"_itemsub
 .d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
 .s tmid="" f  s tmid=$o(^DHCPISTestMasteri("PAADM",LocDr,paadmdr,tmid)) q:(tmid="")  d
 ..i '$d(^DHCPISTestMaster(tmid)) q
 ..s tmInfo=^DHCPISTestMaster(tmid)
 ..s Sat=$p(tmInfo,"^",7)
 ..i Sat'=0 q
 ..s orderDr=$p(tmInfo,"^",32)
 ..s OrId=OrderRowid_"||"_itemsub
 ..i (orderDr'=OrId) q 
 ..s appDoc=$p(tmInfo,"^",30)
 ..s Reason=$p(tmInfo,"^",8)
 ..s exeDate=$p(tmInfo,"^",39)
 ..i exeDate'="" s exeDate=$zd(exeDate,3)
 ..s exeTime=$p(tmInfo,"^",40)
 ..i exeTime'="" s exeTime=$zt(exeTime)
 ..s exeDateTime=exeDate_" "_exeTime
 ..s exeDocDr=$p(tmInfo,"^",38)
 ..i exeDocDr'="" d
 ...s UsId="" s UsId=$o(^DHCPISUsersi("LOCCODE",LocDr,exeDocDr,UsId))
 ...q:UsId=""
 ...i '$d(^DHCPISUsers(UsId)) q
 ...s exeDoc=$p(^DHCPISUsers(UsId),"^",3)
 ..i orderDr'="" d
 ...d ##class(Src.DPIS3InInterface).GetORDERNAME(.data,orderDr)  
 ...s orderName=$p(data,"^",1)
 ..s $NAMESPACE=CurrentNameSpace
 ..Do OutQueryGetSatByAdmNo
 
  Quit $$$OK
OutQueryGetSatByAdmNo
 set Data=$lb(tmid,appDoc,orderName,Reason,exeDoc,exeDateTime)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryGetSatByAdmNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetSatByAdmNoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryGetSatByAdmNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetSatByAdmNoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetFrostRptByAdmNo(paadmdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s paadmdr=$g(paadmdr)
     s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Sat=##class(Src.DHCPisInterface).GetIsFrostRptByAdmNo(paadmdr)
     s $NAMESPACE=CurrentNameSpace
     
     i Sat=1 d 
     .s Info=1
     e  d
     .s Info=0
     q Info
}

/// Creator：董禄宁
/// CreatDate：2011-06-27
/// Description：电子病历的科研组接口
/// 他们本来是想要让咱们给他们写一个类方法，然后返回值是查询出来的记录数，而他们需要的记录写入到临时Global中
/// 后来跟他们谈了一下，就说服他们改成Query，但是他们要求的参数我还是都写进了Query中
/// 参数:所有参数均不为空的传入
/// Sn:科研组提供的唯一编号，用于临时Global的节点
/// RegNo:在程序中不需要判断和处理，只用于临时Global的节点
/// AdmId:病人的就诊表ID
/// DateRange:下医嘱日期范围，格式：YYYY-MM-DD 00:00:00^YYYY-MM-DD 00:00:00  （不包含最后一天）
/// ArcimRowId:ARC_ItmMast表ID
/// 返回值:
/// OrdTime:下医嘱时间，格式：YYYY-MM-DD hh:mm:dd
/// AppTime:申请时间，格式：YYYY-MM-DD hh:mm:dd
/// RegTime:登记时间，格式：YYYY-MM-DD hh:mm:dd
/// RptTime:报告时间，格式：YYYY-MM-DD hh:mm:dd
/// PathId:病理号
/// SpecialResult:特检结果，他们本来要一个检查方法，后来跟他们谈的给他们一个特检结果
/// MacroDesc:大体所见
/// MicroDesc:镜下所见
/// Diagnosis:病理诊断
/// RptClass:报告类型DR
/// Others：d ##class(web.DHCPisApplicationSheet).PISInterfaceforCSM("123456789", "08527413", "3446501", "2010-03-01 00:00:00^2011-09-01 00:00:00","108657||1")
ClassMethod PISInterfaceforCSM(Sn As %String, RegNo As %String, AdmId As %String, DateRange As %String, ArcimRowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Sn=$p(Sn,$c(0))
	s RegNo=$p(RegNo,$c(0))
	s AdmId=$p(AdmId,$c(0))
	s DateRange=$p(DateRange,$c(0))
	s ArcimRowId=$p(ArcimRowId,$c(0))
	Q:((Sn="")||(RegNo="")||(AdmId="")||(ArcimRowId="")) -901
	s startDate=$p($p(DateRange,"^",1)," ",1)
	s endDate=$p($p(DateRange,"^",2)," ",1)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)-1 //不包含最后一天，所以要-1
	
	s count=0 //查询合格记录数，暂时没用
	//根据就诊ID查oe_order表的ID
	s orderRowId=$o(^OEORD(0,"Adm",AdmId,0)) 
	f date=startDate:1:endDate  d
	 .s ordItemSub=0 f  s ordItemSub=$o(^OEORDi(0,"StDt",date,orderRowId,ordItemSub))  q:(ordItemSub="")  d
	  ..Q:('$d(^OEORD(orderRowId,"I",ordItemSub)))
	  ..s itmMastDr=$p($g(^OEORD(orderRowId,"I",ordItemSub,1)),"^",2)
	  ..q:(itmMastDr'=ArcimRowId)
	  ..s reclocdr=$p($g(^OEORD(orderRowId,"I",ordItemSub,3)),"^",6)
	  ..s OrdTime="",AppTime="",RegTime="",RptTime="",PathId=""
	  ..s SpecialResult="",MacroDesc="",MicroDesc="",Diagnosis="",RptClass=""
	  ..s ordDate=$p($g(^OEORD(orderRowId,"I",ordItemSub,1)),"^",9)
	  ..s ordTime=$p($g(^OEORD(orderRowId,"I",ordItemSub,1)),"^",10)
	  ..s ordDate=$zd(ordDate,3)
	  ..s ordTime=$zt(ordTime,1)
	  ..s OrdTime=ordDate_" "_ordTime
	  ..s ordItemRowId=orderRowId_"||"_ordItemSub
	  ..d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	  ..s tmRowId=$o(^DHCPISTestMasteri("ORDER",reclocdr,ordItemRowId,0))
	  ..Q:(tmRowId="")||('$d(^DHCPISTestMaster(tmRowId)))
	  ..s tmInfo=^DHCPISTestMaster(tmRowId)
	  ..s frost=$p(tmInfo,"^",1)
	  ..s PathId=$p(tmInfo,"^",4)
	  ..s appDate=$p(tmInfo,"^",26)
	  ..s appTime=$p(tmInfo,"^",27)
	  ..i appDate'="" s appDate=$zd(appDate,3)
	  ..i appTime'="" s appTime=$zt(appTime,1)
	  ..s AppTime=appDate_" "_appTime
	  ..s regDate=$p(tmInfo,"^",39)
	  ..Q:(regDate="")
	  ..s regTime=$p(tmInfo,"^",40)
	  ..i regDate'="" s regDate=$zd(regDate,3)
	  ..i regTime'="" s regTime=$zt(regTime,1)
	  ..s RegTime=regDate_" "_regTime
	  ..Q:(PathId="")
	  
	  ..s RptRowId=$o(^DHCPISReporti("PATHID",reclocdr,PathId,""),-1)
	  ..q:(RptRowId="")
	  ..q:('$d(^DHCPISReport(RptRowId)))
	  ..s reportInfo=^DHCPISReport(RptRowId)
	  ..s rptDate=$P(reportInfo,"^",7)
	  ..s rptTime=$P(reportInfo,"^",8)
	  ..s rptDate=$zd(rptDate,3)
	  ..s rptTime=$zt(rptTime,1)
	  ..s RptTime=rptDate_" "_rptTime
	  ..s RptClass=$P(reportInfo,"^",2)
	  ..s Diagnosis=$P(reportInfo,"^",3)
	  
	  ..s $NAMESPACE=CurrentNameSpace 

	  ..s MacroDesc=..GetSpecimenSeeingByPathID(PathId,reclocdr)
	  ..s SpecialResult=..GetSpeResultByPathID(PathId,reclocdr)
	  ..s MicroDesc=..GetRptSeeingByPathID(PathId,reclocdr,RptClass)
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"OrdTime")=OrdTime
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"AppTime")=AppTime
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"RegTime")=RegTime
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"RptTime")=RptTime
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"PathId")=PathId
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"SpecialResult")=SpecialResult
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"MacroDesc")=MacroDesc
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"MicroDesc")=MicroDesc
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"Diagnosis")=Diagnosis
	  ..s ^CacheTemp("DataExtraction",Sn,RegNo,AdmId,"PIS",ArcimRowId,RptTime,"RptClass")=RptClass
	  ..s count=count+1
	q count
}

/// 根据病理号取得大体所见的信息
ClassMethod GetSpecimenSeeingByPathID(pathid As %String, Locdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Locdr=$g(Locdr) //科室
	s PathId=$g(pathid)
	s SeeingInfo=""
    i (PathId="")||(Locdr="") q SeeingInfo
    d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    s tmRowId=0 f  s tmRowId=$o(^DHCPISTestMasteri("PATHID",Locdr,PathId,tmRowId)) q:(tmRowId="")  d
     .Q:('$d(^DHCPISTestMaster(tmRowId)))
     .s tsSub=0 f  s tsSub=$o(^DHCPISTestMaster(tmRowId,"TS",tsSub)) q:(tsSub="")  d
      ..q:'$d(^DHCPISTestMaster(tmRowId,"TS",tsSub))
      ..s tsInfo=^DHCPISTestMaster(tmRowId,"TS",tsSub)
      ..s Seeing=$p(tsInfo,"^",11)
      ..Q:(Seeing="")
      ..i SeeingInfo=""  s SeeingInfo=Seeing
      ..e  s SeeingInfo=SeeingInfo_$c(10,13)_Seeing
	s $NAMESPACE=CurrentNameSpace 

 	q SeeingInfo
}

/// 根据病理号取得镜下所见的信息
/// w ##class(PISApp.PISService).GetRptSeeingByPathID("B0000052",616,1)
ClassMethod GetRptSeeingByPathID(pathid As %String, Locdr As %String, rptCls As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Locdr=$g(Locdr) //科室
	s PathId=$g(pathid)
	s rptCls=$g(rptCls)
	s RptSeeingInfo=""
    i (PathId="")||(Locdr="")||(rptCls="") q RptSeeingInfo
    d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    s rptRowId=0 f  s rptRowId=$o(^DHCPISReporti("PATHID",Locdr,PathId,rptRowId)) Q:(rptRowId="")  d
     .Q:('$d(^DHCPISReport(rptRowId)))
     .s rptInfo=^DHCPISReport(rptRowId)
     .q:(rptCls'=$p(rptInfo,"^",2))
     .q:($p(rptInfo,"^",13)="")
     .s RptSeeingInfo=$p(rptInfo,"^",13)
    s $NAMESPACE=CurrentNameSpace
 	q RptSeeingInfo
}

/// 根据病理号取得组化结果的信息
/// w ##class(PISApp.PISService).GetSpeResultByPathID("B0664603",616)
/// w ##class(web.DHCPisApplicationSheet).GetSpeResultByPathID("B0664603",616)
ClassMethod GetSpeResultByPathID(pathid As %String, Locdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Locdr=$g(Locdr) //科室
	s PathId=$g(pathid)

	s RptSeeingInfo=""
    i (PathId="")||(Locdr="") q RptSeeingInfo
    k ^DHCPisSpeResult(PathId)
    d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    s srRowId=0 f  s srRowId=$o(^DHCPISSpecialRecordi("PATH",Locdr,PathId,srRowId)) Q:(srRowId="")  d
     .Q:('$d(^DHCPISSpecialRecord(srRowId)))
     .s srInfo=^DHCPISSpecialRecord(srRowId)
     .s siChildSub=0 f  s siChildSub=$o(^DHCPISSpecialRecord(srRowId,"SI",siChildSub)) Q:(siChildSub="")  d
      ..q:('$d(^DHCPISSpecialRecord(srRowId,"SI",siChildSub)))
      ..s siInfo=^DHCPISSpecialRecord(srRowId,"SI",siChildSub)
      ..s simark=$p(siInfo,"^",4)
      ..s sidye=$p(siInfo,"^",5)
      ..s sipieceno=$p(siInfo,"^",13)
      ..i sidye'=""  d
       ...i '$d(^DHCPisSpeResult(PathId,sipieceno))  s ^DHCPisSpeResult(PathId,sipieceno)=simark_"("_sidye_")"
       ...e  s ^DHCPisSpeResult(PathId,sipieceno)=^DHCPisSpeResult(PathId,sipieceno)_" "_simark_"("_sidye_")"
    i $g(sipieceno)=""  q RptSeeingInfo

    i ((sipieceno="-")||(sipieceno="1")) q $g(^SpeResult(PathId,sipieceno))
    s pieceno="" f  s pieceno=$o(^DHCPisSpeResult(PathId,pieceno)) q:(pieceno="")  d
    .i RptSeeingInfo=""  s RptSeeingInfo=pieceno_":"_^DHCPisSpeResult(PathId,pieceno)
    .e  s RptSeeingInfo=RptSeeingInfo_" "_pieceno_":"_^DHCPisSpeResult(PathId,pieceno)
    k ^DHCPisSpeResult(PathId)
    s $NAMESPACE=CurrentNameSpace
 	q RptSeeingInfo
}

/// 根据拼音字头获得科室名称
/// add by dln 2011-8-24
/// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryCTLocByDesc","bl")
Query QueryCTLocByDesc(desc As %String) As %Query(ROWSPEC = "CTLocDesc:%String")
{
}

ClassMethod QueryCTLocByDescExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s desc=$p(desc,$c(0))
	s desc=$ZCONVERT(desc,"U")
	s descLeng=$l(desc)
	f ctLocType="E","OP"  d
	 .s CTLocRowId=0 f  s CTLocRowId=$o(^CTLOC(0,"LocType",ctLocType,CTLocRowId)) q:(CTLocRowId="")  d
 	  ..q:('$d(^CTLOC(CTLocRowId)))
 	  ..s CTInfo=^CTLOC(CTLocRowId)
 	  ..s dateFrom=$p(CTInfo,"^",24)
 	  ..s dateTo=$p(CTInfo,"^",25)
 	  ..s date=+$h
 	  ..Q:((date<dateFrom)||((dateTo'="")&&(date>dateTo)))
 	  ..s Desc=$p(CTInfo,"^",2)
 	  ..s DescItem=$e(Desc,0,descLeng)
 	  ..Q:(DescItem'=desc)
 	  ..s CTLocDesc=$p(Desc,"-",2)
	  ..Do OutQueryCTLocByDesc
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutQueryCTLocByDesc
	set Data=$lb(CTLocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCTLocByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCTLocByDescExecute ]
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

ClassMethod QueryCTLocByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCTLocByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据拼音字头获得医生的名称
/// add by dln 2011-8-27
/// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryDocNameByDesc","bl")
Query QueryDocNameByDesc(desc As %String) As %Query(ROWSPEC = "DoctorName:%String")
{
}

ClassMethod QueryDocNameByDescExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s desc=$p(desc,$c(0))
	s desc=$ZCONVERT(desc,"U")
	s descLeng=$l(desc)

	s CTPCPRowId=0 f  s CTPCPRowId=$o(^CTPCP(CTPCPRowId)) q:(CTPCPRowId="")  d
 	 .s CTPCPInfo2=^CTPCP(CTPCPRowId,2)
 	 .s dateFrom=$p(CTPCPInfo2,"^",14)
 	 .s dateTo=$p(CTPCPInfo2,"^",15)
 	 .s date=+$h
 	 .Q:((date<dateFrom)||((dateTo'="")&&(date>dateTo)))
 	 .s CTPCPInfo3=$g(^CTPCP(CTPCPRowId,3))
 	 .s otherName=$p(CTPCPInfo3,"^",28)
 	 .s DescItem=$e(otherName,0,descLeng)
 	 .Q:(DescItem'=desc)
 	 .s CTPCPInfo1=^CTPCP(CTPCPRowId,1)
 	 .s Desc=$p(CTPCPInfo1,"^",2)
	 .Do OutQueryDocNameByDesc
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutQueryDocNameByDesc
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDocNameByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocNameByDescExecute ]
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

ClassMethod QueryDocNameByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocNameByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据科室DR得到标本字典表的内容（主要用于肿瘤医院非细胞学检查）
/// add by dln 2011-8-16
Query QueryCellSpecimen(desc As %String) As %Query(ROWSPEC = "标本名称:%String,标本数量:%String")
{
}

ClassMethod QueryCellSpecimenExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
   
	//d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryCellSpecimen","T")
	s CurrentNameSpace =$ZNSPACE
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	.i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    .s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	.s LocDr=sysInfo.SYSDEPTCODE
	.s $NAMESPACE=CurrentNameSpace  
	.q:LocDr=""
	s desc=$p(desc,$c(0))
	s desc=$ZCONVERT(desc,"U")
	s descleng=$l(desc)

 	s SPRowId=0 f  s SPRowId=$o(^DHCPISSpecimenPi("LOC",locDr,SPRowId)) q:(SPRowId="")  d
 	.q:('$d(^DHCPISSpecimenP(SPRowId)))
 	.s SPInfo=^DHCPISSpecimenP(SPRowId)
 	.s SpecimenClass=$p(SPInfo,"^",1)
 	.q:(SpecimenClass'="CellSpecimen")
 	.s SpecimenName=$p(SPInfo,"^",2)
 	.s SpecimenNum=$p(SPInfo,"^",7)
 	.Q:($e(SpecimenNum,1,descleng)'=desc)
 	.//s SpecimenPostNum=$p(SPInfo,"^",5)
	.Do OutCellSpecimen
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutCellSpecimen
	set Data=$lb(SpecimenName,SpecimenNum)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCellSpecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCellSpecimenExecute ]
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

ClassMethod QueryCellSpecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCellSpecimenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCPisApplicationSheet).GetWomenAllInfoByTmRowId(286)

ClassMethod GetWomenAllInfoByTmRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()     
     d ##class(Src.PIS3Register).GetWomanInfoByParref(.data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

ClassMethod TestWomanAddAll(tumourInfo As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s tumourInfo=$g(tumourInfo)
     s Info="" 
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).TestWomanAdd(.data,tumourInfo)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

/// w ##class(web.DHCPisApplicationSheet).InsertBLOrdItem("922","904||4","3879","167","616","12","5")
/// w ##class(web.DHCPisApplicationSheet).InsertBLOrdItem("922","1||1","3879","167","616","12","5")
ClassMethod InsertBLOrdItem(EpisodeID As %String, OEorditemID As %String, arcitemID As %String, CreateUser As %String, CreateLocDr As %String, RecLocDr As %String, OrdItemNo As %String, ChangeTypeDr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	//s ^zxhtest(1)=TMrowId_"^"_CreateUser_"^"_CreateLocDr_"^"_RecLocDr_"^"_OrdItemNo
	 s EpisodeID=$p(EpisodeID,$c(0))
	 s OEorditemID=$p(OEorditemID,$c(0))
 	 s CreateUser=$p(CreateUser,$c(0))
 	 s CreateLocDr=$p(CreateLocDr,$c(0))
 	 s RecLocDr=$p(RecLocDr,$c(0))
 	 s OrdItemNo=$p(OrdItemNo,$c(0))
 	 s ChangeTypeDr=$p(ChangeTypeDr,$c(0))
 	 s ArcitemDr=$p(arcitemID,$c(0))
 	 
     s Info=""
     
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Info=##class(Src.DHCPisInterface).InsertBLOrdItem(EpisodeID, OEorditemID, ArcitemDr, CreateUser, CreateLocDr, RecLocDr, OrdItemNo, ChangeTypeDr)
     s $NAMESPACE=CurrentNameSpace
     q Info
}

/// w ##class(web.DHCPisApplicationSheet).StopOrdItem("8||6","3879")
ClassMethod StopOrdItem(OrdItemDr As %String, UserId As %String) As %String
{
	s OrdItemDr=$p(OrdItemDr,$c(0))
	s UserId=$p(UserId,$c(0))
	q:((OrdItemDr="")||(UserId="")) -901
	s info=""
	s order=$p(OrdItemDr,"||",1)
	s ordsub=$p(OrdItemDr,"||",2)
	s sub=ordsub f  s sub=$o(^OEORD(order,"I",sub)) q:(sub="")  d
	 .s status=$p(^OEORD(order,"I",sub,1),"^",13)
	 .Q:(status="4")
	 .s payStatus=$p(^OEORD(order,"I",sub,3),"^",5)
	 .Q:(payStatus="P")
	 .s subOrdItem=$p($g(^OEORD(order,"I",sub,11)),"^",39)
	 .Q:(subOrdItem'=OrdItemDr)
	 .//s ^dlntest(order,sub)=order_"||"_sub_","_subOrdItem
 	 .s info=##class(web.DHCOEOrdItem).Stop(order_"||"_sub,UserId)
	q info
}

/// 平台通过调用DoOrdItem方法，传入检查状态是“登记”时，可以把医嘱状态变为执行
/// w ##class(web.DHCPisApplicationSheet).DoOrdItem("2109||17")
ClassMethod DoOrdItem(OrdItemDr As %String) As %String
{
	s OrdItemDr=$p(OrdItemDr,$c(0))
	q:(OrdItemDr="") -901
	s infozhu=""
	s info=""
	s statusbz="E"
	s StatusRowId=$o(^OEC("OSTAT",0,"Code",statusbz,0))
	s order=$p(OrdItemDr,"||",1)
	s ordsub=$p(OrdItemDr,"||",2)
	s Info=##class(web.DHCOEOrdItem).UpdateStatus(OrdItemDr,"",StatusRowId)
	q Info
}

/// 平台通过调DoOrdItemStop方法，当“取消检查”（已申请）时，可以把医嘱状态变为核实
/// w ##class(web.DHCPisApplicationSheet).DoOrdItemStop("")
ClassMethod DoOrdItemStop(OrdItemDr As %String) As %String
{
	s OrdItemDr=$p(OrdItemDr,$c(0))
	q:(OrdItemDr="") -901
	s infozhu=""
	s info=""
	s statusbz="V"
	s StatusRowId=$o(^OEC("OSTAT",0,"Code",statusbz,0))
	s order=$p(OrdItemDr,"||",1)
	s ordsub=$p(OrdItemDr,"||",2)
    s Info=##class(web.DHCOEOrdItem).UpdateStatus(OrdItemDr,"",StatusRowId)
	q Info
}

ClassMethod UpdateSpecimenOtherDate(info As %String, tmrowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
 	 s info=$p(info,$c(0))
 	 s tmrowId=$p(tmrowId,$c(0))
 	 
     s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Info=##class(Src.DHCPisRegister).UpdateSpecimenOtherDate(info, tmrowId) 
     s $NAMESPACE=CurrentNameSpace
     q Info
}

ClassMethod GetSpecimenOtherDate(tmrowId As %String) As %String
{
 	 s tmrowId=$p(tmrowId,$c(0))
 	 Q:(tmrowId="") -901
     s TSSub=$o(^DHCPISTestMaster(tmrowId,"TS",0))
     Q:($g(TSSub)="") -902
     s outVitroDate="",outVitroTime="",FixedDate="",FixedTime="",sendDate="",sendTime="",Info=""
     s tsInfo=^DHCPISTestMaster(tmrowId,"TS",TSSub)
     s outVitroDate=$p(tsInfo,"^",21)
     i outVitroDate'=""  s outVitroDate=$zd(outVitroDate,3)
     s outVitroTime=$p(tsInfo,"^",22)
     i outVitroTime'=""  s outVitroTime=$zt(outVitroTime,2)
     s FixedDate=$p(tsInfo,"^",23)
     i FixedDate'=""  s FixedDate=$zd(FixedDate,3)
     s FixedTime=$p(tsInfo,"^",24)
     i FixedTime'=""  s FixedTime=$zt(FixedTime,2)
     s sendDate=$p(tsInfo,"^",25)
     i sendDate'=""  s sendDate=$zd(sendDate,3)
     s sendTime=$p(tsInfo,"^",26)
     i sendTime'=""  s sendTime=$zt(sendTime,2)
     s Info=outVitroDate_"^"_outVitroTime_"^"_FixedDate_"^"_FixedTime_"^"_sendDate_"^"_sendTime
     q Info
}

/// w ##class(web.DHCPisApplicationSheet).SaveAppBill("","1289||5","14/09/2011","1919","","")
ClassMethod SaveAppBill(XMLConent As %String, OeOrditemID As %String, XDate As %String, UserID As %String, HtmlConent As %String, ItemInfo As %String, PrintParamInfo As %String = "", BodyInfo As %String = "", MutiArcItemMastId As %String = "")
{
	/*
	s ^TMP111GP=MutiArcItemMastId
	
	s AppRowid=""
	s xdate=$zdh(XDate,4)
	s FirstOrditem=$p(OeOrditemID,"@",1)
	s AppRowid=$o(^DHCRBAppOrdi(0,FirstOrditem,0)) 
	s OEordRowid=$p(FirstOrditem,"||",1)
	s ChildSub=$p(FirstOrditem,"||",2)
	s AdmId=$p(^OEORD(OEordRowid),"^",1) 

	///更新备注信息 OEORI_Remarks
	if BodyInfo'="" d
	.s count=$g(^OEORD(OEordRowid,"I",ChildSub,"REM",0))
    .i (count="") 
    ..s count=1
    .else  d
    ..s count=count+1
    .s ^OEORD(OEordRowid,"I",ChildSub,"REM",0)=count
    .s ^OEORD(OEordRowid,"I",ChildSub,"REM",count)=BodyInfo
	s RecLocDR=$p(^OEORD(OEordRowid,"I",ChildSub,3),"^",6) 
	s date=+$h
	s time=$p($h,",",2)
	
	s strHtmlConent=""
	if (HtmlConent'="")
	{
		s len=$l(HtmlConent,$c(1))
		for i=1:1:len d
		.s perline=$p(HtmlConent,$c(1),i)
		.if strHtmlConent="" d 
		..s strHtmlConent=perline
		.else  d
		..s strHtmlConent=strHtmlConent_$c(13,10)_perline
	} 
	
	if (AppRowid="")
	{
		&sql(insert into DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time, DRA_LocID_DR) values ( :FirstOrditem,:UserID,:date,:xdate,:time,:RecLocDR))
		q:SQLCODE SQLCODE
		s rowid=$p(%ROWID,$c(1))
		s ^DHCRBApp("Bill",rowid,"XMLContent")=XMLConent
		s ^DHCRBApp("Bill",rowid,"html")=strHtmlConent
		s ^DHCRBApp("Bill",rowid,"ItemInfo")=ItemInfo
		s ^DHCRBApp("Bill",rowid,"PrintParam")=PrintParamInfo
	
		
		s nums=$l(OeOrditemID,"@")
		for i=1:1:nums  d
		.s perOEOrdItemID=$p(OeOrditemID,"@",i)
        .&sql(insert into DHCRB_ApplicationBill_OrdItem (DAO_ParRef,DAO_OrdItem_DR) values (:rowid,:perOEOrdItemID))
	}
	else
	{
		&sql(update DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time,DRA_LocID_DR) values ( :FirstOrditem,:UserID,:date,:xdate,:time,:RecLocDR) where DRA_RowID=:AppRowid )
		s ^DHCRBApp("Bill",AppRowid,"XMLContent")=XMLConent
		s ^DHCRBApp("Bill",AppRowid,"html")=strHtmlConent
		s ^DHCRBApp("Bill",AppRowid,"ItemInfo")=ItemInfo
		s ^DHCRBApp("Bill",AppRowid,"PrintParam")=PrintParamInfo
		
		&sql(delete from DHCRB_ApplicationBill_OrdItem where DAO_ParRef=:AppRowid)
		
	   s nums=$l(OeOrditemID,"@")
	   for i=1:1:nums  d
	   .s perOEOrdItemID=$p(OeOrditemID,"@",i)
       .&sql(insert into DHCRB_ApplicationBill_OrdItem (DAO_ParRef,DAO_OrdItem_DR) values (:AppRowid,:perOEOrdItemID))
	}
	
   ///根据字段对应的医嘱项目的ROWID,ARCITEMMAST ROWID ,插入医嘱
   if MutiArcItemMastId '="" d
   .s count=$l(MutiArcItemMastId,"@")
   .s Orditmstr=""
   .f i=1:1:count d
   ..s ArcItemRowid=$p(MutiArcItemMastId,"@",i)
   ..i Orditmstr="" d
   ...s Orditmstr=ArcItemRowid_$c(2)_"1"
   ..else  d
   ...s Orditmstr=Orditmstr_$c(1)_ArcItemRowid_$c(2)_"1"
   ..s ret=##class(web.DHCOEOrdItem).InsertContinuousOrder(AdmId, UserID, Orditmstr)

	q SQLCODE
	*/
}

/// w ##class(web.DHCPisApplicationSheet).GetItemPrice("2||177")
ClassMethod GetItemPrice(oeorditemrowid)
{
	n (oeorditemrowid)
	q:oeorditemrowid="" ""
	s ItemPrice=""
	s OrderRowid=$p(oeorditemrowid,"||",1) 
	s itemsub=$p(oeorditemrowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)  
	s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	s instypedr=$p($g(^PAADM(paadmdr,1)),"^",7) 
	
	s Type=$p($g(^PAADM(paadmdr)),"^",2)
  	q:Type="H" OEPrice
  
	s SystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(SystemInfo,"^",15)
    if (DHCRisVersion="BJ_AZ") 
    {
	    s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemrowid,0))
	    if (regrowid'="")
	    {
		    s ItemPrice=$p($g(^DHCPACRegInfo(regrowid)),"^",18)
		    if ((ItemPrice="")!(ItemPrice=0))
		    { 
		       d ##class(web.DHCRisCommFunction).SetMedTrakNameSpace()
		       ;s ItemPrice=$$getMasterOrderFee^CHOPOrderEntry(orditemrowid) //sunyi 20091204
    		   d ##class(web.DHCRisCommFunction).SetWebsourceNameSpace()
		    }
	    }
    }
    elseif (DHCRisVersion="HRB_HYD")
    {
	  	d ##class(web.DHCRisCommFunction).SetMedTrakNameSpace()
	    s priceinfo=$$GetOrderPrice^DHCPRICE("","",arcimid,SttDate,"","","","") 
	    d ##class(web.DHCRisCommFunction).SetWebsourceNameSpace()
	    s ItemPrice=$p(priceinfo,"^",1)
    }
    else 
    {
	  	s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	  	s ItemPrice=$p(priceinfo,"^",1)
    }
	q ItemPrice
}

/// 申请单取消后，ris提取状态更新申请单左侧列表
ClassMethod RisGetPisStatus(OeordDR As %String) As %String
{
	s OeordDR=$g(OeordDR)
	i OeordDR ="" q -901
	s blflag="Y"
	s info=""
	
    s tmrowid=$o(^DHCPISTestMasteri("ORDER",LocDr,OeordDR,0))
    i tmrowid'="" d
    .s rsflag=$p(^DHCPISTestMaster(tmrowid),"^",41)
    .i rsflag="" s info=blflag_"^"_rsflag
	q info
}

/// cyq 20121022
/// w ##Class(web.DHCPisApplicationSheet).GetBingCheng("53783")
ClassMethod GetBingCheng(patID As %String) As %String
{
	s retval=-1
	s id=$g(patID)
	q:id="" retval
	s data=""
	s data=##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(id,"5508")
	q data
}

/// zyj 20121115	通用手术记录
/// w ##Class(web.DHCPisApplicationSheet).GetOperationInfoWHET("4")
ClassMethod GetOperationInfoWHET(patID As %String) As %String
{
	s retval=-1
	s id=$g(patID)
	q:id="" retval
	s data2=""
	// Create a Result object for the Sample.Person:ByName query
	Set rset = ##class(%ResultSet).%New("EPRservice.SpecialData:GetOperationInfoWHET")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set sc = rset.Execute(patID)
	// Now fetch the results
	 While (rset.Next()) {
	 For col = 1:1:columns {
	  s ColumnName=rset.GetColumnName(col)
	  //S stemp=$c(13,10)  //M中的换行
      //i (ColumnName="op1LastDiag") && (rset.GetData(col)'="")  s data1="术中诊断:"_rset.GetData(col)
      //i (ColumnName="op2LastDiag") && (rset.GetData(col)'="")  s data1="术中诊断:"_rset.GetData(col)
	  //i (ColumnName="opt1Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col),data2=data1_stemp_data2
	  //i (ColumnName="opt2Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col),data2=data1_stemp_data2
	  i (ColumnName="opt1Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col)
	  i (ColumnName="opt2Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col)
	 }
	 }
	 Do rset.Close()
	q data2
}

/// zyj 20121115	耳鼻喉科.转科手术记录
/// w ##Class(web.DHCPisApplicationSheet).GetOperInfoErBiH("50851")
ClassMethod GetOperInfoErBiH(patID As %String) As %String
{
	s retval=-1
	s id=$g(patID)
	q:id="" retval
	s data3=""
	// Create a Result object for the Sample.Person:ByName query
	Set rset = ##class(%ResultSet).%New("EPRservice.SpecialData:GetOperInfoErBiH")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set sc = rset.Execute(patID)
	// Now fetch the results
	 While (rset.Next()) {
	 For col = 1:1:columns {
	  s ColumnName=rset.GetColumnName(col)
	  //S stemp=$c(13,10)  //M中的换行
      //i (ColumnName="op1LastDiag") && (rset.GetData(col)'="")  s data1="术中诊断:"_rset.GetData(col)
      //i (ColumnName="op2LastDiag") && (rset.GetData(col)'="")  s data1="术中诊断:"_rset.GetData(col)
	  //i (ColumnName="opt1Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col),data2=data1_stemp_data2
	  //i (ColumnName="opt2Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col),data2=data1_stemp_data2
	  i (ColumnName="opt1Desc") && (rset.GetData(col)'="")  s data3="手术经过:"_rset.GetData(col)
	  i (ColumnName="opt2Desc") && (rset.GetData(col)'="")  s data3="手术经过:"_rset.GetData(col)
	 }
	 }
	 Do rset.Close()
	q data3
}

/// zyj 20121116	【入院诊断】信息
/// w ##Class(web.DHCPisApplicationSheet).GetAdmDiagnosInfo("5000")
ClassMethod GetAdmDiagnosInfo(patID As %String) As %String
{
	s retval=-1
	s id=$g(patID)
	q:id="" retval
	s data4=""
	// Create a Result object for the Sample.Person:ByName query
	Set rset = ##class(%ResultSet).%New("EPRservice.SpecialData:GetAdmDiagnosInfo")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set sc = rset.Execute(patID)
	// Now fetch the results
	 While (rset.Next()) {
	 For col = 1:1:columns {
	  s ColumnName=rset.GetColumnName(col)
	  //S stemp=$c(13,10)  //M中的换行
      //i (ColumnName="op1LastDiag") && (rset.GetData(col)'="")  s data1="术中诊断:"_rset.GetData(col)
      //i (ColumnName="op2LastDiag") && (rset.GetData(col)'="")  s data1="术中诊断:"_rset.GetData(col)
	  //i (ColumnName="opt1Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col),data2=data1_stemp_data2
	  //i (ColumnName="opt2Desc") && (rset.GetData(col)'="")  s data2="手术经过:"_rset.GetData(col),data2=data1_stemp_data2
	  //w ColumnName	$p(^PAADM(paadmdr),"^",61)
	  i (ColumnName="AdmDiagnosOne") && ($p(rset.GetData(col),"^",2)'="")  s data4=$p(rset.GetData(col),"^",2)
	  i (ColumnName="AdmDiagnosTwo") && ($p(rset.GetData(col),"^",2)'="")  s data4=$p(rset.GetData(col),"^",2)
	  i (ColumnName="AdmDiagnosThree") && ($p(rset.GetData(col),"^",2)'="")  s data4=$p(rset.GetData(col),"^",2)
	  i (ColumnName="AdmDiagnosFour") && ($p(rset.GetData(col),"^",2)'="")  s data4=$p(rset.GetData(col),"^",2)
	 }
	 }
	 Do rset.Close()
	q data4
}

/// w ##Class(web.DHCPisApplicationSheet).SaveCurrentStatus("8231||3")
ClassMethod SaveCurrentStatus(Oeorditemrowid As %String) As %String
{
   
	//Add By Qu,调用医嘱发送程序
	//if ('SQLCODE)
	//{
		set Oeorditemrowid = ##class(web.DHCENS.Util.Common).ReplaceStr(Oeorditemrowid,"@","^")
	    //do ##class(DHCENS.BC.BS.WebBCService).SendAppBill(Oeorditemrowid)
	    s data=##class(DHCENS.BC.BS.WebBCService).SendAppBill(Oeorditemrowid)
	//}
	
   q data
}

/// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryAppByAdmNo","9813446","")
/// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryAppByAdmNo","574072","160")
/// d ##class(%ResultSet).RunQuery("web.DHCPisApplicationSheet","QueryAppByAdmNo","5799412","616")
Query QueryAppByAdmNo(EpisodeID As %String, LocDr As %String) As %Query(CONTAINID = 0, ROWSPEC = "RegNo:%String,pathid:%String,appDept:%String,appDoc:%String,strOrderName:%String,appDate:%String,exeDate:%String,ItemStatus:%String,RepLocName:%String,RptClsDesc:%String,Report:%String,oeorditemdr:%String,replocdr:%String,RptCls:%String,speciamens:%String")
{
}

ClassMethod QueryAppByAdmNoExecute(ByRef qHandle As %Binary, EpisodeID As %String, LocDr As %String) As %Status
{
	s CurrentNameSpace =$ZNSPACE
	s ^DHCSYLPPPP=EpisodeID_","_LocDr
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s ^DLNTest=EpisodeID_"="_LocDr
	s EpisodeID=$g(EpisodeID)
	i (EpisodeID="") s EpisodeID=%request.Get("EpisodeID")
	s LocDr=$p(LocDr,$c(0))
	;i LocDr=""  s LocDr=$o(^CTLOC(0,"Desc","BLK病理科",""))
	i LocDr="" d
	.s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	..i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	..d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	..s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	..s LocDr=sysInfo.SYSDEPTCODE
	..s $NAMESPACE=CurrentNameSpace  
	..q:LocDr="" 
  	i (($g(EpisodeID)="")||('$d(^PAADM(EpisodeID)))) Set qHandle=$lb(0,repid,0)
    q:$g(EpisodeID)="" $$$OK

	
	s RptNum=0,strOrderName="",oeorditemdr="",RepLocName="",replocdr=""
	s papmiRowid=$P(^PAADM(EpisodeID),"^",1)
	s paadmType=$P(^PAADM(EpisodeID),"^",2)
	s paadmdr=0 f  s paadmdr=$o(^PAPERdr(papmiRowid,"ADM",paadmType,paadmdr)) q:(paadmdr="")  d
	 .s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid)) q:(OrderRowid="")  d
  	  ..s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	   ...s RegNo="",pathid="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",LocName=""
	   ...s replocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	   ...q:(replocdr="")
	   ...s ItemStatDr=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	   ...q:(ItemStatDr=4)
	   ...q:((LocDr'="")&&(replocdr'=LocDr))
	   ...i replocdr'=""  d
	   ...s RepLocName=$p(^CTLOC(replocdr),"^",2)
	   ...i RepLocName["-" s RepLocName=$p(RepLocName,"-",2)
	   ...s oeorditemdr=OrderRowid_"||"_itemsub
	   ...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	   ...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	   ...s TmRowid=0 f  s TmRowid=$o(^DHCPISTestMasteri("ORDER",LocDr,oeorditemdr,TmRowid)) q:(TmRowid="")  d
	    ....i '$d(^DHCPISTestMaster(TmRowid)) q 
	    ....zn "pis"
	    ....s tmInfo=##class(Src.DHCPisRegister).GetTestMasterByRowId(TmRowid)
 	    ....s $NAMESPACE=CurrentNameSpace
 	    ....s RegNo="",pathid="",appDept="",appDoc="",appDate="",exeDate="",ItemStatus="",RptClsDesc="",RptCls="",speciamens=""
	    ....s RegNo=$p(tmInfo,"^",33)
	    ....s pathid=$P(tmInfo,"^",4)
	    ....s child=0 f  s child=$o(^DHCPISTestMaster(TmRowid,"TS",child)) q:child=""  d
	    .....s spinfo=^DHCPISTestMaster(TmRowid,"TS",child)
 	 	.....s speciNo=$p(spinfo,"^",1)
	 	.....s speciName=$p(spinfo,"^",3)
	 	.....s speciMemo=$p(spinfo,"^",6)
	 	.....i speciMemo[";" s speciMemo=$p(speciMemo,";",1)
	 	.....i speciMemo'=""  d
 	 	......s speciamens=speciamens_speciNo_":"_speciName_"("_speciMemo_");"
 	 	.....e  d
 	 	......s speciamens=speciamens_speciNo_":"_speciName_";"	 
	    ....s appDept=$p(tmInfo,"^",28)
	    ....i appDept["-" s appDept=$p(appDept,"-",2)	
	    ....s appDoc=$p(tmInfo,"^",30)
	    ....s appDate=$p(tmInfo,"^",26)
	    ....;w appDate_","
	    ....;i appDate'="" s appDate=$zd(appDate,3)
	    ....s exeDate=$p(tmInfo,"^",39)
	    ....;w exeDate_","
	    ....;i exeDate'="" s exeDate=$zd(exeDate,3)
	    ....s ItemStatus=$P(tmInfo,"^",41)
	    ....i ItemStatus="" q
	    ....s ItemStatus=$p(ItemStatus,"~",2)
	    ....i $g(pathid)=""  Do OutQueryAppByAdmNo q //20110527最后要加一个q，否则不退出，还要继续执行
	    ....s rptrowid=$o(^DHCPISReporti("PATHID",LocDr,pathid,0))
	    ....i rptrowid=""  Do OutQueryAppByAdmNo q //20110527最后要加一个q，否则不退出，还要继续执行
	    ....s RptRowid="" f  s RptRowid=$o(^DHCPISReporti("PATHID",LocDr,pathid,RptRowid)) q:RptRowid=""  d
	     .....s RptCls=$p(^DHCPISReport(RptRowid),"^",2)
	     .....i RptCls=0 s RptClsDesc="病理冰冻切片报告"
	     .....i RptCls=1 s RptClsDesc="病理标本检查报告"
	     .....i RptCls=2 s RptClsDesc="病理会诊报告"
	     .....i RptCls=3 s RptClsDesc="病理检查补充报告"
	     .....i RptCls=4 s RptClsDesc="尸体检查报告"
	     .....i RptCls=5 s RptClsDesc="细胞学检查报告"
	     .....i RptCls=6 s RptClsDesc="体检类检查报告"
	     .....Do OutQueryAppByAdmNo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutQueryAppByAdmNo
	set Data=$lb(RegNo,pathid,appDept,appDoc,strOrderName,appDate,exeDate,ItemStatus,RepLocName,RptClsDesc,"Report",oeorditemdr,replocdr,RptCls,speciamens)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAppByAdmNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppByAdmNoExecute ]
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

ClassMethod QueryAppByAdmNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppByAdmNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCPisApplicationSheet).GetSpeType(127997)

ClassMethod GetSpeType(tmRowid As %String) As %String
{
	s tmRowid=$g(tmRowid)
	i tmRowid="" q
	s Info1=1_$C(1)_"宫颈"_"^"_2_$C(1)_"皮肤标本"
	i '$d(^DHCPISTestMaster(tmRowid,"TS",0)) q Info1
	s SpeType=$p($g(^DHCPISTestMaster(tmRowid,"TS",1)),"^",3)
	i SpeType="皮肤标本" s Info1=1_$C(1)_"皮肤标本"_"^"_2_$C(1)_"宫颈"
	i SpeType="宫颈" s Info1=1_$C(1)_"宫颈"_"^"_2_$C(1)_"皮肤标本"
	q Info1
}

ClassMethod GetSurRoomNO(tmRowid As %String) As %String
{
	s tmRowid=$g(tmRowid)
	//i tmRowid="" q
	s Info1=1_$C(1)_"1"_"^"_2_$C(1)_"2"_"^"_3_$C(1)_"3"_"^"_4_$C(1)_"4"_"^"_5_$C(1)_"5"_"^"_6_$C(1)_"6"_"^"_7_$C(1)_"7"_"^"_8_$C(1)_"8"_"^"_9_$C(1)_"9"_"^"_10_$C(1)_"10"_"^"_11_$C(1)_"11"_"^"_12_$C(1)_"12"_"^"_13_$C(1)_"13"_"^"_14_$C(1)_"14"_"^"_501_$C(1)_"501"
	q Info1
}

// w ##class(web.DHCPisApplicationSheet).SetRoomNO(3791,)

ClassMethod SetRoomNO(tmRowid As %String, RoomNO As %String) As %String
{
	s tmRowid=$g(tmRowid)
	s RoomNO=$g(RoomNO)
	q:tmRowid="" -901
	q:$d(^DHCPISTestMaster(tmRowid))=0 -902
	s $p(^DHCPISTestMaster(tmRowid),"^",52)=RoomNO
	q RoomNO
}

/// /2017-06-06
/// /临床病历长度超过700,临床病历信息存到临时global中
ClassMethod SetBLGlobal(tmRowid As %String, ClinInfo As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s tmRowid=$g(tmRowid)
	s ClinInfo=$g(ClinInfo)
	 s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Info=##class(Src.PIS3Register).SetBLGlobal(tmRowid,ClinInfo)
     s $NAMESPACE=CurrentNameSpace
     q Info
}

ClassMethod GetBLGlobal(tmRowid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s tmRowid=$g(tmRowid)
	 s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     s Info=##class(Src.PIS3Register).GetBLGlobal(tmRowid)
     s $NAMESPACE=CurrentNameSpace
     q Info
}

/// w ##Class(web.DHCPisApplicationSheet).SetHPVFlagByTmrowid(5578)
ClassMethod SetHPVFlagByTmrowid(tmRowId As %String) As %String
{
	s TmRowId=$g(tmRowId)
	s tmInfo = ""
	i '$d(^DHCPISTestMaster(TmRowId)) q 
	
	s $p(^DHCPISTestMaster(TmRowId),"^",25)="1"
	q $p(^DHCPISTestMaster(TmRowId),"^",25)
}

/// w ##Class(web.DHCPisApplicationSheet).IsHPVTCTApp("50873||918")
ClassMethod IsHPVTCTApp(orditemdr As %String) As %String
{
	
	s orditemdr=$g(orditemdr)
	q:(orditemdr="") -901
	s qInfo=""
	s OrderRowid=$p(orditemdr,"||",1) 
    s itemsub=$p(orditemdr,"||",2)
    q:'$d(^OEORD(OrderRowid)) -902
	s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) 
    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	i arcimid'="6051||1" d
	.s qInfo=0
	e  d
	.s qInfo=1
    q qInfo
}

/// 打印时候获取TCTHPV申请单中自动插入的记录的申请单号码，避免重打时候失败。
/// w ##Class(web.DHCPisApplicationSheet).GetAutoHPVAppRowId("5623")
ClassMethod GetAutoHPVAppRowId(tmrowid As %String) As %String
{
	
	s tmrowid=$g(tmrowid)
	q:(tmrowid="") -901
	s qInfo=""
	q:('$d(^DHCPISTestMaster(tmrowid)))
	s qInfo=$p(^DHCPISTestMaster(tmrowid),"^",58)
    q qInfo
}

// 得到信息是否保存标志

ClassMethod Getflag(TMrowid As %String) As %String
{
  s rowid=TMrowid
  s flag="N"
  s ret=$p($g(^DHCPISTestMaster(rowid)),"^",3)
  i (ret'="") d
  .s flag="Y"  
 
  q flag
}

// w ##Class(web.DHCPisApplicationSheet).GetRisDataExamDesc("19989")

ClassMethod GetRisDataExamDesc(EpisodeID As %String) As %String
{
   s ExamDesc="" 
   s OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
   q:OEORDRowId=""
   
   s OrdSub="" f  s OrdSub=$O(^OEORD(OEORDRowId,"I",OrdSub)) q:OrdSub=""  d
   .//医嘱项Rowid  
   .s ArcimDR=""
   .s ArcimDR=$P($G(^OEORD(OEORDRowId,"I",OrdSub,1)),"^",2)   
   .q:ArcimDR=""
   .//医嘱子类
   .s ARCIMRowid=$P(ArcimDR,"||",1)
   .s ARCIMSub=$P(ArcimDR,"||",2)  
   .s itmcatdr=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)   
   .//过滤非内镜申请医嘱
   .q:((itmcatdr'=35)&(itmcatdr'=36))   
   .s ExamDesc="",OEORIRowid=""
   .s OEORIRowid=OEORDRowId_"||"_OrdSub   
   .s ExamDesc=##class(web.DHCPisApplicationSheet).GetRisDataExamDesc1(OEORIRowid)
   .;zw ExamDesc	
   q ExamDesc
}

ClassMethod GetRisDataExamDesc1(OEORIRowId As %String) As %Status
{
	Quit:$g(OEORIRowId)="" 1

	Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORIRowId,0))
	Quit:$g(RARRowId)="" ""
	Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	//Set DRPTRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,0))
	Set DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
	
	Quit:($g(DRPTRowId)="") ""
		
	Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
	;Quit:(RisItemStatus'="5") "Error: 结果未发布" //the result is not Verify."	//未发布

	Set ExamDesc=^DHCRBStudy("Report",DRPTRowId,"ExamDescEx")  //3,检查所见

	Set ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c(13,10)_","  ")
	Set ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c_","  ")

	q ExamDesc
}

ClassMethod GetSongjianInfo(Locdr, Paadmdr, tclscode, TMrowid) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##Class(Src.PIS3Register).GetSongjianInfo(Locdr,Paadmdr,tclscode,TMrowid)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// 发送后取消申请单，记录日志表

ClassMethod Cancellog(CancelInfo As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##Class(Src.PIS3Extending).CancelLogAdd(.data,CancelInfo)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetLocDR("BLK病理科")

ClassMethod GetLocDR(LocDesc As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.DPIS3InInterface).GetLocDR(.data,LocDesc)
	s data=$p(data,"^")
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// 得到加急标志

// w ##Class(web.DHCPisApplicationSheet).GetJjFlag("12114||1")

ClassMethod GetJjFlag(Inid As %String) As %String
{
	
	s ArcimRowid=$p(Inid,"||",1)
	s child=$p(Inid,"||",2)
	s data=""
	s data=$p($g(^ARCIM(ArcimRowid,child,9)),"^",18)
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetCancelInfoByTmid(35)

ClassMethod GetCancelInfoByTmid(tmid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Info="",data=""
	s tmid=$g(tmid)
	i tmid="" s data=-901 q
	i '$d(^DHCPISTestMaster(tmid)) s data=-911 q
	
	s sexDesc="",operation=""
	s Info=^DHCPISTestMaster(tmid)
	s PatName=$p(Info,"^",14)
	s sexDr=$p(Info,"^",17)	
	i (sexDr'="") d    
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace() d ##class(Src.PIS3SystemInit).GetSexDescByCode(.data0,sexDr) s $NAMESPACE=CurrentNameSpace 
	.s sexDesc=data0	
	s birthDate=$P(Info,"^",18)
    i birthDate'="" s birthDate=$zd(birthDate,3)
    s paadm=$p(Info,"^",3)
    s appDept=$p(Info,"^",28)
    s appDocName=$p(Info,"^",30)   
    s appDate=$p(Info,"^",26)
    i appDate'="" s appDate=$zd(appDate,3)
    s specimen=$p(..GetSpecimens(tmid),"^",1)
    s diag=$p(Info,"^",24)   
    s orderDr=$p(Info,"^",32)  
    s clsDr=$p(Info,"^",11)   
    i (clsDr=10)  s operation=$p($p(Info,"^",21),$c(8730),1) 
    e  s operation=""
    s data=tmid_$c(8730)_PatName_$c(8730)_sexDesc_$c(8730)_birthDate_$c(8730)_paadm_$c(8730)_appDept_$c(8730)_appDocName
    _$c(8730)_appDate_$c(8730)_specimen_$c(8730)_operation_$c(8730)_diag_$c(8730)_orderDr_"&1"
   
    q data
}

// w ##Class(web.DHCPisApplicationSheet).GetDelayCause("87","133||92")

ClassMethod GetDelayCause(dept As %String, OrderId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Reason=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(PISApp.PISService).GetDelayCause(.data,dept,OrderId)
	s Reason=data
	s $NAMESPACE=CurrentNameSpace
	q Reason
}

// w ##Class(web.DHCPisApplicationSheet).GetMJCodeByfh()

ClassMethod GetMJCodeByfh(fh As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	 s fh=$g(fh),data=""   
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     ;s data=##Class(Src.DPIS3InInterface).GetMJCodeByfh(fh)
     s $NAMESPACE=CurrentNameSpace
     q data
}

// w ##class(web.DHCPisApplicationSheet).GetSpecimens(43)

ClassMethod GetPISLog(Info As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s Info=$g(Info),data=""
     q:Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.DPIS3InInterface).PassLogtoHIS(.data,Info)
     s $NAMESPACE=CurrentNameSpace
     q data
}

// w ##class(web.DHCPisApplicationSheet).GetDocPower(43)

ClassMethod GetDocPower(UserCode As %String) As %String
{
	//如果返回值为PRACTICE，则为实习生
     s UserCode=$g(UserCode)
     s data="",userID="",CareProvID="",CarPrvTpID="",DocPower="" 
     s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,userID))
     i userID'=""  d
     .s CareProvID=$p(^SSU("SSUSR",userID),"^",14)
     .i CareProvID'=""  d
     ..//&sql(select CTPCP_CarPrvTp_DR into :CarPrvTpID from CT_CareProv where CTPCP_RowId1=:CareProvID)
     ..i CarPrvTpID'=""  d
     ...s DocPower=$p(^CT("CPT",CarPrvTpID),"^",1)
     q DocPower
}

// w ##class(web.DHCPisApplicationSheet).GetOrderExeStatus("1058||2||1")

// 护士执行状态   OE_OrdExec-->OEC_Order_AdminStatus

ClassMethod GetOrderExeStatus(OrdItmRowId As %String) As %String
{
	s ord=+OrdItmRowId
	s itm=$p(OrdItmRowId,"||",2)
	s ore=$p(OrdItmRowId,"||",3)
	q:ord="" -1
	q:itm="" -1
	q:ore="" -1
	
	quit:'$d(^OEORD(ord,"I",itm,"X",1)) ""
	s OreStatusDr=$p(^OEORD(ord,"I",itm,"X",1),"^",16)
	q:OreStatusDr="" -11  
	s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)  
	q AdminStatus
}

/// Creator：      huhm
/// CreatDate：    200906015
/// Description:： 增加阅读结果记录
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod AddViewLog(UserId As %String, Episode As %String, PatientID As %String, OrderID As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##class(Src.DPIS3InInterface).AddViewLog(UserId,Episode,PatientID,OrderID)
	s $NAMESPACE=CurrentNameSpace
	q data
}

// 结果查看记录

ClassMethod ReportViewLog(requestId As %String) As %String
{
	//&sql(select * from websys.Log where requestID=:requestId)
	Quit SQLCODE
}

// w ##class(web.DHCPisApplicationSheet).GetPatBedNO(69)

// 查看是否安排床位

ClassMethod GetPatBedNO(paadmdr As %String) As %String
{
	
	 s paadmdr=$g(paadmdr)
     i paadmdr="" q -901
     i '$d(^PAADM(paadmdr)) q ""
     
     s beddr=$p(^PAADM(paadmdr),"^",73) 
     q beddr
}

// w ##class(web.DHCPisApplicationSheet).GetDocName("7476")

ClassMethod GetDocName(Code As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Code=$g(Code)
	s rtn=""
	s rowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code),""))
	b ;;
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	;通过code查询hisusername
	;s rtn=##class(Src.DPIS3InInterface).GetUserCodeNameBySSUserRowId(rowId)
	;通过ID查询hisusername
	d ##class(Src.DPIS3InInterface).GetUserCodeNameBySSUserRowId(.Data,Code)
	s rtn=$p(Data,"^",2)
	s $NAMESPACE=CurrentNameSpace
	q rtn
}

// w ##class(web.DHCPisApplicationSheet).GetInPatStatus(34)

// 返回不是A的话，代表住院病人出院

ClassMethod GetInPatStatus(paadmdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##class(Src.DPIS3InInterface).GetInPatStatus(paadmdr)
	s $NAMESPACE=CurrentNameSpace
	q data
}

// 得到电子病历的主诉接口

// w ##class(web.DHCPisApplicationSheet).GetHISCliBL()

ClassMethod GetHISCliBL(paadmdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
 	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##class(Src.DPIS3InInterface).GetHISCliBL(paadmdr)
	s $NAMESPACE=CurrentNameSpace
	q data
}

// 检验接口--活检申请单的传染病史

// w ##class(web.DHCPisApplicationSheet).GetTCReesultByAdmNo(14)

ClassMethod GetTCReesultByAdmNo(paadmdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
  //项目对照码--HBSAG，ANTIHCV，ANTIHIV  
  s rtn="",HBsAg="",HCV="",HIV=""
  s paadmdr=$g(paadmdr)
  d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
  s HBsAg=##Class(Src.DPIS3InInterface).GetTCReesultByAdmNo(paadmdr,"HBSAG")
  s HCV=##Class(Src.DPIS3InInterface).GetTCReesultByAdmNo(paadmdr,"ANTIHCV")
  s HIV=##Class(Src.DPIS3InInterface).GetTCReesultByAdmNo(paadmdr,"ANTIHIV")
  s $NAMESPACE=CurrentNameSpace
  s rtn=HBsAg_"^"_HCV_"^"_HIV_"^"
  ;s rtn="HBsAg"_"^"_"HCV"_"^"_"HIV"_"^"
  q rtn
}

// w ##class(web.DHCPisApplicationSheet).GetOrderNameByTmRowId("41")

ClassMethod GetOrderNameByTmRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s rowId=$g(rowId)
	s OrderDr=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).GetOrderNameByTmRowId(.data,rowId)  //2013-11-27修改
	s OrderDr=data //2013-11-27
	s $NAMESPACE=CurrentNameSpace 	
	s OrderRowid=$p(OrderDr,"||",1)	
    s itemsub=$p(OrderDr,"||",2)
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s OrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    q OrderName
}

// w ##class(web.DHCPisApplicationSheet).GetAppDepAndtclscodeByRowId(11)

ClassMethod GetAppDepAndtclscodeByRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s rowId=$g(rowId)
	s Info=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).GetAppDepAndtclscodeByRowId(.data,rowId)  //2013-11-27修改
	s Info=data //2013-11-27 
	q Info
}

// w ##class(web.DHCPisApplicationSheet).GetPaadmbyTMrowid(22)

ClassMethod GetPaadmbyTMrowid(TmRowid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s TmRowid=$g(TmRowid)
     s Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()     
     s Info=$p(^DHCPISTestMaster(TmRowid),"^",3)
     s $NAMESPACE=CurrentNameSpace    
     q Info
}

// w ##class(web.DHCPisApplicationSheet).GetChargeTypeDescByCode("")

ClassMethod GetChargeTypeDescByCode(Code As %String(MAXLEN=32767)) [ SqlProc ]
{
	s CurrentNameSpace =$ZNSPACE
	s Code=$g(Code)
	i Code="" q -901
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##Class(Src.DPIS3InInterface).GetChargeTypeDescByCode(Code)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

ClassMethod GetChaTypeDescByCode(Code As %String(MAXLEN=32767)) [ SqlProc ]
{
	s CurrentNameSpace =$ZNSPACE
	s Code=$g(Code)
	i Code="" q -901
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##Class(Src.DPIS3InInterface).GetChaTypeDescByCode(Code)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetHISUserIdByCode("BLtest")

ClassMethod GetHISUserIdByCode(UserCode As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s UserCode=$g(UserCode)
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()	
	d ##class(Src.DPIS3InInterface).GetHISUserIdByCode(.data,UserCode)	
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetHISUserNameByCode("BLtest")

ClassMethod GetHISUserNameByCode(UserCode As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s UserCode=$g(UserCode)
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##class(Src.DPIS3InInterface).GetHISUserNameByCode(UserCode)	
	s $NAMESPACE=CurrentNameSpace
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetTmInfoByOrderRowId("2698703||1")

ClassMethod GetTmInfoByOrderRowId(oeorditemid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s oeorder=$g(oeorditemid)	
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##Class(Src.DPIS3OutInterface).GetTmInfoByOrderRowId(oeorditemid)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetFrostFlag(1)

ClassMethod GetFrostFlag(tmid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s tmid=$g(tmid)	
	s data=""
	q:tmid="" data
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	i '$d(^DHCPISTestMaster(tmid)) s $NAMESPACE=CurrentNameSpace  q data
	s data=$p(^DHCPISTestMaster(tmid),"^",1)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// d ##class(web.DHCPisApplicationSheet).DelTastMasterByRowid("336||16","87","105","取消")

// OrdItmRowId：医嘱id（OE_OrdItem表的OEORI_RowId字段）、locdr：接受科室locdr（病理科）

// userRowId：撤销医嘱医生rowid（ss_user表的SSUSR_RowId字段）、clDesc：撤销原因（可为空）

ClassMethod DelTastMasterByRowid(OrdItmRowId As %String, locdr As %String, userRowId As %String, clDesc As %String)
{
   
    s CurrentNameSpace =$ZNSPACE
	s TMRowId="", SQLCODE="",tminfo="" ,rsdr=""
	s TMRowId=$o(^DHCPISTestMasteri("ORDER",locdr,OrdItmRowId,TMRowId)) q:TMRowId=""
	q:'$d(^DHCPISTestMaster(TMRowId))
	s tminfo=^DHCPISTestMaster(TMRowId)
	s rsdr=$p(tminfo,"^",41)
	q:rsdr'="1"
	TSTART
	s canInfo=##class(web.DHCPisApplicationSheet).GetCancelInfoByTmid(TMRowId)
	s UserName=$p(^SSU("SSUSR",userRowId),"^",2)
	s UserCode=$p(^SSU("SSUSR",userRowId),"^",1)
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Extending).CancelLogAdd(.data,"^^"_UserName_"^"_UserCode_"^"_clDesc_"^"_canInfo_"^"_TMrowid_"^"_locdr)
	d ##class(Src.PIS3Register).TestMasterDel(.SQLCODE,TMRowId)
	if data'=0{
		w "更新日志成功!"
	}
	 
	else{
		w "更新日志失败!"  TRollback
	}
	if SQLCODE=0{
		w "删除成功!"
	}
	else{
		w "删除失败!"     TRollback
	}
	s $NAMESPACE=CurrentNameSpace
	TCOMMIT
}

// w ##class(web.DHCPisApplicationSheet).GetHosptialDesc(87)

ClassMethod GetHosptialDesc(locdr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s locdr=$g(locdr)	
	s data="",data1=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	//s data=##Class(Src.DPIS3InInterface).GetHosptialDesc(locdr)
	d ##Class(Src.DPIS3InInterface).GetHosptialDesc(.data1,locdr)
	s data=data1
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetSpecimenCondByRowId("")

ClassMethod GetSpecimenCondByRowId(tmid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s tmid=$g(tmid)	
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).GetSpecimenCondByRowId(.data,tmid)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// 

// w ##class(web.DHCPisApplicationSheet).UpdateSpecimenCond(289)

ClassMethod UpdateSpecimenCond(Info As %String, tmid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s tmid=$g(tmid),Info=$g(Info)	
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).UpdateSpecimenCond(.data,Info,tmid)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).CancelLogAdd(289)

ClassMethod CancelLogAdd(Info As %String, tmid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s tmid=$g(tmid),Info=$g(Info)	
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()	
	d ##class(Src.PIS3Extending).CancelLogAdd(.data,"^^"_UserName_"^"_UserCode_"^"_clDesc_"^"_canInfo_"^"_TMrowid_"^"_Locdr)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetTmLocdr(16)

// 取test_master表接收科室

ClassMethod GetTmLocdr(tmid As %String) As %String
{
	s data=""
	q:tmid="" data
	q:'$d(^DHCPISTestMaster(tmid)) data
	s data=$p(^DHCPISTestMaster(tmid),"^",57)
	q data
}

// 得到医嘱项ARC_ITMMAST的ARCIM_CODE

// w ##class(web.DHCPisApplicationSheet).GetAppItemCode("12114||1")

ClassMethod GetAppItemCode(ArcItemRowid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s ArcItemRowid=$g(ArcItemRowid)	
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##class(Src.DPIS3InInterface).GetAppItemCode(ArcItemRowid)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// 判断检查类别表中科室是否存在,DHCPIS_CLASS_DICT

// w ##class(web.DHCPisApplicationSheet).DeptIsExist(87,10)

ClassMethod DeptIsExist(Locdr As %String, tclscode As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
 	s clsId="0",Locdr=$g(Locdr)
 	q:Locdr="" clsId
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    s clsId=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,clsId))
	s $NAMESPACE=CurrentNameSpace 
    q:clsId="" "0"
	q clsId
}

// w ##class(web.DHCPisApplicationSheet).UpdateLinkOrd("430||173","430||174")

// 关联医嘱

ClassMethod UpdateLinkOrd(MasterOrdID As %String, SubOrdID As %String) As %String
{
	s MasterOrdID=$g(MasterOrdID)
	s SubOrdID=$g(SubOrdID)
	//&sql(UPDATE sqlUser.OE_OrdItem (OEORI_OEORI_DR) values (:MasterOrdID) where OEORI_RowId=:SubOrdID)
	q SQLCODE
}

// w ##class(web.DHCPisApplicationSheet).GetinibyLocdr(87,"12814||1")

// 关联医嘱开关，INID_BAK中设置，为1表示开启，否则表示关闭

ClassMethod GetinibyLocdr(Locdr As %String, Inid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s bank="",data=0
	q:'$d(^DHCPISIniDicti)
 	s rowid="" f  s rowid=$o(^DHCPISIniDicti("LOC",Locdr,rowid))  q:rowid=""  d
 	.s Inidvalue=$p(^DHCPISIniDict(rowid),"^",4)
 	.i Inid=Inidvalue  d
 	..s bank=$p(^DHCPISIniDict(rowid),"^",5)
 	..i bank=1 d
 	...s data=1
 	s $NAMESPACE=CurrentNameSpace
 	q data
}

// w ##class(web.DHCPisApplicationSheet).GetSpeNum1("17")

// 得到标本数量--活检

ClassMethod GetSpeNum1(TMrowid As %String) As %String
{
      s sum=0  
      s num=0 f  s num=$o(^DHCPISTestMaster(TMrowid,"TS",num)) q:num=""  d
	 .s spexplain=$p(^DHCPISTestMaster(TMrowid,"TS",num),"^",6)
	 .s speno=$p(spexplain,"~",1)
	 .s sum=sum+speno
	 q sum
}

// DHCPIS_TEST_MOLECULAR分子病理表，保存信息

// w ##class(web.DHCPisApplicationSheet).TestMolecularAdd()

ClassMethod TestMolecularAdd(MolecularInfo As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Fzbl).TestMolecularAdd(.data,MolecularInfo)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

ClassMethod UpdateMolecularInfo(MolecularInfo As %String, id As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Fzbl).UpdateMolecularInfo(.data,MolecularInfo,id)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetMolecularInfoByParref(1)

ClassMethod GetMolecularInfoByParref(TMrowid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""	
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Fzbl).GetMolecularInfoByParref(.data,TMrowid)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetCharegByHISCode(9903)

ClassMethod GetCharegByHISCode(GCharegetypeDR As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s ^DHCSYLGCharegetypeDR=GCharegetypeDR
	i GCharegetypeDR="" q
		
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s dataCharge=""
	d ##class(Src.DPIS3OutInterface).GetCharegByHISCode(.dataCharge,GCharegetypeDR)
	s $NAMESPACE=CurrentNameSpace 
	q dataCharge
}

// w ##class(web.DHCPisApplicationSheet).GetSpecimensinfo(75)

/// /护理组通过申请单号取标本信息20160728
ClassMethod GetSpecimensinfo(tmrowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(tmrowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetSpecimensinfoByRowId(.data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

// 在printBarCode.js中调用的方法增加

// w ##class(web.DHCPisApplicationSheet).GetOrderIDByTmRowId("3")

ClassMethod GetOrderIDByTmRowId(rowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s rowId=$g(rowId)
	s OrderDr="",OrderID=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).GetOrderNameByTmRowId(.data,rowId)  //2013-11-27修改
	s OrderDr=data //2013-11-27
	s $NAMESPACE=CurrentNameSpace 
	i OrderDr'="" d	
    .//&sql(select OEORE_RowId into :OrderID from oe_ordexec where OEORE_OEORI_ParRef=:OrderDr)
    //select * from oe_ordexec WHERE OEORE_OEORI_ParRef="432||61"
    //门诊没有执行记录
    i OrderID="" s OrderID=OrderDr_"||1"
    q OrderID
}

// syl新增护理组打印条码调用方法20170206

// w ##class(web.DHCPisApplicationSheet).GetSpecInfo(75)

ClassMethod GetSpecInfo(tmrowId As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
     s rowId=$g(tmrowId)
     s Info=""
     s data=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.PIS3Register).GetSpecInfoByRowId(.data,rowId)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

// ------------------------------------开始-SYL标本交接类方法增加区域请勿在此区域CRUD方法-------------------------------------

ClassMethod UpdateTmOurINfo(tumourInfo As %String, tmid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Data=""
	s tumourInfo=$g(tumourInfo)
	s tmid=$g(tmid)
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).UpdateTmOurINfo(.Data,tumourInfo,tmid)
	s Info=Data	
	s $NAMESPACE=CurrentNameSpace
	q Info
}

// w ##class(web.DHCPisApplicationSheet).UpdateResult1(86)

ClassMethod UpdateResult1(tmrowid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
    s tmrowid=$g(tmrowid)
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).UpdateResult1(.sqlcode,tmrowid)	
	s $NAMESPACE=CurrentNameSpace
	q sqlcode
}

ClassMethod GetSpeNums(speid As %String) As %String
{
	s speid=$g(speid)
	s tmrowid=$p(speid,"||",1)
	s num=$p(speid,"||",2)
	q:tmrowid="" -901
	s rtn="",count=""
	;q:'$d(^DHCPISTestMaster(tmrowid)) -902
	;s num=0 f  s num=$o(^DHCPISTestMaster(tmrowid,"TS",num)) q:num=""  d
	s info=^DHCPISTestMaster(tmrowid,"TS",num)
	s num=$P($p(info,"^",6),"~",1)
	s count=count+num
	q count
}

// w ##class(web.DHCPisApplicationSheet).GetSysDeptByLocDr("16")

ClassMethod GetSysDeptByLocDr(LocDr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3SystemInit).GeSystemByDeptcode(.data,LocDr)
	s test=data
	s data=$p(test,"^",4)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetSexDescByCode("F")

ClassMethod GetSexDescByCode(sexDr As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3SystemInit).GetSexDescByCode(.data,sexDr)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).GetSexDescByCode("F")

ClassMethod UpdateClassDR(classdr As %String, TMrowid As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.PIS3Register).UpdateClassDR(.data,classdr,TMrowid)
	s $NAMESPACE=CurrentNameSpace 
	q data
}

// w ##class(web.DHCPisApplicationSheet).ModifyHuGong("71||1",27,"insurse","s")

// 修改交接护工

ClassMethod ModifyHuGong(tmidStr As %String, AppLocDr As %String, Doc As %String, NewHG As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s tmidStr=$g(tmidStr)
	f i=1:1:$l(tmidStr,"#") d	
	.s tSpeID=$p(tmidStr,"#",i)
	.s tmid=$p(tSpeID,"||",1)	
	.s child=$p(tSpeID,"||",2)
	.s data=""	
	.s VrId=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)
	.q:VrId=""
	.i '$d(^DHCPISVerifyRecord(VrId)) q
	.s vrInfo=^DHCPISVerifyRecord(VrId)
	.s ProDoc=$p(vrInfo,"^",5)
	.s HGong=$p(vrInfo,"^",6)
	.s mType="11"
	.s mOldId=VrId
	.s mDocDr=Doc
	.s mOldHG=HGong
	.s mNewHG=NewHG
	.s mLocDr=AppLocDr
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()	
	.d ##class(Src.PIS3Cutting).UpdateVerDoc(.data,ProDoc,NewHG,VrId)
	.d ##class(Src.PIS3SystemInit).GetUserNameByCode(.data,AppLocDr_"^"_Doc)	
	.s mDoc=$p(data,"^")
	.d ##class(Src.PIS3Extending).ModifyLogAdd(.data,mType_"^"_mOldId_"^^^^"_mDocDr_"^"_mDoc_"^"_mOldHG_"^"_mNewHG_"^^"_mLocDr)
	.s $NAMESPACE=CurrentNameSpace
	q data
}

// 11--"病理科取消交接",0/""

// w ##class(web.DHCPisApplicationSheet).CancelHandSpe("70||2",87,374)

/// //////////////////////
ClassMethod CancelHandSpe(tmidStr As %String, AppLocDr As %String, Doc As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s ^SYLDHCCTEST=tmidStr_","_AppLocDr_","_Doc
	s tmidStr=$g(tmidStr)
	s AppLocDr=$g(AppLocDr)
	s Doc=$g(Doc)
	f i=1:1:$l(tmidStr,"#") d	
	.s tSpeID=$p(tmidStr,"#",i)
	.s tmid=$p(tSpeID,"||",1)	
	.s child=$p(tSpeID,"||",2)
	.s VrId1="",vrId2="",data="",Locdr="",data1=""
	.q:'$d(^DHCPISTestMaster(tmid))
	.s SpeRecLoc=$p(^DHCPISTestMaster(tmid),"^",22)    		
	.q:SpeRecLoc=""	
	.s Locdr=$p(^DHCPISTestMaster(tmid),"^",57) 	
	.s VrId1=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)
	.s VrId2=$p(^DHCPISTestMaster(tmid,"TS",child),"^",13)
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
   	.i (SpeRecLoc'="")&&(AppLocDr=SpeRecLoc) d  //手术室
   	..i VrId2'="" s data1="11" q
   	..d ##class(Src.PIS3Register).UpdateTSSeeingFirst(.data,tSpeID_"^"_"")   	
   	..d ##class(Src.PIS3SystemInit).GetUserNameByCode(.data,AppLocDr_"^"_Doc)  
   	..s DocName=$p(data,"^")  
   	..d ##class(Src.PIS3Extending).CancelLogAdd(.data,"^^"_DocName_"^"_Doc_"^^"_tSpeID_"&0"_"^"_tSpeID_"^"_AppLocDr)
   	
    .else  i (SpeRecLoc'="")&&(AppLocDr'=SpeRecLoc) d  //病理科  
   	..d ##class(Src.PIS3Register).UpdateTSSeeingTwo(.data,tSpeID_"^"_"") 
   	..d ##class(Src.PIS3SystemInit).GetUserNameByCode(.data,AppLocDr_"^"_Doc)  
   	..s DocName=$p(data,"^")    
   	..d ##class(Src.PIS3Extending).CancelLogAdd(.data,"^^"_DocName_"^"_Doc_"^^"_tSpeID_"&0"_"^"_tSpeID_"^"_AppLocDr)
   	.s $NAMESPACE=CurrentNameSpace 	
	q data1
}

/// //////////////////////
ClassMethod BLKCancelHandSpe(tmidStr As %String, AppLocDr As %String, Doc As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s ^SYLDHCCTEST=tmidStr_","_AppLocDr_","_Doc
	s tmidStr=$g(tmidStr)
	s AppLocDr=$g(AppLocDr)
	s Doc=$g(Doc)
	f i=1:1:$l(tmidStr,"#") d	
	.s tSpeID=$p(tmidStr,"#",i)
	.s tmid=$p(tSpeID,"||",1)	
	.s child=$p(tSpeID,"||",2)
	.s VrId1="",vrId2="",data="",Locdr="",data1=""
	.q:'$d(^DHCPISTestMaster(tmid))
	.s SpeRecLoc=$p(^DHCPISTestMaster(tmid),"^",22)    		
	.q:SpeRecLoc=""	
	.s Locdr=$p(^DHCPISTestMaster(tmid),"^",57) 	
	.s VrId1=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)
	.s VrId2=$p(^DHCPISTestMaster(tmid,"TS",child),"^",13)
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
   	.i (SpeRecLoc'="")&&(AppLocDr=SpeRecLoc) d  //手术室
   	..i VrId2'="" s data1="11" q
   	..d ##class(Src.PIS3Register).UpdateTSSeeingFirst(.data,tSpeID_"^"_"")   	
   	..d ##class(Src.PIS3SystemInit).GetUserNameByCode(.data,AppLocDr_"^"_Doc)  
   	..s DocName=$p(data,"^")  
   	..d ##class(Src.PIS3Extending).CancelLogAdd(.data,"^^"_DocName_"^"_Doc_"^^"_tSpeID_"&0"_"^"_tSpeID_"^"_AppLocDr)
   	
    .else  i (SpeRecLoc'="")&&(AppLocDr'=SpeRecLoc) d  //病理科  
   	..d ##class(Src.PIS3Register).UpdateTSSeeingTwo(.data,tSpeID_"^"_"")
   	..d ##class(Src.PIS3Register).UpdateTSSeeingFirst(.data,tSpeID_"^"_"")  
   	..d ##class(Src.PIS3SystemInit).GetUserNameByCode(.data,AppLocDr_"^"_Doc)  
   	..s DocName=$p(data,"^")    
   	..d ##class(Src.PIS3Extending).CancelLogAdd(.data,"^^"_DocName_"^"_Doc_"^^"_tSpeID_"&0"_"^"_tSpeID_"^"_AppLocDr)
   	.s $NAMESPACE=CurrentNameSpace 	
	q data1
}

// ------------------------------------结束-SYL标本交接类方法增加区域请勿在此区域CRUD方法-------------------------------------

// 新版申请单接口

// w ##class(web.DHCPisApplicationSheet).GetHisAppbyOrderID("6635||3")

// w ##class(web.DHCPisApplicationSheet).GetHisAppbyOrderID("213||36")

ClassMethod GetHisAppbyOrderID(tinfo As %String)
{
	s Data=""
	;q "0^6791^LIV^袁茂勋^1^1989-06-24^内分泌门诊「医生01「2018-02-06「2018-02-06「14:09:00「2018-02-06「16:09:00「放大「√√^收费的^1.轻度酒精中毒\t(11)^2018-02-06^15:09^内分泌门诊^^医生01^^0000009752^^^1^345^6635||3^^15144553377^^N^无*「*1^试试^4~^*「**「*@@*「*,,,N,,N,N,*「*,,,,N"
	s orderID=$g(tinfo)
	i orderID="" q 100
	s HISorder="<Request>""<CardNO>"_orderID_"</CardNO>""<CardType>"_"1"_"</CardType>""</Request>"
	
	;s AppInfo=##Class(web.DHCENS.STBLL.PIS.METHOD.PISHISService).PISGetAPPInfo(HISorder)
	s AppInfo= ##Class(web.DHCAPPPisToPisService).GetPisSysStream(HISorder) 
	i AppInfo="" q 100
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(AppInfo)
	;Do reader.Correlate("Response","web.DHCENS.STBLL.PIS.MODEL.PISAPPMainInfo")
	Do reader.Correlate("Response","web.DHCAPPPisReqModel")
	Set TMROWID="",TMNEEDFROST="0",TMCLASSDR="10"
	set TMNAME="",TMSEXDR="",TMBIRTHDATE="",TMCLINICRECORD="",TMOPERATIONRESULT="",TMRELEVANTCLINICDIAG=""	
	SET TMAPPLICATIONDATE="",TMAPPLICATIONDEPT="",TMAPPLICATIONDOCTOR="",TMPAADMDR="",TMPRIORITYINDICATOR=""
    set TMIPNO="",TMADMNO="",TMBEDNO="",TMRSDR="1",TMLOCDR="",TMBINGQU="",TMTEL="",TMADRESS=""
    set TSROWID="",TSSPECIMENNO="",TSTMPARREF="",TSCHILDSUB="",TSSPECIMENNAME="",TSSPECIMENEXPLAIN="",TSSPECIMENACCEPTDATE=""
    Set TSLTDate="",TSLTtime="",TSFIXEDDate="",TSFIXEDtime=""
    set TSOLDPATHID="",TMSJHospital="",TMSJdocName="",TMOldDiag="",TMSOther=""
    set tmInfo="",tsInfo="",billInfo=""
    Set OrderDr="",TMCRBS="",TMCutLoc="",TMCutDoc="",TMCUTDATE="",TMCUTTIME="",TMTUMOURINFO="",TMWOMANINFO=""
    Set HPVZLDate="",HPVJCMethod="",HPVTreatMent="",OrderStatus=""
    Set ECdocName="",TSepDate="",TFixDate="",TMAge="",TMChargeType=""
    s OrderRowid=$p(orderID,"||",1)  ;医嘱rowid
 	s itemsub=$p(orderID,"||",2) ;子医嘱号 
 	i '$d(^OEORD(OrderRowid,"I",itemsub,3)) q
 	s Locdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6) ;申请所到的科室
 	s TMLOCDR=Locdr
    ;s ObjList=##class(web.DHCENS.STBLL.PIS.MODEL.PISAPPMainInfo).%New()
    s ObjList=##class(web.DHCAPPPisReqModel).%New()
	While reader.Next(.obj,.sc) {
		    s ObjList=obj
		    set OrderStatus=ObjList.PisNoStatus
			Set TMNEEDFROST=ObjList.IsFrozen
			Set TMNAME=ObjList.Name
			Set TMSEXDR=ObjList.SexCode
			Set TMBIRTHDATE=ObjList.BirthDay
			Set TMCLINICRECORD=ObjList.ClinicInfo   //临床病历
			Set TMTEL=ObjList.Telephone
			Set TMADRESS=ObjList.Address
			Set TMPRIORITYINDICATOR=ObjList.IsUrgent
			Set TMOPERATIONRESULT=ObjList.OperationInfo
			Set TMRELEVANTCLINICDIAG=ObjList.ClinicalDiagnosis
			Set TMAPPLICATIONDATE=ObjList.OrdDate
			Set TMAPPLICATIONTIME=ObjList.OrdTime
			Set TMTUMOURINFO=ObjList.TumorInfo
			Set TMWOMANINFO=ObjList.GynecologyInfo
			Set TMAPPLICATIONDEPT=ObjList.OrdDeptCode    //申请科室
			;Set TMAPPLICATIONDEPTDR=ObjList.OrdDeptCode
			set TMAPPLICATIONDEPTDR=""
			Set TMAPPLICATIONDOCTOR=ObjList.OrdDoctorName
			Set TMAPPLICATIONDOCTORDR=ObjList.OrdDoctorCode
			Set TMIPNO=ObjList.RegNo
			Set TMADMNO=ObjList.DocumentID
			Set TMBEDNO=ObjList.PatBedNO
			Set TMBINGQU=ObjList.PatWardCode
			Set TMPAADMDR=ObjList.AdmRowID
		
			Set TMCLASSDR=ObjList.ExamType
			Set TMSJHospital=ObjList.OrdHospital
			Set TMSJdocName=ObjList.TraDoctorCode
			Set TMOldDiag=ObjList.GeneralSpecExamination
			Set ECdocName=ObjList.ConsultationDoctor
			Set TMSOther=ObjList.ConsultationRequirements
			
			
			Set HPVZLDate=ObjList.HumanPapillomavirusDateTime
			Set HPVJCMethod=ObjList.TestMethod
			Set HPVTreatMent=ObjList.Treatment
			Set TMCRBS=ObjList.InfectionInfo  //传染病史
			;Set TMCRBS=$tr(TMCRBS,"^","√")
			Set TMCutLoc=ObjList.SamplingDeptCode  
			Set TMCutDoc=ObjList.SamplingDoctorCode
			Set TMCUTDATE=ObjList.SamplingDateTime
			i ObjList.SpecOffDateTime[" " d
			.Set TSLTDate=$p(ObjList.SpecOffDateTime," ",1)
			.Set TSLTtime=$p(ObjList.SpecOffDateTime," ",2)
			i ObjList.SpecFixedDateTime[" " d
			.Set TSFIXEDDate=$p(ObjList.SpecFixedDateTime," ",1)
			.Set TSFIXEDtime=$p(ObjList.SpecFixedDateTime," ",2)
			Set OtherInfo=TMSJdocName
			Set TMAge=ObjList.Age
			Set TMChargeType=ObjList.FeeType
			Set HPVInfo=HPVZLDate_"√"_HPVJCMethod_"√"_HPVTreatMent
			Set LCBLInfo=TMCutLoc_"「"_TMCutDoc_"「"_TMCUTDATE_"「"_TSLTDate_"「"_TSLTtime_"「"_TSFIXEDDate_"「"_TSFIXEDtime
			Set TMCLINICRECORD=LCBLInfo_"「"_TMCLINICRECORD_"「"_HPVInfo_"「"_OtherInfo
			
			Set TMORDERDR=orderID

			s len=ObjList.SpecInfo.Count()
			f i=1:1:len d
			.Set TSSPECIMENNO=ObjList.SpecInfo.GetAt(i).SpecNO
			.Set TSSPECIMENNAME=ObjList.SpecInfo.GetAt(i).SpecPosition
			.Set TSSPECIMENEXPLAIN=ObjList.SpecInfo.GetAt(i).SpecQty_"~"_ObjList.SpecInfo.GetAt(i).Note
			.Set TSOLDPATHID=ObjList.SpecInfo.GetAt(i).OriginalNO
			.i len>6 d
			..Set TSepDate=ObjList.SpecInfo.GetAt(i).SepDate
			..Set TFixDate=ObjList.SpecInfo.GetAt(i).FixDate
			.i tsInfo="" d
			..set tsInfo=TSSPECIMENNO_"^"_TSSPECIMENNAME_"^"_TSSPECIMENEXPLAIN_"^"_TSOLDPATHID_"^"_TSepDate_"^"_TFixDate
			.e  d
			..set tsInfo=tsInfo_"@"_TSSPECIMENNO_"^"_TSSPECIMENNAME_"^"_TSSPECIMENEXPLAIN_"^"_TSOLDPATHID_"^"_TSepDate_"^"_TFixDate
			
			/*
			s len=ObjList.OrdInfo.Count()
			f i=1:1:len d
			.Set OrderDr=ObjList.OrdInfo.GetAt(i).OrdRowID
			
			.i billInfo="" d
			..set billInfo=OrderDr
			.e  d
			..set billInfo=billInfo_"@"_OrderDr
			*/
			
			s EcInfo=ECdocName_"@"_TMSJHospital_"@"_TMOldDiag_"@"_TMSOther
		
			set tmInfo=TMNEEDFROST_"^"_TMPAADMDR_"^"_TMCLASSDR_"^"_TMNAME_"^"_TMSEXDR_"^"_
			TMBIRTHDATE_"^"_TMCLINICRECORD_"^"_TMOPERATIONRESULT_"^"_TMRELEVANTCLINICDIAG_"^"_TMAPPLICATIONDATE_"^"_TMAPPLICATIONTIME
			_"^"_TMAPPLICATIONDEPT_"^"_TMAPPLICATIONDEPTDR_"^"_TMAPPLICATIONDOCTOR_"^"_TMAPPLICATIONDOCTORDR
			_"^"_TMIPNO_"^"_TMADMNO_"^"_TMBEDNO_"^"_TMRSDR_"^"_TMLOCDR_"^"_TMORDERDR_"^"_TMBINGQU_"^"_TMTEL_"^"_TMADRESS_"^"_TMPRIORITYINDICATOR_"^"_TMCRBS
			_"^"_TMAge_"^"_TMChargeType
			
           s Data=tmInfo_"*「*"_tsInfo_"*「*"_""_"*「*"_EcInfo_"*「*"_TMTUMOURINFO_"*「*"_TMWOMANINFO_"*「*"_OrderStatus
           
		
	}
	do reader.Close()
	
    q Data
}

// w ##class(web.DHCPisApplicationSheet).getrptUrl("87^164||356")

/// 暂时不用
ClassMethod getrptUrl(tinfo As %String) [ SqlProc ]
{
	s url=""
	s tinfo=$g(tinfo)
	i tinfo="" q url
	s dept=$p(tinfo,"^",1)
	s orderID=$p(tinfo,"^",2)
	
	i ((dept="")||(orderID="")) q
	s tmid=$o(^DHCPISTestMasteri("ORDER",dept,orderID,""))
	i tmid="" q
	i '$d(^DHCPISTestMaster(tmid)) q
	s patID=$p(^DHCPISTestMaster(tmid),"^",33)
	
	s url="http://172.19.19.59/pisLogin/RptForOtherLoc.aspx?dept="_dept_"&&patID="_patID_"&&OrderID="_orderID_"&&Rpt"=_Ind
	q url
}

// w ##class(web.DHCPisApplicationSheet).getRptCount("87^164||356")

/// 入参：科室Code，医嘱号
/// 获取病理报告总数
ClassMethod getRptCount(tinfo As %String) [ SqlProc ]
{
	s CurrentNameSpace =$ZNSPACE
	s ret=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	d ##class(Src.DPIS3InInterface).SendRptCountToHis(.ret,tinfo)
	s $NAMESPACE=CurrentNameSpace
	q ret
}

// w ##class(web.DHCPisApplicationSheet).GetIsDiagDoc("66||34","337")

/// 调用郎家看报告程序，获取是否主治医生
ClassMethod GetIsDiagDoc(oeorder As %String, doctor As %String) As %String
{
	s ^TMP0423=oeorder_"^"_doctor
	 s oeorder=$g(oeorder)
	 s Info=""
     s oeordId=$p(oeorder,"||",1),oeoriSub=$p(oeorder,"||",2)
     i oeordId="" q "N"
     s Info=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",11)
     i Info'=doctor q "N"
     q "Y"
}

// w ##class(web.DHCPisApplicationSheet).getpatInfobyOrder("66||34")

/// 通过医嘱ID，获取医嘱的接受科室和病人ID
ClassMethod getpatInfobyOrder(oeorder As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s Locdr="",RegNo=""
 	s OrderRowid=$p(oeorder,"||",1)  ;医嘱rowid
 	s itemsub=$p(oeorder,"||",2) ;子医嘱号 
	i '$d(^OEORD(OrderRowid,"I",itemsub,3)) q ""
 	s Locdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6) ;申请所到的科室
 	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
 	s tmid=$o(^DHCPISTestMasteri("ORDER",Locdr,oeorder,0))
 	i tmid'="" d
 	.s tmInfo=^DHCPISTestMaster(tmid)
 	.s RegNo=$p(tmInfo,"^",33)
 	s $NAMESPACE=CurrentNameSpace
 	q Locdr_"^"_RegNo
}

// w ##class(web.DHCPisApplicationSheet).UpPISCharge()

ClassMethod UpPISCharge() As %String
{
	s CurrentNameSpace =$ZNSPACE
     s data="",Info=""
     d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
     d ##class(Src.DPIS3OutInterface).SynchHisCharge(.data)
     s Info=data
     s $NAMESPACE=CurrentNameSpace
     q Info
}

}
