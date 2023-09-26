Import sqluser

/// Description:移动药房公共核心业务方法类
/// Creator:    hulihua
/// CreateDate: 2017-04-06
/// Table:      
Class web.DHCINPHA.MTCommon.PublicServiceMethod Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCINPHACOMMON";

/// Description:获取移动药房参数配置属性
/// Creator:    hulihua
/// CreateDate: 2017-05-27
/// Table:
/// Input:		安全组id,科室id,用户id
/// Output:     
/// Return：	待摆药病区行数^待摆药病区列数^待摆药病区刷新时间^草药处方护士提交控制标志
/// 			是否使用揭药室标志
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetParamProp("^245^^2")
ClassMethod GetParamProp(Param As %String) As %Library.String
{
	n (Param)
	s GroupId=$p(Param,"^",1)
	s LocId=$p(Param,"^",2)
	s UserId=$p(Param,"^",3)
	s HospId=$p(Param,"^",4)   
	s:(HospId="")&&(LocId'="") HospId=$p(^CTLOC(LocId),"^",22),$p(Param,"^",4)=HospId
	s AppName=..%GetParameter("AppName")
	s WardSeatRow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"WardSeatRow",Param)
	s WardSeatCol=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"WardSeatCol",Param)
	s RefreshTime=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RefreshTime",Param)
	s NurseSubFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"NurseSubFlag",Param)
	s IfAgreeReturn=##class(web.DHCST.Common.AppCommon).GetAppPropValue("HERB.PC","IfAgreeReturn",Param)
	s InvokPatchFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"IfInvokDispatch",Param)
	s PatchProCode=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PatchProCode",Param)
	s UseMedBroFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"UseMedBroFlag",Param)
	;
	s Data1=WardSeatRow_"^"_WardSeatCol_"^"_RefreshTime_"^"_NurseSubFlag_"^"_IfAgreeReturn
	s Data2=InvokPatchFlag_"^"_PatchProCode_"^"_UseMedBroFlag
	q Data1_"^"_Data2
}

/// Description:获取病区列表是否改变背景颜色（送药必须所有的请领单都开始备就灭灯，取药只要开始即可灭灯）
/// Creator:	hulihua
/// CreateDate:	2017-04-25
/// Table:      DHC_InPhReq
/// Input:		PhaLocID-药房科室ID、WardLocID-病区科室ID
/// Output:		
/// Return： 	1-灭灯,0-不灭灯   
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).KillMesFlag()
ClassMethod KillMesFlag(PhaLocID As %String, WardLocID As %String)
{
	n (PhaLocID,WardLocID)
	s InPhReqStatue=10		//判断所有未开始备药的请领单
	s KillFlag=1
	s InPhReq=""
	f  s InPhReq=$o(^DHCINPHREQi("DispLocDate",PhaLocID,+$h,InPhReqStatue,WardLocID,InPhReq),-1)  q:InPhReq=""  d
	.s InPhReqType=$p(^DHCINPHREQ(InPhReq),"^",7)
	.s:InPhReqType="1" KillFlag=0
	q KillFlag
}

