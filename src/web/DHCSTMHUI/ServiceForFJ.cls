Import sqluser

/// Descript:	飞行检查程序
/// Creater:	
/// CreateDate:	2021-9-29
Class web.DHCSTMHUI.ServiceForFJ Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 定点医药机构编号
Parameter HospOrgCode = "abcd";

/// 定点医药机构名称
Parameter HospOrgDesc = 1234;

/// Description:取入库明细数据
/// CreatDate： 2022-7-26
/// Table：     DHC_INGdRecItm
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForFJ","QueryRecNew","2022-1-25","2022-7-29")
/// call web_DHCSTMHUI.ServiceForFJ_QueryRecNew("2022-1-25","2022-07-29")
/// 
Query QueryRecNew(StartDate As %String, EndDate As %String, LocId As %String, Hosp As %String = "") As websys.Query(ROWSPEC = "STORE_DATE,FIXMEDINS_CODE,FIXMEDINS_NAME,MED_LIST_CODG,MEDINS_LIST_CODG,MEDINS_LIST_NAME,LIST_TYPE,INVOICE_NO,BATCH_NUMBER,SPEC,UNT,PRIC:%Float,CNT:%Float,SPLER_NAME,PRODENTP_NAME") [ SqlProc ]
{
}

ClassMethod QueryRecNewExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String, Hosp As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,Hosp)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:LocId="" $$$OK
	s HospCode=..%GetParameter("HospOrgCode") 
	s HospName=..%GetParameter("HospOrgDesc")
	s IngrType=""
	s Mtype=..sssCode()
	s statType="G^R"
	f date=StartDate:1:EndDate d 
	.;1. 统计入库部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","G",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s dhcingr=+pointer
	..s dhcingri=$p(pointer,"||",2)
	..q:'$d(^DHCINGR(dhcingr))
	..q:'$d(^DHCINGR(dhcingr,"GRI",dhcingri))
	..s StkType=$p(^DHCINGR(dhcingr),"^",30)
	..q:StkType'=Mtype
	..s RecLocId=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",3)
	..q:RecLocId=""
	..q:RecLocId'=LocId
	..s HospId=$p(^CTLOC(RecLocId),"^",22)
	..
	..s Inclb=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",1)
	..q:Inclb=""
	..s Inci=+Inclb
	..q:Inci=0
	..;s ArcId=$p(^INCI(Inci,1),"^",3)
	..;q:ArcId=""
	..
	..s IngrNo=$p(^DHCINGR(dhcingr),"^",1)
	..s IngrTypeId=$p(^DHCINGR(dhcingr),"^",23)
	..;s:IngrTypeId'="" IngrType=$p(^DHCOPTYPE(IngrTypeId),"^",2)
	..s RecDate=$zd(date,3)
	..
	..s LocCode=$p(^CTLOC(RecLocId),"^",1) ;库房编码
	..s MatInsuInfo=..GetInciInsuInfo(Inci)
	..s MatInsuCode=$p(MatInsuInfo,"^",1)
	..
	..s MatInsuDesc=$p(MatInsuInfo,"^",2)
	..
	..s listCode="301"
	..s InciCode=$p(^INCI(Inci,1),"^",1) ;代码
	..s InciDesc=$p(^INCI(Inci,1),"^",2) ;名称
	..s VendorId=$p(^DHCINGR(dhcingr),"^",3)
	..s RecDetail=^DHCINGR(dhcingr,"GRI",dhcingri)
	..
	..s InvNo=$p(RecDetail,"^",27) ;发票号
	..s UomDr=$p(RecDetail,"^",10)
	..s UomDesc=$p(^CT("UOM",UomDr),"^",2)
	..s Rp=$p(RecDetail,"^",30) ;单价
	..s Sp=$p(RecDetail,"^",31) ;售价
	..s ManfId=$p(RecDetail,"^",29)
	..s ManfDesc=""
	..s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)  ;生产厂家
	..s VendorDesc=""
	..s:VendorId'="" VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
	..s Qty=$p(RecDetail,"^",4)
	..s BatNo=$p(RecDetail,"^",13)
	..;s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci) ;型号
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci) ;规格
	..s RecTime=$p(^DHCINTR(intrid),"^",3)
	..s:RecTime'="" RecTime=$zt(RecTime)
	..s RecDate=RecDate_" "_RecTime
	..s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	..s BatNo=$p(BatExp,"^",1)
	..d OutputRecRow
	
	f date=StartDate:1:EndDate d 
	.;1. 统计退货部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","R",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s ingrtid=+pointer
	..s retch=$p(pointer,"||",2)
	..q:'$d(^INGRT(ingrtid))
	..q:'$d(^INGRT(ingrtid,"DHCGRR",retch)) ;^INGRT(Ingrt,"DHCGRR",IngrtiCh)
	..s retstr=^INGRT(ingrtid)
	..
	..s retistr=^INGRT(ingrtid,"DHCGRR",retch)
	..s StkType=$p(retstr,"^",16)
	..q:StkType'=Mtype
	..s RetLocId=$p(retstr,"^",7)
	..q:RetLocId=""
	..
	..q:RetLocId'=LocId
	..s HospId=$p(^CTLOC(RetLocId),"^",22)
	..
	..s Inclb=$p(^DHCINTR(intrid),"^",7)
	..q:Inclb=""
	..s Inci=+Inclb
	..q:Inci=0
	..;s ArcId=$p(^INCI(Inci,1),"^",3)
	..;q:ArcId=""
	..s RetTime=$p(^DHCINTR(intrid),"^",3)
	..s RecDate=date_" "_RetTime
	..s Qty=$p(^DHCINTR(intrid),"^",6)
	..s UomDr=$p(^DHCINTR(intrid),"^",10)
	..s Rp=$p(^DHCINTR(intrid),"^",16) ;单价
	..s Sp=$p(^DHCINTR(intrid),"^",14) ;售价
	..s RetDate=$zd(date,3)
	..s:RetTime'="" RetTime=$zt(RetTime)
	..s RetDate=RetDate_" "_RetTime
	..s LocCode=$p(^CTLOC(RetLocId),"^",1) ;库房编码
	..s MatInsuInfo=..GetInciInsuInfo(Inci)
	..s MatInsuCode=$p(MatInsuInfo,"^",1)
	..s listCode="301"
	..s InciCode=$p(^INCI(Inci,1),"^",1) ;代码
	..s InciDesc=$p(^INCI(Inci,1),"^",2) ;名称
	..s VendorId=$p(retstr,"^",2)
	..
	..s InvNo=$p(retistr,"^",12) ;发票号
	..s UomDesc=$p(^CT("UOM",UomDr),"^",2)
	..s ManfId=$p(retistr,"^",29)
	..s ManfDesc=""
	..s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)  ;生产厂家
	..s VendorDesc=""
	..s:VendorId'="" VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
	..
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci) ;规格
	..s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	..s BatNo=$p(BatExp,"^",1)
	..d OutputRetRow
	Quit $$$OK
