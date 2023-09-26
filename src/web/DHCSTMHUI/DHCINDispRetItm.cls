Import sqluser

Class web.DHCSTMHUI.DHCINDispRetItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:查询退回单明细
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		dhc_indispretitm
Query DHCINDispRetItm(Parref As %String) As Query(ROWSPEC = "RowId,Inclb,IncId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty:%Float,UomId,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InclbQty:%Float,Remark,Indsi,IndsNo,DsrqNo,DispQty:%Float,DisRetQty:%Float,RetDirtyQty:%Float,AvailQty:%Float,HVBarCode") [ SqlProc ]
{
}

ClassMethod DHCINDispRetItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK

	s SqlStr="select %ID RowId,"
	_"dsri_inclb_dr Inclb,"
	_"dsri_inclb_dr->inclb_incib_dr->incib_no BatchNo,"
	_"dsri_inclb_dr->inclb_incib_dr->incib_expdate ExpDate,"  
	_"dsri_qty Qty,"
	_"dsri_ctuom_dr Uom,"
	_"dsri_rp Rp,"
	_"dsri_sp Sp,"
	_"dsri_rpamt RpAmt,"
	_"dsri_spamt SpAmt,"
	_"dsri_remark Remark,"
	_"dsri_dsi_dr Indsi,"
	_"dsri_dsi_dr->INDSI_INDS_Parref->INDS_No IndsNo,"
	_"dsri_dsi_dr->INDSI_RQI_DR->DSRQI_DSRQ_ParRef->DSRQ_No DsrqNo"
	_" from dhc_indispretitm"
	_" where dsri_dsr_parref="_Parref
	_" order by DSRI_ChildSub asc"

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
		s Indsi=xrs.Data("Indsi")
		s IndsNo=xrs.Data("IndsNo")
		s DsrqNo=xrs.Data("DsrqNo")
		s BatchNo= xrs.Data("BatchNo")
		s ExpDate= xrs.Data("ExpDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s IncId=+Inclb
		s InciCode=$p($G(^INCI(IncId,1)),"^",1)
		s InciDesc=$p($G(^INCI(IncId,1)),"^",2)
		s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,UomId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s Manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("L",RowId)
		s DispQty=0,DisRetQty=0
		&sql(select indsi_qty-nvl(indsi_retqty,0),nvl(indsi_retqty,0) into :DispQty,:DisRetQty from dhc_indispitm where %id=:Indsi)
		s DispQty=+DispQty,DisRetQty=+DisRetQty
		s RetDirtyQty=Qty
		s AvailQty=DispQty+Qty
		d OutPutItmRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutItmRow
	s Data=$lb(RowId,Inclb,IncId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty,
			UomId,UomDesc,Rp,RpAmt,Sp,SpAmt,InclbQty,Remark,Indsi,IndsNo,
			DsrqNo,DispQty,DisRetQty,RetDirtyQty,AvailQty,HVBarCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询已发放明细
/// Creator:	tsr
/// CreatDate:	2019-04-08
/// Table:		dhc_indispitm
Query GetDispItm(Params As %String) As Query(ROWSPEC = "RowId,Inclb,IncId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty:%Float,Uom,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,DispDate,DisRetQty:%Float") [ SqlProc ]
{
}

ClassMethod GetDispItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s Inci=PJObj.%Get("InciDr")
	s LocId=PJObj.%Get("LocId")
	s ToLoc=PJObj.%Get("ToLoc")		//退回科室(发放单发放科室)
	s UserId=PJObj.%Get("UserId")
		
	s SqlStr="select indsi_rowid RowId,"
	s SqlStr=SqlStr_"indsi_inclb_dr Inclb,"
	s SqlStr=SqlStr_"indsi_inclb_dr->inclb_incib_dr->incib_no BatchNo,"
	s SqlStr=SqlStr_"indsi_inclb_dr->inclb_incib_dr->incib_expdate ExpDate,"  
	s SqlStr=SqlStr_"INDSI_Qty-nvl(indsi_retqty,0) Qty,"
	s SqlStr=SqlStr_"nvl(indsi_retqty,0) RetQty,"
	s SqlStr=SqlStr_"indsi_ctuom_dr Uom,"
	s SqlStr=SqlStr_"indsi_ucost Rp,"
	s SqlStr=SqlStr_"indsi_saleprice Sp,"
	s SqlStr=SqlStr_"indsi_rpamt RpAmt,"
	s SqlStr=SqlStr_"INDSI_AmountSoldFor SpAmt,"
	s SqlStr=SqlStr_"indsi_inds_parref->inds_date DispDate"
	s SqlStr=SqlStr_" from dhc_indispitm"
	s SqlStr=SqlStr_" where indsi_ctloc_dr="_LocId
	;s SqlStr=SqlStr_" And INDSI_INDS_Parref->INDS_DispMode='1'"
	s SqlStr=SqlStr_" And INDSI_INDS_Parref->INDS_SSUSR_DR="_UserId
	s SqlStr=SqlStr_" And INDSI_INCLB_DR->inclb_incil_parref->incil_inci_parref="_Inci
	s SqlStr=SqlStr_" And INDSI_INDS_Parref->INDS_TOLOC_DR="_ToLoc
	s SqlStr=SqlStr_" And INDSI_INDS_Parref->INDS_AckFlag='Y'"
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
		s DisRetQty=xrs.Data("RetQty")
		s Uom=xrs.Data("Uom")
		s UomDesc=$p($G(^CT("UOM",Uom)),"^",2)
		s Rp=xrs.Data("Rp")
		s Sp=xrs.Data("Sp")
		s RpAmt=xrs.Data("RpAmt")
		s SpAmt=xrs.Data("SpAmt")
		s BatchNo= xrs.Data("BatchNo")
		s ExpDate= xrs.Data("ExpDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s DispDate= xrs.Data("DispDate")
		s:DispDate'="" DispDate=..DL2H(DispDate)
		s IncId=+Inclb
		s InciCode=$p($G(^INCI(IncId,1)),"^",1)
		s InciDesc=$p($G(^INCI(IncId,1)),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s Manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		d OutPutDispItmRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutDispItmRow
	s Data=$lb(RowId,Inclb,IncId,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty,
			Uom,UomDesc,Rp,RpAmt,Sp,SpAmt,DispDate,DisRetQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:插入更新退回单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_InDispRetItm
ClassMethod Save(DsrId As %String, DetailRows As %String) As RtnObj
{
	n (DsrId,DetailRows)
	s RtnObj=##class(RtnObj).%New()

	i DsrId="" d RtnObj.Err(-1,"","参数错误!")
	q:RtnObj.success'=0 RtnObj
	i DetailRows="" s RtnObj.rowid=DsrId q RtnObj

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(DetailRows)
	i Sc'=0 d RtnObj.Err(-2,DsrId,"参数解析错误!")
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(##class(web.DHCSTMHUI.DHCINDispRet).%GetParameter("AppName")_DsrId)'=0 d RtnObj.Err(-99,"",DsrId_"锁定失败!")
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Dsri=Obj.%Get("RowId")
		s Inclb=Obj.%Get("Inclb")
		s Qty=Obj.%Get("Qty")		;退回数量
		s UomId=Obj.%Get("UomId")
		s Remark=Obj.%Get("Remark")
		s Rp=Obj.%Get("Rp")
		s RpAmt=Obj.%Get("RpAmt")
		s Sp=Obj.%Get("Sp")
		s SpAmt=Obj.%Get("SpAmt")
		s Indsi=Obj.%Get("Indsi")	//发放明细Id
		s HVBarCode=Obj.%Get("HVBarCode")
		s DispQty=0,DisRetQty=0
		&sql(select indsi_qty-nvl(indsi_retqty,0),nvl(indsi_retqty,0) into :DispQty,:DisRetQty from dhc_indispitm where %id=:Indsi)
		i (Qty-DisRetQty)>DispQty d RtnObj.Err(-2,"","不能超过可退数量")
		q:RtnObj.success'=0
		i Dsri="" d
		.s objItm=##class(User.DHCInDispRetItm).%New(DsrId)
		.d objItm.DSRIDSRParRefSetObjectId(DsrId)
		e  d
		.s objItm=##class(User.DHCInDispRetItm).%OpenId(Dsri)
		.d objItm.%Reload()

		s Loc=$p($G(^INCI(+Inclb,"IL",$p(Inclb,"||",2))),"^",1)
		d objItm.DSRIINCLBDRSetObjectId(Inclb)
		s DiffQty=+Qty-objItm.DSRIQty
		s objItm.DSRIQty=+Qty
		d objItm.DSRICTUOMDRSetObjectId(UomId)
		s objItm.DSRIRpAmt=+Rp*Qty
		s objItm.DSRIRp=+Rp
		s objItm.DSRISp=+Sp
		s objItm.DSRISpAmt=+Sp*Qty
		d objItm.DSRIDSIDRSetObjectId(Indsi)
		s objItm.DSRIRemark=Remark
		s sc=objItm.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-3,Dsri,"退回单明细保存失败:"_sc)
		q:RtnObj.success'=0
		s INDispRetItmId=objItm.%Id()
		&sql(update dhc_indispitm set indsi_retqty=nvl(indsi_retqty,0)+:DiffQty where indsi_rowid=:Indsi)
		i SQLCODE'=0 d RtnObj.Err(-4,Dsri,"发放单退回数量更新失败!")
		q:RtnObj.success'=0
		
		s UserId=$p(^DHCINDSR(DsrId),"^",4)
		s OperData="^"_UserId_"^^^^"_Inclb
		i (Dsri="")&&(HVBarCode'="") d
		.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("L",INDispRetItmId,HVBarCode,OperData)
		.i RtnObj.success'=0 d RtnObj.Err(-5,Dsri,"更新高值跟踪信息失败:")
		q:RtnObj.success'=0
		
	}
	q RtnObj
}

/// Description:恢复退回数量
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indispretitm
/// Input:		退回单Id
ClassMethod RestoreAllRetQty(dsr As %String) As %String
{
	n (dsr)
	s ret=0
	&sql(declare curx cursor for select dsri_rowid from dhc_indispretitm where dsri_dsr_parref=:dsr)
	&sql(open curx)
	f  &sql(fetch curx into :dsri) q:SQLCODE!(ret<0)  d
	.s ret=..RestoreRetQty(dsri)
	.i ret<0 q
	&sql(close curx)
	q ret
}

/// Description:恢复发放单记录的退回数量
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indispretitm,dhc_indispitm
/// Input:		退回单明细Id
ClassMethod RestoreRetQty(dsritm As %String) As %String
{
	n (dsritm)
	q:dsritm="" 0
	&sql(select dsri_dsi_dr,dsri_qty into :dsi,:qty from dhc_indispretitm where %id=:dsritm)
	q:SQLCODE 0
	i (dsi'="")  &sql(update dhc_indispitm set indsi_retqty=indsi_retqty-:qty where indsi_rowid=:dsi)
	i SQLCODE'=0  q -1
	q 0
}

/// Description:删除退回单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispretitm
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()
	s AppName=##class(web.DHCSTMHUI.DHCINDispRet).%GetParameter("AppName")

	ts
	While(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Dsri=Obj.%Get("RowId")
		q:Dsri=""
		s Dsr=+Dsri
		s RtnObj=##class(web.DHCSTMHUI.DHCINDispRet).AllowDel(Dsr)
		q:RtnObj.success'=0
		i ..sssLock(AppName_Dsr)'=0 d RtnObj.Err(-99,Dsr,"加锁失败!")
		q:RtnObj.success'=0
		s RtnObj=..Delete(Dsri)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 d
	.tro
	e  d
	.tc
	d ..sssUnLock(AppName_Dsr)
	q RtnObj.Json()
}

/// Description:删除退回单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispretitm
ClassMethod Delete(DsrItm As %String) As RtnObj
{
	n (DsrItm)
	s RtnObj=##class(RtnObj).%New()
	s Dsr=+DsrItm
	s RtnObj=##class(web.DHCSTMHUI.DHCINDispRet).AllowDel(Dsr)
	q:RtnObj.success'=0 RtnObj
	;先删除高值跟踪记录
  	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer("L",DsrItm)
  	i RtnObj.success'=0 d
  	.d RtnObj.Err(-13,DsrItm,"删除高值跟踪信息失败!")
	q:RtnObj.success'=0 RtnObj

	i ..RestoreRetQty(DsrItm)'=0 d RtnObj.Err(-11,DsrItm,"恢复退回数量失败!")
	q:RtnObj.success'=0 RtnObj
	
	&sql(delete from DHC_INDispRetItm where %ID=:DsrItm)	
	i SQLCODE'=0 d RtnObj.Err(-12,DsrItm,"删除失败!")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// 扫码退回(高值),获取前段需要的参数串
/// w ##class(web.DHCSTMHUI.DHCINDispRetItm).GetDataForRet("10||1")
ClassMethod GetDataForRet(Indsi, Loc) As %Library.String
{
	n (Indsi,Loc)
	s (inclb,dispDate,dispQty,dispUom,dispUomDesc,opUser,rp,sp,dsiRetQty,dsrqNo)=""
	&sql(
		SELECT indsi_inclb_dr inclb,
		indsi_inds_parref->inds_date dispDate,
		INDSI_Qty-nvl(indsi_retqty,0) dispQty,indsi_ctuom_dr dispUom,
		indsi_ctuom_dr->ctuom_desc dispUomDesc,
		indsi_inds_parref->inds_ssusr_ack_dr->ssusr_name opUser,
		indsi_ucost rp,indsi_saleprice sp, nvl(indsi_retqty,0) dsiRetQty,
		indsi_rqi_dr->dsrqi_dsrq_parref->dsrq_no dsrqNo
		into :inclb,:dispDate,:dispQty,:dispUom,:dispUomDesc,
			:opUser,:rp,:sp,:dsiRetQty,:dsrqNo
		FROM dhc_indispitm WHERE INDSI_Rowid=:Indsi
		And indsi_inds_parref->INDS_TOLOC_DR=:Loc
	)
	q:SQLCODE "{}"
	
	s dispDate=..DH2L(dispDate)
	s Inci=$p(inclb,"||",1)
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(inclb)
	s BatchNo=$p(BatExp,"^",1),ExpDate=$p(BatExp,"^",2)
	s Manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
	s Data=Indsi_"^"_inclb_"^"_dispDate_"^"_dispQty_"^"_dispUom_"^"_dispUomDesc
		_"^"_opUser_"^"_rp_"^"_sp_"^"_dsiRetQty_"^"_dsrqNo
		_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_BatchNo_"^"_ExpDate
		_"^"_Spec_"^"_Manf
	s Title="Indsi^Inclb^DispDate^DispQty^DispUom^DispUomDesc"
		_"^OpUser^Rp^Sp^DsiRetQty^DsrqNo"
		_"^InciDr^InciCode^InciDesc^BatchNo^ExpDate"
		_"^Spec^Manf"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

}
