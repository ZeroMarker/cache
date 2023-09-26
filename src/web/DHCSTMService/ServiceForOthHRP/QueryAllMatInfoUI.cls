Import sqluser

Class web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 物资基础信息 GH_MATER_LIST
/// Author: lihui
/// Date: 20191110
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfo","QueryMatBaseInfo")
Query QueryMatBaseInfo() As web.DHCSTMHUI.Query(ROWSPEC = "orgcode:%String,pk_ mateial:%String,mcode:%String,mname:%String,meascode:%String,measname:%String,materialspec:%String,materialtype:%String") [ SqlProc ]
{
}

ClassMethod QueryMatBaseInfoExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s inci=0,count=0
	f  s inci=$o(^INCI(inci)) q:+inci=0  d
	.s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s TmpStkGrpdesc=$p(tmpstkgrp,"^",3)
	.q:TmpStkGrpdesc'="M"
	.s notuse=$p(^INCI(inci,2),"^",9)
	.q:notuse="Y"
	.s InciCode=$P(^INCI(inci,1),"^",1)
	.s InciDesc=$P(^INCI(inci,1),"^",2)
	.s PuomDr=$P(^INCI(inci,3),"^",6)
	.s PuomDesc=$s(PuomDr'="":$P(^CT("UOM",PuomDr),"^",2),1:"")
	.s BuomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncBuom(inci)
	.s BuomDr=$P(BuomStr,"^",1)
	.s BuomCode=$s(BuomDr'="":$P(^CT("UOM",BuomDr),"^",1),1:"")
	.s BuomDesc=$P(BuomStr,"^",2)
	.s packageQuantity=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
	.s Spec=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	.s Model=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
	.s Brand=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci)
	.s Abbrev=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAbbrev(inci)
	.s ManfStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci)
	.s Manfdr=$P(ManfStr,"^",1)
	.s ManfCode=$P(ManfStr,"^",2)
	.s ManfName=$P(ManfStr,"^",3)
	.s IncCatId=$p(^INCI(inci,2),"^",2)
	.s IncCat=$s(IncCatId'="":$p(^INC("SC",IncCatId),"^",2),1:"")
	.s cert=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(inci)
	.s CertNo=$p(cert,"^",1)
	.s CertExpDate=$p(cert,"^",2)
	.s count=count+1
	.s mcode=InciCode ;院内耗材唯一码
	.s mname=InciDesc ;物料名称
	.s PRODISTRICTCODE="" ;省级行政区划代码
	.s orgcode="" ;组织机构代码
	.s UPLOADDATE=$zd(+$h,3)_$zt($p($h,",",2),3)  ;数据上报日期
	.s SERIALNUM=count ;流水号
	.s GJMATERCODE=InciCode ;国家药管平台耗材编码
	.s PRMATERIALCODE=InciCode ;省级耗材集中采购平台耗材编码
	.s APPROVALNO=CertNo ;批准文号
	.s MATERIALNAME=InciDesc ;品种通用名
	.s PRODUCTNAME=InciDesc ;产品通用名
	.s TRADENAME=InciDesc ;商品名
	.s TRADENAMEEN="" ;商品名(英文)
	.s PRODUCER=ManfName ;生产企业
	.s materialspec=Spec ;耗材规格
	.s materialtype=Model ;型号
	.s meascode=BuomCode ;计量单位编码 
	.s measname=BuomDesc ;计量单位名称
	.s DOSAGEUNIT=PuomDesc ;耗材单位
	.s PACKUNIT=BuomDesc ;耗材单位
	.s MATERIALFACTOR=packageQuantity ;转换系数
	.s ISUNITYPURCHASE="" ;是否网上集中采购耗材
	.s ISBASEMATER="" ;是否基本耗材
	.s ISUNIFORMITY="" ;是否通过一致性评价
	.s ORGANIZATIONNAME="" ;组织机构名称
	.s LASTUPDATEDATE=$zd(+$h,3)_$zt($p($h,",",2),3)  ;最后修改时间
	.d OutputRowBaseInfo
	Quit $$$OK

OutputRowBaseInfo
	s Data=$lb(orgcode,inci,mcode,mname,meascode,measname,materialspec,materialtype)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

/// Descript:	耗材库存信息表 	REPORT_MATERIAL_STOCK
/// Creater:	lihui
/// CreateDate:	20191110
/// Table:		
/// Input:
/// Return:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI","QueryMatStockInfo","locid^startdate...")
Query QueryMatStockInfo(StrParam As %String) As web.DHCSTMHUI.Query(ROWSPEC = "orgcode:%String,NO:%String,DATE:%String,STORECODE:%String,BATCHNO:%String,TYPECODE:%String,TYPENAME:%String,MATERIALCODE:%String,MATERIALNAME:%String,materialspec:%String,SERIALNO:%String,COUNT:%String,UNIT:%String,PRICEUNIT:%String,PRICESPEC:%String,IMPORTPRICE:%String,IMPORTAMOUNT:%String,RETAILPRICE:%String,RETAILAMOUNT:%String,PLACENO:%String,VALIDDATE:%String,ALLOTDEPT:%String,SUPPLIER:%String,PRODUCER:%String,CLEARDATE:%String,LASTUPDATEDATE:%String") [ SqlProc ]
{
}

ClassMethod QueryMatStockInfoExecute(ByRef qHandle As %Binary, StrParam As %String) As %Status
{
	n (qHandle,StrParam)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s LocId=$p(StrParam,"^",1)
	s StkDate=$p(StrParam,"^",2)
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=$zdh(StkDate,3)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"","")
	s update=$zd(+$h,3)
	s uptime=$zt($p($h,",",2),3)
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:(+Inci=0)||(Inci="")  d
	.q:'$d(^INCI(Inci))
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgDesc=$p(StkGrpInfo,"^",2)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	.s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.s ArcItmCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcItemCat(Inci)
	.s ItemCatId=$p(ArcItmCatInfo,"^",1)
	.s InsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInsuCat(Inci)
	.s Insu=$p(InsuInfo,"^",1)
	.s OfficalCode=$p(InsuInfo,"^",3)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfDr=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.s ItmImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImpFlag(Inci)
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(Inci)
	.s BillUomDr=$P(BillUomStr,"^",1)
	.s BillUomDesc=$P(BillUomStr,"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s il=0
	.f  s il=$o(^INCI(Inci,"IL",il)) q:il=""  d
	..q:($d(^INCI(Inci,"IL",il))=0)||($d(^INCI(Inci,"IL",il))=10)
	..s Incil=Inci_"||"_il
	..s PhaLoc=$p(^INCI(Inci,"IL",il),"^",1)
	..q:(LocId'="")&&(PhaLoc'=LocId)
	..s PhaLocDesc=$P(^CTLOC(PhaLoc),"^",2)
	..s HospId=$p(^CTLOC(PhaLoc),"^",22)
	..s IncsbDesc =##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(PhaLoc,Inci)
	..s IncsbDesc=$p(IncsbDesc,"^",1)
	..s LastReailPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,StkDate,PurUomId,HospId)
	..
	..s lb=0
	..f  s lb=$o(^INCI(Inci,"IL",il,"LB",lb)) q:lb=""  d
	...s Inclb=Incil_"||"_lb
	...s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	...s VendorStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	...s vendorid=$p($g(VendorStr),"^",1)
	...s vendorname=$p($g(VendorStr),"^",2)
	...s ManfStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	...s ManfDr=$p(ManfStr,"^",1)
	...s Manf=$p(ManfStr,"^",2)
	...s BatchNo=$p(BatExp,"^",1)
	...s ExpDate=$p(BatExp,"^",2)
	...s Incib=$p(^INCI(Inci,"IL",il,"LB",lb),"^",1)
	...s StockQty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,StkDate)
	...s PurStockQty = StockQty / Fac
	...s SalePrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,StkDate,PurUomId,HospId)
	...s SpAmt = SalePrice * PurStockQty
	...s Rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId)
	...s RpPuom=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,PurUomId,HospId)
	...s RpAmt=$g(Rp)*$g(StockQty)
	...s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	...s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	...s orgcode="" ;组织机构代码
	...s NO=Inclb ;序列号
	...s DATE="" ;日期
	...s STORECODE=PhaLocDesc ;库存单元
	...s BATCHNO=BatchNo ;批次
	...s TYPECODE=IncscCode ;类别代码
	...s TYPENAME=InciDesc ;类别名称
	...s MATERIALCODE=InciCode ;物品代码
	...s MATERIALNAME=InciDesc ;物品名称
	...s materialspec=Spec ;规格
	...s SERIALNO=Inclb ;批号
	...s COUNT=PurStockQty ;数量
	...s UNIT=PurchCTUomDesc ;单位
	...s PRICEUNIT=BillUomDesc ;账单单位
	...s PRICESPEC=Spec ;计价规格
	...s IMPORTPRICE=RpPuom ;进货价
	...s IMPORTAMOUNT=RpAmt ;进货金额
	...s RETAILPRICE=SalePrice ;零售价
	...s RETAILAMOUNT=SpAmt ;零售金额
	...s PLACENO="" ;货架
	...s VALIDDATE=$zd(ExpDate,3) ;有效期
	...s ALLOTDEPT="" ;请购科室
	...s SUPPLIER=vendorname ;供应商
	...s PRODUCER=Manf ;生产厂家
	...s CLEARDATE="" ;消毒日期
	...s LASTUPDATEDATE=$zd(+$h,3)_$zt($p($h,",",2),3)  ;最后修改时间
	...
	...d OutPutRowMatStockInfo
	
	Quit $$$OK
