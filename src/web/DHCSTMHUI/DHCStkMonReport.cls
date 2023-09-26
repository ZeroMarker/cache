Import sqluser

/// 进销存月报明细数据维护程序
/// 相关表;
///  DHC_StkMonReport
///  DHC_StkMonStat
///  DHC_StkMonStatIn
///  DHC_StkMonRepLcBt
///  
Class web.DHCSTMHUI.DHCStkMonReport Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 生成月报明细内容
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
/// Return:
///  0 -success
///  <0 -failure
ClassMethod CreateRepDetail(sm As %String) As RtnObj
{
	n (sm)
	
	s RtnObj=##class(RtnObj).%New()
	//取月报主信息
	s obj=##class(User.DHCStkMon).%OpenId(sm)
	s LocId=obj.DHCSMCTLOCDR.%Id()
	s FrDate=obj.DHCSMFromDate
	s ToDate=obj.DHCSMToDate
	s FrTime=obj.DHCSMFromTime
	s ToTime=obj.DHCSMToTime
	s Month=obj.DHCSMMonth
	s UserId=obj.DHCSMCreatedUserDR.%Id()
	s pId=..NewPid()
	s HospID=..sssHospId(LocId)	//取科室的医院
	
	//汇总并暂存业务数据到临时Global Start
	d KTmp
	s n=0,m=0
	s Types=##class(web.DHCSTMHUI.DHCStkMon).%GetParameter("TransTypeStr")
	f i=1:1:$l(Types,"^") d
	.s TrType=$p(Types,"^",i)
	.f Date=FrDate:1:ToDate d
	..s tr=0 
	..f  s tr=$o(^DHCINTR(0,"LOCTYPEDATE",LocId,TrType,Date,tr)) q:tr=""  d
	...s IntrTime=$p(^DHCINTR(tr),"^",3)
	...q:(Date=FrDate)&(FrTime'="")&(IntrTime<FrTime)
	...q:(Date=ToDate)&(ToTime'="")&(IntrTime>ToTime)
	...s Inclb=$p(^DHCINTR(tr),"^",7)
	...q:Inclb=""
	...s Inci=+Inclb,Incil=$p(Inclb,"||",1,2)
	...q:(Inci'>0)||('$d(^INCI(Inci,"IL",$p(Inclb,"||",2))))
	...
	...i '$d(InciInfoArr(Inci)) d
	....s StkgrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	....s Grptype=$p(StkgrpInfo,"^",3)
	....s ScgId=$p(StkgrpInfo,"^",5)
	....s InccatId=$p(^INCI(Inci,2),"^",2)
	....s InciInfoArr(Inci)=Grptype_"^"_ScgId_"^"_InccatId
	...e  d
	....s InciInfo=InciInfoArr(Inci)
	....s Grptype=$p(InciInfo,"^",1)
	....s ScgId=$p(InciInfo,"^",2)
	....s InccatId=$p(InciInfo,"^",3)
	...q:Grptype'=..sssCode()
	...
	...s Pointer=$p(^DHCINTR(tr),"^",9)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s Qty=$p(^DHCINTR(tr),"^",6)
	...s UomId=$p(^DHCINTR(tr),"^",10)
	...s Sp=$p($G(^DHCINTR(tr)),"^",14)
	...s SpAmt=$p($G(^DHCINTR(tr)),"^",8)
	...s Rp=$p($G(^DHCINTR(tr)),"^",16)
	...s RpAmt=$p($G(^DHCINTR(tr)),"^",17)
	...s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s Qty=Qty*Fac
	...s NewType=TrType
	...i NewType="A" d
	....s AdjId=+Pointer
	....s ReasonId=$p(^DHCINAD(AdjId),"^",6)
	....i ReasonId="" s NewType="AT"	//盘点损益
	...
	...s n=n+1
	...s ^TMPDHCMONSTAT(pId,LocId,NewType,Inci,n)=Qty_"^"_Sp_"^"_SpAmt_"^"_RpAmt_"^"_Inclb
	...s ^TMPDHCMONSTATLB(pId,NewType,Inclb,n)=Qty_"^"_Sp_"^"_SpAmt_"^"_Rp_"^"_RpAmt
	...s ^TMPDHCMONSTATFLAG(pId,Inci,Incil,Inclb)=""
	...
	...//准备插入DHC_StkMonTrans表的数据
	...i (NewType="T")||(NewType="K") d
	....//SMT_RelaLoc_DR: T记录toLoc, K记录frLoc
	....s RelaLocId=$s(NewType="T":$p(^DHCINIT(+Pointer),"^",6),NewType="K":$p(^DHCINIT(+Pointer),"^",5),1:"")
	....s ^TMPDHCTMPMONTRANS(pId,LocId,RelaLocId_"^"_InccatId,Inci,NewType,tr)=Qty_"^"_SpAmt_"^"_RpAmt
	....s SumType="TK"
	....i $d(^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType)) d
	.....s tkrpamt=+RpAmt+$p(^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType),"^",1)
	.....s tkspamt=+SpAmt+$p(^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType),"^",2)
	.....s ^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType)=tkrpamt_"^"_tkspamt
	....e  d
	.....s ^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType)=RpAmt_"^"_SpAmt
	...
	...i (NewType="G")||(NewType="R") d
	....//relaLoc:入库和退货用Vendor
	....s RelaLocId=$s(NewType="G":$p(^DHCINGR(+Pointer),"^",3),NewType="R":$p(^INGRT(+Pointer),"^",2))
	....s ^TMPDHCTMPMONTRANS(pId,LocId,RelaLocId_"^"_InccatId,Inci,NewType,tr)=Qty_"^"_SpAmt_"^"_RpAmt
	....s SumType="RG"
	....i $d(^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType)) d
	.....s rgrpamt=+RpAmt+$p(^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType),"^",1)
	.....s rgspamt=+SpAmt+$p(^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType),"^",2)
	.....s ^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType)=rgrpamt_"^"_rgspamt
	....e  d
	.....s ^TMPDHCTMPMONTRANSSUM(pId,LocId,RelaLocId,ScgId,InccatId,SumType)=RpAmt_"^"_SpAmt
	...
	//汇总台账并暂存业务数据到临时Global End
	
	s ret=..GetFinAmount(sm,pId)	//付款金额 ^TMPDHCTMPMONFINSTAT(pid,inci)

	s LastMon=""
	s LastMainRowid=$o(^DHCSM(0,"TypeLoc",..sssCode(),LocId,sm),-1)  //增加月报类型判断
	s:LastMainRowid'="" LastMon=$p(^DHCSM(LastMainRowid),"^",2)
	
	s n=0
	s Inci=""
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:(Inci="")!(RtnObj.success'=0)  d
	.s ch="",ch=$o(^INCI("IL_LOC",LocId,Inci,ch)) 
	.s Incil=Inci_"||"_ch
	.
	.;上期结存为0,且本期没有台帐的
	.s IncilLastFlag=..IsIncilLastMon(LastMainRowid,LastMon,Incil,sm)
	.q:(IncilLastFlag=0)&&('$d(^TMPDHCMONSTATFLAG(pId,Inci,Incil)))&&('$d(^TMPDHCTMPMONFINSTAT(pId,Inci)))
	.
	.s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgId=$p(stkgrpinfo,"^",5)
	.s ScgType=$p(stkgrpinfo,"^",3)
	.q:ScgType'=..sssCode()
	.s InccatId=$p(^INCI(Inci,2),"^",2)
	.
	.;汇总损益金额
	.s ret=..GetAspAmount(sm,pId,LocId,Inci)
	.
	.s lastamount=0,amount=0,lastcostamount=0,costamount=0
	.s recamount=0,retamount=0,transiamount=0,transoamount=0,dspamount=0
	.s adjamount=0,consumeamount=0,disposalamount=0,aspamt=0
	.s recrpamount=0,retrpamount=0,transirpamount=0,transorpamount=0,dsprpamount=0
	.s adjrpamount=0,consumerpamount=0,disposalrpamount=0,asprpamt=0
	.s TrAspRpamt=0,TrAspSpamt=0
	.
	.; 入库
	.s tmp=..GetTrans(pId,LocId,Inci,"G")
	.s recqty=$p(tmp,"^")
	.s recamount=$p(tmp,"^",2)
	.s recrpamount=$p(tmp,"^",3)
	.; 退货
	.s tmp=..GetTrans(pId,LocId,Inci,"R")
	.s retqty=$p(tmp,"^")
	.s retamount=$p(tmp,"^",2)
	.s retrpamount=$p(tmp,"^",3)
	.; 接收
	.s tmp=..GetTrans(pId,LocId,Inci,"K") 
	.s transiqty=$p(tmp,"^")
	.s transiamount=$p(tmp,"^",2)
	.s transirpamount=$p(tmp,"^",3)
	.; 出库
	.s tmp=..GetTrans(pId,LocId,Inci,"T")
	.s transoqty=$p(tmp,"^") 
	.s transoamount=$p(tmp,"^",2)
	.s transorpamount=$p(tmp,"^",3)
	.; 门诊发药（门诊发放）
	.s tmp=..GetTrans(pId,LocId,Inci,"MF")
	.s dspFqty=$p(tmp,"^")
	.s dspFamount=$p(tmp,"^",2)
	.s dspFrpamount=$p(tmp,"^",3)
	.; 住院发药
	.s tmp=..GetTrans(pId,LocId,Inci,"MP")
	.s dspPqty=$p(tmp,"^")
	.s dspPamount=$p(tmp,"^",2)
	.s dspPrpamount=$p(tmp,"^",3)
	.; 住院发放
	.s tmp=..GetTrans(pId,LocId,Inci,"MDP")
	.s dspMoPqty=$p(tmp,"^")
	.s dspMoPamount=$p(tmp,"^",2)
	.s dspMoPrpamount=$p(tmp,"^",3)
	.s dspPqty=dspPqty+dspMoPqty
	.s dspPamount=dspPamount+dspMoPamount
	.s dspPrpamount=dspPrpamount+dspMoPrpamount
	.; 调整
	.s tmp=..GetTrans(pId,LocId,Inci,"A")
	.s adjqty=$p(tmp,"^")
	.s adjamount=$p(tmp,"^",2)
	.s adjrpamount=$p(tmp,"^",3)
	.; 科室内发放
	.s tmp=..GetTrans(pId,LocId,Inci,"C")
	.s consumeqty=$p(tmp,"^")
	.s consumeamount=$p(tmp,"^",2)
	.s consumerpamount=$p(tmp,"^",3)
	.; 科室内退回,和C类型求代数和
	.s tmp=..GetTrans(pId,LocId,Inci,"L")
	.s Lqty=$p(tmp,"^")
	.s Lamount=$p(tmp,"^",2)
	.s Lrpamount=$p(tmp,"^",3)
	.s consumeqty=consumeqty+Lqty
	.s consumeamount=consumeamount+Lamount
	.s consumerpamount=consumerpamount+Lrpamount
	.; 库存报损
	.s tmp=..GetTrans(pId,LocId,Inci,"D")
	.s disposalqty=$p(tmp,"^")
	.s disposalamount=$p(tmp,"^",2)
	.s disposalrpamount=$p(tmp,"^",3)
	.; 门诊退药（门诊发放退回）
	.s tmp=..GetTrans(pId,LocId,Inci,"MH")
	.s pharetHqty=$p(tmp,"^")
	.s pharetHamount=$p(tmp,"^",2)
	.s pharetHrpamount=$p(tmp,"^",3)
	.; 住院退药
	.s tmp=..GetTrans(pId,LocId,Inci,"MY")
	.s pharetYqty=$p(tmp,"^")
	.s pharetYamount=$p(tmp,"^",2)
	.s pharetYrpamount=$p(tmp,"^",3)
	.; 住院发放退回
	.s tmp=..GetTrans(pId,LocId,Inci,"MDY")
	.s pharetMDYqty=$p(tmp,"^")
	.s pharetMDYamount=$p(tmp,"^",2)
	.s pharetMDYrpamount=$p(tmp,"^",3)
	.s pharetYqty=pharetYqty+pharetMDYqty
	.s pharetYamount=pharetYamount+pharetMDYamount
	.s pharetYrpamount=pharetYrpamount+pharetMDYrpamount
	.; 门诊特殊退药
	.s tmp=..GetTrans(pId,LocId,Inci,"Z")
	.s pharetZqty=$p(tmp,"^")
	.s pharetZamount=$p(tmp,"^",2)
	.s pharetZrpamount=$p(tmp,"^",3)
	.; 捐赠入库
	.s tmp=..GetTransGift(pId,LocId,Inci,"G")
	.s giftrecqty=$p(tmp,"^")
	.s giftrecamount=$p(tmp,"^",2)
	.s giftrecrpamount=$p(tmp,"^",3)
	.; 统计捐赠退货到入库
	.s tmp=..GetTransGift(pId,LocId,Inci,"R")
	.s giftrecqty=giftrecqty+$p(tmp,"^")
	.s giftrecamount=giftrecamount+$p(tmp,"^",2)
	.s giftrecrpamount=giftrecrpamount+$p(tmp,"^",3)
	.; 捐赠出库
	.s tmp=..GetTransGift(pId,LocId,Inci,"T")
	.s gifttrfqty=$p(tmp,"^")
	.s gifttrfamount=$p(tmp,"^",2)
	.s gifttrfrpamount=$p(tmp,"^",3)
	.; 统计捐赠退库到出库
	.s tmp=..GetTransGift(pId,LocId,Inci,"K")
	.s gifttrfqty=gifttrfqty+$p(tmp,"^")
	.s gifttrfamount=gifttrfamount+$p(tmp,"^",2)
	.s gifttrfrpamount=gifttrfrpamount+$p(tmp,"^",3)
	.; 调价换票入库
	.s tmp=..GetTransChg(pId,LocId,Inci,"G")
	.s chgcheckrecqty=$p(tmp,"^")
	.s chgcheckamount=$p(tmp,"^",2)
	.s chgcheckrpamount=$p(tmp,"^",3)
	.; 调价换票退货
	.s tmp=..GetTransChg(pId,LocId,Inci,"R")
	.s chgcheckretqty=$p(tmp,"^")
	.s chgcheckretamount=$p(tmp,"^",2)
	.s chgcheckretrpamount=$p(tmp,"^",3)
	.; 盘点
	.s ATAmtStr=..GetTrans(pId,LocId,Inci,"AT")
	.s ATQty=$p(ATAmtStr,"^",1)
	.s ATSpAmt=$p(ATAmtStr,"^",2)
	.s ATRpAmt=$p(ATAmtStr,"^",3)
	.; 调价损益
	.s aspamtStr=..GetAspByType(pId,LocId,Inci,"KC")
	.s aspamt=$p(aspamtStr,"^",2)
	.s asprpamt=$p(aspamtStr,"^",3)
	.; 台账损益
	.s TraAspaAmtStr=..GetAspByType(pId,LocId,Inci,"YW")
	.s TrAspQty=$p(TraAspaAmtStr,"^",1)
	.s TrAspSpamt=$p(TraAspaAmtStr,"^",2)
	.s TrAspRpamt=$p(TraAspaAmtStr,"^",3)
	.//住院退药损益
	.s YDAmtStr=..GetAspByType(pId,LocId,Inci,"MY")
	.s YDQty=$p(YDAmtStr,"^",1)
	.s YDSpAmt=$p(YDAmtStr,"^",2)
	.s YDRpAmt=$p(YDAmtStr,"^",3)
	.//门诊退药损益
	.s HDAmtStr=..GetAspByType(pId,LocId,Inci,"MH")
	.s HDQty=$p(HDAmtStr,"^",1)
	.s HDSpAmt=$p(HDAmtStr,"^",2)
	.s HDRpAmt=$p(HDAmtStr,"^",3)
	.//退货损益
	.s RDAmtStr=..GetAspByType(pId,LocId,Inci,"R")
	.s RDQty=$p(RDAmtStr,"^",1)
	.s RDSpAmt=$p(RDAmtStr,"^",2)
	.s RDRpAmt=$p(RDAmtStr,"^",3)
	.//入库损益(统一进价可能产生)
	.s GDAmtStr=..GetAspByType(pId,LocId,Inci,"G")
	.s GDQty=$p(GDAmtStr,"^",1)
	.s GDSpAmt=$p(GDAmtStr,"^",2)
	.s GDRpAmt=$p(GDAmtStr,"^",3)
	.//接收损益
	.s KDAmtStr=..GetAspByType(pId,LocId,Inci,"K")
	.s KDQty=$p(KDAmtStr,"^",1)
	.s KDSpAmt=$p(KDAmtStr,"^",2)
	.s KDRpAmt=$p(KDAmtStr,"^",3)
	.//上期 
	.s last=##class(web.DHCSTMHUI.DHCStkMon).GetLast(LastMainRowid,LastMon,Incil)
	.s lastqty=+$p($g(last),"^",1)
	.s lastamount=+$p($g(last),"^",2)
	.s lastcostamount=+$p($g(last),"^",3)
	.s lastfinamount=+$p($g(last),"^",4)	//上期未付款进价金额
	.//本期付款金额
	.s fininamount=+$g(^TMPDHCTMPMONFINSTAT(pId,Inci))
	.//本期未付款金额(上期未付款金额+入库金额-退货金额-本期付款金额, 这里均指绝对值)
	.s finamount=lastfinamount-fininamount+recrpamount+retrpamount
	.s finoutamount=transirpamount+transorpamount	//本期支出(出库-退库)
	.//本期金额
	.s BUomID=$p(^INCI(Inci,1),"^",10)
	.s AvailQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,LocId,ToDate)
	.s BUomSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,ToDate,BUomID,HospID)
	.;s amount=$g(availqty)*$g(bUomSp)
	.s amount=..GetSpAmt(Incil,ToDate,HospID)	;根据批次计算当前售价金额
	.s BUomRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,ToDate,BUomID,HospID)
	.;s rpamount=$g(availqty)*$g(bUomRp)  //当前进价计算
	.s rpamount=..GetRpAmt(Incil,ToDate,HospID)		;根据批次计算当前进价金额
	.
	.s dd=+$h
	.s child=$o(^DHCSM(sm,"R",""),-1)+1
	.&sql(Insert into dhc_stkmonreport(SMR_SM_Parref,SMR_Childsub,SMR_CTLOC_DR,SMR_INCI_DR,SMR_INCIL_DR,SMR_PhyQty,SMR_Date,SMR_MonthDate,SMR_SSUSR_DR,
	SMR_CostAmount,SMR_Amount,SMR_LastAmount,SMR_LastCostAmount,SMR_LastPhyQty,SMR_Remarks,SMR_INCSC_DR,SMR_SCG_DR)
	values(:sm,:child,:LocId,:Inci,:Incil,:AvailQty,:dd,:Month,:UserId,:rpamount,:amount,:lastamount,:lastcostamount,:lastqty,"",:InccatId,:ScgId))
	.i SQLCODE'=0 d RtnObj.Err(-21,"","月报明细保存失败！")
	.q:RtnObj.success'=0
	.s SMRDR=%ROWID
	.&sql(insert into dhc_stkmonstat(SMRD_SMR_DR,SMRD_Rec_Qty,SMRD_Rec_Amount,
	SMRD_Ret_Qty,SMRD_Ret_Amount,SMRD_Trfo_Qty,SMRD_Trfo_Amount,
	SMRD_TrfI_Qty,SMRD_TrfI_Amount,SMRD_DspP_Qty,SMRD_DspP_Amount,
	SMRD_DspF_Qty,SMRD_DspF_Amount,
	SMRD_Adj_Qty,SMRD_Adj_Amount,SMRD_Consume_Qty,SMRD_Consume_Amount,
	SMRD_Disposal_Qty,SMRD_Disposal_Amount,SMRD_Asp_Amount,
	SMRD_PhaRetY_Qty,SMRD_PhaRetY_Amount,SMRD_PhaRetH_Qty,
	SMRD_PhaRetH_Amount,SMRD_PhaRetZ_Qty,SMRD_PhaRetZ_Amount,
	SMRD_GiftRec_Qty,SMRD_GiftRec_Amount,SMRD_GiftTrf_Qty,SMRD_GiftTrf_Amount,
	SMRD_ChgCheckRec_Qty,SMRD_ChgCheckRec_Amount,SMRD_ChgCheckRet_Qty,
	SMRD_ChgCheckRet_Amount,SMRD_RetAsp_Amount,SMRD_PhaRetAsp_Amount,
	SMRD_StkTk_Qty,SMRD_StkTk_Amount,
	SMRD_PhoRetAsp_Amount,SMRD_TrfIAsp_Amount,
	SMRD_BG_Qty,SMRD_BG_Amount)
	values(:SMRDR,:recqty,:recamount,:retqty,:retamount,:transoqty,:transoamount,
	:transiqty,:transiamount,:dspPqty,:dspPamount,:dspFqty,:dspFamount,
	:adjqty,:adjamount,:consumeqty,:consumeamount,
	:disposalqty,:disposalamount,:aspamt,
	:pharetYqty,:pharetYamount,:pharetHqty,:pharetHamount,:pharetZqty,:pharetZamount,
	:giftrecqty,:giftrecamount,:gifttrfqty,:gifttrfamount,
	:chgcheckrecqty,:chgcheckamount,:chgcheckretqty,:chgcheckretamount,:RDSpAmt,:YDSpAmt,
	:ATQty,:ATSpAmt,:HDSpAmt,:KDSpAmt,
	:TrAspQty,:TrAspSpamt))
	.i SQLCODE'=0 d RtnObj.Err(-22,"","月报明细售价信息保存失败！"_Incil)
	.q:RtnObj.success'=0
	.&sql(insert into DHC_StkMonStatIn(
	SMRDI_SMR_DR,SMRDI_Rec_Qty,SMRDI_Rec_Amount,SMRDI_Ret_Qty,SMRDI_Ret_Amount,
	SMRDI_Trfo_Qty,SMRDI_Trfo_Amount,SMRDI_TrfI_Qty,SMRDI_TrfI_Amount,SMRDI_DspP_Qty,
	SMRDI_DspP_Amount,SMRDI_Adj_Qty,SMRDI_Adj_Amount,SMRDI_Consume_Qty,SMRDI_Consume_Amount,
	SMRDI_Disposal_Qty,SMRDI_Disposal_Amount,SMRDI_Asp_Amount,SMRDI_PhaRetY_Qty,SMRDI_PhaRetY_Amount,
	SMRDI_GiftRec_Qty,SMRDI_GiftRec_Amount,SMRDI_GiftTrf_Qty,SMRDI_GiftTrf_Amount,SMRDI_ChgCheckRec_Qty,
	SMRDI_ChgCheckRec_Amount,SMRDI_ChgCheckRet_Qty,SMRDI_ChgCheckRet_Amount,SMRDI_DspF_Qty,SMRDI_DspF_Amount,
	SMRDI_PhaRetH_Qty,SMRDI_PhaRetH_Amount,
	SMRDI_PhaRetZ_Qty,SMRDI_PhaRetZ_Amount,SMRDI_RecAsp_Amount,SMRDI_TrfIAsp_Amount,SMRDI_RetAsp_Amount,SMRDI_StkTk_Qty,
	SMRDI_StkTk_Amount,
	SMRDI_FinAmtLast,SMRDI_FinAmt,SMRDI_FinInAmt,SMRDI_FinOutAmt,
	SMRDI_BG_Qty,SMRDI_BG_Amount
	)values(
	:SMRDR,:recqty,:recrpamount,:retqty,:retrpamount,
	:transoqty,:transorpamount,:transiqty,:transirpamount,:dspPqty,
	:dspPrpamount,:adjqty,:adjrpamount,:consumeqty,:consumerpamount,
	:disposalqty,:disposalrpamount,:asprpamt,:pharetYqty,:pharetYrpamount,
	:giftrecqty,:giftrecrpamount,:gifttrfqty,:gifttrfrpamount,:chgcheckrecqty,
	:chgcheckrpamount,:chgcheckretqty,:chgcheckretrpamount,:dspFqty,:dspFrpamount,
	:pharetHqty,:pharetHrpamount,:pharetZqty,
	:pharetZrpamount,:GDRpAmt,:KDRpAmt,:RDRpAmt,:ATQty,
	:ATRpAmt,:lastfinamount,:finamount,:fininamount,:finoutamount,
	:TrAspQty,:TrAspRpamt))
	.i SQLCODE'=0 d RtnObj.Err(-23,"","月报明细进价信息保存失败！"_Incil)
	.q:RtnObj.success'=0
	.//组织汇总
	.s n=n+1
	.s CATSUMData=rpamount_"^"_lastcostamount_"^"_recrpamount_"^"_retrpamount_"^"_transorpamount
	.s CATSUMData=CATSUMData_"^"_transirpamount_"^"_adjrpamount_"^"_consumerpamount_"^"_disposalrpamount_"^"_asprpamt
	.s CATSUMData=CATSUMData_"^"_giftrecrpamount_"^"_gifttrfrpamount_"^"_chgcheckrpamount_"^"_chgcheckretrpamount_"^"_dspPrpamount
	.s CATSUMData=CATSUMData_"^"_pharetYrpamount_"^"_dspFrpamount_"^"_pharetHrpamount_"^"_pharetZrpamount
	.s CATSUMData=CATSUMData_"^"_ATRpAmt_"^"_GDRpAmt_"^"_RDRpAmt_"^"_KDRpAmt
	.s CATSUMData=CATSUMData_"^"_TrAspRpamt
	.s ^TMPDHCTMPMONCATSUM(pId,ScgId,InccatId,n)=CATSUMData
	.//生成批次月报记录;DHC_StkMonRepLcBt
	.s RtnObj=..SaveLBData(pId,SMRDR,Incil,LastMainRowid)	///生成批次月报
	.q:RtnObj.success'=0
	
	i RtnObj.success'=0 d
	.d KTmp
	q:RtnObj.success'=0 RtnObj
	//保存台账汇总和台账明细表（T，K，G，R）
	s RtnObj=..SaveTranData(sm,pId)
	i RtnObj.success'=0 d
	.d KTmp
	q:RtnObj.success'=0 RtnObj
	//保存按库存分类汇总的输出数据
	s RtnObj=..SaveCatSumData(sm,pId)
	
	d KTmp
	q RtnObj
	
