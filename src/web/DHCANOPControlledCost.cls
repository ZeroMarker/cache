Import SQLUser

Class web.DHCANOPControlledCost Extends %RegisteredObject
{

/// Creator: cdx
/// CreatDate: 2015-11-06
/// Description: 取手术所用物资耗材明细列表
/// Table：DHC_AN_OPArrangeStock
/// Input：opaId
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCANOPControlledCost","FindArticleInfoList",161)
Query FindArticleInfoList(opaId As %String) As %Query(ROWSPEC = "opaId:%String,articleId:%String,tArticle,tUnivalent,tUnit:%String,tAmount:%String,tTotal:%String")
{
}

ClassMethod FindArticleInfoListExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if opaId=""	Set qHandle=$lb(0,repid,0) Quit $$$OK
	s articleId=0,tArticle="",tUnivalent=""
	f  s articleId=$o(^DHCANOPArrangeStock(0,"OPArrStockItem",opaId,articleId))  q:articleId=""  d
	  .s ANOPASRowId=0,BarCode=""
	  .f  s ANOPASRowId=$o(^DHCANOPArrangeStock(0,"OPArrStockItem",opaId,articleId,ANOPASRowId))  q:ANOPASRowId=""  d
	     ..s BarCode=$li(^DHCANOPArrangeStock(ANOPASRowId),9)
	     ..q:BarCode'="无"  //条形码不为“无”的是高值耗材
	     ..;s ret=##class(web.DHCSTINTERFACE).GetBatInfoByIncil(articleId)
	     ..s ret=..GetBatInfoByIncil(articleId)
	     ..s tArticle=$p(ret,"^",3)
	     ..s tUnivalent=$p(ret,"^",5)
	     ..s tAmount=$li(^DHCANOPArrangeStock(ANOPASRowId),3)
	     ..s tUnit=$li(^DHCANOPArrangeStock(ANOPASRowId),10)
	     ..s tTotal=$li(^DHCANOPArrangeStock(ANOPASRowId),11)
	     ..d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(opaId,articleId,tArticle,tUnivalent,tUnit,tAmount,tTotal)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindArticleInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArticleInfoListExecute ]
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

ClassMethod FindArticleInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArticleInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// cdx
/// 151106
/// 保存手术中所用的物资耗材信息（手术室精细化管理——可控成本管理）
/// 输入：opaId：手术号,articleId：物资耗材ID,unit：物资耗材单位数量,amount：物资耗材数量,total：总成本,UserId:操作人
ClassMethod SaveArticleInfo(opaId, articleId, unit, amount, total, UserId)
{
	q:opaId="" "-1^opaId is null"
	q:articleId="" "-2^articleId is null"
	
	s date=+$h,time=$p($h,",",2)
	s preBarCode="",str="",ANOPASRowId=""
	s ANOPASRowId=$o(^DHCANOPArrangeStock(0,"OPArrStockItem",opaId,articleId,"")) 
	i ANOPASRowId="" s obj=##class(User.DHCANOPArrangeStock).%New()
	e  d
	.s str="-5^该物资耗材已保存过"
	
	q:str'="" str

	s obj.ANOPASANArrangeDr=opaId
	s obj.ANOPASUpdateUserDr=UserId
	s obj.ANOPASUpdateDate=date
	s obj.ANOPASUpdateTime=time
	s obj.ANOPASANCSIDr=articleId
	s obj.ANOPASQty=amount
	s obj.ANOPASUnitQty=unit
	s obj.ANOPASTotalCost=total
	s obj.ANOPASBarCode="无"
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-4^数据保存失败!"_articleId
	s RowId=obj.%Id()
	d obj.%Close()

	;q RowId
	i RowId>0  s str=0
	e   s str=RowId
	q str
}

