Import sqluser

/// Descript:库存查询
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-06
Class web.DHCSTMHUI.LocItmStk Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCSTMHUI.LocItmStk).LocItmStkDetail(1,15,"{""PhaLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""22/04/2020"",""StockType"":""0"",""StkGrpId"":"""",""Vendor"":"""",""INFOImportFlag"":"""",""StkCat"":"""",""ARCItemCat"":"""",""PhManufacturer"":"""",""LocManGrp"":"""",""InsuType"":"""",""Supervision"":"""",""ChargeFlag"":"""",""UseFlag"":"""",""HvFlag"":"""",""ManageDrugFlag"":"""",""Inci"":"""",""InciDesc"":"""",""InciAlias"":""""}")
ClassMethod LocItmStkDetail(page, rows, sort As %String, order As %String, Params As %String) As %String
{
	n (page,rows,sort,order,Params)
	s Start=(page-1)*rows
	s Limit=rows
	s End=Start+Limit
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s PhaLoc=PJObj.%Get("PhaLoc")
	q:PhaLoc="" $$$OK
	s StkDate=PJObj.%Get("StartDate")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s StockType=PJObj.%Get("StockType")
	s IncId=PJObj.%Get("Inci")
	s ImpFlag=PJObj.%Get("INFOImportFlag")
	s StkCatId=PJObj.%Get("StkCat")
	s LocManGrp=PJObj.%Get("LocManGrp")
	s ArcSubCatId=PJObj.%Get("ARCItemCat")
	s ManfId=PJObj.%Get("PhManufacturer")
	s InsuType=PJObj.%Get("InsuType")
	s ManageFlag=PJObj.%Get("ManageDrugFlag")
	s UseFlag=PJObj.%Get("UseFlag")
	s ItmDesc=PJObj.%Get("InciDesc")
	s ItmCode=PJObj.%Get("InciCode")
	s Vendor=PJObj.%Get("Vendor")
	s HvFlag=PJObj.%Get("HvFlag")
	s Supervision=PJObj.%Get("Supervision")
	s Alias=PJObj.%Get("InciAlias")
	s charge=PJObj.%Get("ChargeFlag") 
	s POfficial=PJObj.%Get("Official")
	s PClinicalCat=PJObj.%Get("ClinicalCat")
	s Pid=..NewPid()
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=..DH2L(StkDate)
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),PhaLoc,StkGrpId,HospId)
	s Alias=$$ALPHAUP^SSUTIL4(Alias)
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s count=0
	s Pid=..NewPid()
	k ^TMPLOCITMSTK(Pid,"LocItmStkDetail")
	s num=0
	s TotalRpAmt=0
	s TotalSpAmt=0
	
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.q:$o(^DHCLOCTOT(0,"LOCITMDATE",PhaLoc,Inci,StkDate+1),-1)=""
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
	.q:(IncId'="")&(Inci'=IncId)
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId)
	.s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.q:(UseFlag="Y")&(NotUse="Y")
	.q:(UseFlag="N")&(NotUse'="Y")
	.s ArcItmCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcItemCat(Inci)
	.s ItemCatId=$p(ArcItmCatInfo,"^",1)
	.q:(ArcSubCatId'="")&(ItemCatId'=ArcSubCatId)
	.s InsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInsuCat(Inci)
	.s OfficalCode=$p(InsuInfo,"^",3)
	.s InsuId=$p(InsuInfo,"^",1)
	.q:(InsuType'="")&(InsuId'=InsuType)    ;医保类别id
	.s INFOSupervision=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(Inci)
	.q:(Supervision'="")&&(Supervision'=INFOSupervision)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfDr=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.q:(ManfId'="")&(ManfDr'=ManfId)
	.s vendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(Inci)
	.s vendor=$p(vendorInfo,"^",1)
	.s VendorDesc=$p(vendorInfo,"^",2)
	.s ItmImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(Inci)
	.q:(ImpFlag'="")&(ItmImpFlag'=ImpFlag)
	.s ManGrp=##class(web.DHCSTMHUI.Common.DrugStkCommon).ManGrpByIncil(Incil)
	.q:(LocManGrp'="")&&(ManGrp'=LocManGrp)  
	.s ManFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
	.q:(ManageFlag'="")&(ManFlag'=ManageFlag)           //是否为重点标志材料
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.q:(HvFlag'="")&&(HvFlag'=HVFlag)   //高值条件过滤
	.s StockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	.q:(StockType=1)&(StockQty'=0)		;只检索库存为零记录
	.q:(StockType=2)&(StockQty'>0)		;只检索库存为正记录
	.q:(StockType=3)&(StockQty'<0)		;只检索库存为负记录
	.q:(StockType=4)&(StockQty=0)		;只检索非零库存
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.q:(ItmDesc'="")&(InciDesc'[ItmDesc)
	.q:(ItmCode'="")&(InciCode'[ItmCode)
	.i Alias'="" d
	..s AliasRet=##class(web.DHCSTMHUI.INCALIAS).CheckAlias(Inci,Alias)
	.q:(Alias'="")&&(+AliasRet'=1)			;别名过滤
	.
	.s LastVendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen(Inci,PhaLoc)
	.s LastVendId=$p(LastVendorInfo,"^",1)
	.s LastVenDesc=$p(LastVendorInfo,"^",2)
	.q:(Vendor'="")&(Vendor'=LastVendId)
	.s chargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)
	.q:((charge="Y")&&(chargeFlag'="Y"))
	.q:((charge="N")&&(chargeFlag="Y"))
	.s ClinicCat=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetClinicCat(Inci)	//重点关注分类
	.s ClinicCatId=$p(ClinicCat,"^",1),ClinicCatDesc=$p(ClinicCat,"^",3)
	.q:(PClinicalCat'="")&&(ClinicCatId'=PClinicalCat)
	.
	.s IncsbInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(PhaLoc,Inci)
	.s IncsbDesc=$p(IncsbInfo,"^",1)
	.s StkBinId=$p(IncsbInfo,"^",2)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s PurStockQty = StockQty / Fac
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.
	.s SalePrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,StkDate,PurUomId,HospId)
	.s LastReailPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,PurUomId,HospId)
	.s BatSpFlag=..sssBatSpFlag(HospId,Inci)
	.if BatSpFlag=1 d 
	..s SpAmt=..GetSpAmt(Incil,StkDate,HospId)
	.e  d
	..s SpAmt = SalePrice * PurStockQty
	.
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s RpAmt=..GetRpAmt(Incil,StkDate,HospId)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.s UnexpiredQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,"","3","","Y")
	.s StkQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,StockQty)
	.&sql(select INCIL_AvailQty,INCIL_DirtyQty,INCIL_ReservedQty into :AvaQty,:DirtyQty,:ReservedQty
			from inc_itmloc where incil_rowid=:Incil)
	.s DirtyQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,DirtyQty)
	.s ReservedQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,ReservedQty)
	.s AvaQty=AvaQty-DirtyQty	;可用库存减去占用数
	.s AvaQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,AvaQty)
	.
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgDesc=$p(ScgInfo,"^",2)
	.
	.s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(Inci,HospId)
	.s MatInsuCode=$p(MatInsuInfo,"^",1)
	.s MatInsuDesc=$p(MatInsuInfo,"^",2)
	.s OfficialCat=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetOfficialCat(Inci)	//68分类
	.s OfficialCatCatId=$p(OfficialCat,"^",1),OfficialCatDesc=$p(OfficialCat,"^",3)
	.q:(POfficial'="")&&(OfficialCatCatId'=POfficial)
	.s BarCodeCount=##class(web.DHCSTMHUI.DHCItmTrack).GetEnableCount(Incil)
	.
	.s Data1=Incil_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_IncsbDesc_"^"_PurchCTUomDesc_"^"_BaseCTUomDesc_"^"_PurStockQty_"^"_StockQty_"^"_StkQtyUom
	.s Data2=SalePrice_"^"_SpAmt_"^"_LastReailPrice_"^"_RpAmt_"^"_Spec_"^"_ManfDesc_"^"_OfficalCode_"^"_ManFlag_"^"_DirtyQtyUom_"^"_AvaQtyUom
	.s Data3=HVFlag_"^"_VendorDesc_"^"_ReservedQtyUom_"^"_Model_"^"_LastVenDesc_"^"_ScgDesc_"^"_IncscDesc_"^"_MatInsuCode_"^"_MatInsuDesc_"^"_OfficialCatDesc
	.s Data4=ClinicCatDesc_"^"_StkBinId_"^"_UnexpiredQty_"^"_BarCodeCount
	.s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	.s Sub=""
	.i sort="InciCode" d
	..s Sub=InciCode
	.e  i sort="InciDesc" d
	..s Sub=InciDesc
	.e  i sort="StockQty" d
	..s Sub=StockQty
	.e  i sort="Sp" d
	..s Sub=SalePrice
	.e  i sort="Rp" d
	..s Sub=LastReailPrice
	.s:Sub="" Sub=Incil
	.s num=num+1
	.s ^TMPLOCITMSTK(Pid,"LocItmStkDetail",Sub,num)=Data
	
	s order=$$ALPHAUP^SSUTIL4(order)
	s:order="" order="ASC"
	s orderFlag=$s(order="ASC":1,1:-1)
	s Sub=""
	f  s Sub=$o(^TMPLOCITMSTK(Pid,"LocItmStkDetail",Sub),orderFlag) q:Sub=""  d
	.s Ch=""
	.f  s Ch=$o(^TMPLOCITMSTK(Pid,"LocItmStkDetail",Sub,Ch),orderFlag) q:Ch=""  d
	..s Data=^TMPLOCITMSTK(Pid,"LocItmStkDetail",Sub,Ch)
	..s RpAmt=$p(Data,"^",14)
	..s SpAmt=$p(Data,"^",12)
	..s TotalRpAmt=TotalRpAmt+RpAmt
	..s TotalSpAmt=TotalSpAmt+SpAmt
	..s count=count+1
	..q:count<=Start
	..q:count>End
	..d json.InsertRowData(Data)
	
	k ^TMPLOCITMSTK(Pid,"LocItmStkDetail")
	s Title="Incil^Inci^InciCode^InciDesc^StkBin^PurUomDesc^BUomDesc^PurStockQty:number^StockQty:number^StkQtyUom:number"
		_"^Sp:number^SpAmt:number^Rp:number^RpAmt:number^Spec^ManfDesc^OfficalCode^ManFlag^DirtyQty:number^AvaQty:number"
		_"^HVFlag^VendorDesc^ReservedQty:number^Model^LastVenDesc^ScgDesc^IncscDesc^MatInsuCode^MatInsuDesc^OfficialCat"
		_"^ClinicCat^StkBinId^UnexpiredQty:number^BarCodeCount:number"
	s FootTitle="InciDesc^SpAmt^RpAmt"
	s FootData="合计"_"^"_TotalSpAmt_"^"_TotalRpAmt
	d json.getJsonData(Title,count,"","","","",FootTitle,FootData)
	k json
	q ""
}

