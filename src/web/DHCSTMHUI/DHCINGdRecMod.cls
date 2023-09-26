Import sqluser

/// Descript:已审核后修改某些信息相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-07-19
Class web.DHCSTMHUI.DHCINGdRecMod Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	已审核后更新入库信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-02-26
/// Table:DHC_InGdRecItm
/// Input:明细id^生产厂家id^批号^效期^随行单号^发票号^发票日期^发票金额^进价
/// Output:		
/// Return：0：成功，
/// w ##class(web.DHCSTMHUI.DHCINGdRecMod).UpdateRecInfo("6357||1^^201604213A^2018-04-21^^^^170^17")
ClassMethod UpdateRecInfo(ListData As %String) As %Library.String
{
	n (ListData)
	;s ^zx("UpdateRecInfo")=ListData
	s MethodName=$CLASSNAME()_".UpdateRecInfo"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"",MethodName_"入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	While (RtnObj.success=0) {
		s ItmObj=PJObj.%Pop()
		q:ItmObj=""
		s Rowid=ItmObj.%Get("RowId")
		s Chl=$p(Rowid,"||",2)
		s ManfId=ItmObj.%Get("ManfId")
		s BatNo=ItmObj.%Get("BatchNo")
		s ExpDate=ItmObj.%Get("ExpDate")
		s SxNo=ItmObj.%Get("SxNo")
		s InvNo=ItmObj.%Get("InvNo")
		s InvDate=ItmObj.%Get("InvDate")
		s InvAmt=ItmObj.%Get("InvMoney")
		s Rp=ItmObj.%Get("Rp")
		s ckret=..checkIncib(Rowid)
		i ckret=0 d  ///如果明细的批次存在其他入库单 则不能修改
		.s RtnObj=..GriUpdateBat(Rowid,BatNo,ExpDate)
		q:RtnObj.success'=0
		i ckret=0 d
		.s RtnObj=..GriUpdateRp(Rowid,Rp)
		q:RtnObj.success'=0
		i ckret=0 d
		.s RtnObj=..GriUpdateManf(Rowid,ManfId)
		q:RtnObj.success'=0
		
		s RtnObj=..GriUpdateInv(Rowid,InvNo,InvDate,InvAmt)
		q:RtnObj.success'=0
		s RtnObj=..GriUpdateSXD(Rowid,SxNo)
		q:RtnObj.success'=0
	}
	q RtnObj.Json()
}