KTmp
	k ^TMPDHCMONSTAT(pId)
	k ^TMPDHCMONSTATLB(pId)
	k ^TMPDHCTMPMONTRANS(pId)
	k ^TMPDHCTMPMONTRANSSUM(pId)
	k ^TMPDHCMONSTATFLAG(pId)
	k ^TMPDHCTMPMONCATSUM(pId)
	k ^TMPDHCTMPMONFINSTAT(pId)
	k ^TMPDHCTMPMONASP(pId)
	k ^TMPDHCTMPMONASPLB(pId)
	k InciInfoArr,IncilInfoArr
	q
}

/// 取某科室某品种某业务类型的发生数量、金额(比如赠品)
/// Date:2012-10-31
/// Argu:
///   pId - 临时Glboal数据识别ID
///   loc - 科室rowid
///  inci - 库存项目rowid
///  type -业务类型代码
/// Return:
///  数量^售价金额^进价金额
ClassMethod GetTrans(pId As %String, LocId As %String, Inci As %String, Type As %String) As %String
{
	n (pId,LocId,Inci,Type)
	s TotalQty=0,TotalSpAmt=0,TotalRpAmt=0
	s n=""
	f  s n=$o(^TMPDHCMONSTAT(pId,LocId,Type,Inci,n)) q:n=""  d
	.s data=^TMPDHCMONSTAT(pId,LocId,Type,Inci,n)
	.s inclb=$p(data,"^",5)
	.s result=..GetGiftChgFlag(inclb)
	.s giftrec=$p(result,"^",1),chgcheck=$p(result,"^",2)
	.i Type="G" q:(giftrec="Y")!(chgcheck="Y")
	.i Type="T" q:giftrec="Y"
	.i Type="R" q:(giftrec="Y")!(chgcheck="Y")
	.i Type="K" q:giftrec="Y"
	.s qty=$p(data,"^",1),TotalQty=TotalQty+qty
	.s sp=$p(data,"^",2) 
	.s spamt=$p(data,"^",3),TotalSpAmt=TotalSpAmt+spamt
	.s rpamt=$p(data,"^",4),TotalRpAmt=TotalRpAmt+rpamt
	q TotalQty_"^"_TotalSpAmt_"^"_TotalRpAmt
}

