Import sqluser

Class web.DHCSTMService.HvOldVersion.HvDataSync Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:生成调整单
/// Other:数量-1调少，条码状态改为InAdj，数量1调多，条码状态改为Enable
/// Creater:	
/// CreateDate:	20200618
/// w ##class(web.DHCSTMService.HvOldVersion.HvDataSync).CreateAdjByLable("GZ20200617001","1")
ClassMethod CreateAdjByLable(HVBarCode As %String, ListData As %String) As %Library.String
{
	n (HVBarCode,ListData)
	;s ^zx(88)=$lb(HVBarCode,ListData)
	;q -999
	q:HVBarCode="" -1
	s Qty=$p(ListData,"^",1)
	s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	q:dhcit="" -2
	
	s Inci=$p(^DHCIT(dhcit),"^",1)
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s status=$p(^DHCIT(dhcit),"^",5)
	q:((status'="InAdj")&&(Qty=1)) -3
	q:((status'="Enable")&&(Qty=-1)) -3
	s Inclb=$p(^DHCIT(dhcit),"^",12)
	q:Inclb="" -4
	s LocId="",LocDesc=""
	i Inclb'="" d
	.s il=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(+Inclb,"IL",il),"^",1)
	.s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
	q:LocId="" -5
	s Ret=0
	ts
	s UserId="",AdjReason="",ScgId="",StkType="M",Remark="新系统开医嘱同步"
	s MainData=LocId_"^"_UserId_"^"_AdjReason_"^"_ScgId_"^"_StkType_"^^^^"_Remark
	
	s BuomId=$p(^INCI(Inci,1),"^",10)
	s UomId=BuomId
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Sp=##class(web.DHCSTM.Common.PriceCommon).GetPriceElse(Inclb,+$h,BuomId,HospId)
	s Rp=##class(web.DHCSTM.Common.PriceCommon).GetClbRp(Inclb,BuomId,HospId)
	s RpAmt=Qty*Rp
	s SpAmt=Qty*Sp
	s AdjItm=""
	s ListData=AdjItm_"^"_Inclb_"^"_Qty_"^"_BuomId_"^"_Rp_"^"_Sp_"^"_RpAmt_"^"_SpAmt_"^"_""_"^"_HVBarCode

	s Adj=##class(web.DHCSTM.DHCINAdj).SaveAdj("",MainData,ListData)
	i +Adj<0 s Ret=-6
	i Ret<0 tro
	q:Ret<0 Ret

	s Ret=##class(web.DHCSTM.DHCINAdj).SetComplete(Adj,"Y")
	i Ret<0 tro
	q:Ret<0 Ret

	s Ret=##class(web.DHCSTM.DHCINAdj).Audit(Adj,"")

	i Ret<0 tro
	q:Ret<0 Ret
	s OldStatus=$p(^DHCIT(dhcit),"^",5)
	i ((Qty="1")&&(OldStatus="InAdj")) d
	.s newStatus="Enable"
	.&sql(update DHC_ItmTrack set DHCIT_Status=:newStatus where %id=:dhcit)
	.i SQLCODE'=0 s ret=-11	

	i Ret<0 tro
	q:Ret<0 Ret	
	tc
	q Ret
}

/// Description:老系统生成入库单、出库单
/// 库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^发票金额
/// w ##class(web.DHCSTMService.HvOldVersion.HvDataSync).CreateInfoHvForOld("WZCLKXK001^ZYYJ003^263","GZ202008140011","T")
ClassMethod CreateInfoHvForOld(MainInfo As %String, ListData As %String, Type As %String = "") As %Library.String
{
	n (MainInfo,ListData,Type)
	;s ^zx(888)=$lb(MainInfo,ListData,Type)
	;q -999
	s Err=0
	i Type="G" d
	.s Err=..CreateRec(MainInfo,ListData)
	e  i Type="T" d
	.s Err=..CreateInit(MainInfo,ListData)
	e  i Type="Adj" d
	.s Err=..CreateAdjByLable(MainInfo,ListData)
	q Err
}

/// Description:同步出库单
/// w ##class(web.DHCSTMService.HvOldVersion.HvDataSync).CreateInit("14^427^4668","JR0003^2222^2021-04-28^^15175.2^ff80808171be8df60171c46e788e0016","G")
ClassMethod CreateInit(MainInfo As %String, ListData As %String) As %Library.String
{
	n (MainInfo,ListData)
	s FrLocCode=$p(MainInfo,"^",1)
	s FrlocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(FrLocCode),0))
	s ToLocCode=$p(MainInfo,"^",2)
	s TolocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(ToLocCode),0))
	q:(FrlocId="")||(TolocId="") -1
	s UserCode=$p(MainInfo,"^",3)
	s UserId=""
	s:UserCode'="" UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	s Ret=0
	ts
	s MainData=FrlocId_"^"_TolocId_"^"_UserId 
	s Init=..InsertInit(MainData)
	i +Init<0 d
	.s Ret=-4
	i Ret<0 tro
	q:Ret<0 Ret
	
	s Dev="#"
	s len=$l(ListData,Dev)
	f i=1:1:len  q:Ret<0  d
	.s DetailList=$p(ListData,Dev,i)
	.s Ret=..InsertInitDatail(Init,DetailList)

	i Ret<0 tro
	q:Ret<0 Ret
	s Ret=##class(web.DHCSTM.DHCINIsTrf).TransOutAuditYes(Init,UserId,"","Y")

	i Ret<0 tro
	q:Ret<0 Ret
	s Ret=##class(web.DHCSTM.DHCINIsTrf).TransInAuditYes(Init,UserId)

 	i Ret<0 tro
	q:Ret<0 Ret
	tc
	q Ret
}

