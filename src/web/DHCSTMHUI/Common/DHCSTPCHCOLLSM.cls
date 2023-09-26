Import sqluser

/// Descript:住院和门诊审核医嘱减库存及停医嘱涨库存执行函数
/// CreateDate:2012-6-10
/// Creator:  zhangxiao
Class web.DHCSTMHUI.Common.DHCSTPCHCOLLSM Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 住院和门诊审核医嘱减库存 2012-06-10
/// zdm,2010-06-09
/// 1 找批次
/// 2 处理该材料记录的库存
/// 3 处理dhc_intrans表
/// 3 处理INC_ItmLcBt和INC_ItmLoc,dhc_locdailytotal,dhc_locbtdailytotal
/// 备注：库存类型不是"M"的不处理,无库存医嘱不处理
/// Input:	oeore-长期医嘱：执行记录rowid
/// 			 -非长期医嘱：医嘱RowID
/// 		CallFlag-(审核医嘱-"ORDER",计费-"BILL")
/// Return:0-正确;-1,-2,-3,-4医嘱错误;-5没有医嘱数量;-6已经发药或已经退药,-7库存不足;1,2,3,4处理库存错误
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).DispMaterial("152||140","ORDER")
ClassMethod DispMaterial(oeore, CallFlag = "") As %Library.String
{
	n (oeore,CallFlag)
	;2016-02-02 不是长期医嘱的,取oeori(而非oeore)
	s priorCode=..PriorityCode(oeore)
	s:priorCode'="S" oeore=$p(oeore,"||",1,2)
	
	s oeori=$p(oeore,"||",1,2)
	s ord=$p(oeore,"||",1)
	s itm=$p(oeore,"||",2)
	q:(ord="")!(itm="") -1
	q:'$d(^OEORD(ord,"I",itm)) -1

	;自备药,嘱托,不进行库存消减
	;OM^自备药即刻, OMST^自备药长期, OMCQZT^长期嘱托, OMLSZT^临时嘱托
	s PriorID=$p(^OEORD(ord,"I",itm,1),"^",8)
	s PriorCode=$s(PriorID'="":$p($g(^OECPR(PriorID)),"^",1),1:"")
	q:$ZCVT(PriorCode,"U")["OM" 0

	s paadm=$P(^OEORD(ord),"^",1)
	s admtype=$p(^PAADM(paadm),"^",2)
	s admloc=$p(^PAADM(paadm),"^",4)
	s HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
	q:recloc="" -3
	
	s StockControl=##class(web.DHCSTMHUI.Common.UtilCommon).GetStockControl(recloc)
	q:(StockControl="N") 0
	
	s Param="^"_recloc_"^^"_HospitalId
	s matDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM","MatDisp",Param)
	s InMatDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTINMATDISPM","InMatDisp",Param)
	q:(admtype="O")&&(matDisp="Y") 0     ;普通物资走门诊发放时不处理
	q:(admtype="E")&&(matDisp="Y") 0     ;急诊物资走门诊发放时不处理
	q:(admtype="I")&&(InMatDisp="Y") 0     ;住院物资走门诊发放时不处理

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	q:(admtype="I")&&(CallFlag="BILL") 0	;2017-02-23: 住院患者,计费时调用不再处理
	q:(admtype="O")&&(CallFlag="ORDER") 0	;2017-02-23: 门诊患者,审核医嘱时调用不再处理

	;paymodeflag: 1-押金收费模式 0-普通收费模式
	s paymodeflag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(HospitalId)
	;stayFlag: 1-有留观医嘱 0-无留观医嘱
	s stayFlag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayStatus(paadm)
	q:(admtype="E")&&(paymodeflag=1)&&(stayFlag'=-1)&&(CallFlag="BILL") 0	;2017-09-28: 急诊患者,押金模式下留观计费时调用不再处理
	q:(admtype="E")&&(paymodeflag=1)&&(stayFlag=-1)&&(CallFlag="ORDER") 0	;2017-09-28: 急诊患者,押金模式下非留观审核医嘱时调用不再处理
	q:(admtype="E")&&(paymodeflag=0)&&(CallFlag="ORDER") 0	;2017-09-28: 急诊患者,普通模式下审核医嘱时调用不再处理

	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" -2
	q:..ChkWoStock(arcim)=1 0	//无库存医嘱退出
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) 
	q:inci="" -4
	s stkCatGrpType=..GetItmStkGrpType(inci)
	q:stkCatGrpType'="M" 0	//非材料医嘱退出

	s UseItmTrack=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCITMTRACKM","UseItmTrack","^^"_recloc)
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	q:(UseItmTrack="Y")&&(HVFlag="Y") 0						;过滤是高值的

	s buomDr=$p(^INCI(inci,1),"^",10)
	s incicode=$p(^INCI(inci,1),"^",1)
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)   	;处方号
	s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)					
	s ucost=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,HospitalId)				;单价
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	s confqty=+..CalDispQty(oeore)				;取材料医嘱数量
	i confqty=0 d
	.s ^DHCSTERROR($h,"confqty_material",$j)="confqty"_"^"_confqty_"oeori:"_oeori
	q:confqty=0 -5
	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	s oeStatus=..ChkDspStatus(oeore)
	i oeStatus'="TC" d
	.l -^DHCOEDISPENSING(oeori)
	q:oeStatus'="TC" -6
	
	//门急诊单机应急系统(导回数据后关于统一售价取值信息，支持负库存)
	s (ContFlag,ContInclb,ContSp,ContBatchSp)=""
	s OeoriInfo=$g(^OEORD(ord,"I",itm,"DHC"))
	s ContFlag=$p(OeoriInfo,"^",62)
	i ContFlag="Y" d
	.s ContBatchSp=$p(OeoriInfo,"^",63)
	.s ContInclb=$p(ContBatchSp,",",1)
	.s ContSp=$p(ContBatchSp,",",2)
	.s ucost=ContSp

	s err=0
	s Pid=..SelClbQty(recloc,inci,confqty)
	i Pid=""  d
	.s ^DHCSTERROR($h,"SelClbQty_material",$j)="recloc:"_recloc_"^inci:"_inci
	.l -^DHCINCIL(recloc,inci)   ;incil去锁
	.l -^DHCOEDISPENSING(oeori)  ;去锁
	q:Pid="" -7
	tstart
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s i=0
	f  s i=$o(^TMPDHCSTM("SelClbQty",Pid,i)) q:(i="")||(err'=0)  d
	.s inclb=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",1)
	.s qty=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",2)
	.s qty=-qty
	.;s ret=##class(web.DHCSTMHUI.PCHCOLLSM).ClearResQty(inclb,qty) ;清在途数
	.;i ret'=0 s err=3 q
	.s ReservedObj={}
	.s Incil=$p(inclb,"||",1,2)
	.s ReservedObj.Type="Oeori",ReservedObj.Pointer=oeore,ReservedObj.Incil=Incil,ReservedObj.Qty=qty
	.s ReservedParams=ReservedObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	.i RtnObj.success<0 s err=-3 q
	.
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	.s:ret<0 err=-1
	.q:ret<0
	.s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,HospitalId)               ;批次进价
	.s rpamt=rp*qty
	.s spamt=ucost*qty
	.s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_ucost_"^"_userid_"^"_oeore_"^"_rp_"^"_rpamt_"^"_spamt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	.s:RtnObj.success'=0 err=-2
	.q:ret<0

	i err'=0 d
	.trollback 1
	.l -^DHCINCIL(recloc,inci)   ;incil去锁
	.l -^DHCOEDISPENSING(oeori)  ;去锁
	q:err'=0 err

	s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(oeore,"C",+$h,$p($h,",",2),userid,intrType,"")
	i err'=0 d
	.trollback 1
	.l -^DHCINCIL(recloc,inci)   ;incil去锁
	.l -^DHCOEDISPENSING(oeori)  ;去锁
	q:err'=0 err
	tcommit
	l -^DHCINCIL(recloc,inci)   ;incil去锁
	l -^DHCOEDISPENSING(oeori)  ;去锁
	q err
}

