Import sqluser

Class web.DHCSTMHUI.DHCINGdRet Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTRETURNM";

/// Descript:	保存退货单
/// 对象类型数据
ClassMethod jsSave(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,Detail)
	q RtnObj.Json()
}

/// Descript:   保存/更新退货单信息
/// Creator:    XuChao
/// CreateDate: 2018-5-30
/// Table:DHC_InGdRet,DHC_INGRTITM
/// Input:退货主表id;
/// 退货科室RowId^供应商id^退货人RowId^类组RowId^调价换票标志,
/// 退货明细id^入库明细id^数量^单位^进价^售价^发票号^发票日期^发票金额^随行单^退货原因,
/// ，退货明细id^入库明细id^数量^单位^进价^售价^发票号^发票日期^发票金额^随行单^退货原因
/// Return：RtnObj
/// w ##class(web.DHCSTMHUI.DHCINGdRet).Save(^templxt("11"),^templxt("22"))
ClassMethod Save(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s LocId=PJObj.%Get("RetLoc")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s OperData=LocId_"^"_UserId_"^^^^"
	
	tstart
	s RtnObj=..Update(Main)
	i RtnObj.success<0 tro  q RtnObj
	s MainId=RtnObj.rowid

	s RtnObj=##class(web.DHCSTMHUI.DHCINGrtItm).Update(MainId,Detail,OperData,HospId)
	i RtnObj.success<0 tro  q RtnObj

	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AutoCompAfterSaveDRET=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"AutoCompAfterSaveDRET",Param)
	i AutoCompAfterSaveDRET="Y" d
	.s AuditTitle="RowId"
	.s AuditData=MainId
	.s AuditObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AuditData,AuditTitle)
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).SetCompleted(AuditObj)
	i RtnObj.success<0 tro  q RtnObj

	tcommit
	s RtnObj.rowid=MainId
	q RtnObj
}

/// 取退货主表记录的数据信息串
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  ret - 退货主表rowid
/// Return：
///  返回记录数据串
ClassMethod Select(RetId As %String) As %String
{
	n (RetId)
	q:RetId="" ""
	s Result=""
	&sql(select INGRT_RowId,INGRT_APCVM_DR,INGRT_Date,INGRT_Time,INGRT_Completed,
		INGRT_SSUSR_DR,INGRT_NO,INGRT_CTLOC_DR,INGRT_SSUSR_Audit_DR,INGRT_AuditDate,
		INGRT_AuditTime,INGRT_AdjCheque,INGRT_PayAllowed,INGRT_PayAllowDate,INGRT_SCG_DR,
		INGRT_AuditFlag,INGRT_StkType,INGRT_PrtFlag,INGRT_PayAllowTime,INGRT_PayAllowUser_DR,INGRT_Remarks
	into
		INGRTRowId,INGRTAPCVMDR,INGRTDate,INGRTTime,INGRTCompleted,
		INGRTSSUSRDR,INGRTNO,INGRTCTLOCDR,INGRTSSUSRAuditDR,INGRTAuditDate,
		INGRTAuditTime,INGRTAdjCheque,INGRTPayAllowed,INGRTPayAllowDate,INGRTSCGDR,
		INGRTAuditFlag,INGRTStkType,INGRTPrtFlag,INGRTPayAllowTime,INGRTPayAllowUserDR,Remarks
	from DHC_INGDRET where %ID=:RetId)
	q:SQLCODE Result
	
	s INGRTDate=..DL2H(INGRTDate)
	s INGRTTime=..TL2H(INGRTTime)
	
	s (VenCode,VenDesc,LocDesc,IngrtUser,ScgDesc)=""
	s:INGRTAPCVMDR'="" VenDesc=$p(^APC("APCVM",INGRTAPCVMDR),"^",3),VenCode=$p(^APC("APCVM",INGRTAPCVMDR),"^",2)
	s:INGRTCTLOCDR'="" LocDesc=$p(^CTLOC(INGRTCTLOCDR),"^",2)
	s:INGRTSSUSRDR'="" IngrtUser=$p(^SSU("SSUSR",INGRTSSUSRDR),"^",2)
	s:INGRTSCGDR'="" ScgDesc=$p(^DHCSCG(INGRTSCGDR),"^",2)
	
	s Result=INGRTRowId_"^"_INGRTAPCVMDR_"^"_INGRTDate_"^"_INGRTTime_"^"_INGRTCompleted
		_"^"_INGRTSSUSRDR_"^"_INGRTNO_"^"_INGRTCTLOCDR_"^"_INGRTSSUSRAuditDR_"^"_INGRTAuditDate
		_"^"_INGRTAuditTime_"^"_INGRTAdjCheque_"^"_INGRTPayAllowed_"^"_INGRTPayAllowDate_"^"_INGRTSCGDR
		_"^"_INGRTAuditFlag_"^"_INGRTStkType_"^"_INGRTPrtFlag_"^"_INGRTPayAllowTime_"^"_INGRTPayAllowUserDR
		_"^"_VenDesc_"^"_LocDesc_"^"_IngrtUser_"^"_ScgDesc_"^"_VenCode
		_"^"_Remarks
	
	s Title="RowId^Vendor^Date^Time^Completed"
		_"^User^RetNo^RetLoc^AuditUser^AuditDate"
		_"^AuditTime^AdjCheque^PayAllowed^PayAllowedDate^ScgStk"
		_"^AuditFlag^StkType^PrtFlag^PayAllowTime^PayAllowUser"
		_"^VendorDesc^LocDesc^User^ScgStkDesc^VendorCode"
		_"^Remarks"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Result,Title)
	q Rtn
}