OutPutRowMatStockInfo
	s Data=$lb(orgcode,NO,DATE,STORECODE,BATCHNO,TYPECODE,TYPENAME,MATERIALCODE,MATERIALNAME,materialspec,SERIALNO,COUNT,UNIT,PRICEUNIT,PRICESPEC,IMPORTPRICE,IMPORTAMOUNT,RETAILPRICE,RETAILAMOUNT,PLACENO,VALIDDATE,ALLOTDEPT,SUPPLIER,PRODUCER,CLEARDATE,LASTUPDATEDATE)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	耗材出入库信息表 	REPORT_MATERIAL_IO
/// Creater:	lihui
/// CreateDate:	20191110
/// Table:		
/// Input:
/// Return:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI","QueryMoveInfo","2017-10-29,2018-01-29,153")	
Query QueryMoveInfo(Paramstr As %String) As web.DHCSTMHUI.Query(ROWSPEC = "orgcode:%String,NO:%String,IODATE:%String,STORAGEUNIT:%String,IOMARK:%String,IOTYPE:%String,INVOICENO:%String,TYPECODE:%String,TYPENAME:%String,MATERIALCODE:%String,MATERIALNAME:%String,materialspec:%String,COUNT:%String,UNIT:%String,BATCHNO:%String,IMPORTPRICE:%String,IMPORTAMOUNT:%String,RETAILPRICE:%String,RETAILAMOUNT:%String,PRICEITEMUNIT:%String,PRICESPEC:%String,BEGINCOUNT:%String,ENDCOUNT:%String,IMPORTBEGINAMOUNT:%String,IMPORTENDAMOUNT:%String,RETAILBEGINAMOUNT:%String,RETIALENDAMOUNT:%String,DEBIT:%String,CREDIT:%String,KEEPNO:%String,MAKER:%String,ALLOTDEPT:%String,EXPENSEACCOUNTNO:%String,SOURCENO:%String,SOURCESEEDNO:%String,LOGNO:%String,LASTUPDATEDATE:%String") [ SqlProc ]
{
}