/// 取某科室某品种某业务类型的发生数量、金额(比如赠品)
/// Date:2012-10-31
/// Argu:
///  pId - 临时Glboal数据识别ID
///  loc - 科室rowid
///  inci - 库存项目rowid
///  type -业务类型代码
/// Return:
///  数量^售价金额^进价金额
ClassMethod GetTransChg(pId As %String, loc As %String, inci As %String, type As %String) As %String
{
	n (pId,loc,inci,type)
	s totalqty=0,totalspamt=0,totalrpamt=0
	s n=""
	f  s n=$o(^TMPDHCMONSTAT(pId,loc,type,inci,n)) q:n=""  d
	.s data=^TMPDHCMONSTAT(pId,loc,type,inci,n)
	.s inclb=$p(data,"^",5)
	.s result=..GetGiftChgFlag(inclb)
	.s giftrec=$p(result,"^",1),chgcheck=$p(result,"^",2)
	.q:chgcheck'="Y"
	.
	.s qty=$p(data,"^",1),totalqty=totalqty+qty
	.s amount=$p(data,"^",3),totalspamt=totalspamt+amount
	.s rpamt=$p(data,"^",4),totalrpamt=totalrpamt+rpamt
	q +totalqty_"^"_+totalspamt_"^"_+totalrpamt
}