/// 插入或更新退货主表
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///    ret - 退货主表rowid (DHC_INGDRET)
///    loc - 科室rowid
///    retNo  -退货单号
///    vendor - 供应商rowid
///    user - 用户rowid
///    scg   - 类组rowid
///    stkType  -分类
///    AdjChequeFlag -调价换票标志
/// Return:
///   >0 - Success
///   <0 - failure
///          
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-11,"","入参解析失败!")
	
	s RowId=PJObj.%Get("RowId")
	s LocId=PJObj.%Get("RetLoc")
	q:LocId="" RtnObj.Err(-12,"","退货科室不能为空!","",0)
	
	s HospId=PJObj.%Get("gHospId")
	s Vendor=PJObj.%Get("Vendor")
	s UserId=PJObj.%Get("gUserId")
	s ScgStk=PJObj.%Get("ScgStk")
	s AdjChequeFlag=PJObj.%Get("AdjChequeFlag")
	s Remarks=PJObj.%Get("Remarks")
	s StkType=..sssCode()

	i RowId=""  d
	.s RetNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),ScgStk,LocId) 
	.i RetNo="" s Sc=RtnObj.Err(-13,"","生成退货单号失败")
	q:RtnObj.success'=0 RtnObj
	
	i RowId="" d
	.s obj=##class(User.DHCINGDRET).%New()
	.s obj.INGRTNO=RetNo
	e  d
	.s obj=##class(User.DHCINGDRET).%OpenId(RowId)
	d obj.INGRTAPCVMDRSetObjectId(Vendor)
	d obj.INGRTCTLOCDRSetObjectId(LocId)
	s obj.INGRTDate=+$h
	s obj.INGRTTime=$p($h,",",2)
	d obj.INGRTSSUSRDRSetObjectId(UserId)
	d obj.INGRTSCGDRSetObjectId(ScgStk)
	s obj.INGRTStkType=StkType
	s obj.INGRTAdjCheque=AdjChequeFlag
	s obj.INGRTRemarks=Remarks
	s Sc=obj.%Save()
	i $$$ISERR(Sc) s Sc=RtnObj.Err(-14,"","保存主表信息失败")
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// 删除退货单
/// Author:zhwh
/// Date:2012-07-03
/// Argu:
///   ret - 退货单rowid
/// Return:
///   0  - success
///   <0 - failure
ClassMethod Delete(RetId As %String) As %String
{
	n (RetId)
	s RtnObj=##class(RtnObj).%New()
	q:RetId="" RtnObj.Err(-1,"","入参不能为空!").Json()
	
	//判断状态
	s Allow=##class(web.DHCSTMHUI.DHCINGdRet).AllowDel(RetId)
	q:Allow'=0 RtnObj.Err(-2,"","已完成或审核,不允许删除!","",0).Json()
	
	i ..sssLock(..%GetParameter("AppName")_+RetId)<0 s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	//清除占用
	s RtnObj=..HandleDirtyQty(RetId,0)
	i RtnObj.success<0 tro  d ..sssUnLock(..%GetParameter("AppName")_+RetId)
	q:RtnObj.success'=0 RtnObj.Json()
	//先删除相关的高值跟踪信息
	s result=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("R",+RetId)
	i RtnObj.success<0 tro  d
	.d ..sssUnLock(..%GetParameter("AppName")_+RetId)
	.d RtnObj.Err(-3,"","删除高值跟踪信息失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	//删除
	&sql(delete from DHC_INGDRET Where %ID=:RetId)
	i SQLCODE tro  d
	.d ..sssUnLock(..%GetParameter("AppName")_+RetId)
	.d RtnObj.Err(-4,"","删除退货信息失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	d ..sssUnLock(..%GetParameter("AppName")_+RetId)   //去锁
	tc
 	q RtnObj.Json()
}

/// 是否允许删除
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  ret - 退货主表RowId
/// return:
///   0 - 允许
///   <0 -禁止
///   
ClassMethod AllowDel(ret As %String) As %String
{
	n (ret)
	s obj=##class(User.DHCINGDRET).%OpenId(ret)
	if obj.INGRTAuditFlag="Y" q -1
	if obj.INGRTCompleted="Y" q -2
	q 0
}

/// w ##class(web.DHCSTMHUI.DHCINGdRet).jsAudit(^tmpqsx("jsAudit"))
ClassMethod jsAudit(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..Audit(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// 退货单审核
/// Author:XuChao
/// Date:2018-06-03
/// Arg:
/// Return:
/// 2013-10-16 wangjiabin 修改事务(之前为明细事务)
/// w ##class(web.DHCSTMHUI.DHCINGdRet).Audit()
ClassMethod Audit(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s RetId=PJObj.%Get("RowId")
	s UserId=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")
	i RetId="" q RtnObj.Err(-2,"","RetId不能为空!","",0)
	s LocId=$p(^INGRT(RetId),"^",7)
	
	s Status=..AllowAudit(RetId)
	i Status<0   q RtnObj.Err(-3,"","已经审核或未完成,不能审核!","",0)
	
	;增加数据验证
	//s ErrId=..CheckDataValid(ret)
	;i ErrId'=0  d
	;.s ErrInfo=##class(web.DHCSTMHUI.ErrorRecord).GetErrorInfo(ErrId)
	;i ErrId'=0  q -101_":"_$g(ErrInfo)  //数据验证不通过
	
	i ..sssLock(..%GetParameter("AppName")_RetId)<0 q RtnObj.Err(-4,"","加锁失败!")
	s Date=+$h
	s Time=$p($h,",",2)
	s Flag="Y"
	&sql(update Dhc_Ingdret set 
		INGRT_AuditDate=:Date,INGRT_AuditTime=:Time,INGRT_SSUSR_Audit_DR=:UserId,ingrt_auditflag=:Flag  
		where %ID=:RetId)
	i SQLCODE  d ..sssUnLock(..%GetParameter("AppName")_RetId) q RtnObj.Err(-5,"","更新审核信息失败！")
	
	&sql(declare curdhcret cursor for 
		select ingrti_ingri_dr,ingrti_retqty,ingrti_retuom_dr,ingrti_retreas_dr,
		ingrti_rowid,ingrti_ingrt_parref->ingrt_no 
		from Dhc_InGrtitm where ingrti_ingrt_parref=:RetId)
	&sql(open curdhcret)
	f  &sql(fetch curdhcret into :Ingri,:Qty,:Uom,:Reason,:Ingrti,:RetNo)  q:(SQLCODE)!(RtnObj.success'=0)   d 
	.;i Ingri="" d RtnObj.Err(-6,"","关联入库单不能为空!","",0) q
	.
	.s Ingrt=+Ingrti
	.s GrtCh=$P(Ingrti,"||",2) 
	.s Uom=+$P(^INGRT(Ingrt,"DHCGRR",GrtCh),"^",3) 
	.s Inclb=$p(^INGRT(Ingrt,"DHCGRR",GrtCh),"^",6)
	.s Loc=+$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2)),"^",1)
	.i Loc=""  d RtnObj.Err(-7,"","科室不能为空!","",0)
	.q:RtnObj.success'=0
	.s Inci=+Inclb
	.s InciDesc="",InciCode=""
	.s:Inci'="" InciDesc=$p(^INCI(Inci,1),"^",2)
	.s:Inci'="" InciCode=$p(^INCI(Inci,1),"^",1)
	.s Rp=$p(^INGRT(Ingrt,"DHCGRR",GrtCh),"^",7)
	.s RpAmt=$p(^INGRT(Ingrt,"DHCGRR",GrtCh),"^",4)
	.s Sp=$p(^INGRT(Ingrt,"DHCGRR",GrtCh),"^",8)
	.s SpAmt=$p(^INGRT(Ingrt,"DHCGRR",GrtCh),"^",9)
	.s Pointer=Ingrti
	.s Type="R"
	.s BUom=$p(^INCI(+Inclb,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
	.s RpAmt=-RpAmt
	.s SpAmt=-SpAmt
	.s RetQty=Qty  //记录退货数量(正)
	.
	.s NowQty=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",2)
	.i NowQty<Qty  s Sc=RtnObj.Err(-8,"",InciCode_","_InciDesc_":当前库存不足!","",0)
	.q:RtnObj.success'=0
	.
	.s Qty=-Qty
	.s QtyBUom=Qty*Fac
	.i $o(^DHCINTR(0,"TypePointer",Type,Pointer,"")) s Sc=RtnObj.Err(-9,"",InciCode_","_InciDesc_":当前退货明细已经处理!","",0)
	.q:RtnObj.success'=0
	.//处理库存
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,QtyBUom)
	.i Ret<0 s Sc=RtnObj.Err(-10,"","处理库存失败!")
	.q:RtnObj.success'=0
	.//处理台帐
	.s lstData=Type_"^"_RetNo_"^"_Inclb_"^"_Qty_"^"_Uom_"^"_Sp_"^"_UserId_"^"_Pointer_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstData)
	.q:RtnObj.success'=0
	.//清除占用
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGrtItm).HandleRetItmDirtyQty(Ingrti,0)
	.q:RtnObj.success'=0
	.//必要时生成调价损益
	.s HospId=..sssHospId(Loc)
	.s currentSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,Uom,HospId)  // 当前售价
	.s currentRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,Uom,HospId) //批次进价
	.i (+Sp'=+currentSp)!(+Rp'=+currentRp) d
	..s SpDiff=Sp-currentSp
	..s SpAmtDiff=SpDiff*RetQty  //售价差额
	..s RpDiff=Rp-currentRp
	..s RpAmtDiff=RpDiff*RetQty  //进价差额
	..s data=Inclb_"^"_RetQty_"^"_SpDiff_"^"_SpAmtDiff_"^"_RpDiff_"^"_RpAmtDiff_"^"_UserId_"^"_Pointer_"^"_Type_"^"_Uom
	..s RtnObj=##class(web.DHCSTMHUI.DHCRetAspAmount).Insert(data)
	.q:RtnObj.success'=0
	.
	.//处理高值材料条码
	.s Labels=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("R",Pointer)
	.i Labels'="" d
	..s Ret=##class(web.DHCSTMHUI.HVMatOrdItm).IngretNO(Labels,Pointer)
	..i Ret<0  d RtnObj.Err(-12,"","更新高值提取数据失败！")
	..q:RtnObj.success'=0
	..s Ret=##class(web.DHCSTMHUI.DHCItmTrack).UpOriBarToOldOriBar(Labels)
	..i Ret<0  d RtnObj.Err(-13,"","处理高值跟踪信息失败！")
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	&sql(close curdhcret)
	i RtnObj.success'=0  d ..sssUnLock(..%GetParameter("AppName")_RetId) q RtnObj
	
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).UpdateInvInfo(RetId,"R")
	i RtnObj.success'=0  q RtnObj.Err(-9,"","创建发票信息失败")
	s RtnObj=##class(web.DHCSTMHUI.PurchaseInfo).SaveRecQty("R",RetId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-9,"","更新带量已采购量失败")
	d ..sssUnLock(..%GetParameter("AppName")_RetId)
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.DHCINGdRet).jsCancelAudit(6)
ClassMethod jsCancelAudit(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..CancelAudit(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// 退货单审核
/// Author:XuChao
/// Date:2018-06-03
/// Arg:
/// Return:
/// 2013-10-16 wangjiabin 修改事务(之前为明细事务)
/// w ##class(web.DHCSTMHUI.DHCINGdRet).CancelAudit(6)
ClassMethod CancelAudit(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s Ingrt=PJObj.%Get("RowId")
	
	i Ingrt="" q RtnObj.Err(-1,"","退货单ID不能为空!","",0)

	s Complete=$p(^INGRT(Ingrt),"^",6)
	i Complete'="Y"  q RtnObj.Err(-2,"","退货单未完成","",0)
	s Audit=$p(^INGRT(Ingrt),"^",15)
	i Audit'="Y"  q RtnObj.Err(-3,"","退货单未审核","",0)
	i ..IfMakeMon(Ingrt)=1  q RtnObj.Err(-4,"","已经生成月报，不允许取消审核","",0)
	i ..IfMadePay(Ingrt)=1  q RtnObj.Err(-5,"","已生成付款单，不允许取消审核","",0)
	i ..IfHVModifyRet(Ingrt)=1  q RtnObj.Err(-6,"","取消高值补录产生的退货单，不允许取消审核","",0)
	i ..sssLock(..%GetParameter("AppName")_Ingrt)<0 q RtnObj.Err(-6,"","加锁失败!")
	
	ts
	s Ch=0
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch)) q:(Ch="")!(RtnObj.success'=0)  d
	.s Ingrti=Ingrt_"||"_Ch
	.
	.;处理高值信息
	.s labels=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("R",Ingrti)
	.i labels'="" d
	..s err=##class(web.DHCSTMHUI.HVMatOrdItm).CancelIngretNO(labels)
	..i err<0 d RtnObj.Err(-7,"",Ingrti_"处理高值医嘱信息失败!")
	..q:RtnObj.success'=0
	..s err=..UpOldOriBarToOriBar(labels)
	..i err'=0 d RtnObj.Err(-8,"",Ingrti_"处理高值追踪信息失败!")
	..q:RtnObj.success'=0
	.;恢复库存数据
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("R",Ingrti)
	.i Ret'=0 d RtnObj.Err(-9,"",Ingrti_"恢复库存失败!")
	.q:RtnObj.success'=0
	.;删除退货损益数据
	.s AspRet=##class(web.DHCSTMHUI.DHCRetAspAmount).Delete("R",Ingrti)
	.i AspRet'=0 d RtnObj.Err(-9,"",Ingrti_"处理退货损益数据失败!")
	.q:RtnObj.success'=0
	.;恢复占用
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGrtItm).HandleRetItmDirtyQty(Ingrti,1)
	.q:RtnObj.success'=0
	i RtnObj.success'=0  d ..sssUnLock(..%GetParameter("AppName")_Ingrt) 
	i RtnObj.success'=0  trollback
	q:RtnObj.success'=0 RtnObj
	&sql(UPDATE DHC_INGDRET SET INGRT_SSUSR_Audit_DR=null,INGRT_AuditDate=null,INGRT_AuditTime=null,INGRT_SSUSR_Purch_DR=null,INGRT_AuditFlag=null,INGRT_Completed=null where INGRT_RowId=:Ingrt)
	i SQLCODE d ..sssUnLock(..%GetParameter("AppName")_Ingrt)
	i SQLCODE trollback
	i SQLCODE  d RtnObj.Err(-10,"","更新退货单状态失败")
	q:RtnObj.success'=0 RtnObj
	s RtnObj=##class(web.DHCSTMHUI.PurchaseInfo).SaveRecQty("R",Ingrt,"Y")
	i RtnObj.success'=0 tro  q RtnObj.Err(-9,"","更新带量已采购量失败")
	tc
	d ..sssUnLock(..%GetParameter("AppName")_Ingrt)
	q RtnObj
}