/// 停医嘱涨库存执行函数 2012-06-10
/// Creator:zdm
/// CreatDate:2010-06-10
/// Description:停医嘱处理库存
/// 备注：库存类型不是"M"的不处理,无库存医嘱不处理
/// Table:in_trans,inc_itmloc,inc_itmlcbt
/// Input:	医嘱明细rowid(长期医嘱传入执行记录rowid--oeore)
/// Return:0,成功；非0，错误 
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ReturnMaterial("6685||187")
ClassMethod ReturnMaterial(oeore, RetStr As %String = "") As %Library.String
{
	n (oeore,RetStr)
	q:oeore="" ""

	s priorCode=..PriorityCode(oeore)
	s:priorCode'="S" oeore=$p(oeore,"||",1,2)

	;自备药,嘱托,不进行库存处理
	q:$ZCVT(priorCode,"U")["OM" 0

	s oeori=$p(oeore,"||",1,2)
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" ""
	;q:..ChkWoStock(arcim)=1 0	//无库存医嘱退出 //2019-04-04:不再根据无库存医嘱进行判断
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
	q:recloc="" ""
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) 
	q:inci="" ""
	s stkCatGrpType=..GetItmStkGrpType(inci)
	q:stkCatGrpType'="M" 0	//非材料医嘱退出
	s buomDr=$p(^INCI(inci,1),"^",10)
	s incicode=$p(^INCI(inci,1),"^",1)
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)   	;处方号
	s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	
	s paadm=$p(^OEORD($p(oeori,"||",1)),"^",1)
	s admtype=$p(^PAADM(paadm),"^",2)

	s admloc=$p(^PAADM(paadm),"^",4)
	s HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	s Param="^"_recloc_"^^"_HospitalId
	s matDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM","MatDisp",Param)
	s InMatDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTINMATDISPM","InMatDisp",Param)
	s BatSpFlag=..sssBatSpFlag(HospitalId,inci)
	q:(admtype="O")&&(matDisp="Y") 0	;普通物资走门诊发放时不处理
	q:(admtype="E")&&(matDisp="Y") 0	;急诊物资走门诊发放时不处理
	q:(admtype="I")&&(InMatDisp="Y") 0	;住院物资走发放时不处理
	
	s StockControl=##class(web.DHCSTMHUI.Common.UtilCommon).GetStockControl(recloc)
	q:((StockControl="N")&&(BatSpFlag=0)) 0	;统一价且不允许科室消耗
	
	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	s err=0
	
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s dispType=$p(IntrTypeInfo,"^",1)
	s intrType=$p(IntrTypeInfo,"^",2)
	
	s OeRetStr=..GetOeRetStr(oeore)		//oeStatus=..ChkDspStatus
	s RetableFlag=$p(OeRetStr,"^",1)
	s RetableQty=$p(OeRetStr,"^",2)
	i RetableFlag'="Y" d
	.l -^DHCOEDISPENSING(oeori)
	q:RetableFlag'="Y" 0
	
	s RetQty=+$p(RetStr,"^",1)
	s PrtId=$p(RetStr,"^",2)
	i PrtId'="" d
	.s TrId=$o(^DHCINTR(0,"TypePrt",intrType,PrtId,0))
	.i TrId'="" s err=-7
	q:err'=0 err
	i (RetQty>RetableQty)||(RetQty=0) s RetQty=RetableQty		//未传退回数量或退回数量大于可退数量，按可退数量取值
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	tstart
	s LeftQty=RetQty
	s Pid=..GetTrQty(oeore)
	i Pid'="" d
	.s Inclb=""
	.f  s Inclb=$o(^TMPDHCSTM("TrQty",Pid,Inclb)) q:(Inclb="")!(err>0)  d
	..s TrStr=^TMPDHCSTM("TrQty",Pid,Inclb)
	..s Inclbqty=$p(TrStr,"^",1)
	..s Rp=$p(TrStr,"^",2)
	..s Sp=$p(TrStr,"^",3)
	..i LeftQty>Inclbqty s InclbRetQty=Inclbqty,LeftQty=LeftQty-Inclbqty
	..e  s InclbRetQty=LeftQty
	..s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,InclbRetQty)
	..s:ret<0 err =1
	..s Rpamt=Rp*InclbRetQty
	..s Spamt=Sp*InclbRetQty
	..s lstdata=intrType_"^"_presc_"^"_Inclb_"^"_InclbRetQty_"^"_buomDr_"^"_Sp_"^"_userid_"^"_oeore_"^"_Rp_"^"_Rpamt_"^"_Spamt_"^"_PrtId
	..s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	..s:RtnObj.success'=0 err=2
	..q:ret<0
	i err>0 d
	.trollback 1
	.l -^DHCOEDISPENSING(oeori)
	q:err>0 err

	s err=##Class(web.DHCSTMHUI.COMMOE).InsDispensing(oeore,"R",+$h,$p($h,",",2),userid,intrType,"",RetQty,buomDr)
	i err'=0 d
	.trollback 1
	.l -^DHCOEDISPENSING(oeori)
	q:err'=0 err
	
	job ##class(web.DHCSTMHUI.ServiceForHRP).SendOeori(oeore,"Return",HospitalId)
	
	tcommit
	l -^DHCOEDISPENSING(oeori)
	q 0
}

