Import sqluser

/// Descript:	依据消耗生成采购计划单
/// Creator:	lxt
/// CreateDate:	2018-09-11
Class web.DHCSTMHUI.INPurPlanAuxByConsume Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	依据消耗生成采购计划单
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		dhc_intrans
/// Input:		排序，查询条件
/// Return：	采购计划单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlanAuxByConsume","QueryLocItmForPurch","","","{""PurLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""31/10/2018"",""ConsumeLoc"":"""",""StkScg"":"""",""EndDate"":""30/11/2018"",""TFlag"":""Y"",""KFlag"":""Y"",""PYFHFlag"":""Y"",""RowId"":"""",""UseDays"":0,""TransType"":""T,K,P,Y,F,H""}")
Query QueryLocItmForPurch(Params As %String) As Query(ROWSPEC = "InciId,InciCode,InciDesc,PUomId,PUomDesc,PurQty:%Float,VendorId,VendorDesc,ManfId,ManfDesc,StkQty:%Float,Rp:%Float,CarrierId,CarrierDesc,DispensQty:%Float,BUomId,ConFac:%Float,ApcWarn,UomId,UomDesc,Qty:%Float") [ SqlProc ]
{
}

ClassMethod QueryLocItmForPurchExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s LocId=PJObj.%Get("ConsumeLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s PurLocId=PJObj.%Get("PurLoc")
	s StkGrpId=PJObj.%Get("StkScg")
	s TypeStr=PJObj.%Get("TransType")
	s UseDays=PJObj.%Get("UseDays")
	s UserId=PJObj.%Get("gUserId")
	
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s pHospId=..sssHospId(PurLocId)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),PurLocId,StkGrpId,pHospId)  //若类组为空，则传递User类组串
	s DspDays=EndDate-StartDate+1           ;days for dispensing
	
	//按照消耗科室查询
	i LocId'=""  d
	.s Pid=..CalcDispQty(LocId,StartDate,EndDate,StkGrpId,TypeStr)  ; calculate the data
	.s count=0
	.s InciId=0
	.f  s InciId=$o(^TMPINPURPLAN(Pid,"DISP",InciId))  q:InciId=""  d
	..s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,LocId,+$h)
	..s DispensQty=^TMPINPURPLAN(Pid,"DISP",InciId)  //消耗量
	..s PermQty=(DispensQty/DspDays)  ;日均消耗量
	..i (UseDays="")!(UseDays=0)  d
	...s PurQty=DispensQty 
	..e  d
	...s PurQty=PermQty*UseDays-StkQty
	..s PurQty=+PurQty			//需采购数量
	..q:PurQty'>0
	..
	..s InciCode=$p(^INCI(InciId,1),"^",1)
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..q:BUomId="" 
	..s PUomId=$p(^INCI(InciId,3),"^",6)
	..i PUomId="" s PUomId=BUomId
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	..s DispensQty=DispensQty/ConFac
	..s DispensQty=$fn(DispensQty,"",2)
	..s StkQty=$fn((StkQty/ConFac),"",0)
	..s PurQty=$fn((PurQty/ConFac),"",0)
	..s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	..s ItmInfo=##class(web.DHCSTMHUI.INPurPlan).GetItmStr(InciId,Params)
	..s VendorId=$p(ItmInfo,"^",1)
	..s VendorDesc=$p(ItmInfo,"^",2)
	..s ManfId=$p(ItmInfo,"^",3)
	..s ManfDesc=$p(ItmInfo,"^",4)
	..s CarrierId=$p(ItmInfo,"^",5)
	..s CarrierDesc=$p(ItmInfo,"^",6)
	..s Rp=$p(ItmInfo,"^",9)
	..
	..s CheckCertParam={}.%Set("Inci",InciId).%Set("Manf",ManfId).%Set("Vendor",VendorId).%Set("gHospId",pHospId).%ToJSON()
	..s CheckCertObj=##class(web.DHCSTMHUI.DHCCertDetail).Check(CheckCertParam)
	..s ApcWarn={}.%FromJSON(CheckCertObj).%Get("Warn")
	..
	..s UomId=PUomId
	..s UomDesc=PUomDesc
	..s Qty=PurQty
	..d OutPutRow
	.k ^TMPINPURPLAN(Pid,"DISP")
	.
	e  d
	.s InciId=0
	.f  s InciId=$o(^INCI(InciId)) q:+InciId=0  d
	..s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	..s TmpStkGrpId=$p(StkGrpInfo,"^",5)
	..s StkType=$p(StkGrpInfo,"^",3)
	..q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
	..q:StkType'=..sssCode()
	..
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..q:BUomId=""
	..s DispensQty=..CalcItmDispQty(InciId,StartDate,EndDate,TypeStr,PurLocId)  //消耗量
	..s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,PurLocId,+$h)
	..i (UseDays="")!(UseDays=0)  d
	...s PurQty=DispensQty
	..e  d
	...s PermQty=(DispensQty/DspDays)	;日均消耗量
	...s PurQty=PermQty*UseDays-StkQty	;需采购数量
	..s PurQty=+PurQty
	..q:PurQty'>0
	..
	..s InciCode=$p(^INCI(InciId,1),"^",1)
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s PUomId=$p(^INCI(InciId,3),"^",6)
	..i PUomId="" s PUomId=BUomId
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	..s DispensQty=DispensQty/ConFac
	..s DispensQty=$fn(DispensQty,"",2)
	..s StkQty=$fn((StkQty/ConFac),"",0)
	..s PurQty=$fn((PurQty/ConFac),"",0)
	..s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	..s ItmInfo=##class(web.DHCSTMHUI.INPurPlan).GetItmStr(InciId,Params)
	..s VendorId=$p(ItmInfo,"^",1)
	..s VendorDesc=$p(ItmInfo,"^",2)
	..s ManfId=$p(ItmInfo,"^",3)
	..s ManfDesc=$p(ItmInfo,"^",4)
	..s CarrierId=$p(ItmInfo,"^",5)
	..s CarrierDesc=$p(ItmInfo,"^",6)
	..s Rp=$p(ItmInfo,"^",9)
	..
	..s CheckCertParam={}.%Set("Inci",InciId).%Set("Manf",ManfId).%Set("Vendor",VendorId).%Set("gHospId",pHospId).%ToJSON()
	..s CheckCertObj=##class(web.DHCSTMHUI.DHCCertDetail).Check(CheckCertParam)
	..s ApcWarn={}.%FromJSON(CheckCertObj).%Get("Warn")
	..
	..s UomId=PUomId
	..s UomDesc=PUomDesc
	..s Qty=PurQty
	..d OutPutRow
	. 
	Quit $$$OK