/// 是否允许审核
/// Author:zhwh
/// Date:2012-07-03
/// Argu:
///  ret - 退货单主表rowid
/// Return:
///   0-  allow
///   <0 - not allow
///   
ClassMethod AllowAudit(ret As %String) As %String
{
	n (ret)
	s obj=##class(User.DHCINGDRET).%OpenId(ret)
	i obj.INGRTAuditFlag="Y" q -1  //已审核
	i obj.INGRTCompleted'="Y" q -2  //未完成
	q 0
}

/// Descript:	查找退货单主记录
/// Creator:	XuChao
/// CreateDate:	2018-07-27
/// Table:		DHC_INGDRET
/// Input:		排序，查询条件
/// Return：	主单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRet","DHCINGdRet",^tmpbin(489))
Query DHCINGdRet(Params As %String) As Query(ROWSPEC = "RowId,Vendor,VendorName,RetLoc,RetLocDesc,RetNo,RetDate,RetTime,RetUser,RetUserName,AuditDate,AuditTime,AuditUser, AuditUserName,AuditFlag,Completed,AdjCheque,ScgStk,ScgStkDesc,SendFlag,Remark,HRPFlag,RpAmt:%Float,SpAmt:%Float")
{
}

ClassMethod DHCINGdRetExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")
	s EndDate=PJobj.%Get("EndDate")
	s pRetLoc=PJobj.%Get("RetLoc")		 
	s pVendor=PJobj.%Get("Vendor")
	s pCompleted=PJobj.%Get("Completed")
	s pAuditFlag=PJobj.%Get("AuditFlag")
	s pSendFlag=PJobj.%Get("SendFlag")
	s pHvFlag=PJobj.%Get("HvFlag")
	s pUserId=PJobj.%Get("gUserId")
	s pHospId=PJobj.%Get("gHospId")
	s pGroupId=PJobj.%Get("gGroupId")
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:pRetLoc="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s pStkType=..sssCode()
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(pUserId,..sssCode(),pRetLoc,"",pHospId)
	s sql="select %ID RowId,"
		_"ingrt_apcvm_dr Vendor,"
		_"ingrt_apcvm_dr->apcvm_name VendorName,"
		_"ingrt_ctloc_dr RetLoc,"
		_"ingrt_ctloc_dr->ctloc_desc RetLocDesc,"
		_"ingrt_no RetNo,"
		_"ingrt_date RetDate,"
		_"ingrt_time RetTime,"
		_"ingrt_ssusr_dr RetUser,"
		_"ingrt_ssusr_dr->ssusr_name RetUserName,"
		_"ingrt_auditdate AuditDate,"
		_"ingrt_audittime AuditTime,"
		_"ingrt_ssusr_audit_dr AuditUser,"
		_"ingrt_ssusr_audit_dr->ssusr_name AuditUserName,"
		_"ingrt_auditflag AuditFlag,"
		_"ingrt_completed Completed,"
		_"ingrt_adjcheque AdjCheque,"
		_"ingrt_scg_dr ScgStk,"
		_"INGRT_Remarks Remark,"
		_"INGRT_SendToSCM SendFlag,"
		_"INGRT_StkType StkType,"
		_"ingrt_scg_dr->scg_desc ScgStkDesc "
		_" from DHC_INGDRET "
		_" where INGRT_Date between "_StartDate_" and "_EndDate 
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	WHILE (xrs.Next())
	{
		s RetLoc=xrs.Data("RetLoc")
		continue:pRetLoc'=RetLoc
		s Vendor=xrs.Data("Vendor")
		continue:(pVendor'="")&&(pVendor'=Vendor)
		s RowId=xrs.Data("RowId")
		s VendorName=xrs.Data("VendorName")
		s RetLocDesc=xrs.Data("RetLocDesc")
		s RetNo=xrs.Data("RetNo")
		s RetDate=xrs.Data("RetDate")
		s RetTime=xrs.Data("RetTime")
		s RetUser=xrs.Data("RetUser")
		s RetUserName=xrs.Data("RetUserName")
		s AuditDate=xrs.Data("AuditDate")
		s AuditTime=xrs.Data("AuditTime")
		s AuditUser=xrs.Data("AuditUser")
		s AuditUserName=xrs.Data("AuditUserName")
		s AuditFlag=xrs.Data("AuditFlag")
		s:AuditFlag="" AuditFlag="N"
		s Completed=xrs.Data("Completed")
		s:Completed="" Completed="N"
		s SendFlag=xrs.Data("SendFlag")
		s:SendFlag="" SendFlag="N"
		s AdjCheque=xrs.Data("AdjCheque")
		s ScgStk=xrs.Data("ScgStk")
		s ScgStkDesc=xrs.Data("ScgStkDesc")
		s Remark=xrs.Data("Remark")
		s StkType=xrs.Data("StkType")
		continue:pStkType'=StkType
		continue:(pAuditFlag'="")&&(pAuditFlag'=AuditFlag)
		continue:(pSendFlag'="")&&(pSendFlag'=SendFlag)
		continue:(pCompleted'="")&&(pCompleted'=Completed)
		continue:(ScgStk'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgStk_"^"))
		s HvFlag=..GetRetHVFlag(RowId)
		continue:(pHvFlag'="")&&(pHvFlag'=HvFlag)
		
		s IsInclude=""
		i (ScgStk="")&&(ScgStr'="") d
		.s DetailScg=..GetRetDetailScg(RowId)
		.s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
		continue:IsInclude=0				//明细过滤
		s RetDate=..DL2H(RetDate)
		s RetTime=..TL2H(RetTime)
		s AuditDate=..DL2H(AuditDate)
		s AuditTime=..TL2H(AuditTime)
		s HRPFlag=$p(^INGRT(RowId),"^",32)				;1-表示"平台已确认"
		s RpAmt=$p(..InrtAmt(RowId),"^",1)
		s SpAmt=$p(..InrtAmt(RowId),"^",2)
		d OutPutRow1
	}

	Quit $$$OK
OutPutRow1
	s xData=$lb(RowId,Vendor,VendorName,RetLoc,RetLocDesc,RetNo,RetDate,RetTime,RetUser,RetUserName,AuditDate,AuditTime,AuditUser,AuditUserName,AuditFlag,Completed,AdjCheque,ScgStk,ScgStkDesc,SendFlag,Remark,HRPFlag,RpAmt,SpAmt)
	s ^CacheTemp(repid,ind)=xData
	s ind=ind+1
	q
}

/// Descript:	获取高值标志
/// Creator:	XuChao
/// CreateDate:	2018-07-27
/// Table:		DHC_INGDRET
/// Input:		排序，查询条件
/// Return：	高值标志
ClassMethod GetRetHVFlag(Ret As %String) As %String
{
	n (Ret)
	s HVFlag="N"
	s ch=0
	f  s ch=$o(^INGRT(Ret,"DHCGRR",ch)) q:(ch="")!(HVFlag="Y")  d
	.s Ingri=$P(^INGRT(Ret,"DHCGRR",ch),"^",1)
	.s Inclb=$p(^INGRT(Ret,"DHCGRR",ch),"^",6)
	.s Inci=$p(Inclb,"||",1)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	q HVFlag
}

/// 查找库存项目可退项
/// Author:XuChao
/// Date:2018-05-28
/// Argu:
///  Loc    -科室rowid
///  Inci   -库存项目rowid
///  Vendor - 供应商rowid
///  wangjiabin 2013-10-14 添加Ingri条件,缺省为空, 在高值条码处理时赋值
///  wangjiabin 2014-01-14 添加Inclb参数,缺省为空, 在高值条码处理时赋值
///  wangjiabin 2018-01-25 添加允许跨科室退货控制
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRet","GdRecItmToRet",^templxt("aa"),^templxt("bb"))
Query GdRecItmToRet(Params As %String, q As %String) As Query(ROWSPEC = "Inci,Code,Description,ManfName,BatNo,ExpDate,RecQty:%Float,Uom,UomDesc,StkQty:%Float,Ingri,VendorDesc,IDate,Rp:%Float,Sp:%Float,Inclb,InvNo,InvDate,InvAmt:%Float,Vendor,ConFac,Spec,SpecDesc,HvFlag,IngriLeftQty:%Float,BUom,PConFac,MatInsuCode,MatInsuDesc")
{
}

ClassMethod GdRecItmToRetExecute(ByRef qHandle As %Binary, Params As %String, q As %String) As %Status
{
	n (qHandle,Params,q)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	s pLoc=PJObj.%Get("Loc")
	s Inci=PJObj.%Get("Inci")
	s pVendor=PJObj.%Get("Vendor")
	s ZeroFlag=PJObj.%Get("ZeroFlag")
	s pIngri=PJObj.%Get("Ingri")
	s pInclb=PJObj.%Get("Inclb")
	s pBatchNo=PJObj.%Get("BatchNo")
	s pExpDate=PJObj.%Get("ExpDate")
	s pExpDate=..DH2L(pExpDate)
	s HospId=PJObj.%Get("gHospId")
	s UserId=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	q:pLoc="" $$$OK
	q:Inci="" $$$OK

	;Inclb不为空时,先进行Loc判断
	s (IncilLoc,pIncib)=""
	i pInclb'="" d
	.s Inci=$p(pInclb,"||",1)
	.s IL=$p(pInclb,"||",2)
	.s LB=$p(pInclb,"||",3)
	.s IncilLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	.s pIncib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	q:(pInclb'="")&&(IncilLoc'=pLoc) $$$OK
	s AppName=..%GetParameter("AppName")
	s Param=GroupId_"^"_pLoc_"^"_UserId_"^"_HospId
	s AllowReturnElse=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AllowReturnElse",Param)

	s n=0
	s Ingr=""
	f  s Ingr=$o(^DHCINGR(0,"INCI",Inci,Ingr),-1) q:Ingr=""  d
	.q:($d(^DHCINGR(Ingr))=0)!($d(^DHCINGR(Ingr))=10)
	.s obj=##class(User.DHCINGdRec).%OpenId(Ingr)
	.s Loc=obj.INGRLocDr.%Id()
	.;低值 或 不允许跨科室退货时, 必须控制Loc过滤
	.q:((AllowReturnElse'="Y")||(pInclb=""))&&(pLoc'=Loc)
	.q:obj.INGRAPCVMDR=""
	.s Vendor=obj.INGRAPCVMDR.%Id()
	.q:(pVendor'="")&(pVendor'=Vendor)
	.s VendorDesc=obj.INGRAPCVMDR.APCVMName
	.s AuditFlag=obj.INGRAuditFlag q:AuditFlag'="Y"   //未审核　
	.s IngCH=""
	.f  s IngCH=$o(^DHCINGR(0,"INCI",Inci,Ingr,IngCH)) q:IngCH=""  d
	..s Ingri=Ingr_"||"_IngCH
	..s objItm=##class(User.DHCINGdRecItm).%OpenId(Ingri)
	..s InclbObj=objItm.INGRIINCLBDR q:InclbObj=""
	..s Inclb=InclbObj.%Id() q:Inclb=""
	..s Incib=objItm.INGRIINCIBDR.%Id()
	..;仅取符合条件的记录,根据高值条码所记录信息查询时用到
	..;2018-01-25 过滤inclb改成按incib
	..q:((pIngri'="")!(pInclb'=""))&&((pIngri'=Ingri)!(Incib'=pIncib))
	..;2018-01-25 过滤之后,INCLB按传入的Inclb来取值(入库字表扔按objItm进行)
	..s:pInclb'="" Inclb=pInclb
	..s Code=$p(^INCI(Inci,1),"^",1)
	..s Description=$p(^INCI(Inci,1),"^",2)
	..s CurQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,Loc,+$h)  
	..s RecQty=objItm.INGRIRecQty
	..s Uom=objItm.INGRICTUOMDR.%Id()
	..i Uom="" s Uom=+$p($g(^INCI(Inci,1)),"^",10)
	..s UomDesc=objItm.INGRICTUOMDR.CTUOMDesc
	..
	..;使用"数组"控制批次可退数量
	..i '$d(InclbIngriArr(Inclb)) d
	...s InclbIngriArr(Inclb)=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,Uom)
	..s InclbStkQty=InclbIngriArr(Inclb)
	..q:(ZeroFlag="Y")&(InclbStkQty'>0)  //不显示零批次
	..
	..;可退数量 = min(入库数量 - 退货单上的(本条退货明细除外)退货总和, 批次库存)
	..s IngriLeftQty=..GetIngriLeftQty(Ingri,"")		;对应入库单上的单位
	..s InclbIngriArr(Inclb)=InclbStkQty-IngriLeftQty		;去除本条入库记录占用的库存数量
	..s StkQty=IngriLeftQty
	..q:(ZeroFlag="Y")&(IngriLeftQty'>0)
	..
	..s IDate=obj.INGRDate 
	..s IDate=..DL2H(IDate) ; 审核日期
	..s Rp=objItm.initmrealprice
	..s Sp=objItm.initmsaleprice
	..s ManfName=objItm.initmphmnfdr.PHMNFName
	..s InvNo=objItm.initminvno
	..s InvDate=objItm.initminvdate
	..s InvDate=..DL2H(InvDate)
	..s InvAmt=objItm.initminvmoney
	..s Tmp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	..s BatNo=$p(Tmp,"^",1),ExpDate=$p(Tmp,"^",2)
	..q:(pBatchNo'="")&&(pBatchNo'=BatNo)
	..q:(pExpDate'="")&&(pExpDate'=..DH2L(ExpDate))
	..s BUom=$P(^INCI(Inci,1),"^",10)
	..s PUomId=$p(^INCI(Inci,3),"^",6)
	..s PConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUom)
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
	..s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	..s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	..s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(Inci,HospId)
	..s MatInsuCode=$p(MatInsuInfo,"^",1)
	..s MatInsuDesc=$p(MatInsuInfo,"^",2)
	..d OutPutRow2
	Quit $$$OK
OutPutRow2
	s Data=$lb(Inci,Code,Description,ManfName,BatNo,ExpDate,RecQty,Uom,UomDesc,StkQty,
		Ingri,VendorDesc,IDate,Rp,Sp,Inclb,InvNo,InvDate,InvAmt,
		Vendor,ConFac,Spec,SpecDesc,HvFlag,IngriLeftQty,BUom,PConFac,MatInsuCode,MatInsuDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取入库单明细对应的可退数量(对应入库明细上的单位)
/// 入库数量 - 退货单上的(本条退货明细除外)退货总和
ClassMethod GetIngriLeftQty(Ingri, Ingrti = "")
{
	n (Ingri,Ingrti)
	q:Ingri="" ""
	
	s Ingr=$p(Ingri,"||",1),Ch=$p(Ingri,"||",2)
	s IngriData=^DHCINGR(Ingr,"GRI",Ch)
	s Inclb=$p(IngriData,"^",1)
	s IngrQty=$p(IngriData,"^",4)
	s UomId=$p(IngriData,"^",10)
	s Inci=$p(Inclb,"||",1)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s IngriUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	s InclbAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,UomId)
	
	s RetQty=0
	s Ingrt=0
	f  s Ingrt=$o(^INGRT(0,"INGRI",Ingri,Ingrt)) q:Ingrt=""  d
	.s AuditFlag=$p(^INGRT(Ingrt),"^",15)
	.q:AuditFlag'="Y"
	.s Ch=0
	.f  s Ch=$o(^INGRT(0,"INGRI",Ingri,Ingrt,Ch)) q:Ch=""  d
	..s IngrtiId=Ingrt_"||"_Ch
	..q:(Ingrti'="")&&(IngrtiId=Ingrti)		;过滤
	..s IngrtiQty=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",2)
	..s IngrtiUom=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",3)
	..s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(IngrtiUom,BUomId)
	..s IngrtiQtyBUom=IngrtiQty*UomFac/IngriUomFac
	..s RetQty=RetQty+IngrtiQtyBUom
	
	s LeftQty=IngrQty-RetQty
	s LeftQty=$s(LeftQty<InclbAvaQty:LeftQty,1:InclbAvaQty)		;因退货单没有占用,这里使用"可用库存"
	
	q LeftQty
}

/// 检索库存项目的历史供应商(入过库)
/// Author:zhwh
/// Date:2012-07-04
/// Argu:
///   INCI -库存项目rowid
///   Loc  - 退货科室rowid
///   ExcludeZeroQtyVendor - 排除0库存的供应商(Y/N)
///   
Query VendorForLocItm(INCI As %String, Loc As %String, ExcludeZeroQtyVendor As %String = "") As Query(ROWSPEC = "vendor,vendorName,latestRecDate,venStkQty:%Float,puomDesc")
{
}

ClassMethod VendorForLocItmExecute(ByRef qHandle As %Binary, INCI As %String, Loc As %String, ExcludeZeroQtyVendor As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:INCI="" $$$OK
	q:Loc="" $$$OK
	s ExcludeZeroQtyVendor=$G(ExcludeZeroQtyVendor)

	s incilsub=$o(^INCI("IL_LOC",Loc,INCI,"")) q:incilsub="" ""
	s incil=INCI_"||"_incilsub
	s i=0,dah=""
	f  s dah=$o(^DHCINTR(0,"ILTYPEDATE",incil,"G",dah),-1) q:dah=""  d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,"G",dah,intr),-1) q:intr=""  d
	..s dhcingri=$p(^DHCINTR(intr),"^",9)
	..s dhcingr=$p(dhcingri,"||",1) q:dhcingr=""
	..q:'$d(^DHCINGR(dhcingr))
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..s ven=$p(^DHCINGR(dhcingr),"^",3)
	..s indate=$p(^DHCINGR(dhcingr),"^",4) ;入库时间
	..s inclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
	..
	..i '$d(^TMP("VendorForLocItm",$j,ven,indate,inclb)) d
	...s ^TMP("VendorForLocItm",$j,ven,indate,inclb)=inclbQty
	..e  d
	...s $p(^TMP("VendorForLocItm",$j,ven,indate,inclb),"^",1)=$p(^TMP("VendorForLocItm",$j,ven,indate,inclb),"^",1)+inclbQty
	..
	s tmpven=""
	f  s tmpven=$o(^TMP("VendorForLocItm",$j,tmpven)) q:tmpven=""  d
	.s venStkQty=0
	.s latestRecDate=$O(^TMP("VendorForLocItm",$j,tmpven,""),-1)
	.
	.s recDate=""
	.f  s recDate=$O(^TMP("VendorForLocItm",$j,tmpven,recDate)) q:recDate=""  d
	..s inclb=""
	..f  s inclb=$O(^TMP("VendorForLocItm",$j,tmpven,recDate,inclb)) q:inclb=""  d
	...s venStkQty=venStkQty+$p(^TMP("VendorForLocItm",$j,tmpven,recDate,inclb),"^",1)
	.
	.i ExcludeZeroQtyVendor="Y" q:venStkQty'>0  //供应商库存的判断
	.
	.s buom=$p(^INCI(INCI,1),"^",10)
	.s puom=$p(^INCI(INCI,3),"^",6)
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,buom)
	.s venStkQty=venStkQty/fac
	.d OutPutRow3

	k ^TMP("VendorForLocItm",$j)
	Quit $$$OK

OutPutRow3
	s vendorName=$p(^APC("APCVM",tmpven),"^",3)
	i latestRecDate'=""  s latestRecDate=..DL2H(latestRecDate)
	s puomDesc=$p(^CT("UOM",puom),"^",2)
	s Data=$lb(tmpven,vendorName,latestRecDate,venStkQty,puomDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 设置退货单完成状态 
/// Author:zhwh
/// Date:2012-07-17
/// Argu:
///  ingrt - 退货单主表rowid
/// Return:
///  0 - success
///  <0 - failure
/// w ##class(web.DHCSTMHUI.DHCINGdRet).jsSetCompleted(^templxt("mmmmmm"))
ClassMethod jsSetCompleted(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetCompleted(Params)
	q RtnObj.Json()
}

ClassMethod SetCompleted(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")

	s RetId=PJObj.%Get("RowId")
	s UserId=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")
	i RetId="" 	q RtnObj.Err(-2,"","RetId不能为空!","",0)

	s CompFlag=$p(^INGRT(RetId),"^",6)
	q:CompFlag="Y" RtnObj.Err(-3,"","已完成,不能重复完成!","",0) 

	i ..sssLock(..%GetParameter("AppName")_RetId)<0 q RtnObj.Err(-3,"","加锁失败!")
	
	ts
	s obj=##class(User.DHCINGDRET).%OpenId(RetId)
	d obj.%Reload()
	s obj.INGRTCompleted="Y"
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.tro
	.d RtnObj.Err(-4,"","退货单完成失败")
	.d ..sssUnLock(..%GetParameter("AppName")_RetId)
	q:RtnObj.success'=0 RtnObj
	
	/// 完成后自动审核
	s LocId=$p(^INGRT(RetId),"^",7)
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AutoAuditAfterCompDRET=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"AutoAuditAfterCompDRET",Param)
	i AutoAuditAfterCompDRET="Y" d
	.s RtnObj =..Audit(Params)
	.q:RtnObj.success'=0  
	
	i RtnObj.success'=0 d
	.tro
	.d ..sssUnLock(..%GetParameter("AppName")_RetId)
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(..%GetParameter("AppName")_RetId)
	tc
	s RtnObj.rowid=RetId
	q RtnObj
}

ClassMethod jsCancelCompleted(RetId) As %String
{
	n (RetId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelCompleted(RetId)
	q RtnObj.Json()
}

/// 取消退货单完成状态 
/// Author:zhwh
/// Date:2012-07-17
/// Argu:
///  RetId - 退货单主表rowid
/// Return:
///  0 - success
///  <0 - failure
ClassMethod CancelCompleted(RetId As %String) As RtnObj
{
	n (RetId)
	s RtnObj=##class(RtnObj).%New()
	q:RetId="" RtnObj.Err(-1,"","RetId不能为空!","",0)
	
	s CompFlag=$p(^INGRT(RetId),"^",6)
	q:CompFlag'="Y" RtnObj.Err(-2,"","未完成,不能取消完成!","",0)  
	
	s AuditFlag=$p(^INGRT(RetId),"^",15)
	q:AuditFlag="Y" RtnObj.Err(-3,"","已审核,不能取消完成!","",0) 
	
	i ..sssLock(..%GetParameter("AppName")_RetId)<0 q RtnObj.Err(-4,"","加锁失败!")

	s obj=##class(User.DHCINGDRET).%OpenId(RetId)
	d obj.%Reload()
	s obj.INGRTCompleted="N"
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.s Sc=RtnObj.Err(-5,"","更新失败!")
	.d ..sssUnLock(..%GetParameter("AppName")_RetId)
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(..%GetParameter("AppName")_RetId)
	s RtnObj.rowid=RetId	
	q RtnObj
}

/// 根据入库明细取入库的进价和售价
/// Author:zhwh
/// Date:2013-01-05
/// Arguments:
///   ingri - 入库明细表rowid
///   uom -单位rowid
ClassMethod IngriPrice(ingri As %String, uom As %String) As %String
{
	n (ingri,uom)
	&sql( select initm_inci_dr,initm_realprice,initm_saleprice,ingri_ctuom_dr 
	into :inci,:rp,:sp,:recUom   from dhc_ingdrecitm where %id=:ingri)
	s data="^"
	q:SQLCODE data
	s inci=+inci
	i +uom=+recUom d
	.s data=rp_"^"_sp
	e  d
	.s buom=$p($G(^INCI(inci,1)),"^",10)
	.s fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+recUom,buom)
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+uom,buom)
	.s rp=(rp/fac1)*fac
	.s sp=(sp/fac1)*fac
	.s data=rp_"^"_sp
	q data
}

