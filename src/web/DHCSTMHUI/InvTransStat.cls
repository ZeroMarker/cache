Import sqluser

/// Descript:	发票台账汇总
/// Creator:	lxt
/// CreateDate:	2021-10-12
Class web.DHCSTMHUI.InvTransStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	发票台账汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_PayTrans
/// Input:		
/// Return：	入库汇总信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InvTransStat","QueryDetail",^tmpzx("inv"))
Query QueryDetail(Params As %Text) As Query(ROWSPEC = "Type,TrDate,TrId,Inclb,RpAmt:%Float,TrTime,VendorId,VendorDesc,OperateType,StkType,GiftFlag,AdjCheque,SourceOfFund,SourceOfFundDesc,InvNo,InvDate,ManfId,ManfDesc,CertNo,CertDesc,InciCode,InciDesc,BUomId,PUomId,BUomDesc,PUomDesc,HVFlag,ChargeFlag,ImpFlag,PbFlag,BookCatId,BookCatDesc,IncscId,IncscDesc,ScgId,StkGrpDesc,MarkTypeId,MarkType,Spec,Model,Brand,MonitorFlag,BatExp,BatchNo,ExpDate,StkBin") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	;tro  s ^tmpzx("inv")=Params
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PLocStr=PJObj.%Get("Loc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s RetFlag=PJObj.%Get("RetFlag")
	q:PLocStr="" $$$OK
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PStkGrpId=PJObj.%Get("ScgStk")
	s PStkCatId=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PManfId=PJObj.%Get("Manf")
	s PVendorId=PJObj.%Get("Vendor")
	s POperateType=PJObj.%Get("OperateType")
	s PInvNo=PJObj.%Get("InvNo")
	s PHvFlag=PJObj.%Get("HvFlag")
	s PSourceOfFund=PJObj.%Get("SourceOfFund")
	s PChargeFlag=PJObj.%Get("ChargeFlag")
	s PFindTypeFlag=PJObj.%Get("AdjCheque")		;赠送或者调价换票
	s gUserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s PScgType=PJObj.%Get("ssStkgrptype")		//类组类型 M-库管；O-财务
	
	s PHospId=..sssHospId(+PLocStr)
	s:PHospId="" PHospId=gHospId
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s PStartTime=..TH2L(PStartTime)
	s PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s TotalScgStr=""
	s LocLength=$l(PLocStr,",")
	f i=1:1:LocLength d
	.s LocId=$p(PLocStr,",",i)
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,PScgType,LocId,PStkGrpId,"")
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s PStkGrpId=TotalScgStr
	s PStkType=..sssCode()
	
	i RetFlag=1 d
	.s TypeStr="G^GC"
	e  i RetFlag=2 d
	.s TypeStr="R^RC"
	e  d
	.s TypeStr="G^GC^R^RC"
	
	f i=1:1:LocLength d
	.s PLocId=$p(PLocStr,",",i)
	.s Type=""
	.f  s Type=$o(^DHCPAYTRANS(0,"LOCTYPEDATE",PLocId,Type)) q:Type=""  d
	..f Date=PStartDate:1:PEndDate d
	...s TrDate=..DL2H(Date)
	...s TrId=""
	...f  s TrId=$o(^DHCPAYTRANS(0,"LOCTYPEDATE",PLocId,Type,Date,TrId)) q:TrId=""  d
	....s TrInfo=^DHCPAYTRANS(TrId)
	....s Pointer=$p(TrInfo,"^",2)
	....s VendorId=$p(TrInfo,"^",4)
	....s Inclb=$p(TrInfo,"^",5)
	....s RpAmt=$p(TrInfo,"^",6)
	....s TrTime=$p(TrInfo,"^",8)
	....s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	....s BatchNo=$p(BatExp,"^",1)
	....s ExpDate=$p(BatExp,"^",2)
	....;台帐信息过滤
	....q:(Date=PStartDate)&&(PStartTime'="")&&(TrTime<PStartTime)
	....q:(Date=PEndDate)&&(PEndTime'="")&&(TrTime>=PEndTime)
	....s Parref=$p(Pointer,"||",1)
	....s Chl=$p(Pointer,"||",2)
	....q:((Type="G")||(Type="GC"))&&('$d(^DHCINGR(Parref))||'$d(^DHCINGR(Parref,"GRI",Chl)))
	....q:((Type="R")||(Type="RC"))&&('$d(^INGRT(Parref))||'$d(^INGRT(Parref,"DHCGRR",Chl)))
	....
	....//单据过滤
	....s (VendorId,OperateType,StkType,GiftFlag,AdjCheque,SourceOfFund)=""
	....s (InvNo,ManfId,InvDate)=""
	....i ((Type="G")||(Type="GC")) d //入库
	.....s IngrStr=^DHCINGR(Parref)
	.....s IngriItmStr=^DHCINGR(Parref,"GRI",Chl)
	.....s VendorId=$p(IngrStr,"^",3)
	.....s OperateType=$p(IngrStr,"^",23)
	.....s StkType=$p(IngrStr,"^",30)
	.....s GiftFlag=$p(IngrStr,"^",31)
	.....s AdjCheque=$p(IngrStr,"^",32)
	.....s SourceOfFund=$p(IngrStr,"^",36)
	.....s InvNo=$p(IngriItmStr,"^",27)
	.....s ManfId=$p(IngriItmStr,"^",29)
	.....s InvDate=$p(IngriItmStr,"^",34)
	.....s CertNo=$p(IngriItmStr,"^",42)
	....e  d //退货
	.....s IngrtStr=^INGRT(Parref)
	.....s IngrtiItmStr=^INGRT(Parref,"DHCGRR",Chl)
	.....s VendorId=$p(IngrtStr,"^",2)
	.....s StkType=$p(IngrtStr,"^",16)
	.....s Ingri=$p(IngrtiItmStr,"^",1)
	.....s InvNo=$p(IngrtiItmStr,"^",12)
	.....s InvDate=$p(IngrtiItmStr,"^",14)
	.....s ManfId=$p(IngrtiItmStr,"^",29)
	.....s Ingr=$p(Ingri,"||",1),IngriCh=$p(Ingri,"||",2)
	.....s AdjCheque=$p(^DHCINGR(Ingr),"^",11)
	.....s OperateType=$p(^DHCINGR(Ingr),"^",23)
	.....s SourceOfFund=$p(^DHCINGR(Ingr),"^",36)
	.....s CertNo=$p(^DHCINGR(Ingr,"GRI",IngriCh),"^",42)
	.....s GiftFlag=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetGiftFlagByInclb(Inclb)
	....
	....q:(PManfId'="")&&(ManfId'=PManfId)
	....q:(PInvNo'="")&&(InvNo'[PInvNo)
	....q:StkType'=PStkType
	....q:VendorId=""
	....q:(PVendorId'="")&&(VendorId'=PVendorId)
	....q:(POperateType'="")&&(OperateType'=POperateType)		;按入库类型
	....q:(PFindTypeFlag="A")&&(AdjCheque'="Y")				;按调价换票
	....q:(PFindTypeFlag="G")&&(GiftFlag'="Y")				;按赠送
	....q:(PSourceOfFund'="")&&(SourceOfFund'=PSourceOfFund)
	....
	....;库存项信息过滤
	....s Inci=$p(Inclb,"||",1)
	....q:(PInci'="")&&(Inci'=PInci)
	....q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3))
	....i '$d(InciInfoArray(Inci)) d
	.....s InciObj=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciObj(Inci,PScgType,PHospId)
	.....s InciInfoArray(Inci)=InciObj
	....s InciObj=InciInfoArray(Inci)
	....
	....s InciCode=InciObj.InciCode,InciDesc=InciObj.InciDesc
	....s BUomId=InciObj.BUomId,PUomId=InciObj.PUomId,UomFac=InciObj.UomFac,BUomDesc=InciObj.BUomDesc,PUomDesc=InciObj.PUomDesc
	....s HVFlag=InciObj.HVFlag,ChargeFlag=InciObj.ChargeFlag,BookCatId=InciObj.BookCatId,BookCatDesc=InciObj.BookCatDesc
	....s IncscId=InciObj.IncscId,IncscDesc=InciObj.IncscDesc
	....s ScgId=InciObj.ScgId,StkGrpDesc=InciObj.StkGrpDesc
	....s MarkTypeId=InciObj.MarkTypeId,MarkType=InciObj.MarkType
	....s ImpFlag=InciObj.ImpFlag,PbFlag=InciObj.PbFlag
	....s Spec=InciObj.Spec,Model=InciObj.Model,Brand=InciObj.Brand
	....s MonitorFlag=InciObj.MonitorFlag
	....s CertInfo=##class(web.DHCSTMHUI.DHCMatRegCert).getByRegNo(CertNo)
	....s CertInfo={}.%FromJSON(CertInfo)
	....s CertDesc=CertInfo.%Get("MRCInciDesc")
	....
	....q:(PHvFlag'="")&&(HVFlag'=PHvFlag)
	....q:(PChargeFlag'="")&&(ChargeFlag'=PChargeFlag)
	....q:(PInciDesc'="")&&(InciDesc'[PInciDesc)
	....q:(PStkGrpId'="")&&(("^"_PStkGrpId_"^")'[("^"_ScgId_"^"))
	....q:(PStkCatId'="")&&((","_PStkCatId_",")'[(","_IncscId_","))
	....
	....;变量取值
	....s VendorDesc=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(Date,VendorId)
	....s ManfDesc=$s(ManfId'="":$p(^PHMNF(ManfId),"^",2),1:"")
	....s InvDate=..DL2H(InvDate)
	....s SourceOfFundDesc=$s(SourceOfFund'="":$p(^DHCSOUROFFUND(SourceOfFund),"^",2),1:"")
	....s StkBinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(PLocId,Inci)
	....s StkBin=$p(StkBinInfo,"^",2)
	....
	....d OutputRow
	
	Quit $$$OK

OutputRow
	s Data=$lb(Type,TrDate,TrId,Inclb,RpAmt,TrTime,VendorId,VendorDesc,OperateType,StkType,
			GiftFlag,AdjCheque,SourceOfFund,SourceOfFundDesc,InvNo,InvDate,ManfId,ManfDesc,CertNo,CertDesc,
			InciCode,InciDesc,BUomId,PUomId,BUomDesc,PUomDesc,HVFlag,ChargeFlag,ImpFlag,PbFlag,
			BookCatId,BookCatDesc,IncscId,IncscDesc,ScgId,StkGrpDesc,MarkTypeId,MarkType,Spec,Model,
			Brand,MonitorFlag,BatExp,BatchNo,ExpDate,StkBin)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