ClassMethod QueryMoveInfoExecute(ByRef qHandle As %Binary, Paramstr As %String) As %Status
{
	n (qHandle,Paramstr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Loc=$p(Paramstr,"^",1)
	s StartDate=$p(Paramstr,"^",2)
	s EndDate=$p(Paramstr,"^",3)
	q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK

	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:StartDate["/" StartDate=$zdh(StartDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)


	s LocDesc=$p(^CTLOC(Loc),"^",2)
	f Date=StartDate:1:EndDate d
	.s ItmDr=0
	.f  s ItmDr=$o(^INCI("IL_LOC",Loc,ItmDr)) q:ItmDr=""  d
	..q:$o(^DHCLOCTOT(0,"LOCITMDATE",Loc,ItmDr,Date+1),-1)=""
	..s Chl=$o(^INCI("IL_LOC",Loc,ItmDr,0))
	..s Incil=ItmDr_"||"_Chl
	..s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmDr)
	..s ScgDesc=$p(StkGrpInfo,"^",2)
	..s Scg=$p(StkGrpInfo,"^",5)
	..s ScgType=$p(StkGrpInfo,"^",3)
	..q:ScgType'=..sssCode()
	..s Incsc=$p(^INCI(ItmDr,2),"^",2)
	..s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	..s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)
	..s InciCode = $p(^INCI(ItmDr,1),"^",1)
	..s InciDesc = $p(^INCI(ItmDr,1),"^",2)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",ItmDr)
	..s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(ItmDr)
	..s BillUomDr=$P(BillUomStr,"^",1)
	..s BillUomDesc=$P(BillUomStr,"^",2)
	..s BUomId=$p(^INCI(ItmDr,1),"^",10)
	..s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	..s PurUomId=$p(^INCI(ItmDr,3),"^",6)
	..s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")
	..s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s HospId=$p(^CTLOC(Loc),"^",22)
	..s TmpDate=StartDate-1
	..s BegQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(ItmDr,Loc,BUomId,TmpDate)  ;期初库存(基本数量)
	..s BegQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,BegQty)
	..s DaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmDr,TmpDate,BUomId,HospId)
	..s BegSpAmt=BegQty*DaySp
	..s BegRpAmt=##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty(Incil,TmpDate)
	..
	..s EndQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(ItmDr,Loc,BUomId,EndDate)
	..s EndDaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmDr,EndDate,BUomId,HospId)
	..s EndSpAmt=EndQty*EndDaySp
	..s EndRpAmt=##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty(Incil,EndDate)
	..
	..s TrId="" 
	..f  s TrId=$o(^DHCINTR(0,"INCI",ItmDr,Date,TrId)) q:TrId=""  d
	...q:'$d(^DHCINTR(TrId))
	...s Inclb=$p(^DHCINTR(TrId),"^",7)
	...q:Inclb=""
	...s TmpIncil=$p(Inclb,"||",1,2)
	...q:Incil'=TmpIncil           ;非统计科室库存
	...s Incib=$p(^INCI(ItmDr,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
	...s (BatNo,ExpDate)=""
	...i Incib'=""  d
	....s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	....s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	....s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	...s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
	...s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
	...s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
	...s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
	...s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
	...s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
	...s OperateUser=""
	...s:TrUser'="" OperateUser=$p(^SSU("SSUSR",TrUser),"^",2)
	...s TrTime=$p(^DHCINTR(TrId),"^",3)
	...s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
	...s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
	...s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
	...s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
	...s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
	...s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
	...s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	...s TrQtyB=TrQty*FacTr              ;基本单位数量
	...s BUomSp=TrSp/FacTr               ;基本单位售价
	...s PurUomSp=BUomSp*Factor          ;包装单位售价
	...s BUomRp=TrRp/FacTr    //##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
	...s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
	...s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
	...s Manf=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	...i Manf'=""  s Manf=$p(Manf,"^",2)
	...s TEndQty=StkQty  //EndQty+TrQtyB         ;本条记录的结余库存
	...s TEndQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,EndQty)
	...s TEndQtyUomInclb=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,StkLbQty)
	...s TrQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,TrQtyB)
	...s TEndSpAmt=EndSpAmt+TrSpAmt       ;结余金额(售价)
	...s TEndRpAmt=EndRpAmt+TrRpAmt         ;结余金额(进价)
	...s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetInclbVend(Inclb,Date)  ;该批次对应的最后一次入库的供应商
	...s Vendor=$p(VendorInfo,"^",2)
	...s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
	...
	...s TrAdm="BX",TrMsg="BX"
	...
	...i (TrType="P")||(TrType="PM")||(TrType="MP") d
	....s TrMsg="物资住院医嘱"        ;摘要
	....;s oeori=$$GetPHPORI(TrPointer)
	....;s OrdInfo=..GetOrdInfo(oeori)
	....s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
	....s TrAdm=$p(OrdInfo,"^",1)
	....s TrNo=$p(OrdInfo,"^",2)
	...
	...i (TrType="Y")||(TrType="YM")||(TrType="MY") d
	....s TrMsg="物资住院医嘱废除"
	....;s oeori=$$GetPHYORI(TrPointer)
	....;s OrdInfo=..GetOrdInfo(oeori)
	....s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
	....s TrAdm=$p(OrdInfo,"^",1)
	....s TrNo=$p(OrdInfo,"^",2)
	...
	...i (TrType="F")||(TrType="MF") d
	....s TrMsg="物资门诊医嘱"
	....;s oeori=$$GetORI(TrPointer)
	....;s OrdInfo=..GetOrdInfo(oeori)
	....s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
	....s TrAdm=$p(OrdInfo,"^",1)
	....s TrNo=$p(OrdInfo,"^",2)
	....
	...
	...i (TrType="H")||(TrType="MH") d
	....s TrMsg="物资门诊医嘱废除"
	....;s oeori=$$GetRetORI(TrPointer)
	....;s OrdInfo=..GetOrdInfo(oeori)
	....s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
	....s TrAdm=$p(OrdInfo,"^",1)
	....s TrNo=$p(OrdInfo,"^",2)
	....
	...
	...i TrType="S" d
	....s TrMsg="物资非正常医嘱"
	....q:'$d(^DHCINAD($p(TrPointer,"||",1)))
	....q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
	....s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
	....
	...
	...i TrType="Z" d
	....s TrMsg="物资非正常医嘱废除"
	....q:'$d(^DHCINAD($p(TrPointer,"||",1)))
	....q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
	....s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
	....
	...
	...i TrType="K" d
	....s TrMsg="转移入库" 
	....q:'$d(^DHCINIT($p(TrPointer,"||",1)))
	....q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",5)=""
	....s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",5)),"^",2)   ;出库科室
	....
	...
	...i (TrType="T")!(TrType="I") d
	....s TrMsg="转移出库"
	....q:'$d(^DHCINIT($p(TrPointer,"||",1)))
	....q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",6)=""
	....s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",6)),"^",2)    ;转入科室
	....
	...
	...i TrType="G" d
	....s TrMsg="入库"
	....q:'$d(^DHCINGR($p(TrPointer,"||",1)))
	....q:$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)=""
	....;q:'$d(^DHCINGR("APCVM",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)))
	....s TrAdm=$p(^SSU("SSUSR",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)),"^",2) 
	....
	...
	...i TrType="D" d
	....s TrMsg="库存报损"
	....s INSPId=$p(TrPointer,"||",1)
	....q:'$d(^DHCINSP(INSPId))
	....q:$p(^DHCINSP(INSPId),"^",6)=""
	....s TrAdm=$p(^SSU("SSUSR",$p(^DHCINSP(INSPId),"^",6)),"^",2)
	....
	...
	...i TrType="A" d
	....s TrMsg="库存调整"
	....q:'$d(^DHCINAD($p(TrPointer,"||",1)))
	....q:$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)=""
	....s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
	....
	...
	...i TrType="R" d
	....s TrMsg="退货"
	....s INGRT=$p(TrPointer,"||",1)
	....q:INGRT=""
	....q:'$d(^INGRT(INGRT))
	....q:$p(^INGRT(INGRT),"^",5)=""
	....s TrAdm=$p(^SSU("SSUSR",$p(^INGRT(INGRT),"^",5)),"^",2)
	....
	...
	...i TrType="M" d
	....s TrMsg="制剂加工"
	....q:'$d(^DHCINMAN(TrPointer))
	....s Manuser=$p(^DHCINMAN(TrPointer),"^",23)
	....q:Manuser=""
	....s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
	....
	...
	...i TrType="X" d
	....s TrMsg="制剂消耗"
	....q:'$d(^DHCINMAN(+TrPointer)) 
	....s Manuser=$p(^DHCINMAN(+TrPointer),"^",23)
	....q:Manuser=""
	....s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
	....
	...
	...i TrType="C" d
	....s TrMsg="科室内发放"
	....q:'$d(^DHCINDS(+TrPointer))
	....s userDr=$p(^DHCINDS(+TrPointer),"^",4)
	....q:userDr=""
	....s TrAdm=$p(^SSU("SSUSR",userDr),"^",2)
	...
	...i TrType="L" d
	....s TrMsg="科室内退回"
	....q:'$d(^DHCINDSR(+TrPointer))
	....s userDr=$p(^DHCINDSR(+TrPointer),"^",4)
	....q:userDr=""
	....s TrAdm=$p(^SSU("SSUSR",userDr),"^",2)
	...
	...s orgcode="" ;组织机构代码
	...s NO=TrId ;序列号
	...s IODATE=$zd(Date,3) ;出入库日期
	...s STORAGEUNIT=LocDesc ;出入库单元
	...i (","_TrType_",")'[(",G,R,T,K,")  d
	....s IOMARK=1  ;出入库标志
	...e  d
	....s IOMARK=0
	...s IOTYPE=TrMsg ;出入库类型
	...s INVOICENO="" ;发票号
	...s TYPECODE=IncscCode ;类别代码
	...s TYPENAME=IncscDesc ;类别名称
	...s MATERIALCODE=InciCode ;物品代码
	...s MATERIALNAME=InciDesc ;物品名称
	...s materialspec=Spec ;规格
	...s COUNT=TrQtyB ;数量
	...s UNIT=BUomDesc ;单位
	...s BATCHNO=BatNo ;批次
	...s IMPORTPRICE=BUomRp ;进货价
	...s IMPORTAMOUNT=TrRpAmt ;进货金额
	...s RETAILPRICE=BUomSp ;零售价
	...s RETAILAMOUNT=TrSpAmt ;零售金额
	...s PRICEITEMUNIT=BillUomDesc ;账单单位
	...s PRICESPEC=Spec ;计价规格
	...s BEGINCOUNT=BegQty ;期初数量
	...s ENDCOUNT=EndQty ;期末数量
	...s IMPORTBEGINAMOUNT=BegRpAmt ;期初进货金额
	...s IMPORTENDAMOUNT=EndRpAmt ;期末进货金额
	...s RETAILBEGINAMOUNT=BegSpAmt ;期初零售金额
	...s RETIALENDAMOUNT=EndSpAmt ;期末零售金额
	...s DEBIT="" ;发货方
	...s CREDIT="" ;收货方
	...s KEEPNO="" ;结存号
	...s MAKER=TrAdm ;开单人
	...s ALLOTDEPT=TrAdm ;请购科室
	...s EXPENSEACCOUNTNO="" ;报销单号
	...s SOURCENO=TrNo ;来源单据号
	...s SOURCESEEDNO="" ;
	...s LOGNO="" ;账页号
	...s LASTUPDATEDATE=$zd(+$h,3)_$zt($p($h,",",2),3)  ;最后修改时间
	...
	...d OutPutRowMoveInfo

	Quit $$$OK