/// Descript:验证数据是否正确
/// Creater:ZhangDongmei
/// CreateDate: 2012-10-19
/// Input:退货主表id
/// Output:     
/// Return：数据验证通过:0
/// 数据验证不通过:DHC_StkSysErrorRecord rowid
ClassMethod CheckDataValid(retid) As %Library.String
{
	n (retid)
	q:retid="" 0
	s AppCode=..%GetParameter("AppName")
	s KeyValue=$p(^INGRT(retid),"^",1)   ;单号
	s ret=0
	s Apc=$p(^INGRT(retid),"^",2)
	i Apc=""  d
	.s ErrInfo="退货供应商为空"
	q:ErrInfo'="" ErrInfo
	s Loc=$p(^INGRT(retid),"^",7)
	i Loc=""  d
	.s ErrInfo="退货科室为空"
	q:ErrInfo'="" ErrInfo
	;
	s Chl=0
	f  s Chl=$o(^INGRT(retid,"DHCGRR",Chl)) q:(Chl="")!(ret'=0)  d
	.s Inclb=$p(^INGRT(retid,"DHCGRR",Chl),"^",6)
	.s Qty=$p(^INGRT(retid,"DHCGRR",Chl),"^",2)
	.s UomId=$p(^INGRT(retid,"DHCGRR",Chl),"^",3)
	.s Rp=$p(^INGRT(retid,"DHCGRR",Chl),"^",7)
	.;s Sp=$p(^INGRT(retid,"DHCGRR",Chl),"^",8)
	.s Sp=""  ;退货的时候不对售价进行控制20160216
	.s ret=##class(web.DHCSTMHUI.Common.UtilCommon).CheckDetail(AppCode,Inclb,Qty,Rp,Sp,UomId)
	.q:ret'=0
	.
	q:ret'=0 ret    ;明细验证不通过
	;
	q 0    ;验证通过
}

/// w ##class(web.DHCSTMHUI.DHCINGdRet).jsSendIngRetToSCM(88)
ClassMethod jsSendIngRetToSCM(RowId) As %String
{
	n (RowId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SendIngRetToSCM(RowId)
	q RtnObj.Json()
}

/// 发送退货单到平台
ClassMethod SendIngRetToSCM(RowId As %String) As RtnObj
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	i RowId="" q RtnObj.Err(-1,"","RetId不能为空!","",0)
	
	s SendToSCM="",Ret=-1
	&sql(SELECT INGRT_SendToSCM INTO:SendToSCM FROM DHC_INGDRET WHERE ID=:RowId)
	i SendToSCM="Y" q RtnObj.Err(-1,"","已经推送到平台,不能重复推送!","",0)
	
	s LocId=$p(^INGRT(RowId),"^",7)
	s HospId=..sssHospId(LocId)
	s Ret=##class(web.DHCSTMHUI.ServiceForSCI).getRetOrder(RowId)
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).saveSupRet(RowId,HospId)
	i Ret'=0 q RtnObj.Err(-2,RowId,"推送失败!")

	s SendFlag="Y"
	&sql(UPDATE DHC_INGDRET SET INGRT_SendToSCM=:SendFlag WHERE ID=:RowId)
	i SQLCODE'=0 q RtnObj.Err(-3,RowId,"更新退货单推送状态失败!")

	q RtnObj
}

