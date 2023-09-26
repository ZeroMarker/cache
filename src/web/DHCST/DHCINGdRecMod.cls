Import sqluser

/// Descript:已审核后修改某些信息相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-07-19
Class web.DHCST.DHCINGdRecMod Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	已审核后更新入库信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-02-26
/// Table:DHC_InGdRecItm
/// Input:明细id^厂商id^批号^效期^随行单号^发票号^发票日期^发票金额^进价
/// Output:		
/// Return：0：成功
/// w ##class(web.DHCST.DHCINGdRecMod).UpdateRecInfo("7751||1^240^2016022529^2018-02-24^98654321^123456789877^^4920^40","142^102^590^2")
ClassMethod UpdateRecInfo(ListData As %String, StrParam) As %Library.String
{
	n (ListData,StrParam)
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s Len=$l(ListData,rowDelim)
	s Ret=0
	f i=1:1:Len  q:Ret'=0  d
	.s Data=$p(ListData,rowDelim,i)
	.s Rowid=$p(Data,"^",1)
	.s Chl=$p(Rowid,"||",2)
	.s ManfId=$p(Data,"^",2)
	.s BatNo=$p(Data,"^",3)
	.s ExpDate=$p(Data,"^",4)
	.s SxNo=$p(Data,"^",5)
	.s InvNo=$p(Data,"^",6)
	.s InvDate=$p(Data,"^",7)
	.s InvAmt=$p(Data,"^",8)
	.s Rp=$p(Data,"^",9)
	.s Ret=..GriUpdateInv(Rowid,InvNo,InvDate,InvAmt)
	.q:Ret'=0
	.s Ret=..GriUpdateSXD(Rowid,SxNo)
	.q:Ret'=0
	.s Ret=..GriUpdateBat(Rowid,BatNo,ExpDate)  //需控制
	.q:Ret'=0
	.s Ret=..GriUpdateManf(Rowid,ManfId)  //需控制
	.q:Ret'=0
	.s Ret=..GriUpdateRp(Rowid,Rp,StrParam)  //需控制
	.q:Ret'=0
	//更新业务数据重新插入HERP中间表  add by liangjiaquan 2018-11-27
	//s INGDr=+$g(Rowid)
	//i INGDr'=0&&(Ret=0)  d
	//.job ##class(web.DHCST.HERP).CancelData(INGDr,"G",StrParam) //删除HERP中间表 add by liangjiaquan 2018-11-27
	//.job ##class(web.DHCST.HERP).SendData(INGDr,"G",StrParam)   //插入HERP中间表 add by liangjiaquan 2018-11-27
	q Ret
}