/// Description:通用的判断打包记录是否可以发药
/// Creator:	hulihua
/// CreateDate:	2017-04-06
/// Table:      DHC_InPhReq、DHC_InPhReqItm
/// Input:		DspId-打包表ID，InPhReqDr-请领子表ID，PhdrawOrderId-备药孙表ID
/// Output:		
/// Return： 	0-不可发药,1-可发药 
/// Others:		调用此方法-GetDispWard,GetDispDrug 
/// Modify:		增加备药孙表的入参用于装箱等操作的时候同一个打包记录有多个请领单的情况！ 
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDispFlag("11824860","114528||1")
ClassMethod GetDispFlag(DspId As %String, InPhReqDr As %String = "") As %String
{
 n (DspId,InPhReqDr)
 s dispFlag=0,phreqFlag=0
 q:'$d(^DHCOEDISQTY(DspId)) dispFlag 
 ;判断请领单的状态
 i InPhReqDr'=""  d
 .s InPhReq=+InPhReqDr
 .q:InPhReq=0
 .s InPhReqStatue=$p(^DHCINPHREQ(InPhReq),"^",8)
 .q:InPhReqStatue="05"
 .s InPhReqIStatue=$p(^DHCINPHREQ(+InPhReqDr,"I",$p(InPhReqDr,"||",2)),"^",2)
 .q:InPhReqIStatue="05"
 .s phreqFlag=1
 e  d
 .s InPhReq=$o(^DHCINPHREQi("DSP",DspId,""),-1)
 .q:InPhReq="" 
 .s InPhReqStatue=$p(^DHCINPHREQ(InPhReq),"^",8)
 .q:InPhReqStatue="05" 								//请领主表的状态
 .s InPhReqCh=$o(^DHCINPHREQi("DSP",DspId,InPhReq,""),-1)
 .q:InPhReqCh="" 
 .s InPhReqIStatue=$p(^DHCINPHREQ(InPhReq,"I",InPhReqCh),"^",2)
 .q:InPhReqIStatue="05" 							//请领明细的状态
 .s phreqFlag=1
 q:phreqFlag=0 dispFlag
 ;判断医嘱相关的操作状态
 q:$p(^DHCOEDISQTY(DspId),"^",7)'="TC" dispFlag
 s phaloc=$p(^DHCOEDISQTY(DspId),"^",24)
 q:phaloc="" dispFlag
 s HospId=$p($g(^CTLOC(phaloc)),"^",22)
 s Params="^"_phaloc_"^^"_HospId
 s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
 s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     		//OE_OrdItem表指针
 s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     		//OE_OrdExec表指针
 s Ord=+OrdExeRowid
 s Chl=$p(OrdExeRowid,"||",2)
 s OreChl=$p(OrdExeRowid,"||",3)
 q:Ord="" dispFlag
 q:Chl="" dispFlag
 q:'$d(^OEORD(Ord)) dispFlag
 s arcim=$p($g(^OEORD(Ord,"I",Chl,1)),"^",2)
 q:arcim="" dispFlag
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s arcimcat=$P(^ARCIM(sub,ver,1),"^",10)
 q:arcimcat="" dispFlag
 s ArcCatCode=$p(^ARC("IC",arcimcat),"^",1)	
 s AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
 q:AdmDr="" dispFlag
 s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
 q:AdmType'="I" dispFlag
 s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
 q:PriorDr="" dispFlag  						;优先级不存在的不予发放
 s Priority=$p(^OECPR(PriorDr),"^",1) 			;医嘱优先级代码              
 q:Priority["OM" dispFlag 		;自备药
 q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0 dispFlag ;判断执行记录状态是否可配药				2018-8-17 移动药房不判断停止医嘱 发了的走 手动退药
 q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)=0 dispFlag //护士审核
 q:##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId)'="Y" dispFlag //-11 //禁忌审核不通过 zhouyg 20150108
 s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(AdmDr,arcimcat_"^"_Priority)  ;最终结算,则不发药
 q:AmtFlag=0 dispFlag
 q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId) dispFlag ;被拒绝发放
 s DoctorLoc=$p(^OEORD(Ord,"I",Chl,7),"^",2)   		;060725
 q:##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phaloc,DoctorLoc)=1 dispFlag ;病区发药时过滤掉医生科室
 s SkinTest=##class(web.DHCSTPCHCOLLS2).SkinTest(OrdItmRowid)
 s inst=$p($g(^OEORD(Ord,"I",Chl,2)),"^",7)
 i inst'="" s inst=$p($g(^PHCIN(inst)),"^",2)
 q:(NeedSkinTest="Y")&&(SkinTest<0)&&(inst'["皮试") dispFlag
 s dispFlag=1
 q dispFlag
}

/// Description:重新判断dhc_oedispensing状态
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_OEDispensing-新医嘱打包表
/// Input:		dodiss-打包记录串，dispflag-判断标志（0-不可发，1-可发）
/// Output:
/// Return：    重新获取的打包记录串
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).ReGetDodis("7591,7592,7593","0")
ClassMethod ReGetDodis(dodiss As %String, dispflag As %String) As %String
{
	n (dodiss,dispflag)
	s result=""
	q:dodiss="" result
	s dodiss=$tr(dodiss,"^",",") 
	s cnt=$l(dodiss,",")
	f i=1:1:cnt d
	.s dodis=$p(dodiss,",",i)
	.s dspdispflag=..GetDispFlag(dodis)
 	.q:dspdispflag'=dispflag
 	.s result=$s(result="":dodis,1:result_","_dodis)
	q result
}

/// Description:根据dodis串，汇总应发药数量
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_OEDispensing-新医嘱打包表
/// Input:		dodiss-打包记录串
/// Output:
/// Return：    应发药数量
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).CalDspQty("")
ClassMethod CalDspQty(dodiss As %String) As %String
{
	n (dodiss)
	s totalQty=0
	q:dodiss="" totalQty
	s cnt=$l(dodiss,",")
	f i=1:1:cnt d
	. s dodis=$p(dodiss,",",i)
	. q:$p(^DHCOEDISQTY(dodis),"^",7)'="TC" 
	. s qty=$p(^DHCOEDISQTY(dodis),"^",11) 
	. s totalQty=totalQty+qty
	q totalQty
}

