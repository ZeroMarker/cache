Import sqluser

/// Descript:	采购计划制单(明细)
/// Creater:	lxt
/// CreateDate:	2018-05-09
Class web.DHCSTMHUI.INPurPlanItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询采购计划单明细
/// Creator:	lxt
/// CreateDate:	2018-05-09
/// Table:		IN_PurPlanItm
/// Input:		排序，查询条件
/// Return：	采购计划单明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlanItm","Query","9")
Query Query(PurId As %String, Params As %String = "{}") As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Spec,SpecDesc,ManfId,ManfDesc,Qty:%Float,UomId,UomDesc,Rp:%Float,Sp:%Float,RpAmt:%Float,SpAmt:%Float,VendorId,VendorDesc,CarrierId,CarrierDesc,Inpoi,ReqLocId,ReqLocDesc,StkQty:%Float,MaxQty:%Float,MinQty:%Float,RecQty:%Float,LeftQty:%Float,BUomId,ConFacPur:%Float,LocQty:%Float,ReqQty:%Float,TrfQty:%Float,LocAvaQty:%Float,DateNeeded,Remark") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, PurId As %String, Params As %String = "{}") As %Status
{
	n (qHandle,PurId,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s InppiIdStr=PJObj.%Get("InppiIdStr")
	
	s SqlStr="select INPPI_Rowid as RowId,"
	s SqlStr=SqlStr_"INPPI_INCI_DR InciId,INPPI_INCI_DR->INCI_Code InciCode,INPPI_INCI_DR->INCI_Desc InciDesc,"
	s SqlStr=SqlStr_"INPPI_PHMNF_DR ManfId,INPPI_PHMNF_DR->PHMNF_Name ManfName,"
	s SqlStr=SqlStr_"INPPI_Qty Qty,INPPI_CTUOM_DR UomId,INPPI_CTUOM_DR->CTUOM_Desc UomDesc,"
	s SqlStr=SqlStr_"INPPI_PurPrice Rp,INPPI_Sp Sp,"
	s SqlStr=SqlStr_"INPPI_APCVM_DR VendorId,INPPI_APCVM_DR->APCVM_Name VendorName,"
	s SqlStr=SqlStr_"INPPI_Carrier_DR CarrierId,INPPI_Carrier_DR->CA_Desc CarrierDesc,"
	s SqlStr=SqlStr_"INPPI_INPOI_DR Inpoi,"
	s SqlStr=SqlStr_"INPPI_RLOC_DR ReqLocId,INPPI_RLOC_DR->CTLOC_Desc ReqLocDesc,"
	s SqlStr=SqlStr_"INPPI_SpecList SpecList,"
	s SqlStr=SqlStr_"INPPI_Remark Remark,"
	s SqlStr=SqlStr_"INPPI_Parref->INPP_CTLOC_DR FCTLocId,"
	s SqlStr=SqlStr_"INPPI_ReqCanceled ReqCancelFlag, INPPI_DateNeeded DateNeeded"
	s SqlStr=SqlStr_" from IN_PurPlanItm"
	s SqlStr=SqlStr_" where INPPI_Parref="_PurId
	s SqlStr=SqlStr_" order by INPPI_ChildSub asc"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		continue:(InppiIdStr'="")&&(("^"_InppiIdStr_"^")'[("^"_RowId_"^"))
		s InciId = Result.Data("InciId")
		s InciCode = Result.Data("InciCode")
		s InciDesc = Result.Data("InciDesc")
		s ManfId = Result.Data("ManfId")
		s ManfDesc = Result.Data("ManfName")
		s VendorId = Result.Data("VendorId")
		s VendorDesc = Result.Data("VendorName")
		s Qty = Result.Data("Qty")
		s UomId = Result.Data("UomId")
		s UomDesc = Result.Data("UomDesc")
		s Rp = Result.Data("Rp")
		s Sp = Result.Data("Sp")
		s CarrierId = Result.Data("CarrierId")
		s CarrierDesc = Result.Data("CarrierDesc")
		s Inpoi = Result.Data("Inpoi")
		s ReqLocId = Result.Data("ReqLocId")
		s ReqLocDesc = Result.Data("ReqLocDesc")
		s SpecDesc = Result.Data("SpecList")
		s FCTLocId = Result.Data("FCTLocId")
		s ReqCancelFlag = Result.Data("ReqCancelFlag")
		s DateNeeded=Result.Data("DateNeeded")
		s Remark=Result.Data("Remark")
		CONTINUE:ReqCancelFlag="Y"
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(InciCode,InciId)
		s CtLocId=$p(^INPP(PurId),"^",7) 
		i ReqLocId'="" d
		.s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciId,ReqLocId,UomId,+$h)
		e  d
		.s StkQty=""
		s QtyInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetItmLocMNRQtyUO(InciId,FCTLocId,UomId)
		s MinQty=$p(QtyInfo,"^",1)
		s MaxQty=$p(QtyInfo,"^",2)
		s RpAmt=Rp*Qty
		s SpAmt=Sp*Qty
		s RecQty=..GetImpQty(RowId,UomId)
		s LeftQty=Qty-RecQty
		s:LeftQty<0 LeftQty=0	//不显示负数
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s ConFacPur=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		///本科室数量
		s LocQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciId,CtLocId,UomId,+$h)
		s LocAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(CtLocId,InciId,UomId)
		s ReqQty=0,TrfQty=0
		s ret=..TransReqQty(RowId,UomId,ReqQty,TrfQty)
		
		s DateNeeded=..DL2H(DateNeeded)
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,InciId,InciCode,InciDesc,Spec,
		SpecDesc,ManfId,ManfDesc,Qty,UomId,
		UomDesc,Rp,Sp,RpAmt,SpAmt,
		VendorId,VendorDesc,CarrierId,CarrierDesc,Inpoi,
		ReqLocId,ReqLocDesc,StkQty,MaxQty,MinQty,
		RecQty,LeftQty,BUomId,ConFacPur,LocQty,
		ReqQty,TrfQty,LocAvaQty,DateNeeded,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存采购明细信息
/// Creator:	lxt
/// CreateDate:	2018-05-23
/// Table:		IN_PurPlanItm
/// Input:		主表id，明细信息
/// Return：	失败，成功
/// "[{""RowId"":""32||1"",""InciId"":""9628"",""InciCode"":""cl0420001"",""InciDesc"":""cl0420普通物资"",""Spec"":"""",""SpecDesc"":""aaa"",""ManfId"":""7"",""ManfDesc"":""3mzgyx-3M中国有限公司"",""Qty"":""20"",""UomId"":""8"",""UomDesc"":""包"",""Rp"":""19"",""Sp"":""22.9"",""RpAmt"":""380"",""SpAmt"":""458"" ,""VendorId"":""782"",""VendorDesc"":""DSJT-鼎盛集团"",""CarrierId"":""36"",""CarrierDesc"":""cl配送201601"",""Inpoi"":"""",""ReqLocId"":""1"",""ReqLocDesc"":""CK-产科"",""StkQty"":""0"",""MaxQty"":""0.00"",""MinQty"":""0.00"",""RecQty"":""0"",""LeftQty"":""20"",""BUomId"":""8"",""Confac"":""1"",""LocQty"":""22"",""ReqQty"":""0"",""TrfQty"":""0"",""LocAvaQty"":""22"",""CarrierDescDesc"":""lcy配送商""}]"
ClassMethod Save(PurId As %String, Details As %String) As RtnObj
{
	n (PurId,Details)
	s MethodName=$CLASSNAME()_".Save"
	s RtnObj=##class(RtnObj).%New()
	i PurId="" s Sc=RtnObj.Err(-11,"","主单Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Details)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-11,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s AppName=##class(web.DHCSTMHUI.INPurPlan).%GetParameter("AppName")
	s LockName=AppName_PurId
	i ..sssLock(LockName)<0  d
	.s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s IncId=Obj.%Get("InciId")
		i IncId=0  s Sc=RtnObj.Err(-11,"","缺少明细数据！","",0)
		i RtnObj.success'=0  q
		s SpecDesc=Obj.%Get("SpecDesc")
		s ManfId=Obj.%Get("ManfId")
		s Qty=Obj.%Get("Qty")
		i +Qty=0  s Sc=RtnObj.Err(-11,"","采购数量为0","",0)
		i RtnObj.success'=0  q
		s UomId=Obj.%Get("UomId")
		s Rp=Obj.%Get("Rp")
		s VendorId=Obj.%Get("VendorId")
		s CarrierId=Obj.%Get("CarrierId")
		s ReqLocId=Obj.%Get("ReqLocId")
		s DateNeeded=Obj.%Get("DateNeeded")
		s Remark=Obj.%Get("Remark")
		s LocId=$p(^INPP(PurId),"^",7)
		s HospId=$p(^CTLOC(LocId),"^",22)
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId)
		s DateNeeded=..DH2L(DateNeeded)
		
		i RowId="" d
		.s Obj=##class(User.INPurPlanItm).%New()
		.d Obj.INPPIParrefSetObjectId(PurId)
		.s Chl=$o(^INPP(PurId,"PPI",""),-1)+1
		.s Obj.INPPIChildsub=Chl
		e  d
		.s Obj=##class(User.INPurPlanItm).%OpenId(RowId)
		d Obj.INPPIINCIDRSetObjectId(IncId)
		s Obj.INPPIQty=Qty
		d Obj.INPPICTUOMDRSetObjectId(UomId)
		s Obj.INPPIPurPrice=Rp
		d Obj.INPPIAPCVMDRSetObjectId(VendorId)
		d Obj.INPPIPHMNFDRSetObjectId(ManfId)
		d Obj.INPPICarrierDRSetObjectId(CarrierId)
		s Obj.INPPIAvailQty=Qty
		d Obj.INPPIRLOCDRSetObjectId(ReqLocId)
		s Obj.INPPISp=Sp
		s Obj.INPPISpecList=SpecDesc
		s Obj.INPPIRemark=Remark
		s Obj.INPPIDateNeeded=DateNeeded
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-11,"",MethodName_"保存明细失败!") q
		s RtnObj.rowid=Obj.%Id()
	}
	d ..sssUnLock(LockName)
	q RtnObj
}