/// 取消发送退货单到平台
/// w ##class(web.DHCSTMHUI.DHCINGdRet).CancelSend(88)
ClassMethod CancelSend(RowId As %String) As %String
{
	n (RowId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i RowId="" s Sc=RtnObj.Err(-1,"","RetId不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s SendToSCM="",Ret=-1
	&sql(SELECT INGRT_SendToSCM INTO :SendToSCM FROM DHC_INGDRET WHERE ID=:RowId)
	i SendToSCM'="Y" s Sc=RtnObj.Err(-1,"","尚未推送到平台!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s LocId=$p(^INGRT(RowId),"^",7)
	s HospId=..sssHospId(LocId)
	s Ret=##class(web.DHCSTMHUI.ServiceForSCI).getRetOrder(RowId)
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).cancelSupRet(RowId,HospId)
	i Ret'=0 d RtnObj.Err(-2,RowId,"推送失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s CancelSendFlag="N"
	&sql(UPDATE DHC_INGDRET SET INGRT_SendToSCM=:CancelSendFlag WHERE ID=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-3,RowId,"更新退货单推送状态失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	q RtnObj.Json()
}

/// 调用ECS供应链,获取退货单状态
/// w ##class(web.DHCSTMHUI.DHCINGdRet).jsSetRetStatus(87)
ClassMethod jsSetRetStatus(RowId As %String)
{
	n (RowId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetRetStatus(RowId)
	q RtnObj.Json()
}

ClassMethod SetRetStatus(RowId As %String) As RtnObj
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	i RowId="" q RtnObj
	
	s HRPFlag=""
	&sql(SELECT INGRT_HRPFlag INTO :HRPFlag FROM DHC_INGDRET WHERE ID=:RowId)
	i HRPFlag="1" q RtnObj.Err(-1,"","已获取退货单状态!","",0)
	
	s LocId=$p(^INGRT(RowId),"^",7)
	s HospId=..sssHospId(LocId)
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).getRetrunsState(RowId,HospId)
	;i Ret'=0 q RtnObj.Err(-2,RowId,"获取状态失败!")	;目前此方法没有返回值

	q RtnObj
}

/// Description:验证退货单上是否有非该科室入库的物资
/// Creator:	wangjiabin
/// CreateDate: 2018-02-01
/// Input:		退货主表id
/// OutPut:		"":ok, 非空:科室不对应的信息
/// w ##class(web.DHCSTMHUI.DHCINGdRet).CheckItmLoc(32)
ClassMethod CheckItmLoc(Ingrt As %String)
{
	n (Ingrt)
	q:Ingrt="" ""
	s Ret=""
	s IngrtLoc=$p(^INGRT(Ingrt),"^",7)
	s Ch=0
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch)) q:Ch=""  d
	.s Ingrti=Ingrt_"||"_Ch
	.s DHCIT=$o(^DHCITD(0,"Type","R","Pointer",Ingrti,0))
	.s HVBarCode=$s(DHCIT'="":$p(^DHCIT(DHCIT),"^",2),1:"")
	.s Ingri=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",1)
	.s Ingr=$p(Ingri,"||",1)
	.q:Ingr=""
	.s Inclb=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",6)
	.s Inci=$p(Inclb,"||",1)
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s IngrLoc=$p(^DHCINGR(Ingr),"^",13)
	.i IngrLoc'=IngrtLoc d
	..s IngrLocDesc=$p(^CTLOC(IngrLoc),"^",2)
	..s IngrtiInfo=InciCode_" "_HVBarCode_",入库科室为"_IngrLocDesc_"."
	..i Ret="" s Ret=IngrtiInfo
	..e  s Ret=Ret_$c(13,10)_IngrtiInfo
	.
	q Ret
}