/// 判断当前医嘱可退库存标志及数量
ClassMethod GetOeRetStr(Oeore)
{
	n (Oeore)
	s RetableFlag="N",RetQty=0,DspQty=0,RetableQty=0
	
	i $p(Oeore,"||",3)'="" d
	.s LastDspID=$o(^DHCOEDISQTY(0,"OEORE",Oeore,""),-1)
	.s LastStatus=$p(^DHCOEDISQTY(LastDspID),"^",7)
	.i LastStatus="C" s RetableFlag="Y",RetableQty=$p(^DHCOEDISQTY(LastDspID),"^",5)
	.q:(LastStatus'="C")&&(LastStatus'="R")
	.q:RetableFlag="Y"
	.s DspID=0
	.f  s DspID=$o(^DHCOEDISQTY(0,"OEORE",Oeore,DspID)) q:(DspID="")  d
	..s RetStatus=$p(^DHCOEDISQTY(DspID),"^",7)
	..i RetStatus="C" s DspQty=$p(^DHCOEDISQTY(DspID),"^",5)
	..e  i RetStatus="R" s RetQty=RetQty+$p(^DHCOEDISQTY(DspID),"^",5)
	.s RetableQty=DspQty-RetQty
	.i RetableQty>0 s RetableFlag="Y"
	.q:RetableFlag="Y"
	e  d
	.;医嘱rowid--oeori
	.s Oeori=$p(Oeore,"||",1,2)
	.s LastDspID=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""),-1)
	.s LastStatus=$p(^DHCOEDISQTY(LastDspID),"^",7)
	.i LastStatus="C" s RetableFlag="Y",RetableQty=$p(^DHCOEDISQTY(LastDspID),"^",5)
	.q:(LastStatus'="C")&&(LastStatus'="R")
	.q:RetableFlag="Y"
	.s DspID=0
	.f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",Oeori,DspID)) q:(DspID="")  d
	..s RetStatus=$p(^DHCOEDISQTY(DspID),"^",7)
	..i RetStatus="C" s DspQty=$p(^DHCOEDISQTY(DspID),"^",5)
	..e  i RetStatus="R" s RetQty=RetQty+$p(^DHCOEDISQTY(DspID),"^",5)
	.s RetableQty=DspQty-RetQty
	.i RetableQty>0 s RetableFlag="Y"
	.q:RetableFlag="Y"
	
	q RetableFlag_"^"_RetableQty
}

/// 获取当前医嘱的减库存台账对应可退库存的批次及数量
ClassMethod GetTrQty(oeore)
{
	n (oeore)
	s Pid=..NewPid()
	
	s oeori=$p(oeore,"||",1,2)
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s dispType=$p(IntrTypeInfo,"^",1)
	s intrType=$p(IntrTypeInfo,"^",2)
	
	k ^TMPDHCSTM("TrQty",Pid)
	s count=0,trid=""
	f  s trid=$o(^DHCINTR(0,"TypePointer",dispType,oeore,trid),-1) q:(trid="")  d
	.s inclb=$p(^DHCINTR(trid),"^",7)
	.s inci=$p(^DHCINTR(trid),"^",15)
	.;非材料过滤20180920
	.s inci=$p(^DHCINTR(trid),"^",15)
	.q:inci=""
	.s stkCatGrpType=..GetItmStkGrpType(inci)
	.q:stkCatGrpType'="M"
	.s dispqty=$p(^DHCINTR(trid),"^",6)
	.s rp=$p(^DHCINTR(trid),"^",16)
	.s ucost=$p(^DHCINTR(trid),"^",14)
	.s dispqty=-dispqty
	.s retqty=0,leftqty=0
	.s rettrid=0
	.f  s rettrid=$o(^DHCINTR(0,"TypePointerInclb",intrType,oeore,inclb,rettrid)) q:(rettrid="")  d
	..s qty=$p(^DHCINTR(rettrid),"^",6)
	..s retqty=retqty+qty
	.s leftqty=dispqty-retqty
	.q:leftqty'>0
	.s count=count+1
	.s ^TMPDHCSTM("TrQty",Pid,inclb)=leftqty_"^"_rp_"^"_ucost
	
	q:count=0 ""
	q Pid
}