/// Descript:	删除采购明细信息
/// 对象类型数据
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Delete(Params)
	q RtnObj.Json()
}

/// Descript:	删除采购明细信息
/// Creator:	lxt
/// CreateDate:	2018-05-23
/// Table:		IN_PurPlanItm
/// Input:		主表id，明细信息
/// Return：	失败，成功
ClassMethod Delete(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
 		i ##class(web.DHCSTMHUI.INPurPlan).AllowDel(+RowId)<0  s Sc=RtnObj.Err(-2,"","不允许删除!","",0)
		q:RtnObj.success'=0
		&sql(delete from IN_PurPlanItm where inppi_rowid=:RowId)
		i SQLCODE<0  s Sc=RtnObj.Err(-2,"","删除明细失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0  tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	查询请求科室,请求采购数量报表，科室请求采购物资明细信息显示
/// Creator:	lxt
/// CreateDate:	2018-05-23
/// Table:		IN_PurPlanItm
/// Input:		主表id，明细信息
/// Return：	失败，成功
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlanItm","INPurPlanItmReqLoc","13")
Query INPurPlanItmReqLoc(Parref As %String) As Query(ROWSPEC = "INPPI,inci,inciCode,inciDesc,qty:%Float,uomDesc,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,vendor,manf,inpoitm,carrier,valqty:%Float,ReqLoc,Reqlocid,ReqLocDesc,reqQty:%Float,Requom,Spec,LeftQty:%Float,InrqiRemark") [ SqlProc ]
{
}

ClassMethod INPurPlanItmReqLocExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s StrSql="select INPPI_Rowid as Rowid,INPPI_INCI_DR,INPPI_INCI_DR->INCI_Code as IncCode,INPPI_INCI_DR->INCI_Desc as IncDesc,"_
		"INPPI_PHMNF_DR,INPPI_PHMNF_DR->PHMNF_Name as Manf,INPPI_Qty,INPPI_CTUOM_DR,"_
		" INPPI_CTUOM_DR->CTUOM_Desc as UomDesc,INPPI_PurPrice,INPPI_Sp,INPPI_AvailQty,INPPI_APCVM_DR,"_
		" INPPI_APCVM_DR->APCVM_Name as Vendor,INPPI_Carrier_DR,INPPI_Carrier_DR->CA_Desc as Carrier,"_
		"INPPI_INPOI_DR,INPPI_RLOC_DR,INPPI_RLOC_DR->CTLOC_Desc as ReqLoc from IN_PurPlanItm "_
		" where INPPI_Parref="_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s INPPI = result.Data("Rowid")
		s inci = result.Data("INPPI_INCI_DR")
		s inciCode = result.Data("IncCode")
		s inciDesc = result.Data("IncDesc")
		s ManfId = result.Data("INPPI_PHMNF_DR")
		s manf = result.Data("Manf")
		s qty = result.Data("INPPI_Qty")
		s UomId = result.Data("INPPI_CTUOM_DR")
		s uomDesc = result.Data("UomDesc")
		s BUom=$p(^INCI(inci,1),"^",10)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(inciCode,inci)
		s rp = result.Data("INPPI_PurPrice")
		s sp = result.Data("INPPI_Sp")
		s rpAmt=rp*qty
		s spAmt=sp*qty
		s VenId = result.Data("INPPI_APCVM_DR")
		s vendor = result.Data("Vendor")
		s CarrierId = result.Data("INPPI_Carrier_DR")
		s carrier = result.Data("Carrier")
		s inpoitm= result.Data("INPPI_INPOI_DR")
		s valqty=result.Data("INPPI_AvailQty")
		s ReqLocId = result.Data("INPPI_RLOC_DR")
		s ReqLoc = result.Data("ReqLoc")
		s RecQty=..GetImpQty(INPPI,UomId)
		s LeftQty=qty-RecQty 
		s:LeftQty<0 LeftQty=0	;不显示负数
		s (INRqi,Reqlocid,ReqLocDesc,reqQty,Requom,InrqiRemark)=""
		&sql(SELECT PPREQI_REQITM_DR into :INRqi FROM DHC_INPPReqItm WHERE PPREQI_INPPI_Parref=:INPPI)
		i INRqi=""  d
		.s Reqlocid=ReqLocId
		.s ReqLocDesc=ReqLoc
		.d OutPutRowReq
		e   d
		.&sql(declare INPlanCursor cursor for
			select PPREQI_REQITM_DR->INRQI_ReqQty,PPREQI_REQITM_DR->INRQI_CTUOM_DR->CTUOM_Desc,PPREQI_REQITM_DR->INRQI_INRQ_Parref->INRQ_RecLoc_Dr,PPREQI_REQITM_DR->INRQI_INRQ_Parref->INRQ_RecLoc_Dr->CTLoc_Desc,PPREQI_REQITM_DR
			from DHC_INPPReqItm WHERE PPREQI_INPPI_Parref=:INPPI)
		.&sql(open INPlanCursor)
		.f  &sql(fetch INPlanCursor into :reqQty,:Requom,:Reqlocid,:ReqLocDesc,:Inrqi) q:SQLCODE  d
		..s dhcInrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,0))
		..s InrqiRemark=$s(dhcInrqi'="":$p($g(^DHCINRQI(dhcInrqi)),"^",2),1:"")
		..d OutPutRowReq
		.&sql(close INPlanCursor)
	}
 Quit $$$OK