/// Description:通过备药主表和打包串获取某药品的实际应该发药数量
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_PHDraw备药单主表、DHC_PHDrawInc备药单子表（药品汇总）、DHC_PHDrawOrder备药单孙表（医嘱明细表）
/// Input:		备药主表串、dodissbatch-有效打包子表串、DspFlag-发药模式（0-正常发药减库，1-库存返回）
/// Output:
/// Return：    实际需要发药的数量（不包含撤销的）^备药孙表串
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDspPhdrQty("120","17936||1","1")
ClassMethod GetDspPhdrQty(wardphdrstr As %String, dodissbatch As %String, DspFlag As %String = "") As %String
{
	n (wardphdrstr, dodissbatch, DspFlag)
	s sumphdrqty=0,phdrsubidstr="",phdrefflag=""
	s inci=$p(^DHCOEDISQTY(+dodissbatch,"I",$p(dodissbatch,"||",2)),"^",5)
	s len=$l(wardphdrstr,"#")
	f j=1:1:len  d
	.s phdrid=$p(wardphdrstr,"#",j)
	.q:phdrid=""
	.s phdrincich=$o(^DHCPHDRAWi("INCI",inci,phdrid,""),-1)
	.q:phdrincich=""
	.s phdrch=$o(^DHCPHDRAWi("DSPBATCH",dodissbatch,phdrid,""),-1)
	.q:phdrch=""
	.s phdrsub=$o(^DHCPHDRAWi("DSPBATCH",dodissbatch,phdrid,phdrch,""),-1)
	.q:phdrsub=""
	.s phdrefflag=$p(^DHCPHDRAW(phdrid,"INC",phdrch,"ORDER",phdrsub),"^",3)
	.q:(DspFlag'="1")&&(phdrefflag="Y")   
	.s phdrqty=$p(^DHCPHDRAW(phdrid,"INC",phdrch,"ORDER",phdrsub),"^",2)
	.s phdrsubid=phdrid_"||"_phdrch_"||"_phdrsub
	.s sumphdrqty=sumphdrqty+phdrqty
	.s phdrsubidstr=$s(phdrsubidstr="":phdrsubid,1:phdrsubidstr_","_phdrsubid)
	q sumphdrqty_"^"_phdrsubidstr_"^"_phdrefflag
}

/// Description:通过备药孙表从台帐里面获取批次信息和批次数量
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_PHDrawOrder备药单孙表（医嘱明细表）、DHC_INTRANS
/// Input:		备药孙表ID串、计数器
/// Output:		批次信息临时global
/// Return：	批次信息临时global数量    
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetInclbQty("73||1||1","1")
ClassMethod GetInclbQty(phdrsubidstr As %String, pid As %String) As %String
{
	n (phdrsubidstr, pid)
	k ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid,"INCLB")
	s len=$l(phdrsubidstr,",")
	s i=0
	f j=1:1:len d
	.s phdrsubid=$p(phdrsubidstr,",",j)
	.q:phdrsubid=""
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypePointer","L",phdrsubid,intr))  q:intr=""  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..s qty=$p(^DHCINTR(intr),"^",6)
	..s sp=$p(^DHCINTR(intr),"^",14)
	..s spamt=$p(^DHCINTR(intr),"^",8)
	..s rp=$p(^DHCINTR(intr),"^",16)
	..s rpamt=$p(^DHCINTR(intr),"^",17)
	..s ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid,"INCLB",inclb)=qty_"^"_sp_"^"_spamt_"^"_rp_"^"_rpamt_"^"_intr
	..s i=i+1
	.
	q i
}

