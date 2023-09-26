Import sqluser

Class web.DHCSTMHUI.DHCINDispReqItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 检索子表数据
/// Author:zhwh
/// Date:2013-09-26
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINDispReqItm","DHCINDispReqItm",4)
Query DHCINDispReqItm(Parref As %String, Params As %String = "") As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Spec,Manf,Qty:%Float,UomId,UomDesc,Remark,StkQty:%Float,DispMadeQty:%Float,DispedQty:%Float,Status,Sp:%Float,SpAmt:%Float,DispQty:%Float") [ SqlProc ]
{
}

ClassMethod DHCINDispReqItmExecute(ByRef qHandle As %Binary, Parref As %String, Params As %String = "") As %Status
{
	n (qHandle,Parref, Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s DspReqiIdStr=PJObj.%Get("DspReqiIdStr")
	s DsrqLoc=$p(^DHCINDSREQ(Parref),"^",2)
	s DsrqDate=$p(^DHCINDSREQ(Parref),"^",3)
	s HospId=..sssHospId(DsrqLoc)

	s SqlStr="select dsrqi_rowid RowId,dsrqi_inci_dr Inci,dsrqi_inci_dr->inci_code InciCode,dsrqi_inci_dr->inci_desc InciDesc,dsrqi_qty Qty,"
	_"dsrqi_ctuom_dr Uom,dsrqi_ctuom_dr->ctuom_desc UomDesc,dsrqi_remark Remark,dsrqi_dsrq_parref->dsrq_disploc_dr LocId,dsrqi_movestatus Status"
	_" From DHC_INDispReqItm"
	_" where dsrqi_dsrq_parref="_Parref
	
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		continue:(DspReqiIdStr'="")&&(("^"_DspReqiIdStr_"^")'[("^"_RowId_"^"))
		s InciCode=xrs.Data("InciCode")
		s InciDesc=xrs.Data("InciDesc")
		s Inci=xrs.Data("Inci")
		q:Inci=""
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(Inci),"^",2)
		s Qty=xrs.Data("Qty")
		s UomId=xrs.Data("Uom")
		s UomDesc=xrs.Data("UomDesc")
		s Remark=xrs.Data("Remark")
		s DispLocId=xrs.Data("LocId")
		s LocId=##class(web.DHCSTMHUI.Common.UtilCommon).GetLeadLoc(DispLocId)
		i LocId="" s LocId=DispLocId
		s il=$o(^INCI("IL_LOC",LocId,Inci,0))
		s Incil=Inci_"||"_il
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,UomId)
		s DispItmQty=..GetDispQty(RowId)
		s DispMadeQty=$p(DispItmQty,"^",1)		//已制单数量
		s DispedQty=$p(DispItmQty,"^",2)		//已审核发放数量
		s BUom=$p(^INCI(Inci,1),"^",10)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUom)
		s DispMadeQty=DispMadeQty/UomFac
		s DispedQty=DispedQty/UomFac
		s Status=xrs.Data("Status")
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Incil,DsrqDate,UomId,HospId)
		s SpAmt=Sp*Qty
		s DispQty=Qty-DispMadeQty
		i DispQty>StkQty d
		.s DispQty=StkQty
		d OutputRow
	}
	d xrs.Close()
	Quit $$$OK
OutputRow
	s Data=$lb(RowId,Inci,InciCode,InciDesc,Spec,Manf,Qty,UomId,UomDesc,Remark,StkQty,DispMadeQty,DispedQty,Status,Sp,SpAmt,DispQty)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:插入更新请领单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_InDispReqItm
ClassMethod Save(DsrqId As %String, DetailRows As %String) As RtnObj
{
	n (DsrqId,DetailRows)
	s RtnObj=##class(RtnObj).%New()
	i DsrqId="" d RtnObj.Err(-1,"","参数错误!")
	q:RtnObj.success'=0 RtnObj
	i DetailRows="" s RtnObj.rowid=DsrqId q RtnObj

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(DetailRows)
	i Sc'=0 d RtnObj.Err(-2,DsrqId,"参数解析错误!")
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(##class(web.DHCSTMHUI.DHCINDispReq).%GetParameter("AppName")_DsrqId)'=0 d RtnObj.Err(-99,"",DsrqId_"锁定失败!")
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Dsrqi=Obj.%Get("RowId")
		s InciId=Obj.%Get("InciId")
		s Qty=Obj.%Get("Qty")
		s UomId=Obj.%Get("UomId")
		s Remark=Obj.%Get("Remark")
		i Dsrqi="" d
		.s objItm=##class(User.DHCINDispReqItm).%New(DsrqId)
		.d objItm.DSRQIDSRQParRefSetObjectId(DsrqId)
		e  d
		.s objItm=##class(User.DHCINDispReqItm).%OpenId(Dsrqi)
		.d objItm.%Reload()
		i InciId'="" d objItm.DSRQIINCIDRSetObjectId(InciId)
		s objItm.DSRQIQty=+Qty
		d objItm.DSRQICTUOMDRSetObjectId(UomId)
		s objItm.DSRQIRemark=Remark
		s sc=objItm.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-3,Dsri,"请领单明细保存失败:"_sc)
		q:RtnObj.success'=0
	}
	d ..sssUnLock(##class(web.DHCSTMHUI.DHCINDispReq).%GetParameter("AppName")_DsrqId)
	q RtnObj
}