OutputRecRow
	Set Data=$lb(RecDate,HospCode,HospName,MatInsuCode,InciCode,InciDesc,listCode,InvNo,BatNo,Spec,UomDesc,Rp,Qty,VendorDesc,ManfDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
OutputRetRow
	Set Data=$lb(RetDate,HospCode,HospName,MatInsuCode,InciCode,InciDesc,listCode,InvNo,BatNo,Spec,UomDesc,Rp,Qty,VendorDesc,ManfDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// Description:根据获取转出数据
/// CreatDate： 2022-7-26
/// Table：     DHC_INTRANS 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForFJ","QueryTransOutNew","2021-7-1","2022-10-1")
/// call web_DHCSTMHUI.ServiceForFJ_QueryTransOutNew("2022-1-1","2022-12-4")
/// 
Query QueryTransOutNew(StartDate As %String, EndDate As %String, LocId As %String, Hosp As %String = "") As websys.Query(ROWSPEC = "DEL_DATE,FIXMEDINS_CODE,FIXMEDINS_NAME,MED_LIST_CODG,MEDINS_LIST_CODG,MEDINS_LIST_NAME,LIST_TYPE,SPEC,UNT,CNT:%Float,DELIVER_OBJECT,SPLER_NAME,PRODENTP_NAME") [ SqlProc ]
{
}

ClassMethod QueryTransOutNewExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String, Hosp As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,Hosp)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:LocId="" $$$OK
	s Mtype=..sssCode()
	s HospCode=..%GetParameter("HospOrgCode") 
	s HospName=..%GetParameter("HospOrgDesc")
	s TrType="T"
	f date=StartDate:1:EndDate d
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s uomDr=$p(^DHCINTR(intrid),"^",10)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..s StkType=$p(^DHCINIT(MainId),"^",24)
	..q:StkType'=Mtype
	..s InitNo=$p(^DHCINIT(MainId),"^",1)
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;接收科室
	..q:FromLocId=""
	..q:ToLocId=""
	..q:FromLocId'=LocId
	..s InitType=$p(^DHCINIT(MainId),"^",20)
	..s:InitType'="" InitType=$p(^DHCOPTYPE(InitType),"^",2)
	..s HospId=$p(^CTLOC(FromLocId),"^",22)
	..s inclbid=$p(^DHCINTR(intrid),"^",7)
	..q:inclbid=""
	..
	..s Inci=+inclbid
	..q:+Inci=0
	..s ArcId=$p(^INCI(Inci,1),"^",3)
	..;q:ArcId=""
	..s TransDate=$zd(date,3)
	..s MatInsuInfo=..GetInciInsuInfo(Inci)
	..s MatInsuCode=$p(MatInsuInfo,"^",1)
	..s MatInsuDesc=$p(MatInsuInfo,"^",2)
	..s InciCode=$p(^INCI(Inci,1),"^",1) ;代码
	..s InciDesc=$p(^INCI(Inci,1),"^",2) ;名称
	..;s scgDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",2)
	..s ListType="301"
	..s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci) ;型号
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci) ;规格
	..s InitiInfo=^DHCINIT(MainId,"ITI",Chl)
	..s Rp=$p(InitiInfo,"^",15)
	..s Sp=$p(InitiInfo,"^",17)	
	..s TrQty=$p(InitiInfo,"^",1)
	..S RpAmt=Rp*TrQty
	..s ManfList=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
	..s ManfDesc=$p(ManfList,"^",2)
	..s VenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclbid)
	..s VendorDesc=$p(VenInfo,"^",2)
	..s ToLocCode=$p(^CTLOC(ToLocId),"^",1)
	..s ToLocDesc=$p(^CTLOC(ToLocId),"^",2)
	..s TransTime=$p(^DHCINTR(intrid),"^",3)
	..s:TransTime'="" TransTime=$zt(TransTime)
	..;s:TransTime'="" TransTime=$p(TransTime,":",1,2)
	..s TransDate=TransDate_" "_TransTime
	..s TmpBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(inclbid)
	..s BatNo=$p(TmpBat,"^",1)
	..s ExpDate=$p(TmpBat,"^",2)
	..s UomDesc=""
	..s:uomDr'="" UomDesc=$p(^CT("UOM",uomDr),"^",2)
	..s Remarks=""
	..d OutputTransOutRow
	s TrType="K"
	f date=StartDate:1:EndDate d
	.s intrid="" 
	.f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s uomDr=$p(^DHCINTR(intrid),"^",10)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..s StkType=$p(^DHCINIT(MainId),"^",24)
	..q:StkType'=Mtype
	..s InitNo=$p(^DHCINIT(MainId),"^",1)
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;退库科室
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;库房
	..q:ToLocId'=LocId
	..q:FromLocId=""
	..q:ToLocId=""
	..s HospId=$p(^CTLOC(FromLocId),"^",22)
	..s inclbid=$p(^DHCINTR(intrid),"^",7)
	..q:inclbid=""
	..
	..s Inci=+inclbid
	..q:+Inci=0
	..s ArcId=$p(^INCI(Inci,1),"^",3)
	..;q:ArcId=""
	..s TransDate=$zd(date,3)
	..s MatInsuInfo=..GetInciInsuInfo(Inci)
	..s MatInsuCode=$p(MatInsuInfo,"^",1)
	..s MatInsuDesc=$p(MatInsuInfo,"^",2)
	..s InciCode=$p(^INCI(Inci,1),"^",1) ;代码
	..s InciDesc=$p(^INCI(Inci,1),"^",2) ;名称
	..;s scgDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",2)
	..s ListType="301"
	..s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci) ;型号
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci) ;规格
	..s InitiInfo=^DHCINIT(MainId,"ITI",Chl)
	..s Rp=$p(InitiInfo,"^",15)
	..s Sp=$p(InitiInfo,"^",17)	
	..s TrQty=-$p(InitiInfo,"^",1)
	..S RpAmt=Rp*TrQty
	..s ManfList=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
	..s ManfDesc=$p(ManfList,"^",2)
	..s VenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclbid)
	..s VendorDesc=$p(VenInfo,"^",2)
	..s FromLocCode=$p(^CTLOC(FromLocId),"^",1)
	..s FromLocDesc=$p(^CTLOC(FromLocId),"^",2)
	..s TransTime=$p(^DHCINTR(intrid),"^",3)
	..s:TransTime'="" TransTime=$zt(TransTime)
	..;s:TransTime'="" TransTime=$p(TransTime,":",1,2)
	..s TransDate=TransDate_" "_TransTime
	..s TmpBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(inclbid)
	..s BatNo=$p(TmpBat,"^",1)
	..s ExpDate=$p(TmpBat,"^",2)
	..s UomDesc=""
	..s:uomDr'="" UomDesc=$p(^CT("UOM",uomDr),"^",2)
	..s Remarks=""
	..d OutputTransInRow
	Quit $$$OK 
