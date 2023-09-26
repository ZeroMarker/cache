Class web.DHCUserFavItemPrice Extends DHCDoc.Util.RegisteredObject
{

/// 包装价格的查询query
/// 入参：ARCOSRowid
/// w ##class(%ResultSet).RunQuery("web.text1","FindInfo","100000014587","") 
Query FindInfo(ARCOSRowid As %String) As %Query(ROWSPEC = "TDateFrom:%String,TDateTo:%String,TTariff:%String,TPrice:%String,THospital:%String,Pricerowid:%String,TTariffrowid:%String,Hospitalid:%String")
{
}

ClassMethod FindInfoExecute(ByRef qHandle As %Binary, ARCOSRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s ^tempqujian("aa",ARCOSRowid)=ARCOSRowid
    Set langid=..%LanguageID()
    s Pricerowid=0
    f  s Pricerowid=$o(^ARCOS(ARCOSRowid,"PRICE",Pricerowid)) q:Pricerowid=""  d
    .s DateFrom=$p(^ARCOS(ARCOSRowid,"PRICE",Pricerowid),"^",1)
    .s TDateFrom=..%ZD(DateFrom) //$zd(DateFrom,4)
    .s DateTo=$p(^ARCOS(ARCOSRowid,"PRICE",Pricerowid),"^",2)
    .s TDateTo=""
    .i DateTo'=""  s TDateTo=..%ZD(DateTo) //$zd(DateTo,4)
    .s TTariffrowid=$p(^ARCOS(ARCOSRowid,"PRICE",Pricerowid),"^",3)
   	.i TTariffrowid'=""  s TTariff=$p(^ARC("TAR",TTariffrowid),"^",2)
   	.Set TTariff= ##class(User.ARCTariff).GetTranByDesc("TARDesc",TTariff,langid)
    .s TPrice=$j($p(^ARCOS(ARCOSRowid,"PRICE",Pricerowid),"^",4),"",2)
    .s Hospitalid=$p(^ARCOS(ARCOSRowid,"PRICE",Pricerowid),"^",7)
    .s THospital=""
    .i Hospitalid'=""  s THospital=$p(^CT("HOSP",Hospitalid),"^",2)
    .Set THospital= ##class(User.CTHospital).GetTranByDesc("HOSPDesc",THospital,langid)
    .s Pricerowid1=ARCOSRowid_"||"_Pricerowid
    .do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TDateFrom,TDateTo,TTariff,TPrice,THospital,Pricerowid1,TTariffrowid,Hospitalid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod FindInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 医院下拉框
ClassMethod LookUpHospital(itmjs As %Library.String = "", desc As %String = "") As %String
{
	Set langid=..%LanguageID()
	s rowid=0,json="[",myIdx=1
	f  s rowid=$o(^CT("HOSP",rowid)) q:rowid=""  d
	.s Desc=$p(^CT("HOSP",rowid),"^",2)
	.Set Desc= ##class(User.CTHospital).GetTranByDesc("HOSPDesc",Desc,langid)
	.s value=rowid
	.i itmjs="" d
	..s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
	..&javascript<#(retval)#>
	.e  d
	..s OneJsonData="{""text"":"""_$g(Desc)_""",""id"":"""_$g(value)_""""
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=1 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (itmjs'=""){
		q json
	}
    q 0
}

/// 征收下拉框
ClassMethod LookUpTariff(itmjs As %Library.String = "", desc As %String = "") As %String
{
	s rowid=0,json="[",myIdx=1
	Set langid=..%LanguageID()
	f  s rowid=$o(^ARC("TAR",rowid)) q:rowid=""  d
	.s Desc=$p(^ARC("TAR",rowid),"^",2)
	.Set Desc= ##class(User.ARCTariff).GetTranByDesc("TARDesc",Desc,langid)
	.s value=rowid
	.i itmjs="" d
	..s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
	..&javascript<#(retval)#>
	.e  d
	..s OneJsonData="{""text"":"""_$g(Desc)_""",""id"":"""_$g(value)_""""
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=1 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (itmjs'=""){
		q json
	}
    q 0
}

/// 增加医嘱套的包装价格
ClassMethod insert(ARCOSRowid As %String = "", DateFrom As %String = "", DateTo As %String = "", Tariff As %String = "", Price As %String = "", Hospital As %String = "") As %String
{
	
	q:ARCOSRowid=""
	/*i DateFrom["-" s DateFrom=$zdh(DateFrom,3)
 	i DateFrom["/" s DateFrom=$zdh(DateFrom,4)
 	i DateTo["-" s DateTo=$zdh(DateTo,3)
 	i DateTo["/" s DateTo=$zdh(DateTo,4)*/
	s DateTo=$replace(DateTo," ","")
	i DateFrom'="" s DateFrom=..%ZDH(DateFrom)
	i DateTo'="" s DateTo=..%ZDH(DateTo)
	&sql(INSERT INTO sqluser.ARC_OrdSetPrice (PRICE_ParRef,PRICE_DateFrom,PRICE_DateTo,PRICE_Tariff_DR,PRICE_Price,PRICE_HospitalDR)
	VALUES (:ARCOSRowid,:DateFrom,:DateTo,:Tariff,:Price,:Hospital))
	s rtn=SQLCODE
	q rtn
}

ClassMethod Update(ARCOSRowidPrice As %String = "", DateFrom As %String = "", DateTo As %String = "", Tariff As %String = "", Price As %String = "", Hospital As %String = "") As %String
{
	q:ARCOSRowidPrice=""
	/*i DateFrom["-" s DateFrom=$zdh(DateFrom,3)
 	i DateFrom["/" s DateFrom=$zdh(DateFrom,4)
 	i DateTo["-" s DateTo=$zdh(DateTo,3)
 	i DateTo["/" s DateTo=$zdh(DateTo,4)*/
	s DateTo=$replace(DateTo," ","")
	i DateFrom'="" s DateFrom=..%ZDH(DateFrom)
	i DateTo'="" s DateTo=..%ZDH(DateTo)
 	&sql(Update sqluser.ARC_OrdSetPrice (PRICE_DateFrom,PRICE_DateTo,PRICE_Tariff_DR,PRICE_Price,PRICE_HospitalDR)
	VALUES (:DateFrom,:DateTo,:Tariff,:Price,:Hospital)
	WHERE (PRICE_RowId=:ARCOSRowidPrice))
	s rtn=SQLCODE
	q rtn
}

ClassMethod Delete(ARCOSRowidPrice As %String = "") As %String
{
	q:ARCOSRowidPrice=""
	&sql(Delete sqluser.ARC_OrdSetPrice WHERE (PRICE_RowId=:ARCOSRowidPrice))
	s rtn=SQLCODE
	q rtn
}

}