/// Description:删除请领单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispreqitm
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()
	s AppName=##class(web.DHCSTMHUI.DHCINDispReq).%GetParameter("AppName")

	ts
	While(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Dsrqi=Obj.%Get("RowId")
		q:Dsrqi=""
		s Dsrq=+Dsrqi
		s RtnObj=##class(web.DHCSTMHUI.DHCINDispReq).AllowDel(Dsrq)
		q:RtnObj.success'=0
		i ..sssLock(AppName_Dsrq)'=0 d RtnObj.Err(-99,Dsrq,"加锁失败!")
		q:RtnObj.success'=0
		s RtnObj=..Delete(Dsrqi)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 d
	.tro
	e  d
	.tc
	d ..sssUnLock(AppName_Dsrq)
	q RtnObj.Json()
}

/// Description:删除请领单明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispretitm
ClassMethod Delete(DsrqItm As %String) As RtnObj
{
	n (DsrqItm)
	s RtnObj=##class(RtnObj).%New()
	s Dsrq=+DsrqItm
	s RtnObj=##class(web.DHCSTMHUI.DHCINDispReq).AllowDel(Dsrq)
	q:RtnObj.success'=0 RtnObj
	
	&sql(delete from DHC_INDispReqItm where %ID=:DsrqItm)	
	i SQLCODE'=0 d RtnObj.Err(-12,DsrqItm,"删除失败!")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description:取已请求明细的发放数量(基本单位)
/// Creater:    wangjiabin
/// CreateDate: 2013-12-08
/// Table:		dhc_indispreqitm,dhc_indisp,dhc_indispitm
/// Input:		请领单子表rowid
/// Output:     
/// Return：	已制单数量^已审核发放数量
ClassMethod GetDispQty(dsrqi As %String) As %String
{
	n (dsrqi)
	s indsiQtySum=0,auditedQty=0
	s inds=0
	f  s inds=$o(^DHCINDS(0,"RQI",dsrqi,inds)) q:inds=""  d
	.s ackFlag=$p(^DHCINDS(inds),"^",17)	;审核标志
	.s ch=""
	.f  s ch=$o(^DHCINDS(0,"RQI",dsrqi,inds,ch)) q:ch=""  d
	..s indsiQty=$p(^DHCINDS(inds,"DSI",ch),"^",1)
	..s inclb=$p(^DHCINDS(inds,"DSI",ch),"^",3)
	..s uom=$p(^DHCINDS(inds,"DSI",ch),"^",4)
	..s indsiQty=..BUomQty(+inclb,indsiQty,uom)
	..s:ackFlag="Y" auditedQty=auditedQty+indsiQty
	..s indsiQtySum=indsiQtySum+indsiQty
	
	q indsiQtySum_"^"_auditedQty
}

/// Description:供应方拒绝(或请领方取消)请领单中的某条明细
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispreqitm
ClassMethod DenyReqItm(Dsrq As %String, Params As %String) As %String
{
	n (Dsrq,Params)
	s RtnObj=##class(RtnObj).%New()	
	i Dsrq="" d RtnObj.Err(-1,"","请选择请领单!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	i Params="" d RtnObj.Err(-1,"","请选择请领单明细!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-2,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s AppName=##class(web.DHCSTMHUI.DHCINDispReq).%GetParameter("AppName")
	i ..sssLock(AppName_Dsrq) d RtnObj.Err(-99,Dsrq,"请领单加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Complete=$p(^DHCINDSREQ(Dsrq),"^",11)
	i Complete'="Y" d
	.d RtnObj.Err(-3,Dsrq,"请领单未完成,不能拒绝!","",0)
	.d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()

	s Status=$p(^DHCINDSREQ(Dsrq),"^",9)
	i Status="X" d RtnObj.Err(-4,Dsrq,"请领单已作废,不能拒绝!","",0)
	i Status="R" d RtnObj.Err(-5,Dsrq,"请领单已拒绝,无需再次拒绝!","",0)
	i RtnObj.success'=0 d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()
	
	while(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Dsrqi=Obj.%Get("RowId")
		q:Dsrqi=""
		s Ch=$p(Dsrqi,"||",2)
		s MoveStatus=$p(^DHCINDSREQ(Dsrq,"I",Ch),"^",5)
		i MoveStatus="D" d RtnObj.Err(-6,Dsrqi,"请领单明细"_Dsrqi_"已处理,不能拒绝!","",0)
		i MoveStatus="X" d RtnObj.Err(-6,Dsrqi,"请领单明细"_Dsrqi_"已作废,不能拒绝!","",0)
		i MoveStatus="R" d RtnObj.Err(-6,Dsrqi,"请领单明细"_Dsrqi_"已拒绝,无需再次拒绝!","",0)
		q:RtnObj.success'=0
		s Inds=$o(^DHCINDS(0,"RQI",Dsrqi,0))
		i Inds'="" d RtnObj.Err(-6,Dsrqi,"请领单明细"_Dsrqi_"已处理,不能拒绝!","",0)
		q:RtnObj.success'=0
		
		&sql(UPDATE SQLUser.DHC_INDispReqItm SET DSRQI_MoveStatus = 'R' WHERE DSRQI_RowId = :Dsrqi)
		i SQLCODE'=0 d RtnObj.Err(-8,Dsrqi,"更新请领单明细状态失败!")
		q:RtnObj.success'=0
	}
	d ..sssUnLock(AppName_Dsrq)
	q RtnObj.Json()
}

/// Description:检查并重设请领单和请领单子表的status,moveStatus
/// Creater:    wangjiabin
/// CreateDate: 2013-12-10
/// Table:		dhc_indispreq
/// Input:		请领主表id
/// Output:     
/// Return：	0:成功，其他:失败
ClassMethod ResetDsrqiStatus(dsrqi As %String) As %String
{
	n (dsrqi)
	q:dsrqi="" 0
	s $ZT=..sssError()
	
	s ret=0,readyStatus="G"
	s dsrq=+dsrqi,ch=$p(dsrqi,"||",2)
	s moveStauts=$p(^DHCINDSREQ(dsrq,"I",ch),"^",5)
	i ('$d(^DHCINDS(0,"RQI",dsrqi)))&&(moveStauts="D") d
	.&sql(update dhc_indispreqitm set dsrqi_movestatus=:readyStatus where %id=:dsrqi)
	.i SQLCODE s ret=-1
	q:ret<0 ret
	
	q 0
}

/// 科室个人请领控制情况
ClassMethod CheckUserItmReq(loc, user, inci, qty, uom, amt) As %String
{
  n (loc,user,inci,sd,ed,qty,uom,amt)
  s ret=0
  //先看是否有请领控制	
  &sql(select urq_reqqty,urq_ctuom_dr,urq_reqamt,urq_reqamtofthismonth,urq_reqqtyofthismonth
   into :cfgQty,:cfgUom,:cfgAmt,:monAmt,:monQty
   from dhc_sublocuserreqmonthlyconfig
    where urq_subloc_dr=:loc and urq_ssusr_dr=:user and urq_inci_dr=:inci)
   i 'SQLCODE d
   .s qty=..BUomQty(inci,qty,uom)  //请求数量(基本单位)
   .s cfgQty=..BUomQty(inci,cfgQty,cfgUom)  //限制请求数量(基本单位)
   .i monQty+qty>cfgQty s ret=-1 q //单品数量超
   .i monAmt+amt>cfgAmt s ret=-2 q //单品金额超
   q:ret>0 ret
 
 s scg=$P(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",5)
 i scg="" d
 . &sql(select urq_reqamt,urq_reqamtofthismonth into :cfgAmt,:monAmt
   from dhc_sublocuserreqmonthlyconfig  where urq_subloc_dr=:loc and urq_ssusr_dr=:user and urq_scg_dr=:inci)
 .i 'SQLCODE d
 ..i monAmt+amt>cfgAmt s ret=3  //类组金额超
 ..
 q ret
}

/// 换算出某库存项的基本单位数量
ClassMethod BUomQty(inci, qty, uom) As %String
{
 n (inci,qty,uom)
 q:(inci="")!(uom="")!(qty="") 0
 s buom=$p($G(^INCI(inci,1)),"^",10)
 s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
 s qty=qty*fac
 q qty
}

/// 科室专业组请领控制情况
ClassMethod CheckUserGrpItmReq(loc, grp, inci, qty, uom, amt) As %String
{
  n (loc,grp,inci,qty,uom,amt)
  s ret=0
  //先看是否有请领控制	
  &sql(select rq_reqamt,rq_reqamtofthismonth
   into :cfgAmt,:monAmt
   from dhc_sublocreqmonthlyconfig
    where rq_subloc_dr=:loc and rq_lug_dr=:grp and rq_inci_dr=:inci)
   i 'SQLCODE d
   .s qty=..BUomQty(inci,qty,uom)  //请求数量(基本单位)
   .s cfgQty=..BUomQty(inci,cfgQty,cfgUom)  //限制请求数量(基本单位)
   .i cfgQty>0,monQty+qty>cfgQty s ret=-1 q //单品数量超
   .i cfgAmt>0,monAmt+amt>cfgAmt s ret=-2 q //单品金额超
   q:ret>0 ret
 
 s scg=$P(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",5)
 i scg="" d
 . &sql(select rq_reqamt,rq_reqamtofthismonth into :cfgAmt,:monAmt
   from dhc_sublocreqmonthlyconfig  where rq_subloc_dr=:loc and rq_lug_dr=:grp and rq_scg_dr=:scg)
 .i 'SQLCODE d
 ..i cfgAmt>0,monAmt+amt>cfgAmt s ret=3  //类组金额超
 ..
 q ret
}

}