ClassMethod GetRpAmt(incil, dtend, hospid, TimeH = "") As %String
{
	n (incil,dtend,hospid,TimeH)
	s inci=$p(incil,"||",1)
	s incich=$p(incil,"||",2)
	s ch=0
	s sumamt=0
	f  s ch=$o(^INCI(inci,"IL",incich,"LB",ch)) q:ch=""  d
	.s inclb=incil_"||"_ch
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,dtend,TimeH)
	.q:qty=0
	.s buom=$p(^INCI(inci,1),"^",10)
	.s rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buom,hospid,"",dtend)
	.s rpamt=rp*qty
	.s sumamt=sumamt+rpamt
	.
	s sumamt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(sumamt,hospid)
	q sumamt
}

/// 批次售价获取每个批次售价金额的之和
ClassMethod GetSpAmt(incil, dtend, hospid) As %String
{
	n (incil, dtend,hospid)
	s inci=$p(incil,"||",1)
	s incich=$p(incil,"||",2)
	s ch=0
	s sumamt=0
	f  s ch=$o(^INCI(inci,"IL",incich,"LB",ch)) q:ch=""  d
	.s inclb=incil_"||"_ch
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,dtend)
	.q:qty=0
	.s buom=$p(^INCI(inci,1),"^",10)
	.s PriceStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByInclb(inclb,dtend,buom,hospid)
	.s sp=$p(PriceStr,"^",2)
	.s spamt=sp*qty
	.s sumamt=sumamt+spamt
	s sumamt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(sumamt,hospid)
	q sumamt
}