/// Description: 获取退货总金额
/// Creator:	lihui
/// CreateDate: 20210309
/// Input:		退货主表id
/// OutPut:		进价金额,售价金额
/// w ##class(web.DHCSTMHUI.DHCINGdRet).InrtAmt(32)
ClassMethod InrtAmt(Ingrt As %String)
{
	n (Ingrt)
	q:Ingrt="" ""
	s (RpAmt,SpAmt)=0
	s Ch=0
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch)) q:Ch=""  d
	.s Ingrti=Ingrt_"||"_Ch
	.s rpamt=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",4)
	.s spamt=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",9)
	.s RpAmt=RpAmt+rpamt
	.s SpAmt=SpAmt+spamt
	q RpAmt_"^"_SpAmt
}

/// 获取退货单平台确认状态
ClassMethod GetPlatState(RowId As %String) As %String
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	i RowId="" s Sc=RtnObj.Err(-1,"","RetId不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s SendToSCM=""
	&sql(SELECT INGRT_SendToSCM INTO :SendToSCM FROM DHC_INGDRET WHERE ID=:RowId)
	i SendToSCM'="Y" s Sc=RtnObj.Err(-1,"","尚未推送到平台!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s LocId=$p(^INGRT(RowId),"^",7)
	s HospId=..sssHospId(LocId)
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).getRetrunsState(RowId,HospId)
	i Ret'=0 d RtnObj.Err(-2,RowId,"获取失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	q RtnObj.Json()
}