/// /// Description:插入出库明细
ClassMethod InsertInitDatail(Init As %String, DetailList As %String) As %Library.String
{
	n (Init,DetailList)
	s HVBarCode=DetailList
	s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	q:dhcit="" -5
	
	s Inci=$p(^DHCIT(dhcit),"^",1)
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s status=$p(^DHCIT(dhcit),"^",5)
	q:status'="Enable" -6
	s Inclb=$p(^DHCIT(dhcit),"^",12)
	q:Inclb="" -7
	s LocId="",LocDesc=""
	i Inclb'="" d
	.s il=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(+Inclb,"IL",il),"^",1)
	.s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
	s FrlocId=$p(^DHCINIT(Init),"^",5)
	q:LocId'=FrlocId -8
	s HospId=$p(^CTLOC(FrlocId),"^",22)
	s ret=0
	s Qty=1
	s BuomId=$p(^INCI(Inci,1),"^",10)
	s UomId=BuomId
	s TmpData=Inclb_"^"_Qty_"^"_UomId
	s ret=##class(web.DHCSTM.DHCINIsTrfItm).CheckTransferDetail("",TmpData)
	q:ret<0 ret
	
	s Sp=##class(web.DHCSTM.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId)
	s Rp=##class(web.DHCSTM.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	s SpAmt=Sp*Qty
	s RpAmt=Rp*Qty
	s SpAmt=##class(web.DHCSTM.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	s RpAmt=##class(web.DHCSTM.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	
	s Data=Inclb_"^"_Qty_"^"_UomId_"^"_""_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_Rp_"^"_RpAmt
	s Rowid=##class(web.DHCSTM.DHCINIsTrfItm).Update("",Init,Data)
	i +Rowid<0 d
	.s ret=-8
	q:ret<0 ret
	s UserId=$p(^DHCINIT(Init),"^",8)
	s operData=FrlocId_"^"_UserId_"^"_Inci_"^^^"
	s result=##class(web.DHCSTM.DHCItmTrack).Save("T",Rowid,operData,HVBarCode)
	s:result'=0 ret=-9
	q:ret<0 ret
	s result=##class(web.DHCSTM.DHCINIsTrf).HandleTransItmDirtyQty(Rowid,1)
	s:result'=0 ret=-10
	q:ret<0 ret
	
	q ret
}

