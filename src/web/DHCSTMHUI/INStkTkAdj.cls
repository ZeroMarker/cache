Import sqluser

Class web.DHCSTMHUI.INStkTkAdj Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 盘点调整 (js 调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.INStkTkAdj).jsStkTkAdj(15,6423)
ClassMethod jsStkTkAdj(Inst As %String, UserId As %String) As %String
{
	n (Inst,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..StkTkAdj(Inst,UserId)
	q RtnObj.Json()
}

/// 执行盘点调整(盘点调整的条件是：已经实盘汇总)
/// Author:zhwh
/// Date:2012-08-09
/// Argu:
///  inst - 盘点主表rowid
/// Return:
///  0 - sucess
///  <0 - failure
/// w ##class(web.DHCSTMHUI.INStkTkAdj).StkTkAdj("155","4668")
ClassMethod StkTkAdj(Inst As %String, UserId As %String) As RtnObj
{
	n (Inst,UserId)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-1,"","入参解析失败!")
	
	//检查盘点状态，判断是否可以执行调整
	s obj=##class(User.DHCInStkTk).%OpenId(Inst)
	d obj.%Reload()
	q:'$IsObject(obj) RtnObj.Err(-2,"","盘点单加载错误!")
	
	s LocId=obj.INSTCTLOCDR.%Id()
	s CompFlag =obj.INSTCompleted
	s StktkCompFlag =obj.INSTStockTakeComplete
	s AdjCompFlag=obj.INSTAdjustmentComplete
	s HVINStkTkFlag=obj.INSTHighValueFlag
	q:CompFlag'="Y" RtnObj.Err(-3,"","帐盘未完成!","",0)
	q:StktkCompFlag'="Y" RtnObj.Err(-4,"","未实盘汇总!","",0)
	q:AdjCompFlag="Y" RtnObj.Err(-5,"","盘点已经调整!","",0)
	
	s AppName=##class(web.DHCSTMHUI.INStkTk).%GetParameter("AppName")
	i ..sssLock(AppName_Inst)<0  q RtnObj.Err(-99,"","加锁失败!")
	
	ts
	//生成库存调整单主表
	s mdata=..PJsons(Inst,UserId)
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Update(mdata)
	i RtnObj.success'=0  d
	.tro
	.d ..sssUnLock(AppName_Inst)
	i RtnObj.success'=0  q RtnObj
	s AdjId=RtnObj.rowid

	//生成库存调整单子表
	s Num=0
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STI",ch)) q:(ch="")!(RtnObj.success'=0)  d
	.s Insti=Inst_"||"_ch  
	.s InciId=$p(^DHCINST(Inst,"STI",ch),"^",18)
	.s Inclb=$p(^DHCINST(Inst,"STI",ch),"^",1)
	.s AdjQty=$p(^DHCINST(Inst,"STI",ch),"^",13)
	.s inadi=$p(^DHCINST(Inst,"STI",ch),"^",22)
	.q:inadi'=""  ;该记录已经调整
	.s AdjUomDesc=""
	.s BUomId=$p($G(^INCI(InciId,1)),"^",10)
	.q:BUomId=""
	.s AdjUomId=$p(^DHCINST(Inst,"STI",ch),"^",17)
	.q:AdjUomId=""
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AdjUomId,BUomId)
	.s AdjQty=AdjQty/Fac
	.i AdjUomId'="" s AdjUomDesc=$p(^CT("UOM",AdjUomId),"^",2)
	.q:AdjUomDesc=""
	.//价格
	.s HospId=$p(^CTLOC(LocId),"^",22)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,AdjUomId,HospId)
	.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,AdjUomId,HospId)
	.;按高值条码盘点时,按dhc_instktkitmtrack处理
	.s sub=0,BarcodeQty=0
	.f  s sub=$o(^DHCINST(Inst,"STI",ch,"STIT",sub)) q:(sub="")||(RtnObj.success'=0)  d
	..s ItmTrackFlag=$p(^DHCINST(Inst,"STI",ch,"STIT",sub),"^",2)		;高值盘点标志
	..q:ItmTrackFlag="Y"
	..s BarcodeQty=BarcodeQty+1
	..s HVQty=-1
	..s HVRpAmt=Rp*HVQty,HVSpAmt=Sp*HVQty
	..s dhcit=$p(^DHCINST(Inst,"STI",ch,"STIT",sub),"^",1)
	..s HVBarCode=$p(^DHCIT(dhcit),"^",2)
	..s tmpDatad="^"_Inclb_"^"_HVQty_"^"_AdjUomId_"^"_Rp_"^"_Sp_"^"_HVBarCode
	..s tmpTitled="RowId^Inclb^Qty^UomId^Rp^Sp^HvBarCode"
	..s adiData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpDatad,tmpTitled)
	..s RtnObj=##class(web.DHCSTMHUI.DHCINAdjItm).Update(AdjId,adiData)
	..q:RtnObj.success<0
	..s Num=Num+1
	.q:RtnObj.success<0
	.s AdjQty=AdjQty+BarcodeQty		;高值条码数量计算
	.q:+AdjQty=0					;计算后若为0,高值调整之外不再调整批次
	.s RpAmt=Rp*AdjQty            //$p(^DHCINST(inst,"STI",ch),"^",35)
	.s SpAmt=Sp*AdjQty			//$p(^DHCINST(inst,"STI",ch),"^",34)
	.s tmpDatad="^"_Inclb_"^"_AdjQty_"^"_AdjUomId_"^"_Rp_"^"_Sp
	.s tmpTitled="RowId^Inclb^Qty^UomId^Rp^Sp"
	.s adiData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpDatad,tmpTitled)
	.s RtnObj=##class(web.DHCSTMHUI.DHCINAdjItm).Update(AdjId,adiData)
	.q:RtnObj.success<0
	.s Adji=RtnObj.rowid
	.;更新盘点子表中相应信息
	.&sql(update dhc_instktkitm set insti_inadi_dr=:Adji,INSTI_Variance1SpAmt=:SpAmt,
		INSTI_Variance1RpAmt=:RpAmt where %id=:Insti)
	.i SQLCODE'=0 d RtnObj.Err(-6,"","更新调整信息失败")
	.q:RtnObj.success<0
	.s Num=Num+1
	i RtnObj.success<0 tro  d ..sssUnLock(AppName_Inst) q RtnObj
	
	i Num<1 d	//调整明细为空，删除主单
	.&sql(delete from dhc_inadj where %ID=:AdjId)
	.i SQLCODE'=0 d RtnObj.Err(-1,"","处理单据失败!")
	.e  s AdjId=""
	e  d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Audit(AdjId,"{""gUserId"":"_UserId_"}")
	i RtnObj.success'=0 tro  d ..sssUnLock(AppName_Inst) q RtnObj
	
	//记录盘点调整信息
	&sql(update dhc_instktk set inst_inad_dr=:AdjId,INST_AdjustmentComplete='Y' where %id=:Inst)
	i SQLCODE'=0  d
	.d RtnObj.Err(-8,"","记录盘点调整信息失败!") 
	i RtnObj.success<0 tro  d ..sssUnLock(AppName_Inst) q RtnObj
	s RtnObj.rowid=AdjId
	
	tc
	d ..sssUnLock(AppName_Inst)
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.INStkTkAdj).PJsons(68)
ClassMethod PJsons(Inst As %String, UserId As %String) As %String
{
	n (Inst,UserId)
	s obj=##class(User.DHCInStkTk).%OpenId(Inst)
	s adjLoc=obj.INSTCTLOCDR.%Id()
	s adjReason=""
	s adjScg=obj.INSTSCGDR
	i $IsObject(adjScg) s adjScg=adjScg.%Id()
	s adjStkType=..sssCode()
	s adjInst=Inst
	s adjComp="Y"
	s adjState="11"
	s Remark="盘点调整"
	d obj.%Close()
	s tmpData=adjLoc_"^"_UserId_"^"_adjReason_"^"_adjScg_"^"_adjStkType_"^"_adjInst_"^"_adjComp_"^"_adjState_"^"_Remark
	s tmpTitle="AdjLoc^gUserId^ForAdjustReasonId^ScgStk^adjStkType^adjInst^Complate^adjState^Remark"
	s tmpDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpData,tmpTitle)
	q tmpDataObj
}

}