/// 取某科室某品种某业务类型的发生数量、金额(比如赠品)
/// Date:2012-10-31
/// Argu:
///  pId - 临时Glboal数据识别ID 
///  loc - 科室rowid
///  inci - 库存项目rowid
///  type -业务类型代码
/// Return:
///  数量^售价金额^进价金额
ClassMethod GetTransGift(pId As %String, loc As %String, inci As %String, type As %String) As %String
{
	n (pId,loc,inci,type)
	s totalqty=0,totalspamt=0,totalrpamt=0
	s n=""
	f  s n=$o(^TMPDHCMONSTAT(pId,loc,type,inci,n)) q:n=""  d
	.s data=^TMPDHCMONSTAT(pId,loc,type,inci,n)
	.s inclb=$p(data,"^",5)
	.
	.s result=..GetGiftChgFlag(inclb)
	.s giftrec=$p(result,"^",1)
	.q:giftrec'="Y"
	.
	.s qty=$p(data,"^",1),totalqty=totalqty+qty
	.s spamt=$p(data,"^",3),totalspamt=totalspamt+spamt
	.s rpamt=$p(data,"^",4),totalrpamt=totalrpamt+rpamt
	q totalqty_"^"_totalspamt_"^"_totalrpamt
}

/// 根据批次查找其最后入库的属性(是否为调价换票?赠品入库?)
/// Date:2012-10-31
/// Argu:
/// inclb  - 库存批次rowid
/// Return:
///   调价换票入库标志^赠品入库标志
///   '="Y"的按N处理
ClassMethod GetGiftChgFlag(inclb As %String) As %String
{
	n (inclb)
	s giftrec="N",chgcheckrec="N"
	q:inclb="" giftrec_"^"_chgcheckrec
	
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" giftrec_"^"_chgcheckrec
	
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" giftrec_"^"_chgcheckrec
	
	s giftrec=$p(^DHCINCIB(dhcincib),"^",15)
	s:giftrec'="Y" giftrec="N"
	s chgcheckrec=$p(^DHCINCIB(dhcincib),"^",16)
	s:chgcheckrec'="Y" chgcheckrec="N"
	
	q giftrec_"^"_chgcheckrec
}

/// 取某批次某业务类型的月报汇总数据     
/// Author:zhwh
/// Date:2012-11-01
/// Argu:
///    Type - 业务类型
///    INCLB - 库存批次rowid
/// Return:
///  业务发生数量^售价金额^进价金额
ClassMethod GetLBTrans(pId As %String, Type As %String, INCLB As %String) As %String
{
	n (pId,Type,INCLB)
	s n=""
	s qty=0,amt=0,rpamt=0
	f  s n=$o(^TMPDHCMONSTATLB(pId,Type,INCLB,n)) q:n=""  d
	.s qty=qty+$p(^TMPDHCMONSTATLB(pId,Type,INCLB,n),"^",1)
	.s amt=amt+$p(^TMPDHCMONSTATLB(pId,Type,INCLB,n),"^",3)
	.s rpamt=rpamt+$p(^TMPDHCMONSTATLB(pId,Type,INCLB,n),"^",5)
	q qty_"^"_amt_"^"_rpamt
}

/// 本月库存结存数据
/// Author:zhwh
/// Date:2012-11-01
/// Argu:
///  INCLB  -批次rowid
///  sm - 月报住表rowid
/// Return:
///  字符串: 结存数量^结存售价金额^结存进价金额  
ClassMethod GetCurStk(INCLB As %String, sm As %String) As %String
{
	n (INCLB,sm)
	q:INCLB="" ""
	s INCI=+INCLB
	s todate=$p(^DHCSM(sm),"^",4)
	s loc=$P($G(^INCI(INCI,"IL",$P(INCLB,"||",2))),"^",1)
	S HospID=$P(^CTLOC(loc),"^",22)
	s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(INCLB,todate,"",HospID)  //基本单位的售价
	s qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(INCLB,todate,"")  //基本单位的数量
	s amt=qty*sp
	s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(INCLB,"",HospID)		//使用批次价格(之前为调价表价格)
	s ramt=qty*rp
	q qty_"^"_amt_"^"_ramt
}

/// 取某批次的上月月报的结存
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
///  LastSM -上月月报主表rowid
///  INCLB - 批次rowid
/// Return:
/// 字符串: 结存数量^结存售价金额^结存进价金额  
ClassMethod GetLastStk(INCLB As %String, LastSM As %String) As %String
{
	n (INCLB,LastSM)
	q:INCLB="" ""
	q:LastSM="" ""
	
	s SMRCH=$o(^DHCSM(0,"INCLB",INCLB,LastSM,""))
	q:SMRCH="" ""
	s LBCH=$o(^DHCSM(0,"INCLB",INCLB,LastSM,SMRCH,""))
	q:LBCH="" ""
	q:'$d(^DHCSM(LastSM,"R",SMRCH,"B",LBCH)) ""
	
	s qty=$p(^DHCSM(LastSM,"R",SMRCH,"B",LBCH,1),"^",3)
	s amt=$p(^DHCSM(LastSM,"R",SMRCH,"B",LBCH,1),"^",5)
	s coamt=$p(^DHCSM(LastSM,"R",SMRCH,"B",LBCH,1),"^",7)
	q qty_"^"_amt_"^"_coamt
}