/// Creator:wxj
/// CreatDate:2021-12-02
/// Description:判断该退货单是否已经生成月报
/// InPut：退货主表id
/// Return:0,未生成；1,已生成
ClassMethod IfMakeMon(ingrt As %String) As %Library.String
{
	n (ingrt)
	q:ingrt="" 0
	
	s loc=$p(^INGRT(ingrt),"^",7)
	s date=$p(^INGRT(ingrt),"^",9) ;审核日期
	q:loc="" 0
	q:date="" 0
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_ToDate>=:date)
	q:'SQLCODE 1
	q 0
}

/// Creator:wxj
/// CreatDate:2021-12-02
/// Description:判断该退货明细是否已经生成付款单
/// InPut：退货明细id
/// Return:1 已经生成付款单  0 未生成付款单
ClassMethod IfMadePay(Ingrt As %String) As %Library.String
{
	n (Ingrt)
	q:Ingrt="" 0
	s Ret=0
	s Ch=0
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch)) q:(Ch="")!(Ret'=0)  d
	.s Ingrti=Ingrt_"||"_Ch
	.s Pay=$o(^DHCPAY(0,"TYPEGR","R",Ingrti,""))
	.s:+Pay>0 Ret=1	
	q Ret
}

/// Descrpiton: 处理高值取消退货审核自带条码恢复至原字段
/// Date: 2021-12-02
/// return: 0 成功,非0 失败
/// W ##class(web.DHCSTMHUI.DHCINGdRet).UpOldOriBarToOriBar("WJWSGZ20161020002")
ClassMethod UpOldOriBarToOriBar(label) As %String
{
	n (label)
	q:label="" 0
	s ret=0,tmporibar=""
	s DHCITid=$o(^DHCIT(0,"LABEL",label,""))
	q:'$d(^DHCIT(DHCITid)) 0
	s oribarcode=$p(^DHCIT(DHCITid),"^",30)
	q:oribarcode="" 0
	&sql(UPDATE DHC_ItmTrack SET DHCIT_OriginalCode=:oribarcode, DHCIT_OldOriginalBarcode=:tmporibar WHERE DHCIT_Rowid=:DHCITid)
	if SQLCODE d
	.s ret=-1
	q ret
}