/// 按照数量选择批次（先进先出）,PDELIM="!"
/// zdm,2009-5-25
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).SelClbQty(153,1427,2000)
ClassMethod SelClbQty(loc, inci, dspqty) As %Library.String
{
	n (loc, inci, dspqty)
	
	//l +^DHCINCIL(loc,inci):20  e  q ""
	
	s ch=$o(^INCI("IL_LOC",loc,inci,0))
	q:ch="" ""
	
	s CheckExpFlag="Y"
	i $d(^DHCSTM("CheckExp")) d
	.s CheckExpFlag=^DHCSTM("CheckExp")
	
	s Pid=..NewPid()
	s sumclbqty=0
	k ^TMPDHCSTM("ClbQty",Pid)
	k ^TMPDHCSTM("SelClbQty",Pid)
	s inclbsub=0,inclb="",num=0,ExpDate=""
	f  s inclbsub=$o(^INCI(inci,"IL",ch,"LB",inclbsub)) q:(inclbsub="")||(sumclbqty>dspqty)  d
	.s inclb=inci_"||"_ch_"||"_inclbsub
	.s incib=$p(^INCI(inci,"IL",ch,"LB",inclbsub),"^",1)
	.s phyqty=+$p(^INCI(inci,"IL",ch,"LB",inclbsub),"^",2)
	.s incibsub=$p(incib,"||",2)
	.s ExpDate=$p(^INCI(inci,"IB",incibsub),"^",2)
	.i +ExpDate=0 s ExpDate=$zdh("9999-12-31",3)
	.q:(CheckExpFlag="Y")&&(ExpDate<=+$h)
	.s reccallflag=$p(^INCI(inci,"IB",incibsub),"^",3)
	.q:reccallflag="Y"		///批次锁定
	.q:phyqty'>0
	.s ^TMPDHCSTM("ClbQty",Pid,ExpDate,inclb)=phyqty
	.s num=num+1
	.s sumclbqty=sumclbqty+phyqty
	q:inclb="" ""	//没有可用批次
	
	//取最后一个批次,且qty=0
	i (num=0) d
	.s num=num+1
	.s ^TMPDHCSTM("ClbQty",Pid,ExpDate,inclb)=0
	//循环消减
	s k=0,sumdqty=0,lastqty=dspqty,tempinclb=""
	s ExpDate=0
	f  s ExpDate=$o(^TMPDHCSTM("ClbQty",Pid,ExpDate)) q:(ExpDate="")||(lastqty'>0)  d
	.s inclb=0
	.f  s inclb=$o(^TMPDHCSTM("ClbQty",Pid,ExpDate,inclb)) q:(inclb="")||(lastqty'>0)  d
	..s clbqty=^TMPDHCSTM("ClbQty",Pid,ExpDate,inclb)
	..s tempinclb=inclb		//记录最后一个批次
	..q:+clbqty=0
	..s k=k+1
	..s ^TMPDHCSTM("SelClbQty",Pid,k)=inclb
	..i clbqty'<lastqty d
	...s sumdqty=sumdqty+lastqty
	...s ^TMPDHCSTM("SelClbQty",Pid,k)=inclb_"^"_lastqty
	...s lastqty=0
	..e  d
	...s sumdqty=sumdqty+clbqty
	...s ^TMPDHCSTM("SelClbQty",Pid,k)=inclb_"^"_clbqty
	...s lastqty=lastqty-clbqty
	q:tempinclb="" "" //没有可用批次
	
	//剩余数量消减在最后一个批次
	i (lastqty>0) d
	.i k>0 d
	..s $p(^TMPDHCSTM("SelClbQty",Pid,k),"^",2)=$p(^TMPDHCSTM("SelClbQty",Pid,k),"^",2)+lastqty
	.e  d
	..s k=k+1
	..s ^TMPDHCSTM("SelClbQty",Pid,k)=tempinclb_"^"_lastqty
	
	q:k=0 ""
	q Pid
}

/// Creator:zdm
/// CreatDate:2010-06-03
/// Description:取材料医嘱数量
/// Table:oe_orditem
/// Input:
///     “医嘱明细id”（非长嘱） 或 “执行记录RowId”(长嘱)
/// Return:数量
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CalDispQty("6685||217")
ClassMethod CalDispQty(oe As %String) As %Library.String
{
	n (oe)

	//重新计算发放数量（zhwh，2016-02-04）
	s sumqty=0,qty=0
	s err=0
	i $l(oe,"||")=3 d  //执行记录
	.s oeore=oe
	.s dspID=0
	.f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",oeore,dspID)) q:(dspID="")!(err'=0)  d
	..s qty=$p($G(^DHCOEDISQTY(dspID)),"^",11)
	..s sumqty=sumqty+qty
	e  d  //医嘱明细
	.s OeoriID=oe
	.s dspID=0
	.f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,dspID)) q:(dspID="")!(err'=0)  d
	..s qty=$p($G(^DHCOEDISQTY(dspID)),"^",11)
	..s sumqty=sumqty+qty

	q sumqty
}

/// Description:判断医嘱是否是无库存医嘱
/// Creator:	zhouyg
/// CreatDate:	2012-04-13
/// Table:		Arc_ItmMast
/// Input:		医嘱项ID
/// Return:		1-是无库存医嘱,0-不是无库存医嘱
ClassMethod ChkWoStock(ArcimID) As %Library.String
{
	n (ArcimID)
	s ArcimSub=$p(ArcimID,"||",1)
	s ArcimVer=$p(ArcimID,"||",2)
	q:(ArcimSub="")!(ArcimVer="") 1
	s WoFlag=0
	s WoStock=$p($g(^ARCIM(ArcimSub,ArcimVer,8)),"^",11)
	i WoStock="Y" s WoFlag=1
	q WoFlag
}

/// Description:判断医嘱的发药状态(只适用于材料,不会存在分次发放的情况)
/// Creator:	zhouyg
/// CreatDate:	2012-04-13
/// Table:		oe_orditem
/// Input:		医嘱ID
/// Return:		状态代码(TC,C,R)
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ChkDspStatus("6685||183")
ClassMethod ChkDspStatus(Oeore) As %Library.String
{
	n (Oeore)
	s RetStatus=""
	i $p(Oeore,"||",3)'="" d
	.;执行记录rowid--oeore
	.s DspID=$o(^DHCOEDISQTY(0,"OEORE",Oeore,""),-1)
	.s:DspID'="" RetStatus=$p(^DHCOEDISQTY(DspID),"^",7)
	e  d
	.;医嘱rowid--oeori
	.s Oeori=$p(Oeore,"||",1,2)
	.s DspID=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""),-1)
	.s:DspID'="" RetStatus=$p(^DHCOEDISQTY(DspID),"^",7)

	q RetStatus
}

/// Description:库存项对应的类组类型：G/M
/// Input:	库存项id
/// Return:
ClassMethod GetItmStkGrpType(inciid) As %Library.String
{
	n (inciid)
	q:inciid="" ""
	s Incsc=$p(^INCI(inciid,2),"^",2)
	q:Incsc="" ""
	s StkType=$p(^INC("SC",Incsc),"^",3)
	q StkType
}

/// 材料消耗处理（适合第三方系统对物资材料的消耗处理-可能是没有医嘱）
/// Author:  zhwh
/// Date:2014-12-05
/// Arguments :
///  loc -  科室(库)RowId
///  arcim  -医嘱RowId (ARC_ItmMast)
///  qty  - 材料数量(按基本单位计)
///  user - 操作用户RowId
///  admtype -就诊类型代码("I","O")
///  xseqid -业务流水Id(透析记录)
/// Return:
///  0 - 成功
///  -1 - 无库存项
///  -2 - 非材料
///  -3 - 库存不足
///  1 - 库存处理出错
///  2 -台帐处理出错
ClassMethod MatConsume(loc, arcim, qty, user, admtype, xseqid)
{
	n (loc,arcim,qty,user,admtype,xseqid)
	s $ZT=..sssError()
	s Arc=$p(arcim,"||",1)
	q:Arc="" -1
	s inci=$o(^INCI(0,"ARCIM_DR",Arc,0))
	q:inci="" -1
	q:..GetItmStkGrpType(inci)'="M" -2	//非材料医嘱退出
	s Pid=..SelClbQty(loc,inci,qty)
	q:Pid="" -3
	s IntrType=$s(admtype="I":"MP",admtype="O":"MF",1:"MF")
	
	tstart
	s err=0
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s i=0
	f  s i=$o(^TMPDHCSTM("SelClbQty",Pid,i)) q:(i="")||(err'=0)  d
	.s inclb=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",1)
	.s qty=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",2)
	.s qty=-qty
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	.s:ret<0 err=1
	.q:ret<0
	.s buomDr=$p(^INCI(inci,1),"^",10)  ;基本单位
	.s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,"")
	.s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")
	.s rpamt=rp*qty
	.s spamt=sp*qty
	.s lstdata=IntrType_"^"_xseqid_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_user_"^"_oeori_"^"_rp_"^"_rpamt_"^"_spamt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	.s:RtnObj.success'=0 err=2
	.q:err>0

	i err'=0 tro  q err
	tcommit
	q err
}

