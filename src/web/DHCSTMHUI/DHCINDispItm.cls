Import sqluser

Class web.DHCSTMHUI.DHCINDispItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:查询发放单明细
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		dhc_indispitm
/// 
Query DHCINDispItm(Parref As %String) As Query(ROWSPEC = "RowId,Inclb,InciId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty:%Float,UomId,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InclbQty:%Float,Remark,RQI,AvaQty:%Float,InclbDirtyQty:%Float,DirtyQty:%Float,HVBarCode,DisRetQty:%Float,AvaRetQty:%Float") [ SqlProc ]
{
}

ClassMethod DHCINDispItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK

	s AckFlag=$p(^DHCINDS(Parref),"^",17)

	s SqlStr="select %ID RowId,"
	_"indsi_inclb_dr Inclb,"
	_"indsi_inclb_dr->inclb_incib_dr->incib_no BatchNo,"
	_"indsi_inclb_dr->inclb_incib_dr->incib_expdate ExpDate,"  
	_"indsi_qty Qty,"
	_"indsi_ctuom_dr Uom,"
	_"indsi_ucost Rp,"
	_"indsi_saleprice Sp,"
	_"indsi_rpamt RpAmt,"
	_"INDSI_AmountSoldFor SpAmt,"
	_"INDSI_Remarks Remark,"
	_"INDSI_RQI_DR RQI,"
	_"nvl(indsi_retqty,0) DisRetQty"
	_" from dhc_indispitm where indsi_inds_parref="_Parref
	_" order by INDSI_Childsub asc"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Inclb=xrs.Data("Inclb")
		s Qty=xrs.Data("Qty")
		s UomId=xrs.Data("Uom")
		s UomDesc=$p($G(^CT("UOM",UomId)),"^",2)
		s Rp=xrs.Data("Rp")
		s Sp=xrs.Data("Sp")
		s RpAmt=xrs.Data("RpAmt")
		s SpAmt=xrs.Data("SpAmt")
		s Remark=xrs.Data("Remark")
		s RQI=xrs.Data("RQI")
		s BatchNo= xrs.Data("BatchNo")
		s ExpDate= xrs.Data("ExpDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s IncId=+Inclb
		s InciCode=$p($G(^INCI(IncId,1)),"^",1)
		s InciDesc=$p($G(^INCI(IncId,1)),"^",2)
		s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,UomId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s Manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		&sql(select INCLB_PhyQty,INCLB_DirtyQty into :PhyQty,:InclbDirtyQty from inc_itmlcbt where %id=:Inclb)
		s AvaQty=+PhyQty-(+InclbDirtyQty)
		s BUom=$P(^INCI(IncId,1),"^",10)
		s PUom=$P(^INCI(IncId,3),"^",6)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUom)
		s AvaQty=AvaQty/UomFac
		s InclbDirtyQty=InclbDirtyQty/UomFac
		s DirtyQty=$s(AckFlag'="Y":Qty,1:0)
		s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("C",RowId)
		s DisRetQty=xrs.Data("DisRetQty")
		s AvaRetQty=Qty-DisRetQty
		d OutPutItmRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutItmRow
	s Data=$lb(RowId,Inclb,IncId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty,
			UomId,UomDesc,Rp,RpAmt,Sp,SpAmt,InclbQty,Remark,RQI,AvaQty,
			InclbDirtyQty,DirtyQty,HVBarCode,DisRetQty,AvaRetQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:插入更新发放单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_InDispItm
ClassMethod Save(Inds As %String, DetailRows As %String) As RtnObj
{
	n (Inds,DetailRows)
	s RtnObj=##class(RtnObj).%New()
	i Inds="" d RtnObj.Err(-1,"","参数错误!")
	q:RtnObj.success'=0 RtnObj
	i DetailRows="" s RtnObj.rowid=Inds q RtnObj

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(DetailRows)
	i Sc'=0 d RtnObj.Err(-2,Inds,"参数解析错误!")
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(##class(web.DHCSTMHUI.DHCINDisp).%GetParameter("AppName")_Inds)'=0 d RtnObj.Err(-99,"",Inds_"锁定失败!")
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s IndsItm=Obj.%Get("RowId")
		s Inclb=Obj.%Get("Inclb")
		s Qty=Obj.%Get("Qty")
		s UomId=Obj.%Get("UomId")
		s Remark=Obj.%Get("Remark")
		s Rp=Obj.%Get("Rp")
		s Sp=Obj.%Get("Sp")
		s RQI=Obj.%Get("RQI")
		s HVBarCode=Obj.%Get("HVBarCode")
		s RpAmt=Rp*Qty
		s SpAmt=Sp*Qty
		s LocId=$p($G(^INCI(+Inclb,"IL",$p(Inclb,"||",2))),"^",1)
		s BUom=$P(^INCI(+Inclb,1),"^",10)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUom)
		s QtyBUom=Qty*Fac
		
		i IndsItm="" d
		.s objItm=##class(User.DHCInDispItm).%New()
		.s objItm.INDSIINDSParref=##class(User.DHCInDisp).%OpenId(Inds)
		.s Ch=$o(^DHCINDS(Inds,"DSI",""),-1)+1
		.s objItm.INDSIChildsub=Ch
		e  d
		.s objItm=##class(User.DHCInDispItm).%OpenId(IndsItm)
		.d objItm.%Reload()
		d objItm.INDSIINCLBDRSetObjectId(Inclb)
		s objItm.INDSIQty=+Qty
		d objItm.INDSICTUOMDRSetObjectId(UomId)
		d objItm.INDSICTLOCDRSetObjectId(LocId)
		s objItm.INDSIRpAmt=+RpAmt
		s objItm.INDSIUCost=+Rp
		s objItm.INDSISalePrice=+Sp
		s objItm.INDSIAmountSoldFor=+SpAmt
		d objItm.INDSIRQIDRSetObjectId(RQI)
		s objItm.INDSIRemarks=Remark
		s sc=objItm.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-3,IndsItm,"发放单明细保存失败:"_sc)
		q:RtnObj.success'=0
		i RQI'="" d
		.s DispStatus="D"
		.&sql(update dhc_indispreqitm set dsrqi_movestatus=:DispStatus where %id=:RQI)
		.i SQLCODE'=0 d RtnObj.Err(-4,IndsItm,"更新请领单明细状态失败:"_SQLCODE)
		q:RtnObj.success'=0
		
		s Indsi=objItm.%Id()
		s IndsUser=$p(^DHCINDS(Inds),"^",4)
		s OperData="^"_IndsUser_"^^^^"_Inclb
		i (IndsItm="")&&(HVBarCode'="") d
		.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("C",Indsi,HVBarCode,OperData)
		.i RtnObj.success'=0 d RtnObj.Err(-5,IndsItm,"更新高值跟踪信息失败:")
		q:RtnObj.success'=0
	}
	d ..sssUnLock(##class(web.DHCSTMHUI.DHCINDisp).%GetParameter("AppName")_Inds)
	q RtnObj
}

/// Description:删除发放单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispitm
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()
	s AppName=##class(web.DHCSTMHUI.DHCINDisp).%GetParameter("AppName")

	ts
	While(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Indsi=Obj.%Get("RowId")
		q:Indsi=""
		s Inds=+Indsi
		s RtnObj=##class(web.DHCSTMHUI.DHCINDisp).AllowDel(Inds)
		q:RtnObj.success'=0
		i ..sssLock(AppName_Inds)'=0 d RtnObj.Err(-99,Inds,"加锁失败!")
		q:RtnObj.success'=0
		s RtnObj=..Delete(Indsi)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 d
	.tro
	e  d
	.tc
	d ..sssUnLock(AppName_Inds)
	q RtnObj.Json()
}

/// Description:删除发放单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispitm
ClassMethod Delete(Indsi As %String) As RtnObj
{
	n (Indsi)
	s RtnObj=##class(RtnObj).%New()
	s Inds=+Indsi
	
	s ret=##class(web.DHCSTMHUI.DHCINDisp).HandleItmDirtyQty(Indsi,0)
	i ret<0 d RtnObj.Err(-11,Indsi,"发放单明细库存占用处理失败!")
	q:RtnObj.success'=0 RtnObj
	
	;先删除高值跟踪记录
  	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer("C",Indsi)
  	i RtnObj.success'=0 d
  	.d RtnObj.Err(-14,Indsi,"删除高值跟踪信息失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Dsrqi=$p(^DHCINDS(+Indsi,"DSI",$p(Indsi,"||",2)),"^",12)
	&sql(delete from DHC_INDispItm where %ID=:Indsi)	
	i SQLCODE'=0 d RtnObj.Err(-12,Indsi,"删除失败!")
	q:RtnObj.success'=0 RtnObj
	
	s ret=##class(web.DHCSTMHUI.DHCINDispReqItm).ResetDsrqiStatus(Dsrqi)
	i ret<0 d RtnObj.Err(-13,Indsi,"修改请领单状态失败!")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description:根据模板发放单ID和明细ID加载数据(模板明细当前批次不足则用其他批次补上)
/// Creator:	wn
/// CreatDate:	2022-07-14
/// Table:		dhc_indispitm
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINDispItm","DHCINDispItmTemp","26","{""DispDetailIdStr"":""26||1"",""gUserId"":""6460"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""MENUID"":""57767""}")
Query DHCINDispItmTemp(Parref As %String, Params As %String) As Query(ROWSPEC = "Inclb,InciId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty:%Float,UomId,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InclbQty:%Float,AvaQty:%Float,DirtyQty:%Float") [ SqlProc ]
{
}

ClassMethod DHCINDispItmTempExecute(ByRef qHandle As %Binary, Parref As %String, Params As %String) As %Status
{
	n (qHandle,Parref,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s Loc=$p(^DHCINDS(Parref),"^",9)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pDispDetailIdStr=PJobj.%Get("DispDetailIdStr")
	s HospId=$p(^CTLOC(Loc),"^",22)
	s SqlStr="select %ID RowId,"
	_"indsi_inclb_dr Inclb,"
	_"indsi_inclb_dr->inclb_incib_dr->incib_no BatchNo,"
	_"indsi_inclb_dr->inclb_incib_dr->incib_expdate ExpDate,"  
	_"indsi_qty Qty,"
	_"indsi_ctuom_dr Uom,"
	_"indsi_ucost Rp,"
	_"indsi_saleprice Sp,"
	_"indsi_rpamt RpAmt,"
	_"INDSI_AmountSoldFor SpAmt,"
	_"INDSI_RQI_DR RQI"
	_" from dhc_indispitm where indsi_inds_parref="_Parref
	_" order by INDSI_Childsub asc"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		continue:(pDispDetailIdStr'="")&&(("^"_pDispDetailIdStr_"^")'[("^"_RowId_"^"))	;生成模板明细时过滤掉未勾选的
		s Inclb=xrs.Data("Inclb")
		s IncId=+Inclb
		s BatSpFlag=..sssBatSpFlag(HospId,IncId)
		s TotalQty=xrs.Data("Qty")
		s UomId=xrs.Data("Uom")	
		s UomDesc=$p($G(^CT("UOM",UomId)),"^",2)
		s BUom=$P(^INCI(IncId,1),"^",10)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUom)
		s InciCode=$p($G(^INCI(IncId,1)),"^",1)
		s InciDesc=$p($G(^INCI(IncId,1)),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s pid=##class(web.DHCSTMHUI.DHCINIsTrfItm).GetInclbForTransfer(Loc,IncId,TotalQty*UomFac,1)
		i pid'="" d
		.i '$d(^TMPGETINCLB(pid)) q
		.s Inclb=""
		.f  s Inclb=$o(^TMPGETINCLB(pid,Inclb)) q:Inclb=""  d
		..s InclbInfo=^TMPGETINCLB(pid,Inclb)
		..s BatchNo=$p(InclbInfo,"^",1)
		..s InclbQty=$p(InclbInfo,"^",2)
		..s InclbQty=InclbQty/UomFac
		..s ExpDate=$p(InclbInfo,"^",3)
		..s Qty=$p(InclbInfo,"^",7)
		..s Qty=Qty/UomFac
		..s Manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		..s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,UomId)
		..s InclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,UomId)
		..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId)
		..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
		..s SpAmt=Sp*Qty
		..s RpAmt=Rp*Qty
		..d OutPutItmRowTemp
	}
	d xrs.Close()
	Quit $$$OK
OutPutItmRowTemp
	s Data=$lb(Inclb,IncId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty,
			UomId,UomDesc,Rp,RpAmt,Sp,SpAmt,InclbQty,AvaQty,
			InclbDirtyQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