/// Description:药房备药的时候按照备药孙表处理库存以及增加台帐（移动端备药调用）
/// Creator:	hulihua
/// CreateDate:	2017-04-18
/// Table:      DHC_PHDrawOrder
/// Input:		备药孙表ID、UserId-备药人ID
/// Output:
/// Return：   
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).HandleDispStock("50550||1||1","5774","1")
ClassMethod HandleDispStock(listData As %String, usercompid As %String, pid As %String) As %String
{
	n (listData, usercompid,pid)
	s phdrsubid=listData
	q:phdrsubid="" ""
	s phdr=+phdrsubid
	s PhacLoc=$p(^DHCPHDRAW(phdr),"^",2)
	s HospID=$p($g(^CTLOC(PhacLoc)),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	i RuleFlag=3 d
	.s Err=..HandleStockByBatch(phdrsubid,usercompid,pid)
	e  d
	.s Err=..HandleStock(phdrsubid,usercompid,pid)
	q:Err'=0 Err
	q 0
}

/// Description:非批次价按照备药孙表处理库存以及增加台帐
/// Creator:	hulihua
/// CreateDate:	2017-04-18
/// Table:      DHC_PHDrawOrder
/// Input:		备药孙表ID
/// Output:
/// Return：   
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).HandleStock("")
ClassMethod HandleStock(phdrsubid As %String, usercompid As %String, pid As %String) As %String
{
	n (phdrsubid, usercompid, pid)
	q:phdrsubid="" -1
	s phdr=+phdrsubid
	s phdrch=+$p(phdrsubid,"||",2)
	s phdrsub=+$p(phdrsubid,"||",3)
	q:'$d(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub)) -2
	s dspbid=$p(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub),"^",1)
	q:dspbid="" -3
	s dsp=+dspbid
	s inci=$p(^DHCPHDRAW(phdr,"INC",phdrch),"^",1)
	q:inci="" -4
	s recloc=$p($g(^DHCOEDISQTY(dsp)),"^",24)
	q:recloc="" -5
	s ch=$o(^INCI("IL_LOC",recloc,inci,"")) 
	q:ch="" -6
	s incil=inci_"||"_ch
	s HospID=$p(^CTLOC(recloc),"^",22)
	l +^DHCINPHAHandleStock(dsp):5  e  q -1000   					;加锁
	s confqty=$p(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub),"^",2)
	i confqty=0 l -^DHCINPHAHandleStock(dsp) q -7
	i pid<0 d Unlock
	q:pid<0 -8
	s err=0
	tstart
	s $ZT="Error^DHCSTERROR"										;增加错误处理
	s cnt=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,confqty,recloc,pid)
	i cnt<=0 trollback  d Unlock
	q:cnt<=0 -9 									;即库存不够的情况
	s ret=##class(web.DHCST01).UPDINVRESQTY(inci,recloc,-confqty)	//处理在途数
	i ret=0 s err=-10
	i err'=0 trollback  d Unlock
 	q:err'=0 err
	s SqlStr=incil_"^"_3_"^"_confqty_"^"_""_"^"_dsp_"^"_recloc
 	s ret=##Class(User.DHCIncReservedQtyDetail).Insert(SqlStr)		//记录在途明细
 	i ret'>0 s err=-11
	i err'=0 trollback  d Unlock
 	q:err'=0 err
	s ItmCode=$p(^INCI(inci,1),"^",1)
	s drawno=$p(^DHCPHDRAW(phdr),"^",1)
 	s uom=$p(^DHCPHDRAW(phdr,"INC",phdrch),"^",4)
 	s UomDesc=$p(^CT("UOM",uom),"^",2)
 	s user=$p(^DHCPHDRAW(phdr,"INC",phdrch),"^",6)
 	s:user="" user=usercompid
 	s type="L"
 	s pointer=phdrsubid
	s newclb=""
	f  s newclb=$o(^TMPGETINCLB(pid,newclb)) q:(newclb="")!(err'=0)  d
	.s inclb=$p(^TMPGETINCLB(pid,newclb),"^",2)
	.s qty=$p(^TMPGETINCLB(pid,newclb),"^",1)
	.s buom=$P(^INCI(inci,1),"^",10)
	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	.s qty=qty*fac
	.s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,HospID,"G",+$h,"")
	.s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,HospID,"G","")
    .s Data=type_"^"_drawno_"^"_inclb_"^"_-qty_"^"_UomDesc_"^"_ItmCode_"^"_sp_"^"_user_"^"_pointer_"^^"_rp
	.s ret=##class(web.DHCST01).UPDINCI(Data)						//处理库存插入台帐
	.i ret=0 s err=-12
	.q:ret=0  
	i err'=0 trollback  d Unlock
 	q:err'=0 err
 	s Ret=..UpDspBatStatus(dspbid,"C")
 	s:Ret<0 err=-13
 	i err'=0 trollback  d Unlock
 	q:err'=0 err
 	;提交事务
 	tcommit
 	d Unlock
 	q 0
	
Unlock		;去锁
	l -^DHCINPHAHandleStock(dsp)  
	k ^TMPGETINCLB(pid)
	q
}