OutPutRowReq
 s Data=$lb(INPPI,inci,inciCode,inciDesc,qty,uomDesc,rp,rpAmt,sp,spAmt,vendor,manf,inpoitm,carrier,valqty,ReqLoc,Reqlocid,ReqLocDesc,reqQty,Requom,Spec,LeftQty,InrqiRemark)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	删除某采购计划单所有明细信息
/// Creator:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:IN_PurplanItm
/// Input:采购计划主表id
/// Output:		
/// Return：成功:0，
/// -1   	;订单已经完成，不能删除
/// -2		;订单已经审核，不能删除
/// -3   ;删除计划明细失败
ClassMethod DeleteAll(Parref As %String) As %Library.String
{
	n (Parref)
	s $ZT=..sssError()
	q:Parref="" ""
	q:'$d(^INPP(Parref)) 0   ;已经删除
	s CompFlag=$p(^INPP(Parref),"^",8)
 	s AuditFlag=$p(^INPP(Parref),"^",10)
 	q:CompFlag="Y" -1   	;订单已经完成，不能删除
 	q:AuditFlag="Y" -2		;订单已经审核，不能删除
	;
	s Err=0
	&sql(Delete from IN_PurPlanItm  where INPPI_Parref=:Parref) 
	i SQLCODE'=0  d
	.s Err=-3
	q:Err'=0 -3   ;删除计划明细失败
	;
	q 0
}