OutputTransOutRow
	Set Data=$lb(TransDate,HospCode,HospName,MatInsuCode,InciCode,InciDesc,
	ListType,Spec,UomDesc,TrQty,ToLocDesc,VendorDesc,ManfDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
OutputTransInRow
	Set Data=$lb(TransDate,HospCode,HospName,MatInsuCode,InciCode,InciDesc,
	ListType,Spec,UomDesc,TrQty,FromLocDesc,VendorDesc,ManfDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForFJ","QueryStockNew","2022-8-19","2022-08-19")
Query QueryStockNew(StartDate As %String, EndDate As %String, LocId = "", Hosp As %String = "") As websys.Query(ROWSPEC = "FIXMEDINS_CODE,FIXMEDINS_NAME,MED_LIST_CODG,MEDINS_LIST_CODG,MEDINS_LIST_NAME,LIST_TYPE,SPEC,OPENING_DATE,OPENING_BALANCE:%Float,CLOSING_DATE,CLOSING_BALANCE:%Float,SPLER_NAME,PRODENTP_NAME") [ SqlProc ]
{
}

ClassMethod QueryStockNewExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId = "", Hosp As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,Hosp)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s OriStartDate=StartDate,OriEndDate=EndDate
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s pid=..NewPid()
	k ^TMPDHCSTM("ServiceForFJ","StockNew",pid)
	s Inci=0
	s HospCode=..%GetParameter("HospOrgCode") 
	s HospName=..%GetParameter("HospOrgDesc")
	f  s Inci=$o(^INCI(Inci)) q:(+Inci=0)||(Inci="")  d
	.q:'$d(^INCI(Inci))
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgDesc=$p(StkGrpInfo,"^",2)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.q:NotUse="Y" 
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.
	.s (BaseCTUomDesc,PurchCTUomDesc)=""
	.s:BUomId'="" BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s il=0
	.f  s il=$o(^INCI(Inci,"IL",il)) q:il=""  d
	..q:'$d(^INCI(Inci,"IL",il))
	..s Incil=Inci_"||"_il
	..s PhaLoc=$p($g(^INCI(Inci,"IL",il)),"^",1)
	..q:PhaLoc=""
	..q:(LocId'="")&&(PhaLoc'=LocId)
	..s lb=0
	..f  s lb=$o(^INCI(Inci,"IL",il,"LB",lb)) q:lb=""  d
	...s Inclb=Incil_"||"_lb
	...s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	...//供应商过滤
	...s VendorStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	...s vendorId=$p(VendorStr,"^",1)
	...s vendorname=$p(VendorStr,"^",2)
	...s ManfStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	...s ManfId=$p(ManfStr,"^",1)
	...s ManfName=$p(ManfStr,"^",2)
	...//供应商过滤
	...s BatchNo=$p(BatExp,"^",1)
	...s ExpDate=$p(BatExp,"^",2)
	...s Incib=$p(^INCI(Inci,"IL",il,"LB",lb),"^",1)
	...s StartStockQty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,StartDate)
	...s EndStockQty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,EndDate)
	...
	...q:(StartStockQty=0)&&(EndStockQty=0)
	...s ListStr=Inci_","_vendorId_","_ManfId
	...i '$d(^TMPDHCSTM("ServiceForFJ","StockNew",pid,ListStr))  d
	....s ^TMPDHCSTM("ServiceForFJ","StockNew",pid,ListStr)=Inci_"^"_vendorId_"^"_ManfId_"^"_StartStockQty_"^"_EndStockQty_"^"_vendorname_"^"_ManfName
	...e  d
	....s $p(^TMPDHCSTM("ServiceForFJ","StockNew",pid,ListStr),"^",4)=+$p(^TMPDHCSTM("ServiceForFJ","StockNew",pid,ListStr),"^",4)+StartStockQty
	....s $p(^TMPDHCSTM("ServiceForFJ","StockNew",pid,ListStr),"^",5)=+$p(^TMPDHCSTM("ServiceForFJ","StockNew",pid,ListStr),"^",5)+EndStockQty
	s tmpListStr=""
	f  s tmpListStr=$o(^TMPDHCSTM("ServiceForFJ","StockNew",pid,tmpListStr)) q:(tmpListStr="")  d
	.s ListData=^TMPDHCSTM("ServiceForFJ","StockNew",pid,tmpListStr)
	.s Inci=$p(ListData,"^",1)
	.s ManfName=$p(ListData,"^",7)
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s MatInsuInfo=..GetInciInsuInfo(Inci)
	.s MatInsuCode=$p(MatInsuInfo,"^",1)
	.s MatInsuDesc=$p(MatInsuInfo,"^",2)
	.;s ScgDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",2)
	.s ListType="301"
	.s spec=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci),",",1)
	.s startDateQty=$p(ListData,"^",4)
	.S endDateQty=$p(ListData,"^",5)
	.s VendorDesc=$p(ListData,"^",6)
	.s ManfDesc=$p(ListData,"^",7)
	.d OutputStockRow
	k ^TMPDHCSTM("ServiceForFJ","StockNew",pid)
	Quit $$$OK
OutputStockRow
	Set Data=$lb(HospCode,HospName,MatInsuCode,InciCode,InciDesc,
	ListType,spec,OriStartDate,+startDateQty,OriEndDate,
	+endDateQty,VendorDesc,ManfDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// 取医保分类代码信息(此方法变化可能较多)
ClassMethod GetInciInsuInfo(Inci) As %Library.String
{
	n (Inci)
	q:Inci="" ""
	s MatInsuInfo=""
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	q:Info="" ""
	s MatInsuCode=$p($g(^DHCITMINFO(Info,1)),"^",39)
	s MatInsuDesc=$p($g(^DHCITMINFO(Info,1)),"^",54)
	s MatInsuInfo=MatInsuCode_"^"_MatInsuDesc
	q MatInsuInfo
}

}