/// Description:批次价按照备药孙表处理库存以及增加台帐
/// Creator:	hulihua
/// CreateDate:	2017-04-18
/// Table:      DHC_PHDrawOrder
/// Input:		备药孙表ID
/// Output:
/// Return：   
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).HandleStockByBatch("50550||1||1","5774","1")
ClassMethod HandleStockByBatch(phdrsubid As %String, usercompid As %String, pid As %String) As %String
{
	n (phdrsubid, usercompid, pid)
	q:pid<0 "-1^计数器为0！"	
	q:phdrsubid="" "-2^备药孙表ID为空！"
	s phdr=+phdrsubid
	s phdrch=+$p(phdrsubid,"||",2)
	s phdrsub=+$p(phdrsubid,"||",3)
	q:'$d(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub)) "-3^备药孙表记录不存在！"
	s dspbatchID=$p(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub),"^",1)
	q:dspbatchID="" "-4^打包子表为空！"
	s dspID=+dspbatchID
	s dspSubId=$p(dspbatchID,"||",2)
	q:'$d(^DHCOEDISQTY(dspID,"I",dspSubId)) 0
	s oeori=$p(^DHCOEDISQTY(dspID),"^",1)
	s inci=$p(^DHCPHDRAW(phdr,"INC",phdrch),"^",1)
	q:inci="" "-5^药品库存项为空！"
	s recloc=$p($g(^DHCOEDISQTY(dspID)),"^",24)
	q:recloc="" "-6^接收科室为空!"
	s ILSub=$o(^INCI("IL_LOC",recloc,inci,"")) 
	q:ILSub="" "-7^科室库存项为空！"
	s incil=inci_"||"_ILSub
	s HospID=$p(^CTLOC(recloc),"^",22)
	s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
	q:'$d(^OEORD(ord,"I",itm)) "-8^医嘱ID为空！"
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" "-9^医嘱项为空！"
	s ArcCatId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",10)
	s PriorDr=$p(^OEORD(ord,"I",itm,1),"^",8) 
	q:PriorDr="" "-10^医嘱优先级为空!"									;优先级不存在的不予发放
	s Priority=$p($g(^OECPR(PriorDr)),"^",1) 							;医嘱优先级
	s confqty=+$p(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub),"^",2)
	q:confqty=0 "-11^备药孙表数量为空！"
	s PhReqId=$p(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub),"^",5)			
	s feePoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(ArcCatId_"^"_Priority_"^"_oeori)
	i $$LK()<0  q "-12^加锁失败！"   									;加锁
	s dsbstatus=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",6)
	i dsbstatus="C" d UK
	q:dsbstatus="C" 0
	s $ZT="Error^DHCSTERROR"											;增加错误处理
	tstart
	s ErrCode=0
	s RetFlag=..GetDspAllInciQty(dspID,pid)
	k ^TMP("DHCST","web.DHCST01","Inclb",pid)  							;用完及时K
	s:RetFlag'=1 ErrCode=-100
	i ErrCode'=0 d
 	.d Exit
 	q:ErrCode'=0 ErrCode_"打包明细有库存不够！"
	s dspInclb=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",1)
	s dspqty=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",2)
	s dspInci=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",5)
	s inci=$s(dspInclb'="":+dspInclb,1:dspInci)
	;处理批次在途
	s minusret=##class(web.DHCST01).UpdInclbResQty(dspInclb,-dspqty) 	
 	s:minusret'=0 ErrCode=-101
 	i ErrCode'=0 d
 	.d Exit
 	q:ErrCode'=0 ErrCode_"^清除批次在途数失败！"
 	;判断医生下医嘱时保存的批次是否够用
 	s dspFlag=..GetDspClb(dspbatchID,pid)								
 	i dspFlag'=1 d
 	.s incil=$p(dspInclb,"||",1,2)
 	.;不够用重新需要分配批次										
 	.s RetCode=##CLASS(web.DHCST01).GetInclbQty(incil,dspqty,pid,1)		
 	.s:RetCode'=1 ErrCode=-102
 	i ErrCode'=0 d
 	.d Exit
 	q:ErrCode'=0 ErrCode_"^库存不足！"
 	;再分配批次前记录下老的价格只记录第一条的因为计费时是按照第一条来收费的
 	s oldRp=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",3) 
 	s oldSp=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",4) 
 	;发药计费,并且配药批次表保存的批次当前库存不足需要重新选择批次发药,删除打包批次表和备药孙表
 	s InsDspbFlag=0				
 	i (dspFlag'=1)&&(feePoint=1) d
 	.s InsDspbFlag=1
 	.s ErrCode=..DelDspBatAndOrder(dspbatchID,phdrsubid)
 	.i ErrCode'=0 s ErrCode=-103
 	.s batsp=+##class(web.DHCSTPRICE).GetSp(dspInclb,+$h,"",HospID,$p($h,",",2))
 	i ErrCode'=0 d
 	.d Exit
 	q:ErrCode'=0 ErrCode_"^重新分配批次删除打包子表记录失败！"
 	;发药计费,库存足够时需重新获取价格,按第一条收费,更新第一条即可
 	i (dspFlag=1)&&(feePoint=1) d 
 	.s batsp=+##class(web.DHCSTPRICE).GetSp(dspInclb,+$h,"",HospID,$p($h,",",2))
 	.i batsp'=oldSp d
 	..;回写打包批次表售价
 	..s $p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",4)=batsp 		
 	.s batsp=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",4)
 	i feePoint=0 s batsp=oldSp	
 	s type="L",pointer=phdrsubid
 	s drawno=$p(^DHCPHDRAW(phdr),"^",1)
 	s ItmCode=$p(^INCI(inci,1),"^",1)
 	s uom=$p(^DHCPHDRAW(phdr,"INC",phdrch),"^",4)
 	s UomDesc=$p(^CT("UOM",uom),"^",2)
 	s user=$p(^DHCPHDRAW(phdr,"INC",phdrch),"^",6)
 	s:user="" user=usercompid
 	s lbNum=""
 	f  s lbNum=$o(^TMP("DHCST","web.DHCST01","Inclb",pid,lbNum)) q:(lbNum="")!(ErrCode'=0)  d
 	.s inclbStr=^(lbNum)
 	.s rinclb=$p(inclbStr,"^",4)
 	.q:+rinclb'=inci
 	.s rqty=+$p(inclbStr,"^",1)
 	.s sp=batsp  
 	.s rp=+##class(web.DHCSTPRICE).GetRp(rinclb,+$h,"",HospID,$p($h,",",2))
 	.i InsDspbFlag=1 d
 	..;发药计费,并且删除了打包子表和备药孙表的需要按照重新选择的批次重新插入打包子表和备药孙表
 	..s SqlStr=dspID_"^"_rinclb_"^"_rqty_"^"_sp_"^"_rp_"^"_inci_"^C"
 	..s NDspBatch=..InsDspBatch(SqlStr)
 	..s:NDspBatch'>0 ErrCode=-104
 	..q:ErrCode'=0
 	..s SqlStr=$p(phdrsubid,"||",1,2)_"^"_NDspBatch_"^"_rqty_"^"_PhReqId
 	..s PhDrawOrderID=##class(web.DHCINPHA.MTPHDraw.SqlDbPHDraw).InsPHDrawOrder(SqlStr)
 	..s:PhDrawOrderID'>0 ErrCode=-105
 	..s pointer=PhDrawOrderID
 	.e  d
 	..s Ret=..UpDspBatStatus(dspbatchID,"C")
 	..s:Ret<0 ErrCode=-106
 	.q:ErrCode'=0
 	.s Data=type_"^"_drawno_"^"_rinclb_"^"_-rqty_"^"_UomDesc_"^"_ItmCode_"^"_sp_"^"_user_"^"_pointer_"^^"_rp
 	.s ret=##class(web.DHCST01).UPDINCI(Data)
 	.s:ret=0 ErrCode=-107
 	i ErrCode'=0 d
 	.d Exit
	q:ErrCode=-104 ErrCode_"^重新分配批次插入打包子表记录失败！"
	q:ErrCode=-105 ErrCode_"^重新分配批次插入备药孙表记录失败！"
	q:ErrCode=-106 ErrCode_"^修改打包子表发药状态记录失败！"
	q:ErrCode=-107 ErrCode_"^处理库存和台帐失败！"
	q:ErrCode'=0 ErrCode
	tcommit
	d UK
	k ^TMP("DHCST","web.DHCST01","Inclb",pid)
	q 0
	
Exit
	d UK
	k ^TMP("DHCST","web.DHCST01","Inclb",pid) 
	tro	
LK()
	l +^DHCINPHAHandleStock(dspID,"DBL",dspSubId):5  e  q -1
	q 0
UK
	l -^DHCINPHAHandleStock(dspID,"DBL",dspSubId)  ;去锁
	q
}

/// Description:按照发药子表一条条账单
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHACollected--住院发药主表、DHC_PHACollectItm--住院发药子表
/// Input:		phaci-发药子表ID
/// Output:		
/// Return：	0-成功
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).MakeBillPhaci("32||1")
ClassMethod MakeBillPhaci(phaci) As %String
{
	n (phaci)
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTCommon.PublicServiceMethod")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid)
	s phac=+phaci
	s ch=$p(phaci,"||",2)
	s userid=$p(^DHCPHAC(phac),"^",5)
	s adm=$p(^DHCPHAC(phac,"I",ch),"^",3)
	s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
	s orditm=$P(oedis,"||",1,2)
	s ord=+orditm
	s itm=$p(orditm,"||",2)
	q:+itm=0
	s arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2) 
	q:arcim="" 
	s arccat=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",10) //子类
	s priordr=$p(^OEORD(ord,"I",itm,1),"^",8) 
	q:priordr="" 													//优先级不存在的不予发放
	s priority=$p($g(^OECPR(priordr)),"^",1) 						//医嘱优先级
	s feepoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(arccat_"^"_priority_"^"_orditm)
	q:feepoint'=1 
	s dodisstr=$p(^DHCPHAC(phac,"I",ch),"^",13)
	s dodisi=0
	f dodisi=1:1:$l(dodisstr,",") d
	.s dodis=$p(dodisstr,",",dodisi)
	.q:dodis=""
	.s ordexeid=$p($g(^DHCOEDISQTY(dodis)),"^",3)
	.i '$d(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid,adm)) d
	.. s ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid,adm)=ordexeid
	.e  d
	.. s ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid,adm)=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid,adm)_"^"_ordexeid	
	q:'$d(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid)) ""
	s ret=""
	s adm=""
	f  s adm=$o(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid,adm)) q:adm=""  d
	.s str=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid,adm)
	.q:adm=""
	.q:str=""
	.s ret=##Class(web.UDHCJFBILL).BILLN(adm,userid,str,1)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTCommon.PublicServiceMethod","MakeBillPhaci",pid)
	q $g(ret)
}