/// cdx
/// 151117
/// 修改手术中所用的物资耗材信息（手术室精细化管理——可控成本管理）
/// 输入：opaId：手术号,articleId：物资耗材ID,unit：物资耗材单位数量,amount：物资耗材数量,UserId:操作人,tUnivalent:单价
ClassMethod UpdateArticleInfoFromList(opaId, articleId, unit, amount, UserId, tUnivalent)
{
	q:opaId="" "-1^opaId is null"
	q:articleId="" "-2^articleId is null"
	
	s date=+$h,time=$p($h,",",2)
	s preBarCode="",str="",ANOPASRowId=""
	s total=..GetTotalCost(unit,amount,tUnivalent)
	s ANOPASRowId=$o(^DHCANOPArrangeStock(0,"OPArrStockItem",opaId,articleId,"")) 
	i ANOPASRowId="" s obj=##class(User.DHCANOPArrangeStock).%New()
	e  s obj=##class(User.DHCANOPArrangeStock).%OpenId(ANOPASRowId)

	s obj.ANOPASANArrangeDr=opaId
	s obj.ANOPASUpdateUserDr=UserId
	s obj.ANOPASUpdateDate=date
	s obj.ANOPASUpdateTime=time
	s obj.ANOPASANCSIDr=articleId
	s obj.ANOPASQty=amount
	s obj.ANOPASUnitQty=unit
	s obj.ANOPASTotalCost=total
	s obj.ANOPASBarCode="无"
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-4^数据保存失败!"_articleId
	s RowId=obj.%Id()
	d obj.%Close()

	q:RowId>0 0
	q RowId
}

/// cdx
/// 151124
/// 删除手术中所用的物资耗材记录（手术室精细化管理——可控成本管理）
/// 输入：opaId：手术号,articleId：物资耗材ID
ClassMethod DeleteArticleInfo(opaId, articleId)
{
	q:opaId="" "-1^opaId is null"
	q:articleId="" "-2^articleId is null"
	
	s preBarCode="",str="",ANOPASRowId=""
	s ANOPASRowId=$o(^DHCANOPArrangeStock(0,"OPArrStockItem",opaId,articleId,"")) 
	i ANOPASRowId="" s str="该物资未保存过"
	e  d
	.d ##class(User.DHCANOPArrangeStock).%DeleteId(ANOPASRowId)
	.s str=0
	
	q str
}

ClassMethod GetTotalCost(unit, amount, univalent)
{
	q amount*univalent
}

/// Descript:取入库表的进价，实际进货价
/// Input:inclb-科室库存项ID,UOM-单位ID,HospID-医院ID
/// w ##class().LastInPrice("8673||6||1","100",2)
ClassMethod LastInPrice(inclb, UOM, HospID = "") As %String
{
 //n (inclb,UOM,HospID)
 q:inclb="" ""
 Q:##class(web.DHCSTPRICE).ChkRIngr(+inclb)=1 ##class(web.DHCSTPRICE).GetManPrice(inclb,UOM)	;制剂取进价
 s LASTINGRI=##class(web.DHCSTPRICE).LastINGRI(inclb) q:LASTINGRI="" ""
 s DHCINGR=$P(LASTINGRI,"||",1)
 s DHCINGRCH=$P(LASTINGRI,"||",2)
 s RP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30)    ; Real Price (in)
 s RECUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10) ; UOM
 s BUOM=$p(^INCI(+inclb,1),"^",10)
 i $g(UOM)="" s UOM=BUOM
 b	;
 i UOM=RECUOM q RP     ; if the specified uom equals to the rec uom 
 s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
 s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(RECUOM,BUOM)
 s RP=RP/fac2*fac1
 i $d(^$R("^web.DHCSTCOMMPARA.1")) d
	 .S CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID) //DHC_STCustomer
	 .S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
	 .S StkTypeDesc=$P(CatGrpStr,"^",4)
	 .S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	 .i UOM=BUOM d
	 ..;b	;1
	 ..s RP=##Class(web.DHCSTCOMMPARA).GetNumbDec(RP,Perv,"FmtRP",2)
	 .e  d
	 ..;b	;2
	 ..s RP=##Class(web.DHCSTCOMMPARA).GetNumbDec(RP,Perv,"FmtRP",1)
 q RP
}