OutPutRowMoveInfo
	s Data=$lb(orgcode,NO,IODATE,STORAGEUNIT,IOMARK,IOTYPE,INVOICENO,TYPECODE,TYPENAME,MATERIALCODE,MATERIALNAME,materialspec,COUNT,UNIT,BATCHNO,IMPORTPRICE,IMPORTAMOUNT,RETAILPRICE,RETAILAMOUNT,PRICEITEMUNIT,PRICESPEC,BEGINCOUNT,ENDCOUNT,IMPORTBEGINAMOUNT,IMPORTENDAMOUNT,RETAILBEGINAMOUNT,RETIALENDAMOUNT,DEBIT,CREDIT,KEEPNO,MAKER,ALLOTDEPT,EXPENSEACCOUNTNO,SOURCENO,SOURCESEEDNO,LOGNO,LASTUPDATEDATE)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod NewPid() As %String
{
	q $I(^DHCSTMYYPID("DHCSTMYY"))
}

/// 物资信息(集成平台调用)
/// 20200715 lihui
/// w ##class(web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI).QueryMatBaseInfoYY()
ClassMethod QueryMatBaseInfoYY() As %String
{
	new
	s pid=..NewPid()
	k ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMatBaseInfoYY",pid)
	s inci=0,count=0
	f  s inci=$o(^INCI(inci)) q:+inci=0  d
	.s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s TmpStkGrpdesc=$p(tmpstkgrp,"^",3)	
	.q:TmpStkGrpdesc'="M"
	.s notuse=$p(^INCI(inci,2),"^",9)
	.q:notuse="Y"
	.s InciCode=$P(^INCI(inci,1),"^",1)
	.s InciDesc=$P(^INCI(inci,1),"^",2)
	.s PuomDr=$P(^INCI(inci,3),"^",6)
	.s PuomDesc=$s(PuomDr'="":$P(^CT("UOM",PuomDr),"^",2),1:"")
	.s BuomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncBuom(inci)
	.s BuomDr=$P(BuomStr,"^",1)
	.s BuomCode=$s(BuomDr'="":$P(^CT("UOM",BuomDr),"^",1),1:"")
	.s BuomDesc=$P(BuomStr,"^",2)
	.s packageQuantity=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
	.s Spec=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	.s Model=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
	.s Brand=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci)
	.s Abbrev=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAbbrev(inci)
	.s ManfStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci)
	.s Manfdr=$P(ManfStr,"^",1)
	.s ManfCode=$P(ManfStr,"^",2)
	.s ManfName=$P(ManfStr,"^",3)
	.s IncCatId=$p(^INCI(inci,2),"^",2)
	.s IncCat=$s(IncCatId'="":$p(^INC("SC",IncCatId),"^",2),1:"")
	.s cert=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(inci)
	.s CertNo=$p(cert,"^",1)
	.s CertExpDate=$p(cert,"^",2)
	.s count=count+1
	.s mcode=InciCode ;院内耗材唯一码
	.s mname=InciDesc ;物料名称
	.s orgcode="" ;组织机构代码
	.s materialspec=Spec ;耗材规格
	.s materialtype=Model ;型号
	.s meascode=BuomCode ;计量单位编码 
	.s measname=BuomDesc ;计量单位名称
	.s ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMatBaseInfoYY",pid,inci)=orgcode_"^"_inci_"^"_mcode_"^"_mname_"^"_meascode_"^"_measname_"^"_materialspec_"^"_materialtype
	q pid_"^"_count
}

/// 供应商(集成平台调用)
/// w ##class(web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI).GetVendInfo()
ClassMethod GetVendInfo() As %String
{
	new
	s pid=..NewPid()
	s count=0
	s venid=0
	f  s venid=$o(^APC("APCVM",venid)) q:(venid="")||(venid=0)  d
	.s vendCode=$p(^APC("APCVM",venid),"^",2)
	.s vendDesc=$p(^APC("APCVM",venid),"^",3)
	.s hospcode="" ;组织结构代码
	.s count=count+1
	.s ^TMP("DHCST","web.QueryAllMatInfoUI","GetVendor",pid,venid)=venid_"^"_vendCode_"^"_vendDesc_"^"_hospcode
	q pid_"^"_count
}

/// 入库(集成平台调用)
/// 20200715 lihui
/// w ##class(web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI).QueryMoveInfoINGRYY("392^2019-09-09^2020-09-09")
ClassMethod QueryMoveInfoINGRYY(Paramstr) As %String
{
	s pid=..NewPid()
	k ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINGR",pid)
	k ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINGRDetail",pid)
	
	s Loc=$p(Paramstr,"^",1)
	 s StartDate=$p(Paramstr,"^",2)
	 s EndDate=$p(Paramstr,"^",3)
	 q:Loc="" $$$OK
	 q:StartDate="" $$$OK
	 q:EndDate="" $$$OK
	 
	 s:StartDate["-" StartDate=$zdh(StartDate,3)
	 s:EndDate["-" EndDate=$zdh(EndDate,3)
	 s:StartDate["/" StartDate=$zdh(StartDate,4)
	 s:EndDate["/" EndDate=$zdh(EndDate,4)    
	 
	 s LocCode=$p(^CTLOC(Loc),"^",1)
	 s LocDesc=$p(^CTLOC(Loc),"^",2)
	 s count=0,maincount=0
	 f Date=StartDate:1:EndDate d
	 .s ItmDr=0
	 .f  s ItmDr=$o(^INCI("IL_LOC",Loc,ItmDr)) q:ItmDr=""  d
	 ..q:$o(^DHCLOCTOT(0,"LOCITMDATE",Loc,ItmDr,Date+1),-1)=""
	 ..s Chl=$o(^INCI("IL_LOC",Loc,ItmDr,0))
	 ..s Incil=ItmDr_"||"_Chl
	 ..s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmDr)
	 ..s ScgDesc=$p(StkGrpInfo,"^",2)
	 ..s Scg=$p(StkGrpInfo,"^",5)
	 ..s ScgType=$p(StkGrpInfo,"^",3)
	 ..q:ScgType'=..sssCode()
	 ..s Incsc=$p(^INCI(ItmDr,2),"^",2)
	 ..s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	 ..s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)
	 ..s InciCode = $p(^INCI(ItmDr,1),"^",1)
	 ..s InciDesc = $p(^INCI(ItmDr,1),"^",2)
	 ..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",ItmDr)
	 ..s Model=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(ItmDr)
	 ..s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(ItmDr)
	 ..s BillUomDr=$P(BillUomStr,"^",1)
	 ..s BillUomCode=$s(BillUomDr'="":$p(^CT("UOM",BillUomDr),"^",1),1:"")
	 ..s BillUomDesc=$P(BillUomStr,"^",2)
	 ..s BUomId=$p(^INCI(ItmDr,1),"^",10)
	 ..s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	 ..s PurUomId=$p(^INCI(ItmDr,3),"^",6)
	 ..s PurUomCode=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",1),1:"")
	 ..s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")
	 ..s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	 ..s HospId=$p(^CTLOC(Loc),"^",22)
	 ..s TmpDate=StartDate-1
	 ..s BegQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(ItmDr,Loc,BUomId,TmpDate)  ;期初库存(基本数量)
	 ..s BegQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,BegQty)
	 ..s DaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmDr,TmpDate,BUomId,HospId)
	 ..s BegSpAmt=BegQty*DaySp
	 ..s BegRpAmt=##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty(Incil,TmpDate)
	 ..
	 ..s EndQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(ItmDr,Loc,BUomId,EndDate)
	 ..s EndDaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmDr,EndDate,BUomId,HospId)
	 ..s EndSpAmt=EndQty*EndDaySp
	 ..s EndRpAmt=##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty(Incil,EndDate)
	 ..s InciBinStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(Incil)
	 ..s incscdesc=$p(InciBinStr,":",2)
	 ..s incsccode=""
	 ..i incscdesc'="" d
	 ...s incsc=$o(^INC("SB",0,"Desc",incscdesc,""))
	 ...s incsccode=$p(^INC("SB",incsc),"^",1)
	 ..
	 ..s TrId="" 
	 ..f  s TrId=$o(^DHCINTR(0,"INCI",ItmDr,Date,TrId)) q:TrId=""  d
	 ...q:'$d(^DHCINTR(TrId))
	 ...s Inclb=$p(^DHCINTR(TrId),"^",7)
	 ...q:Inclb=""
	 ...s TmpIncil=$p(Inclb,"||",1,2)
	 ...q:Incil'=TmpIncil           ;非统计科室库存
	 ...s Incib=$p(^INCI(ItmDr,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
	 ...s (BatNo,ExpDate)=""
	 ...i Incib'=""  d
	 ....s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	 ....s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	 ....s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	 ...s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
	 ...q:(TrType'="G")&&(TrType'="R")
	 ...s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
	 ...s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
	 ...s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
	 ...s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
	 ...s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
	 ...s OperateUser=""
	 ...s:TrUser'="" OperateUser=$p(^SSU("SSUSR",TrUser),"^",2)
	 ...s TrTime=$p(^DHCINTR(TrId),"^",3)
	 ...s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
	 ...s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
	 ...s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
	 ...s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
	 ...s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
	 ...s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
	 ...s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	 ...s TrQtyB=TrQty*FacTr              ;基本单位数量
	 ...s BUomSp=TrSp/FacTr               ;基本单位售价
	 ...s PurUomSp=BUomSp*Factor          ;包装单位售价
	 ...s BUomRp=TrRp/FacTr    //##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
	 ...s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
	 ...s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
	 ...s Manfinfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	 ...s manfid=$p(Manfinfo,"^",1)
	 ...s ManfCode=$s(manfid'="":$p(^PHMNF(manfid),"^",1),1:"")
	 ...s Manf=$p(Manfinfo,"^",2)
	 ...s TEndQty=StkQty  //EndQty+TrQtyB         ;本条记录的结余库存
	 ...s TEndQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,EndQty)
	 ...s TEndQtyUomInclb=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,StkLbQty)
	 ...s TrQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,TrQtyB)
	 ...s TEndSpAmt=EndSpAmt+TrSpAmt       ;结余金额(售价)
	 ...s TEndRpAmt=EndRpAmt+TrRpAmt         ;结余金额(进价)
	 ...s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetInclbVend(Inclb,Date)  ;该批次对应的最后一次入库的供应商
	 ...s venid=$p(VendorInfo,"^",1)
	 ...s VendCode=$s(venid'="":$p(^APC("APCVM",venid),"^",1),1:"")
	 ...s Vendor=$p(VendorInfo,"^",2)
	 ...s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
	 ...
	 ...s (OpTypeCode,OpTypeDesc,UserName,UserInitial,UomCode,UomDesc,ProduceDate)=""
	 ...i (TrType="G") d
	 ....s TrMsg="入库"
	 ....q:'$d(^DHCINGR($p(TrPointer,"||",1)))
	 ....q:$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)=""
	 ....s UserInitial=$p(^SSU("SSUSR",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)),"^",1)
	 ....s UserName=$p(^SSU("SSUSR",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)),"^",2)
	 ....s ingrInfo=^DHCINGR(+TrPointer)
	 ....s OpTypeDr=$p(ingrInfo,"^",23)  //入库类型
	 ....s OpTypeCode=$p(^DHCOPTYPE(OpTypeDr),"^",1)
	 ....s OpTypeDesc=$p(^DHCOPTYPE(OpTypeDr),"^",2)
	 ....s ingritminfo=^DHCINGR(+TrPointer,"GRI",$p(TrPointer,"||",2))
	 ....s uomid=$p(ingritminfo,"^",10)
	 ....s UomCode=$s(uomid'="":$p(^CT("UOM",uomid),"^",1),1:"")
	 ....s UomDesc=$s(uomid'="":$p(^CT("UOM",uomid),"^",1),1:"")
	 ....s ProduceDate=$p(ingritminfo,"^",49)
	 ....s ProduceDate=$zd(ProduceDate,3)
	 ...
	 ...
	 ...i (TrType="R") d
	 ....s TrMsg="退货"
	 ....s INGRT=$p(TrPointer,"||",1)
	 ....q:INGRT=""
	 ....q:'$d(^INGRT(INGRT))
	 ....q:$p(^INGRT(INGRT),"^",5)=""
	 ....s UserInitial=$p(^SSU("SSUSR",$p(^INGRT(INGRT),"^",5)),"^",1)
	 ....s UserName=$p(^SSU("SSUSR",$p(^INGRT(INGRT),"^",5)),"^",2)
	 ....s ingrtitminfo=^INGRT(INGRT,"DHCGRR",$p(TrPointer,"||",2))
	 ....s uomid=$p(ingrtitminfo,"^",3)
	 ....s UomCode=$s(uomid'="":$p(^CT("UOM",uomid),"^",1),1:"")
	 ....s UomDesc=$s(uomid'="":$p(^CT("UOM",uomid),"^",1),1:"")
	 ....
	 ....
	 ...
	 ...s count=count+1
	 ...s orgcode="" ;组织机构代码
	 ...s orgname="" ;组织机构名称
	 ...s billhid=+TrPointer ;入库单主键
	 ...s billcode=TrNo ;入库单号
	 ...s vbilldate=Date
	 ...s vbilldate=$zd(vbilldate,3) ;单据日期
	 ...s doccode=LocCode ;仓库编码
	 ...s docname=LocDesc ;仓库名称
	 ...s btcode=OpTypeCode ;入库类型编码
	 ...s btname=OpTypeDesc ;入库类型名称
	 ...s pcode=UserInitial ;库管员编码
	 ...s pname=UserName ;库管员名称
	 ...s deptcode=""
	 ...s deptname=""
	 ...s ntotalnum=0
	 ...s Remark=""
	 ...i '$d(^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINGR",pid,+TrPointer)) d
	 ....s maincount=maincount+1
	 ....s ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINGR",pid,+TrPointer)=orgcode_"^"_orgname_"^"_+TrPointer_"^"_billcode_"^"_vbilldate_"^"_doccode_"^"_docname_"^"_btcode_"^"_btname_"^"_pcode_"^"_pname_"^"_deptcode_"^"_deptname_"^"_ntotalnum_"^"_Remark
	 ...s billbid=TrPointer
	 ...s crowno=count
	 ...s mcode=InciCode ;物料编码
	 ...s mname=InciDesc ;物料名称
	 ...s materialspec=Spec ;规格
	 ...s materialtype=Model ;型号
	 ...s meascode=UomCode ;计量单位编码
	 ...s measname=UomDesc ;计量单位名称 
	 ...s nassistnum=TrQty ;数量
	 ...s price=0
	 ...s nmny=TrRpAmt ;金额
	 ...s costprice=TrRp ;成本价
	 ...s mainmeascode=PurUomCode ;主计量单位编码
	 ...s mainmeasname=PurUomDesc ;主计量单位名称 
	 ...s vchangerate=Factor ;换算率
	 ...s vbatchcode=BatNo ;批次号
	 ...s vserialcode="" ;序列号
	 ...s barcode=HVBarCode ;条形码
	 ...s dproducedate=ProduceDate ;生产日期
	 ...s dvalidate=ExpDate ;失效日期
	 ...s dbizdate=vbilldate
	 ...s procode=ManfCode ;生产厂商编码
	 ...s proname=Manf ;生产厂商名称
	 ...s supcode=VendCode ;供应商编码 
	 ...s supname=Vendor ;供应商名称
	 ...s rcode=incsccode ;货位码
	 ...s rname=incscdesc ;货位
	 ...s vnotebody=""
	 ...s ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINGRDetail",pid,TrId)=billbid_"^"_crowno_"^"_mcode_"^"_mname_"^"_materialspec_"^"_materialtype_"^"_meascode_"^"_measname_"^"_nassistnum_"^"_price_"^"_nmny_"^"_costprice_"^"_mainmeascode_"^"_mainmeasname_"^"_vchangerate_"^"_vbatchcode_"^"_vserialcode_"^"_barcode_"^"_dproducedate_"^"_dvalidate_"^"_dbizdate_"^"_procode_"^"_proname_"^"_supcode_"^"_supname_"^"_rcode_"^"_rname_"^"_vnotebody
	q pid_"^"_maincount_"^"_count
}

/// 出库(集成平台调用)
/// 20200715 lihui
/// w ##class(web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI).QueryMoveInfoINITYY("392^2019-09-09^2020-09-09")
ClassMethod QueryMoveInfoINITYY(Paramstr) As %String
{
	n (Paramstr)
	s pid=..NewPid()
	k ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINIT",pid)
	k ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINITDetail",pid)

	s Loc=$p(Paramstr,"^",1)
	s StartDate=$p(Paramstr,"^",2)
	s EndDate=$p(Paramstr,"^",3)
	q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:Type="" $$$OK

	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:StartDate["/" StartDate=$zdh(StartDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)    

	s LocCode=$p(^CTLOC(Loc),"^",1)
	s LocDesc=$p(^CTLOC(Loc),"^",2)
	s count=0,maincount=0
	f Date=StartDate:1:EndDate d
	.s ItmDr=0
	.f  s ItmDr=$o(^INCI("IL_LOC",Loc,ItmDr)) q:ItmDr=""  d
	..q:$o(^DHCLOCTOT(0,"LOCITMDATE",Loc,ItmDr,Date+1),-1)=""
	..s Chl=$o(^INCI("IL_LOC",Loc,ItmDr,0))
	..s Incil=ItmDr_"||"_Chl
	..s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmDr)
	..s ScgDesc=$p(StkGrpInfo,"^",2)
	..s Scg=$p(StkGrpInfo,"^",5)
	..s ScgType=$p(StkGrpInfo,"^",3)
	..q:ScgType'=..sssCode()
	..s Incsc=$p(^INCI(ItmDr,2),"^",2)
	..s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	..s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)
	..s InciCode = $p(^INCI(ItmDr,1),"^",1)
	..s InciDesc = $p(^INCI(ItmDr,1),"^",2)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",ItmDr)
	..s Model=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(ItmDr)
	..s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(ItmDr)
	..s BillUomDr=$P(BillUomStr,"^",1)
	..s BillUomCode=$s(BillUomDr'="":$p(^CT("UOM",BillUomDr),"^",1),1:"")
	..s BillUomDesc=$P(BillUomStr,"^",2)
	..s BUomId=$p(^INCI(ItmDr,1),"^",10)
	..s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	..s PurUomId=$p(^INCI(ItmDr,3),"^",6)
	..s PurUomCode=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",1),1:"")
	..s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")
	..s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s HospId=$p(^CTLOC(Loc),"^",22)
	..s TmpDate=StartDate-1
	..s BegQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(ItmDr,Loc,BUomId,TmpDate)  ;期初库存(基本数量)
	..s BegQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,BegQty)
	..s DaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmDr,TmpDate,BUomId,HospId)
	..s BegSpAmt=BegQty*DaySp
	..s BegRpAmt=##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty(Incil,TmpDate)
	..
	..s EndQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(ItmDr,Loc,BUomId,EndDate)
	..s EndDaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmDr,EndDate,BUomId,HospId)
	..s EndSpAmt=EndQty*EndDaySp
	..s EndRpAmt=##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty(Incil,EndDate)
	..s InciBinStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(Incil)
	..s incscdesc=$p(InciBinStr,":",2)
	..s incsccode=""
	..i incscdesc'="" d
	...s incsc=$o(^INC("SB",0,"Desc",incscdesc,""))
	...s incsccode=$p(^INC("SB",incsc),"^",1)
	..
	..s TrId="" 
	..f  s TrId=$o(^DHCINTR(0,"INCI",ItmDr,Date,TrId)) q:TrId=""  d
	...q:'$d(^DHCINTR(TrId))
	...s Inclb=$p(^DHCINTR(TrId),"^",7)
	...q:Inclb=""
	...s TmpIncil=$p(Inclb,"||",1,2)
	...q:Incil'=TmpIncil           ;非统计科室库存
	...s Incib=$p(^INCI(ItmDr,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
	...s (BatNo,ExpDate)=""
	...i Incib'=""  d
	....s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	....s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	....s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	...s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
	...q:(TrType'="T")&&(TrType'="K")
	...s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
	...s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
	...s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
	...s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
	...s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
	...s OperateInitail=$s(TrUser'="":$p(^SSU("SSUSR",TrUser),"^",1),1:"")
	...s OperateUser=$s(TrUser'="":$p(^SSU("SSUSR",TrUser),"^",2),1:"")
	...s TrTime=$p(^DHCINTR(TrId),"^",3)
	...s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
	...s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
	...s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
	...s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
	...s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
	...s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
	...s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	...s TrQtyB=TrQty*FacTr              ;基本单位数量
	...s BUomSp=TrSp/FacTr               ;基本单位售价
	...s PurUomSp=BUomSp*Factor          ;包装单位售价
	...s BUomRp=TrRp/FacTr    //##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
	...s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
	...s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
	...s Manfinfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	...s manfid=$p(Manfinfo,"^",1)
	...s ManfCode=$s(manfid'="":$p(^PHMNF(manfid),"^",1),1:"")
	...s Manf=$p(Manfinfo,"^",2)
	...s TEndQty=StkQty  //EndQty+TrQtyB         ;本条记录的结余库存
	...s TEndQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,EndQty)
	...s TEndQtyUomInclb=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,StkLbQty)
	...s TrQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,TrQtyB)
	...s TEndSpAmt=EndSpAmt+TrSpAmt       ;结余金额(售价)
	...s TEndRpAmt=EndRpAmt+TrRpAmt         ;结余金额(进价)
	...s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetInclbVend(Inclb,Date)  ;该批次对应的最后一次入库的供应商
	...s venid=$p(VendorInfo,"^",1)
	...s VendCode=$s(venid'="":$p(^APC("APCVM",venid),"^",1),1:"")
	...s Vendor=$p(VendorInfo,"^",2)
	...s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
	...s OpTypeDr=$p(^DHCINIT(+TrPointer),"^",20)  //出库类型
	...s OpTypeCode=$p(^DHCOPTYPE(OpTypeDr),"^",1)
	...s OpTypeDesc=$p(^DHCOPTYPE(OpTypeDr),"^",2)
	...s uomid=$p(initinfo,"^",7)
	...s UomCode=$s(uomid'="":$p(^CT("UOM",uomid),"^",1),1:"")
	...s UomDesc=$s(uomid'="":$p(^CT("UOM",uomid),"^",1),1:"")
	...
	...s (TFLocCode,TFLocDesc)=""
	......i (TrType="K") d
	....s TrMsg="转移入库" 
	....q:'$d(^DHCINIT($p(TrPointer,"||",1)))
	....q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",5)=""
	....s initinfo=^DHCINIT(+TrPointer)
	....s tfLocid=$p(initinfo,"^",5)
	....s TFLocCode=$p(^CTLOC(tfLocid),"^",1)
	....s TFLocDesc=$p(^CTLOC(tfLocid),"^",2)
	....
	...
	...i (TrType="T") d
	....s TrMsg="转移出库"
	....q:'$d(^DHCINIT($p(TrPointer,"||",1)))
	....q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",6)=""
	....s initinfo=^DHCINIT(+TrPointer)
	....s tfLocid=$p(initinfo,"^",6)
	....s TFLocCode=$p(^CTLOC(tfLocid),"^",1)
	....s TFLocDesc=$p(^CTLOC(tfLocid),"^",2)
	....
	...
	...s count=count+1
	...s orgcode="" ;组织机构代码
	...s orgname="" ;组织机构名称
	...s billhid=+TrPointer ;出库单主键
	...s billcode=TrNo ;出库单号
	...s vbilldate=Date
	...s vbilldate=$zd(vbilldate,3) ;单据日期
	...s doccode=LocCode ;仓库编码
	...s docname=LocDesc ;仓库名称
	...s btcode=OpTypeCode ;出库类型编码
	...s btname=OpTypeDesc ;出库类型名称
	...s pcode=OperateInitail ;库管员编码
	...s pname=OperateUser ;库管员名称
	...s deptcode=TFLocCode ;入库科室代码
	...s deptname=TFLocDesc ;入库科室名称
	...s ntotalnum=0
	...s Remark=""
	...i '$d(^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINIT",pid,+TrPointer)) d
	....s maincount=maincount+1
	....s ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINIT",pid,+TrPointer)=orgcode_"^"_orgname_"^"_+TrPointer_"^"_billcode_"^"_vbilldate_"^"_doccode_"^"_docname_"^"_btcode_"^"_btname_"^"_pcode_"^"_pname_"^"_deptcode_"^"_deptname_"^"_ntotalnum_"^"_Remark
	...s billbid=TrPointer
	...s crowno=count
	...s mcode=InciCode ;物料编码
	...s mname=InciDesc ;物料名称
	...s materialspec=Spec ;规格
	...s materialtype=Model ;型号
	...s meascode=UomCode ;计量单位编码
	...s measname=UomDesc ;计量单位名称 
	...s nassistnum=TrQty ;数量
	...s price=0
	...s nmny=TrRpAmt ;金额
	...s costprice=TrRp ;成本价
	...s mainmeascode=PurUomCode ;主计量单位编码
	...s mainmeasname=PurUomDesc ;主计量单位名称 
	...s vchangerate=Factor ;换算率
	...s vbatchcode=BatNo ;批次号
	...s vserialcode="" ;序列号
	...s barcode=HVBarCode ;条形码
	...s dproducedate="" ;生产日期
	...s dvalidate=ExpDate ;失效日期
	...s dbizdate=vbilldate
	...s procode=ManfCode ;生产厂商编码
	...s proname=Manf ;生产厂商名称
	...s supcode=VendCode ;供应商编码 
	...s supname=Vendor ;供应商名称
	...s rcode=incsccode ;货位码
	...s rname=incscdesc ;货位
	...s vnotebody=""
	...s ^TMP("DHCSTM","web.QueryAllMatInfoUI","QueryMoveInfoINITDetail",pid,TrId)=billbid_"^"_crowno_"^"_mcode_"^"_mname_"^"_materialspec_"^"_materialtype_"^"_meascode_"^"_measname_"^"_nassistnum_"^"_price_"^"_nmny_"^"_costprice_"^"_mainmeascode_"^"_mainmeasname_"^"_vchangerate_"^"_vbatchcode_"^"_vserialcode_"^"_barcode_"^"_dproducedate_"^"_dvalidate_"^"_dbizdate_"^"_procode_"^"_proname_"^"_supcode_"^"_supname_"^"_rcode_"^"_rname_"^"_vnotebody
	q pid_"^"_maincount_"^"_count
}

/// 库存请求
/// Author: lihui
/// Date: 20200721
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI","QueryMatReq")
Query QueryMatReq(StartDate, EndDate) As %Query(ROWSPEC = "reqitmid:%String,ReqLocid:%String,ReqLoc:%String,ssuserid:%String,ssuser:%String,date:%String,InciCode:%String,InciDesc:%String,Spec:%String,Uom:%String,qty:%String,regUser:%String,regDate:%String,remark:%String") [ SqlProc ]
{
}

ClassMethod QueryMatReqExecute(ByRef qHandle As %Binary, StartDate, EndDate) As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	f date=StartDate:1:EndDate   d
	.s ReqId=""
	.f  s ReqId=$O(^INRQ(0,"Date",date,ReqId)) q:ReqId=""  d
	..q:'$d(^INRQ(ReqId))
	..s reginfo=^INRQ(ReqId)
	..s ReqLocid=$p(reginfo,"^",6)
	..s ReqLoc=$p(^CTLOC(ReqLocid),"^",2)
	..s ssuserid=$p(reginfo,"^",4)
	..s ssuser=$p(^SSU("SSUSR",ssuserid),"^",2)
	..s chl=0
	..f  s chl=$o(^INRQ(ReqId,"RQI",chl)) q:chl=""  d
	...q:'$d(^INRQ(ReqId,"RQI",chl))
	...s reqitmid=ReqId_"||"_chl
	...s reqitminfo=^INRQ(ReqId,"RQI",chl)
	...s inci=$p(reqitminfo,"^",4)
	...s dhcid=$o(^DHCITMINFO(0,"INCI",inci,""))
	...q:dhcid=""
	...s Spec=$p(^DHCITMINFO(dhcid),"^",27)
	...s InciCode=$p(^INCI(inci,1),"^",1)
	...s InciDesc=$p(^INCI(inci,1),"^",2)
	...s qty=$p(reqitminfo,"^",3)
	...s Uomid=$p(reqitminfo,"^",5)
	...s Uom=$p(^CT("UOM",Uomid),"^",2)
	...s dhcinreqitmid=$o(^DHCINRQI(0,"INRQI",reqitmid,""))
	...i dhcinreqitmid'="" d
	....s remark=$p(^DHCINRQI(dhcinreqitmid),"^",2)
	...s regUser=""
	...s regDate=""
	...d OutputRowMatReq
	Quit $$$OK
OutputRowMatReq
	s Data=$lb(reqitmid,ReqLocid,ReqLoc,ssuserid,ssuser,date,InciCode,InciDesc,Spec,Uom,qty,regUser,regDate,remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

/// 出库数据 医政
/// Author: lihui
/// Date: 20200922
/// OutPut：唯一ID,科室ID,科室名称,出库审核人ID,审核人,日期,物资代码,物资名称,规格,单位,数量,,,备注,库存分类ID,库存分类代码,库存分类名称,医院
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.ServiceForOthHRP.QueryAllMatInfoUI","QueryMatTrf","2020-01-01","2020-04-04",392,2)
Query QueryMatTrf(StartDate, EndDate, LocStr, IncscIdStr) As web.DHCSTMHUI.Query(ROWSPEC = "TrId:%String,Loc:%String,LocDesc:%String,AuditUserid:%String,AuditUser:%String,Date:%String,InciCode:%String,InciDesc:%String,Spec:%String,BUomDesc:%String,TrQtyB:%String,regUser:%String,regDate:%String,remark:%String,Incsc:%String,IncscDesc:%String,IncscCode:%String,Hospital:%String") [ SqlProc ]
{
}

ClassMethod QueryMatTrfExecute(ByRef qHandle As %Binary, StartDate, EndDate, LocStr, IncscIdStr) As %Status
{
	n (qHandle,StartDate,EndDate,LocStr,IncscIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:LocStr="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	f Date=StartDate:1:EndDate d
	.s len=$l(LocStr,"^")
	.f i=1:1:len  d
	..s Loc=$p(LocStr,"^",i)
	..s LocDesc=$p(^CTLOC(Loc),"^",2) 
	..s ItmDr=0
	..f  s ItmDr=$o(^INCI("IL_LOC",Loc,ItmDr)) q:ItmDr=""  d
	...q:$o(^DHCLOCTOT(0,"LOCITMDATE",Loc,ItmDr,Date+1),-1)=""
	...s Chl=$o(^INCI("IL_LOC",Loc,ItmDr,0))
	...s Incil=ItmDr_"||"_Chl
	...s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmDr)
	...s ScgDesc=$p(StkGrpInfo,"^",2)
	...s Scg=$p(StkGrpInfo,"^",5)
	...s ScgType=$p(StkGrpInfo,"^",3)
	...q:ScgType'=..sssCode()
	...s Incsc=$p(^INCI(ItmDr,2),"^",2)
	...q:(IncscIdStr'="")&&(("^"_IncscIdStr_"^")'[("^"_Incsc_"^"))
	...s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2) 
	...s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)
	...s InciCode = $p(^INCI(ItmDr,1),"^",1)
	...s InciDesc = $p(^INCI(ItmDr,1),"^",2)
	...s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",ItmDr)
	...s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(ItmDr)
	...s BillUomDr=$P(BillUomStr,"^",1)
	...s BillUomDesc=$P(BillUomStr,"^",2)
	...s BUomId=$p(^INCI(ItmDr,1),"^",10)
	...s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	...s PurUomId=$p(^INCI(ItmDr,3),"^",6)
	...s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")
	...s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	...s HospId=$p(^CTLOC(Loc),"^",22)
	...s Hospital=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	...s TrId="" 
	...f  s TrId=$o(^DHCINTR(0,"INCI",ItmDr,Date,TrId)) q:TrId=""  d
	....q:'$d(^DHCINTR(TrId))
	....s Inclb=$p(^DHCINTR(TrId),"^",7)
	....q:Inclb=""
	....s TmpIncil=$p(Inclb,"||",1,2)
	....q:Incil'=TmpIncil           ;非统计科室库存
	....s Incib=$p(^INCI(ItmDr,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
	....s (BatNo,ExpDate)=""
	....i Incib'=""  d
	.....s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	.....s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	.....s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	....s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
	....q:(TrType'="T")&&(TrType'="K")
	....s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
	....s InIstrfinfo=^DHCINIT(+TrPointer)
	....s inititminfo=^DHCINIT(+TrPointer,"ITI",$p(TrPointer,"||",2))
	....s reqitmid=$p(inititminfo,"^",2)  ;申请单ID
	....s (OperLoc,AuditUserid,AuditUser)=""
	....i TrType="T" d
	.....s OperLoc=$p(InIstrfinfo,"^",5)
	.....s AuditUserid=$p(InIstrfinfo,"^",11)
	.....s AuditUser=$p(^SSU("SSUSR",AuditUserid),"^",2)
	....i TrType="K" d
	.....s OperLoc=$p(InIstrfinfo,"^",6)
	....q:OperLoc'=Loc
	....s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
	....s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
	....s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
	....s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
	....s OperateUser=""
	....s:TrUser'="" OperateUser=$p(^SSU("SSUSR",TrUser),"^",2)
	....s TrTime=$p(^DHCINTR(TrId),"^",3)
	....s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
	....s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
	....s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
	....s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
	....s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
	....s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
	....s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	....s TrQtyB=TrQty*FacTr              ;基本单位数量
	....s BUomSp=TrSp/FacTr               ;基本单位售价
	....s PurUomSp=BUomSp*Factor          ;包装单位售价
	....s BUomRp=TrRp/FacTr    //##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
	....s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
	....s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
	....s Manf=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	....i Manf'=""  s Manf=$p(Manf,"^",2)
	....s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetInclbVend(Inclb,Date)  ;该批次对应的最后一次入库的供应商
	....s Vendor=$p(VendorInfo,"^",2)
	....s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
	....s (regUserid,regUser,regDate)=""
	....i reqitmid'="" d
	.....s reqinfo=^INRQ(+reqitmid)
	.....s regUserid=$p(reqinfo,"^",4)
	.....s regUser=$s(regUserid'="":$p(^SSU("SSUSR",regUserid),"^",2),1:"")
	.....s regDate=$p(reqinfo,"^",2)
	.....s:regDate'="" regDate=$zd(regDate,3)
	....d OutputRowQueryMatTrf
	Quit $$$OK
OutputRowQueryMatTrf
	s Data=$lb(TrId,Loc,LocDesc,AuditUserid,AuditUser,Date,InciCode,InciDesc,Spec,BUomDesc,TrQtyB,regUser,regDate,remark,Incsc,IncscDesc,IncscCode,Hospital)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

}