OutPutRow
	s Data=$lb(InciId,InciCode,InciDesc,PUomId,PUomDesc,PurQty,VendorId,VendorDesc,ManfId,ManfDesc,StkQty,Rp,CarrierId,CarrierDesc,DispensQty,BUomId,ConFac,ApcWarn,UomId,UomDesc,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取采购数量
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		INC_ItmLoc
/// Input:		消耗科室id,开始日期,截止日期,类组id,业务类型串
/// Return：	^TMPINPURPLAN(Pid,"DISP")
ClassMethod CalcDispQty(LocId As %String, StartDate As %String, EndDate As %String, StkGrpId As %String, TypeStr As %String) As %Library.String
{
	n (LocId,EndDate,StartDate,StkGrpId,TypeStr)
	s Pid=..NewPid()
	k ^TMPINPURPLAN(Pid,"DISP")
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:Inci=""  d
	.s Ch=$o(^INCI("IL_LOC",LocId,Inci,""))
	.q:Ch=""
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s TmpStkGrpId=$p(StkGrpInfo,"^",5)
	.s StkType=$p(StkGrpInfo,"^",3)
	.q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
	.q:StkType'=..sssCode()
	.s Incil=Inci_"||"_Ch
	.s Qty=..CalcLocItmDispQty(Incil,StartDate,EndDate,TypeStr)
	.q:Qty=0
	.i (TypeStr="K")&&(Qty<0) s Qty=-Qty		;2015-07-30 仅统计K台帐时,按正数处理
	.s ^TMPINPURPLAN(Pid,"DISP",Inci)=Qty
	.
	q Pid
}

/// Descript:	计算某一科室库存项的消耗量
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		INC_ItmLoc
/// Input:		科室库存id,开始日期,截止日期,业务类型串
/// Return：	消耗量
ClassMethod CalcLocItmDispQty(Incil As %String, StartDate As %String, EndDate As %String, TypeStr As %String) As %Library.String
{
	n (Incil,StartDate,EndDate,TypeStr)
	s TotalQty=0
	s DispQty=0
	q:TypeStr="" 0
	s TypeCnt=$l(TypeStr,",")
	f i=1:1:TypeCnt d
	.s Type=$P(TypeStr,",",i)
	.f Date=StartDate:1:EndDate d
	..s INTR=0
	..f  s INTR=$o(^DHCINTR(0,"ILTYPEDATE",Incil,Type,Date,INTR)) q:INTR=""  d
	...s Uom=$p(^INCI(+Incil,1),"^",10)
	...s Inclb=$p(^DHCINTR(INTR),"^",7) 
	...s DispUom=$p(^DHCINTR(INTR),"^",10)
	...s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(DispUom,Uom)
	...s Dispqty=$p(^DHCINTR(INTR),"^",6)
	...s Dispqty=Dispqty*Fac
	...s TotalQty=TotalQty+Dispqty
	..
	.
	q (-1)*TotalQty
}

/// Descript:	计算某一库存项的全院消耗量(实际发药数)
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_InTrans
/// Input:		库存项id,开始日期,截止日期,业务类型串
/// Return：	消耗量
ClassMethod CalcItmDispQty(Inci As %String, StartDate As %String, EndDate As %String, TypeStr As %String, PurLocId) As %Library.String
{
	n (Inci,StartDate,EndDate,TypeStr,PurLocId)
	s TotalQty=0
	s DispQty=0
	q:TypeStr="" 0
	s TypeCnt=$l(TypeStr,",")
	f i=1:1:TypeCnt d
	.s Type=$P(TypeStr,",",i)
	.f Date=StartDate:1:EndDate d
	..s INTR=0
	..f  s INTR=$o(^DHCINTR(0,"INCI",Inci,Date,INTR)) q:INTR=""  d
	...s type=$p($g(^DHCINTR(INTR)),"^",1)
	...q:type'=Type
	...s Uom=$p(^INCI(+Inci,1),"^",10)
	...s Inclb=$p(^DHCINTR(INTR),"^",7)
	...s ch=$p(Inclb,"||",2)
	...s LocId=$p(^INCI(+Inclb,"IL",ch),"^",1)
	...q:(PurLocId'="")&&(PurLocId'=LocId) 
	...s DispUom=$p(^DHCINTR(INTR),"^",10)
	...s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(DispUom,Uom)
	...s Dispqty=$p(^DHCINTR(INTR),"^",6)
	...s Dispqty=Dispqty*Fac
	...s TotalQty=TotalQty+Dispqty
	..
	.
	q (-1)*TotalQty
}

}