/// 生成月报批次数据
/// Date:2012-11-01
/// Argu:
///   pId - 临时Glboal数据识别ID
///   SMR - 月报明细记录rowid
///   INCIL - 科室库存rowid
///   LastSM - 上月月报主表rowid
/// Return:
/// 	0 -success
/// 	<0  -失败
ClassMethod SaveLBData(pId As %String, SMR As %String, INCIL As %String, LastSM As %String) As RtnObj
{
	n (pId,SMR,INCIL,LastSM)
	s RtnObj=##class(RtnObj).%New()
	s INCI=+INCIL,CH=$p(INCIL,"||",2),LBCH=0
	f  s LBCH=$o(^INCI(INCI,"IL",CH,"LB",LBCH)) q:(LBCH="")!(RtnObj.success'=0)  d
	.s INCLB=INCI_"||"_CH_"||"_LBCH
	.s RtnObj=..InsertLBTrans(pId,SMR,INCLB,LastSM)
	.q:RtnObj.success'=0
	q RtnObj
}

/// 插入库存批次的"批次月报"记录
/// Author:zhwh
/// Date:2012-11-01
/// Argu:
///   pId - 临时Glboal数据识别ID
///  SMR - 月报子表rowid(DHC_StkMonReport)
///  INCLB  -批次rowid
///  LastSM - 上期月报主表rowid
/// Return:
///    <0 -failure
///    0  - success
ClassMethod InsertLBTrans(pId As %String, SMR As %String, INCLB As %String, LastSM As %String) As RtnObj
{
	n (pId,SMR,INCLB,LastSM)
	s RtnObj=##class(RtnObj).%New()
	s INCI=+INCLB,INCIL=$p(INCLB,"||",1,2)
	
	//上期结余
	s laststk=..GetLastStk(INCLB,LastSM)
	s lastqty=+$p(laststk,"^",1)
	s lastamt=+$p(laststk,"^",2)
	s lastcoamt=+$p(laststk,"^",3)
	;上期结存为0,且没有台帐数据的批次,过滤
	q:('$d(^TMPDHCMONSTATFLAG(pId,INCI,INCIL,INCLB)))&&((laststk'="")&&(lastqty=0) && (lastcoamt=0)) RtnObj
	
	//本期结余
	s currstk=..GetCurStk(INCLB,+SMR)
	s qty=$p(currstk,"^",1),amt=$p(currstk,"^",2),coamt=$p(currstk,"^",3)
	
	s rec=..GetLBTrans(pId,"G",INCLB)
	s transo=..GetLBTrans(pId,"T",INCLB)
	s transi=..GetLBTrans(pId,"K",INCLB)
	s ret=..GetLBTrans(pId,"R",INCLB)
	s adj=..GetLBTrans(pId,"A",INCLB)
	s stk=..GetLBTrans(pId,"AT",INCLB)
	s disp=..GetLBTrans(pId,"D",INCLB)
	s consume=..GetLBTrans(pId,"C",INCLB)
	s consumeL=..GetLBTrans(pId,"L",INCLB)		;L放在C上
	s dspP=..GetLBTrans(pId,"MP",INCLB)
	s dspF=..GetLBTrans(pId,"MF",INCLB)
	s dspS=..GetLBTrans(pId,"S",INCLB)
	s dspYret=..GetLBTrans(pId,"MY",INCLB)
	s dspHret=..GetLBTrans(pId,"MH",INCLB)
	s dspZret=..GetLBTrans(pId,"Z",INCLB)
	s recqty=+$p(rec,"^",1),recamt=+$p(rec,"^",2),reccoamt=+$p(rec,"^",3)
	s retqty=+$p(ret,"^",1),retamt=+$p(ret,"^",2),retcoamt=+$p(ret,"^",3)
	s transoqty=+$p(transo,"^",1),transoamt=+$p(transo,"^",2),transocoamt=+$p(transo,"^",3)
	s transiqty=+$p(transi,"^",1),transiamt=+$p(transi,"^",2),transicoamt=+$p(transi,"^",3)
	s adjqty=+$p(adj,"^",1),adjamt=+$p(adj,"^",2),adjcoamt=+$p(adj,"^",3)
	s dispqty=+$p(disp,"^",1),dispamt=+$p(disp,"^",2),dispcoamt=+$p(disp,"^",3)
	s consumeqty=+$p(consume,"^",1),consumeamt=+$p(consume,"^",2),consumecoamt=+$p(consume,"^",3)
	s Lqty=+$p(consumeL,"^",1),Lamt=+$p(consumeL,"^",2),Lcoamt=+$p(consumeL,"^",3)
	s consumeqty=consumeqty+Lqty,consumeamt=consumeamt+Lamt,consumecoamt=consumecoamt+Lcoamt
	s dspqty=+$p(dspP,"^",1)+$p(dspF,"^",1)+$p(dspS,"^",1),dspamt=+$p(dspP,"^",2)+$p(dspF,"^",2)+$p(dspS,"^",2),dspcoamt=+$p(dspP,"^",3)+$p(dspF,"^",3)+$p(dspS,"^",3)
	s dspretqty=+$p(dspYret,"^",1)+$p(dspHret,"^",1)+$p(dspZret,"^",1),dspretamt=+$p(dspYret,"^",2)+$p(dspHret,"^",2)+$p(dspZret,"^",2),dspretcoamt=+$p(dspYret,"^",3)+$p(dspHret,"^",3)+$p(dspZret,"^",3)
	s stkqty=+$p(stk,"^",1),stkamt=+$p(stk,"^",2),stkcoamt=+$p(stk,"^",3)
	
	; 调价损益
	s aspamtStr=..GetLBAspByType(pId,"KC",INCLB)
	s aspamt=$p(aspamtStr,"^",2)
	s aspcoamt=$p(aspamtStr,"^",3)
	; 台账损益
	s TraAspaAmtStr=..GetLBAspByType(pId,"YW",INCLB)
	s TrAspQty=$p(TraAspaAmtStr,"^",1)
	s TrAspSpamt=$p(TraAspaAmtStr,"^",2)
	s TrAspRpamt=$p(TraAspaAmtStr,"^",3)
	//住院退药损益
	s YDAmtStr=..GetLBAspByType(pId,"MY",INCLB)
	s YDQty=$p(YDAmtStr,"^",1)
	s YDSpAmt=$p(YDAmtStr,"^",2)
	s YDRpAmt=$p(YDAmtStr,"^",3)
	//门诊退药损益
	s HDAmtStr=..GetLBAspByType(pId,"MH",INCLB)
	s HDQty=$p(HDAmtStr,"^",1)
	s HDSpAmt=$p(HDAmtStr,"^",2)
	s HDRpAmt=$p(HDAmtStr,"^",3)
	//退货损益
	s RDAmtStr=..GetLBAspByType(pId,"R",INCLB)
	s RDQty=$p(RDAmtStr,"^",1)
	s RDSpAmt=$p(RDAmtStr,"^",2)
	s RDRpAmt=$p(RDAmtStr,"^",3)
	//入库损益(统一进价可能产生)
	s GDAmtStr=..GetLBAspByType(pId,"G",INCLB)
	s GDQty=$p(GDAmtStr,"^",1)
	s GDSpAmt=$p(GDAmtStr,"^",2)
	s GDRpAmt=$p(GDAmtStr,"^",3)
	//接收损益
	s KDAmtStr=..GetLBAspByType(pId,"K",INCLB)
	s KDQty=$p(KDAmtStr,"^",1)
	s KDSpAmt=$p(KDAmtStr,"^",2)
	s KDRpAmt=$p(KDAmtStr,"^",3)
	
	s lbch=$o(^DHCSM($P(SMR,"||",1),"R",$P(SMR,"||",2),"B",""),-1)+1
	&sql(insert into DHC_StkMonRepLcBt(SMRLB_SMR_Parref,SMRLB_Childsub,SMRLB_INCLB_DR,
		SMRLB_Qty,SMRLB_LastQty,SMRLB_Amount,SMRLB_CostAmount,SMRLB_LastAmount,SMRLB_LastCostAmount,
		SMRLB_Rec_Qty,SMRLB_Rec_Amt,SMRLB_Rec_CoAmt,
		SMRLB_Ret_Qty,SMRLB_Ret_Amt,SMRLB_Ret_CoAmt,
		SMRLB_Trfo_Qty,SMRLB_Trfo_Amt,SMRLB_Trfo_CoAmt,
		SMRLB_TrfI_Qty,SMRLB_TrfI_Amt,SMRLB_TrfI_CoAmt,
		SMRLB_Adj_Qty,SMRLB_Adj_Amt,SMRLB_Adj_CoAmt,
		SMRLB_Cons_Qty,SMRLB_Cons_Amt,SMRLB_Cons_CoAmt,
		SMRLB_Disp_Qty,SMRLB_Disp_Amt,SMRLB_Disp_CoAmt,
		SMRLB_Dsp_Qty,SMRLB_Dsp_Amt,SMRLB_Dsp_CoAmt,
		SMRLB_PhaRet_Qty,SMRLB_PhaRet_Amt,SMRLB_PhaRet_CoAmt,
		SMRLB_Asp_Amt,SMRLB_Asp_CoAmt,
		SMRLB_StkTk_Qty,SMRLB_StkTk_Amt,SMRLB_StkTk_CoAmt,
		SMRLB_BG_Amt,SMRLB_BG_CoAmt,SMRLB_PhaRetAsp_Amt,SMRLB_PhaRetAsp_CoAmt,
		SMRLB_PhoRetAsp_Amt,SMRLB_PhoRetAsp_CoAmt,SMRLB_RetAsp_Amt,SMRLB_RetAsp_CoAmt,
		SMRLB_RecAsp_Amt,SMRLB_RecAsp_CoAmt,SMRLB_TrfIAsp_Amt,SMRLB_TrfIAsp_CoAmt
		)
	values (:SMR,:lbch,:INCLB,:qty,:lastqty,
		:amt,:coamt,:lastamt,:lastcoamt,
		:recqty,:recamt,:reccoamt,
		:retqty,:retamt,:retcoamt,
		:transoqty,:transoamt,:transocoamt,
		:transiqty,:transiamt,:transicoamt,
		:adjqty,:adjamt,:adjcoamt,
		:consumeqty,:consumeamt,:consumecoamt,
		:dispqty,:dispamt,:dispcoamt,
		:dspqty,:dspamt,:dspcoamt,
		:dspretqty,:dspretamt,:dspretcoamt,
		:aspamt,:aspcoamt,
		:stkqty,:stkamt,:stkcoamt,
		:TrAspSpamt,:TrAspRpamt,:YDSpAmt,:YDRpAmt,
		:HDSpAmt,:HDRpAmt,:RDSpAmt,:RDRpAmt,
		:GDSpAmt,:GDRpAmt,:KDSpAmt,:KDRpAmt)
	)
	i SQLCODE<0  d RtnObj.Err(-31,"","生成批次月报失败！"_INCLB)
	q RtnObj
}