/// Description:根据计费项关联库存项的明细信息进行库存消减
/// Creator:	wangjiabin
/// CreateDate:	2016-08-22
/// Table:		DHC_InciLinkTar
/// Input:		oeori - 医嘱项rowid
/// Output:		
/// Return:		0:成功, 其他:失败
ClassMethod DispByTariff(oeori As %String, CallFlag = "") As %String
{
	n (oeori,CallFlag)
	s Oeord=$p(oeori,"||",1),Ch=$p(oeori,"||",2)
	q:(Oeord="")!(Ch="") -1
	q:'$d(^OEORD(Oeord,"I",Ch)) -1
	s arcim=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	q:arcim="" -2
	
	s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	s priorCode=""
	i $d(^OECPR(priority)) d
	.s priorCode=$p(^OECPR(priority),"^",1)
	.s:priorCode'="S" oeori=$p(oeori,"||",1,2)
	q:priorCode["OM" 0
	
	s paadm=$p(^OEORD(Oeord),"^",1)
	s admtype=$p(^PAADM(paadm),"^",2)
	q:(admtype="I")&&(CallFlag="BILL") 0	;住院患者,计费时调用不再处理
	q:(admtype="O")&&(CallFlag="ORDER") 0	;门诊患者,审核医嘱时调用不再处理
	
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	;避免重复处理
	q:$d(^DHCINTR(0,"TypePointer",intrType,oeori)) -10
	
	l +^DHCOEDISPENSING(oeori):20  e  q -100		;加锁
	s ret=0
	ts
	s InstZ=""
	f  s InstZ=$o(^DHCOLT(0,"ARCIM",arcim,InstZ)) q:(InstZ="")||(ret'=0)  d
	.s OltStartDate=""
	.f  s OltStartDate=$o(^DHCOLT(0,"ARCIM",arcim,InstZ,OltStartDate)) q:(OltStartDate="")||(ret'=0)  d
	..q:(OltStartDate'="")&&(OltStartDate>+$h)
	..s Olt=""
	..f  s Olt=$o(^DHCOLT(0,"ARCIM",arcim,InstZ,OltStartDate,Olt)) q:(Olt="")||(ret'=0)  d
	...s OltEndDate=$p(^DHCOLT(Olt),"^",5)
	...q:(OltEndDate'="")&&(OltEndDate<+$h)
	...s tariff=$p(^DHCOLT(Olt),"^",2)
	...s oltqty=+$p(^DHCOLT(Olt),"^",3)   //计费数量
	...s Inci=..GetInciByTariff(tariff)
	...i Inci'="" d
	....s ret=..ConsumeByTariffM(Inci,tariff,oeori,oltqty)
	...e  d
	....q:'$d(^DHCILT(0,"Tariff",tariff))
	....s ret=..ConsumeByTariff(tariff,oeori,oltqty)
	i ret'=0 l -^DHCOEDISPENSING(oeori) tro 1  q ret
	
	l -^DHCOEDISPENSING(oeori)
	tc
	q ret
}

/// Description:根据计费项关联库存项的明细信息进行库存消减
/// Creator:	wangjiabin
/// CreateDate:	2015-03-30
/// Table:		DHC_InciLinkTar
/// Input:		Tariff - 计费项rowid, Oeori - 医嘱项rowid
/// Output:		
/// Return:
///  0 - 成功
///  -1 - 无库存项
///  -2 - 非材料
///  -3 - 库存不足
///  1 - 库存处理出错
///  2 - 台帐处理出错
ClassMethod ConsumeByTariff(tariff As %String, oeori As %String, oltqty As %String = "1") As %String [ Private ]
{
	n (tariff,oeori,oltqty)
	s ord=+oeori,itm=$p(oeori,"||",2)
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	s loc=$p(^OEORD(ord,"I",itm,3),"^",6)	;接收科室
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s confqty=+$p(^OEORD(ord,"I",itm,1),"^",12)		;取材料医嘱数量
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	
	k xTMPILTGROUP
	s err=0
	tstart
	&sql(declare InciLinkCursor cursor for
		select ILT_INCI_DR,ILT_Qty,ILT_Uom,ILT_Group
		from DHC_InciLinkTar where ILT_Tariff_DR=:tariff)
	&sql(open InciLinkCursor)
	f  &sql(fetch InciLinkCursor into :inci,:qtyUom,:uom,:LinkGroup) q:((SQLCODE'=0)||(err'=0))  d
	.q:..GetItmStkGrpType(inci)'="M"
	.
	.;若不存在库存记录,自动生成一个批次
	.s Incil=##class(web.DHCSTMHUI.Common.StockHandle).CreateZeroIncil(loc,inci)
	.
	.s buomDr=$p(^INCI(inci,1),"^",10)
	.s confac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buomDr)
	.s bqty=qtyUom*confac*oltqty*confqty   //计费物资关联数量*计费数量*医嘱数量
	.i LinkGroup'="" d
	..q:((","_$g(xTMPILTGROUP(oeori,tariff,LinkGroup))_",")[(","_LinkGroup_","))
	..i '$d(xTMPILTGROUP(oeori,tariff,LinkGroup)) d
	...s xTMPILTGROUP(oeori,tariff,LinkGroup)=LinkGroup
	..e  d
	...s xTMPILTGROUP(oeori,tariff,LinkGroup)=xTMPILTGROUP(oeori,tariff,LinkGroup)_","_LinkGroup
	..s ret=..SelClbQtyM(oeori,loc,bqty,LinkGroup,tariff)
	.e  d
	..s Pid=..SelClbQty(loc,inci,bqty)
	..;i Pid="" s err=-3
	..i Pid="" q		;没有库存不报错
	..e  d
	...s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	...s i=0
	...f  s i=$o(^TMPDHCSTM("SelClbQty",Pid,i)) q:(i="")||(err'=0)  d
	....s inclb=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",1)
	....s qty=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",2)
	....s qty=-qty
	....s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	....s:ret<0 err=-1
	....q:ret<0
	....s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,"")				;单价
	....s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")	;批次进价
	....s rpamt=rp*qty
	....s spamt=sp*qty
	....s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpamt_"^"_spamt
	....s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	....s:RtnObj.success'=0 err=-2
	&sql(close InciLinkCursor)
	i err'=0 tro 1 l -^DHCINCIL(loc,inci) q err
	tcommit
	q err
}

/// Description:单纯医嘱项关联了耗材类收费项(该收费项存在有效库存项)时, 提供库存消减功能
/// Creator:	wxj
/// CreateDate:	2023-03-16
/// Input:		inci - 库存项rowid, Tariff - 计费项rowid, Oeori - 医嘱项rowid		
/// Return:
///  0 - 成功, <0 - 失败
ClassMethod ConsumeByTariffM(inci As %String, tariff As %String, oeori As %String, oltqty As %String = "1") As %String [ Private ]
{
	n (inci,tariff,oeori,oltqty)
	s ord=+oeori,itm=$p(oeori,"||",2)
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	s loc=$p(^OEORD(ord,"I",itm,3),"^",6)	;接收科室
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s confqty=+$p(^OEORD(ord,"I",itm,1),"^",12)		;取材料医嘱数量
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	
	s err=0
	tstart
	;若不存在库存记录,自动生成一个批次
	s Incil=##class(web.DHCSTMHUI.Common.StockHandle).CreateZeroIncil(loc,inci)	
	s buomDr=$p(^INCI(inci,1),"^",10)
	s bqty=oltqty*confqty   //计费数量*医嘱数量
		
	s Pid=..SelClbQty(loc,inci,bqty)
	q:Pid="" 0 ;没有库存不报错
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s i=0
	f  s i=$o(^TMPDHCSTM("SelClbQty",Pid,i)) q:(i="")||(err'=0)  d
	.s inclb=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",1)
	.s qty=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",2)
	.s qty=-qty
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	.s:ret<0 err=-1
	.q:ret<0
	.s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,"")				;单价
	.s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")	;批次进价
	.s rpamt=rp*qty
	.s spamt=sp*qty
	.s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpamt_"^"_spamt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	.s:RtnObj.success'=0 err=-2
	i err'=0 tro 1 l -^DHCINCIL(loc,inci) q err
	tcommit
	q err
}

/// CreatDate:	2016-08-22
/// Description:停医嘱处理库存(检查,检验类医嘱)
/// Input:		医嘱明细rowid(长期医嘱传入执行记录rowid--oeore)
/// Return:		0,成功；非0，错误 
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ReturnByTariff("6685||187")
ClassMethod ReturnByTariff(oeore) As %Library.String
{
	n (oeore)
	q:oeore="" 0
	s priorCode=..PriorityCode(oeore)
	s:priorCode'="S" oeore=$p(oeore,"||",1,2)
	q:priorCode["OM" 0
	
	s oeori=$p(oeore,"||",1,2)
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" 0
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	q:inci'="" 0

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s dispType=$p(IntrTypeInfo,"^",1)
	s intrType=$p(IntrTypeInfo,"^",2)
	
	;避免重复处理
	q:$d(^DHCINTR(0,"TypePointer",intrType,oeori)) 0

	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)		;处方号
	s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))

	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	s err=0

	tstart
	s trid=""
	f  s trid=$o(^DHCINTR(0,"TypePointer",dispType,oeore,trid)) q:(trid="")!(err>0)  d
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s inclb=$p(^DHCINTR(trid),"^",7)
	.;不是材料的过滤
	.s inci=$p(^DHCINTR(trid),"^",15)
	.q:inci=""
	.s stkCatGrpType=..GetItmStkGrpType(inci)
	.q:stkCatGrpType'="M"
	.s qty=$p(^DHCINTR(trid),"^",6)
	.s rp=$p(^DHCINTR(trid),"^",16)
	.s ucost=$p(^DHCINTR(trid),"^",14)
	.s qty=-qty
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	.s:ret<0 err =1
	.q:ret<0
	.s inci=+inclb
	.s buomDr=$p(^INCI(inci,1),"^",10)
	.s rpamt=rp*qty
	.s spamt=ucost*qty
	.s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_ucost_"^"_userid_"^"_oeore_"^"_rp_"^"_rpamt_"^"_spamt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	.s:RtnObj.success'=0 err=2

	i err>0 d
	.trollback 1
	.l -^DHCOEDISPENSING(oeori)
	q:err>0 err

	tcommit
	l -^DHCOEDISPENSING(oeori)
	q 0
}

/// 取医嘱优先级代码
ClassMethod PriorityCode(ori As %String) As %String
{
	n (ori)
	s Oeord=$p(ori,"||",1),Ch=$p(ori,"||",2)
	q:Oeord="" ""
	q:Ch="" ""
	s priority=$p($G(^OEORD(Oeord,"I",Ch,1)),"^",8)
	q:priority="" ""
	q:'$d(^OECPR(priority)) ""
	s priorCode=$p($G(^OECPR(priority)),"^",1)
	q priorCode
}

/// Description:没有库存记录时插入库存和批次记录为0的记录
/// Creator:	zhangxiao
/// CreateDate:	2019-09-11
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).InsertIncil(1,118)
ClassMethod InsertIncil(LocId, Inci) As %Library.String
{
	n (LocId,Inci)
	q:((LocId="")||(Inci="")) ""
	s Uom=$p(^INCI(Inci,3),"^",6)
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,Uom,"")
	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,Uom,"")

	s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
	s (Bat,Exp,VendorId,ManfId,Sourceoffund,SpecList,giftFlag,adjCheque,SterilizedBat,DetailId,Tax,HVBarCode,ProduceDate)=""
	s NewSpAsSp="N"
	i +Info>0 d
	.s VendorId=$p(^DHCITMINFO(Info),"^",24)
	.s ManfId=$p(^DHCITMINFO(Info),"^",25)
	s Incib=##class(web.DHCSTMHUI.DHCINGdRec).GetBatNo(Inci, Bat, Exp, Rp, Uom, ManfId, VendorId, Sourceoffund, SpecList, giftFlag, adjCheque, NewSpAsSp, SterilizedBat, DetailId, Tax, ProduceDate, HVBarCode, Sp)
	s DhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	
	i DhcIncib="" d
	.s BuomDr=$p(^INCI(+Incib,1),"^",10)
	.s PuruomDr=$p(^INCI(+Incib,3),"^",6)
	.s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
	.s BRp=Rp/PFac
	.s BSp=Sp/PFac
	.s Dhcingri=""
	.s Date=+$H
	.s Time=$p($H,",",2)
	.&sql(insert into dhc_incitmbat(INCIB_INCIB_Dr,INCIB_ProduceDate,INCIB_Rp,INCIB_RpPuruom,INCIB_Sp,
		INCIB_SpPuruom,INCIB_PHMNF_Dr,INCIB_APCVM_Dr,INCIB_INGRI_Dr,INCIB_DateAdd,INCIB_TimeAdd,INCIB_SourceOfFund,INCIB_SpecList,INCIB_GiftFlag,INCIB_AdjCheque,INCIB_SterilizedBat,INCIB_DetailId,INCIB_Tax,INCIB_BarCode) 
		values (:Incib,:ProduceDate,:BRp,:Rp,:BSp,
		:Sp,:ManfId,:VendorId,:Dhcingri,:Date,:Time,:Sourceoffund,:SpecList,:giftFlag,:adjCheque,:SterilizedBat,:DetailId,:Tax,:HVBarCode))
	
	s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStockForImp(Inci,LocId,Incib,0)
	q Ret
}

/// Description:提供接口按照收费项配置减库存时判断库存
/// Creator:	zhangxiao
/// CreateDate:	2020-03-20
/// Table:		DHC_InciLinkTar
/// Input:		LocId - 接收科室id，Arcim-医嘱项id，Qty-数量
/// Output:		
/// Return:		0:成功, 其他:失败
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CheckforDispByTariff(
ClassMethod CheckforDispByTariff(LocId As %String, Arcim As %String, Qty As %Float) As %String
{
	n (LocId,Arcim,Qty)
	s Ret=""
	q:((LocId="")||(Arcim="")||(Qty="")) Ret
	s Inci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),""))
	q:Inci'="" Ret
	
	s InstZ=""
	f  s InstZ=$o(^DHCOLT(0,"ARCIM",Arcim,InstZ)) q:(InstZ="")  d
	.s OltStartDate=""
	.f  s OltStartDate=$o(^DHCOLT(0,"ARCIM",Arcim,InstZ,OltStartDate)) q:(OltStartDate="")  d
	..q:(OltStartDate'="")&&(OltStartDate>+$h)
	..s Olt=""
	..f  s Olt=$o(^DHCOLT(0,"ARCIM",Arcim,InstZ,OltStartDate,Olt)) q:(Olt="")  d
	...s OltEndDate=$p(^DHCOLT(Olt),"^",5)
	...q:((OltEndDate'="")&&(OltEndDate<+$H))
	...s tariff=$p(^DHCOLT(Olt),"^",2)
	...q:'$d(^DHCILT(0,"Tariff",tariff))
	...s oltqty=+$p(^DHCOLT(Olt),"^",3)   //计费数量(一个医嘱项对应多个收费项数量)
	...s LinkId=0
	...f  s LinkId=$o(^DHCILT(0,"Tariff",tariff,LinkId)) q:(LinkId="")  d
	....s InciId=$p(^DHCILT(LinkId),"^",1)
	....s LinkQty=$p(^DHCILT(LinkId),"^",3)
	....s UomId=$p(^DHCILT(LinkId),"^",4)
	....s BuomDr=$p(^INCI(InciId,1),"^",10)
	....s Confac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BuomDr)
	....s bqty=LinkQty*Confac*oltqty*Qty 
	....s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(LocId,InciId,BuomDr)
	....i AvaQty<bqty d
	.....s InciDesc=$p(^INCI(InciId,1),"^",2)
	.....s TmpRet=InciDesc_"库存不足"
	.....i Ret="" d
	......s Ret=TmpRet
	.....e  d
	......s Ret=Ret_"^"_TmpRet
	
	q Ret
}

/// Description:按照收费项关联分组标记减库存
/// Creator:	qiushengxin
/// CreateDate:	2020-01-20
/// Table:		DHC_InciLinkTar
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).SelClbQtyM(360,1,1)
ClassMethod SelClbQtyM(oeori, loc, dspqty, linkgroup, tariff) As %Library.String
{
	n (oeori,loc,dspqty,linkgroup,tariff)
	s ord=+oeori,itm=$p(oeori,"||",2)
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	s err=0
	i linkgroup'="" d
	.s Pid=..SelInciByLinkGroup(loc, linkgroup,tariff)
	.s ExpDay=""
	.f  s ExpDay=$o(^TMPDHCSTM(Pid,"SelInciByLinkGroup",ExpDay)) q:(ExpDay="")||(dspqty=0)||(err'=0)  d
	..s inci=""
	..f  s inci=$o(^TMPDHCSTM(Pid,"SelInciByLinkGroup",ExpDay,inci)) q:(inci="")||(dspqty=0)||(err'=0)  d
	...s Inclb=""
	...f  s Inclb=$o(^TMPDHCSTM(Pid,"SelInciByLinkGroup",ExpDay,inci,Inclb)) q:(Inclb="")||(dspqty=0)||(err'=0)  d
	....s incibdr=""
	....f  s incibdr=$o(^TMPDHCSTM(Pid,"SelInciByLinkGroup",ExpDay,inci,Inclb,incibdr)) q:(incibdr="")||(dspqty=0)||(err'=0)  d
	.....s Data=$g(^TMPDHCSTM(Pid,"SelInciByLinkGroup",ExpDay,inci,Inclb,incibdr))
	.....s:Data="" err=-3
	.....q:Data=""
	.....s incil=$p(Data,"^",1)
	.....s Inci=$p(incil,"||",1)
	.....s inclbQty=$p(Data,"^",2)
	.....s buomDr=$p(^INCI(Inci,1),"^",10)
	.....i (inclbQty-dspqty'<0)&&(dspqty>0) d
	......s inclb=Inclb
	......s qty=-dspqty
	......s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	......s:ret<0 err=-1
	......q:ret<0
	......s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,"")				;单价
	......s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")	;批次进价
	......s rpamt=rp*qty
	......s spamt=sp*qty
	......s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpamt_"^"_spamt
	......s ret=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	......s:ret<0 err=-2
	......s dspqty=0
	.....i (inclbQty-dspqty<0)&&(dspqty>0) d
	......s newdspqty=dspqty-inclbQty
	......s dspqty=newdspqty
	......s inclb=Inclb
	......s qty=inclbQty
	......s qty=-qty
	......s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	......s:ret<0 err=-1
	......q:ret<0
	......s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,"")				;单价
	......s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")	;批次进价
	......s rpamt=rp*qty
	......s spamt=sp*qty
	......s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpamt_"^"_spamt
	......s ret=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	......s:ret<0 err=-2
	k ^Tmp("DHCSTM","web.DHCSTMHUI.Common.DHCSTPCHCOLLSM","SelInciByLinkGroup")
	q err
}

/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).SelInciByLinkGroup(360,1,1)
ClassMethod SelInciByLinkGroup(Loc, LinkGroup, tariff) As %Library.String
{
	n (Loc,LinkGroup,tariff)
	s Pid=..NewPid() 
	k ^TMPDHCSTM(Pid,"SelInciByLinkGroup")
	&sql(DECLARE CurrLinkGroup CURSOR FOR
		SELECT ILT_INCI_DR FROM DHC_InciLinkTar
		WHERE ILT_Group=:LinkGroup AND ILT_Tariff_DR=:tariff)
	&sql(open CurrLinkGroup)
	s num=0
	f  &sql(fetch CurrLinkGroup INTO :ILTINCI) q:SQLCODE  d
	.s ch=""
	.f  s ch=$o(^INCI("IL_LOC",Loc,ILTINCI,ch)) q:ch=""  d
	..s incil=ILTINCI_"||"_ch
	..s LogQty=$p(^INCI(ILTINCI,"IL",ch),"^",3)
	..s ReservedQty=$p(^INCI(ILTINCI,"IL",ch),"^",6)
	..s DirtyQty=$p(^INCI(ILTINCI,"IL",ch),"^",9)
	..s AvailQty=LogQty-ReservedQty-DirtyQty
	..s inclbsub=0
	..f  s inclbsub=$o(^INCI(ILTINCI,"IL",ch,"LB",inclbsub)) q:inclbsub=""  d
	...s inclb=ILTINCI_"||"_ch_"||"_inclbsub
	...s inclbQty=$p(^INCI(ILTINCI,"IL",ch,"LB",inclbsub),"^",2)
	...s incib=$p(^INCI(ILTINCI,"IL",ch,"LB",inclbsub),"^",1)
	...q:incib=""
	...s ExpDays=0      ;失效天数
	...s ExpDate=+$p(^INCI(ILTINCI,"IB",$p(incib,"||",2)),"^",2)
	...i ExpDate=0  d
	....s ExpDate=+$h+500
	...i ExpDate=+$h  s ExpDays=1
	...e  s ExpDays=ExpDate-(+$h)
	...s reccallflag=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",3)
	...q:reccallflag="Y"     ///批次锁定
	...i inclbQty>0 d
	....s ^TMPDHCSTM(Pid,"SelInciByLinkGroup",ExpDays,ILTINCI,inclb,incib)=incil_"^"_inclbQty
	&sql(close CurrLinkGroup)
	q Pid
}

/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CreateRecByOeori("14||341")
ClassMethod CreateRecByOeori(oeori)
{
	n (oeori)
	s ord=+oeori,chl=$p(oeori,"||",2)
	q:(ord="")!(chl="") -1
	s hvm=$o(^DHCHVMORI(0,"OEORI",oeori,""))
	q:hvm="" -2
	s HvmInfo1=^DHCHVMORI(hvm,1)
	s mainloc=$p(HvmInfo1,"^",42)
	
	s MainInfo={}
	s MainInfo.Loc=mainloc
	s nMainInfo=MainInfo.%ToJSON()
	
	s ListDetail={}
	s ListDetail.RowId=hvm
	s nListDetail=ListDetail.%ToJSON()
	s nListDetail="["_nListDetail_"]"
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RtnObjJson=##class(web.DHCSTMHUI.HVMatOrdItm).Create(nMainInfo,nListDetail)
	s RtnObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=RtnObj.%FromJSON(RtnObjJson)
	s success=RtnObj.%Get("success")
	q:success'=0 -3
	
	q 0
}

/// 依据医嘱项判断是否存在关联库存项（包含库存项关联计费项功能）
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CheckIncLTar(arcim)
ClassMethod CheckIncLTar(arcim)
{
	n (arcim)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	
	s Ret="N"
	i inci'="" d
	.s stkCatGrpType=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetItmStkGrpType(inci)
	.i stkCatGrpType="M" s Ret="Y"
	e  d
	.s InstZ=""
	.f  s InstZ=$o(^DHCOLT(0,"ARCIM",arcim,InstZ)) q:(InstZ="")||(Ret="Y")  d
	..s OltStartDate=""
	..f  s OltStartDate=$o(^DHCOLT(0,"ARCIM",arcim,InstZ,OltStartDate)) q:(OltStartDate="")||(Ret="Y")  d
	...q:(OltStartDate'="")&&(OltStartDate>+$h)
	...s Olt=""
	...f  s Olt=$o(^DHCOLT(0,"ARCIM",arcim,InstZ,OltStartDate,Olt)) q:(Olt="")||(Ret="Y")  d
	....s OltEndDate=$p(^DHCOLT(Olt),"^",5)
	....q:(OltEndDate'="")
	....s tariff=$p(^DHCOLT(Olt),"^",2)
	....s Inci=..GetInciByTariff(tariff)
	....i Inci'="" s Ret="Y"
	....q:Inci'=""
	....q:'$d(^DHCILT(0,"Tariff",tariff))
	....s Ret="Y"
	
	q Ret
}

/// Description:根据收费项获取库存项Rowid
/// Creator:wxj
/// Date:2023-03-16
/// Input:Arcim:医嘱项Rowid
/// Output:Inci:库存项Rowid
/// Remark:入参所指医嘱项未关联有效库存项,但其关联的收费项本身存在有效的库存项
/// w ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetInciByTariff(3507)
ClassMethod GetInciByTariff(Tariff As %String)
{
	n (Tariff)
	s Type=..sssCode()
	s Inci=""
	s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"TAR",Tariff,StartDate)) q:(StartDate="")||(Inci'="")  d
	.q:(StartDate="")||(StartDate>+$h)
	.s LinkId=""
	.f  s LinkId=$o(^DHCOLT(0,"TAR",Tariff,StartDate,LinkId)) q:(LinkId="")||(Inci'="")  d
	..s EndDate=$p(^DHCOLT(LinkId),"^",5)
	..q:(EndDate'="")&&(EndDate<+$h)
	..s Arcim=$p(^DHCOLT(LinkId),"^",1)
	..q:..ChkWoStock(Arcim)=1
	..s TempInci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),""))
	..q:TempInci=""
	..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(TempInci)
	..s StkType=$p(ScgInfo,"^",3)
	..q:StkType'=Type
	..s Inci=TempInci
	q Inci
}

}