/// Description:判断某打包记录的批次明细中所有的库存项是否都有可用的批次
/// Creator:	hulihua
/// CreateDate:	2017-11-28
/// Table:      DHC_OEDispensing、DHC_OEDispBatch  
/// Input:		DspId-打包表ID
/// Output:		
/// Return：	0-打包明细记录有库存项库存不足，1-打包明细记录库存都足
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDspAllInciQty("3406960","1")
ClassMethod GetDspAllInciQty(dspId As %Library.String, pid As %String) As %Integer
{
	N (dspId,pid)
  	Q:(dspId="")||(pid="") 0
  	Q:'$D(^DHCOEDISQTY(dspId)) 0
  	S RecLoc=$p($g(^DHCOEDISQTY(dspId)),"^",24)
	Q:RecLoc="" 0
  	K ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid)
  	S dspBatId=0,i=0
	F  S dspBatId=$o(^DHCOEDISQTYi("DSPBStatus","TC",dspId,dspBatId)) Q:dspBatId=""  D
	.Q:'$D(^DHCOEDISQTY(dspId,"I",dspBatId))
	.S dspInci=$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",5)
	.S dspInclb=$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",1)
	.S dspInci=$s(dspInclb'="":+dspInclb,1:+dspInci)
	.Q:dspInci=0
	.S dspQty=+$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",2)
	.S Index=dspInci
	.I $D(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid,Index)) D
	..S ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid,Index)=+$G(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid,Index))+dspQty
	.E  D
	..s i=i+1
	..S ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid,Index)=dspQty
	.
	Q:i=0 0
	S Index="",RetFlag=1
	F  S Index=$O(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid,Index))  Q:(Index="")||(RetFlag'=1)  D
	.S DspQty=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid,Index)
	.S:DspQty=0 RetFlag=0
	.Q:RetFlag'=0
	.S Inci=Index
	.S ILSub=$o(^INCI("IL_LOC",RecLoc,inci,"")) 
	.S:ILSub="" RetFlag=0
	.Q:RetFlag'=0
	.S Incil=Inci_"||"_ILSub
	.S RetCode=##CLASS(web.DHCST01).GetInclbQty(Incil,DspQty,pid,1)
	.S:RetCode'=1 RetFlag=0
	K ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetDspAllInciQty",pid)
	Q RetFlag
}