/// Creator:zdm
/// CreatDate:2012-07-19
/// Description:更新入库供应商
/// InPut：入库主表rowid,供应商id
/// Table:dhc_ingdrec,DHC_IncItmBat
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GrUpdateVen(Ingr As %String, VendorId As %String) As %Library.String
{
	
	n (Ingr,VendorId)
	q:Ingr="" -1
	;q:VendorId="" -1
	s OldVenId=$p(^DHCINGR(Ingr),"^",3)
	q:VendorId=OldVenId 0   ;不需要更新
	s Ret=..IfExistMadeRet(Ingr)	;2013-09-12 IfReturn-->IfExistMadeRet
	q:Ret'=0 -11      ;该入库单已经发生退货，不能修改供应商
	s Ret=..IfExistMadePay(Ingr)	;2013-09-12 IfExistPay-->IfExistMadePay
	q:Ret'=0 -12      ;该入库单已经发生付款，不能修改供应商
	
	s Ret=..CheckBatRepeatByRec(Ingr)	
	q:(Ret '= "") -13_"^"_Ret      ;该入库单明细中有批次有历史入库记录
	;
	tstart
	s $ZT="Error^DHCSTERROR"
	s Err=0
	&sql(update dhc_ingdrec set INGR_APCVM_DR=:VendorId
	where ingr_Rowid=:Ingr)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("GrUpdateVen:dhc_ingdrec","dhcingr:"_Ingr,SQLCODE_":"_%msg)
	.s Err=-13  ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	;更新批次信息表中的供应商
	&sql(update DHC_IncItmBat set INCIB_APCVM_Dr=:VendorId
	where INCIB_INGRI_Dr->INGRI_INGR_ParRef=:Ingr)
	i (SQLCODE'=0)&(SQLCODE'=100)  d
	.s rett=$$ErrorRecord^DHCSTERROR("GrUpdateVen:DHC_IncItmBat","dhcingr:"_Ingr,SQLCODE_":"_%msg)
	.s Err=-14  ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	tcommit
	//job ##class(web.DHCST.HERP).SendData(Ingr,"G","")   //插入HERP中间表 add by liangjiaquan 2018-11-27
	q 0
}

/// Decription	: 判断入库的批次是否有历史批次
/// Output		: 空：无重复批次， 不为空:重复批次信息
/// Debugger    : w ##class(web.DHCST.DHCINGdRecMod).CheckBatRepeatByRec(178)
ClassMethod CheckBatRepeatByRec(ingrId As %String) As %String
{
	#dim result As %String = "" 
	
	s itm = 0
	for {
		s itm = $o(^DHCINGR(ingrId ,"GRI", itm))
		q:(itm = "")
		s ingriData = ^DHCINGR(ingrId ,"GRI", itm)
		s inclb = $p(ingriData, "^", 1)
		continue:(inclb = "")
		s inci = +inclb
		s incib = $p(^INCI(inci, "IL", $p(inclb, "||", 2), "LB", $p(inclb, "||", 3)), "^", 1)
		s tmpIngrId = 0
		for {
			s tmpIngrId = $o(^DHCINGR(0, "GRI_INCIB", incib, tmpIngrId))
			q:(tmpIngrId = "")
			continue:(ingrId = tmpIngrId)
			return $p(^INCI(inci, 1), "^", 2) _ "批次有历史入库记录"
		}
	}
	q result
}

/// Creator:zdm
/// CreatDate:2012-07-19
/// Description:更新入库明细对应的厂商
/// InPut：入库明细rowid,厂商id
/// Table:dhc_ingdrec,DHC_IncItmBat
/// OutPut:
/// Return:0,成功；
/// -1，失败
ClassMethod GriUpdateManf(Ingri As %String, ManfId As %String) As %Library.String
{
	
	n (Ingri,ManfId)
	q:Ingri="" -2
	;q:ManfId="" -2
	s OldManfId=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",29)
	q:ManfId=OldManfId 0      ;不需要更新
    q:..CheckInclbCanEdit(Ingri)'=0 -111 ;存在其他相同批次记录
	s Err=0
	tstart
	s $ZT="Error^DHCSTERROR"
	&sql(update dhc_ingdrecitm set initm_phmnf_dr=:ManfId
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("GriUpdateManf:dhc_ingdrecitm","dhcingri:"_Ingri,SQLCODE_":"_%msg)
	.s Err=-21  ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	;更新批次信息表中的厂商
	s Chl=$p(Ingri,"||",2)
	s Inclb=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",1)
	i Inclb'=""  d
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.&sql(update DHC_IncItmBat set INCIB_PHMNF_Dr=:ManfId
	 where INCIB_INCIB_Dr=:Incib)
	.i SQLCODE'=0  d
	..s rett=$$ErrorRecord^DHCSTERROR("GriUpdateManf:DHC_IncItmBat","dhcingr:"_Ingri,SQLCODE_":"_%msg)
	..s Err=-22  ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	tcommit
	q 0
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
	q:Ingri="" -3
	s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ExpDate)
	s OldBatNo=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",13)
	s OldExpDate=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",9)
	q:(BatNo=OldBatNo)&(ExpDate=OldExpDate) 0  ;不需要更新
    q:..CheckInclbCanEdit(Ingri)'=0 -111 ;存在其他相同批次记录
	s Err=0
	tstart
	s $ZT="Error^DHCSTERROR"
	&sql(update dhc_ingdrecitm set INGRI_ExpDate=:ExpDate,INGRI_BatchNo=:BatNo
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("GriUpdateBat:dhc_ingdrecitm","dhcingri:"_Ingri,SQLCODE_":"_%msg)
	.s Err=-32  ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	;更新批次信息表中的批号效期
	s Chl=$p(Ingri,"||",2)
	s Inclb=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",1)
	i Inclb'=""  d
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.&sql(update INC_ItmBat set INCIB_No=:BatNo,INCIB_ExpDate=:ExpDate
	 where INCIB_Rowid=:Incib)
	.i SQLCODE'=0  d
	..s rett=$$ErrorRecord^DHCSTERROR("GriUpdateBat:INC_ItmBat","incib:"_Incib,SQLCODE_":"_%msg)
	..s Err=-33  ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	tcommit
	q 0
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
	q:Ingri="" -4
	s OldSxNo=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",38)
	q:SxNo=OldSxNo 0  ;不需要更新
	;
	s Err=0
	;
	&sql(update dhc_ingdrecitm set initm_sxno=:SxNo
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("GriUpdateSXD:dhc_ingdrecitm","dhcingri:"_Ingri,SQLCODE_":"_%msg)
	.s Err=-41  ;更新失败
	q Err
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
	q:Ingri="" -5
	s:InvDate'="" InvDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InvDate)
	;
	s OldInvNo=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",27)
	s OldInvDate=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",34)
	s OldInvAmt=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",26)
	q:(InvNo=OldInvNo)&(InvDate=OldInvDate)&(InvAmt=OldInvAmt) 0 ;不需要更新
	s Ret=..IfPay(Ingri)
	q:Ret'=0 -52  ;已经付款，不能更新发票信息
	;
	s Err=0
	;
	ts
	&sql(update dhc_ingdrecitm set initm_invno=:InvNo,initm_invdate=:InvDate,initm_invmoney=:InvAmt
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("GriUpdateInv:dhc_ingdrecitm","dhcingri:"_Ingri,SQLCODE_":"_%msg)
	.s Err=-53  ;更新失败
	i Err'=0 tro
	q:Err'=0 Err
	s Err = ##Class(PHA.IN.InvNoManage.Save).SaveINGD(Ingri,"G")   //更新发票信息
	i Err'=0 tro
	q:Err'=0 Err
	b ;tc
	tc
	q Err
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:更新入库明细进价
/// InPut：入库明细rowid,进价
/// Table:dhc_ingdrecitm,DHC_IncItmBat
/// OutPut:
/// Return:0,成功；
/// -1，失败"7750||1!!40!!142^102^590^2"
/// w ##class(web.DHCST.DHCINGdRecMod).GriUpdateRp("7750||1",40,"142^102^590^2")
ClassMethod GriUpdateRp(Ingri As %String, Rp As %Numeric, StrParam As %String) As %Library.String
{
	
	n (Ingri,Rp,StrParam)
	//s ^yunhaibao("GriUpdateRp")=Ingri_"!!"_Rp_"!!"_StrParam
	q:Ingri="" -6
	q:+Rp=0 -6
	s CommonAppName=##class(web.DHCST.Common.AppCommon).%GetParameter("AppName")
    s RpRule=##class(web.DHCST.Common.AppCommon).GetAppPropValue(CommonAppName,"RpRule",StrParam)
	s LocId=$p(^DHCINGR(+Ingri),"^",13)
    s HospId=$p(^CTLOC(LocId),"^",22)
	s OldRp=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",30)
	s Uom=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",10)      ;uom 
	s Inclb=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",1)      ;uom 
	s CurRp=##class(web.DHCSTPRICE).GetRp(Inclb,+$h,Uom,HospId,"") //zhouyg 20141203
	q:RpRule=1 0   ;yunhaibao,20160225,入库进价不存在进价损益
	q:((RpRule=2)||(RpRule=3))&&(CurRp=Rp) 0
	s noasp=""
	i $d(^DHCRETA(0,"TypePointer","G",Ingri)) d
    .s retarowid=$o(^DHCRETA(0,"TypePointer","G",Ingri,""))
    .s rpdiff=$p($g(^DHCRETA(retarowid)),"^",11)
    .s newrpdiff=CurRp-Rp
    .i rpdiff=newrpdiff s noasp=1
    q:noasp=1 0
	q:..CheckInclbCanEdit(Ingri)'=0 -111 ;存在其他相同批次记录
	q:..IfTransfer(Ingri)'=0 -61  ;已经发生转移，不能修改
	q:..IfMakeMon(+Ingri)'=0 -62   ;已经生成月报，不能修改
	q:..IfRetToVen(Ingri)'=0 -63   ;已经退货，不能修改
	q:..IfPay(Ingri)'=0 -64   ;已经付款，不能修改 
	s Err=0
	tstart
	s $ZT="Error^DHCSTERROR"
	s Chl=$p(Ingri,"||",2)
	s Qty=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",4)
	s RecUom=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",10)
	s Inclb=$p(^DHCINGR(+Ingri,"GRI",Chl),"^",1)
	s BUom=$p(^INCI(+Inclb,1),"^",10)
	s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(RecUom,BUom)
	s BRp=Rp/Fac
	s RpAmt=Qty*Rp
	s LocId=$p(^DHCINGR(+Ingri),"^",13)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1)
	s BRp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,2)
	s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	&sql(update dhc_ingdrecitm set initm_realprice=:Rp,initm_realtotal=:RpAmt
	where ingri_Rowid=:Ingri)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("GriUpdateRp:dhc_ingdrecitm","dhcingri:"_Ingri,SQLCODE_":"_%msg)
	.s Err=-64 ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	;更新批次信息表中的进价
	i Inclb'=""  d
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.&sql(update DHC_IncItmBat set INCIB_Rp=:BRp,INCIB_RpPuruom=:Rp
	 where INCIB_INCIB_Dr=:Incib)
	.i SQLCODE'=0  d
	..s rett=$$ErrorRecord^DHCSTERROR("GriUpdateRp:DHC_IncItmBat","dhcingri:"_Ingri,SQLCODE_":"_%msg)
	..s Err=-65  ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err
	;更新台账进价
	&sql(update DHC_INTRANS set INTR_Rp=:Rp,INTR_RpAmount=:RpAmt where
	INTR_Type='G' AND INTR_Pointer=:Ingri)
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("GriUpdateRp:DHC_INTRANS","dhcingri:"_Ingri,SQLCODE_":"_%msg)
	.s Err=-66 ;更新失败
	i Err'=0 trollback
	q:Err'=0 Err	
	;更新业务损益
	s User=$p(StrParam,"^",3)
	s AspARet=##class(web.DHCST.DHCINGdRec).CreateImpAspA(Ingri,User,RpRule)
	i AspARet'=0 tro
	q:AspARet'=0 -67
	tcommit
	q 0
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
ClassMethod GrCancelAudit(Ingr As %String) As %Library.String
{
	n (Ingr)
	q:Ingr="" -1  ;入库单id不能为空
	s Ingr=+Ingr
 	s Complete=$p(^DHCINGR(Ingr),"^",12)
 	q:Complete'="Y" -2   ;入库单尚未完成
 	s Audit=$p(^DHCINGR(Ingr),"^",29)
 	q:Audit'="Y" -3  ;入库单尚未审核 
 	s HDCMIngdInd=$p(^DHCINGR(Ingr),"^",54)
 	q:HDCMIngdInd'="" -12
	;
 	q:..IfMakeMon(Ingr)=1 -4	;已经生成月报，不能撤销审核
 	s ret=##class(web.DHCST.Common.AppCommon).Lock("LOCKREC"_Ingr)  
	q:ret'=0 -100  ;加锁失败
	;
 	s Ret=0
 	s Ch=0
 	tstart
 	s $ZT="Error^DHCSTERROR"
	f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:(Ch="")!(Ret'=0)  d
	.s Ingri=Ingr_"||"_Ch
	.s Inclb=$p(^DHCINGR(Ingr,"GRI",Ch),"^",1)
	.s Qty=$p(^DHCINGR(Ingr,"GRI",Ch),"^",4)
	.s Uom=$p(^DHCINGR(Ingr,"GRI",Ch),"^",10)
	.s Inci=+Inclb
	.s Buom=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uom,Buom)
	.s Qty=Qty*Fac
	.s LocDr=$p(^INCI(Inci,"IL",$p(Inclb,"||",2)),"^",1) 
	.q:LocDr=""
	.q:Inclb=""
	.i ..IfTransfer(Ingri)'=0 s Ret=-7
	.q:Ret'=0		;已经转移, 不能取消审核
	.//i ..IfRetToVen(Ingri)'=0 s Ret=-8
	.//q:Ret'=0     ;已经退货，不能取消审核
	.i ..IfMadeRet(Ingri)'=0 s Ret=-8
	.q:Ret'=0     ;已经退货制单，不能取消审核
	.//i ..IfPay(Ingri)'=0  s Ret=-9
	.//q:Ret'=0   ;已经付款，不能取消审核
	.i ..MadePay(Ingri)'=0  s Ret=-9
	.q:Ret'=0   ;已经生成付款单，不能取消审核
	.
	.&sql(update dhc_ingdrecitm set ingri_inclb_dr=null where ingri_rowid=:Ingri)
	.i SQLCODE'=0  d
	..s rett=$$ErrorRecord^DHCSTERROR("CancelAudit:dhc_ingdrecitm","ingri:"_Ingri,SQLCODE_":"_%msg)
	..s Ret=-10
	.q:Ret'=0
	.;
	.;恢复库存数据
	.s Ret=##class(web.DHCST.Common.StockHandle).DelIntrs("G",Ingri)
	.i Ret'=0 s Ret=-11  q
	.;删除入库损益
	.i $d(^DHCRETA(0,"TypePointer","G",Ingri)) d
    ..s retarowid=$o(^DHCRETA(0,"TypePointer","G",Ingri,""))
    ..&SQL(delete from DHC_RetAspAmount where RETA_RowId=:retarowid)
	..i SQLCODE'=0 d
	...s rett=$$ErrorRecord^DHCSTERROR("CancelAudit:dhc_ingdrecitm","ingri:"_Ingri,SQLCODE_":"_%msg)
	...s Ret=-13
	.q:Ret'=0
	.s Ret = ##Class(PHA.IN.InvNoManage.Save).DeleteInvNoItm(Ingri,"G")  // 删除发票信息
	.q:Ret'=0
	i Ret'=0 trollback
	d:Ret'=0 ##class(web.DHCST.Common.AppCommon).UnLock("LOCKREC"_Ingr)
	q:Ret'=0 Ret   ;明细未处理ok 
	;
	&sql(update dhc_ingdrec set INGR_Completed=null,ingr_backup1=null,INGR_SSUSR_DR=null,INGR_Date=null,INGR_Time=null,INGR_AuditFlag=null where ingr_rowid=:Ingr)
	i SQLCODE trollback
	d:SQLCODE ##class(web.DHCST.Common.AppCommon).UnLock("LOCKREC"_Ingr)
	q:SQLCODE -12
	s Ret=##Class(PHA.IN.TmpDrugPurIngd.Save).CancleTDPIngdAudit(Ingr)
	i Ret'=0 tro
	q:Ret="HaveAuth" -101 //临购药品已经使用授权
    q:Ret'=0 -102  ;更新临购申请单状态失败
    
	tcommit
	;
	d ##class(web.DHCST.Common.AppCommon).UnLock("LOCKREC"_Ingr)
	//job ##class(web.DHCST.HERP).CancelData(Ingr,"G","") //删除HERP中间表 add by liangjiaquan 2018-11-27
	q 0
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
	 //q:$d(^DHCINIT(0,"INCLB",inclb)) 1 // 建单了就不行  2021-01-14 yangs 去掉
	 s dah=$p(^DHCINTR(tmpdr),"^",2)
	 s dth=$p(^DHCINTR(tmpdr),"^",3)
	 s trdah="",ret=0
	 f  s trdah=$o(^DHCINTR(0,"INCLB",inclb,trdah)) q:(trdah="")!(ret=1)  d
	 .q:trdah<dah
	 .s trid=""
	 .f  s trid=$o(^DHCINTR(0,"INCLB",inclb,trdah,trid)) q:(trid="")!(ret=1)  d
	 ..q:($p(^DHCINTR(trid),"^",1)="G")&($p(^DHCINTR(trid),"^",9)=ingri)
	 ..q:(trdah=dah)&($p(^DHCINTR(trid),"^",3)'>dth)
	 ..i $p(^DHCINTR(trid),"^",1)="T"  d
	 ...s ret=1
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
	s Ret = 0
	s Pay = 0
	f  s Pay = $o(^DHCPAY(0,"GRI",Ingri,Pay)) q:(Pay="")!(Ret'=0)  d
	.s Itm = $o(^DHCPAY(0,"GRI",Ingri,Pay,0))
	.s RecType = $p(^DHCPAY(Pay,"I",Itm),"^",9)
	.q:RecType'="G"
	.s AckFlag = $p(^DHCPAY(Pay),"^",8)
	.i AckFlag = "Y" s Ret=1  ;已经付款
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
ClassMethod IfExistMadePay(Ingr As %String) As %Library.String
{
	n (Ingr)
	q:Ingr="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(Ingr,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=Ingr_"||"_Chl
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
ClassMethod IfReturn(Ingr As %String) As %Library.String
{
	n (Ingr)
	q:Ingr="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(Ingr,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=Ingr_"||"_Chl
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
ClassMethod IfExistPay(Ingr As %String) As %Library.String
{
	n (Ingr)
	q:Ingr="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(Ingr,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=Ingr_"||"_Chl
	.s Ret=..IfPay(Ingri)
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
ClassMethod IfExistMadeRet(Ingr As %String) As %Library.String
{
	n (Ingr)
	q:Ingr="" 0
	s Ret=0
	s Chl=0
	f  s Chl=$o(^DHCINGR(Ingr,"GRI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Ingri=Ingr_"||"_Chl
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

/// creator:yunhaibao
/// creatdate:2015-11-24
/// description:已审核入库单修改中,如果对应批次有其他业务记录,则禁止修改批次相关信息
/// input:批次id,入库子表id
/// return:0 允许修改,其他不允许
/// others:批次信息除本次入库记录外,如有其他任何业务,则认为不允许修改
/// w ##class(web.DHCST.DHCINGdRecMod).CheckInclbCanEdit("7215||1")
ClassMethod CheckInclbCanEdit(ingdrecitm)
{
	n (ingdrecitm)
	q:+ingdrecitm=0 0
	q:'$d(^DHCINGR(+ingdrecitm,"GRI",$p(ingdrecitm,"||",2))) 0
	q:'$d(^DHCINTR(0,"TypePointer","G",ingdrecitm)) 0 //无台账记录
	s inclb=$p(^DHCINGR(+ingdrecitm,"GRI",$p(ingdrecitm,"||",2)),"^",1)
	q:'$d(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3))) 0
	s recintr=$o(^DHCINTR(0,"TypePointer","G",ingdrecitm,""),-1)
	s editflag=0
	//遍历台账表^DHCINTR(0,"INCLB",date,rowid)
	s checkdate=""
	f  s checkdate=$o(^DHCINTR(0,"INCLB",inclb,checkdate)) q:(checkdate="")||(editflag="-1")  d
	.s checkintr=""
	.f  s checkintr=$o(^DHCINTR(0,"INCLB",inclb,checkdate,checkintr)) q:(checkintr="")||(editflag="-1")  d
	..q:checkintr=recintr  //本次入库记录不许判断
	..s editflag="-111"
	q editflag
}

}