/// Creator:wxj
/// CreatDate:2023-02-23
/// Description:判断退货单是否包含补录后取消医嘱产生的退货明细
/// InPut：退货明细id
/// Return:1 包含  0 不包含
ClassMethod IfHVModifyRet(Ingrt As %String) As %Library.String
{
	n (Ingrt)
	q:Ingrt="" 0
	s Ret=0
	s Ch=0
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch)) q:(Ch="")!(Ret'=0)  d
	.s Ingrti=Ingrt_"||"_Ch
	.s dhcitda=$o(^DHCITD(0,"IATypePointer","SR",Ingrti,""))
	.s:dhcitda'="" Ret=1
	q Ret
}

/// Description:处理占用数量(整单)
/// CreateDate:	2023-03-17
/// Input:		退货单rowid, 
ClassMethod HandleDirtyQty(Ingrt As %String, Sign As %String) As RtnObj
{
	n (Ingrt,Sign)
	s RtnObj=##class(RtnObj).%New()
	s Ch=0
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch))  q:(Ch="")||(RtnObj.success<0)  d
	.s Ingrti=Ingrt_"||"_Ch
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGrtItm).HandleRetItmDirtyQty(Ingrti,Sign)
	q RtnObj
}

/// 获取退货单明细的类组串(^隔开)
/// Author:	wxj
/// Date:	2023-04-10
/// Input:RetId - 退货单RowId
/// Return:
ClassMethod GetRetDetailScg(RetId As %String) As %String
{
	n (RetId)
	q:RetId="" ""
	s result=""
	s ch=0
	f  s ch=$o(^INGRT(RetId,"DHCGRR",ch)) q:ch=""  d
	.s Ingrti=RetId_"||"_ch
	.s inclb=$p(^INGRT(RetId,"DHCGRR",ch),"^",6)
	.s inci=+inclb
	.s scg=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",5)
	.i result="" d
	..s result=scg
	.e  i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(result,scg,"^")=0 d
	..s result=result_"^"_scg
	
	q result
}

}