/// Description:判断开医嘱保存的打包子表的批次库存是否够用
/// Creator:	hulihua
/// CreateDate:	2017-11-28
/// Table:      DHC_OEDispensing、DHC_OEDispBatch  
/// Input:		DspBatchID-DHC_OEDispBatch的ID,进程ID
/// Output:		
/// Return：	1-够用，0-不够用，需要重新取批次
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDspClb("32||1")
ClassMethod GetDspClb(DspBatchID As %String, pid As %String) As %Integer
{
	n (DspBatchID,pid)
	q:DspBatchID="" 0
	s DspID=+DspBatchID
	q:$o(^DHCOEDISQTY(DspID,"I",0))="" 0
	s DspSub=$p(DspBatchID,"||",2)
	q:'$d(^DHCOEDISQTY(DspID,"I",DspSub)) 0
	s inclb=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",1)
	s Inci=+inclb,ilSub=$p(inclb,"||",2),LBSub=$p(inclb,"||",3)
	s Dspqty=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",2)
	s Curqty=##Class(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
	q:Curqty<Dspqty 0
	s incib=$P(^INCI(Inci,"IL",ilSub,"LB",LBSub),"^",1)
	q:incib="" 0
	s IBSub=$p(incib,"||",2)
	q:IBSub="" 0
	q:'$d(^INCI(Inci,"IB",IBSub)) 0
	s ExpDate=+$p($g(^INCI(Inci,"IB",IBSub)),"^",2)
	q:(ExpDate'=0)&&(ExpDate<+$h) 0 				//过滤过期
	q:'$d(^DHCINCLB(0,"LB",inclb)) 0
	s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""),-1)
	s inclbactive=$p($g(^DHCINCLB(dhcinclb)),"^",2)				
	q:inclbactive'="Y" 0							//过滤不可用
	s rp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",3)
	s sp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",4)
	k ^TMP("DHCST","web.DHCST01","Inclb",pid)
	s ^TMP("DHCST","web.DHCST01","Inclb",pid,1)=Dspqty_"^"_sp_"^"_rp_"^"_inclb
	q 1
}