/// Descript:取某采购明细对应的入库数量
/// Creator:	ZhangDongmei
/// CreateDate:	2012-08-03
/// Table:IN_PurplanItm，DHC_InGdRecItm
/// Input:采购计划明细id
/// Output:		
/// Return：入库数量
ClassMethod GetImpQty(PurItmId As %String, UomId As %String) As %Library.String
{
	n (PurItmId,UomId)
	q:PurItmId="" 0
	s TotalQty=0
	;
	s PoItmId=$p(^INPP(+PurItmId,"PPI",$p(PurItmId,"||",2)),"^",7)
	q:PoItmId="" 0
	s Ingr=0
	f  s Ingr=$o(^DHCINGR(0,"PODR",PoItmId,Ingr)) q:Ingr=""  d
	.s Chl=0
	.f  s Chl=$o(^DHCINGR(0,"PODR",PoItmId,Ingr,Chl)) q:Chl=""  d
	..s IncId=+$p(^DHCINGR(Ingr,"GRI",Chl),"^",25)
	..s Qty=$p(^DHCINGR(Ingr,"GRI",Chl),"^",4)
	..s RecUomId=$p(^DHCINGR(Ingr,"GRI",Chl),"^",10)
	..s BUomId=$p(^INCI(IncId,1),"^",10)
	..s PurUomId=$p(^INCI(IncId,3),"^",6)
	..s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RecUomId,BUomId)
	..s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	..s Qty=Qty*Fac1/Fac2
	..s TotalQty=TotalQty+Qty
	.
	q TotalQty
}