/// 获取月报时间段内的付款金额
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
/// sm - 月报rowid, incil
/// Return: 入库单付款审批金额^退货单付款审批金额(负值)
ClassMethod GetFinAmount(sm, pid) As %String
{
	n (sm,pid)
	s obj=##class(User.DHCStkMon).%OpenId(sm)
	i $ISOBJECT(obj)  d obj.%Reload()
	//取月报主信息
	s loc=obj.DHCSMCTLOCDR.%Id()
	s frdate=obj.DHCSMFromDate
	s todate=obj.DHCSMToDate
	s frtime=obj.DHCSMFromTime
	s totime=obj.DHCSMToTime
	//入库
	f dat=frdate:1:todate d
	.s ingr=0
	.f  s ingr=$o(^DHCINGR(0,"INVSETDATE",dat,ingr)) q:ingr=""  d
	..s ingrloc=$P(^DHCINGR(ingr),"^",13)
	..q:loc'=ingrloc
	..s ch=0
	..f  s ch=$o(^DHCINGR(0,"INVSETDATE",dat,ingr,ch)) q:ch=""  d
	...s inclb=$p(^DHCINGR(ingr,"GRI",ch),"^",1)
	...s inci=+inclb
	...s rpAmt=$p(^DHCINGR(ingr,"GRI",ch),"^",31)
	...i $D(^TMPDHCTMPMONFINSTAT(pid,inci)) d
	....s ^TMPDHCTMPMONFINSTAT(pid,inci)=^TMPDHCTMPMONFINSTAT(pid,inci)+rpAmt
	...e  d
	....s ^TMPDHCTMPMONFINSTAT(pid,inci)=rpAmt
	//退货单
	f dat=frdate:1:todate d
	.s ingrt=0
	.f  s ingrt=$o(^INGRT(0,"InvSetDate",dat,ingrt)) q:ingrt=""  d
	..s ingrtloc=$P(^INGRT(ingrt),"^",7)
	..q:loc'=ingrtloc
	..s ch=0
	..f  s ch=$o(^INGRT(0,"InvSetDate",dat,ingrt,ch)) q:ch=""  d
	...s inclb=$p(^INGRT(ingrt,"DHCGRR",ch),"^",6)
	...s inci=+inclb
	...s rpAmt=-$p(^INGRT(ingrt,"DHCGRR",ch),"^",4)		//使用负值
	...i $D(^TMPDHCTMPMONFINSTAT(pid,inci)) d
	....s ^TMPDHCTMPMONFINSTAT(pid,inci)=^TMPDHCTMPMONFINSTAT(pid,inci)+rpAmt
	...e  d
	....s ^TMPDHCTMPMONFINSTAT(pid,inci)=rpAmt	
	q 0
}

/// 获取月报时间段内的损益金额
/// Creator：lxt
/// CreatorDate：20220427
/// sm，pid，locid，inci
/// 各项损益进价、售价损益(KC--调价损益,YW--台账损益：各业务损益台账类型+D)
ClassMethod GetAspAmount(SM, Pid, LocId, Inci) As %String
{
	n (SM,Pid,LocId,Inci)
	s Obj=##class(User.DHCStkMon).%OpenId(SM)
	q:'$ISOBJECT(Obj) 0
	d Obj.%Reload()
	//取月报主信息
	s FrDate=Obj.DHCSMFromDate
	s ToDate=Obj.DHCSMToDate
	s FrTime=Obj.DHCSMFromTime
	s ToTime=Obj.DHCSMToTime
	
	f AspDate=FrDate:1:ToDate d
	.s AspId=0
	.f  s AspId=$o(^ASPA(0,"DATEINCIL",AspDate,Inci,LocId,AspId)) q:AspId=""  d
	..s AspInfo=^ASPA(AspId)
	..s SpAmt=+$p(AspInfo,"^",5)
	..s RpAmt=+$p(AspInfo,"^",12)
	..s AspTime=$p(AspInfo,"^",9)
	..s Type=$p(AspInfo,"^",17)
	..s Trans=$p(AspInfo,"^",18)
	..s Qty=+$p(AspInfo,"^",4)
	..q:(AspDate=FrDate)&(FrTime'="")&(AspTime<FrTime)
	..q:(AspDate=FrDate)&(ToTime'="")&(AspTime>ToTime)
	..q:Type=""
	..s TransType=""
	..i Type="YW" d
	...s TransType=$p($g(^DHCINTR(Trans)),"^",1)
	...q:TransType=""
	...i TransType="A" d
	....s AdjId=+Trans
	....s ReasonId=$p(^DHCINAD(AdjId),"^",6)
	....i ReasonId="" s TransType="AT"	//盘点损益
	..
	..i $d(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type)) d
	...s $p(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type),"^",1)=$p(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type),"^",1)+Qty
	...s $p(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type),"^",2)=$p(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type),"^",2)+SpAmt
	...s $p(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type),"^",3)=$p(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type),"^",3)+RpAmt
	..e  d
	...s ^TMPDHCTMPMONASP(Pid,LocId,Inci,Type)=Qty_"^"_SpAmt_"^"_RpAmt
	..
	..i TransType'="" d
	...i $d(^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType)) d
	....s $p(^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType),"^",1)=$p(^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType),"^",1)+Qty
	....s $p(^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType),"^",2)=$p(^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType),"^",2)+SpAmt
	....s $p(^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType),"^",3)=$p(^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType),"^",3)+RpAmt
	...e  d
	....s ^TMPDHCTMPMONASP(Pid,LocId,Inci,TransType)=Qty_"^"_SpAmt_"^"_RpAmt
	..s AspCh=0
	..f  s AspCh=$o(^ASPA(AspId,"LB",AspCh)) q:AspCh=""  d
	...s AspLBInfo=^ASPA(AspId,"LB",AspCh)
	...s Inclb=$p(AspLBInfo,"^",1)
	...s InclbQty=$p(AspLBInfo,"^",2)
	...s InclbSpAmt=$p(AspLBInfo,"^",4)
	...s InclbRpAmt=$p(AspLBInfo,"^",6)
	...i $d(^TMPDHCTMPMONASPLB(Pid,Type,Inclb)) d
	....s $p(^TMPDHCTMPMONASPLB(Pid,Type,Inclb),"^",1)=$p(^TMPDHCTMPMONASPLB(Pid,Type,Inclb),"^",1)+InclbQty
	....s $p(^TMPDHCTMPMONASPLB(Pid,Type,Inclb),"^",2)=$p(^TMPDHCTMPMONASPLB(Pid,Type,Inclb),"^",2)+InclbSpAmt
	....s $p(^TMPDHCTMPMONASPLB(Pid,Type,Inclb),"^",3)=$p(^TMPDHCTMPMONASPLB(Pid,Type,Inclb),"^",3)+InclbRpAmt
	...e  d
	....s ^TMPDHCTMPMONASPLB(Pid,Type,Inclb)=InclbQty_"^"_InclbSpAmt_"^"_InclbRpAmt
	...i TransType'="" d
	....i $d(^TMPDHCTMPMONASPLB(Pid,TransType,Inclb)) d
	.....s $p(^TMPDHCTMPMONASPLB(Pid,TransType,Inclb),"^",1)=$p(^TMPDHCTMPMONASPLB(Pid,TransType,Inclb),"^",1)+InclbQty
	.....s $p(^TMPDHCTMPMONASPLB(Pid,TransType,Inclb),"^",2)=$p(^TMPDHCTMPMONASPLB(Pid,TransType,Inclb),"^",2)+InclbSpAmt
	.....s $p(^TMPDHCTMPMONASPLB(Pid,TransType,Inclb),"^",3)=$p(^TMPDHCTMPMONASPLB(Pid,TransType,Inclb),"^",3)+InclbRpAmt
	....e  d
	.....s ^TMPDHCTMPMONASPLB(Pid,TransType,Inclb)=InclbQty_"^"_InclbSpAmt_"^"_InclbRpAmt
	q 0
}