/// 根据科室批次id取批次信息
/// w ##class(web.DHCANOPControlledCost).GetBatInfoByIncil("8673||6||1")
/// return:  科室批次id^代码^名称^批号^进价^单位^厂家
ClassMethod GetBatInfoByIncil(inclb) As %String
{
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	q:(inci=0)!(il="")!(lb="") ""
	s incicode=$p(^INCI(inci,1),"^",1)
    s incidesc=$p(^INCI(inci,1),"^",2)
    s puom=$p(^INCI(inci,3),"^",6)
    s puomdesc=$p(^CT("UOM",puom),"^",2)
    s rp=..LastInPrice(inclb,puom,"")
    b
    s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
    s BatNo=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
    s manf=""    
    s dhcib=$o(^DHCINCIB(0,"INCIB",incib,""))
    i dhcib'=""  d
    .s manfdr=$p(^DHCINCIB(dhcib),"^",7)
    .s:manfdr'="" manf=$p(^PHMNF(manfdr),"^",2)
    s ret=inclb_"^"_incicode_"^"_incidesc_"^"_BatNo_"^"_(+rp)_"^"_puomdesc_"^"_manf
    q ret
}

/// Descript：给手麻系统的接口，取科室批次信息
/// CreateDate：2016-10-19
/// INPUT: input-搜索别名  ctloc-科室id(ct_loc rowid)
/// RETRUN:科室批次id^代码^名称^批号^进价^单位^厂家
/// d ##class(%ResultSet).RunQuery("web.DHCANOPControlledCost","QueryInci","bflwz","")
ClassMethod QueryInciClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryInciExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryInciExecute(ByRef QHandle As %Binary, input As %Library.String = "", ctloc As %Library.String = "") As %Status
{
    //n (QHandle,input,ctloc)
	Set repid=$I(^CacheTemp)
	s ind=1
	s input=$g(input)
	s input=$ZCVT(input,"U") 
	s input="%"_input_"%"
	s HospID=$p(^CTLOC(ctloc),"^",22)
	&sql(declare curt cursor for select INCA_INCI_DR from inc_alias where INCA_TEXT like :input)
    &sql(open curt)
    f  &sql(fetch curt  into :inci )  q:SQLCODE  d
    .q:(ctloc'="")&&('$d(^INCI("IL_LOC",ctloc,inci)))
    .s il=$o(^INCI("IL_LOC",ctloc,inci,""))
    .q:il=""
    .s incicode=$p(^INCI(inci,1),"^",1)
    .s incidesc=$p(^INCI(inci,1),"^",2)
    .s lb=0
    .f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
    ..s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
    ..s BatNo=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
    ..s ExpDate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)   
    ..s rp=0,manf=""    
    ..s dhcib=$o(^DHCINCIB(0,"INCIB",incib,""))
    ..i dhcib'=""  d
    ...s manfdr=$p(^DHCINCIB(dhcib),"^",7)
    ...s:manfdr'="" manf=$p(^PHMNF(manfdr),"^",2)
    ...//s rp=$p(^DHCINCIB(dhcib),"^",2)
    ..s inclb=inci_"||"_il_"||"_lb
    ..s puom=$p(^INCI(inci,3),"^",6)
    ..s puomdesc=$p(^CT("UOM",puom),"^",2)
    ..s rp=##class(web.DHCSTPRICE).GetCurRp(inclb,puom,HospID)
	..set Data=$lb(inclb,incicode,incidesc,BatNo,+rp,puomdesc,manf)
	..Set ^CacheTemp(repid,ind)=Data
	..Set ind=ind+1
	&sql(close curt)
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryInciFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInciExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryInci(input As %String, ctloc As %String) As %Query(ROWSPEC = "inclb:%String,incicode:%String,incidesc:%String,BatNo:%String,rp:%String,puomdesc:%String,manf:%String")
{
}

ClassMethod CheckValidData(desc, id)
{
	q:+id'>0 0
	q:$d(^INCI(+id))<1 0
	s incidesc=$p(^INCI(+id,1),"^",2)
	q:incidesc'=desc 0
	q 1
}

}