/// /// Description:插入入库单主表
ClassMethod InsertInit(MainData As %String) As %Library.String
{
	n (MainData)
	s FrlocId=$p(MainData,"^",1)
	s TolocId=$p(MainData,"^",2)
	s UserId=$p(MainData,"^",3)
	s stkType="M"
	s remark="新系统同步"
	s status="11"
	s comp="Y"
	s remark=$lfs(remark,$c(3))
	s opType=""
	s Err=0
	i opType="" d
 	.s OperDesc="正常出库",OperStkType="OM"
 	.&sql(select %id into :opType from dhc_operatetype where ipt_desc=:OperDesc and ipt_type=:OperStkType)
 	.s opType=$g(opType)
 	
 	s ret=##class(web.DHCSTM.Common.AppCommon).Lock("TRANSFERNO")  
	s:ret'=0 Err=-99  ;加锁失败
	q:Err<0 Err
	s AppName=##class(web.DHCSTM.DHCINIsTrf).%GetParameter("AppName")
	s TrNo=##class(web.DHCSTM.Common.AppCommon).GetAppNo(AppName,"",FrlocId)
	s:TrNo="" Err=-2   ;生成单号失败
	q:Err<0 Err
	s req="",scg=""
	s d=+$h
 	s t=$p($h,",",2)
	&sql(insert into dhc_inistrf (
	  INIT_No,init_frloc_dr,init_toloc_dr,init_inrq_dr,init_date,
	  init_time,init_ssusr_dr,init_state,init_usercompleted,init_scg_dr,
	  init_stktype,INIT_OperateType,INIT_Remarks)
	  values (:TrNo,:FrlocId,:TolocId,:req,:d,
	  	:t,:UserId,:status,:comp,:scg,
	  	:stkType,:opType,:remark) )
	 i SQLCODE'=0  d
	 .s Err=-3
	 e  d
	 .s Init=%ROWID
	 q:Err<0 Err
	 q Init
}

/// Description:根据新系统数据登记高值条码并生成老系统入库单
/// 库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^发票金额
/// w ##class(web.DHCSTM.HV.CreateInScrapBylable).CreateRec("鲲鹏集团^WZCLKXK001^263","JR0055^2020081455^2022-08-14^^3652^GZ2020081400111^1","G")
ClassMethod CreateRec(MainInfo As %String, ListData As %String) As %Library.String
{
	n (MainInfo,ListData)
	s VendorCode=$p(MainInfo,"^",1)
	s LocCode=$p(MainInfo,"^",2)
	s VendorId=$o(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(VendorCode),0))
	s LocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),0))
	q:((VendorId="")||(LocId="")) -1
	s UserCode=$p(MainInfo,"^",3) ;后期修改取法
	s UserId=""
	s:UserCode'="" UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	s Ret=0
	ts
	s Ingr=..InsertRec(MainInfo)
	i +Ingr<0 d
	.s Ret=-4
	i Ret<0 tro
	q:Ret<0 Ret
	;处理明细数据
	s Dev="#"
	s len=$l(ListData,Dev)
	f i=1:1:len  q:Ret<0  d
	.s IngrInfo=$p(ListData,Dev,i)
	.s Ret=..InsertRecDatail(Ingr,IngrInfo)
	i Ret<0 tro
	q:Ret<0 Ret
	s Ret=##class(web.DHCSTM.DHCINGdRec).Audit(Ingr,UserId,"","Y")
	i Ret<0 tro
	q:Ret<0 Ret

	tc
	q Ret
}