/// 取某科室某品种一段日期范围内的调价损益金额
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  loc as %String ,inci as %String,frdate,todate
/// Return:
/// 调价损益进价金额^调价损益售价金额
ClassMethod GetAspByType(Pid As %String, LocId As %String, Inci As %String, Type As %String) As %String
{
	n (Pid,LocId,Inci,Type)
	
	s AspInfo=$g(^TMPDHCTMPMONASP(Pid,LocId,Inci,Type))
	s Qty=+$p(AspInfo,"^",1)
	s SpAmt=+$p(AspInfo,"^",2)
	s RpAmt=+$p(AspInfo,"^",3)
	
	q Qty_"^"_SpAmt_"^"_RpAmt
}

/// 取某科室某品种一段日期范围内的调价损益金额
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  loc as %String ,inci as %String,frdate,todate
/// Return:
/// 调价损益进价金额^调价损益售价金额
/// w ##class(web.DHCSTMHUI.DHCStkMonReport).GetLBAspByType("1","1","1")
ClassMethod GetLBAspByType(Pid As %String, Type As %String, Inclb As %String) As %String
{
	n (Pid,Type,Inclb)
	
	s AspInfo=$g(^TMPDHCTMPMONASPLB(Pid,Type,Inclb))
	s Qty=+$p(AspInfo,"^",1)
	s SpAmt=+$p(AspInfo,"^",2)
	s RpAmt=+$p(AspInfo,"^",3)
	
	q Qty_"^"_SpAmt_"^"_RpAmt
}

/// 获取批次进价金额
ClassMethod GetRpAmt(incil, dtend, hospid) As %String
{
	n (incil,dtend,hospid)
	s inci=$p(incil,"||",1)
	s il=$p(incil,"||",2)
	
	s sumamt=0
	s lb=0
	f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
	.s inclb=incil_"||"_lb
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,dtend)
	.s buom=$p(^INCI(inci,1),"^",10)
	.s rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buom,hospid,"",dtend)
	.s rpamt=rp*qty
	.s sumamt=sumamt+rpamt
	q sumamt
}

/// 获取批次售价金额
ClassMethod GetSpAmt(incil, dtend, hospid) As %String
{
	n (incil,dtend,hospid)
	s inci=$p(incil,"||",1)
	s il=$p(incil,"||",2)
	
	s sumamt=0
	s lb=0
	f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
	.s inclb=incil_"||"_lb
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,dtend)
	.s buom=$p(^INCI(inci,1),"^",10)
	.s sp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inclb,dtend,buom,hospid)
	.s spamt=sp*qty
	.s sumamt=sumamt+spamt
	.
	q sumamt
}

/// 保存月报台帐表的数据
/// Author:wyx 
/// Date:2014-02-18
/// 
ClassMethod SaveTranData(sm, pid) As RtnObj
{
	n (sm,pid)
	s loc=$p(^DHCSM(sm),"^",1)
	s RtnObj=##class(RtnObj).%New()
	s relaLoc=""
	f  s relaLoc=$o(^TMPDHCTMPMONTRANSSUM(pid,loc,relaLoc)) q:(relaLoc="")||(RtnObj.success<0)  d
	.s scg="" 
	.f  s scg=$o(^TMPDHCTMPMONTRANSSUM(pid,loc,relaLoc,scg)) q:(scg="")||(RtnObj.success<0)  d
	..s cat="" 
	..f  s cat=$o(^TMPDHCTMPMONTRANSSUM(pid,loc,relaLoc,scg,cat)) q:(cat="")||(RtnObj.success<0)  d
	...s type=""
	...f  s type=$o(^TMPDHCTMPMONTRANSSUM(pid,loc,relaLoc,scg,cat,type)) q:(type="")||(RtnObj.success<0)  d
	....q:(type'="TK")&&(type'="RG")
	....s tkRpAmt=$p(^TMPDHCTMPMONTRANSSUM(pid,loc,relaLoc,scg,cat,type),"^",1)
	....s tkSpAmt=$p(^TMPDHCTMPMONTRANSSUM(pid,loc,relaLoc,scg,cat,type),"^",2)
	....;relaLoc(TK:业务科室, RG:供应商)
	....i type="TK" s RelaLocDr=relaLoc,RelaOrg=""
	....i type="RG" s RelaLocDr=loc,RelaOrg=relaLoc
	....&sql(Insert DHC_StkMonSum_TransLoc
		(SUMTL_SM_DR,SUMTL_Type,SUMTL_RelaLoc_DR,SUMTL_StkCat_DR,SUMTL_SCG_DR,
		SUMTL_RpAmt,SUMTL_SpAmt,SUMTL_RelaOrg)
		values
		(:sm,:type,:RelaLocDr,:cat,:scg,:tkRpAmt,:tkSpAmt,:RelaOrg))
	....i SQLCODE'=0 d RtnObj.Err(-41,"","月报台账汇总表保存失败！")
	....s sumtlRowId=%ROWID
	....s RtnObj=..CreatTranData(sm,loc,scg,cat,pid,sumtlRowId,relaLoc,type)
	q RtnObj
}