/// 检索采购单明细
/// Author:zhangxiao
/// Date:2013-06-15
/// Argu:
/// Parref - 采购单主表rowid
/// Return:
///  采购单明细信息数据(采购明细RowId，库存rowid，药品代码，药品名称，数量，单位，进价，进价金额，售价，售价金额，供应商，生产厂家,订单子表,配送商,可用数量,科室 )
Query INPurPlanItm(Parref As %String) As Query(ROWSPEC = "INPPI,inci,inciCode,inciDesc,qty:%Float,uomDesc,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,vendor,manf,inpoitm,carrier,valqty:%Float,ReqLoc") [ SqlProc ]
{
}

ClassMethod INPurPlanItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
  	s repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	q:Parref="" $$$OK
 	s StrSql="select INPPI_Rowid as Rowid,INPPI_INCI_DR,INPPI_INCI_DR->INCI_Code as IncCode,INPPI_INCI_DR->INCI_Desc as IncDesc,"_
		"INPPI_PHMNF_DR,INPPI_PHMNF_DR->PHMNF_Name as Manf,INPPI_Qty,INPPI_CTUOM_DR,"_
    	" INPPI_CTUOM_DR->CTUOM_Desc as UomDesc,INPPI_PurPrice,INPPI_Sp,INPPI_AvailQty,INPPI_APCVM_DR,"_
    	" INPPI_APCVM_DR->APCVM_Name as Vendor,INPPI_Carrier_DR,INPPI_Carrier_DR->CA_Desc as Carrier,"_
    	" INPPI_INPOI_DR,INPPI_RLOC_DR,INPPI_RLOC_DR->CTLOC_Desc as ReqLoc from IN_PurPlanItm "_
    	" where INPPI_Parref="_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q ""
	s count = 0
	While(result.Next())
	{	
		s INPPI = result.Data("Rowid")
		s inci = result.Data("INPPI_INCI_DR")
		s inciCode = result.Data("IncCode")
		s inciDesc = result.Data("IncDesc")
		s ManfId = result.Data("INPPI_PHMNF_DR")
		s manf = result.Data("Manf")
		s qty = result.Data("INPPI_Qty")
		s UomId = result.Data("INPPI_CTUOM_DR")
		s uomDesc = result.Data("UomDesc")
		s rp = result.Data("INPPI_PurPrice")
		s sp = result.Data("INPPI_Sp")
		s rpAmt=rp*qty
		s spAmt=sp*qty
		s VenId = result.Data("INPPI_APCVM_DR")
		s vendor = result.Data("Vendor")
		s CarrierId = result.Data("INPPI_Carrier_DR")
		s carrier = result.Data("Carrier")
		s inpoitm= result.Data("INPPI_INPOI_DR")
		s valqty=result.Data("INPPI_AvailQty")
		s ReqLocId = result.Data("INPPI_RLOC_DR")
		s ReqLoc = result.Data("ReqLoc")
		d OutPutRow
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(INPPI,inci,inciCode,inciDesc,qty,uomDesc,rp,rpAmt,sp,spAmt,vendor,manf,inpoitm,carrier,valqty,ReqLoc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 支配科室
ClassMethod GetDominLoc(loc As %String) As %String
{
 n (loc)
 s dLocs=""
  &sql(declare domiLoc cursor for 
   	select dhcloc_ctloc_dr From dhcst_ctloc where dhcloc_mainloc_dr = :loc)
  &sql(open domiLoc) 
 f  &sql(fetch domiLoc into :subLoc) q:SQLCODE  d
 .i dLocs="" s dLocs=subLoc
 .e  s dLocs=dLocs_","_subLoc
  &sql(close domiLoc)
 q dLocs
}

/// Descript:  拒绝某采购计划单明细
/// Creater:   徐超
/// CreateDate: 2015-06-04
/// Table: 
/// Input: rowid串
/// Output:     
/// Return：0	;拒绝成功
ClassMethod DenyDetail(RowidStr As %String, UserId As %String) As %Library.String
{
    n (RowidStr,UserId)
    s d=+$h
    s t=$p($h,",",2)
 	s yes="Y"
 	s ret=0
 	&sql(update IN_PurPlanItm set INPPI_RefuseFlag=:yes,INPPI_RefuseUser_DR=:UserId,INPPI_RefuseDate=:d,INPPI_RefuseTime=:t where INPPI_Rowid in (:RowidStr))
 	i SQLCODE'=0 d
 	.s ret=-2
 	q:ret'=0 ret
 	s len=$l(RowidStr,"^")
    f i=1:1:len  d
    .s rowid=$p(RowidStr,"^",i)
    .d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Insert(rowid,"PR",UserId,"PP")
    q ret
}

/// 查找对应的请求单
/// Author:zhwh
/// Date:2012-07-18
/// Argu:
///  INRQI - 请求单明细rowid
/// Return:
///  转移数
ClassMethod TransReqQty(inppi, UomId, ReqQtySum, TrfQtySum) As %String
{
 n (inppi,UomId,ReqQtySum,TrfQtySum) 
 s inpp=$p(inppi,"||",1)
 s ppi=$p(inppi,"||",2)
 s ReqQtySum=0,TrfQtySum=0
 s sub=""
 f  s sub=$O(^INPP(inpp,"PPI",ppi,"RQI",sub)) q:sub=""  d
 .q:'$d(^INPP(inpp,"PPI",ppi,"RQI",sub))
 .s reqi=$p(^INPP(inpp,"PPI",ppi,"RQI",sub),"^",1)
 .s reqqty=0,requom="",trfqty=0
 .&sql(select inrqi_inci_dr,inrqi_reqqty,inrqi_ctuom_dr into :inci,:reqqty,:requom from in_reqitm where %id=:reqi)
 .s btrfqty=##class(web.DHCSTMHUI.INPurPlanAuxByReq).TransQty(reqi)
 .s buom=$P(^INCI(inci,1),"^",10)
 .s fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(requom,buom)
 .s breqqty=reqqty*fac1
 .s fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,buom)
 .s reqqty=breqqty/fac2
 .s trfqty=btrfqty/fac2
 .s ReqQtySum=ReqQtySum+reqqty
 .s TrfQtySum=TrfQtySum+trfqty
 q 0
}

}