/// /// Description:插入高值条码信息和入库明细信息
ClassMethod InsertRecDatail(Ingr As %String, ListData As %String) As %Library.String
{
	n (Ingr,ListData)
	s InciCode=$p(ListData,"^",1)
	s BatNo=$p(ListData,"^",2)
	s ExpDate=$p(ListData,"^",3)

	s ManfId=$p(ListData,"^",4)
	s Rp=$p(ListData,"^",5)
	s HVBarCode=$p(ListData,"^",6)
	;s HVBarCode=HVBarCode_"1"  ;本机测试修改
	s Qty=$p(ListData,"^",7)
	q:HVBarCode="" -5
	q:Qty'=1 -5
	s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z",""))
	q:+IncId=0 -5
	
	s IngrUser=$p(^DHCINGR(Ingr),"^",16)
  	s VenId=$p(^DHCINGR(Ingr),"^",3)
  	s LocId=$p(^DHCINGR(Ingr),"^",13)
  	s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
  	q:dhcit'="" -6 ;高值条码已经存在
  	s ret=0
  	;注册高值条码
  	s (OriginalCode,SpecDesc,ProduceDate,CertNo,CertExpDate)=""
	s CodeData=dhcit_"^"_IncId_"^"_HVBarCode_"^"_Qty_"^"_OriginalCode
		_"^"_""_"^"_BatNo_"^"_ExpDate_"^"_SpecDesc_"^"_ProduceDate
		_"^"_CertNo_"^"_CertExpDate_"^"_Rp_"^"_ManfId
	s HVRegRet=##class(web.DHCSTM.DHCItmTrack).UpdateReg(CodeData,IngrUser,"",+$h,$p($h,",",2),LocId)
	i HVRegRet<0  s ret=-7	
	q:ret<0 ret
	
	s:ExpDate'="" ExpDate=$zdh(ExpDate,3)
	s BuomId=$p(^INCI(IncId,1),"^",10)
	s UomId=BuomId
	s Margin=""
	s Desc=$p(^INCI(IncId,1),"^",2)
	s InvAmt=""
	s InvNo=""
	s RpAmt=Rp*Qty
	s Sp=##class(web.DHCSTM.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,"","",Rp)
	s InvDate=""
	s SxNo="" 
	s NewSp=Sp
	s Chl=1+$o(^DHCINGR(Ingr,"GRI",""),-1)
	s NewSpAmt=Sp*Qty
	s SpAmt=Sp*Qty
	s (PoItmId,Remark,Remarks,QualityNo,MtDr)=""
	&sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR, 
	    INGRI_CTUOM_DR,INGRI_ExpDate,INGRI_Margin,INGRI_RecQty, INGRI_StkDesc,initm_INCI_DR, initm_invmoney, 
	    initm_invno, initm_phmnf_dr, initm_realprice,initm_realtotal, initm_saleprice, initm_invdate, 
	    initm_BatPrice, initm_sxno,initm_newSp, initm_newSpAmt,initm_SpAmt,INGRI_INPOI_DR,initm_Remark,INGRI_Remarks,initm_QualityNo,initm_MT_Dr)
	    VALUES(:Ingr, :Chl, :BatNo, :LocId,:UomId,:ExpDate,:Margin,:Qty,:Desc,
	    :IncId,:InvAmt,:InvNo,:ManfId,:Rp,:RpAmt,:Sp,:InvDate,:Rp,:SxNo,:NewSp,:NewSpAmt,:SpAmt,:PoItmId,:Remark,:Remarks,:QualityNo,:MtDr))
	  i SQLCODE'=0  d
	  .s ret=-8  ;插入子表失败
	 q:ret<0 ret
	 
   s Ingri=Ingr_"||"_Chl
   s operData=LocId_"^"_IngrUser_"^"_IncId_"^^"_VenId
   s HVret=##class(web.DHCSTM.DHCItmTrack).Update("G",Ingri,HVBarCode,operData)
   i +HVret'=0 s ret=-9
   q:ret<0 ret
  	
	q ret
}

/// /// Description:插入入库单主表
ClassMethod InsertRec(MainInfo As %String) As %Library.String
{
	n (MainInfo)
	s VendorCode=$p(MainInfo,"^",1)
	s LocCode=$p(MainInfo,"^",2)
	s VendorId=$o(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(VendorCode),0))
	s LocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),0))
	s UserCode=$p(MainInfo,"^",3) ;后期修改取法
	s UserId=""
	s:UserCode'="" UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	s AppName=##class(web.DHCSTM.DHCINGdRec).%GetParameter("AppName")
	s IngrNo=##class(web.DHCSTM.Common.AppCommon).GetAppNo(AppName,"",LocId)
	q:IngrNo="" -2
	s Ret=0
	s Complete="Y"
	s ExchangeFlag="N"
	s PresentFlag="N"
	s IngrTypeId=""
	s StkType="M"
	s PurUserId=""
	s StkGrpId=""
	s AuditFlag="N"
	s PoId=""
	s ReqLocId=""
	s h=+$h
	s t=$p($h,",",2)
	s InGrRemarks="新系统同步入库单"
	s MemoDelim=##class(web.DHCSTM.Common.UtilCommon).MemoDelim()
	s InGrRemarks=$lfs(InGrRemarks,MemoDelim)
	
	&sql(insert into dhc_ingdrec(
		INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,INGR_ExRate,INGR_HandChg,
		INGR_No,INGR_Loc_Dr,INGR_CreateUser,INGR_CreateDate,INGR_CreateTime,
		INGR_AdjCheque,INGR_GiftFlag,INGR_Type,INGR_SSUSR_Purch_DR,INGR_SCG_DR,
		INGR_AuditFlag,INGR_StkType,INGR_INPO_DR,INGR_ReqLoc_Dr,INGR_Remarks) 
		values
		(:VendorId,:Complete,1,1,0,
		:IngrNo,:LocId,:UserId,:h,:t,
		:ExchangeFlag,:PresentFlag,:IngrTypeId,:PurUserId,:StkGrpId,
		:AuditFlag,:StkType,:PoId,:ReqLocId,:InGrRemarks)
	)
	i SQLCODE'=0  d
	.s Ret=-3  ;主表插入失败
	e  d
	.s Ingdrec=$g(%ROWID)
	q:Ret<0 Ret
	q Ingdrec
}

}