/// relaLoc参数(type=TK时传入业务科室id, type=RG时传入供应商id)
ClassMethod CreatTranData(sm, loc, scg, cat, pid, sumtlRowId, relaLoc, type) As RtnObj
{
	n (sm,loc,scg,cat,pid,sumtlRowId,relaLoc,type)
	s RtnObj=##class(RtnObj).%New()
	s relaLocCat=relaLoc_"^"_cat
	s len=$l(type)
	s inci="" 
	f  s inci=$o(^TMPDHCTMPMONTRANS(pid,loc,relaLocCat,inci)) q:inci=""  d
	.f i=1:1:len  d
	..s newtype=$e(type,i)
	..s tr=0
	..f  s tr=$o(^TMPDHCTMPMONTRANS(pid,loc,relaLocCat,inci,newtype,tr))  q:(tr="")!(RtnObj.success'=0)  d
	...s tmpstr=^TMPDHCTMPMONTRANS(pid,loc,relaLocCat,inci,newtype,tr)
	...s qty=$p(tmpstr,"^",1)
	...s spamt=$p(tmpstr,"^",2)
	...s rpamt=$p(tmpstr,"^",3)
	...s pointer=$p(^DHCINTR(tr),"^",9)
	...s (slg,operateType,RelaLocDr,RelaOrg)=""
	...i ((newtype="T")||(newtype="K")) d
	....&sql(select DHCLoc_SLG_Dr into :slg from dhcst_ctloc where DHCLoc_Ctloc_dr=:relaLoc)
	....s operateType=$p(^DHCINIT($p(pointer,"||",1)),"^",20)	;记录出库类型
	....s RelaLocDr=relaLoc,RelaOrg=""
	...e  i ((newtype="G")||(newtype="R")) d
	....s RelaLocDr=loc,RelaOrg=relaLoc
	...
	...s smsub=$O(^DHCSM(0,"INCI",inci,sm,""))
	...s smr=sm_"||"_smsub
	...s chsub=$o(^DHCSM(sm,"R",smsub,"T",""),-1)+1
	...&sql(insert into DHC_StkMonTrans(SMT_SMR_Parref,SMT_ChildSub,SMT_TransType,SMT_Pointer,SMT_PhyQty,
		SMT_Amount,SMT_CostAmount,SMT_RelaLoc_DR,SMT_SLG_DR,SMT_INCSC_DR,
		SMT_SCG_DR,SMT_SUMTL_DR,SMT_OperateType,SMT_RelaOrg)
		values(:smr,:chsub,:newtype,:pointer,:qty,
		:spamt,:rpamt,:RelaLocDr,:slg,:cat,
		:scg,:sumtlRowId,:operateType,:RelaOrg))
	...i SQLCODE'=0 d RtnObj.Err(-42,"","月报台账明细表保存失败！")
	q RtnObj
}

/// 判断incil上期月报是否有非零结存（鉴于部分项目负库存,repLcbt数据不完整,多种方式控制)
/// Author:	wangjiabin
/// Date:	2015-08-02
/// Argu:	上期月报id,上期月报日期,incil,本期月报rowid
/// Return:	1:有结存, 0:结存为零
/// w ##class().IsIncilLastMon("","",
ClassMethod IsIncilLastMon(LastSM, LastMon, incil, SM = "") As %String
{
	n (LastSM,LastMon,incil,SM)
	s inci=+incil,il=$p(incil,"||",2)
	s LocId=$p(^INCI(inci,"IL",il),"^",1)
	s ret=0
	
	;若没有上期月报,按本期期初判断
	i (LastSM="")&&(SM'="") d
	.s StartDate=$p(^DHCSM(SM),"^",3)
	.s Date=StartDate-1
	.s lb=0
	.f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:(lb="")||(ret'=0)  d
	..s Inclb=incil_"||"_lb
	..s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Date)
	..i +InclbQty'=0 s ret=1
	i (LastSM="")&&(SM'="") q ret
	
	s last=##class(web.DHCSTMHUI.DHCStkMon).GetLast(LastSM,LastMon,incil)
	s lastqty=+$p($g(last),"^",1)
	s lastamount=+$p($g(last),"^",2)
	s lastcostamount=+$p($g(last),"^",3)
	q:(lastqty'=0)||(lastamount'=0)||(lastcostamount'=0) 1
	
	s lb=0
	f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:(lb="")||(ret'=0)  d
	.s inclb=incil_"||"_lb
	.s laststk=..GetLastStk(inclb,LastSM)
	.s lastqty=+$p(laststk,"^",1)
	.i lastqty'=0 s ret=1
	
	q ret
}

/// 保存月报分类汇总数据
/// Author:xuchao
/// Date:2016-08-02
/// .s CATSUMData=rpamount_"^"_lastcostamount_"^"_recrpamount_"^"_retrpamount_"^"_transorpamount
/// .s CATSUMData=CATSUMData_"^"_transirpamount_"^"_adjrpamount_"^"_consumerpamount_"^"_disposalrpamount_"^"_asprpamt
/// .s CATSUMData=CATSUMData_"^"_giftrecrpamount_"^"_gifttrfrpamount_"^"_chgcheckrpamount_"^"_chgcheckretrpamount_"^"_dspPrpamount
/// .s CATSUMData=CATSUMData_"^"_pharetYrpamount_"^"_dspFrpamount_"^"_pharetHrpamount_"^"_pharetZrpamount
/// .s CATSUMData=CATSUMData_"^"_ATRpAmt_"^"_"^"_GDRpAmt_"^"_RDRpAmt_"^"_KDRpAmt
/// .s ^TMPDHCTMPMONCATSUM(pId,incscg,inccat,n)=CATSUMData
ClassMethod SaveCatSumData(sm, pid) As RtnObj
{
	n (sm,pid)
	s RtnObj=##class(RtnObj).%New()
	s scg="" 
	f  s scg=$o(^TMPDHCTMPMONCATSUM(pid,scg)) q:(scg="")||(RtnObj.success<0)  d
	.s cat="" 
	.f  s cat=$o(^TMPDHCTMPMONCATSUM(pid,scg,cat)) q:(cat="")||(RtnObj.success<0)  d
	..s n=0
	..s (Sumrpamount,Sumlastcostamount,Sumrecrpamount,Sumretrpamount,Sumtransorpamount)=0
	..s (Sumtransirpamount,Sumadjrpamount,Sumconsumerpamount,Sumdisposalrpamount,Sumasprpamt)=0
	..s (Sumgiftrecrpamount,Sumgifttrfrpamount,Sumchgcheckrpamount,Sumchgcheckretrpamount,SumdspPrpamount)=0
	..s (SumpharetYrpamount,SumdspFrpamount,SumpharetHrpamount,SumpharetZrpamount)=0
	..s (SumATRpAmt,SumGDRpAmt,SumRDRpAmt,SumKDRpAmt,SumTrAspRpamt)=0
	..f  s n=$o(^TMPDHCTMPMONCATSUM(pid,scg,cat,n)) q:(n="")||(RtnObj.success<0)  d
	...s CATSUMData=^TMPDHCTMPMONCATSUM(pid,scg,cat,n)
	...s rpamount=$P(CATSUMData,"^",1)
	...s lastcostamount=$P(CATSUMData,"^",2)
	...s recrpamount=$P(CATSUMData,"^",3)
	...s retrpamount=$P(CATSUMData,"^",4)
	...s transorpamount=$P(CATSUMData,"^",5)
	...s transirpamount=$P(CATSUMData,"^",6)
	...s adjrpamount=$P(CATSUMData,"^",7)
	...s consumerpamount=$P(CATSUMData,"^",8)
	...s disposalrpamount=$P(CATSUMData,"^",9)
	...s asprpamt=$P(CATSUMData,"^",10)
	...s giftrecrpamount=$P(CATSUMData,"^",11)
	...s gifttrfrpamount=$P(CATSUMData,"^",12)
	...s chgcheckrpamount=$P(CATSUMData,"^",13)
	...s chgcheckretrpamount=$P(CATSUMData,"^",14)
	...s dspPrpamount=$P(CATSUMData,"^",15)
	...s pharetYrpamount=$P(CATSUMData,"^",16)
	...s dspFrpamount=$P(CATSUMData,"^",17)
	...s pharetHrpamount=$P(CATSUMData,"^",18)
	...s pharetZrpamount=$P(CATSUMData,"^",19)
	...s ATRpAmt=$P(CATSUMData,"^",20)
	...s GDRpAmt=$P(CATSUMData,"^",21)
	...s RDRpAmt=$P(CATSUMData,"^",22)
	...s KDRpAmt=$P(CATSUMData,"^",23)
	...s TrAspRpamt=$P(CATSUMData,"^",24)
	...s Sumrpamount=Sumrpamount+rpamount
	...s Sumlastcostamount=Sumlastcostamount+lastcostamount
	...s Sumrecrpamount=Sumrecrpamount+recrpamount
	...s Sumretrpamount=Sumretrpamount+retrpamount
	...s Sumtransorpamount=Sumtransorpamount+transorpamount
	...s Sumtransirpamount=Sumtransirpamount+transirpamount
	...s Sumadjrpamount=Sumadjrpamount+adjrpamount
	...s Sumconsumerpamount=Sumconsumerpamount+consumerpamount
	...s Sumdisposalrpamount=Sumdisposalrpamount+disposalrpamount
	...s Sumasprpamt=Sumasprpamt+asprpamt
	...s Sumgiftrecrpamount=Sumgiftrecrpamount+giftrecrpamount
	...s Sumgifttrfrpamount=Sumgifttrfrpamount+gifttrfrpamount
	...s Sumchgcheckrpamount=Sumchgcheckrpamount+chgcheckrpamount
	...s Sumchgcheckretrpamount=Sumchgcheckretrpamount+chgcheckretrpamount
	...s SumdspPrpamount=SumdspPrpamount+dspPrpamount
	...s SumpharetYrpamount=SumpharetYrpamount+pharetYrpamount
	...s SumdspFrpamount=SumdspFrpamount+dspFrpamount
	...s SumpharetHrpamount=SumpharetHrpamount+pharetHrpamount
	...s SumpharetZrpamount=SumpharetZrpamount+pharetZrpamount
	...s SumATRpAmt=SumATRpAmt+ATRpAmt
	...s SumGDRpAmt=SumGDRpAmt+GDRpAmt
	...s SumRDRpAmt=SumRDRpAmt+RDRpAmt
	...s SumKDRpAmt=SumKDRpAmt+KDRpAmt
	...s SumTrAspRpamt=SumTrAspRpamt+TrAspRpamt
	..&sql(Insert DHC_StkMonSumIn_CatGrp
		(SUMCG_SM_DR,SUMCG_StkCat_DR,SUMCG_SCG_DR,
		SUMCG_Amt,SUMCG_LastAmt,SUMCG_Rec_Amt,SUMCG_Ret_Amt,SUMCG_Trf_O_Amt,
		SUMCG_Trf_I_Amt,SUMCG_Adj_Amt,SUMCG_Consume_Amt,SUMCG_Disposal_Amt,SUMCG_Asp_Amt,
		SUMCG_Gift_Rec_Amt,SUMCG_Gift_Trf_Amt,SUMCG_ChgCheck_Rec_Amt,SUMCG_ChgCheck_Ret_Amt,SUMCG_Dsp_P_Amt,
		SUMCG_PhaRet_Y_Amt,SUMCG_Dsp_F_Amt,SUMCG_PhaRet_H_Amt,SUMCG_PhaRet_Z_Amt,
		SUMCG_StkTk_Amt,SUMCG_Rec_Asp_Amt,SUMCG_Ret_Asp_Amt,
		SUMCG_Trf_I_Asp_Amt,SUMCG_BG_Asp_Amt)
		values
		(:sm,:cat,:scg,
		:Sumrpamount,:Sumlastcostamount,:Sumrecrpamount,:Sumretrpamount,:Sumtransorpamount,
		:Sumtransirpamount,:Sumadjrpamount,:Sumconsumerpamount,:Sumdisposalrpamount,:Sumasprpamt,
		:Sumgiftrecrpamount,:Sumgifttrfrpamount,:Sumchgcheckrpamount,:Sumchgcheckretrpamount,:SumdspPrpamount,
		:SumpharetYrpamount,:SumdspFrpamount,:SumpharetHrpamount,:SumpharetZrpamount,
		:SumATRpAmt,:SumGDRpAmt,:SumRDRpAmt,
		:SumKDRpAmt,:SumTrAspRpamt
		))
	..i SQLCODE'=0 d RtnObj.Err(-1,"","保存月报库存分类汇总数据失败！")
	q RtnObj
}

}