/// w ##class(web.DHCSTMHUI.LocItmStk).Batch("1","15",^temxjc1("1"),"4677||1")
ClassMethod Batch(page As %String, rows As %String, StrParam As %String = "", InciParam As %String = "") As %String
{
	n (page,rows,StrParam,InciParam)
	;s ^zx(22)=$lb(page,rows,StrParam,InciParam)
	s Start=(page-1)*rows
	s Limit=rows
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(StrParam)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Incil=InciParam
	s Date=PJObj.%Get("StartDate")
	s VendorId=PJObj.%Get("Vendor")
	s InclbBatchNo=PJObj.%Get("InclbBatchNo")
	s InclbExpDate=PJObj.%Get("InclbExpDate")
	s InclbNoZeroFlag=PJObj.%Get("InclbNoZeroFlag")
	
	s Pid=..NewPid()
	k ^TMPDHCST("LocItmStk",Pid)
	q:Incil="" ""
	i Date="" d
	.s Date=+$h
	e  d
	.s Date=..DH2L(Date)
	s LB=0
	s Inci=+Incil
	s IL=$p(Incil,"||",2)
	s PhaLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB)) q:LB=""  d
	.s Inclb=Inci_"||"_IL_"||"_LB
	.q:$o(^DHCBTLOCTOT(0,"INCLBDATE",Inclb,Date+1),-1)=""
	.s Incib=$P(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	.s Chl=$p(Incib,"||",2)
	.s dhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,""))
	.s Vendor=$s(dhcIncib'="":$p(^DHCINCIB(dhcIncib),"^",8),1:"")
	.s BarCode=$s(dhcIncib'="":$p(^DHCINCIB(dhcIncib),"^",17),1:"")
	.;q:(VendorId'="")&&(Vendor'=VendorId)		;供应商过滤
	.s IncQty=##CLASS(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Date)
	.q:(InclbNoZeroFlag="Y")&&(+IncQty=0)
	.s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)
	.s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)
	.s RecallFlag=$p(^INCI(Inci,"IB",Chl),"^",3)
	.i ExpDate'=0  d
	..s Expire=..DL2H(ExpDate)
	.e  d
	..s Expire=""
	.q:(InclbBatchNo'="")&&(BatNo'[InclbBatchNo)
	.q:(InclbExpDate'="")&&(Expire'=InclbExpDate)
	.s RecallFlag=$p(^INCI(Inci,"IB",Chl),"^",3)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s BRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId)
	.s PRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,PurUomId,HospId)
	.s BSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbSp(Inclb,Date,BUomId,HospId)
	.s PSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbSp(Inclb,Date,PurUomId,HospId)
	.;s BSp=$p(##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByInclb(Inclb,Date,BUomId,HospId),"^",2)
	.;s PSp=$p(##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByInclb(Inclb,Date,PurUomId,HospId),"^",2)
	.s QtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,IncQty)
	.s DirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,BUomId)
	.s DirtyQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,DirtyQty)
	.s ResveredQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbReservedQty(Inclb,BUomId)
	.s ResveredQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,ResveredQty)
	.s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,BUomId)
	.s AvaQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,AvaQty)
	.s Vendor=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb),"^",2)
	.s Manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
	.
	.s (IngrDate,IngrLocDesc,IngrNo)=""
	.s LastIngrId="",dah=+$h,INGR=""
	.f  s INGR=$o(^DHCINGR(0,"GRI_INCIB",Incib,INGR),-1)  q:(LastIngrId'="")!(INGR="")   d
	..s grdate=$p(^DHCINGR(INGR),"^",4)
	..s:grdate'>dah LastIngrId=INGR
	..s IngrNo=$p(^DHCINGR(LastIngrId),"^",1)
	..s IngrDate=$p(^DHCINGR(LastIngrId),"^",4)
	..s IngrLocId=$p(^DHCINGR(LastIngrId),"^",13)
	..s IngrDate=..DL2H(IngrDate)
	..s IngrLocDesc=$s(IngrLocId'="":$p(^CTLOC(IngrLocId),"^",2),1:"")
	.
	.s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	.s BTax=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetTaxByInclb(Inclb)
	.s BarCodeCount=##class(web.DHCSTMHUI.DHCItmTrack).GetEnableCount(Inclb)
	.
	.s Data1=BatNo_"^"_Expire_"^"_QtyUom_"^"_BRp_"^"_PRp_"^"_Inclb_"^"_DirtyQtyUom_"^"_AvaQtyUom_"^"_BSp_"^"_PSp
	.s Data2=Vendor_"^"_RecallFlag_"^"_ResveredQtyUom_"^"_IngrDate_"^"_SpecDesc_"^"_BTax_"^"_Manf_"^"_BarCode_"^"_RecallFlag_"^"_IngrLocDesc
	.s Data3=IngrNo_"^"_BarCodeCount
	.s ^TMPDHCST("LocItmStk",Pid,IncQty,ExpDate,Inclb)=Data1_"^"_Data2_"^"_Data3
	
	s count = 0
	s end=Start+Limit
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s Sub=""
	f  s Sub=$o(^TMPDHCST("LocItmStk",Pid,Sub),-1) q:Sub=""  d
	.s ssub=""
	.f  s ssub=$o(^TMPDHCST("LocItmStk",Pid,Sub,ssub),-1) q:ssub=""  d
	..s sssub=""
	..f  s sssub=$o(^TMPDHCST("LocItmStk",Pid,Sub,ssub,sssub)) q:sssub=""  d
	...s Data=^TMPDHCST("LocItmStk",Pid,Sub,ssub,sssub)
	...s count = count+1
	...i (count>Start)&(count<=end) d
	....d json.InsertRowData(Data)

	s TitleStr="BatNo^ExpDate^QtyUom:number^BRp:number^PRp:number^Inclb^DirtyQty:number^AvaQty:number^BSp:number^PSp:number"
		_"^Vendor^RecallFlag^ReservedQty:number^IngrDate^SpecDesc^BTax^Manf^BarCode^RecallFlag^IngrLocDesc"
		_"^IngrNo^BarCodeCount:number"
	d json.getJsonData(TitleStr,count)
	k json
	k ^TMPDHCST("LocItmStk",Pid)
	q ""
}

/// Descript:占用数量单据查询
/// Creater:	zhangdongmei
/// CreateDate:	2012-08-16
/// Input:	科室库存批次id
/// Output:		
/// Return：
/// d ##class(web.DHCSTMHUI.LocItmStk).GetDirtyQtyInfo("2766||2||1")
ClassMethod GetDirtyQtyInfo(Inclb As %String) As %String
{
	n (Inclb)
	q:Inclb="" ""
	s count = 0
	s resultString = ""
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	
	d GetInfoFromTr
	d GetInfoFromInds	;2014-10-23 添加科室内发放单占用查询
	d GetInfoFromInscp
	d GetInfoFromRet
	d json.getJsonData("Rowid^No^Qty:number^Uom^Date^Type",count)
	k json
	q ""

GetInfoFromTr
	s init=""
	f  s init=$o(^DHCINIT(0,"INCLB",Inclb,init)) q:init=""  d
	.s stat=$p($g(^DHCINIT(init)),"^",14)
	.q:(stat=21)!(stat=31)!(stat=99)			;转移出库审核通过和转移入库审核通过不存在占用
	.s trno=$p($g(^DHCINIT(init)),"^",1)
	.s trdate=$p($g(^DHCINIT(init)),"^",2)
	.s trdate=..DL2H(trdate)
	.s chl=""
	.f  s chl=$o(^DHCINIT(0,"INCLB",Inclb,init,chl))  q:chl=""  d
	..s tmpinci=+Inclb
	..s rowid=init_"||"_chl
	..s qty=$p(^DHCINIT(init,"ITI",chl),"^",1)
	..s uomdr=$p(^DHCINIT(init,"ITI",chl),"^",7)
	..s uom=$p(^CT("UOM",uomdr),"^",2)
	..s incicode=$p(^INCI(tmpinci,1),"^",1)
	..s incidesc=$p(^INCI(tmpinci,1),"^",2)
	..s count = count+1
	..s result=rowid_"^"_trno_"^"_qty_"^"_uom_"^"_trdate_"^"_"T"
	..d json.InsertRowData(result)
	.
	q 

GetInfoFromRet
	s grt=""
	f  s grt=$o(^INGRT(0,"INCLB",Inclb,grt)) q:grt=""  d
	.s auditdate=+$p(^INGRT(grt),"^",9)
	.q:auditdate>0					;已审核的单据不存在占用
	.s retno=$p(^INGRT(grt),"^",1)
	.s retdate=$p(^INGRT(grt),"^",3)
	.s retdate=..DL2H(retdate)
	.s chl=""
	.f  s chl=$o(^INGRT(0,"INCLB",Inclb,grt,chl))  q:chl=""  d
	..s tmpinci=+Inclb
	..s rowid=grt_"||"_chl
	..s qty=$p(^INGRT(grt,"DHCGRR",chl),"^",2)
	..s uomdr=$p(^INGRT(grt,"DHCGRR",chl),"^",3)
	..s uom=$p(^CT("UOM",uomdr),"^",2)
	..s incicode=$p(^INCI(tmpinci,1),"^",1)
	..s incidesc=$p(^INCI(tmpinci,1),"^",2)
	..s count = count+1
	..
	..s result=rowid_"^"_retno_"^"_qty_"^"_uom_"^"_retdate_"^"_"R"
	..d json.InsertRowData(result)
	.
	q

	;科室内发放制单占用
GetInfoFromInds
	s inds=""
	f  s inds=$o(^DHCINDS(0,"INCLB",Inclb,inds)) q:inds=""  d
	.s AckFlag=$p(^DHCINDS(inds),"^",17)
	.q:AckFlag="Y"			;已审核单据不存在占用
	.s trno=$p(^DHCINDS(inds),"^",1)
	.s trdate=$p(^DHCINDS(inds),"^",2)
	.s trdate=..DL2H(trdate)
	.s chl=""
	.f  s chl=$o(^DHCINDS(0,"INCLB",Inclb,inds,chl))  q:chl=""  d
	..s rowid=inds_"||"_chl
	..s qty=$p(^DHCINDS(inds,"DSI",chl),"^",1)
	..s uomdr=$p(^DHCINDS(inds,"DSI",chl),"^",4)
	..s uom=$p(^CT("UOM",uomdr),"^",2)
	..s count = count+1
	..
	..s result=rowid_"^"_trno_"^"_qty_"^"_uom_"^"_trdate_"^"_"C"
	..d json.InsertRowData(result)
	.
	q
GetInfoFromInscp
	s Inscp=0
	f  s Inscp=$o(^DHCINSP(0,"INCLB",Inclb,Inscp)) q:Inscp=""  d
	.s AckFlag=$p(^DHCINSP(Inscp),"^",14)
	.q:AckFlag="Y"			;已审核单据不存在占用
	.s trno=$p(^DHCINSP(Inscp),"^",1)
	.s trdate=$p(^DHCINSP(Inscp),"^",2)
	.s trdate=..DL2H(trdate)
	.s chl=""
	.f  s chl=$o(^DHCINSP(0,"INCLB",Inclb,Inscp,chl)) q:chl=""  d
	..s rowid=Inscp_"||"_chl
	..s qty=$p(^DHCINSP(Inscp,"I",chl),"^",3)
	..s uomdr=$p(^DHCINSP(Inscp,"I",chl),"^",2)
	..s uom=$p(^CT("UOM",uomdr),"^",2)
	..s count = count+1
	..
	..s result=rowid_"^"_trno_"^"_qty_"^"_uom_"^"_trdate_"^"_"D"
	..d json.InsertRowData(result)
	.
	q
}

/// 检索全院库存查询数据
/// Author:	wangjiabin
/// Date:	2014-07-23
/// Argu:
/// Input:StrParam:科室id^日期^类型^库存项rowid^类组^库存分类^进口标志^医嘱子类^生产厂家^医保类别
/// 			^是否重点关注^仅在用品种^仅不在用品种 
/// OutPut:科室,incil,库存项id,库存项代码,库存项描述,货位码描述,入库单位,基本单位,库存(入库单位),库存(基本单位),
/// 			售价,售价金额,最新进价,进价金额,规格,生产厂家,医保名称,incib,批号,效期,
/// 			批次进价(入库单位),类组id,类组描述,库存分类id,库存分类描述
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmStk","LocItmStkAll","{""PhaLoc"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57974"",""StartDate"":""2023-03-17"",""StockType"":""4"",""ScgStk"":"""",""StkCat"":"""",""INFOImportFlag"":"""",""ARCItemCat"":"""",""Vendor"":"""",""Manf"":"""",""UseFlag"":"""",""HVFlag"":"""",""ChargeFlag"":"""",""Supervision"":"""",""LocGroup"":"""",""ExcludeWarehouse"":"""",""InciDesc"":"""",""Inci"":""""}")
Query LocItmStkAll(Params As %String(MAXLEN="")) As Query(ROWSPEC = "PhaLocDesc,Incil,Inci,InciCode,InciDesc,IncsbDesc,PurchCTUomDesc,BaseCTUomDesc,PurStockQty:%Float,StockQty:%Float,SalePrice:%Float,SpAmt:%Float,LastReailPrice:%Float,RpAmt:%Float,Spec,ManfDesc,OfficalCode,Incib,BatchNo,ExpDate,RpPuom:%Float,Scg,ScgDesc,Incsc,IncscDesc,vendorname,Supervision,Slgdesc,Model") [ SqlProc ]
{
}

ClassMethod LocItmStkAllExecute(ByRef qHandle As %Binary, Params As %String(MAXLEN="")) As %Status
{
	n (qHandle,Params)
	;tro  s ^dhcstmqsx("LocItmStkAll")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s LocId=PJObj.%Get("PhaLoc")
	s StkDate=PJObj.%Get("StartDate")
	s:StkDate'="" StkDate=..DH2L(StkDate)
	s StockType=PJObj.%Get("StockType")
	s IncId=PJObj.%Get("Inci")
	s StkGrpId=PJObj.%Get("ScgStk")
	s StkCatId=PJObj.%Get("StkCat")
	s ImpFlag=PJObj.%Get("INFOImportFlag")
	s ArcSubCatId=PJObj.%Get("ARCItemCatBox")	//医嘱子类
	s ManfId=PJObj.%Get("Manf")
	s InsuType=PJObj.%Get("InsuType")
	s ExcludeWarehouse=PJObj.%Get("ExcludeWarehouse")
	s UseFlag=PJObj.%Get("UseFlag")
	s Vendor=PJObj.%Get("Vendor")	
	s ItmDesc=PJObj.%Get("InciDesc")
	s gHospId=PJObj.%Get("gHospId")	
	s HV=PJObj.%Get("HVFlag")
	s Charge=PJObj.%Get("ChargeFlag")
	s Supervision=PJObj.%Get("Supervision")
	s LocGroup=PJObj.%Get("LocGroup")
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",StkGrpId,gHospId)
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:(+Inci=0)||(Inci="")  d
	.q:(IncId'="")&(Inci'=IncId)
	.q:'$d(^INCI(Inci))
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgDesc=$p(StkGrpInfo,"^",2)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.;q:(StkGrpId'="")&(Scg'=StkGrpId)
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.q:NotUse=UseFlag 
	.s ArcItmCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcItemCat(Inci)
	.s ItemCatId=$p(ArcItmCatInfo,"^",1)
	.q:(ArcSubCatId'="")&(ItemCatId'=ArcSubCatId)
	.s InsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInsuCat(Inci)
	.s Insu=$p(InsuInfo,"^",1)
	.q:(InsuType'="")&(Insu'=InsuType)    ;医保类别id
	.s OfficalCode=$p(InsuInfo,"^",3)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfDr=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.q:(ManfId'="")&(ManfDr'=ManfId)
	.s ItmImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(Inci)
	.q:(ImpFlag'="")&(ItmImpFlag'=ImpFlag)
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.q:(ItmDesc'="")&(InciDesc'[ItmDesc)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.q:(HV'="")&&(HVFlag'=HV)
	.s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)
	.q:(Charge'="")&&(ChargeFlag'=Charge)
	.s INFOSupervision=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(Inci)
	.q:(Supervision'="")&&(Supervision'=INFOSupervision)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s (BaseCTUomDesc,PurchCTUomDesc)=""
	.s:BUomId'="" BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s:PurUomId'="" PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.s il=0
	.f  s il=$o(^INCI(Inci,"IL",il)) q:il=""  d
	..q:($d(^INCI(Inci,"IL",il))'=1)&&($d(^INCI(Inci,"IL",il))'=11)
	..s Incil=Inci_"||"_il
	..s PhaLoc=$p($g(^INCI(Inci,"IL",il)),"^",1)
	..q:PhaLoc=""
	..q:(LocId'="")&&(PhaLoc'=LocId)
	..s LocType=..GetLocType(PhaLoc)
	..q:(ExcludeWarehouse="Y")&&(LocType="A")
	..s Slgdesc="",Slgdr=""
	..i $d(^DHCLOC(0,"LOC",PhaLoc)) d
	...s dhclocdr=$o(^DHCLOC(0,"LOC",PhaLoc,0))
	...q:dhclocdr=""
	...q:'$d(^DHCLOC(dhclocdr))
	...s Slgdr=$p(^DHCLOC(dhclocdr),"^",3)
	...s:(Slgdr'="")&&$d(^DHCSLG(Slgdr)) Slgdesc=$p($g(^DHCSLG(Slgdr)),"^",2)
	..q:(LocGroup'="")&&(Slgdr'=LocGroup)
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
	...//供应商过滤
	...s VendorStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	...s vendorid=$p(VendorStr,"^",1)
	...q:(Vendor'="")&(vendorid'=Vendor)
	...s vendorname=$p(VendorStr,"^",2)
	...//供应商过滤
	...s BatchNo=$p(BatExp,"^",1)
	...s ExpDate=$p(BatExp,"^",2)
	...s Incib=$p(^INCI(Inci,"IL",il,"LB",lb),"^",1)
	...s StockQty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,StkDate)
	...
	...q:(StockType=1)&(StockQty'=0)     ;只检索库存为零记录
	...q:(StockType=2)&(StockQty'>0)     ;只检索库存为正记录
	...q:(StockType=3)&(StockQty'<0)     ;只检索库存为负记录
	...q:(StockType=4)&(StockQty=0)
	...
	...s PurStockQty = StockQty / Fac
	...s SalePrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,StkDate,PurUomId,HospId)
	...s SpAmt = SalePrice * PurStockQty
	...s Rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId)
	...s RpPuom=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,PurUomId,HospId)
	...s RpAmt=Rp*StockQty
	...s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	...s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	...d OutPutRow
	
	Quit $$$OK
OutPutRow
	s Data=$lb(PhaLocDesc,Incil,Inci,InciCode,InciDesc,
			IncsbDesc,PurchCTUomDesc,BaseCTUomDesc,PurStockQty,StockQty,
			SalePrice,SpAmt,LastReailPrice,RpAmt,Spec,
			ManfDesc,OfficalCode,Incib,BatchNo,ExpDate,
			RpPuom,Scg,ScgDesc,Incsc,IncscDesc,vendorname,Supervision,
			Slgdesc,Model)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取科室扩展信息中的科室类型
ClassMethod GetLocType(LocId) As %String
{
	n (LocId)
	q:LocId="" ""
	s dhcstLoc=$o(^DHCLOC(0,"LOC",LocId,""))
	q:dhcstLoc="" ""
	s LocType=$p(^DHCLOC(dhcstLoc),"^",5)
	q LocType
}

/// 同步科室库存
/// Author:	wangjiabin
/// Date:	2015-02-10
/// Argu:
/// Input:	Incil
/// OutPut:	0:成功, >0:失败
ClassMethod SynIncilStkQty(incil) As %String
{
	n (incil)
	s RtnObj=##class(RtnObj).%New()
	s inci=+incil,il=$P(incil,"||",2)
	ts
	s lb=0,err=0
	f  s lb=$O(^INCI(inci,"IL",il,"LB",lb)) q:(lb="")!(err'=0)  d
	.s inclb=incil_"||"_lb
	.s lbqty=+$P(^INCI(inci,"IL",il,"LB",lb),"^",2)
	.s dhclbqty=+##CLASS(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
	.i lbqty'=dhclbqty d
	..s adjqty=dhclbqty-lbqty
	..s err=..MakeUpStk(inclb,adjqty)
	i err'=0 {
		tro  
		s RtnObj.success=-1
		s RtnObj.msg="同步失败"
		q RtnObj.Json()
	}
	tc
	s RtnObj.success=0
	s RtnObj.msg="同步成功"
	q RtnObj.Json()
}

ClassMethod MakeUpStk(inclb, bqty)
{
	n (inclb,bqty)
	q:(inclb="")!(bqty="") -1
	s inci=$p(inclb,"||",1),il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	q:il="" -1
	q:lb="" -1
	s incil=inci_"||"_il
	ts
	&sql(update inc_itmlcbt set INCLB_PhyQty=INCLB_PhyQty+:bqty where %id=:inclb)
	i SQLCODE tro  q -2
	&sql(update inc_itmloc set INCIL_LogQty=INCIL_LogQty+:bqty where %id=:incil)
	i SQLCODE tro  q -3
	tc
	q 0
}

/// w ##class(web.DHCSTMHUI.LocItmStk).ClrLocInciResQtyAll()
ClassMethod ClrLocInciResQtyAll() As %String
{
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci=0
	.;q:Inci'=4857
	.s incsctype=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",3)
	.q:incsctype'="M"
	.s incilCh=0
	.f  s incilCh=$o(^INCI(Inci,"IL",incilCh)) q:incilCh=""  d
	..s locDr=$p($g(^INCI(Inci,"IL",incilCh)),"^",1)
	..;q:locDr'=143
	..s Incil=Inci_"||"_incilCh
	..;q:Incil'="4857||2"
	..d ..ClrLocInciResQty(Incil)
	q 0
}

/// 清除科室在途数 20180918 lihui
/// w ##class(web.DHCSTMHUI.LocItmStk).ClrLocInciResQty("2051||2")
ClassMethod ClrLocInciResQty(Incil) As %String
{
	N (Incil)
	s inci=+Incil
	s ch=$p(Incil,"||",2)
	s RtnObj=##class(RtnObj).%New()
	i (inci="")||(ch="")||('$D(^INCI(inci,"IL",ch))) d
	.d RtnObj.Err(-1,"","此物资库存为空","",0)
	i RtnObj.success'=0 q RtnObj.Json()
	s incsctype=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",3)
	q:incsctype'="M"
	s locID=$p($g(^INCI(inci,"IL",ch)),"^",1)
	i locID="" d RtnObj.Err(-2,"","此物资不在此科室","",0)
	i RtnObj.success'=0 q RtnObj.Json()
	s HospID=$p($g(^CTLOC(locID)),"^",22)
	s RuleFlag=..sssBatSpFlag(HospID,inci)
	s $p(^INCI(inci,"IL",ch),"^",10)=0		//清除科室库存在途
	i RuleFlag'=1 d
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).ClearReservedDetailByInc(Incil,"",locID)
	e  d   
	.s lbSub=0
	.f  s lbSub=$o(^INCI(inci,"IL",ch,"LB",lbSub)) q:lbSub=""  d
	..s inclb=Incil_"||"_lbSub
	..s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
	..i dhcinclb'="" d
	...s $p(^DHCINCLB(dhcinclb),"^",3)=0	//批次医嘱占用数(批次售价流程)
	..s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).ClearReservedDetailByInc("",inclb,locID)
	//记录清在途日期时间
	s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateIncilClearTime(Incil)
	i Ret'=0 d RtnObj.Err(-2,"","记录清在途时间失败")
	q RtnObj.Json()
}

/// creator:yunhaibao
/// createdate:2015-12-18
/// update xuchao   2017-1-7
/// description:根据任务清除门诊未交费医嘱在途数,规则为这次执行任务,清除前24到12小时的未交费数据,或72-36
/// input:任务间隔的小时数,比如12小时一次则入参为12,Type:1-清除未交费,2清除未发药
/// 先发药后交费的不清
/// w ##class(web.DHCSTMHUI.LocItmStk).ClearReserveQtyClinicNoPay(24,1)
ClassMethod ClearReserveQtyClinicNoPay(Hours, Type)
{
	n (Hours,Type)
	q:+Hours=0 ""
	s NowDateTime=$zdt($h,3)     
	&SQL(SELECT DATEADD(hh,-:Hours,:NowDateTime),DATEADD(hh,-2*:Hours,:NowDateTime) into :EndDateTime,:BeginDateTime)
	
	s BeginDateTime=$zdth(BeginDateTime,3)
	s EndDateTime=$zdth(EndDateTime,3)
	s BeginDate=+BeginDateTime,BeginTime=$p(BeginDateTime,",",2)   //开始日期，开始时间
	s EndDate=+EndDateTime,BeginTime=$p(EndDateTime,",",2)
	s StkType=..sssCode()
	
	s LocId=0
	f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d  
	.s HospId=$p($g(^CTLOC(LocId)),"^",22)
	.f OrdDate=BeginDate:1:EndDate d
	..s Ord=""
	..f  s Ord=$o(^OEORDi(0,"LocStDtArr",LocId,0,OrdDate,Ord)) q:Ord=""  d
	...s AdmDr=$p(^OEORD(Ord),"^",1)
	...q:AdmDr=""
	...s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
	...q:(AdmType'="O")&&(AdmType'="E")		//非门急诊,过滤
	...s OrdCh=""
	...f  s OrdCh=$o(^OEORDi(0,"LocStDtArr",LocId,0,OrdDate,Ord,OrdCh)) q:OrdCh=""  d
	....s Oeori=Ord_"||"_OrdCh
	....s Arcim=$p(^OEORD(Ord,"I",OrdCh,1),"^",2)
	....s Prority=$p(^OEORD(Ord,"I",OrdCh,1),"^",8)
	....s OrdTime=$p(^OEORD(Ord,"I",OrdCh,1),"^",10)
	....s OrdStatDR=$p(^OEORD(Ord,"I",OrdCh,1),"^",13)
	....s Bill=$p(^OEORD(Ord,"I",OrdCh,3),"^",5)
	....q:(Type=1)&&(Bill="P")				//过滤已交费, Bill 费别
	....
	....s PrCode=$s(Prority'="":$p(^OECPR(Prority),"^",1),1:"")
	....q:PrCode["OM"						//自备药
	....s OrdStaus=$p(^OEC("OSTAT",OrdStatDR),"^",1)       
	....q:(OrdStaus'="V")&(OrdStaus'="E")	//非有效医嘱
	....
	....q:(OrdDate=BeginDate)&&(OrdTime<BeginTime) 
	....q:(OrdDate=EndDate)&&(OrdTime>BeginTime)
	....s Arc=$p(Arcim,"||",1),Ver=$p(Arcim,"||",2)
	....q:(Arc="")||(Ver=0)
	....
	....s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""),-1) //可能有R记录
	....q:Dsp=""
	....s qty=$p(^DHCOEDISQTY(Dsp),"^",5)
	....s status=$p(^DHCOEDISQTY(Dsp),"^",7)
	....q:status'="TC"
	....
	....
	....s Inci=$o(^INCI(0,"ARCIM_DR",Arc,""))
	....q:Inci=""
	....s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	....s Type=$p(ScgInfo,"^",3)
	....q:Type'=StkType
	....s highflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	....q:highflag="Y"			;过滤高值耗材
	....s IL=$o(^INCI("IL_LOC",LocId,Inci,""))
	....q:IL=""
	....s Incil=Inci_"||"_IL
	....
	....s BatSpFlag=..sssBatSpFlag(HospId,Inci,"",OrdDate)
	....i (BatSpFlag=1)&&$d(^DHCOEDISQTY(Dsp,"I")) d
	.....;批次价模式
	.....s DspSub=0
	.....f  s DspSub=$o(^DHCOEDISQTY(Dsp,"I",DspSub)) q:DspSub=""  d
	......q:+DspSub'>0
	......s Inclb=$p(^DHCOEDISQTY(Dsp,"I",DspSub),"^",1)
	......s qty=$p(^DHCOEDISQTY(Dsp,"I",DspSub),"^",2)
	......q:Inclb=""
	......s DspBatId=Dsp_"||"_DspSub
	......;s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty(Inclb,-qty)
	......s ReservedObj={}
	......s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspBatId,ReservedObj.Inclb=Inclb,ReservedObj.Qty=-qty
	......s ReservedParams=ReservedObj.%ToJSON()
	......s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	....e  d
	.....;统一价模式
	.....;s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateResQty(Incil,-qty)
	.....s ReservedObj={}
	.....s ReservedObj.Type="Oeori",ReservedObj.Pointer=Oeori,ReservedObj.Incil=Incil,ReservedObj.Qty=-qty
	.....s ReservedParams=ReservedObj.%ToJSON()
	.....s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	
	q ""
}

/// 判断该材料哪些科室有库存
/// w ##class(web.DHCSTMHUI.LocItmStk).IsLocStock(1530)
ClassMethod IsLocStock(inci As %String) As %String
{
	n (inci)
	s childSub="",LocStr=""
	f  s childSub=$o(^INCI(inci,"IL",childSub))  q:childSub=""  d
	.q:$d(^INCI(inci,"IL",childSub))'="11"
	.s loc=$p(^INCI(inci,"IL",childSub),"^",1)
	.s locdesc=$p(^CTLOC(loc),"^",2)
	.s LogQty=$p(^INCI(inci,"IL",childSub),"^",3)
	.s locdescqty=locdesc_":"_LogQty
	.i LogQty>0  d
	..s LocStr=locdescqty_","_LocStr
	
	q LocStr
}

/// Descript:	查询在途明细
/// Creator:	wangjiabin
/// CreateDate:	2021-08-09
/// Input:		incil
/// Output:		
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmStk","GetReservedQtyInfo",^templxt("111111"))
Query GetReservedQtyInfo(Incil As %String) As Query(ROWSPEC = "Type,Oeori,PatNo,PatName,OrdLocDesc,Qty:%Float,UomDesc,OrdDate,OrdTime") [ SqlProc ]
{
}

ClassMethod GetReservedQtyInfoExecute(ByRef qHandle As %Binary, Incil As %String) As %Status
{
	n (qHandle,Incil)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Incil="" $$$OK
	s Inci=$p(Incil,"||",1),IL=$p(Incil,"||",2)
	s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	s ReservedQty=$p(^INCI(Inci,"IL",IL),"^",10)
	
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	
	s Clear="N"
	s RowId=0
	f  s RowId=$o(^User.MATReservedDetailI("Incil",Incil,Clear,RowId)) q:RowId=""  d
	.s ResDetailInfo=^User.MATReservedDetailD(RowId)
	.s Type=$lg(ResDetailInfo,2)
	.s Pointer=$lg(ResDetailInfo,3)
	.s Incil=$lg(ResDetailInfo,4)
	.s Inclb=$lg(ResDetailInfo,5)
	.s Qty=$lg(ResDetailInfo,6)
	.s LocId=$lg(ResDetailInfo,7)
	.s Date=$lg(ResDetailInfo,8)
	.s Time=$lg(ResDetailInfo,9)
	.s Date=..DL2H(Date)
	.s Time=..TL2H(Time)
	.
	.s (PatNo,PatName,OrdLocDesc)=""
	.i Type="DspBatch" d
	..s Dsp=$p(Pointer,"||",1)
	..q:Dsp=""
	..s Oeori=$p(^DHCOEDISQTY(Dsp),"^",1)
	..s Ord=$p(Oeori,"||",1),OrdCh=$p(Oeori,"||",2)
	..q:(Ord="")||(OrdCh="")
	..s OrdLocId=$p(^OEORD(Ord,"I",OrdCh,1),"^",3)
	..s OrdLocDesc=$s(OrdLocId'="":$p(^CTLOC(OrdLocId),"^",2),1:"")
	..s AdmId=$p(^OEORD(Ord),"^",1)
	..s PatObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(AdmId)
	..s PatId=PatObj.PatId
	..s PatName=PatObj.PatName
	..s PatNo=PatObj.PatNo
	.e  i Type="Oeori" d
	..s Oeore=Pointer
	..s Ord=$p(Oeore,"||",1),OrdCh=$p(Oeore,"||",2)
	..q:(Ord="")||(OrdCh="")
	..s OrdLocId=$p(^OEORD(Ord,"I",OrdCh,1),"^",3)
	..s OrdLocDesc=$s(OrdLocId'="":$p(^CTLOC(OrdLocId),"^",2),1:"")
	..s AdmId=$p(^OEORD(Ord),"^",1)
	..s PatObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(AdmId)
	..s PatId=PatObj.PatId
	..s PatName=PatObj.PatName
	..s PatNo=PatObj.PatNo
	.e  i Type="Inrqi" d
	..s Inrqi=Pointer
	..s Inrq=$p(Inrqi,"||",1)
	..s PatNo=$p(^INRQ(Inrq),"^",1)		;请求单号
	..s OrdLocId=$p(^INRQ(Inrq),"^",6)	;请求科室
	..s OrdLocDesc=$s(OrdLocId'="":$p(^CTLOC(OrdLocId),"^",2),1:"")
	.
	.d OutPutRowReservedQty
	
	Quit $$$OK
OutPutRowReservedQty
	s Data=$lb(Type,Pointer,PatNo,PatName,OrdLocDesc,Qty,BUomDesc,Date,Time)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.LocItmStk).JsSaveStkBin("[{""Incil"":""2902||4"",""Inci"":""2902"",""InciCode"":""GZ00137"",""InciDesc"":""一次性材料费(血管成型术用套件)"",""StkBin"":"""",""PurUomDesc"":""套"",""BUomDesc"":""套"",""PurStockQty"":""0"",""StockQty"":""0"",""StkQtyUom"":""0"",""Sp"":""285"",""SpAmt"":""0"",""Rp"":""285"",""RpAmt"":""0"",""Spec"":"""",""ManfDesc"":""爱尔兰"",""OfficalCode"":"""",""ManFlag"":""N"",""DirtyQty"":""0"",""AvaQty"":""0"",""HVFlag"":""Y"",""VendorDesc"":""新疆众康九安科技有限公司"",""ReservedQty"":""0"",""Model"":"""",""LastVenDesc"":"""",""ScgDesc"":""医疗"",""IncscDesc"":""高值材料"",""MatInsuCode"":"""",""MatInsuDesc"":"""",""OfficialCat"":"""",""ClinicCat"":"""",""StkBinId"":""22""}]")
ClassMethod JsSaveStkBin(Detail As %String) As %Library.String
{
	n (Detail)
	s $zt=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveStkBin(Detail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod SaveStkBin(Detail As %String) As web.DHCSTMHUI.RtnObj
{
	n (Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Incil=Obj.%Get("Incil")
		s StkBin=Obj.%Get("StkBinId")
		&sql(Update INC_ItmLoc Set INCIL_INCSB_DR=:StkBin Where INCIL_RowId=:Incil)
		i SQLCODE d RtnObj.Err(-2,"","修改货位码失败!")
		q:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

}