/// Creator:zdm
/// CreatDate:2012-07-19
/// Description:更新入库供应商
/// InPut：入库主表rowid,供应商id
/// Table:dhc_ingdrec,DHC_IncItmBat
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GrUpdateVen(IngrId As %String, VendorId As %String) As %Library.String
{
	n (IngrId,VendorId)
	s MethodName=$CLASSNAME()_".GrUpdateVen"
	s RtnObj=##class(RtnObj).%New()
	i ((IngrId="")||('$d(^DHCINGR(IngrId)))) d RtnObj.Err(-1,"","入库单不存在!","",0) q RtnObj.Json()
	s OldVenId=$p(^DHCINGR(IngrId),"^",3)
	i VendorId=OldVenId q RtnObj.Json()   ;不需要更新
	s Ret=..IfExistMadeRet(IngrId)	;2013-09-12 IfReturn-->IfExistMadeRet
	i Ret'=0 d RtnObj.Err(-2,"","该入库单已经发生退货,不能修改供应商!","",0) q RtnObj.Json()
	s Ret=..IfExistMadePay(IngrId)	;2013-09-12 IfExistPay-->IfExistMadePay
	i Ret'=0 d RtnObj.Err(-3,"","该入库单已经发生付款，不能修改供应商!","",0) q RtnObj.Json()
	s Ret=..IfExistIncib(IngrId)	;2022-02-25 
	i Ret'=0 d RtnObj.Err(-3,"","该入库单中批次存在于其它入库单，不能修改供应商!","",0) q RtnObj.Json()
	;
	tstart
	s $ZT=..sssError()
	s Err=0
	&sql(update dhc_ingdrec set INGR_APCVM_DR=:VendorId
	where ingr_Rowid=:IngrId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-4,"",MethodName_"更新入库主表失败!")  ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj.Json() 
	;更新批次信息表中的供应商
	&sql(update DHC_IncItmBat set INCIB_APCVM_Dr=:VendorId
	where INCIB_INGRI_Dr->INGRI_INGR_ParRef=:IngrId)
	i (SQLCODE'=0)&(SQLCODE'=100)  d
	.d RtnObj.Err(-5,"",MethodName_"更新批次表失败!")  ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj.Json() 
	tcommit
	q RtnObj.Json()
}

/// Creator:zdm
/// CreatDate:2012-07-19
/// Description:更新入库明细对应的生产厂家
/// InPut：入库明细rowid,生产厂家id
/// Table:dhc_ingdrec,DHC_IncItmBat
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GriUpdateManf(Ingri As %String, ManfId As %String) As %Library.String
{
	n (Ingri,ManfId)
	s MethodName=$CLASSNAME()_".GriUpdateManf"
	s RtnObj=##class(RtnObj).%New()
	i Ingri="" d RtnObj.Err(-1,"","入库明细id为空!","",0) q RtnObj
	s OldManfId=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",29)
	i ManfId=OldManfId q RtnObj     ;不需要更新
	;
	s Err=0
	tstart
	s $ZT=..sssError()
	&sql(update dhc_ingdrecitm set initm_phmnf_dr=:ManfId
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.d RtnObj.Err(-2,"","更新入库表中生产厂家失败!")  ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj
	;更新批次信息表中的生产厂家
	s Chl=$p(Ingri,"||",2)
	s Inclb=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",1)
	i Inclb'=""  d
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.&sql(update DHC_IncItmBat set INCIB_PHMNF_Dr=:ManfId
	where INCIB_INCIB_Dr=:Incib)
	.i SQLCODE'=0  d
	..d RtnObj.Err(-3,"",MethodName_"更新批次表中生产厂家失败!")  ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj
	tcommit
	q RtnObj
}

/// Creator:zdm
/// CreatDate:2012-07-19
/// Description:更新入库明细批号、效期
/// InPut：入库明细rowid,批号,效期
/// Table:dhc_ingdrec,INC_ItmBat
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GriUpdateBat(Ingri As %String, BatNo As %String, ExpDate As %String) As %Library.String
{
	n (Ingri,BatNo,ExpDate)
	s MethodName=$CLASSNAME()_".GriUpdateBat"
	s RtnObj=##class(RtnObj).%New()
	i Ingri="" d RtnObj.Err(-1,"","入库明细id为空!","",0) q RtnObj
	s:ExpDate'="" ExpDate=..DH2L(ExpDate)
	s OldBatNo=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",13)
	s OldExpDate=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",9)
	i (BatNo=OldBatNo)&(ExpDate=OldExpDate) q RtnObj  ;不需要更新
	;
	s Err=0
	tstart
	
	s Ingr=$p(Ingri,"||",1)
	s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Ingri)
	i HVBarCode'="" d
	.s Incib=""
	.&sql(select Ingri_Incib_dr into :Incib from dhc_ingdrecitm where ingri_rowid=:Ingri)
	.q:(SQLCODE'=0)
	.&sql(update dhc_ingdrecitm set INGRI_ExpDate=:ExpDate,INGRI_BatchNo=:BatNo where ingri_Ingr_parref=:Ingr and Ingri_Incib_dr=:Incib)
	e  d
	.&sql(update dhc_ingdrecitm set INGRI_ExpDate=:ExpDate,INGRI_BatchNo=:BatNo where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.d RtnObj.Err(-2,"","更新入库明细失败!")
	i RtnObj.success'=0 trollback  q RtnObj
	;更新批次信息表中的批号效期
	s Chl=$p(Ingri,"||",2)
	s Inclb=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",1)
	i Inclb'=""  d
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.&sql(update INC_ItmBat set INCIB_No=:BatNo,INCIB_ExpDate=:ExpDate
		where INCIB_Rowid=:Incib)
	.i SQLCODE'=0  d
	..d RtnObj.Err(-3,"","更新批次信息失败!")
	i RtnObj.success'=0 trollback  q RtnObj
	tcommit
	q RtnObj
}

/// Creator:zdm
/// CreatDate:2012-07-20
/// Description:更新入库明细随行单
/// InPut：入库明细rowid,随行单号
/// Table:dhc_ingdrec
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GriUpdateSXD(Ingri As %String, SxNo As %String) As %Library.String
{
	
	n (Ingri,SxNo)
	s MethodName=$CLASSNAME()_".GriUpdateSXD"
	s RtnObj=##class(RtnObj).%New()
	i Ingri="" d RtnObj.Err(-1,"","入库明细id为空!","",0) q RtnObj
	s OldSxNo=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",38)
	i SxNo=OldSxNo q RtnObj  ;不需要更新
	;
	s Err=0
	s $ZT=..sssError()
	&sql(update dhc_ingdrecitm set initm_sxno=:SxNo
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.d RtnObj.Err(-2,"","更新入库明细失败!")  ;更新失败
	q RtnObj
}

/// Creator:zdm
/// CreatDate:2012-07-20
/// Description:更新入库明细发票信息
/// InPut：入库明细rowid,发票号,发票日期,发票金额
/// Table:dhc_ingdrec
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GriUpdateInv(Ingri As %String, InvNo As %String, InvDate As %String, InvAmt As %String) As %Library.String
{
	n (Ingri,InvNo,InvDate,InvAmt)
	s MethodName=$CLASSNAME()_".GriUpdateInv"
	s RtnObj=##class(RtnObj).%New()
	i Ingri="" d RtnObj.Err(-1,"","入库明细id为空!","",0) q RtnObj
	s:InvDate'="" InvDate=..DH2L(InvDate)
	s OldInvNo=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",27)
	s OldInvDate=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",34)
	s OldInvAmt=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",26)
	i (InvNo=OldInvNo)&(InvDate=OldInvDate)&(InvAmt=OldInvAmt) q RtnObj ;不需要更新
	s Ret=..IfPay(Ingri)
	i Ret'=0 d RtnObj.Err(-2,"","已经付款,不能更新发票信息!"_InvNo,"",0) q RtnObj
	s InvSetDate=##class(web.DHCSTMHUI.DHCINGdRecItm).GetInvSetDate(Ingri,"G",InvNo)
	s Err=0
	s $ZT=..sssError()
	&sql(update dhc_ingdrecitm set initm_invno=:InvNo,initm_invdate=:InvDate,initm_invmoney=:InvAmt,initm_InvSetDate=:InvSetDate 
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.d RtnObj.Err(-3,"","更新发票信息失败!"_InvNo)
	q RtnObj
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:更新入库明细进价
/// InPut：入库明细rowid,进价
/// Table:dhc_ingdrecitm,DHC_IncItmBat
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GriUpdateRp(Ingri As %String, Rp As %Numeric) As %Library.String
{
	n (Ingri,Rp)
	s MethodName=$CLASSNAME()_".GriUpdateRp"
	s RtnObj=##class(RtnObj).%New()
	i Ingri="" d RtnObj.Err(-1,"","入库明细id为空!","",0) q RtnObj
	i +Rp=0 d RtnObj.Err(-2,"","进价为0!") q RtnObj
	s OldRp=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",30)
	i Rp=OldRp q RtnObj   ;不需要更新
	i ..IfMakeMon(+Ingri)'=0 d RtnObj.Err(-3,"","已经生成月报，不能修改!","",0) q RtnObj
	i ..IfRetToVen(Ingri)'=0 d RtnObj.Err(-4,"","已经退货，不能修!","",0) q RtnObj
	i ..IfPay(Ingri)'=0 d RtnObj.Err(-5,"","已经付款，不能修改 !","",0) q RtnObj
	;
	tstart
	s $ZT=..sssError()
	s Chl=$p(Ingri,"||",2)
	s Qty=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",4)
	s RecUom=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",10)
	s Inclb=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",1)
	s BUom=$p(^INCI(+Inclb,1),"^",10)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RecUom,BUom)
	s BRp=Rp/Fac
	s RpAmt=Qty*Rp
	s LocId=$p(^DHCINGR(+Ingri),"^",13)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,1)
	s BRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,2)
	s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	&sql(update dhc_ingdrecitm set initm_realprice=:Rp,initm_realtotal=:RpAmt
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.d RtnObj.Err(-6,"","更新入库表失败!") ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj
	;更新批次信息表中的进价
	i Inclb'=""  d
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.&sql(update DHC_IncItmBat set INCIB_Rp=:BRp,INCIB_RpPuruom=:Rp
	where INCIB_INCIB_Dr=:Incib)
	.i SQLCODE'=0  d
	..d RtnObj.Err(-7,"","更新批次表失败!") ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj
	
	;修改入库单台账信息
	s transtype="G"
	&sql(update DHC_INTRANS set INTR_Rp=:Rp,INTR_RpAmount=:RpAmt where INTR_Type=:transtype and
	INTR_Pointer=:Ingri)
	i SQLCODE'=0  d
	.d RtnObj.Err(-8,"","更新入库台账表失败!") ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj
	;修改出库单明细信息和台账信息
	s RecAuditDate=$p(^DHCINGR(+Ingri),"^",4)
	s RecAuditTime=$p(^DHCINGR(+Ingri),"^",9)
	s Init=""
	f  s Init=$o(^DHCINIT(0,"INCLB",Inclb,Init)) q:((Init="")||(RtnObj.success'=0))  d
	.s InitDate=$p(^DHCINIT(Init),"^",2)
	.s InitTime=$p(^DHCINIT(Init),"^",3)
	.q:InitDate<RecAuditDate
	.q:((InitDate=RecAuditDate)&&(InitTime<RecAuditTime))
	.s sub=""
	.f  s sub=$o(^DHCINIT(0,"INCLB",Inclb,Init,sub)) q:((sub="")||(RtnObj.success'=0))  d
	..s Initi=Init_"||"_sub
	..s TrQty=$p(^DHCINIT(Init,"ITI",sub),"^",1) 
	..s TrUom=$p(^DHCINIT(Init,"ITI",sub),"^",7)
	..s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RecUom,TrUom)
	..s TrRp=Rp/Fac
	..s TrAmtRp=TrQty*TrRp
	..s $p(^DHCINIT(Init,"ITI",sub),"^",13)=TrRp
	..s $p(^DHCINIT(Init,"ITI",sub),"^",14)=TrAmtRp
	..s $p(^DHCINIT(Init,"ITI",sub),"^",15)=TrRp
	..s $p(^DHCINIT(Init,"ITI",sub),"^",16)=TrAmtRp
	..s TransOutAmtRp=-1*TrAmtRp
	..s TransOutType="T"
	..s TransInType="K"
	..s InitState=""
	..s InitState=$p(^DHCINIT(Init),"^",14)
	..q:((InitState'="21")&&(InitState'="31"))
	..&sql(update DHC_INTRANS set INTR_Rp=:TrRp,INTR_RpAmount=:TransOutAmtRp where INTR_Type=:TransOutType and INTR_Pointer=:Initi)
	..i SQLCODE'=0  d
	...d RtnObj.Err(-9,"","更新出库台账表失败!") ;更新失败
	..q:RtnObj.success'=0
	..q:InitState'="31"
	..&sql(update DHC_INTRANS set INTR_Rp=:TrRp,INTR_RpAmount=:TrAmtRp where INTR_Type=:TransInType and INTR_Pointer=:Initi)
	..i SQLCODE'=0  d
	...d RtnObj.Err(-10,"","更新转移入库台账表失败!") ;更新失败
	i RtnObj.success'=0 trollback  q RtnObj
	tcommit
	q RtnObj
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:取消审核
/// InPut：入库明细rowid,操作人id
/// Table:
/// OutPut:
/// Return:0,成功；
/// -1	 ;入库单id不能为空
/// -2   ;入库单尚未完成
ClassMethod GrCancelAudit(IngrId As %String) As %Library.String
{
	n (IngrId)
	s MethodName=$CLASSNAME()_".GrCancelAudit"
	s RtnObj=##class(RtnObj).%New()
	i ((IngrId="")||('$d(^DHCINGR(IngrId)))) d RtnObj.Err(-1,"","入库单不存在!","",0) q RtnObj.Json()
	s IngrId=+IngrId
	s Complete=$p(^DHCINGR(IngrId),"^",12)
	i Complete'="Y" d RtnObj.Err(-2,"","入库单尚未完成!","",0) q RtnObj.Json()
	s Audit=$p(^DHCINGR(IngrId),"^",29)
	i Audit'="Y" d RtnObj.Err(-3,"","入库单尚未审核!","",0) q RtnObj.Json()
	i ..IfMakeMon(IngrId)=1 d RtnObj.Err(-1,"","已经生成月报,不能撤销审核!","",0) q RtnObj.Json()
	i ..IfMakeInstk(IngrId)=1 d RtnObj.Err(-1,"","科室存在未调整完成盘点单,不能撤销审核!","",0) q RtnObj.Json()
	s ret=..sssLock("LOCKREC"_IngrId)  
	i ret'=0 d RtnObj.Err(-4,"","加锁失败!") q RtnObj.Json()
	;
	s Ch=0
	tstart
	s $ZT=..sssError()
	f  s Ch=$o(^DHCINGR(IngrId,"GRI",Ch)) q:(Ch="")!(RtnObj.success'=0)  d
	.s Ingri=IngrId_"||"_Ch
	.s Inclb=$p(^DHCINGR(IngrId,"GRI",Ch),"^",1)
	.q:Inclb=""
	.s Qty=$p(^DHCINGR(IngrId,"GRI",Ch),"^",4)
	.s Uom=$p(^DHCINGR(IngrId,"GRI",Ch),"^",10)
	.s Inci=+Inclb
	.s Buom=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,Buom)
	.s Qty=Qty*Fac
	.s LocDr=$p(^INCI(Inci,"IL",$p(Inclb,"||",2)),"^",1) 
	.q:LocDr=""
	.
	.i ..IfTransfer(Ingri)'=0 d RtnObj.Err(-5,"","已经转移制单,不能取消审核!","",0) q
	.i ..IfMadeRet(Ingri)'=0 d RtnObj.Err(-7,"","已经退货制单,不能取消审核!","",0) q
	.;i ..IfPay(Ingri)'=0 d RtnObj.Err(-8,"","已经付款,不能取消审核!","",0) q
	.i ..MadePay(Ingri)'=0 d RtnObj.Err(-9,"","已经生成付款单,不能取消审核!","",0) q
	.i ..IfBusinessByIngri(Ingri)'=0 d RtnObj.Err(-20,"","已经发生业务,不能取消审核!","",0) q
	.;处理高值批次信息
	.s dhcit=$o(^DHCITD(0,"Type","G","Pointer",Ingri,0))
	.i dhcit'=""  d
	..&sql(update DHC_ItmTrack set DHCIT_INCIB_DR=null,DHCIT_INCLB_DR=null where DHCIT_Rowid=:dhcit)
	..i SQLCODE'=0  d
	...d RtnObj.Err(-21,"","更新高值批次信息失败!")
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	.&sql(update dhc_ingdrecitm set ingri_inclb_dr=null where ingri_rowid=:Ingri)
	.i SQLCODE'=0  d
	..d RtnObj.Err(-10,"","更新入库子表批次信息失败!")
	.q:RtnObj.success'=0
	.;恢复库存数据
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("G",Ingri)
	.i Ret'=0 d RtnObj.Err(-11,"","恢复库存失败!") q
	.
	i RtnObj.success'=0 trollback  d ..sssUnLock("LOCKREC"_IngrId)
	i RtnObj.success'=0 q RtnObj.Json()    ;明细未处理ok 
	;
	&sql(update dhc_ingdrec set INGR_Completed=null,ingr_backup1=null,INGR_SSUSR_DR=null,INGR_Date=null,INGR_Time=null,INGR_AuditFlag=null where ingr_rowid=:IngrId)
	i SQLCODE trollback  d ..sssUnLock("LOCKREC"_IngrId)
	i SQLCODE d RtnObj.Err(-12,"","更新入库主表失败!") q RtnObj.Json()
	s RtnObj=##class(web.DHCSTMHUI.PurchaseInfo).SaveRecQty("G",IngrId,"Y")
	i RtnObj.success'=0 tro  q RtnObj.Err(-9,"","更新带量已采购量失败")
	tcommit
	d ..sssUnLock("LOCKREC"_IngrId)
	q RtnObj.Json()
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:判断该入库单是否已经生成月报
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,未生成；1,已生成
ClassMethod IfMakeMon(ingr As %String) As %Library.String
{
	;if loc have maked monreport
	n (ingr)
	q:ingr="" 0
	
	s loc=$p(^DHCINGR(ingr),"^",13)
	s date=$p(^DHCINGR(ingr),"^",4) ;审核日期
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_ToDate>=:date)
	q:'SQLCODE 1
	q 0
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:判断该入库明细对应的批次是否已经退货
/// InPut：入库明细表id
/// Table:
/// OutPut:
/// Return:0,未退货；1,已退货
ClassMethod IfRetToVen(ingri As %String) As %Library.String
{
	n (ingri)
	s tmpdr=$o(^DHCINTR(0,"TypePointer","G",ingri,""))
	q:tmpdr="" -1
	s inclb=$p(^DHCINTR(tmpdr),"^",7)
	s dah=$p(^DHCINTR(tmpdr),"^",2)
	s dth=$p(^DHCINTR(tmpdr),"^",3)
	s trdah="",ret=0
	f  s trdah=$o(^DHCINTR(0,"INCLB",inclb,trdah)) q:(trdah="")!(ret=1)  d
	.q:trdah<dah
	.s trid=""
	.f  s trid=$o(^DHCINTR(0,"INCLB",inclb,trdah,trid)) q:(trid="")!(ret=1)  d
	..q:($p(^DHCINTR(trid),"^",1)="G")&($p(^DHCINTR(trid),"^",9)=ingri)
	..q:(trdah=dah)&($p(^DHCINTR(trid),"^",3)'>dth)
	..i $p(^DHCINTR(trid),"^",1)="R"  d
	...s ret=1
	q ret
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:判断该入库明细对应的批次是否已经出库
/// InPut：入库明细表id
/// Table:
/// OutPut:
/// Return:0,未出库；1,已出库
ClassMethod IfTransfer(ingri As %String) As %Library.String
{
	n (ingri)
	s tmpdr=$o(^DHCINTR(0,"TypePointer","G",ingri,""))
	q:tmpdr="" -1
	s inclb=$p(^DHCINTR(tmpdr),"^",7)
	s dah=$p(^DHCINTR(tmpdr),"^",2)
	s dth=$p(^DHCINTR(tmpdr),"^",3)
	s Init=$o(^DHCINIT(0,"INGRI",ingri,""))	///存在依据入库单生成出库单未审核也不允许取消审核2021-01-26
	i +Init>0 -2
	s trdah="",ret=0
	f  s trdah=$o(^DHCINTR(0,"INCLB",inclb,trdah)) q:(trdah="")!(ret=1)  d
	.q:trdah<dah
	.s trid=""
	.f  s trid=$o(^DHCINTR(0,"INCLB",inclb,trdah,trid)) q:(trid="")!(ret=1)  d
	..q:($p(^DHCINTR(trid),"^",1)="G")&($p(^DHCINTR(trid),"^",9)=ingri)
	..q:(trdah=dah)&($p(^DHCINTR(trid),"^",3)<dth)
	..i $p(^DHCINTR(trid),"^",1)="T"  d
	...s ret=1
	q:ret=1 ret
	;根据入库明细ID判断是否有相应的出库单
	s initid=$o(^DHCINIT(0,"INGRI",ingri,""))
	i initid'="" s ret=1
	q ret
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:判断该入库明细是否已经付款
/// InPut：入库明细id
/// Table:
/// OutPut:
/// Return:0,未付款；1,已付款
ClassMethod IfPay(Ingri As %String) As %Library.String
{
	n (Ingri)
	q:Ingri="" 0
	s Ret=0
	s Pay=0
	f  s Pay=$o(^DHCPAY(0,"TYPEGR","G",Ingri,Pay)) q:(Pay="")!(Ret'=0)  d
	.s AckFlag=$p(^DHCPAY(Pay),"^",8)
	.i AckFlag="Y" s Ret=1  ;已经付款
	.
	q Ret
}

/// Creator:zhangxiao
/// CreatDate:2013-06-20
/// Description:判断该入库明细是否已经生成付款单
/// InPut：入库明细id
/// Table:
/// OutPut:
/// Return:1 已经生成付款单  0 未生成付款单
ClassMethod MadePay(Ingri As %String) As %Library.String
{
	n (Ingri)
	q:Ingri="" 0
	s Ret=0
	s Pay=$o(^DHCPAY(0,"GRI",Ingri,0))
	s:Pay'="" Ret=1  ;已经生成付款单
	
	q Ret
}

/// Creator:wangjiabin
/// CreatDate:2013-09-12
/// Description:判断某入库单中是否有明细已经付款制单
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,没有付款制单；1,有入库明细已经付款制单
ClassMethod IfExistMadePay(IngrId As %String) As %Library.String
{
	n (IngrId)
	q:IngrId="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(IngrId,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=IngrId_"||"_Chl
	.s Ret=..MadePay(Ingri)
	.
	q Ret
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:判断某入库单中是否有明细退货
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,未退货；1,有退货
ClassMethod IfReturn(IngrId As %String) As %Library.String
{
	n (IngrId)
	q:IngrId="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(IngrId,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=IngrId_"||"_Chl
	.s Ret=..IfRetToVen(Ingri)
	.
	q Ret
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:判断某入库单中是否有明细付款
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,未付款；1,有付款
ClassMethod IfExistPay(IngrId As %String) As %Library.String
{
	n (IngrId)
	q:IngrId="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(IngrId,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=IngrId_"||"_Chl
	.s Ret=..IfPay(Ingri)
	.
	q Ret
}

/// Creator:zx
/// CreatDate:2022-02-25
/// Description:判断入库单对应的批次是否和其他入库单中批次相同
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,,批次不存在于其他入库单；1,批次存在于其他入库单
ClassMethod IfExistIncib(IngrId As %String) As %Library.String
{
	n (IngrId)
	q:IngrId="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(IngrId,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=IngrId_"||"_Chl
	.s Ret=..checkIncib(Ingri)
	.
	q Ret
}

/// Creator:wangjiabin
/// CreatDate:2013-09-12
/// Description:判断某入库单中是否有明细已经加入退货单
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,未退货；1,有退货
ClassMethod IfExistMadeRet(IngrId As %String) As %Library.String
{
	n (IngrId)
	q:IngrId="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(IngrId,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=IngrId_"||"_Chl
	.s Ret=..IfMadeRet(Ingri)
	.
	q Ret
}

/// Creator:wangjiabin
/// CreatDate:2013-09-12
/// Description:判断入库明细是否已经加入退货单
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,否；1,是
ClassMethod IfMadeRet(Ingri As %String) As %Library.String
{
	n (Ingri)
	s ret=0
	s Ingrt=$o(^INGRT(0,"INGRI",Ingri,""))
	q:Ingrt'="" 1
	
	q ret
}

/// Creator:xuchao
/// CreatDate:2017-4-5
/// Description:判断入库明细批次是否存在于其他入库明细上
/// InPut：入库字表id
/// Table:
/// OutPut:
/// Return:0,不存在；1,存在
/// w ##class(web.DHCSTMHUI.DHCINGdRecMod).checkIncib("6||1")
ClassMethod checkIncib(Ingri As %String) As %Library.String
{
	n (Ingri)
	s ret=0
	s Incib=""
	&sql(SELECT INGRI_INCIB_DR INTO :Incib FROM DHC_INGdRecItm WHERE INGRI_RowId=:Ingri)
	q:Incib="" 0

	s Ingr=$p(Ingri,"||",1)
	s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Ingri)
	i HVBarCode'="" d
	.;高值,按单据判断
	.&sql(select INGRI_RowId FROM DHC_INGdRecItm WHERE INGRI_INCIB_DR=:Incib and INGRI_INGR_Parref!=:Ingr)
	e  d
	.&sql(select INGRI_RowId FROM DHC_INGdRecItm WHERE INGRI_INCIB_DR=:Incib and INGRI_RowId!=:Ingri)
	i SQLCODE=0  s ret=1
	q ret
}

/// Creator:
/// CreatDate:2021-07-06
/// Description:判断该入库明细对应的批次是否已经门诊发放
/// InPut：入库明细表id
/// Table:
/// OutPut:
/// Return:0,未门诊发放；1,已门诊发放
ClassMethod IfDHCDisp(ingri As %String) As %Library.String
{
	n (ingri)
	s tmpdr=$o(^DHCINTR(0,"TypePointer","G",ingri,""))
	q:tmpdr="" -1
	s inclb=$p(^DHCINTR(tmpdr),"^",7)
	s trdah="",ret=0
	f  s trdah=$o(^DHCINTR(0,"INCLB",inclb,trdah)) q:(trdah="")!(ret=1)  d
	.s trid=""
	.f  s trid=$o(^DHCINTR(0,"INCLB",inclb,trdah,trid)) q:(trid="")!(ret=1)  d
	..s:$p(^DHCINTR(trid),"^",1)="C" ret=1
	q ret
}

/// Description:判断该入库明细对应的批次是否已经发生业务
/// InPut：入库明细表id
/// Table:
/// OutPut:
/// Return:0：未方式业务；1：已发生业务
/// w ##class(web.DHCSTMHUI.DHCINGdRecMod).IfBusinessByIngri("70||1")
ClassMethod IfBusinessByIngri(ingri As %String) As %Library.String
{
	n (ingri)
	s Ingr=$p(ingri,"||",1)
	s IngrTrId=$o(^DHCINTR(0,"TypePointer","G",ingri,""))
	q:IngrTrId="" -1
	s inclb=$p(^DHCINTR(IngrTrId),"^",7)
	s IngrDate=$p(^DHCINTR(IngrTrId),"^",2)
	s IngrTime=$p(^DHCINTR(IngrTrId),"^",3)
	
	s ret=0
	s TransDate=IngrDate-1
	f  s TransDate=$o(^DHCINTR(0,"INCLB",inclb,TransDate)) q:(TransDate="")||(ret=1)  d
	.s TransId=""
	.f  s TransId=$o(^DHCINTR(0,"INCLB",inclb,TransDate,TransId)) q:(TransId="")||(ret=1)  d
	..q:TransId<=IngrTrId
	..
	..s IntrType=$p(^DHCINTR(TransId),"^",1)
	..s IntrTime=$p(^DHCINTR(TransId),"^",3)
	..s IntrPointer=$p(^DHCINTR(TransId),"^",9)
	..q:(IntrType="G")&&($p(IntrPointer,"||",1)=Ingr)
	..q:(TransDate=IngrDate)&&(IntrTime'>IngrTime)
	..s ret=1
	
	q ret
}

/// Creator:wxj
/// CreatDate:2022-7-29
/// Description:判断入库科室是否存在未调整完成的盘点单
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,不存在；1,存在
/// w ##class(web.DHCSTMHUI.DHCINGdRecMod).IfMakeInstk()
ClassMethod IfMakeInstk(Ingr As %String) As %Library.String
{
	n (Ingr)
	q:Ingr="" 0
	
	s RecLoc=$p(^DHCINGR(Ingr),"^",13)
	&sql(select INST_RowId from DHC_InStkTk where INST_CTLOC_DR=:RecLoc and nvl(INST_AdjustmentComplete,'')!='Y')
	q:'SQLCODE 1
	q 0
}

}