/// Description:对于重新分配批次的需要将下医嘱分配的打包批次表和备药孙表先删除
/// Creator:	hulihua
/// CreateDate:	2017-11-28
/// Table:      DHC_OEDispBatch
/// Input:		dspbatchID-打包表子表ID
/// Output:
/// Return： 	0-成功，-1-参数为空 ，-2-删除打包子表失败，-3-删除备药孙表失败
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).DelDspBatchIn()
ClassMethod DelDspBatAndOrder(DspBatchID As %String, PhdrSubID As %String) As %String
{
	n (DspBatchID,PhdrSubID)
	q:(DspBatchID="")||(PhdrSubID="") -1
	s err=0
	&sql(Delete From DHC_OEDispBatch Where DSPB_RowId=:DspBatchID)
 	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("DelDspBatAndOrder:DHC_OEDispBatch",DspBatchID,SQLCODE_":"_%msg)
 	.s err=-2
 	q:err'=0 err
 	&sql(Delete From DHC_PHDrawOrder Where PHDWO_RowID=:PhdrSubID)
 	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("DelDspBatAndOrder:DHC_PHDrawOrder",PhdrSubID,SQLCODE_":"_%msg)
 	.s err=-3
 	q:err'=0 err
 	q 0
}

/// Description:修改打包子表的状态
/// Creator:	hulihua
/// CreateDate:	2017-11-28
/// Table:      DHC_OEDispBatch
/// Input:		DspBatchID-打包子表ID,DspBatchStatus-打包子表状态
/// Output:
/// Return： 	0-成功，-1-参数为空 ，-2-修改打包子表失败
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpDspBatStatus()
ClassMethod UpDspBatStatus(DspBatchID As %String, DspBatchStatus) As %String
{
	n (DspBatchID,DspBatchStatus)
	q:(DspBatchID="")||(DspBatchStatus="") -1
	s err=0
	&sql(Update DHC_OEDispBatch set DSPB_Status=:DspBatchStatus Where DSPB_RowId=:DspBatchID)
 	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("UpDspBatStatus:DHC_OEDispBatch",DspBatchID_","_DspBatchStatus,SQLCODE_":"_%msg)
 	.s err=-2
 	q:err'=0 err
 	q 0
}

/// Description:对于重新分配批次的需要插入打包批次表
/// Creator:	hulihua
/// CreateDate:	2017-04-18
/// Table:      DHC_OEDispBatch
/// Input:		打包主表ID^科室批次ID^批次数量^售价^进价
/// Output:
/// Return： 	0-成功，空-失败  
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).InsDspBatch()
ClassMethod InsDspBatch(listData As %String) As %String
{
	n (listData)
	k OEDISP
 	s OEDISP(0)=$p(listData,"^",1)
 	s OEDISP(3)=$p(listData,"^",2)
 	s OEDISP(4)=$p(listData,"^",3)
 	s OEDISP(5)=$p(listData,"^",4)
 	s OEDISP(6)=$p(listData,"^",5)
 	s OEDISP(7)=$p(listData,"^",6)
 	s OEDISP(8)=$p(listData,"^",7)
 	s err=0
 	&sql(Insert Into DHC_OEDispBatch Values :OEDISP())
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("InsDspBatch:DHC_OEDispBatch",dspID,SQLCODE_":"_%msg)
 	.s err=-1
 	q:err'=0 ""
 	s dspbatchid=$P(%ROWID,$C(1))
 	q dspbatchid
}

Storage Default
{
<Data name="PublicServiceMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINP1332.PublicServiDDFBD</DataLocation>
<DefaultData>PublicServiceMethodDefaultData</DefaultData>
<IdLocation>^web.DHCINP1332.PublicServiDDFBD</IdLocation>
<IndexLocation>^web.DHCINP1332.PublicServiDDFBI</IndexLocation>
<StreamLocation>^web.DHCINP1332.PublicServiDDFBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
