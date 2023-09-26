Include webimport

IncludeGenerator webimport

/// 2007-01-21
Class web.DHCSTPCHCOLLS Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1442;

ClassMethod CLEARALL() As %Integer
{
	d ..CLEARTMP($j,"D")
	d ..CLEARTMP($j,"D1")
	d ..CLEARTMP($j,"D2")
	d ..CLEARTMP($j,"DISPM")
	d ..CLEARTMP($j,"DISPD")
	d ..CLEARTMP($j,"DispCat")
	q 0
}

ClassMethod CLEARTMP(pid, PAR As %String) As %String
{
	k ^TMP("dhcpha",pid,PAR)
	q 0
}

// description: 费别

ClassMethod GetYBType(adm As %String) As %String
{
	n (adm)
	q:adm="" ""
	s tmp=""
	s papmidr=$p(^PAADM(adm),"^",1)
	s admreasondr=$p(^PAADM(adm,1),"^",7)
	q:admreasondr="" ""
	s admreason=$p(^PAC("ADMREA",admreasondr),"^",2)
	q admreason
}

ClassMethod GetCat(CATCODE As %String) As %String
{
	n (CATCODE)
	s CATCODE=$$ALPHAUP^SSUTIL4(CATCODE)
	s ordcatdr=$o(^ARC("IC",0,"Code",CATCODE,"")) q:ordcatdr="" ""
	s SDG=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:SDG="" ""
	s dispcat=$p(^DHCSTDRUGGRP(SDG),"^",1)
	q dispcat
}

/// create:wyx 2014-05-27
/// 用于批次价模式取价格
ClassMethod getpriceBatch(dspID As %String)
{
	n (dspID)	
	s dapIDBat=$o(^DHCOEDISQTY(dspID,"I","0"))
	s oldSp=$p(^DHCOEDISQTY(dspID,"I",dapIDBat),"^",4) //再分配批次前记录下老的价格只记录第一条的因为计费时是按照第一条来收费的  
	q oldSp
}

ClassMethod getprice(INCITM As %String, STTDATE As %String, LOCDR = "") As %Currency
{
	n (INCITM,STTDATE,LOCDR)
	s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(LOCDR)
	s HospDr=$p(HospString,"^",1)
	q ##class(web.DHCSTCOMMONSRV).GetPriceElse(INCITM,STTDATE,"",HospDr)
}

/// Creator:zhangdongmei
/// CreatDate:2012-02-27
/// Descriprtion:按人发药,直接从配药表检索待发药数据
/// Table:DHC_oedispensing , OE_OrdItem
/// Input:发药科室,pa_adm Rowid,开始日期,结束日期,发药人,长嘱标志,临嘱标志,出院带药标志, 
///     发药类别, 审核标志,起始时间, 结束时间,库存项Rowid
/// Output:npid 进程号
/// Others:save the data into temporary global
ClassMethod PCHCOLLADM(LocId As %String, AdmDr As %String, DateFrom As %String, DateTo As %String, UserId As %String, LFlag As %String, StrSFlag As %String, OutFlag As %String, DispCat As %String, NotAudit As %String, TimeFrom As %String, TimeTo As %String, InciDr As %String, loclog As %String) As %Integer
{
	n (LocId,AdmDr,DateFrom,DateTo,UserId,LFlag,StrSFlag,OutFlag,DispCat,NotAudit,TimeFrom,TimeTo,InciDr,loclog)
	s HospId=$p($g(^CTLOC(LocId)),"^",22)
	s Params="^"_LocId_"^^"_HospId
	s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
	S CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospId) 
	s SFlag=$p(StrSFlag,"||",1)        	;临嘱
	s EmOrdFlag=$p(StrSFlag,"||",2)		;中草药急煎标志
	s PackFlag=$p(StrSFlag,"||",3)   		;整包装？
	s tDispstr=DispCat
	s DispCat=$p(tDispstr,"#",1) //发药类别
	s pristr=$p(tDispstr,"#",2) //本地配置限发
	s npid=..NewPid() ; 
	q:AdmDr="" -1							;不能为空
	;
	s i=0
	s HospID=""
	i LocId'="" d
	.s HospID=$p($g(^CTLOC(LocId)),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	f Date=DateFrom:1:DateTo  d
	.s DspId=0
	.f  s DspId=$o(^DHCOEDISQTY(0,"ADM",LocId,Date,"TC",AdmDr,DspId)) q:DspId=""  d
	..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
	..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
	..s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
	..q:WardLocId=""
	..s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
	..s AdmWard=$p(^PAADM(AdmDr),"^",70)  		;病人当前病房
	..s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
	..q:AdmType'="I"  							;过滤非住院病人     
	..s Ord=+OrdExeRowid
	..s Chl=$p(OrdExeRowid,"||",2)
	..s OreChl=$p(OrdExeRowid,"||",3)
	..q:Ord=""
	..q:Chl=""
	..q:'$d(^OEORD(Ord))
	..q:'$d(^OEORD(Ord,"I",Chl))
	..q:##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId)'="Y" //-11 //禁忌审核不通过 zhouyg 20150108
	..//zhouyg 20141217
	..s Cat=$p(^DHCOEDISQTY(DspId),"^",27)
	..q:Cat=0 //过虑配液医嘱
	..s ret=..DealWithOrdInfo(LocId,LFlag,StrSFlag,OutFlag,tDispstr,OrdItmRowid,Cat,npid)
	..q:ret'=0    ;不需要配药
	..q:'$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"))
	..//q:##class(web.DHCSTPCHCOLLS2).IfPIVA(OrdItmRowid)="1"             //过虑配液医嘱 //2015-02-15 赵志端 
	..s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"),"^",1)  ;医嘱状态
	..s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)          ;医嘱核实、未核实、停止状态 
	..q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0  ;判断该配药记录是否需要配药：执行记录医嘱状态，护士执行状态
	..s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
	..q:(Date=DateFrom)&(TimeDosing'="")&(TimeFrom'="")&(TimeDosing<TimeFrom)
	..q:(Date=DateTo)&(TimeDosing'="")&(TimeTo'="")&(TimeDosing>TimeTo)
	..s ConfirmFlag=$p($g(^DHCOEDISQTY(DspId)),"^",17)
	..//护士领药审核控制
	..q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)=0 //yunhaibao20160223,NotAudit参数已无用
	..q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId)   ;被拒绝发放
	..s SkinTest=##class(web.DHCSTPCHCOLLS2).SkinTest(Ord_"||"_Chl)
	..q:(NeedSkinTest="Y")&&(SkinTest<0)&&(SkinTest'=-5)
	..s Prescno=$p(^OEORD(Ord,"I",Chl,1),"^",14) 		;处方号
	..s Doctor=$p(^OEORD(Ord,"I",Chl,7),"^",1)
	..s DoctorLoc=$p(^OEORD(Ord,"I",Chl,7),"^",2)   		;060725
	..q:..DoctorLocRefuse(LocId,DoctorLoc)=1 				;病区发药时过滤掉医生科室
	..q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId)   ;被拒绝发放
	..s DepLoc=$p(^DHCOEDISQTY(DspId),"^",23) //$p(^PAADM(AdmDr),"^",4) ;病人所在科室,yunhaibao20160324,按打包表记录
	..s BedStr=##class(web.DHCSTCOMMONORDER).GetAdmBedCode(AdmDr,WardLocId)
	..s PatBedId=$p(BedStr,"^",1)
 	..s PatBed=$p(BedStr,"^",2)
	..s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
	..s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
	..s ArcCatCode=$p(^ARC("IC",ArcCatId),"^",1)                       			;医嘱子类代码
	..q:..CatInList(DispCat,Cat)=0  ;If the cat not in the required cat list then quit
	..s PriorDr=$p($g(^OEORD(+Ord,"I",+Chl,1)),"^",8)
	..q:PriorDr=""
	..s Priority=$p($g(^OECPR(PriorDr)),"^",1) 		
	..s feepoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(ArcCatId_"^"_Priority_"^"_OrdItmRowid) 
	..s DateTime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"IP")_","_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP")
	..i TimeDosing'="" S TimeDosing=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP")
	..s Data1=Prescno_"^"_PatBedId_"^"_PatBed_"^"_OeFlag_"^"_DepLoc			//5
 	..s Data2=DspId_"^"_ConfirmFlag_"^"_TimeDosing_"^"_LocId_"^"_DateTime	//10
	..;构造临时global原则：1.一条医嘱一天的配药记录合并成一条显示
	..;2.先按发药类别排序，然后按就诊id排序
	..s j=AdmDr_"^"_Date_"^"_OrdItmRowid     ;，
	..i '$d(^TMP("dhcpha",npid,"DispCat",Cat,j))  d
	...s ^TMP("dhcpha",npid,"DispCat",Cat,j)=Data1_"^"_Data2
	..e  d
	...s $p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",6)=$p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",6)_","_DspId
	...s $p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",8)=$p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",8)_","_TimeDosing
	..i '$d(^TMP("dhcpha",npid,"OEORI",OrdItmRowid))  d
	...d ..GetOrdInfo(OrdItmRowid,npid)
	..s exStr="^"_DspId
	..k ExistInclb
	..s DspSubId=""
	..f  s DspSubId=$o(^DHCOEDISQTY(DspId,"I",DspSubId)) q:DspSubId=""  d
	...q:+DspSubId=0
	...s DspInci=$p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",5) 
	...s DspInclb=$p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",1) 
	...s Inci=$s(DspInclb'="":+DspInclb,1:Inci)
	...q:(InciDr'="")&&(InciDr'=Inci) 
	...q:$d(ExistInclb(+Inci)) // 批次价一个批次只取一次
	...s ExistInclb(+Inci)=""
	...s DspQty=$p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",2)
	...s DispItem=..getDispOrdItem(LocId, npid, Inci, OrdItmRowid,DspId)          ;构造某接收科室发药库存项Rowid,为发药前退药做准备
	...s i=i+1                                                       ;                                                  ;
	...s Sp=##Class(web.DHCSTPRICE).GetSp(Inci,Date,"",HospId,"",exStr)	//zhouyg 20150115-待修改啊
	...s BatchNo=""
	...i RuleFlag=3 d
	....i feepoint=1 d ; 发药计费
	.....s firstbatsp=+##class(web.DHCSTPRICE).GetSp(DspInclb,+$h,"",HospID,$p($h,",",2))
	.....i firstbatsp'=Sp d
	......s Sp=firstbatsp
	......s $p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",4)=firstbatsp ; 批次价发生售价,且发药计费时,修改打包批次表价格,yunhaibao20170122
	....//s BatchNo=..GetBatInfoByDsp(DspId)
	...s SumAmt=Sp*DspQty
	...// 金额保留
	...S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(Inci)
	...s StkTypeDesc=$P(CatGrpStr,"^",4)
	...S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	...s SumAmt=##Class(web.DHCSTCOMMPARA).GetNumbFN(SumAmt,Perv,"FmtSA",1)
	...i '$d(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci)) d
	....s InciDesc=$p(^INCI(Inci,1),"^",2)
	....s BaseUomDr=$p(^INCI(Inci,1),"^",10)
	....s BaseUom=$s(BaseUomDr'="":$p(^CT("UOM",BaseUomDr),"^",2),1:"")
	....s DspIncData1=InciDesc_"^"_Sp_"^"_SumAmt_"^"_DspQty_"^"_BaseUom
	....s DspIncData=DspIncData1
	....s ^TMP("dhcpha",npid,"DispCat",Cat,j,Inci)=DspIncData
	...e  d
	....s $p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",3)=SumAmt+$p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",3)
	....s $p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",4)=DspQty+$p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",4)
	...s ret=..AddAdmOrdItm(npid,Cat,AdmDr,OrdItmRowid,DspQty)    ;需要确认AddAdmOrdItm是否需要修改-待修改
	..
	.
	i i=0 k ^TMP("dhcpha",npid,"ModifyARCIM","A") ;如果无查找内容,清除更改医嘱项的构造数据 
	i i>0 s billret=..AuditAdmBill(npid,LocId,loclog)
	i i>0 s ^TMP("dhcpha",npid,"DISPM")=LocId_"^"_WardId_"^"_DateFrom_"^"_DateTo_"^"_UserId
	i i>0 q npid    ; return the process ID
	q ""
}

/// Creator:zhangdongmei
/// CreatDate:2012-02-23
/// Descriprtion:整理病区待发药信息,直接从配药表检索数据
/// Table:DHC_oedispensing , OE_OrdItem
/// Input:发药科室id,病区id,开始日期,结束日期,发药人id,长嘱标志,临嘱||加急||,出院带药标志, 
/// 发药类别,审核标志,起始时间,结束时间,库存项Rowid
/// Output:npid 进程号
/// Others:save the data into temporary global
ClassMethod PCHCOLLS(LocId As %String, WardId As %String, DateFrom As %String, DateTo As %String, UserId As %String, LFlag As %String, StrSFlag As %String, OutFlag As %String, DispCat As %String, NotAudit As %String, TimeFrom As %String, TimeTo As %String, InciDr As %String, loclog As %String) As %Integer
{
 n (LocId,WardId,DateFrom,DateTo,UserId,LFlag,StrSFlag,OutFlag,DispCat,NotAudit,TimeFrom,TimeTo,InciDr,loclog)
 s HospId=$p($g(^CTLOC(LocId)),"^",22)
 s Params="^"_LocId_"^^"_HospId
 s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
 s SFlag=$p(StrSFlag,"||",1)        	;临嘱
 s EmOrdFlag=$p(StrSFlag,"||",2)		;中草药急煎标志
 s PackFlag=$p(StrSFlag,"||",3)   		;整包装？
 s tDispstr=DispCat
 s DispCat=$p(tDispstr,"#",1) //发药类别
 s pristr=$p(tDispstr,"#",2) //本地配置限发
 s catpid=$p(tDispstr,"#",3)
 s npid=..NewPid() ; 
 q:WardId="" -1							;病区不能为空
 s i=0
 s h=0
 s HospID=""
 i LocId'="" d
 .s HospID=$p($g(^CTLOC(LocId)),"^",22)
 s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
 S CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID) 
 s WardLocNew=WardId
 s cnt=$l(WardLocNew,"^")
 f wnum=1:1:cnt d
 .s WardId2=$p(WardLocNew,"^",wnum)
 .s WardLoc=$p(^PAWARD(WardId2),"^",5)  	;病区对应的CT_Loc记录
 .i catpid'="" s DispCat=$g(^TMP("dhcpha",catpid,"CATINWARD",WardId2))
 .f Date=DateFrom:1:DateTo  d
 ..s num=1
 ..f  s DspCatCode=$p(DispCat,"^",num) q:DspCatCode=""  d
 ...s num=num+1
 ...s Cat=DspCatCode
 ...s DspId=0
 ...f  s DspId=$o(^DHCOEDISQTY(0,"REC",LocId,Date,"TC",WardLoc,DspCatCode,DspId)) q:DspId=""  d
 ....s h=h+1
 ....s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
 ....s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针 ..
 ....s AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
 ....q:AdmDr=""
 ....s AdmWard=$p(^PAADM(AdmDr),"^",70)  		;病人当前病房
 ....s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
 ....q:AdmType'="I"  							;过滤非住院病人     
 ....s Ord=+OrdExeRowid
 ....s Chl=$p(OrdExeRowid,"||",2)
 ....s OreChl=$p(OrdExeRowid,"||",3)
 ....q:Ord=""
 ....q:Chl=""
 ....q:'$d(^OEORD(Ord))
 ....q:'$d(^OEORD(Ord,"I",Chl))
 ....q:##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId)'="Y" //-11 //禁忌审核不通过 zhouyg 20150108
 ....s ret=..DealWithOrdInfo(LocId,LFlag,StrSFlag,OutFlag,tDispstr,OrdItmRowid,Cat,npid)
 ....q:ret'=0    ;不需要配药
 ....q:'$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"))
 ....s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"),"^",1)  ;医嘱状态
 ....q:OrderStatusDr=""
 ....s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)          ;医嘱核实、未核实、停止状态 
 ....q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0  ;判断执行记录状态是否可配药
 ....s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
 ....q:(Date=DateFrom)&(TimeDosing'="")&(TimeFrom'="")&(TimeDosing<TimeFrom)
 ....q:(Date=DateTo)&(TimeDosing'="")&(TimeTo'="")&(TimeDosing>TimeTo)
 ....s ConfirmFlag=$p($g(^DHCOEDISQTY(DspId)),"^",17)
 ....q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)=0 //护士审核,NotAudit参数已无用,yunhaibao20160223
 ....q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId)   ;被拒绝发放
 ....s SkinTest=##class(web.DHCSTPCHCOLLS2).SkinTest(Ord_"||"_Chl)
 ....q:(NeedSkinTest="Y")&&(SkinTest<0)&&(SkinTest'=-5)
 ....s BedStr=##class(web.DHCSTCOMMONORDER).GetAdmBedCode(AdmDr,WardLoc)
 ....s PatBedId=$p(BedStr,"^",1)
 ....s PatBed=$p(BedStr,"^",2)
 ....s DepLoc=$p(^DHCOEDISQTY(DspId),"^",23) //$p(^PAADM(AdmDr),"^",4) ;病人所在科室,yunhaibao20160324,按打包表记录                                          ;病人所在科室
 ....s DspQty=$p(^DHCOEDISQTY(DspId),"^",11)   					//本顿发药数
 ....s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCI
 ....q:ArcimId=""
 ....s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 ....s ArcCatCode=$p(^ARC("IC",ArcCatId),"^",1)                       			;医嘱子类代码
 ....s Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
 ....s DispItem=..getDispOrdItem(LocId, npid, Inci, OrdItmRowid,DspId)          ;构造某接收科室发药库存项Rowid,为发药前退药做准备
 ....s i=i+1     
 ....s PriorDr=$p($g(^OEORD(+Ord,"I",+Chl,1)),"^",8)
 ....q:PriorDr=""
 ....s Priority=$p($g(^OECPR(PriorDr)),"^",1) 		
 ....s feepoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(ArcCatId_"^"_Priority_"^"_OrdItmRowid)
 ....s DateTime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"IP")_","_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP")
 ....s Prescno=$p(^OEORD(Ord,"I",Chl,1),"^",14)
 ....i TimeDosing'="" S TimeDosing=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP") 
 ....s Data1=Prescno_"^"_PatBedId_"^"_PatBed_"^"_OeFlag_"^"_DepLoc			//5
 ....s Data2=DspId_"^"_ConfirmFlag_"^"_TimeDosing_"^"_LocId_"^"_DateTime	//10
 ....;构造临时global原则：1.一条医嘱一天的配药记录合并成一条显示
 ....;2.先按发药类别排序，然后按就诊id排序
 ....s j=AdmDr_"^"_Date_"^"_OrdItmRowid_"^"_WardId2     //增加病区id，用于当左侧多个病区同事选择发药时的过滤 ;，
 ....i '$d(^TMP("dhcpha",npid,"DispCat",Cat,j))  d
 .....s ^TMP("dhcpha",npid,"DispCat",Cat,j)=Data1_"^"_Data2
 ....e  d
 .....s $p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",6)=$p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",6)_","_DspId
 .....s $p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",8)=$p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",8)_","_TimeDosing
 ....i '$d(^TMP("dhcpha",npid,"OEORI",OrdItmRowid))  d  
 .....d ..GetOrdInfo(OrdItmRowid,npid)
 ....k ExistInclb
 ....s DspSubId=""
 ....f  s DspSubId=$o(^DHCOEDISQTY(DspId,"I",DspSubId)) q:DspSubId=""  d
 .....q:+DspSubId=0
 .....s DspInci=$p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",5) 
 .....s DspInclb=$p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",1)
 .....s DspQty=$p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",2) 
 .....s Inci=$s(DspInclb'="":+DspInclb,1:DspInci)
 .....q:(InciDr'="")&&(InciDr'=Inci) 
 .....q:$d(ExistInclb(+Inci)) // 批次价一个批次只取一次
 .....s ExistInclb(+Inci)=""
 .....s DispItem=..getDispOrdItem(LocId, npid, Inci, OrdItmRowid,DspId)          ;构造某接收科室发药库存项Rowid,为发药前退药做准备
 .....s i=i+1    
 .....i DspInclb'="" s DspQty=##class(web.DHCSTCOMMONSRV).GetDspInciQtyByDsp(DspId,Inci)                                            ;
 .....s exStr="^"_DspId
 .....s Sp=##Class(web.DHCSTPRICE).GetSp(Inci,Date,"",HospID,"",exStr)	//zhouyg 20150115-医嘱改造,待修改
 .....s BatchNo=""
 .....i RuleFlag=3 d
 ......i feepoint=1 d
 .......s firstbatsp=+##class(web.DHCSTPRICE).GetSp(DspInclb,+$h,"",HospID,$p($h,",",2))
 .......i firstbatsp'=Sp d
 ........s Sp=firstbatsp
 ........s $p(^DHCOEDISQTY(DspId,"I",DspSubId),"^",4)=firstbatsp ; 批次价发生售价,且发药计费时,修改打包批次表价格,yunhaibao20170122
 .....s SumAmt=Sp*DspQty
 .....//金额保留
 .....S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(Inci)
 .....S StkTypeDesc=$P(CatGrpStr,"^",4)
 .....S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 .....s SumAmt=##Class(web.DHCSTCOMMPARA).GetNumbFN(SumAmt,Perv,"FmtSA",1)
 .....i '$d(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci)) d
 ......s InciDesc=$p(^INCI(Inci,1),"^",2)
 ......s BaseUomDr=$p(^INCI(Inci,1),"^",10)
 ......s BaseUom=$s(BaseUomDr'="":$p(^CT("UOM",BaseUomDr),"^",2),1:"")
 ......s DspIncData1=InciDesc_"^"_Sp_"^"_SumAmt_"^"_DspQty_"^"_BaseUom
 ......s DspIncData=DspIncData1	
 ......s ^TMP("dhcpha",npid,"DispCat",Cat,j,Inci)=DspIncData
 .....e  d
 ......s $p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",3)=SumAmt+$p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",3)
 ......s $p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",4)=DspQty+$p(^TMP("dhcpha",npid,"DispCat",Cat,j,Inci),"^",4)
 .....//s ret=..AddAdmOrdItm(npid,Cat,AdmDr,OrdItmRowid,DspQty)    ;需要确认AddAdmOrdItm是否需要修改
 .
 //i i=0 k ^TMP("dhcpha",npid,"ModifyARCIM","A") ;如果无查找内容,清除更改医嘱项的构造数据 
 i i>0 s billret=..AuditAdmBill(npid,LocId,loclog)
 //i i>0 s ^TMP("dhcpha",npid,"DISPM")=LocId_"^"_WardId_"^"_DateFrom_"^"_DateTo_"^"_UserId  ;保存发药主表用
 i i>0 s ^TMP("dhcpha",npid,"DISPM")=LocId_"^"_""_"^"_DateFrom_"^"_DateTo_"^"_UserId  ;保存发药主表用 ///modify wyx 2014-12-23,病区由发药界面传入
 i i>0 q npid    ; return the process ID
 q ""
}

/// Descriprtion: 	判断是否可发药
/// Creater：		zhouyg
/// CreateDate：	2014-12-17
/// Return:			0-可发药
ClassMethod DealWithOrdInfo(LocId As %String, LFlag As %String, StrSFlag As %String, OutFlag As %String, DispCat As %String, OrdItmRowid As %String, Cat As %String, npid As %String)
{
	n (LocId,LFlag,StrSFlag,OutFlag,DispCat,OrdItmRowid,Cat,npid)
	s SFlag=$p(StrSFlag,"||",1)        	;临嘱
	s EmOrdFlag=$p(StrSFlag,"||",2)		;中草药急煎标志
	s PackFlag=$p(StrSFlag,"||",3)   		;整包装？
	s tDispstr=DispCat
	s pristr=$p(tDispstr,"#",2) //本地配置限发
	q:$d(^TMP("dhcpha",npid,"OEORI",OrdItmRowid)) 0   		;存在，说明该医嘱可发药,不需要判断下述条件
 	s Ord=+OrdItmRowid
	s Chl=$p(OrdItmRowid,"||",2)
 	s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
	q:PriorDr="" -1  										;优先级不存在的不予发放 2006-05-27 
 	s Priority=$p(^OECPR(PriorDr),"^",1) 					;医嘱优先级代码              
 	q:Priority["OM" -1 									;自备药即刻,8.0新增嘱托医嘱 
 	q:(LFlag="1")&(Priority'="S") -2     					;只处理长期医嘱
 	q:(OutFlag="1")&(Priority'="OUT") -3                	;只处理出院带药
 	i (SFlag="1") q:(Priority="S")!(Priority="OUT") -4  	;只处理即刻医嘱和取药医嘱
 	q:(OutFlag'="1")&(Priority="OUT") -5                   ;在不选中"仅发出院代药"的情况下,不包括出院带药
 	s Prescno=$p(^OEORD(Ord,"I",Chl,1),"^",14) 			;处方号
 	s Emergency=..GetEmy(Prescno)
 	q:(EmOrdFlag="EmOrd")&(Emergency'="Y") -5  			;紧急发放控制 
 	s Doctor=$p(^OEORD(Ord,"I",Chl,7),"^",1)
 	s DoctorLoc=$p(^OEORD(Ord,"I",Chl,7),"^",2)   			;060725
 	q:..DoctorLocRefuse(LocId,DoctorLoc)=1 -6				;病区发药时过滤掉医生科室
 	s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 	s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 	s AdmDr=$p(^OEORD(Ord),"^",1)
 	s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(AdmDr,ArcCatId_"^"_Priority)  ;最终结算,则不发药
 	q:AmtFlag=0 -7
 	i pristr'="" q:##Class(web.DHCSTPCHCOLLS5).CheckPrioDispCat(pristr,Priority_"#"_Cat)=0 -11	
 	s QtyPackUom=$p(^OEORD(Ord,"I",Chl,9),"^",4)    ;整包装数量？
 	s PackedCat=..getPackedCat()            ;需分整散包装发药的药品类别
 	q:(PackFlag="ISPACK")&(QtyPackUom="")&($f(PackedCat,Cat)>0 )&(PackedCat'="") -9 	;整发 
 	q:(PackFlag="NOPACK")&(QtyPackUom'="")&($f(PackedCat,Cat)>0)&(PackedCat'="") -10 	;片发
 	q 0
}

/// Creator:zhangdongmei
/// CreatDate:2012-02-23
/// Descriprtion:整理病区待发药信息,直接从配药表检索数据
/// Table:DHC_oedispensing , OE_OrdItem
/// Input:发药科室id,病区id,开始日期,结束日期,发药人id,长嘱标志,临嘱||加急||,出院带药标志, 
/// 发药类别,审核标志,起始时间,结束时间,库存项Rowid
/// Output:npid 进程号
/// Others:save the data into temporary global
ClassMethod GetOrdInfo(OrdItmRowid As %String, npid As %String)
{
	n (OrdItmRowid,npid)
	s Ord=+OrdItmRowid
	s Chl=$p(OrdItmRowid,"||",2)
	s SeqNo=$p(^OEORD(Ord,"I",Chl,3),"^",4)
	s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2) 
	s PhcdfDr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",12)
	s AdmReasonId=$p($g(^OEORD(Ord,"I",Chl,11)),"^",18)
	s RecLocId=$p(^OEORD(Ord,"I",Chl,3),"^",6)
	s HospId=$p($g(^CTLOC(RecLocId)),"^",22)
	s IssuType=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(ArcimId,AdmReasonId,HospId)
	s AdmDr=$p(^OEORD(Ord),"^",1)
	s PapmiId=$p(^PAADM(AdmDr),"^",1) 
	s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1) 
	s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2) 
	s UomId="" //$p(^INCI(Inci,1),"^",10)
	s Uom="" //$p(^CT("UOM",UomId),"^",2) 
	s Priorty=$p(^OECPR($p(^OEORD(Ord,"I",Chl,1),"^",8)),"^",2)   		;医嘱优先级
	s DoseQty=$p($g(^OEORD(Ord,"I",Chl,2)),"^",1)       						;用药剂量
	i +DoseQty>0 d
	.s DoseUom=$p($g(^OEORD(Ord,"I",Chl,2)),"^",3)
	.i DoseUom'="" s DoseUom=$p($g(^CT("UOM",DoseUom)),"^",2)
	.s DoseQty=DoseQty_DoseUom
	s Freq=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(OrdItmRowid),"^",3)    			;用药频率 
	s Instru=$p($g(^OEORD(Ord,"I",Chl,2)),"^",7)
	i Instru'="" s Instru=$p($g(^PHCIN(Instru)),"^",2)        	;用法
	s Duration=$p($g(^OEORD(Ord,"I",Chl,2)),"^",6)
	i Duration'="" s Duration=$p($g(^PHCDU(Duration)),"^",1)         	;用药疗程
	s Batno=""       ;发药前不知道
	s OrdAuditResult=$p(^OEORD(Ord,"I",Chl,7),"^",3)
	s Audited=""		;护士审核标志按配药记录走的，按医嘱没法显示,20160615显示为医嘱审核结果
	i OrdAuditResult["SHJJ" s Audited="审核拒绝"
	i OrdAuditResult["SHTG" s Audited="审核通过"	
	s Generic=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(PhcdfDr)
	s Generic=$p(Generic,"^",2)
	s Form=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PhcdfDr)
	s Form=$p(Form,"^",2)
	s Spec="" //##class(web.DHCSTCOMMONSRV).getBarcode(Inci)
	s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManfByPhcd(PhcdfDr)
	s Manf=$p(Manf,"^",3)
	s StkBin="" //				
	s UserAdd=##class(web.DHCSTCOMMONSRV).getOrdDoctor(OrdItmRowid)       ;医生
	s Diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",")
	s Age=##class(PHA.FACE.IN.Com).GetAge(PapmiId, AdmDr) 					;PA_PatMas PAPMI_RowId 
	s SkinTest=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrdItmRowid) 		;备注(皮试结果)
	s SexDr=$p(^PAPER(PapmiId,"ALL"),"^",7)
	s Sex=$p(^CT("SEX",SexDr),"^",2)
	s data1=SeqNo_"^"_ArcimId_"^"_PhcdfDr_"^"_IssuType_"^"_PapmiId_"^"_PatName_"^"_PatNo_"^"_ArcimDesc
	s data2=UomId_"^"_Uom_"^"_Priorty_"^"_DoseQty_"^"_Freq_"^"_Instru_"^"_Duration_"^"_Batno_"^"_Audited
	s data3=Generic_"^"_Form_"^"_Spec_"^"_Manf_"^"_StkBin_"^"_UserAdd_"^"_Diagnose
	s data4=Age_"^"_SkinTest_"^"_SexDr_"^"_Sex
	s data=data1_"^"_data2_"^"_data3_"^"_data4
	s ^TMP("dhcpha",npid,"OEORI",OrdItmRowid)=data 
	q
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-13 
/// Description:获取病区分组情况,按分组排序
/// Input:bedid ,  bed
/// Output:分组_床号
/// Return:分组_床号
/// Others:
ClassMethod getWardGrp(bedid, bed)
{
  n (bedid,bed)
  ;s grpstr=##Class(web.HXExternal.WardRegion).GetByBed(bedid)
  ;s grpstr=^tmplqxxx(bedid)
  s grpstr=""
  s bedgrp=$p(grpstr,"^",2)
  i bedgrp'="" d
  .s bed=bedgrp_"_"_bed 
  q bed
}

/// Descriprtion:判断是否医特殊科室
/// Input:phaloc -药房科室, doctorloc -医生科室
/// Output: 1:拒绝的医生科室 0:非拒绝的医生科室
/// Table:CT_LocLinkLocation
/// Creator:Liang Qiang
/// CreatDate:2008-11-03
ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
 n (phaloc,doctorloc)
 &sql(select * from CT_LocLinkLocation where link_parref=:phaloc and link_ctloc_dr=:doctorloc)
 q:'SQLCODE 1
 q 0
}

/// Descriprtion:获取中草药急煎标志
/// Input:prescno - 处方号
/// Output: 急煎标志 (Y/N)
/// Table:PA_Que1
/// Creator:Liang Qiang
/// CreatDate:2009-1-03
ClassMethod GetEmy(prescno)
{
 n (prescno)
 q:prescno="" ""
 s queid=""
 f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
 .s preno=$p(^PAQUE1(queid),"^",14) ;处方号
 .i $d(^PAQUE1(queid,"DHC")) d
 ..s Emergencyflag=$p(^PAQUE1(queid,"DHC"),"^",22)
 ..s Emergencyflag=Emergencyflag
 q ($g(Emergencyflag))
}

ClassMethod CatInList(dispcat, cat)
{
 n (dispcat, cat)
 q:dispcat="" 1
  //zhouyg 20141218按登记号发药时可以不选择发药类别
 s i=1
 s result=0
 f  s tmp=$p(dispcat,"^",i) q:(tmp="")!(result=1)  d
 . i cat=tmp s result=1 q
 . s i=i+1
 q result
}

/// Description:获取需分整散包装发药的药品类别
/// Creator:Liang Qiang
/// CreatDate:2009-07-30
/// w ##class(web.DHCSTPCHCOLLS).getPackedCat()
ClassMethod getPackedCat()
{
 s result=""
 s rowid="0"
 f  s rowid=$o(^DHCSTDRUGGRP(rowid)) q:rowid=""  d
 .q:'$d(^DHCSTDRUGGRP(rowid))
 .s code=$p(^DHCSTDRUGGRP(rowid),"^",1)
 .s ispack=$p(^DHCSTDRUGGRP(rowid),"^",4)
 .i ispack="1" d
 ..i result="" d
 ...s result=code
 ..e  d
 ...s result=result_"^"_code 
 q result
}

/// w ##class(web.DHCSTPCHCOLLS).GetAdm("","","0000000912")
ClassMethod GetAdm(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegNo As %String, querytype = "DISP") As %Integer
{
	n (RegNo,itmjs,itmjsex,querytype)
	s result=$g(result)
	s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	q:papmi="" ""
	s adm="" f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
	. i adm'="" d
	. . s adm=+adm
	. . q:$p(^PAADM(adm),"^",2)'="I"      ; if not inpatient then quit - 20060601
	. . s ord=$o(^OEORD(0,"Adm",adm,""))
	. . q:ord=""
	. . s admstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)
	. . s exitflag=$s(querytype="DISP":1,1:"")
	. . i admstatus="1" s exitflag=""
	. . i (querytype="DISP")&&(admstatus'=1) d ; 发药显示的就诊需要判断计费点是否显示
	. . . s exitflag="1"
	. . . s dsp=""
	. . . f  s dsp=$o(^DHCOEDISQTY(0,"ADM",adm,dsp),-1) q:(dsp="")||(exitflag="")  d
	. . . . q:+dsp=0
	. . . . s dspstatus=$p(^DHCOEDISQTY(dsp),"^",7)
	. . . . q:dspstatus'="TC"
	. . . . s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	. . . . s oeore=$p(^DHCOEDISQTY(dsp),"^",2)
	. . . . s ord=+oeori,itm=$p(oeori,"||",2)
	. . . . q:##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)=0 ; 
	. . . . q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(dsp)
	. . . . s pri=$p(^OEORD(ord,"I",itm,1),"^",8) 
	. . . . q:pri="" 
	. . . . s pricode=$p($g(^OECPR(pri)),"^",1)
	. . . . q:pricode["OM" 							
	. . . . s arcimid=$P(^OEORD(ord,"I",itm,1),"^",2)
	. . . . q:arcimid="" 
	. . . . s arcimm=$p(arcimid,"||",1)
	. . . . q:arcimm="" 
	. . . . s arcimsub=$p(arcimid,"||",2)
	. . . . q:arcimsub="" 
	. . . . s arcitemcat=$p($g(^ARCIM(arcimm,arcimsub,1)),"^",10)
	. . . . q:arcitemcat="" 
	. . . . s arcitmtype=$p($g(^ARC("IC",arcitemcat)),"^",7)
	. . . . q:arcitmtype'="R" ; 过滤非药品医嘱
	. . . . s amtflag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(adm,arcitemcat_"^"_pricode)
	. . . . i amtflag="1" s exitflag="1"
	. . q:exitflag'=""
	. . s depcodedr=$p(^PAADM(adm),"^",4) i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
	. . s admdate=$p(^PAADM(adm),"^",6) i admdate>0 s admdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate,"IP") 
	. . s admtime=$p(^PAADM(adm),"^",7) i admtime>0 s admtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(admtime,"IP")
	. . s curWard=$p(^PAADM(adm),"^",70) i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
	. . s curBed=$p(^PAADM(adm),"^",73) i curBed'="" d
	. . .s w=+curBed,b=$p(curBed,"||",2) q:(w="")!(b="")
	. . .s curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	. . s doctor=$p(^PAADM(adm),"^",9) i doctor'=""  s doctor=$p(^CTPCP(doctor,1),"^",2 )
	. q:$g(admdate)=""
	. s xxx=$g(adm)_"&"_$g(depDesc)_" * "_$g(admdate)_" * "_$g(admtime)_" * "_$g(curWardDesc)_" * "_$g(curBedcode)_" * "_$g(doctor)
	. i result="" d
	. . s result=xxx ;
	. e  d
	. . s result=result_"^"_xxx
	s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
	&javascript<#(retval)#>
	q $g(result)
}

ClassMethod GetPaInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", pano As %String) As %String
{
 //根据登记号,取出病人信息:姓名、性别、年龄
 n (pano,itmjs,itmjsex)
 &sql(select papmi_name,papmi_sex_dr->ctsex_desc,nvl(papmi_dob,"") 
 into :paname,:sex,:dob from pa_patmas
 where papmi_no=:pano)
 q:SQLCODE ""
 i $g(dob)'="" d
 .//s age=$fn((+$h-dob)/365,"",0)
 .s pmi=$o(^PAPERi("PAPMI_PatNo",pano,""))
 .s age=##class(web.DHCSTKUTIL).GetAge(pmi) //年龄统一调用接口wyx 2015-01-29
 .s dob=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dob,"IP")
 .s dob=dob_"( "_age_" )" 
 ;s dob=$zd(dob,3)
 s result=$g(paname)_"^"_$g(sex)_"^"_ $g(dob)

 s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
 &javascript<#(retval)#>
}

ClassMethod GetDispM(n As %Integer) As %String
{
 i +n<1 q ""  				;^TMP("dhcpha",$j,"DISPM")  ; if n is null
 i $d(^TMP("dhcpha",$j,"DISPM",n)) q ^TMP("dhcpha",$j,"DISPM",n)
 q ""
}

/// w ##class(web.DHCSTPCHCOLLS).SAVEDATA("","","PTFY",676192,"","","",98,14)
ClassMethod SAVEDATA(itmjs As %Library.String = "", itmjsex As %Library.String = "", PhacType As %String, pid As %String, CollectUserRowid As %String, CollectOperaterRowid As %String, ifsend As %String, loc As %String, wardid As %String) As %String
{
	n (itmjs,itmjsex,PhacType,pid,CollectUserRowid,CollectOperaterRowid,ifsend,loc,wardid,%session)
	//s ^hlh($h)=$lb(itmjs,itmjsex,PhacType,pid,CollectUserRowid,CollectOperaterRowid,ifsend,loc,wardid)
	s PhacType=$g(PhacType) 
	//wyx 增加wardid选择多病区时发药控制
	//wyx 增加loclog取自登录科室session里的科室
	s loclog=%session.Data("LOGON.CTLOCID")
	s retbill=..AuditAdmBill(pid,loc,loclog)  ;欠费控制
	s DispInfo=^TMP("dhcpha",pid,"DISPM")
	s PhacLoc=$p(DispInfo,"^",1)
	//s PhacWard=$p(DispInfo,"^",2)
	s PhacWard=wardid
	s PhacDateFrom=$p(DispInfo,"^",3)
	s PhacDateTo=$p(DispInfo,"^",4)
    s:PhacLoc="" PhacWard="*"        ;?
	s PhacUser=$p(DispInfo,"^",5)
	s:CollectUserRowid'="" PhacUser=CollectUserRowid
	s PhacDate=+$h
	s PhacTime=$p($h,",",2)
	s operater=CollectOperaterRowid
	s PhacStatus="Print"
	s TmpOldphac=""
	s PhacRowid=""
	s PrtPhac=""  ;返回打印值:phacrowid串,以“A”间隔
	s HospID=""
 	i PhacLoc'="" d
 	.s HospID=$p($g(^CTLOC(PhacLoc)),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	;保存某一类别的发药记录
	k CheckAllowFlagArr
	s j=0
	s SubStr=""
	f  s SubStr=$o(^TMP("dhcpha",pid,"DispCat",PhacType,SubStr))  q:SubStr=""  d
	.s quitFlag=""
	.s AdmDr=$p(SubStr,"^",1)
 	.s DateDosing=$p(SubStr,"^",2)
 	.s OrdItmRowid=$p(SubStr,"^",3)
 	.s WardRowid=$p(SubStr,"^",4)  //add wyx 2014-12-23
 	.s InciRowId=$p(SubStr,"^",5) 
 	.q:(WardRowid'=wardid)&&(WardRowid'="")  // WardRowid 为空是按登记号发放          //add wyx 2014-12-23
 	.s DataStr=^TMP("dhcpha",pid,"DispCat",PhacType,SubStr)
 	.s DspIdStr=$p(DataStr,"^",6)
  	.s DspId=+DspIdStr 
  	.q:'$d(^DHCOEDISQTY(DspId))
 	.s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
    .s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
    .s WardRowid=WardId
 	.q:$d(^TMP("dhcpha",pid,"D","Filter",+DspIdStr))  // 过滤没有选择的医嘱,yunhaibao20160603,勾选修正为按单条存,
 	.s chkOweFee=..CheckOrditmAllowedNew(pid,OrdItmRowid,PhacLoc)
 	.i chkOweFee=0 d ..SetCantDispInfo(pid,OrdItmRowid,"欠费") q
 	.s MainOeori=..GetMainOrdRowid(OrdItmRowid)
 	.s chkArcEnd=$d(^TMP("dhcpha",pid,"arcEndDate",MainOeori)) 
 	.i chkArcEnd=1  d ..SetCantDispInfo(pid,OrdItmRowid,"医嘱项已到截止日期") q
 	.// 关联医嘱中只要有一个库存不足的都不发 wyx 2015-03-12
	.q:(PhacType="ZCY")&&($d(^TMP("dhcpha","NOSTOCK","MainOrd",pid,MainOeori))=1)
	.s DspIdStr=..ReGetDodis(DspIdStr,+OrdItmRowid,$p(OrdItmRowid,"||",2))  ;重新获取配药记录串
	.q:DspIdStr=""
	.//---------zhouyg 20151217  关联医嘱一起发药
	.i '$d(CheckAllowFlagArr(DspIdStr)) d
 	..s allowflag=..CheckAllowFlag(DspIdStr,pid)   ;1--够发  0-不可发
 	..s CheckAllowFlagArr(DspIdStr)=allowflag //只判断一次
 	..i allowflag'=1 d
	...s nostk=##class(web.DHCSTPCHCOLLS).CreateNoStock(DspIdStr,OrdItmRowid,pid)
	...s ^TMP("dhcpha","NOSTOCK","MainOrd",pid,..GetMainOrdRowid(OrdItmRowid))=""
	.e  s allowflag=CheckAllowFlagArr(DspIdStr)
	.q:allowflag'="1"
	.i PhacRowid=""  d
	..s listdata=PhacLoc_"^"_WardRowid_"^"_PhacUser_"^"_PhacDateFrom_"^"_PhacDateTo_"^"_PhacType
	..s PhacRowid=..CreatePhaCollected(listdata)
	.q:PhacRowid="" ;主表插入失败
	.i RuleFlag=3 d
	..s Err=..DispensingByBatch(PhacRowid,DspIdStr,OrdItmRowid)
	.e  d
	..s Err=..Dispensing(PhacRowid,DspIdStr,OrdItmRowid)
	.i Err=7 d ..SetCantDispInfo(pid,OrdItmRowid,"库存不足")
	.q:Err'=0   
	.d KillAdmBill(pid,PhacType,OrdItmRowid)
	.s j=j+1
	i (j=0)&(PhacRowid'="") d
	.&sql(delete from dhc_phacollected where dhc_phacollect_rowid=:PhacRowid)
	q:j=0 0
	i PhacRowid>0 s ret=..Collect(PhacRowid,operater) ;修改发药主表状态
	i PhacRowid>0 d     ;发药后立即做账单
	. job ##class(web.DHCST.HERP).SendData(PhacRowid,"P","")   //插入HERP中间表 add by liangjiaquan 2018-11-27
	. s ret=..MakeBill(PhacRowid)   ;2007-01-08
	. ;d ..killTmpBill(pid,phactype)  ;2007-01-08
	. //生成摆药机数据
	. //i ifsend=1 s ret=..SendToAuto(phacrowid)
	. //华西传送老HIS接口
	. ;s ret=..SendHX(phacrowid)	
	q PhacRowid
		
KillAdmBill(pid,phactype,phacidis)
    ;清除暂存的计费控制帐单
    k ^TMP(pid,"ORDITEMS",phactype,phacidis)
    q
}

/// Descriprtion:保存发药主表记录
/// Input:药房id^病区id^发药人^分发日期(开始)^分发日期(截止)^发药类别
/// Output: 成功：主表id; 失败:""
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-23
ClassMethod CreatePhaCollected(listData As %String) As %String
{
	n (listData)
	q:listData="" ""	
	s PhacLoc=$p(listData,"^",1)
	s PhacWard=$p(listData,"^",2)
	s PhacUser=$p(listData,"^",3)
	s PhacDateFrom=$p(listData,"^",4)
	s PhacDateTo=$p(listData,"^",5)
	s PhacType=$p(listData,"^",6)
	s UrgentFlag=$p(listData,"^",7)
	s WardGrp=$p(listData,"^",8)
	s PhacDate=+$h
	s PhacTime=$p($h,",",2)
	s PhacStatus="Print"
	l +^DHCSTLOCK("DHCSTORDDISP"):2 e  q ""   ;加锁
	s DspNo=..GetDispNo($g(PhacLoc))
	&sql(INSERT INTO DHC_PHACollected(DHC_PHALoc_DR,DHC_PHACollectDate,DHC_PHACollectTime,
	DHC_PHAWard_DR,DHC_PHAOperator,DHC_PHACollectStatus,DHC_PHAPrintDate,DHC_PHAPrintTime,
	DHC_PHADateFrom,DHC_PHADateTo,DHC_PHAOrdType,DHC_PHACollectUser,DHC_PHADispNo,DHC_PHAUrgentFlag,
	DHC_PHAWardGroup_DR) 
	VALUES (:PhacLoc,:PhacDate,:PhacTime,:PhacWard,:PhacUser,:PhacStatus,:PhacDate,:PhacTime,
	:PhacDateFrom,:PhacDateTo,:PhacType,:PhacUser,:DspNo,:UrgentFlag,:WardGrp))
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("CreatePhaCollected:DHC_PHACollected",PhacWard,SQLCODE_":"_%msg)
 	l -^DHCSTLOCK("DHCSTORDDISP")
 	q:SQLCODE ""
 	q $p(%ROWID,$c(1))
}

/// Descriprtion:更新发药主表状态
/// Input:主表id,更新人
/// Output: 成功：0; 失败:其它
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-23
ClassMethod Collect(phacdr As %String, Nurse As %String) As %String
{
	n (phacdr,Nurse)
	s Nurse=$g(Nurse)
	s Col="Collect"
	i '$d(^DHCPHAC(phacdr)) q -1
	; calculate the rowcount of items 
	s phacdate=+$h
	s phactime=$p($h,",",2)
	s phaci=0 
	s cnt=0 
	f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	.s cnt=cnt+1
	.	
	s ret=0 
	i cnt=0 d
	. &sql(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:phacdr)
	e  d
	.s $p(^DHCPHAC(phacdr),"^",6)=Col
	.s $p(^DHCPHAC(phacdr),"^",9)=cnt
	.s $p(^DHCPHAC(phacdr),"^",13)=Nurse
	.
	q ret
}

/// Descriprtion:保存发药子表记录
/// Input:主表id^医嘱id^库存项id^数量^配药表id（串）
/// Output: 成功：子表id; 失败:""
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-23
ClassMethod InsPhacItm(listData As %String) As %String
{
	
 n (listData)
 s phacrowid=$p(listData,"^",1)
 q:phacrowid="" ""
 s oeori=$p(listData,"^",2)
 q:oeori="" ""
 s phaciinci=$p(listData,"^",3)
 s phaciqty=$p(listData,"^",4)
 s dhcoedis=$p(listData,"^",5)
 s ord=+oeori
 s itm=$p(oeori,"||",2)
 ;s phaciprice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+phaciinci,+$h,"")
 s PhcLocID=$p($g(^DHCPHAC(phacrowid)),"^",1)
 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(PhcLocID)
 s HospID=$p(CustStr,"^",5)
 s CustID=$p(CustStr,"^",1)
 s exStr=oeori_"^"_dhcoedis
 s phaciprice="" //##Class(web.DHCSTPRICE).GetSp(+phaciinci,+$h,"",HospID,"",exStr)      //整包装价格 //20150115
 //s phaciprice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+phaciinci,+$h,"",HospID)
 //s phacistatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
 s phacistatus=""	//zhouyg 20151105 一次发药可能是多条执行，此状态无意义
 s phaciadm=$P(^OEORD(ord),"^",1) ;adm_dr
 s phacipresc=$p(^OEORD(ord,"I",itm,1),"^",14)   ;处方号
 s phaciloc=$p(^PAADM(phaciadm),"^",4)   ;admloc
 s wardLocId=$p(^DHCOEDISQTY(+dhcoedis),"^",22)
 s phacibed=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(phaciadm,wardLocId),"^",2)
 ;s dhcoedis=$tr(dhcoedis,",","^")   ;保存到子表中是按^分隔的串,用","分隔，否则取global有问题
 s tmpdodis=$p(dhcoedis,",",1)
 s datedosing=$p(^DHCOEDISQTY(tmpdodis),"^",21)  ;分发日期
 s SpAmt="" //##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
 s j=$o(^DHCPHAC(phacrowid,"I",""),-1)+1   ;child sub
 &sql(INSERT INTO DHC_PHACollectItm(PHACI_PHAC_ParRef,PHACI_Adm_DR,PHACI_PrescNo,
 PHACI_INCI_DR,PHACI_Qty,PHACI_OEDIS_DR,PHACI_ChildSub,PHACI_BED,PHACI_Price,
 PHACI_OrdStatus,PHACI_AdmLoc_DR,PHACI_DODIS_DR,PHACI_DateDosing,PHACI_SpAmt) 
 VALUES(:phacrowid,:phaciadm,:phacipresc,:phaciinci,:phaciqty,:oeori,:j,:phacibed,
 :phaciprice,:phacistatus,:phaciloc,:dhcoedis,:datedosing,:SpAmt))
 i SQLCODE'=0  d
 .s ret=$$SqlErrorRecord^DHCSTERROR("InsPhacItm:DHC_PHACollectItm",oeori,SQLCODE_":"_%msg)
 q:SQLCODE ""
 q $p(%ROWID,$c(1))
}

/// Descriprtion:保存发药子表记录
/// Input:发药子表id^批次id^批次数量
/// Output: 成功：批次表id; 失败:""
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-23
ClassMethod InsPhacItmLB(listData As %String) As %String
{
	n (listData)
	s phacirowid=$p(listData,"^",1)
	q:phacirowid="" ""
	s phacID=$p(phacirowid,"||",1)
	s locID=$p(^DHCPHAC(phacID),"^",1)
	s HospID=$p(^CTLOC(locID),"^",22)
	s inclb=$p(listData,"^",2)
	s inci=+inclb
	s buom=$p(^INCI(inci,1),"^",10)
	s qty=$p(listData,"^",3)
	s sp=$p(listData,"^",4)
	s rp=$p(listData,"^",5)
	s dspBatchId=$p(listData,"^",6)
	//s rp=##class(web.DHCSTPRICE).GetClbRp(inclb,buom)
	s rpamt=rp*qty
	s spamt=sp*qty
	 //格式化数值小数位数
	S CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID) //DHC_STCustomer
	S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inci)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
	S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	s rpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtRA",1)
	s spamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spamt,Perv,"FmtSA",1)
	s childsub=$o(^DHCPHAC(+phacirowid,"I",$p(phacirowid,"||",2),"B",""),-1)+1   ;child sub
 	;
 	&sql(INSERT INTO DHC_PHACollectItmLB(PHACIL_PHACI_ParRef,PHACIL_ChildSub,PHACIL_INCLB_Dr,
 	PHACIL_Qty,PHACIL_Rp,PHACIL_RpAmt,PHACIL_Sp,PHACIL_SpAmt,PHACIL_DSPB_Dr) 
 	VALUES (:phacirowid,:childsub,:inclb,:qty,:rp,:rpamt,:sp,:spamt,:dspBatchId))
 	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("InsPhacItmLB:DHC_PHACollectItmLB",inclb,SQLCODE_":"_%msg)
 	q:SQLCODE ""
 	q $p(%ROWID,$c(1))
}

ClassMethod SendHX(phac As %String) As %String
{
	//执行传发药数量至老HIS--华西
	n (phac)
	q:phac="" 0
	s phac=+phac
    s err=##class(web.DHCSTInPhaInterFace).PutMessagePharmacy("1",phac)
	q err
}

/// Description：获取主医嘱Rowid
/// Creator:LiangQiang
/// CreatDate:2009-06-27
/// Table:
/// Input:orditemRowid
/// Output:关联主医嘱Rowid
/// Return:关联主医嘱Rowid
/// Others:
ClassMethod GetMainOrdRowid(orditemRowid As %String) As %String
{
    n (orditemRowid)
    s mainord=$p(^OEORD(+orditemRowid,"I",$p(orditemRowid,"||",2),11),"^",39)  
	i mainord="" s mainord=orditemRowid
    q mainord
}

ClassMethod KillTmpAfterSave(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String)
{
	d ..CLEARTMP(pid,"DISPM")	; 
	d ..CLEARTMP(pid,"DISPD")	; 
	d ..CLEARTMP(pid,"D")		;
	d ..CLEARTMP(pid,"Disp")
	d ..CLEARTMP(pid,"DispCat")
	k ^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid)
	k ^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",pid)       ;计费控制所用
	//k ^TMP("dhcpha","NOSTOCK","WARDPAT",pid) //注释掉，因为在打印时还没打印完数据就被k掉了
	k ^TMP("dhcpha","NOSTOCK","MainOrd",pid)
	q 0
}

/// Description:构造库存不足数据 - ^TMP("dhcpha","NOSTOCK",pid)
/// Input： dhcoedispensing -rowid ,oeorditem -rowid ,pid - 进程号
/// return: 病区^登记号^药品名^床号^姓名^应发数量^医嘱时间
/// Creator：Liang Qiang
/// CreatDate：2008-09-10
/// w ##class(web.DHCSTPCHCOLLS).CreateNoStock("83656","1290||2","123")
ClassMethod CreateNoStock(dhcoedis, oeori, pid) As %String
{
	 n (dhcoedis,oeori,pid)
	 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
	 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	 s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	 s dodiss=..ReGetDodis(dhcoedis,ord,itm)
	 s dspid=+dodiss
	 s disptype=$p(^DHCOEDISQTY(dspid),"^",27) 
	 s locid=$p(^DHCOEDISQTY(dspid),"^",24) 
	 s locdesc=$p(^CTLOC(locid),"^",2)
	 i $f(locdesc,"-") s locdesc=$p(locdesc,"-",2)
	 s confqty=..CalDspQty(dodiss)
	 s wardlocid=$p(^DHCOEDISQTY(dspid),"^",22)
	 s adm=$p(^OEORD(ord),"^",1)  
	 s admward=$p(^PAADM(adm),"^",70)  
	 s bedid=$p(^PAADM(adm),"^",73)                                             
	 i bedid="" s bed=""
	 e  s bed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	 s nameid=$p(^PAADM(adm),"^",1)
	 s name=$p(^PAPER(nameid,"ALL"),"^",1)
	 s patno=$p(^PAPER(nameid,"PAT",1),"^",1)
	 s incidesc=$p(^INCI(inci,1),"^",2)
	 s arcimid=$p(^INCI(inci,1),"^",3)
     s incidesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",21)   //add by myq 20120522 北京同仁 取医嘱通用名
	 s orddate=$p(^OEORD(ord,"I",itm,1),"^",9)
	 i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"IP")    
	 s buomid=$p(^INCI(inci,1),"^",10) 							// 指向 CT_UOM 
     s buomdesc=$p($g(^CT("UOM",+buomid)),"^",2) 						// 单位
   	 s doclocid=$p(^OEORD(ord,"I",itm,7),"^",2)   		;060725
   	 s ifdocloc=..DoctorLocRefuse(locid,doclocid)  
   	 i ifdocloc=1 d
   	 .s admlocid=doclocid
   	 e  d 
     .s admlocid=wardlocid	// 医生科室发药为开单科室,病区发药为病区在科室表Id
     s admlocdesc=$p(^CTLOC(admlocid),"^",2)
	 s ^TMP("dhcpha","NOSTOCK",pid,oeori_"^"_dhcoedis)=oeori_"^"_admlocdesc_"^"_patno_"^"_incidesc_"^"_bed_"^"_name_"^"_confqty_"^"_orddate_"^"_dhcoedis 
	 i '$d(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,admlocid,patno,disptype,inci)) d
	 .s ^TMP("dhcpha","NOSTOCK","WARDPAT",pid,admlocid,patno,disptype,inci)=oeori_"^"_admlocdesc_"^"_patno_"^"_incidesc_"^"_bed_"^"_name_"^"_confqty_"^"_orddate_"^"_dhcoedis_"^"_buomdesc_"^"_adm_"^"_locdesc
	 e  d
	 .s $p(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,admlocid,patno,disptype,inci),"^",7)=$p(^TMP("dhcpha","NOSTOCK","WARDPAT",pid,admlocid,patno,disptype,inci),"^",7)+confqty
	 q 0
}

ClassMethod GetGroup(user As %String) As %String
{
	n (user) s user=$g(user) q:user="" 0
	i '$d(^SSU("SSUSR",user)) q 0
	s group=$p(^SSU("SSUSR",user),"^",5)
	q $g(group)
}

ClassMethod GetInciCode(arcimdesc As %String) As %String
{
	k code
	s itm=""
	s desc=$$ALPHAUP^SSUTIL4(arcimdesc)
	s itm=$o(^INCI(0,"Desc",desc,"")) q:itm="" ""
	s code=$p(^INCI(itm,1),"^",1)
	q code
}

ClassMethod LocUser(Loc As %String) As %Integer
{
	n user,num       
	k PLIST	s num=0 s user=""
	f  s user=$o(^SSU("SSUSR",user)) q:user=""  d
	.q:$p(^SSU("SSUSR",user),"^",4)'=Loc
	.s num=num+1
	.s PLIST(num)=$p(^SSU("SSUSR",user),"^",2)
	s PLIST=num
	q num
}

ClassMethod GrpUser(grp As %String) As %String
{
	n (grp)	q:grp="" ""
	s grp=+grp,user="",result=""
	f   s user=$o(^SSU("SSUSR",0,"Group",grp,user))  q:user=""  d
	. i result="" d
	. . s result=user
	. e  d
	. . s result=result_"^"_user
	q result
}

ClassMethod GetInternalType(loc As %String) As %String
{
	n (loc)
	s IntType=$p(^CTLOC(loc),"^",13)
	q IntType
}

ClassMethod GetLocDesc(LOC As %String) As %String
{
	n (LOC)	s LocDesc=""
	i LOC'="" s LocDesc=$p(^CTLOC(LOC),"^",1)
	q LocDesc
}

/// w ##class(web.DHCSTPCHCOLLS).AdmLocDisp("126","200")
ClassMethod AdmLocDisp(processid As %String, dept As %String) As %Integer
{

 n (processid,dept) 
 s num=0
 s TotalQty=0				//合计数量总计
 s TotalAmt=0				//合计金额总计
 s TotalAmtRp=0				//合计金额总计：进价
 s TotalDspQty=0  			//发药数量总计
 s TotalDspAmt=0  			//发药金额总计
 s TotalDspAmtRp=0  		//发药金额总计：进价
 s TotalRetQty=0  			//退药数量总计
 s TotalRetAmt=0  			//退药金额总计
 s TotalRetAmtRp=0  		//退药金额总计：进价
 ;总计     
 i dept=0 d
 .s inci="" 
 .f  s inci=$o(^TMP("dhcpha",processid,"locsum",inci)) q:inci=""  d
 ..s sub=""
 ..f  s sub=$o(^TMP("dhcpha",processid,"locsum",inci,sub)) q:sub=""  d
 ...s inciname=$p(^INCI(inci,1),"^",2)
 ...s incicode=$p(^INCI(inci,1),"^",1)
 ...;<----------------------------add by lq-------------------------------------------------------
 ...s rInciOriginalArcimDr=$p(^INCI(inci,1),"^",3) ;通过库存项的RowId取指向医嘱项的字段
 ...s rArcimRowId=rInciOriginalArcimDr ;指向医嘱项的内容=医嘱项的RowId
 ...s rSubscript=$p(rArcimRowId,"||",1) ;医嘱项RowId的前半部分
 ...s rVersion=$p(rArcimRowId,"||",2) ;医嘱项RowId的后半部分
 ...s rArcimPhcdfDr=$p(^ARCIM(rSubscript,rVersion,1),"^",12) ; 指向PHC_DrgForm
 ...s rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
 ...s rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
 ...q:(rPhcDrgForm1="")&(rPhcDrgForm2="") 
 ...q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2))
 ...s rPhcdfPhcfDr=$p($g(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,1)),"^",1) ;指向PHC_Form
 ...s rPhcfDesc=$p(^PHCF(rPhcdfPhcfDr),"^",2) ; 取剂型
 ...;s rmanf=##class(web.DHCSTKUTIL).GetManfNameByInci(inci) ;产地
 ...s rmanf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3) //厂家
 ...s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci) //2007-10-13
 ...s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) ;规格
 ...s uom=$p(^INCI(inci,1),"^",10)
 ...s uomname=$p(^CT("UOM",uom),"^",2)
 ...s phciprice=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",7)
 ...s rp=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",8)
 ...
 ...s dispqty=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",1)      ;发药数量
 ...s amt=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",2)			;发药金额
 ...s amtrp=+$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",3)		;发药金额：进价
 ...s retqty=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",4) 		;退药数量
 ...s retamt=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",5)		;退药金额
 ...s retamtrp=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",6)		;退药金额：进价
 ...
 ...s sumqty=dispqty-retqty
 ...s sumamt=amt-retamt
 ...s sumamtrp=amtrp-retamtrp
 ...
 ...s TotalQty=TotalQty+sumqty						//合计数量总计
 ...s TotalAmt=TotalAmt+sumamt						//合计金额总计
 ...s TotalAmtRp=TotalAmtRp+sumamtrp				//合计金额总计：进价
 ...s TotalDspQty=TotalDspQty+dispqty  					//发药数量总计
 ...s TotalDspAmt=TotalDspAmt+amt  						//发药金额总计
 ...s TotalDspAmtRp=TotalDspAmtRp+amtrp  				//发药金额总计：进价
 ...s TotalRetQty=TotalRetQty+retqty  					//退药数量总计
 ...s TotalRetAmt=TotalRetAmt+retamt  					//退药金额总计
 ...s TotalRetAmtRp=TotalRetAmtRp+retamtrp  			//退药金额总计：进价
 ...
 ...s subsumUom=##Class(web.DHCSTCOMINC).GetQtyIncUom(inci,sumqty)
 ...s num=num+1
 ...s ^TMP("dhcpha",processid,"ADMLOCDISP",num)=inciname_"&"_dispqty_"&"_retqty_"&"_sumqty_"&"_$g(uomname)_"&"_$g(sumamt)_"&"_$g(incicode)_"&"_rPhcfDesc_"&"_rmanf_"&"_Specifaction_"&"_phciprice_"&"_generic_"&"_subsumUom_"&"_"所有病区"_"&"_rp_"&"_sumamtrp_"&"_inci
 ..
 .s num=num+1 
 .s ^TMP("dhcpha",processid,"ADMLOCDISP",num)=""_"&"_TotalDspQty_"&"_TotalRetQty_"&"_TotalQty_"&&"_TotalAmt_"&"_"总计:"_"&&&&&&&&&"_TotalAmtRp_"&"_""
 .
 ;某一科室
 i dept>0 d
 .s inci=""
 .f  s inci=$o(^TMP("dhcpha",processid,"locsum1",dept,inci)) q:inci=""  d
 ..s sub=""
 ..f  s sub=$o(^TMP("dhcpha",processid,"locsum1",dept,inci,sub)) q:sub=""  d
 ...;w !,dept_"^"_inci_"^"_phciprice
 ...s ward=$p(^CTLOC(dept),"^",2)
 ...s inciname=$p(^INCI(inci,1),"^",2)
 ...s incicode=$p(^INCI(inci,1),"^",1)
 ...;<-----------------------------------------------------------------------------------
 ...s rInciOriginalArcimDr=$p(^INCI(inci,1),"^",3) ;通过库存项的RowId取指向医嘱项的字段
 ...s rArcimRowId=rInciOriginalArcimDr ;指向医嘱项的内容=医嘱项的RowId
 ...s rSubscript=$p(rArcimRowId,"||",1) ;医嘱项RowId的前半部分
 ...s rVersion=$p(rArcimRowId,"||",2) ;医嘱项RowId的后半部分
 ...s rArcimPhcdfDr=$p(^ARCIM(rSubscript,rVersion,1),"^",12) ; 指向PHC_DrgForm
 ...s rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
 ...s rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
 ...q:(rPhcDrgForm1="")||(rPhcDrgForm2="") 
 ...q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2))
 ...s rPhcdfPhcfDr=$p($g(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,1)),"^",1) ;指向PHC_Form
 ...s rPhcfDesc=$p($g(^PHCF(+rPhcdfPhcfDr)),"^",2) ; 取剂型
 ...;s rmanf=##class(web.DHCSTKUTIL).GetManfNameByInci(inci) ;产地
 ...s rmanf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3) //厂家
 ...s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci) ;通用名//2007-10-13
 ...;w !,generic
 ...s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) ;规格
 ...s phciprice=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",7)
 ...s rp=$p(^TMP("dhcpha",processid,"locsum",inci,sub),"&",8)
 ...s uom=$p(^INCI(inci,1),"^",10)
 ...s uomname=$p(^CT("UOM",uom),"^",2)
 ...
 ...s dispqty=+$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",1)
 ...s amt=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",2)
 ...s amtrp=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",3)
 ...s retqty=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",4) 
 ...s retamt=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",5)
 ...s retamtrp=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",6)
 ...
 ...s sumqty=dispqty-retqty
 ...s sumamt=amt-retamt
 ...s sumamtrp=amtrp-retamtrp
 ...
 ...s TotalQty=TotalQty+sumqty						//合计数量总计
 ...s TotalAmt=TotalAmt+sumamt						//合计金额总计
 ...s TotalAmtRp=TotalAmtRp+sumamtrp				//合计金额总计：进价
 ...s TotalDspQty=TotalDspQty+dispqty  					//发药数量总计
 ...s TotalDspAmt=TotalDspAmt+amt  						//发药金额总计
 ...s TotalDspAmtRp=TotalDspAmtRp+amtrp  				//发药金额总计：进价
 ...s TotalRetQty=TotalRetQty+retqty  					//退药数量总计
 ...s TotalRetAmt=TotalRetAmt+retamt  					//退药金额总计
 ...s TotalRetAmtRp=TotalRetAmtRp+retamtrp  			//退药金额总计：进价
 ...;-------------------------------------->
 ...s subsumUom=##Class(web.DHCSTCOMINC).GetQtyIncUom(inci,sumqty)
 ...s num=num+1
 ...s ^TMP("dhcpha",processid,"ADMLOCDISP",num)=inciname_"&"_dispqty_"&"_retqty_"&"_sumqty_"&"_$g(uomname)_"&"_$g(sumamt)_"&"_$g(incicode)_"&"_rPhcfDesc_"&"_rmanf_"&"_Specifaction_"&"_phciprice_"&"_generic_"&"_subsumUom_"&"_ward_"&"_rp_"&"_sumamtrp_"&"_inci
 ..
 .s num=num+1 
 .s ^TMP("dhcpha",processid,"ADMLOCDISP",num)=""_"&"_TotalDspQty_"&"_TotalRetQty_"&"_TotalQty_"&&"_TotalAmt_"&"_"总计:"_"&&&&&&&&&"_TotalAmtRp_"&"_""
 .
 q num
}

ClassMethod ListAdmLocDisp(processid As %String, n As %Integer) As %String
{
	i $d(^TMP("dhcpha",processid,"ADMLOCDISP",n)) q ^TMP("dhcpha",processid,"ADMLOCDISP",n)
	q ""
}

ClassMethod ClearColl(processid As %String) As %String
{
	q:processid="" 0
	k ^TMP("dhcpha",processid,"ADMLOCDISP")
	k ^TMP("dhcpha",processid,"locsum1")
	k ^TMP("dhcpha",processid,"locsum2")
	k ^TMP("dhcpha",processid,"locsum")
	k ^TMP("dhcpha",processid,"locsumitm")
	
	q 0
}

ClassMethod KillCollTmpGlobal(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String) As %String
{
	d ..ClearColl(pid)
	q ""
}

ClassMethod getpha(loc As %String) As %String
{
	n (loc)   i loc'="" d
	. s loc=$p(^CTLOC(loc),"^",2)
	i loc["-" s loc=$p(loc,"-",2)         
	q loc
}

ClassMethod GetOrderPriorty(phaci As %String) As %String
{
	n (phaci)
	s pha=+phaci,ch=$p(phaci,"||",2)
	s oedis=$p(^DHCPHAC(pha,"I",ch),"^",7)
	s oe=+oedis,itm=$p(oedis,"||",2)
	q:oe="" ""
	q:itm="" ""
	s priority=$p(^OEORD(oe,"I",itm,1),"^",8)
	q:priority="" ""
	s priority=$p(^OECPR(priority),"^",1)
 	q $p(priority,$c(1))
}

ClassMethod GetDispType(itmjs As %Library.String = "", itmjsex As %Library.String = "", phacrowid As %String) As %String
{
	n (phacrowid)
	&sql(select dhc_phaordtype into :disptype from dhc_phacollected
	where dhc_phacollect_rowid=:phacrowid)
	q $g(disptype)
}

ClassMethod CollectDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CollectDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query CollectDrug(displocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, Userid As %String, ByWardFlag As %String, LongOrdFlag As %String, ShortOrdFlag As %String, OutWithDrugFlag As %String, DispCat As %String, Adm As %String, DoctorLocRowid As %String, NotAudit As %String, StartTime As %String, EndTime As %String, incirowid As %String) As %Query(ROWSPEC = "TPID:%String,TInsuType:%String,TAdmLoc:%String,TBedNo:%String,TPaName:%String,TRegNo:%String,TDesc:%String,TQty:%String,TUom:%String,TSalePrice:%String,TOrdStatus:%String,TPhaCat:%String,TDoseQty:%String,TFreq:%String,TInstruction:%String,TDuration:%String,TPrescNo:%String,TBatchNo:%String,Toedis:%String,TAudited:%String,TGeneric:%String,TForm:%String,TBarcode:%String,TManufacture:%String,TIncStk:%String,TAmt:%String,TUserAdd:%String,TTimeAdd:%String,TDiagnose:%String,TAge:%String,Taction:%String,Tsex:%String,TinciQty:%String,Tstr:%String,TEncryptLevel:%String,TPatLevel:%String,TMainOrd:%String,TTimeDosing:%String,TUrgent:%String")
{
}

ClassMethod CollectDrugExecute(ByRef qHandle As %Binary, displocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, Userid As %String, ByWardFlag As %String, LongOrdFlag As %String, ShortOrdFlag As %String, OutWithDrugFlag As %String, DispCat As %String, Adm As %String, DoctorLocRowid As %String, NotAudit As %String, StartTime As %String, EndTime As %String, incirowid As %String) As %Status
{
	n (qHandle,displocrowid,wardrowid,StartDate,EndDate,Userid,ByWardFlag,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,Adm,DoctorLocRowid,NotAudit,StartTime,EndTime,incirowid,%session)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;
	
	q:displocrowid="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	//wyx 增加loclog取自登录科室session里的科室
	s loclog=%session.Data("LOGON.CTLOCID")
	//实现；
   	i NotAudit="on" s NotAudit=1 
   	e  s NotAudit=0
   
	Do ResetVariables
	
	;如果出院代药,类别应默认为发药科室的全部类别  LQ
	i OutWithDrugFlag="1"   s DispCat=##class(web.DHCSTPHALOC).GetPhaLocDisType(displocrowid)
	s dhcplrowid=$o(^DHCPL(0,"Loc",displocrowid,""))
	s displayemyflag=""
	i dhcplrowid'="" s displayemyflag=$p(^DHCPL(dhcplrowid),"^",24)
	i Adm="" d  // 按病区发药
	. s PID=..PCHCOLLS(displocrowid,wardrowid,StartDate,EndDate,Userid,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,NotAudit,StartTime,EndTime,incirowid,loclog)
	e  d  //按病人发药
	. s PID=..PCHCOLLADM(displocrowid,Adm,StartDate,EndDate,Userid,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,NotAudit,StartTime,EndTime,incirowid,loclog)
	q:PID="" $$$OK    // no Process ID returned
	d OutputRow
	k ^TMP("dhcpha",PID,"DISPD")
	k ^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",PID)
	k ^TMP("dhcpha",PID,"OEORI")
	Quit $$$OK
OutputRow
 	s TmpCat=""
 	f  s TmpCat=$o(^TMP("dhcpha",PID,"DispCat",TmpCat)) q:TmpCat=""  d
 	.s SubStr=""
 	.f  s SubStr=$o(^TMP("dhcpha",PID,"DispCat",TmpCat,SubStr)) q:SubStr=""  d
 	..s DataStr=^TMP("dhcpha",PID,"DispCat",TmpCat,SubStr)
 	..s AdmDr=$p(SubStr,"^",1)
 	..s papmidr=$p(^PAADM(AdmDr),"^",1)
 	..S EncryptLevelInfo=""
	..s EncryptLevel=""
	..s PatLevel=""
	..s HospID=""
    ..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospID)
    ..i EncryptFlag=1 d
 	...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 	...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	...s PatLevel=$p(EncryptLevelInfo,"^",2)
 	..s DateDosing=$p(SubStr,"^",2)
 	..s OrdItmRowid=$p(SubStr,"^",3)
 	..s Prescno=$p(DataStr,"^",1)
 	..s DspQty=$p(DataStr,"^",2)
 	..s BedNo=$p(DataStr,"^",3)
 	..s Sp=$p(DataStr,"^",4)
 	..s Sp=##class(web.DHCSTKUTIL).Getprice4(Sp)    ;格式化为四位小数
 	..//s SpAmt=DspQty*Sp
 	..s OeFlag=$p(DataStr,"^",5)
 	..s:OeFlag="V" OeFlag="核实"
 	..s AdmLoc=$p(DataStr,"^",6)
 	..s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2) 
 	..s BedId=$p(DataStr,"^",8)
 	..s InciId=$p(DataStr,"^",9)
 	..s DspIdStr=$p(DataStr,"^",10)
 	..s TimeDosing=$p(DataStr,"^",12)
 	..s RecLocId=$p(DataStr,"^",13)
 	..s DateTime=$p(DataStr,"^",14)
 	..s SpAmt=$p(DataStr,"^",15)
 	..s Batno=$p(DataStr,"^",16) 
 	..s OrdInfo=$g(^TMP("dhcpha",PID,"OEORI",OrdItmRowid))
 	..s SeqNo=$p(OrdInfo,"^",1)
	..s ArcimId=$p(OrdInfo,"^",2)                              ;ARCIM_RowId 
	..s PhcdfDr=$p(OrdInfo,"^",3)
	..s IssuType=$p(OrdInfo,"^",4) ;医保类别  
	..s PapmiId=$p(OrdInfo,"^",5) 
	..s PatName=$p(OrdInfo,"^",6) 
	..s PatNo=$p(OrdInfo,"^",7)
	..s ArcimDesc=$p(OrdInfo,"^",8)
	..s UomId=$p(OrdInfo,"^",9)
	..s Uom=$p(OrdInfo,"^",10)
	..s Priorty=$p(OrdInfo,"^",11)   		;医嘱优先级
	..s DoseQty=$p(OrdInfo,"^",12)       						;用药剂量
	..s Freq=$p(OrdInfo,"^",13)     			;用药频率 
	..s Instru=$p(OrdInfo,"^",14)        	;用法
	..s Duration=$p(OrdInfo,"^",15)        	;用药疗程
	..s Audited=$p(OrdInfo,"^",17)		;护士审核标志按配药记录走的，按医嘱没法显示
	..s Generic=$p(OrdInfo,"^",18)
	..s Form=$p(OrdInfo,"^",19)
	..s Spec=$p(OrdInfo,"^",20)
	..s Manf=$p(OrdInfo,"^",21)
	..s StkBin=$p(OrdInfo,"^",22) 					;货位
	..
	..s UserAdd=$p(OrdInfo,"^",23)       ;医生
	..s Diagnose=$p(OrdInfo,"^",24)
	..s Age=$p(OrdInfo,"^",25)					;PA_PatMas PAPMI_RowId 
	..s SkinTest=$p(OrdInfo,"^",26) 		;备注(皮试结果)
	..s SexDr=$p(OrdInfo,"^",27)
	..s Sex=$p(OrdInfo,"^",28)              
	..s IL=$o(^INCI("IL_LOC",RecLocId,InciId,"")) 
 	..i IL'=""  d
 	...s Incil=InciId_"||"_IL
 	...s InciQty=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,DspQty)  ;1,够发，0：不可发 
 	..e  d
 	...s Incil=""
 	...s InciQty=0
 	..
 	..s MainOrd=..GetMainOrdRowid(OrdItmRowid) 
    ..s ArcDateStr=..GetArcEndFlag(OrdItmRowid)
    ..s ArcFlag=$p(ArcDateStr,"^",1)
    ..s:ArcFlag=-1 ^TMP("dhcpha",PID,"arcEndDate",MainOrd)=""   ;医嘱项到期，,保存数据时用
    ..s ArcEndDateFlag=0
    ..s:ArcFlag=-1 ArcEndDateFlag=1							;医嘱项到期
    ..s ArcEndDate=$p(ArcDateStr,"^",2)     
    ..
    ..i InciQty=0  s ^TMP("dhcpha",PID,"NoStockOrd",SubStr)="" ;构造库存不足的医嘱项,保存数据时用
	..i displayemyflag="Y" s Urgent=$p($g(^OEORD(+OrdItmRowid,"I",$p(OrdItmRowid,"||",2),11)),"^",55) //加急
	..e  s Urgent=""
	..s CookType=..GetCookType(Prescno)     ;草药煎药方式
    ..i ArcEndDate'="" s ArcEndDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ArcEndDate,"IP")
    ..s Bill=""
	..i $d(^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",PID,AdmDr)) s Bill="欠费"
	..s coltype=..GetColorType(InciQty,ArcEndDateFlag)
	..s Str=CookType_"^"_SeqNo_"^"_ArcEndDate_"^"_ArcEndDateFlag_"^"_Bill_"^"_DspIdStr_"^"_coltype
	..set Data=$lb(PID,IssuType,AdmLocDesc,BedNo,PatName,PatNo,ArcimDesc,DspQty,Uom,Sp,OeFlag,Priorty,DoseQty,Freq,Instru,Duration,Prescno,Batno,OrdItmRowid,Audited,Generic,Form,Spec,Manf,StkBin,SpAmt,UserAdd,DateTime,Diagnose,Age,SkinTest,Sex,InciQty,Str,EncryptLevel,PatLevel,MainOrd,TimeDosing,Urgent)
	..Set ^CacheTemp(repid,ind)=Data	
	..Set ind=ind+1
	.
	quit

ResetVariables
	set (PID,issutype,admloc,bedno,paname,registerno,arcimdesc,qty,uom,sp,ordstatus,phatype,dosage,freq,instr,duration,prescno,batno,ordis,audited,sex,iniQty,str,EncryptLevel,PatLevel)=""
	quit
}

ClassMethod CollectDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CollectDrugExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
	}
	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DispListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DispListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, Userid As %String, dispcatvalue As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, DispNo As %String, PamStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s contentstr=""
	//实现；
	//PamStr="登记号^长嘱标志^临嘱标志    lq 
	q:$g(displocrowid)="" $$$OK
	q:$g(StartDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime) 
	i +dispcatvalue'=0 d
	.s dispcatvalue=$p($g(^DHCSTDRUGGRP(dispcatvalue)),"^",1)
	i Userid["^" d
	.i ($p(Userid,"^",2)="id")&&($p(Userid,"^",1)'="") s Userid=$p($g(^SSU("SSUSR",+Userid)),"^",1)
	s tmp=$$GetColl(StartDate,EndDate,displocrowid,wardrowid,Userid,dispcatvalue,StartTime,EndTime,DoctorLocRowid,DispNo,PamStr)
	s cnt=$p(tmp,"^",1)
	s pid=$p(tmp,"^",2)
	s i=1
	//w !,"<font color=#EA2000><b>发药单数:　"_cnt_"</b></font>"
	f i=1:1:cnt   d
	. s dispm=^TMP("dhcpha",pid,"DISPMQ",i)
	. q:dispm=""
	. d OutputRow1
	;k ^TMP("dhcpha",pid,"DISPMQ")
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    i (EncryptFlag=1)&(contentstr'="") d
    .s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("StartDate^EndDate^displocrowid^wardrowid^Userid^dispcatvalue^StartTime^EndTime^DoctorLocRowid^DispNo",StartDate_"^"_EndDate_"^"_displocrowid_"^"_wardrowid_"^"_Userid_"^"_dispcatvalue_"^"_StartTime_"^"_EndTime_"^"_DoctorLocRowid_"^"_DispNo)
    .s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("发药ID^ward^type^status^date^time",contentstr)
    .s EncryptCode=$o(^User.DHCSecretLevelI("Code",""))
    .s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPQUERY",condition,content,EncryptCode)   //记录日志
	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow1
	s coll=$p(dispm,"&",1)
	s collward=$p(dispm,"&",2)
	i collward["-" s collward=$p(collward,"-",2,$l(collward,"-"))
	s colltype=$p(dispm,"&",3)
	s colldatescope=$p(dispm,"&",4)
	s collstatus=$p(dispm,"&",5)
	i collstatus="Collect" s collstatus="已发药"
	e  i collstatus="Print" s collstatus="已打印"
	s collcount=$p(dispm,"&",6)
	s collpdate=$p(dispm,"&",7)
	s collptime=$p(dispm,"&",8)
	s collcdate=$p(dispm,"&",9)
	s collctime=$p(dispm,"&",10)
	s colluser=$p(dispm,"&",11)
	s collcuser=$p(dispm,"&",12)
	s colldispno=$p(dispm,"&",13)
	s collsendautoflag=$p(dispm,"&",14)
	i contentstr="" d
	.s contentstr=coll_"^"_collward_"^"_colltype_"^"_collstatus_"^"_collpdate_"^"_collptime
	
	;coll,TWard,TDispCat,TDateScope,TStatus,TPrintDate,TPrintTIme,TCollectDate,TCollectTime,TOperUser"	
	s Data=$lb(coll,collward,colltype,colldatescope,collstatus,collpdate,collptime,collcdate,collctime,colluser,collcuser,colldispno,collsendautoflag,pid)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
GetColl(datef,datet,pha,ward,user,type,StartTime,EndTime,DoctorLocRowid,dispno,pamstr)
	q:datef="" ""
	q:datet="" ""
	q:pha="" ""
	s dispno=$zcvt(dispno,"U") //不区分大小写
 	i $g(StartTime)="" s StartTime=$zth("00:00:00",3)       ;0
 	i $g(EndTime)="" s EndTime=$zth("23:59:59",3)       ;86399
 	
	s ward=$g(ward),user=$g(user),type=$g(type)  
	s num=0
	s regno="",longord="",shortord="",retflag=""

    s regno=$p(pamstr,"^",1)
    s longord=$p(pamstr,"^",2)
    s shortord=$p(pamstr,"^",3)
    ;i $l(pamstr,"^")=3   s shortord=$p(pamstr,"^",3)
    ;
	s pid=..NewPid()  ;
	f date=datef:1:datet d
	.s coll="" f  s coll=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,coll)) q:coll=""  d            ;
	..s collward=$p(^DHCPHAC(coll),"^",4) 
	..s colluser=$p(^DHCPHAC(coll),"^",5)
	..s colltype=$p(^DHCPHAC(coll),"^",12)
	..s colldate=$p(^DHCPHAC(coll),"^",2)
	..s colltime=$p(^DHCPHAC(coll),"^",3)
	..i colldate=datef q:(colltime<StartTime)
	..i colldate=datet q:(colltime>EndTime)
	..
	..s tmpdocloc=..DocLoc(coll) ;20070404
	..;q:(DoctorLocRowid'="")&(collward'="") ;20070404
	..q:(DoctorLocRowid'="")&($g(tmpdocloc)'=DoctorLocRowid) ;20070404
	..
	..i ward'="" q:collward'=ward
	..i type'="" q:colltype'=type
	..s user1="" //2007-10-26
	..i user'="" s user1=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(user),user1)) //2007-10-26 根据科室与人员对应表找人员userid
	..i user1'="" q:colluser'=user1 //2007-10-26
	..i collward'="" s collward=$p(^PAWARD(collward),"^",2)       
	..i colluser'="" s colluser=$p($g(^SSU("SSUSR",colluser)),"^",2)
	..i colltype'="" s colltype=..DispCatDesc(colltype)
	..i collward="" d
	...;s collward=$g(tmpdocloc) ;20070404
	...&sql(select ctloc_desc into :tmpdoclocdesc from ct_loc where ctloc_rowid=:tmpdocloc)
	...s collward=$g(tmpdoclocdesc)
	..i pamstr'="" s retflag=..ChkPhaItmInfo(coll,pamstr)
	..q:(retflag=0)&(pamstr'="")
	..s collpdate=$p(^DHCPHAC(coll),"^",7) i collpdate'="" s collpdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(collpdate)
	..s collptime=$p(^DHCPHAC(coll),"^",8) i collptime'="" s collptime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(collptime)
	..s collcdate=$p(^DHCPHAC(coll),"^",2) i collcdate'="" s collcdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(collcdate)
	..s collctime=$p(^DHCPHAC(coll),"^",3) i collctime'="" s collctime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(collctime)
	..s collcount=$p(^DHCPHAC(coll),"^",9)
	..s collcuser=$p(^DHCPHAC(coll),"^",13) i collcuser'="" s collcuser=$p(^SSU("SSUSR",collcuser),"^",2)
	..s collstatus=$p(^DHCPHAC(coll),"^",6)
	..s colldatef=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(^DHCPHAC(coll),"^",10))
	..s colldatet=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(^DHCPHAC(coll),"^",11))
	..s colldispno=$p(^DHCPHAC(coll),"^",14)
	..s collsendautoflag=$p(^DHCPHAC(coll),"^",15)
	..//q:(dispno'="")&(colldispno'=dispno)
	..q:(dispno'="")&(colldispno'[dispno)  //实现单号的模糊查询
	..s collprintflag=$p(^DHCPHAC(coll),"^",16)
	..s num=num+1
	..s ^TMP("dhcpha",pid,"DISPMQ",num)=coll_"&"_collward_"&"_colltype_"&"_colldatef_"至"_colldatet_"&"_collstatus_"&"_collcount_"&"_collpdate_"&"_collptime_"&"_collcdate_"&"_collctime_"&"_colluser_"&"_collcuser_"&"_$g(colldispno)_"&"_collsendautoflag_"&"_collprintflag
	..;s mPLIST(num)=coll_"&"_collward_"&"_colltype_"&"_colldatef_"-"_colldatet_"&"_collstatus_"&"_collcount_"&"_collpdate_"&"_collptime_"&"_collcdate_"&"_collctime_"&"_colluser_"&"_collcuser
	.;
	q num_"^"_pid

ResetVariables1
	q
}

Query DispList(StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, Userid As %String, dispcatvalue As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, DispNo As %String, PamStr As %String) As %Query(ROWSPEC = "Tcoll:%String,TWard:%String,TDispCat:%String,TDateScope:%String,TStatus:%String,TPrintDate:%String,TPrintTime:%String,TCollectDate:%String,TCollectTime:%String,TOperUser:%String,TCollectUser:%String,TDispNo:%String,TSendAutoFlag:%String,Tpid:%String")
{
}

ClassMethod DispListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DispStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLS","DispStat","2016-05-08","2018-05-08","310","","00:00","23:59","","1","","","","")
ClassMethod DispStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, dispcatval As %String, StartTime As %String, EndTime As %String, incirowid As %String, statflag As %String, tPhcCatRowid As %String, IncludeDispF As %String, tRegNo As %String, stkgrp As %String) As %Status
{
	s IncludeDispF="on"
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i StartDate="" s qHandle=$lb(0,repid,0) q $$$OK
	i EndDate="" s qHandle=$lb(0,repid,0) q $$$OK
	i displocrowid="" s qHandle=$lb(0,repid,0) q $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	//实现；
	s SessionLocID=$g(%session.Data("LOGON.CTLOCID"))
	s pno=$$TotalColl(StartDate,EndDate,displocrowid,dispcatval,StartTime,EndTime,incirowid,statflag,tPhcCatRowid,IncludeDispF,SessionLocID,tRegNo,stkgrp)
	s admlocs=$$PopulateLocs(pno)
	s i=1 
	f  s admloc=$p(admlocs,"^",i)  q:admloc=""  d
	. d OutputRow2
	. s i=i+1
	
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	s locrowid=$p(admloc,"#",1)
	s locdesc=$p(admloc,"#",2)
	i $f(locdesc,"-") s locdesc=$p(locdesc,"-",2)
	s Data=$lb(pno,locrowid,locdesc)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
TotalColl(datef,datet,pha,type,stime,etime,inci,statflag,tPhcCatRowid,IncludeDispF,SessionLocID,tRegNo,stkgrp) 
	n (datef,datet,pha,type,stime,etime,inci,statflag,tPhcCatRowid,IncludeDispF,SessionLocID,tRegNo,stkgrp)
	s pid=..NewPid() 
	d ..ClearColl(pid)
	i $g(stime)="" s stime=$zth("00:00:00",3)       ;0
	i $g(etime)="" s etime=$zth("23:59:59",3)       ;86399
	;
	s i=0
	;
	s statflag=$g(statflag)
	s loctype=$p(^CTLOC(SessionLocID),"^",13)  // ;特殊科室查询,如科室类型'="Dispensing" 
	i loctype'="D" d 
	.s oploc=SessionLocID
	e  d
	.s oploc=""
	s daterange=datef_"^"_datet
	s timerange=stime_"^"_etime
	f date=datef:1:datet d
	.;统计住院发药
	.s ret=..CollectPhaDsp(pid,date,daterange,pha,type,timerange,inci,statflag,oploc,stkgrp)
	.
	.;统计住院退药
	.s ret=..CollectPhaRet(pid,date,daterange,pha,type,timerange,inci,statflag,oploc,stkgrp)
	.;Q:IncludeDispF'="on"	//不统计门诊
	.Q:statflag="1"			//按病区统计
	.Q:type'=""				//选择发药类别
	.
	.;统计门诊发药
	.s ret=..CollectOutPhDsp(pid,date,daterange,pha,timerange,inci,stkgrp)
	.
	.;统计门诊退药
	.s ret=..CollectOutPhRet(pid,date,daterange,pha,timerange,inci,stkgrp)
	.
	q pid
 
PopulateLocs(processno)
 n (processno)
 s loc="",result=""
 f  s loc=$o(^TMP("dhcpha",processno,"locsum1",loc)) q:loc=""  d 
 . s locdesc=$p($G(^CTLOC(loc)),"^",2)
 . s tmp=loc_"#"_locdesc
 . i result="" d
 . . s result=tmp
 . e  d
 . . s result=result_"^"_tmp
 . 
 s tmp="0"_"#"_"总计"
 s result=result_"^"_tmp
 q $g(result)
}

/// Descriprtion:统计住院发药数据
/// Input:进程id,统计日期，日期范围（开始日期^截止日期）,发药科室id,发药类别,
/// 时间范围（开始时间^截止时间）,药品id,统计方式(1:按病区;0:按科室),特殊科室（用于特殊科室查询）
/// Output: 
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-27
ClassMethod CollectPhaDsp(pid As %String, date As %String, daterange As %String, pha As %String, dispcatval As %String, timerange As %String, incirowid As %String, statflag As %String, oploc As %String, stkgrp As %String) As %String
{
	n (pid,date,daterange,pha,dispcatval,timerange,incirowid,statflag,oploc,stkgrp)
	s datef=$p(daterange,"^",1)
	s datet=$p(daterange,"^",2)
	s stime=$p(timerange,"^",1)
	s etime=$p(timerange,"^",2)
	q:pid="" ""
	q:date="" ""
	s i=0
	s intr=""
	F  S intr=$O(^DHCINTR(0,"TypeDate","P",date,intr)) Q:intr=""  D
	.S phcirowid=$P(^DHCINTR(intr),"^",9)	//pointer -发药批次表RowID
	.Q:phcirowid=""
	.S phccid=$P(phcirowid,"||",1)
	.Q:phccid=""
	.Q:'$D(^DHCPHAC(phccid))
	.S phccitm=$P(phcirowid,"||",2)
	.Q:phccitm=""
	.q:'$d(^DHCPHAC(phccid,"I",phccitm))
	.s phcil=$p(phcirowid,"||",3)
	.q:phcil=""
	.S Phaloc=$P(^DHCPHAC(phccid),"^",1)
	.Q:Phaloc'=pha
	.s dispcat=$p(^DHCPHAC(phccid),"^",12)
	.q:(dispcatval'="")&&('$f(dispcatval,dispcat))   ;发药类别不在查询的范围内
	.s time=$p(^DHCPHAC(phccid),"^",3)
	.Q:(date=datef)&(time<stime)
	.Q:(date=datet)&(time>etime) 
	.S oedis=$P(^DHCPHAC(phccid,"I",phccitm),"^",7)
	.S ord=$P(oedis,"||",1)
	./// 登记号
	.S adm=$P(^OEORD(ord),"^",1)	/// 病人 PAADM_Rowid
	.S pat=##class(web.DHCSTPIVA).GetPat(adm)
	.S ipno=$P(pat,"^",1)
	.s phciinci=$P(^DHCINTR(intr),"^",15)
	.s phciinci=+phciinci
	.q:(incirowid'="")&&(phciinci'=incirowid)
	.s scg=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(phciinci)
	.s scg=$p(scg,"^",5)
	.q:(+stkgrp'=0)&&(+stkgrp'=scg)
 	.q:'$d(^DHCPHAC(phccid,"I",phccitm,"B",phcil))
 	.s inclb=$p(^DHCPHAC(phccid,"I",phccitm,"B",phcil),"^",1)
	.s phciqty=$p(^DHCPHAC(phccid,"I",phccitm,"B",phcil),"^",2)
	.s Rp=$p(^DHCPHAC(phccid,"I",phccitm,"B",phcil),"^",3)
	.s RpAmt=$p(^DHCPHAC(phccid,"I",phccitm,"B",phcil),"^",4)
	.s phciprice=$p(^DHCPHAC(phccid,"I",phccitm,"B",phcil),"^",5) //$p(^DHCPHAC(phccid,"I",phccitm),"^",9)
	.//s phciprice=$fn(phciprice,"",4)
	.s phciloc=+$p(^DHCPHAC(phccid,"I",phccitm),"^",11)   ;adm loc
	.q:'$d(^INCI(phciinci,1)) 
	.s pakuom=$p(^INCI(phciinci,1),"^",10)
	.s cost=$p(^DHCPHAC(phccid,"I",phccitm,"B",phcil),"^",6) //phciqty*phciprice
	.S pawarddr=$p(^DHCPHAC(phccid),"^",4)
	.s phadocloc=$p($g(^DHCPHAC(phccid,1)),"^",10)
	.I pawarddr="" D
	..i phadocloc="" d
	...s tmpdocloc=..DocLoc(phccid)
	...s phciloc=tmpdocloc
	.i statflag="1" d  ;070911 选择按病区统计
	..s phciloc=$p(^DHCPHAC(phccid),"^",4)
	..i phciloc="" d
	...i phadocloc="" d
	....s phciloc=..DocLoc(phccid)
	...e  s phciloc=phadocloc
	..e  s phciloc=$p($g(^PAWARD(phciloc)),"^",5) 
	.q:(oploc'="")&&(oploc'=phciloc)  ;特殊科室查询 
	.;各种药的总数量和总金额
	.s sub=phciprice_"^"_Rp
	.;发药统计-点击总计查看所有药品
	.i $d(^TMP("dhcpha",pid,"locsum",phciinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",1)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",1)+phciqty
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",2)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",2)+cost
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",3)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",3)+RpAmt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum",phciinci,sub)=phciqty_"&"_cost_"&"_RpAmt_"&"_0_"&"_0_"&"_0_"&"_phciprice_"&"_Rp
	.
	.;发药统计-选择若干科室（病区）查看药品
	.i $d(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",1)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",1)+phciqty
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",2)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",2)+cost
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",3)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",3)+RpAmt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub)=phciqty_"&"_cost_"&"_RpAmt_"&"_0_"&"_0_"&"_0_"&"_phciprice_"&"_Rp
	.
	.;发药统计-双击药品查看明细	
	.s i=1+$o(^TMP("dhcpha",pid,"locsumitm",phciinci,phciloc,""),-1)
	.s ^TMP("dhcpha",pid,"locsumitm",phciinci,phciloc,i)=oedis_"^"_adm_"^"_phciqty_"^"_phciprice_"^"_cost_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"IP")_"^"_pawarddr_"^"_RpAmt_"^"_Rp
	.
	q i
}

/// Descriprtion:统计住院退药数据
/// Input:进程id,统计日期，日期范围（开始日期^截止日期）,发药科室id,发药类别,
/// 时间范围（开始时间^截止时间）,药品id,统计方式(1:按病区;0:按科室),特殊科室（用于特殊科室查询）
/// Output: 
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-27
ClassMethod CollectPhaRet(pid As %String, date As %String, daterange As %String, pha As %String, dispcatval As %String, timerange As %String, incirowid As %String, statflag As %String, oploc As %String, stkgrp As %String) As %String
{
	n (pid,date,daterange,pha,dispcatval,timerange,incirowid,statflag,oploc,stkgrp)
	s datef=$p(daterange,"^",1)
	s datet=$p(daterange,"^",2)
	s stime=$p(timerange,"^",1)
	s etime=$p(timerange,"^",2)
	q:pid="" ""
	q:date="" ""
	s i=0
	s intr=""
	F  S intr=$O(^DHCINTR(0,"TypeDate","Y",date,intr)) Q:intr=""  D
	.S ret=$P(^DHCINTR(intr),"^",9)	//pointer -退药批次表RowID
	.Q:ret=""
	.s retchl=$p(ret,"||",2)
	.s retil=$p(ret,"||",3)
	.s ret=+ret
	.Q:'$D(^PHARET(ret))
	.S Recloc=$P(^PHARET(ret),"^",5)
	.Q:Recloc'=pha
	.s tt=$p(^PHARET(ret),"^",2)
	.Q:(date=datef)&(tt<stime)
	.Q:(date=datet)&(tt>etime)
	.q:'$d(^PHARET(ret,"I",retchl))
	.s rinci=$p(^PHARET(ret,"I",retchl),"^",11) 
	.q:rinci=""
	.q:(incirowid'="")&(rinci'=incirowid)
	.s scg=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(rinci)
	.s scg=$p(scg,"^",5)
	.q:(+stkgrp'=0)&&(+stkgrp'=scg)
	.s pakuom=$p(^INCI(rinci,1),"^",10)
	.q:'$d(^PHARET(ret,"I",retchl,"B",retil))
	.s retqty=+$p(^PHARET(ret,"I",retchl,"B",retil),"^",2)     ;qty数量
	.s rp=+$p(^PHARET(ret,"I",retchl,"B",retil),"^",3) 	
	.s rpamt=+$p(^PHARET(ret,"I",retchl,"B",retil),"^",4) 
	.s sprice=+$p(^PHARET(ret,"I",retchl,"B",retil),"^",5) //$p(^PHARET(ret,"I",retchl),"^",4)  ;price价格
	.//s sprice=$fn(sprice,"",4)
	.s retcost=+$p(^PHARET(ret,"I",retchl,"B",retil),"^",6)  //总金额
	.//s retloc=$p(^PHARET(ret,"I",retchl),"^",9)   //就诊科室
	.//s:retloc="" retloc=$p(^PHARET(ret),"^",6) 
	.//s retloc=+retloc
	.
	.s oedis=$p(^PHARET(ret,"I",retchl),"^",1)
	.s retloc=..UserDept(oedis)   //取医生科室
	.s dspcat=..OrdCatType(oedis)
	.q:(dispcatval'="")&('$f(dispcatval,dspcat))
	.S ord=$P(oedis,"||",1)
	./// 登记号
	.S adm=$P(^OEORD(ord),"^",1)	/// 病人 PAADM_Rowid
	.i statflag="1" d
	..s retloc=$p(^PHARET(ret),"^",6 ) ;按病区
	.
	.q:(oploc'="")&&(oploc'=retloc)  ;特殊科室查询
	.S pawarddr=$p(^PHARET(ret),"^",6)
	.s:pawarddr'="" pawarddr=$o(^PAWARD(0,"WARD_LocationDR",pawarddr,""))
	.I (pawarddr="")&(adm'="") S pawarddr=$p($G(^PAADM(adm)),"^",70)
	.;各种药的总数量和总金额
	.s sub=sprice_"^"_rp
	.
	.;发药统计-点击总计查看所有药品
	.i $d(^TMP("dhcpha",pid,"locsum",rinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum",rinci,sub),"&",4)=+$p(^TMP("dhcpha",pid,"locsum",rinci,sub),"&",4)+retqty
	..s $p(^TMP("dhcpha",pid,"locsum",rinci,sub),"&",5)=+$p(^TMP("dhcpha",pid,"locsum",rinci,sub),"&",5)+retcost
	..s $p(^TMP("dhcpha",pid,"locsum",rinci,sub),"&",6)=+$p(^TMP("dhcpha",pid,"locsum",rinci,sub),"&",6)+rpamt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum",rinci,sub)=0_"&"_0_"&"_0_"&"_retqty_"&"_retcost_"&"_rpamt_"&"_sprice_"&"_rp
	.
	.;发药统计-选择若干科室（病区）查看药品
	.i $d(^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub),"&",4)=+$p(^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub),"&",4)+retqty
	..s $p(^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub),"&",5)=+$p(^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub),"&",5)+retcost
	..s $p(^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub),"&",6)=+$p(^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub),"&",6)+rpamt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum1",retloc,rinci,sub)=0_"&"_0_"&"_0_"&"_retqty_"&"_retcost_"&"_rpamt_"&"_sprice_"&"_rp
	.
	.;发药统计-双击药品查看明细	
	.s i=2 //1+$o(^TMP("dhcpha",pid,"locsumitm",rinci,retloc,""),-1)
	.s ^TMP("dhcpha",pid,"locsumitm",rinci,retloc,i)=oedis_"^"_adm_"^"_retqty_"^"_sprice_"^"_retcost_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"IP")_"^"_pawarddr_"^"_rpamt_"^"_rp
	.
	q i
}

/// Descriprtion:统计门诊发药数据
/// Input:进程id,统计日期，日期范围（开始日期^截止日期）,发药科室id,
/// 时间范围（开始时间^截止时间）,药品id
/// Output: 
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-27
ClassMethod CollectOutPhDsp(pid As %String, date As %String, daterange As %String, pha As %String, timerange As %String, incirowid As %String, stkgrp As %String) As %String
{
	n (pid,date,daterange,pha,timerange,incirowid,stkgrp)
	s datef=$p(daterange,"^",1)
	s datet=$p(daterange,"^",2)
	s stime=$p(timerange,"^",1)
	s etime=$p(timerange,"^",2)
	q:pid="" ""
	q:date="" ""
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(pha)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
	s i=0
	s intr=""
	F  S intr=$O(^DHCINTR(0,"TypeDate","F",date,intr)) Q:intr=""  D
	.S phdicrowid=$P(^DHCINTR(intr),"^",9)	//pointer -DHC_PHDISITMCLB表RowID
	.Q:phdicrowid=""
	.S phd=$P(phdicrowid,"||",1)
	.S phdisub=$P(phdicrowid,"||",2)
	.S phdicsub=$P(phdicrowid,"||",3)
	.Q:phd=""
	.Q:phdisub=""
	.Q:phdicsub=""
	.Q:'$D(^DHCPHDISP(phd))
	.Q:'$D(^DHCPHDI(phd,"PHDI",phdisub))
	.Q:'$D(^DHCPHDI(phd,"PHDI",phdisub,"INCLB",phdicsub))
	.S inclb=$P(^DHCINTR(intr),"^",7)
	.Q:inclb=""
	.S incil=$P(inclb,"||",1,2)
	.;S Phdloc=##Class(web.DHCST01).LOC(inclb)       
	.S Phdloc=##Class(web.DHCSTDISPSTATDM).GetRecLocDR(inclb)
	.Q:Phdloc'=pha
	.s time=""
	.s time=$p(^DHCINTR(intr),"^",3)
	.Q:(date=datef)&(time<stime)
	.Q:(date=datet)&(time>etime)
	.s phciinci=$p(inclb,"||",1)
	.q:(incirowid'="")&(phciinci'=incirowid)
	.q:'$d(^INCI(phciinci,1))
	.q:(+stkgrp'=0)&&(+stkgrp'=$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(phciinci),"^",5))
	.s phciqty=-$p(^DHCINTR(intr),"^",6)
	.s phciprice=$p(^DHCINTR(intr),"^",14)
	.//s phciprice=$fn(phciprice,"",4)
	.s cost=$p(^DHCPHDI(phd,"PHDI",phdisub,"INCLB",phdicsub),"^",8)
	.S truom=$p(^DHCINTR(intr),"^",10)
	.s pakuom=$p(^INCI(phciinci,1),"^",10)
	.S fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(truom,pakuom)
	.S phcibqty=phciqty*fac
	.s rpamt=$p(^DHCPHDI(phd,"PHDI",phdisub,"INCLB",phdicsub),"^",6)
	.s rp=$p(^DHCINTR(intr),"^",16)
	.S:fac'=0 phciprice=phciprice/fac,rp=rp/fac 
	.s oeori=$p(^DHCPHDI(phd,"PHDI",phdisub),"^",5)
	.Q:oeori=""
	.s ord=$p(oeori,"||",1)
	.S itm=$p(oeori,"||",2)
	.Q:'$D(^OEORD(ord))
	.S paadmdr=$P(^OEORD(ord),"^",1)
	.Q:paadmdr=""
	.s phciloc=0
	.S phcilocdesc=""
	.I paadmdr'="" D
	..S phciloc=$P($G(^PAADM(paadmdr)),"^",4)
	..I phciloc'="" S phcilocdesc=$P($G(^CTLOC(phciloc)),"^",2)
	.S:phcilocdesc="" phcilocdesc="其它"
	.S:phciloc="" phciloc="0"
	.s pawarddr=""
	.s sub=phciprice_"^"_rp
	.
	.;发药统计-点击总计查看所有药品
	.i $d(^TMP("dhcpha",pid,"locsum",phciinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",1)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",1)+phcibqty
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",2)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",2)+cost
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",3)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",3)+rpamt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum",phciinci,sub)=phcibqty_"&"_cost_"&"_rpamt_"&"_0_"&"_0_"&"_0_"&"_phciprice_"&"_rp
	.
	.;发药统计-选择若干科室（病区）查看药品
	.i $d(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",1)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",1)+phcibqty
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",2)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",2)+cost
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",3)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",3)+rpamt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub)=phcibqty_"&"_cost_"&"_rpamt_"&"_0_"&"_0_"&"_0_"&"_phciprice_"&"_rp
	.
	.;发药统计-双击药品查看明细	
	.s i=1+$o(^TMP("dhcpha",pid,"locsumitm",phciinci,phciloc,""),-1)
	.s ^TMP("dhcpha",pid,"locsumitm",phciinci,phciloc,i)=oeori_"^"_paadmdr_"^"_phcibqty_"^"_phciprice_"^"_cost_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"IP")_"^"_pawarddr_"^"_rpamt_"^"_rp
	.
	q i
}

/// Descriprtion:统计门诊退药数据
/// Input:进程id,统计日期，日期范围（开始日期^截止日期）,发药科室id,
/// 时间范围（开始时间^截止时间）,药品id
/// Output: 
/// Table:
/// Creator:zhangdongmei
/// CreatDate:2012-03-27
ClassMethod CollectOutPhRet(pid As %String, date As %String, daterange As %String, pha As %String, timerange As %String, incirowid As %String, stkgrp As %String) As %String
{
	n (pid,date,daterange,pha,timerange,incirowid,stkgrp)
	s datef=$p(daterange,"^",1)
	s datet=$p(daterange,"^",2)
	s stime=$p(timerange,"^",1)
	s etime=$p(timerange,"^",2)
	q:pid="" ""
	q:date="" ""
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(pha)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
	s i=0
	s intr=""
	F  S intr=$O(^DHCINTR(0,"TypeDate","H",date,intr)) Q:intr=""  D
	.S phdicrowid=$P(^DHCINTR(intr),"^",9)	//pointer -DHC_PHDISITMCLB表RowID
	.Q:phdicrowid=""
	.S phret=$P(phdicrowid,"||",1)
	.S phretisub=$P(phdicrowid,"||",2)
	.Q:phret=""
	.Q:phretisub=""
	.Q:'$D(^DHCPHRET(phret))
	.Q:'$D(^DHCPHRTI(phret,"RTI",phretisub))
	.S inclb=$P(^DHCINTR(intr),"^",7)
	.Q:inclb=""
	.S incil=$P(inclb,"||",1,2)
	.;S Phdloc=##Class(web.DHCST01).LOC(inclb)
	.S Phdloc=##Class(web.DHCSTDISPSTATDM).GetRecLocDR(inclb)
	.Q:Phdloc'=pha
	.s time=""
	.s time=$p(^DHCINTR(intr),"^",3)
	.Q:(date=datef)&(time<stime)
	.Q:(date=datet)&(time>etime)
	.s phciinci=$p(inclb,"||",1)
	.q:(incirowid'="")&(phciinci'=incirowid)
	.q:'$d(^INCI(phciinci,1))
	.q:(+stkgrp'=0)&&(+stkgrp'=$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(phciinci),"^",5))
	.s phciqty=$p(^DHCINTR(intr),"^",6)
	.s phciprice=$p(^DHCINTR(intr),"^",14)
	.//s phciprice=$fn(phciprice,"",4)
	.s cost=$p(^DHCINTR(intr),"^",8)
	.S truom=$p(^DHCINTR(intr),"^",10)
	.s pakuom=$p(^INCI(phciinci,1),"^",10)
	.S fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(truom,pakuom)
	.S phcibqty=phciqty*fac
	.s rp=$p(^DHCINTR(intr),"^",16)
	.s rpamt=$p(^DHCINTR(intr),"^",17)
	.S:fac'=0 phciprice=phciprice/fac,rp=rp/fac
	.s oeori=$p(^DHCPHRTI(phret,"RTI",phretisub),"^",2)
	.Q:oeori=""
	.s ord=$p(oeori,"||",1)
	.S itm=$p(oeori,"||",2)
	.Q:'$D(^OEORD(ord))
	.S paadmdr=$P(^OEORD(ord),"^",1)
	.Q:paadmdr=""
	.s phciloc=0
	.S phcilocdesc=""
	.I paadmdr'="" D
	..S phciloc=$P($G(^PAADM(paadmdr)),"^",4)
	..I phciloc'="" S phcilocdesc=$P($G(^CTLOC(phciloc)),"^",2)
	.S:phcilocdesc="" phcilocdesc="其它"
	.S:phciloc="" phciloc="0"
	.s pawarddr=""
	.s sub=phciprice_"^"_rp
	.
	.;发药统计-点击总计查看所有药品
	.i $d(^TMP("dhcpha",pid,"locsum",phciinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",4)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",4)+phcibqty
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",5)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",5)+cost
	..s $p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",6)=$p(^TMP("dhcpha",pid,"locsum",phciinci,sub),"&",6)+rpamt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum",phciinci,sub)=0_"&"_0_"&"_0_"&"_phcibqty_"&"_cost_"&"_rpamt_"&"_phciprice_"&"_rp
	.
	.;发药统计-选择若干科室（病区）查看药品
	.i $d(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub))  d             
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",4)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",4)+phcibqty
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",5)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",5)+cost
	..s $p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",6)=$p(^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub),"&",6)+rpamt
	.e  d
	..s ^TMP("dhcpha",pid,"locsum1",phciloc,phciinci,sub)=0_"&"_0_"&"_0_"&"_phcibqty_"&"_cost_"&"_rpamt_"&"_phciprice_"&"_rp
	.
	.;发药统计-双击药品查看明细	
	.s i=$o(^TMP("dhcpha",pid,"locsumitm",phciinci,phciloc,""),-1)
	.q:i=""
	.s ^TMP("dhcpha",pid,"locsumitm",phciinci,phciloc,i)=oeori_"^"_paadmdr_"^"_phcibqty_"^"_phciprice_"^"_cost_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"IP")_"^"_pawarddr_"^"_rpamt_"^"_rp
	.
	q i
}

ClassMethod DispStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query DispStat(StartDate As %String, EndDate As %String, displocrowid As %String, dispcatval As %String, StartTime As %String, EndTime As %String, incirowid As %String, statflag As %String, tPhcCatRowid As %String, IncludeDispF As %String, tRegNo As %String, stkgrp As %String) As %Query(ROWSPEC = "ProcessID:%String,AdmLocRowid:%String,AdmLocDesc:%String")
{
}

ClassMethod DispOperUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispOperUserExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DispOperUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispOperUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DispOperUserExecute(ByRef qHandle As %Binary, Grpid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	d ResetVariables3
	s result=..GrpUser(Grpid)
	s i=1
	f  s userid=$p(result,"^",i) q:userid=""  d
	. s i=i+1
	. q:'$d(^SSU("SSUSR",userid))
	. s username=$p(^SSU("SSUSR",userid),"^",2)
	. d OutputRow3
	. 
	. 
	Quit $$$OK
OutputRow3
	s Data=$lb(username,userid )
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
ResetVariables3
	s (userid,username)=""
	q
}

Query DispOperUser(Grpid As %String) As %Query(ROWSPEC = "username:%String,userid:%String")
{
}

ClassMethod DispDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLS","DispDetail","87^A88^A89^")

ClassMethod DispDetailExecute(ByRef qHandle As %Binary, phacrowidStr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:phacrowidStr="" $$$OK
	q:phacrowidStr=0 $$$OK
	d ResetVariables4
	s amttotal=0
    s DetailLen=$length(phacrowidStr,"A")
	f l=1:1:DetailLen  d  
	.s pid=..NewPid()
	.s Detail=$p(phacrowidStr,"A",l)
	.s coll=$p(Detail,"^",1)
	.s PamStr=$p(Detail,"^",2)_"^"_$p(Detail,"^",3)_"^"_$p(Detail,"^",4)
	.q:coll=""
 	.s cnt=$$GETDATA(coll,PamStr)
	.f i=1:1:cnt d
	..s detail=^TMP("dhcpha",pid,"DISPDQ",i)
	..d OutputRow4
	. 
	d outputtotal
	
	k ^TMP("dhcpha",pid,"DISPDQ")
	Quit $$$OK
OutputRow4
	s TInsuType=$p(detail,"&",1)
	s TAdmLoc=$p(detail,"&",2)
	s TBedNo=$p(detail,"&",3)
	s TPaName=$p(detail,"&",4)
	s TRegNo=$p(detail,"&",5)
	
	s TOrdItemDesc=$p(detail,"&",6)
	s TQty=$p(detail,"&",7)
	s TSalePrice=$p(detail,"&",8)
	s TStatus=$p(detail,"&",9)
	s TDispCat=$p(detail,"&",10)
	s TDoseQty=$p(detail,"&",11)
	s TFreq=$p(detail,"&",12)
	s TInstruction=$p(detail,"&",13)
	s TDuration=$p(detail,"&",14)
	s TPrescno=$p(detail,"&",15)
	s TBatchNo=$p(detail,"&",16)
	;--------add by lq------------
	
	s Tsex=$p(detail,"&",21)
	s Tdoctor=$p(detail,"&",22)
	s Tgenedesc=$p(detail,"&",23)
	s Tphcform=$p(detail,"&",24)
	s Tbarcode=$p(detail,"&",25)
	s Tmanf=$p(detail,"&",26)
	s Tuomdesc=$p(detail,"&",27)
	s Tstotal=$p(detail,"&",28)
	s Tdiag=$p(detail,"&",29)
	s Told=$p(detail,"&",30)
	s Taction=$p(detail,"&",31)
	s Tquesdate=$p(detail,"&",33)
	s TEncryptLevel=$p(detail,"&",34)
	s TPatLevel=$p(detail,"&",35)
	;-----------------------------
	s amttotal=amttotal+Tstotal
 	s amttotal=$fn(amttotal,"",2)
 	s jytype=..GetCookType(TPrescno)
	s Data=$lb(TInsuType,TAdmLoc,TBedNo,TPaName,TRegNo,TOrdItemDesc,TQty,TSalePrice,TStatus,TDispCat,TDoseQty,TFreq,TInstruction,TDuration,TPrescno,TBatchNo,Tsex,Tdoctor,Tgenedesc,Tphcform,Tbarcode,Tmanf,Tstotal,Tdiag,Told,Taction,Tquesdate,TEncryptLevel,TPatLevel,jytype)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q

outputtotal
	;2007-8-7,zdm
	s Data=$lb("","总计","","","","","","","","","","","","","","","","","","","","",amttotal,"","","")
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
	
ResetVariables4
	s (TInsuType,TAdmLoc,TBedNo,TPaName,TRegNo,TOrdItemDesc,TQty,TSalePrice,TStatus,TDispCat,TDoseQty,TFreq,TInstruction,TDuration,TPrescno,TBatchNo,Tsex,Tdoctor,Tgenedesc,Tphcform,Tbarcode,Tmanf,Tuomdesc,Tstotal,Tdiag,Told,Taction,TEncryptLevel,TPatLevel)=""
	q
	
GETDATA(phacdr,pamstr) 
 q:phacdr=""
 s pid=..NewPid()
 s regno="",longord="",shortord=""
 s regno=$p(pamstr,"^",1)
 s longord=$p(pamstr,"^",2)
 s shortord=$p(pamstr,"^",3)
 k ^TMP("dhcpha",pid,"D2")
 i '$d(^DHCPHAC(phacdr)) q -1
 s phactype=$p(^DHCPHAC(phacdr),"^",12)
 s phacdatefrom=$p(^DHCPHAC(phacdr),"^",10)
 s phacdateto=$p(^DHCPHAC(phacdr),"^",11)
 s phacward=$p(^DHCPHAC(phacdr),"^",4)
 s phacloc=$p(^DHCPHAC(phacdr),"^",1)
 s phacuser=$p(^DHCPHAC(phacdr),"^",5)
 s phacstat=$p(^DHCPHAC(phacdr),"^",6)
 s phacusername=$g(phacusername)
 i phacuser'="" s phacusername=$p($g(^SSU("SSUSR",+phacuser)),"^",2)
 ;
 s i=0 
 s Stotal1=0  
 s phaci="" f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
 .s i=i+1
 .s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
 .s inci=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
 .s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)   
 .;s inci=$p(inclbdr,"||",1)                                                    ;INCI_RowId
 .;s incil=$p(inclbdr,"||",2)                                                   ;INCIL_ChildSub
 .;s inclb=$p(inclbdr,"||",3)                                                   ;INCLB_ChildSub
 .;-------------add by lq ---------------------
 .s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
 .s phcform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
 .s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) 	        //规格
 .s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3) 		//厂家
 .s CTUOMDR=$p(^INCI(inci,1),"^",10) 							// 指向 CT_UOM 
 .s UOMDesc=$p(^CT("UOM",CTUOMDR),"^",2) 						//单位
 .s diagnose=""
 .i adm'="" s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
 .;-----------------------------------------------
 .;s incibdr=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
 .;s incib=$p(incibdr,"||",2)                                                   ;INCIB_ChildSub   
 .s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
 .s chl=$p(oedis,"||",2) 
 .s doctorlocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
 .s doctorloc=$p(^CTLOC(doctorlocdr),"^",2) 
 .i doctorloc["-" s doctorloc=$p(doctorloc,"-",2,$l(doctorloc,"-"))
 .i '$d(^OEORD(ord,"I",chl)) q 
 .s DocTor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)
 .;s ordmemo=$$GetOrdItmRemark^DHCSTIPOUT(oedis)  
 .s ordmemo=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(oedis)                                 ;oeori_remarks
 .&sql(select oeori_doctor_dr into :doctor from oe_orditem where oeori_oeord_parref=:ord and oeori_childsub=:chl)   ;医师
 .i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)  
 .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;ARCIM_RowId     
 .s patnameid=$p(^PAADM(adm),"^",1)    ;PA_PatMas PAPMI_RowId
 .s patid=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)                 ;病人姓名   
 .s patno=$p(^PAPER(patnameid,"PAT",1),"^",1) 
 .q:(regno'="")&(regno'=patno)                  //过滤登记号条件
 .s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1) 
 .i longord="1" q:priority'="S"              //过滤仅显示长嘱条件
 .i shortord="1" q:(priority="S")!(priority="OUT") //过滤仅显示临嘱条件
 .s sexid =$p( ^PAPER(patnameid,"ALL"),"^",7)   
 .s sex =$p(^CT("SEX",sexid),"^",2 )            //性别
 .s PADob=$p( ^PAPER(patnameid,"ALL"),"^",6)
 .s Paold=##class(PHA.FACE.IN.Com).GetAge(patnameid,adm) //年龄统一调用接口wyx 2015-01-29
 .s getaction=##class(web.DHCSTPCHCOLLS2).SkinTest2(ord_"||"_chl) ;//2007-10-26 皮试结果
 .s code="In Patient"                                  
 .&sql(select max(paadm_admdate) into :admdate from pa_adm where paadm_papmi_dr=:patnameid and paadm_type=:code)  ;入院日期
 .s admdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate,"IP") 
 .s deploc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)
 .s arcim=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
 .s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
 .s datedosing=$p(^DHCPHAC(phacdr,"I",phaci),"^",16)
 .S EncryptLevelInfo=""
 .s EncryptLevel=""
 .s PatLevel=""
 .s HospID=""
 .s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospID)
 .i EncryptFlag=1 d
 ..s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patnameid,"")
 ..s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 ..s PatLevel=$p(EncryptLevelInfo,"^",2)
 .
 .s j=deploc_"||"_bed_"||"_arcim         ;i phactype="PJ" 
 .i phactype'="PJ" s j=arcim_"||"_deploc_"||"_bed        
 .s ^TMP("dhcpha",pid,"D2","ARCIM",j,i)=arcim                                        ;arcim(j,i)                 ;医嘱名称
 .s ^TMP("dhcpha",pid,"D2","PATNAME",j,i)=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)               ;病人姓名   
 .s ^TMP("dhcpha",pid,"D2","PATMRN",j,i)=$p(^PAPER(patnameid,"PAT",1),"^",1)         ;patmrn(j,i)                ;病人登记号     
 .s ^TMP("dhcpha",pid,"D2","PRESC",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)         ;presc(j,i)                 ;医嘱处方号      
 .s ^TMP("dhcpha",pid,"D2","BED",j,i)=bed                                            ;bed(j,i)                   ;病人床号       
 .;s ^TMP("dhcpha",pid,"D2","PRICE",j,i)=$fn($p(^DHCPHAC(phacdr,"I",phaci),"^",9),"",4)         ;price(j,i)       ;医嘱价格       
 .;s ^TMP("dhcpha",pid,"D2","QTY",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)           ;qty(j,i)                   ;医嘱数量
 .;<---------------add by lq-----------------
 .s phacilStr=$$GetPhacQty(phacdr_"||"_phaci)	//zhouyg 20140402 
 .s ^TMP("dhcpha",pid,"D2","PRICE",j,i)=$p(phacilStr,"^",1)
 .s ^TMP("dhcpha",pid,"D2","QTY",j,i)=$p(phacilStr,"^",2)
 .s Stotal=$p(phacilStr,"^",3)
 .;s Stotal=$fn($fn($p(^DHCPHAC(phacdr,"I",phaci),"^",9),"",4) *$p(^DHCPHAC(phacdr,"I",phaci),"^",6),"",2)
 .s Stotal1=Stotal1+Stotal
 .s ^TMP("dhcpha",pid,"D2","Stotal",j,i)= Stotal //医嘱总价
 .s ^TMP("dhcpha",pid,"D2","Sex",j,i)=sex   //性别
 .s ^TMP("dhcpha",pid,"D2","Doctor",j,i)=DocTor_" "_doctorloc //医师
 .s ^TMP("dhcpha",pid,"D2","Genedesc",j,i)=genedesc //通用名
 .s ^TMP("dhcpha",pid,"D2","PhcForm",j,i)=phcform //剂型
 .s ^TMP("dhcpha",pid,"D2","BarCode",j,i)=Specifaction //规格
 .s ^TMP("dhcpha",pid,"D2","Manf",j,i)=manf //厂家
 .s ^TMP("dhcpha",pid,"D2","UOMDesc",j,i)=UOMDesc //单位
 .s ^TMP("dhcpha",pid,"D2","Diag",j,i)=diagnose //诊断
 .s ^TMP("dhcpha",pid,"D2","Old",j,i)=Paold //年龄
 .s ^TMP("dhcpha",pid,"D2","Getaction",j,i)=getaction //皮试备注
 .;----------------------------------->
 .s ^TMP("dhcpha",pid,"D2","PAKUOM",j,i)=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2) ;pakuom(j,i)              ;药品基本库存单位       
 .s ^TMP("dhcpha",pid,"D2","YBTYPE",j,i)=..GetYBType(+adm)
 .i $p(^OEORD(ord,"I",chl,2),"^",6)="" s ^TMP("dhcpha",pid,"D2","DURA",j,i)="*"
 .e  s ^TMP("dhcpha",pid,"D2","DURA",j,i)=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)   ;dur(j,i)         ;用药疗程
 .i $p(^OEORD(ord,"I",chl,2),"^",7)="" s ^TMP("dhcpha",pid,"D2","INST",j,i)="*"
 .e  s ^TMP("dhcpha",pid,"D2","INST",j,i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)   ;inst(j,i)        ;用法
 .i $f(^TMP("dhcpha",pid,"D2","INST",j,i),"-")  s ^TMP("dhcpha",pid,"D2","INST",j,i)=$p(^TMP("dhcpha",pid,"D2","INST",j,i),"-",2)      
 .i $p(^OEORD(ord,"I",chl,2),"^",4)="" s ^TMP("dhcpha",pid,"D2","FREQ",j,i)="*"           ;freq(j,i)
 .e  s ^TMP("dhcpha",pid,"D2","FREQ",j,i)=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",3)                       ;用药频率 
 .s ^TMP("dhcpha",pid,"D2","DOSAGE",j,i)=$p(^OEORD(ord,"I",chl,2),"^",1)                               ;用药剂量
 .i $p(^OEORD(ord,"I",chl,2),"^",3)="" s ^TMP("dhcpha",pid,"D2","UOM",j,i)="*"
 .e  s ^TMP("dhcpha",pid,"D2","UOM",j,i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)   ;uom(j,i)         ;剂量单位           
 .s ^TMP("dhcpha",pid,"D2","BATNO",j,i)=..GetDspBatno(phacdr_"||"_phaci)                      ;incibno(j,i)      ;药物批号
 .s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)                    ;oeflag(j,i)    ;医嘱核实、未核实、停止状态
 .i $p(^OEORD(ord,"I",chl,1),"^",8)="" s ^TMP("dhcpha",pid,"D2","TYPE",j,i)="*"            ;ordtype(j,i)
 .e  s ^TMP("dhcpha",pid,"D2","TYPE",j,i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)                       ;医嘱优先级
 .s ^TMP("dhcpha",pid,"D2","DEPLOC",j,i)=$p(^CTLOC(deploc),"^",2)                                  ;deploc(j,i)   ;病人所在科室
 .i $f(^TMP("dhcpha",pid,"D2","DEPLOC",j,i),"-")  s ^TMP("dhcpha",pid,"D2","DEPLOC",j,i)=$p(^TMP("dhcpha",pid,"D2","DEPLOC",j,i),"-",2)
 .s ^TMP("dhcpha",pid,"D2","DOTOR",j,i)=doctor        
 .s ^TMP("dhcpha",pid,"D2","ADMDATE",j,i)=admdate
 .s ^TMP("dhcpha",pid,"D2","PHACUSERNAME",j,i)=phacusername
 .s ^TMP("dhcpha",pid,"D2","ORDMEMO",j,i)=ordmemo
 .i (^TMP("dhcpha",pid,"D2","OEFLAG",j,i)'="D")&(^TMP("dhcpha",pid,"D2","TYPE",j,i)'="NORM") d
 ..i $d(HUIZONGPJ(arcimid)) s $p(HUIZONGPJ(arcimid),"&",2)=$p(HUIZONGPJ(arcimid),"&",2)+^TMP("dhcpha",pid,"D2","QTY",j,i) 
 ..i '$d(HUIZONGPJ(arcimid)) d
 ...s $p(HUIZONGPJ(arcimid),"&",1)=arcim 
 ...s $p(HUIZONGPJ(arcimid),"&",2)=^TMP("dhcpha",pid,"D2","QTY",j,i) 
 ...s $p(HUIZONGPJ(arcimid),"&",3)=$p(^INCI(inci,1),"^",10)
 ...s $p(HUIZONGPJ(arcimid),"&",4)=^TMP("dhcpha",pid,"D2","PRICE",j,i)
 .s ^TMP("dhcpha",pid,"D2","EncryptLevel",j,i)=EncryptLevel
 .s ^TMP("dhcpha",pid,"D2","PatLevel",j,i)=PatLevel
 s num=0
 s j="" f  s j=$o(^TMP("dhcpha",pid,"D2","ARCIM",j))  q:j=""  d
 .s i="" f  s i=$o(^TMP("dhcpha",pid,"D2","ARCIM",j,i)) q:i=""  d
 ..i ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="V" s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="核实"
 ..i ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="D" s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="停止"
 ..s info0=^TMP("dhcpha",pid,"D2","DEPLOC",j,i)_"&"_^TMP("dhcpha",pid,"D2","BED",j,i)_"&"_^TMP("dhcpha",pid,"D2","PATNAME",j,i)_"&"_^TMP("dhcpha",pid,"D2","PATMRN",j,i)
 ..s info1=^TMP("dhcpha",pid,"D2","ARCIM",j,i)_"&"_^TMP("dhcpha",pid,"D2","QTY",j,i)_" "_^TMP("dhcpha",pid,"D2","PAKUOM",j,i)_"&"_^TMP("dhcpha",pid,"D2","PRICE",j,i)
 ..s info2=^TMP("dhcpha",pid,"D2","OEFLAG",j,i)_"&"_^TMP("dhcpha",pid,"D2","TYPE",j,i)_"&"_^TMP("dhcpha",pid,"D2","DOSAGE",j,i)_^TMP("dhcpha",pid,"D2","UOM",j,i)
 ..s info3=^TMP("dhcpha",pid,"D2","FREQ",j,i)_"&"_^TMP("dhcpha",pid,"D2","INST",j,i)_"&"_^TMP("dhcpha",pid,"D2","DURA",j,i)_"&"_^TMP("dhcpha",pid,"D2","PRESC",j,i)_"&"_^TMP("dhcpha",pid,"D2","BATNO",j,i)_"&"_^TMP("dhcpha",pid,"D2","DOTOR",j,i)_"&"_^TMP("dhcpha",pid,"D2","ADMDATE",j,i)_"&"_^TMP("dhcpha",pid,"D2","PHACUSERNAME",j,i)_"&"_^TMP("dhcpha",pid,"D2","ORDMEMO",j,i)
 ..;<-----------------add by lq ------------------------
 ..s info4=^TMP("dhcpha",pid,"D2","Sex",j,i)_"&"_^TMP("dhcpha",pid,"D2","Doctor",j,i)_"&"_^TMP("dhcpha",pid,"D2","Genedesc",j,i)_"&"_^TMP("dhcpha",pid,"D2","PhcForm",j,i)_"&"_^TMP("dhcpha",pid,"D2","BarCode",j,i)_"&"_^TMP("dhcpha",pid,"D2","Manf",j,i)_"&"_^TMP("dhcpha",pid,"D2","UOMDesc",j,i)_"&"_^TMP("dhcpha",pid,"D2","Stotal",j,i)_"&"_^TMP("dhcpha",pid,"D2","Diag",j,i)_"&"_^TMP("dhcpha",pid,"D2","Old",j,i)_"&"_^TMP("dhcpha",pid,"D2","Getaction",j,i) //2007-10-26
 ..;---------------------------------->
 ..s memo=""
 ..s memonum=^OEORD(ord,"I",chl,"DEP",0)               ;get memo
 ..f k=2:1:memonum  d
 ...s memo=memo_^OEORD(ord,"I",chl,"DEP",k)
 ..s num=num+1
 ..;s mPLIST(num)=Med_"&"_memo_"&"_^TMP("dhcpha",pid,"D2","YBTYPE",j,i)
 ..s info5=memo_"&"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(datedosing)
 ..s info6=^TMP("dhcpha",pid,"D2","EncryptLevel",j,i)_"&"_^TMP("dhcpha",pid,"D2","PatLevel",j,i)
 ..s Med=info0_"&"_info1_"&"_info2_"&"_info3_"&"_info4_"&"_info5_"&"_info6
 ..s ^TMP("dhcpha",pid,"DISPDQ",num)=^TMP("dhcpha",pid,"D2","YBTYPE",j,i)_"&"_Med
 ..;
 .;
 k ^TMP("dhcpha",pid,"D2")
 q num
 ///Creater:	zhouyg
 ///CreateDate:	2014-04-02
 ///Descript:	取发药子记录的数量和金额
 ///Input:		住院发药字表ID
 ///Return:		售价^数量^金额
GetPhacQty(phaciID)
 n (phaciID)
 s phaci=$p(phaciID,"||",1)
 s phaciSub=$p(phaciID,"||",2)
 q:(phaci="")!(phaciSub="") ""
 s PhcLocID=$p($g(^DHCPHAC(phaci)),"^",1)
 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(PhcLocID)
 s CustID=$p(CustStr,"^",1)
 s inciID=$p(^DHCPHAC(phaci,"I",phaciSub),"^",4)
 s phacib=0,qty=0,spamt=0,sp=""
 f  s phacib=$o(^DHCPHAC(phaci,"I",phaciSub,"B",phacib)) q:phacib=""  d
 .s strPhacil=^DHCPHAC(phaci,"I",phaciSub,"B",phacib)
 .s qty=qty+$p(strPhacil,"^",2)
 .s spamt=spamt+$p(strPhacil,"^",6)
 .i sp="" s sp=$p(strPhacil,"^",5) //yunhaibao20170110,单价显示第一个
 i qty'=0 d
 .//s sp=spamt/qty
 .S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inciID)
 .S StkTypeDesc=$P(CatGrpStr,"^",4)
 .S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 .s sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(sp,Perv,"FmtSP",2)
 s retStr=sp_"^"_qty_"^"_spamt
 q retStr
}

ClassMethod DispDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query DispDetail(phacrowidStr As %String) As %Query(ROWSPEC = "TInsuType:%String,TAdmLoc:%String,TBedNo:%String,TPaName:%String,TRegNo:%String,TOrdItemDesc:%String,TQty:%String,TSalePrice:%String,TStatus:%String,TDispCat:%String,TDoseQty:%String,TFreq:%String,TInstruction:%String,TDuration:%String,TPrescno:%String,TBatchNo:%String ,TSex:%String ,TDoctor:%String,TGenedesc:%String,TPhcForm:%String,TBarcode:%String,TManf:%String,TStotal:%String,TDiag:%String,TOld:%String,Taction:%String,Tquesdate:%String,TEncryptLevel:%String,TPatLevel:%String,TJYType:%String")
{
}

ClassMethod DispStatItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query DispStatItm(ProcessID As %String, AdmLocRowid As %String) As %Query(ROWSPEC = "DispItmDesc:%String,DispQty:%String,RetQty:%String,Total:%String,Uom:%String,Amount:%Float,PID:%String,DispItmCode:%String,AdmLocID:%String,TPhcfDesc:%String,TManf:%String,TBarCode:%String,TPhciPrice:%String,Tgeneric:%String,TTotalUom:%String,Tward:%String,Tinci:%String")
{
}

ClassMethod DispStatItmExecute(ByRef qHandle As %Binary, ProcessID As %String, AdmLocRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	i ProcessID=""  Set qHandle=$lb(0,repid,0) q $$$OK
	i AdmLocRowid=""  Set qHandle=$lb(0,repid,0) q $$$OK
	s cnt=0
	i $f(AdmLocRowid,"^") d
	.s cnt=..SelAdmLocDisp(ProcessID,AdmLocRowid)
	e  d
	.s cnt=..AdmLocDisp(ProcessID,AdmLocRowid) 
	q:cnt<1 $$$OK
	f i=1:1:cnt d
	. s dispitm=..ListAdmLocDisp(ProcessID,i)
	. d OutputDispStatItm
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDispStatItm
	s DispItmDesc=$p(dispitm,"&",1)	
	s DispQty=$p(dispitm,"&",2)	
	s RetQty=$p(dispitm,"&",3)	
	s Total=$p(dispitm,"&",4)
	i $l($p(DispQty,".",2))>6 s DispQty=##class(web.DHCST.Common.AppCommon).FormatSq(DispQty,"",2)
	i $l($p(RetQty,".",2))>6 s RetQty=##class(web.DHCST.Common.AppCommon).FormatSq(RetQty,"",2)
	i $l($p(Total,".",2))>6 s Total=##class(web.DHCST.Common.AppCommon).FormatSq(Total,"",2)
	s Uom=$p(dispitm,"&",5)	
	s Amount=$p(dispitm,"&",6)	
	s DispItmCode=$p(dispitm,"&",7) 
	;---------------add by lq----- 
	s rPhcfDesc=$p(dispitm,"&",8)
	s rmanf=$p(dispitm,"&",9)
	s Specifaction=$p(dispitm,"&",10)
	s phciprice=$p(dispitm,"&",11)
	i phciprice'="" s phciprice=$fn(phciprice,"N")
	s generic=$p(dispitm,"&",12) //2007-10-13
	i $f(generic,"-") s generic=$p(generic,"-",2)
	S TotalUom=$P(dispitm,"&",13) //X盒X片 090402 zyg
	s ward=$p(dispitm,"&",14)
	i $f(ward,"-") s ward=$p(ward,"-",2)
	s Inci=$p(dispitm,"&",17)
	s PID=ProcessID
	s Data=$lb(DispItmDesc,DispQty,-RetQty,Total,Uom,Amount,PID,DispItmCode,AdmLocRowid,rPhcfDesc,rmanf,Specifaction,phciprice,generic,TotalUom,ward,Inci) //lq add
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod DispStatItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DocLocRowid(user As %String) As %String
{
	n (user)
	q:user="" ""
	s defaultloc=$p(^SSU("SSUSR",+user),"^",4)
	q defaultloc
}

Query DispStatItmDet(PID As %String, INCI As %String, AdmLocId As %String, Price As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TAdmLoc:%String,TDoctor:%String,TPrescNo:%String,TCode:%String,TDesc:%String,TUom:%String,TQty:%String,TSp:%String,TAmt:%String,TDispDate:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLS","DispStatItmDet","162536","Z01N120","1","2.0392")

ClassMethod DispStatItmDetExecute(ByRef qHandle As %Binary, PID As %String, INCI As %String, AdmLocId As %String, Price As %String) As %Status
{
	//w PID_"^"_INCI_"^"_AdmLocId_"^"_Price
	;w !,+Price
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	q:PID="" $$$OK
	q:INCI="" $$$OK
    s LocStr=AdmLocId
    s num=$l(LocStr,"^")
    f i=1:1:num d
    .s AdmLocId=$p(LocStr,"^",i)
	.i AdmLocId>0 d
	..s n=""
	..//w "B^"_PID_"^"_INCI_"^"_AdmLocId,!
	..f  s n=$o(^TMP("dhcpha",PID,"locsumitm",INCI,AdmLocId,n)) q:n=""  d
	... s phciprice=$p(^TMP("dhcpha",PID,"locsumitm",INCI,AdmLocId,n),"^",10)  //价格不同分开显示 add by caoting
	...s phciprice=$fn(phciprice,"",4)
	... s sdata=^(n)
	... d OutputDispStatItmDet
	... 
	.e  d
	..s AdmLocId=""
	..//w "A^"_PID_"^"_INCI_"^"_AdmLocId,!
	..f  s AdmLocId=$o(^TMP("dhcpha",PID,"locsumitm",INCI,AdmLocId))  q:AdmLocId=""  d
	...s n=""
	...f  s n=$o(^TMP("dhcpha",PID,"locsumitm",INCI,AdmLocId,n)) q:n=""  d
	.... s phciprice=$p(^TMP("dhcpha",PID,"locsumitm",INCI,AdmLocId,n),"^",10)
	.... s phciprice=$fn(phciprice,"",4)
	.... q:+phciprice'=+Price
	....s sdata=^(n)
	....d OutputDispStatItmDet
	.... 
	.
	Quit $$$OK

OutputDispStatItmDet
	s TRegNo=$p(sdata,"^",1)
	s TName=$p(sdata,"^",2)
	s TAdmLoc=$p(sdata,"^",3)
	s TDoctor=$p(sdata,"^",4)
	s TPrescNo=$p(sdata,"^",5)
	s TCode=$p(sdata,"^",6)
	s TDesc=$p(sdata,"^",7)
	s TUom=$p(sdata,"^",8)
	s TQty=$p(sdata,"^",9)
	s TSp=$p(sdata,"^",10)
	s TAmt=$p(sdata,"^",11)
	s TDispDate=$p(sdata,"^",12)
	s Data=$lb(TRegNo,TName,TAdmLoc,TDoctor,TPrescNo,TCode,TDesc,TUom,TQty,TSp,TAmt,TDispDate)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod DispStatItmDetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatItmDetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DispStatItmDetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatItmDetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCSTPCHCOLLS).GetDispNo(98)
ClassMethod GetDispNo(phaloc As %String) As %String
{
	n (phaloc)
	s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(phaloc)
	s LocCode=$p(^CTLOC(phaloc),"^",1)
	i HospString'="" d
	.s prepara=$p(HospString,"^",2)_"^"_LocCode
	.q:prepara=""
	.s dispno=##class(web.DHCSTPHACREATENO).GetAppNoM("DHC_STOrdDisp",prepara)
    q:HospString'="" dispno
	;
	//get prefix
	s phalocset=$o(^DHCPL(0,"Loc",phaloc,""))
	q:phalocset="" ""
	l +^DHCPL(phalocset):3
	s prefix=$P(^DHCPL(phalocset),"^",13)   
	s finaldate=$P(^DHCPL(phalocset),"^",15)   
	s countnum=$P(^DHCPL(phalocset),"^",12) 	
	i finaldate'=+$h d
	.s $P(^DHCPL(phalocset),"^",15)=+$h
	.s countnum=0
	s finaldate=$P(^DHCPL(phalocset),"^",15)   
	; s countnum=$P(^DHCPL(phalocset),"^",12) 	
	s countnum=countnum+1
	s $P(^DHCPL(phalocset),"^",12)=+countnum
	s dispno=prefix_$e($zd(finaldate,8),3,8)_$tr($j(countnum,4)," ","0")
	l -^DHCPL(phalocset)
	q dispno
}

ClassMethod DispCatDesc(catcode As %String) As %String
{
 n (catcode)
 &sql( select sdg_desc into :catdesc from DHCStkDrugGroup where sdg_code=:catcode)
 q:SQLCODE ""
 q $g(catdesc)
}

ClassMethod NewPid() As %String
{
 q $I(^DHCSTPHARMACY("COLL"))
}

/// w ##Class(web.DHCSTPCHCOLLS).HandlePhaResQty("2||3")
ClassMethod HandlePhaResQty(phaci As %String) As %String
{
 //处理发药扣除数据...
 n (phaci)
 s phac=$P(phaci,"||",1)
 s ch=$p(phaci,"||",2)
 s ward=$p(^DHCPHAC(phac),"^",4)
 q:ward="" ""  ;特殊科室不进行发药保留
 i ward'="" d
 .s wardloc=$p(^PAWARD(ward),"^",5 )
 s adm=$p(^DHCPHAC(phac,"I",ch),"^",3)
 i ward="" d
 .s warddesc=##class(web.DHCSTPCHCOLLDSPPRN).getWardDesc(adm)
 .s wardloc=##class(web.DHCSTCOMMONSRV).LocToRowID(warddesc)
 s phaloc=$p(^DHCPHAC(phac),"^",1)
 s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
 s inci=+$p(^DHCPHAC(phac,"I",ch),"^",4)
 s oeori=$p(^DHCPHAC(phac,"I",ch),"^",7)
 s ord=+oeori
 s chl=$p(oeori,"||",2)
 s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
 
 i ##class(web.DHCSTCOMMONSRV).GetWholeDispFlag(oeori)=1 d
 . ///胰岛素特殊处理, 满整支时, 保留整支+当前发药量 , 否保留当前发药量, 胰岛素第一次发默认保留,够整支再发
 .s ret=0
 .i ward'="" s pres=$o(^DHCPRES(0,"LOCINCIWARD",phaloc,inci,ward,"") )
 .i ward="" s pres=$o(^DHCPRES(0,"LOCINCIDEPT",phaloc,inci,wardloc,"") )
 .i pres="" d
 ..s pres=$$InsertRes(phaloc,inci,ward,qty,wardloc)	
 ..
 .q:+pres'>0
 .s eqty=##class(web.DHCSTKUTIL).GetBuomDosage(oeori)
 .s eqty=+eqty
 .i eqty>0 d
 ..s resqty=$p(^DHCPRES(pres),"^",4)
 ..s resqty=resqty+qty
 ..i resqty<1 d
 ...s $p(^DHCPHAC(phac,"I",ch),"^",12)=qty
 ...s newResqty=resqty
 ..e  d
 ...s pharesqty=qty-(resqty\1)
 ...s $p(^DHCPHAC(phac,"I",ch),"^",12)=pharesqty
 ...s newResqty=resqty-(resqty\1)
 ..s $p(^DHCPRES(pres),"^",4)=newResqty
 e  d
 .///普通药品发药保留处理
 .//s pres=$o(^DHCPRES(0,"LOCINCIWARD",phaloc,inci,ward,"") )	
 .i ward'="" s pres=$o(^DHCPRES(0,"LOCINCIWARD",phaloc,inci,ward,"") )
 .i ward="" s pres=$o(^DHCPRES(0,"LOCINCIDEPT",phaloc,inci,wardloc,"") )
 .q:$g(pres)=""
 .s resqty=$p(^DHCPRES(pres),"^",4)
 .i resqty=0 s pres=""
 .q:resqty=0
 .;
 .i resqty>qty d
 ..s $p(^DHCPHAC(phac,"I",ch),"^",12)=qty
 ..s newResqty=resqty-qty
 .e  d
 ..s $p(^DHCPHAC(phac,"I",ch),"^",12)=resqty
 ..s newResqty=0
 .s $p(^DHCPRES(pres),"^",4)=newResqty
 
 q:+pres'>0 ""
 
 
 ;保留数据台帐---Liang Qiang
 s pressub=$o(^DHCPRES(pres,"DET",""),-1)+1
 s avqty=$p(^DHCPRES(pres),"^",4)
 k PLIST
 s PLIST(0)=pres
 s PLIST(2)=pressub
 s PLIST(3)="P"
 s PLIST(4)=qty
 s PLIST(5)=phaci
 s PLIST(6)=avqty
 s PLIST(7)=+$h
 s PLIST(8)=$p(^DHCPHAC(+phaci),"^",5)
 s PLIST(9)=$p($h,",",2)
 &sql(insert into DHC_PhaReserveDetail values PLIST())
 i SQLCODE'=0 s ret=-5 
 q:SQLCODE'=0 ret
 
 s ret=$$HandleResQtyInRet(phaloc,inci,wardloc,qty,pres,pressub)
 q 1
 
 
HandleResQtyInRet(recloc, inci, wardloc, qty,pres,pressub ) 
 ;查找reservedqty
 n (recloc,inci,wardloc,qty,pres,pressub)
 s i=0
 s ret=0
 s phar=""
 f  s phar=$o(^PHARET(0,"LOCDEPT",recloc,wardloc,phar)) q:phar=""  s data=^PHARET(phar) d
 .s pharsub=""
 .f  s pharsub=$o(^PHARET(0,"PHARINCI",phar,inci,pharsub)) q:(pharsub="")||(qty=0)  s data=^PHARET(phar,"I",pharsub) d 
 ..s phari=phar_"||"_pharsub
 ..s resqty=$p(data,"^",3)
 ..q:+resqty=0
 ..//s pressub=$o(^DHCPRES(pres,"DET",""),-1) //wyx modify 防止并发改为传入
 ..s i=i+1
 ..i resqty'<qty d
 ... //s ^DHCPRES(pres,"DET",pressub,"SUB",i)=phari_"^"_qty //wyx 改为退药明细id
 ... //wyx add 2015-02-07 改为存入表
 ... s parref=pres_"||"_pressub
 ...&sql(insert into DHC_PhaReserveDetailSub(PRDETS_PRDET_Parref,PRDETS_ChildSub,PRDETS_PHARET_Dr,PRDETS_Qty) VALUES (:parref,:i,:phari,:qty))
 ...i SQLCODE'=0 s ret=-6 
 ... s newresqty=resqty-qty
 ... s $p(^PHARET(phar,"I",pharsub),"^",3)=newresqty
 ... s qty=0
 ... 
 ..e  d
 ... //s ^DHCPRES(pres,"DET",pressub,"SUB",i)=phari_"^"_resqty //wyx 改为退药明细id
 ... s parref=pres_"||"_pressub
 ...&sql(insert into DHC_PhaReserveDetailSub(PRDETS_PRDET_Parref,PRDETS_ChildSub,PRDETS_PHARET_Dr,PRDETS_Qty) VALUES (:parref,:i,:phari,:resqty))
 ...i SQLCODE'=0 s ret=-6  
 ... s qty=qty-resqty
 ... s $p(^PHARET(phar,"I",pharsub),"^",3)=0
 ... 
 ..
 q ret
 
InsertRes(phaloc,inci,ward,qty,wardloc)
  k PLIST
  s PLIST(2)=phaloc
  s PLIST(3)=inci
  s PLIST(4)=0
  s PLIST(5)=ward
  s PLIST(6)=wardloc
  &sql(insert into DHC_PhaReserve values PLIST())   ;总表插入
  i SQLCODE'=0 s ret=-5 
  q +$g(%ROWID)
}

ClassMethod xx(recloc, inci, wardloc, qty)
{
 //试验用的方法 = $$HandleResQtyInRet
 ;查找reservedqty
 ;n (recloc,inci,wardloc,qty)
 s phar=""
 f  s phar=$o(^PHARET(0,"LOCINCIDEPT",recloc,inci,wardloc,phar)) q:(phar="")!(qty=0)  s data=^PHARET(phar) d
 .s resqty=$p(data,"^",21)
 .w resqty,!
 .q:+resqty=0
 .
 .i resqty'<qty d
 .. s newresqty=resqty-qty
 .. s $p(^PHARET(phar),"^",21)=newresqty
 .. s qty=0
 .e  d
 .. s qty=qty-resqty
 .. s $p(^PHARET(phar),"^",21)=0
 q 0
}

ClassMethod OrdCatType(oedis As %String) As %String
{
 n (oedis)
 q:oedis="" ""
 s ord=$p(oedis,"||",1) q:ord="" ""
 s itm=$p(oedis,"||",2) q:itm="" ""
 q:'$d(^OEORD(ord,"I",itm)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 q:'$d(^ARCIM(sub,ver,1)) ""
 s ordcat=$p(^ARCIM(sub,ver,1),"^",10)
 q:ordcat="" ""
 s catcode=$p(^ARC("IC",ordcat),"^",1)
 q ..GetCat(catcode)
}

ClassMethod ExcludeLoc(oedis, phaloc)
{
	; 根据oedis确定是否排除该行,1 -　排除 0 - 不排除 
	q:oedis="" 0
	s ord=$p(oedis,"||",1) q:ord="" 0
	s itm=$p(oedis,"||",2) q:itm="" 0
	s doctorloc=$p(^OEORD(ord,"I",itm,7),"^",2)
	q:..DoctorLocRefuse(phaloc,doctorloc)>0 1
	q 0
}

ClassMethod MakeBill(phac) As %String
{
 //2007-01-08
 //此段用来处理发药后即刻作帐单
 s pid=$i(^TMP("MAKEBILLPID"))
 s ch=0
 s userid=$p(^DHCPHAC(phac),"^",5)
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  s data=^(ch) d
 .s adm=$p(data,"^",3)
 .s oedis=$p(data,"^",7)
 .s orditm=$P(oedis,"||",1,2)
 .s ord=+orditm
 .s itm=$p(orditm,"||",2)
 .q:+itm=0
 .s arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2) 
 .q:arcim="" 
 .s arccat=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",10) //子类
 .s priordr=$p(^OEORD(ord,"I",itm,1),"^",8) 
 .q:priordr="" 							;优先级不存在的不予发放
 .s priority=$p($g(^OECPR(priordr)),"^",1) 					;医嘱优先级
 .s feepoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(arccat_"^"_priority_"^"_orditm)
 .q:feepoint'=1 //发药计费才调用账单,yunhaibao20160713
 .s dodisstr=$p(data,"^",13)
 .s dodisi=0
 .f dodisi=1:1:$l(dodisstr,",") d
 ..s dodis=$p(dodisstr,",",dodisi)
 ..q:dodis=""
 ..s ordexeid=$p($g(^DHCOEDISQTY(dodis)),"^",3)
 ..i '$d(^TMP("MAKEBILL",pid,adm)) d
 ... s ^TMP("MAKEBILL",pid,adm)=ordexeid
 ..e  d
 ... s ^TMP("MAKEBILL",pid,adm)=^TMP("MAKEBILL",pid,adm)_"^"_ordexeid	
 q:'$d(^TMP("MAKEBILL",pid)) ""
 s ret=""
 s adm=""
 f  s adm=$o(^TMP("MAKEBILL",pid,adm)) q:adm=""  d
 .s str=^TMP("MAKEBILL",pid,adm)
 .q:adm=""
 .q:str=""
 .s ret=##Class(web.UDHCJFBILL).BILLN(adm,userid,str,1)
 k ^TMP("MAKEBILL",pid)
 q $g(ret)
}

ClassMethod AddAdmOrdItm(pid As %String, cat As %String, adm As %String, orditm As %String, qty As %String) As %String
{

 //2007-01-08
 //用来暂时存储"费用检查"使用的数据
 /*
 s orditemqty=orditm_$c(2)_qty
 i '$d(^TMP(pid,"ADMBILL",cat,adm)) d
 . s ^TMP(pid,"ADMBILL",cat,adm)=orditemqty
 e   d
 . s ^TMP(pid,"ADMBILL",cat,adm)=^TMP(pid,"ADMBILL",cat,adm)_"^"_orditemqty	
 
 s ^TMP(pid,"ORDITEMS",cat,orditm)=""   ;记录医嘱
 */
 //
 s orditemqty=orditm_$c(2)_qty
 i '$d(^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid,adm)) d
 . s ^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid,adm)=orditemqty
 e   d
 . s ^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid,adm)=^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid,adm)_"^"_orditemqty	
 //
 q ""
}

ClassMethod CheckIfDispAllowed(pid As %String, cat As %String) As %String
{
 //2007-01-11
 //检查本次发药前病人的费用情况,若被控制,则不发药
 //
 s adm=""
 s code="C" , code1="N"
 f  s adm=$o(^TMP(pid,"ADMBILL",cat,adm)) q:adm=""  d
 .s str=^TMP(pid,"ADMBILL",cat,adm)
 .q:str="" 
 .s P5="",P9=""
 .s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm,"")   //lrl
 .q:rtn=0  ; ok
 .s P5=$p(rtn,"^",5),P9=$p(rtn,"^",9)          //lrl
 .i (P5=code)&(P9=code1) d                        //lrl
 .. s cnt=$l(str,"^")
 .. f xx=1:1:cnt d
 ... s xdata=$p(^TMP(pid,"ADMBILL",cat,adm),"^",xx)
 ... s xorditm=$p(xdata,$c(2),1)
 ... q:xorditm=""                           //lrl
 ... k ^TMP(pid,"ORDITEMS",cat,xorditm)
 q ""
}

ClassMethod CheckIfDispAllowed1(pid As %String, cat As %String) As %String
{
 //2007-01-08
 //检查本次发药中病人的费用情况,若被控制,则去掉费用超出的部分医嘱的发药
 //
 s adm=""
 s code="C",code1="N"
 f  s adm=$o(^TMP(pid,"ADMBILL",cat,adm)) q:adm=""  d
 .s str=^TMP(pid,"ADMBILL",cat,adm)
 .q:str="" 
 .s P5="",P9=""
 .s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm,str)   //lrl
 .q:rtn=0  ; ok
 .s P5=$p(rtn,"^",5),P9=$p(rtn,"^",9)          //lrl
 .i (P5=code)&(P9=code1) d                        //lrl
 .. ;s ^TMP(pid,"ADMDISPNOTALLOWED",adm)=0
 .. s cnt=$l(str,"^")
 .. s i=0
 .. f  q:(i>cnt)!(rtn'=0)  d
 .. . s i=i+1
 .. . s tmpdata=$p(^TMP(pid,"ADMBILL",cat,adm),"^",1,i)
 .. . s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm,tmpdata)
 .. . q:rtn=0                                  //lrl
 .. . s P5=$p(rtn,"^",5),P9=$p(rtn,"^",9)      //lrl
 .. . q:(P5=code)&(P9=code1)                      //lrl
 .. . s rtn=0                                  //lrl
 .. i (rtn'=0)  d
 .. . ;s ^TMP(pid,"ADMBILL",adm)=$p(str,"^",1,i-1)
 .. . f xx=i:1:cnt d
 .. . . s xdata=$p(^TMP(pid,"ADMBILL",cat,adm),"^",xx)
 .. . . s xorditm=$p(xdata,$c(2),1)
 .. . . q:xorditm=""                           //lrl
 .. . . k ^TMP(pid,"ORDITEMS",cat,xorditm)
 q ""
}

ClassMethod CheckOrditmAllowed(pid As %String, cat As %String, oedis As %String) As %String
{
 //2007-01-08
 //检查医嘱是否允许发，1 - 可发 0 - 不可
 q:oedis="" 0
 q:cat="" 0
 s orditm=$p(oedis,"||",1,2)
 ;
 i $d(^TMP(pid,"ORDITEMS",cat,orditm)) q 1
 q 0
}

ClassMethod CheckOrditmAllowedNew(pid As %String, oeori As %String, loc As %String) As %String
{
 //检查医嘱是否允许发，1 - 可发 0 - 不可
 n (pid,oeori,loc)
 ;zdm,2012-03-07,增加住院药房欠费管理设置判断
 s para=##Class(web.DHCSTPHALOC).GetPhaflag(loc)
 s AduitBill=$p(para,"^",23)
 q:AduitBill'="Y" 1    ;设置如果是不控制，则欠费也允许发药 //wyx 2015-03-05注释，按照新的欠费控制
 ;
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 s adm=$p(^OEORD(ord),"^",1)
 i '$d(^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",pid,adm)) q 1
 q 0
}

ClassMethod killTmpBill(pid As %String, cat As %String)
{
	////2007-01-08
 q:$g(pid)="" 0                 //lrl
 q:$g(cat)="" 0                 //lrl
 k ^TMP(pid,"ORDITEMS",cat)
 k ^TMP(pid,"ADMBILL",cat)
 q 0
}

ClassMethod IfAuditByPriority(ord As %String, itm As %String, priority As %String) As %String
{
  n (ord,itm,priority)
  ;q  1 -- 需审核   0 -- 不需审核
  q:..OrdCatType(ord_"||"_itm)="ZCY" 0   //中草药不需要审核
  s config=0
  s recloc=$P($g(^OEORD(ord,"I",itm,3)),"^",6)
  s plrowid=$o(^DHCPL(0,"Loc",recloc,""))
  q:plrowid="" 0
  s AduitNeed=$p(^DHCPL(plrowid),"^",14)
  i AduitNeed="Y" d
  .s config=1
  s doctorloc=$p(^OEORD(ord,"I",itm,7),"^",2)
  q:..DoctorLocRefuse(recloc,doctorloc)=1 0   //医生科室不需审核
  s priorityCode=$p($g(^OECPR(+priority)),"^",1)
  i priorityCode="OUT" q 0  //出院带药不需审核
  q config
}

// d ##Class(%ResultSet).RunQuery("web.DHCSTPCHCOLLS","DispItmTotal","")

Query DispItmTotal(PID As %String) As %Query(ROWSPEC = "TDesc:%String,TUom:%String,TDrugForm:%String,TQty:%String,TQtyBed:%String,TSp:%String,TBarcode:%String,TManufacture:%String,TIncstk:%String,TAmt:%String,TGeneric:%String")
{
}

ClassMethod DispItmTotalExecute(ByRef qHandle As %Binary, PID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:PID="" $$$OK
	s amtTotal=0
	s num=0
	s TmpCat=""
 	f  s TmpCat=$o(^TMP("dhcpha",PID,"DispCat",TmpCat)) q:TmpCat=""  d
 	.s SubStr=""
 	.f  s SubStr=$o(^TMP("dhcpha",PID,"DispCat",TmpCat,SubStr)) q:SubStr=""  d
 	..s DataStr=^TMP("dhcpha",PID,"DispCat",TmpCat,SubStr)
 	..s OrdItmRowid=$p(SubStr,"^",3)
 	..s Prescno=$p(DataStr,"^",1)
 	..s DspQty=$p(DataStr,"^",2)
 	..s BedNo=$p(DataStr,"^",3)
 	..s Sp=$p(DataStr,"^",4)
 	..s Sp=##class(web.DHCSTKUTIL).Getprice4(Sp)    ;格式化为四位小数
 	..s InciId=$p(DataStr,"^",9)
 	..s DspIdStr=$p(DataStr,"^",10)
	..s tmpdspid="",dspquit="",tmpdspidi=0
 	..f tmpdspidi=1:1:$l(DspIdStr,",") d
 	...s tmpdspid=$p(DspIdStr,",",tmpdspidi)
 	...q:'$d(^TMP("dhcpha",PID,"D","Filter",tmpdspid)) ;过滤没有选择的医嘱
 	...s dspquit=1
 	..q:dspquit'=""
 	..s TimeDosing=$p(DataStr,"^",12)
 	..s RecLocId=$p(DataStr,"^",13)
 	..s Ord=+OrdItmRowid
 	..s Chl=$p(OrdItmRowid,"||",2)
	..s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                 ;ARCIM_RowId 
	..s PhcdfDr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",12)
	..s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2) 
	..s UomId=$p(^INCI(InciId,1),"^",10)
	..s Uom=$p(^CT("UOM",UomId),"^",2) 
	..
	..s Generic=##class(web.DHCSTCOMMONSRV).getGeneric(InciId)
	..i $f(Generic,"-") s Generic=$p(Generic,"-",2)
	..s Form=##class(web.DHCSTCOMMONSRV).GetForm(InciId)
	..s Spec=##class(web.DHCSTCOMMONSRV).getBarcode(InciId)
	..s Manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId),"^",3)
	..s StkBin=##class(web.DHCSTKUTIL).StkBin(OrdItmRowid) 					;货位
	..s SpAmt=$p(DataStr,"^",15) //DspQty*Sp    
    ..s:BedNo="" BedNo="*"
    ..;计算某个床某药品的发药数量
    ..i $d(^TMP("dhcpha",PID,"TOTALQTYBED",ArcimDesc,BedNo)) d
	...s ^TMP("dhcpha",PID,"TOTALQTYBED",ArcimDesc,BedNo)=+^TMP("dhcpha",PID,"TOTALQTYBED",ArcimDesc,BedNo)+DspQty
	..e   d
	...s ^TMP("dhcpha",PID,"TOTALQTYBED",ArcimDesc,BedNo)=DspQty
	..;按药品汇总
	..i $d(^TMP("dhcpha",PID,"TOTAL",ArcimDesc)) d
	...s $p(^TMP("dhcpha",PID,"TOTAL",ArcimDesc),"^",2)=+$p(^TMP("dhcpha",PID,"TOTAL",ArcimDesc),"^",2)+DspQty
	...s $p(^TMP("dhcpha",PID,"TOTAL",ArcimDesc),"^",11)=+$p(^TMP("dhcpha",PID,"TOTAL",ArcimDesc),"^",11)+SpAmt
	..e  d
	...s qtybed=""
	...s ^TMP("dhcpha",PID,"TOTAL",ArcimDesc)=ArcimDesc_"^"_DspQty_"^"_Uom_"^"_Sp_"^"_qtybed_"^"_Form_"^"_Spec_"^"_Manf_"^"_StkBin_"^"_Generic_"^"_SpAmt
	..
	.
	s desc=""
	f  s desc=$o(^TMP("dhcpha",PID,"TOTAL",desc)) q:desc=""  d
	. s bedno="" f  s bedno=$o(^TMP("dhcpha",PID,"TOTALQTYBED",desc,bedno)) q:bedno=""  d
	. . s qty=^TMP("dhcpha",PID,"TOTALQTYBED",desc,bedno)
	. . s qtybedno=qty_"/"_bedno
	. . i $p(^TMP("dhcpha",PID,"TOTAL",desc),"^",5)=""  d
	. . . s $p(^TMP("dhcpha",PID,"TOTAL",desc),"^",5)=qtybedno
	. . e  d
	. . . s $p(^TMP("dhcpha",PID,"TOTAL",desc),"^",5)=$p(^TMP("dhcpha",PID,"TOTAL",desc),"^",5)_" "_qtybedno
    
 	s desc=""
 	f  s desc=$o(^TMP("dhcpha",PID,"TOTAL",desc)) q:desc=""  d
 	.s result=^TMP("dhcpha",PID,"TOTAL",desc)
 	.d outputdispitmtotal
 
 	d outputdispitmtotalall
    
	k ^TMP("dhcpha",PID,"TOTALQTYBED")
	k ^TMP("dhcpha",PID,"TOTAL")	
	q $$$OK
	
outputdispitmtotal
 ;s TCode=$p(result,"^",)
 s TDesc=$p(result,"^",1)
 s TQty=$p(result,"^",2)
 s TUom=$p(result,"^",3)
 S TSp=$p(result,"^",4)
 s TSp=##class(web.DHCSTKUTIL).Getprice4(TSp)
 s TQtyBed=$p(result,"^",5)
 s TDrugForm=$p(result,"^",6)
 s TBarcode=$p(result,"^",7)
 s TManufacture=$p(result,"^",8)
 s TIncstk=$p(result,"^",9)
 s TAmt=$p(result,"^",11) //TQty*TSp //yunhaibao20161011,批次价不能直接计算金额
 s TAmt=##class(web.DHCSTKUTIL).Getprice2(TAmt)
 s amtTotal=amtTotal+TAmt
 s TGeneric=$p(result,"^",10)
 
 s Data=$lb(TDesc,TUom,TDrugForm,TQty,TQtyBed,TSp,TBarcode,TManufacture,TIncstk,TAmt,TGeneric)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
 
outputdispitmtotalall
 ;2007-8-30,zdm
 ;输出总金额
 
 s Data=$lb("总计","","","","","","","","",amtTotal)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DispItmTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispItmTotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DispItmTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispItmTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDrugForm(oedis As %String) As %String
{
 n (oedis)
 s ord=$p(oedis,"||",1) q:ord="" ""
 s itm=$p(oedis,"||",2) q:itm="" ""
 //s exe=$p(oedis,"||",3) q:exe="" ""   ;07-09-30 rem
 //s dsp=$p(oedis,"||",4) q:dsp="" "" ;07-09-30 rem
 //q:'$d(^OEORD(ord,"I",itm,"X",exe,"D",dsp)) "" ;07-09-30 rem
 //s inclb=$p(^OEORD(ord,"I",itm,"X",exe,"D",dsp),"^",2) ;07-09-30 rem
 s inci=##class(web.DHCSTKUTIL).OrdItmInci(ord_"||"_itm)
 q ##class(web.DHCSTCOMMONSRV).GetForm(inci)
}

ClassMethod OrdItmAudited(oedis As %String) As %String
{
	s ord=$p(oedis,"||",1) q:ord="" -1
	s itm=$p(oedis,"||",2) q:itm="" -1
	q:'$d(^OEORD(ord,"I",itm,1)) -2
	s priority=$p(^OEORD(ord,"I",itm,1),"^",8)
	q ..IfAuditByPriority(ord,itm,priority)
}

// 以下为修改....2007-09-27

ClassMethod Dispensing(phac As %String, dhcoedis As %String, oeori As %String) As %String
{
 ;根据dhc_oedispensing记录处理发药
 ;1 找批次
 ;2 生成发药记录
 ;3 处理该发药记录的库存
 ;3.1 处理INC_ItmLcBt和INC_ItmLoc
 ;3.2 处理dhc_locdailytotal,dhc_locbtdailytotal,dhc_intrans
 //s status=$p(^DHCOEDISQTY(dhcoedis),"^",7) q:status'="TC" "" ;并非发药状态时退出
 //s oeori=$p(^DHCOEDISQTY(dhcoedis),"^",1) q:oeori="" ""
 n (phac,dhcoedis,oeori)
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:'$d(^OEORD(ord,"I",itm)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
 q:arcim="" ""
 s fdspID=$p(dhcoedis,",",1)
 q:fdspID="" ""
 s recloc=$p($g(^DHCOEDISQTY(fdspID)),"^",24)
 q:recloc="" ""
 q:dhcoedis="" ""
 s HospID=$p(^CTLOC(recloc),"^",22)
 l +^DHCOEDISPENSING(oeori):5  e  q ""   ;加锁
 s dodiss=..ReGetDodis(dhcoedis,ord,itm)
 i dodiss="" l -^DHCOEDISPENSING(oeori) q ""
 s errCode=0
 tstart
 s $ZT="Error^DHCSTERROR"  
 s dodisLen=$l(dodiss,",")
 s dosisI=""
 f dosisI=1:1:dodisLen d
 .s dspId=$p(dodiss,",",dosisI)
 .q:+dspId=0
 .s listdata=phac_"^"_oeori_"^^^"_dodiss
 .s phaci=..InsPhacItm(listdata) ;生成发药记录
 .i phaci="" trollback  d Unlock s errCode=1
 .q:phaci=""     ;保存发药子表失败
 .s dspSubId=""
 .s err=0
 .f  s dspSubId=$o(^DHCOEDISQTY(dspId,"I",dspSubId)) q:(dspSubId="")||(errCode'=0)||(err'=0)  d
 ..q:+dspSubId=0
 ..s inci=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",5)
 ..s confqty=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",2) //..CalDspQty(dodiss,inci)  //yunhaibao,医嘱改造后一个dspId+inci插入一个自己录
 ..i confqty=0 l -^DHCOEDISPENSING(oeori) s errCode=1
 ..q:confqty=0 
 ..s pid=..GetInclbCounter(recloc,inci)
 ..i pid<0 d Unlock s errCode=2
 ..q:pid<0 
 ..s cnt=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,confqty,recloc,pid)
 ..s code="C"
 ..i cnt<=0 d Unlock s errCode=7
 ..q:cnt<=0 ;即库存不够的情况
 ..																;保存发药批次表
 ..s sp=##class(web.DHCSTPRICE).GetCurSp(inci,"",HospID) 
 ..s err=0
 ..s newclb=""
 ..f  s newclb=$o(^TMPGETINCLB(pid,newclb)) q:(newclb="")!(err'=0)  d
 ...s inclb=$p(^TMPGETINCLB(pid,newclb),"^",2)
 ...s qty=$p(^TMPGETINCLB(pid,newclb),"^",1)
 ...s rp=##class(web.DHCSTPRICE).GetCurRp(inclb,"",HospID)
 ...s listdata=phaci_"^"_inclb_"^"_qty_"^"_sp_"^"_rp_"^"_dspId_"||"_dspSubId
 ...s phacil=..InsPhacItmLB(listdata) 							;生成发药批次记录
 ...i phacil="" s err=9 
 ...q:phacil=""
 ...
 ...s resultstk=##class(web.DHCSTPCHCOLLS2).DhcStkTab(phacil)  	;处理该笔发药记录的台帐库存
 ...i resultstk<0 s err=3 
 ...q:resultstk<0
 ..k ^TMPGETINCLB(pid)
 i errCode'=0 tro  d Unlock
 q:errCode'=0 errCode
 i err'=0 trollback  d Unlock
 q:err'=0 err
 s ret=..UpdStatusForDODISS(phaci,dodiss)
 i ret<0 trollback  d Unlock
 q:ret<0 8
 tcommit
 d Unlock
 q 0

Unlock
	l -^DHCINCIL(recloc,inci)
	l -^DHCOEDISPENSING(oeori)  ;去锁
	k ^TMPGETINCLB(pid)
	q
}

/// 按批次执行发药
/// 根据dhc_oedispensing记录处理发药
/// 1 找批次
/// 2 生成发药记录
/// 3 处理该发药记录的库存
/// 	3.1 处理INC_ItmLcBt和INC_ItmLoc
/// 	3.2 处理dhc_locdailytotal,dhc_locbtdailytotal,dhc_intrans
ClassMethod DispensingByBatch(phac As %String, dhcoedis As %String, oeori As %String) As %String
{
 n (phac,dhcoedis,oeori)
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:'$d(^OEORD(ord,"I",itm)) -1
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
 q:arcim="" -2
 s fdspID=$p(dhcoedis,",",1)
 q:fdspID="" ""
 s recloc=$p($g(^DHCOEDISQTY(fdspID)),"^",24)
 q:recloc="" ""
 q:dhcoedis="" -3
 s ArcCatId=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",10)
 s PriorDr=$p(^OEORD(ord,"I",itm,1),"^",8) 
 q:PriorDr="" -4							;优先级不存在的不予发放
 s Priority=$p($g(^OECPR(PriorDr)),"^",1) 					;医嘱优先级
 s feePoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(ArcCatId_"^"_Priority_"^"_oeori)
 s HospID=$p(^CTLOC(recloc),"^",22)
 i $$LK()<0 q -1000   ;加锁
 s dodiss=..ReGetDodis(dhcoedis,ord,itm)
 i dodiss="" d UK
 q:dodiss="" q -5
 s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
 i pid<0 d UK
 q:pid<0 -6 
 tstart
 s $ZT="Error^DHCSTERROR"
 s code="C",ErrCode=0
 k ^TMP("DHCINPHA",$this,"DispensingByBatch")
 s lendodis=$l(dodiss,",")
 f ddd=1:1:lendodis  q:(ErrCode'=0)  d
 .s dspID=$p(dodiss,",",ddd)
 .q:+dspID=0
 .s dapIDBat=$o(^DHCOEDISQTY(dspID,"I","0"))
 .i dapIDBat=""  d
 ..s retvaltmp=##class(web.DHCST01).InsDspBatch(dspID,1)					//如果打包子表无记录，则发药的时候补插！
 .s listdata=phac_"^"_oeori_"^^^"_dspID
 .s phaci=..InsPhacItm(listdata) 											//生成发药记录,医嘱改造子表只存dspId
 .s:phaci="" ErrCode=-101
 .q:ErrCode'=0
 .;
 .s minusret=##class(web.DHCST01).MinusResQtyByDspBatch(dspID) 				//处理批次在途,yunhaibao20160307
 .s:minusret'=0 ErrCode=-102
 .q:ErrCode'=0
 .;
 .k ReCollectInc
 .s dspSubId=0,lastInci="" ,dspFlag=0
 .f  s dspSubId=$o(^DHCOEDISQTY(dspID,"I",dspSubId)) q:(dspSubId="")||(ErrCode'=0)  d
 ..s dspInclb=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",1)
 ..s dspInci=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",5)
 ..s inci=$s(dspInclb'="":+dspInclb,1:dspInci)
 ..q:$d(ReCollectInc(inci)) 												// 重新分配库存只处理对应首条库存项记录
 ..s UserId=$p($g(^DHCPHAC(phac)),"^",13)
 ..s incil=$p(dspInclb,"||",1,2)
 ..s dspQty=##class(web.DHCSTCOMMONSRV).GetDspInciQtyByDsp(dspID,+inci,3)
 ..i lastInci="" s dspFlag=##Class(web.DHCST01).GetDspClb(dspID,pid,inci) 	// 1-够用,一库存项只判断一次
 ..e  i lastInci'=inci s dspFlag=##Class(web.DHCST01).GetDspClb(dspID,pid,inci)
 ..i dspFlag'=1 d
 ...s RetCode=##CLASS(web.DHCST01).GetInclbQty(incil,dspQty,pid,1)  		//分配库存
 ...s ReCollectInc(inci)=""
 ...s:RetCode'=1 ErrCode=-103
 ..s:ErrCode'=0 ^TMP("DHCINPHA",$this,"DispensingByBatch")=$p(^INCI(inci,1),"^",2)
 ..q:ErrCode'=0
 ..;
 ..s lastInci=inci
 ..s oldRp=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",3) 
 ..s oldSp=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",4) 						//再分配批次前记录下老的价格只记录第一条的因为计费时是按照第一条来收费的
 ..s InsDspbFlag=0	   														//计费点是发药计费并且配药批次表保存的批次当前库存不足需要重新选择批次发药时需更新配药批次表
 ..i (dspFlag'=1)&&(feePoint=1) d
 ...s InsDspbFlag=1
 ...d DelDspBatch(dspID,inci)
 ...s firstbatsp=+##class(web.DHCSTPRICE).GetSp(dspInclb,+$h,"",HospID,$p($h,",",2))
 ..i (dspFlag=1)&&(feePoint=1) d 											//yunhaibao20170111发药计费,库存足够时需重新获取价格,按第一条收费,更新第一条即可
 ...s firstbatsp=+##class(web.DHCSTPRICE).GetSp(dspInclb,+$h,"",HospID,$p($h,",",2))
 ...i firstbatsp'=oldSp d
 ....s $p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",4)=firstbatsp 				//回写打包批次表售价
 ...s firstbatsp=$p(^DHCOEDISQTY(dspID,"I",dspSubId),"^",4)
 ..i feePoint=0 s firstbatsp=oldSp
 ..s lbNum=""
 ..f  s lbNum=$o(^TMP("DHCST","web.DHCST01","Inclb",pid,lbNum)) q:(lbNum="")!(ErrCode'=0)  d
 ...s inclbStr=^(lbNum)
 ...s rinclb=$p(inclbStr,"^",4)
 ...q:+rinclb'=inci
 ...q:(dspFlag=1)&&(dspInclb'=rinclb) 										// 库存足够,需记录每个打包批次ID，库存不够仅记录第一打包子表ID
 ...s rqty=+$p(inclbStr,"^",1)
 ...s sp=firstbatsp
 ...s rp=+##class(web.DHCSTPRICE).GetRp(rinclb,+$h,"",HospID,$p($h,",",2)) //yunhaibao20160310,进价按最新进价
 ...s listdata=phaci_"^"_rinclb_"^"_rqty_"^"_sp_"^"_rp_"^"_dspID_"||"_dspSubId
 ...s phacil=..InsPhacItmLB(listdata) 										//生成发药批次记录
 ...s:phacil="" ErrCode=-104
 ...q:ErrCode'=0
 ...;
 ...i InsDspbFlag=1 d
 ....s insDspBat=$$InsDspBatch()
 ....i +insDspBat'>0 d
 .....s ErrCode=-105
 ....e  d
 .....&SQL(UPDATE DHC_PhaCollectItmLB SET PHACIL_DSPB_Dr=:insDspBat WHERE PHACIL_Rowid=:phacil) //更新发药孙表
 .....s:SQLCODE'=0 ErrCode=-106
 ...q:ErrCode'=0
 ...;
 ...s resultstk=##class(web.DHCSTPCHCOLLS2).DhcStkTab(phacil)
 ...s:resultstk<0 ErrCode=-107
 ...q:ErrCode'=0
 ..
 .k ^TMP("DHCST","web.DHCST01","Inclb",pid)  								// 用完及时K
 .q:ErrCode'=0
 .s ret=..UpdStatusForDODISS(phaci,dspID)
 .s:ret<0 ErrCode=-108
 .q:ErrCode'=0
 i ErrCode'=0 d
 .d UK
 .tro
 .k ^TMP("DHCST","web.DHCST01","Inclb",pid)
 q:ErrCode=-103 7  ;即库存不够的情况
 q:ErrCode'=0 ErrCode
 tcommit
 d UK
 k ^TMP("DHCST","web.DHCST01","Inclb",pid)
 q 0
 
LK()
	l +^DHCOEDISPENSING(oeori):5 e  q -1
	q 0
UK
	l -^DHCOEDISPENSING(oeori)  
	q
	
InsDspBatch()
	k OEDISP
 	s OEDISP(0)=dspID
 	s OEDISP(3)=rinclb
 	s OEDISP(4)=rqty
 	s OEDISP(5)=sp
 	s OEDISP(6)=rp
 	s OEDISP(7)=+rinclb
 	s OEDISP(8)="C"
 	&sql(Insert Into DHC_OEDispBatch Values :OEDISP())
 	q $p(%ROWID,$c(1))
DelDspBatch(dspID,inci)
	s tmpinci=inci_"||%"
	&sql(Delete From DHC_OEDispBatch Where DSPB_DSP_ParRef=:dspID and DSPB_INCLB_DR like :tmpinci)
 	q SQLCODE
}

ClassMethod OeordQueryExecute(ByRef qHandle As %Binary, datefrom As %String, dateto As %String, admno As %String, wardid As %String) As %Status
{
 //饮片医嘱查询 create by lq for bjzy 08-03-10
 s repid=$I(^CacheTemp)
 s ind=1
 Set qHandle=$lb(0,repid,0)
 q:datefrom="" $$$OK
 q:dateto="" $$$OK
 ;q:warddesc="" $$$OK
 s tmpid=""
 s tmp=$$GetOeord(datefrom,dateto,admno,wardid)
 s cnt=$p(tmp,"^",1)
 q:cnt=0 $$$OK
 s pid=$p(tmp,"^",2)
 s i=1
 f i=1:1:cnt   d
 . s dispm=^TMP("ListOequery",pid,i)
 . q:dispm=""
 . d OutRowtyp
 . s tmpid=$p(dispm,"^",1)
 k ^TMP("ListOequery",pid)
 Quit $$$OK
OutRowtyp
 set date0=datefrom
 set date1=datefrom+1
 set date2=datefrom+2
 set date3=datefrom+3
 set date4=datefrom+4
 set date5=datefrom+5
 set date6=datefrom+6
 set adm=$p(dispm,"^",1)
 set bed=$p(dispm,"^",2)
 set name=$p(dispm,"^",3)
 set qusdate=$p(dispm,"^",4)
 set quxdate=$p(dispm,"^",5)
 set quxtype=$p(dispm,"^",6)
 set xdate=$p(dispm,"^",7)
 i xdate'="" s xdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(xdate,"IP")
 s date0=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date0,"IP")
 s date1=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date1,"IP")
 s date2=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date2,"IP")
 s date3=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date3,"IP")
 s date4=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date4,"IP")
 s date5=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date5,"IP")
 s date6=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date6,"IP")
 s qusdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(qusdate,"IP")
 s quxdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(quxdate,"IP")
 set Data=$lb(adm,bed,name,date0,date1,date2,date3,date4,date5,date6,qusdate,quxdate,quxtype,xdate)   //所对应传出的列名
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
	
GetOeord(sdate,xdate,admno,wardid)
 s pid=..NewPid()
 s ins1="19^20^31^33^35"      ;这些用法是内服
 s ins2="25^26^27^23^24^34"   ;这些用法是外用
 s flag=""
 s n=0
 s deldate=+$h-30
 i $d(^CREATEFORFIND(deldate)) d
 .f delid=deldate:1:deldate+20 d 
 ..k ^CREATEFORFIND(delid) ;保留10天的数据
 f date=sdate:1:xdate d
 .q:'$d(^CREATEFORFIND(date))
 .s j="" f  s j=$o(^CREATEFORFIND(date,j)) q:j=""  d
 ..s rowid="" s rowid=$o(^CREATEFORFIND(date,j,rowid))
 ..q:$d(^TMP("OEORDQUERY",rowid)) ;过滤同一个OE_OrdItem
 ..s ^TMP("OEORDQUERY",rowid)=""
 ..s ord=+rowid
 ..s chl=$p(rowid,"||",2)
 ..s adm=$p(^OEORD(ord),"^",1)
 ..s papmidr=$p(^PAADM(adm),"^",1)
 ..s pano=$p(^PAPER(papmidr,"PAT",1),"^",1) ;登记号
 ..i admno'="" q:pano'=admno
 ..s bedid=$p(^PAADM(adm),"^",73) ;床号
 ..i bedid="" s bed=""
 ..e  s bed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
 ..s nameid=$p(^PAADM(adm),"^",1)
 ..s name=$p(^PAPER(nameid,"ALL"),"^",1) ;名字
 ..s ward=$p(^PAADM(adm),"^",70) ;病区
 ..i wardid'="" q:ward'=wardid
 ..;s chl="" f  s chl=$o(^OEORDi(0,"ItemDate",date,ord,chl)) q:chl=""  d
 ..s ord1=ord
 ..s chl1=chl
 ..s relrowid=""
 ..i $d(^OEORD(ord,"I",chl,11)) s relrowid=$p(^OEORD(ord,"I",chl,11),"^",39) ;关联医嘱rowid
 ..i relrowid'="" d
 ...s ord1=$p(relrowid,"||",1) 
 ...s chl1=$p(relrowid,"||",2)
 ..s itemstatdr=$p(^OEORD(ord1,"I",chl1,1),"^",13) ; 4:停医嘱
 ..s states=$p(^OEC("OSTAT",itemstatdr),"^",1)
 ..s xdate1=""
 ..i states="D" s xdate1=$p(^OEORD(ord1,"I",chl1,3),"^",34) ;
 ..s prno=$p(^OEORD(ord1,"I",chl1,1),"^",14) ;处方号
 ..s queid=$o(^PAQUE1(0,"PrescNo",prno,""))
 ..;s queid=""
 ..;f  s queid=$o(^PAQUE1(0,"QUE1_PAADM_DR",adm,queid)) q:queid=""  d 
 ..;.s quno=$p(^PAQUE1(queid),"^",14) ;处方号
 ..q:'$d(^PAQUE1(queid,"DHC")) ;过滤非中草药
 ..s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
 ..s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
 ..s quesdate=$p(^PAQUE1(queid,"DHC"),"^",6)
 ..s xdate=xdate1
 ..s quexdate=quesdate+facotor-1 ;停止时间=开始时间+疗程
 ..s quetype=$p(^PAQUE1(queid,"DHC"),"^",11) ;处方用法
 ..i (  (quetype=19) ! (quetype=20) ! (quetype=31) ! (quetype=33) ! (quetype=35) ) d 
 ...s flag="ins1"
 ...s ^TMP("dhcpha","que",pid,adm,prno,flag)=pano_"^"_bed_"^"_name_"^"_$g(quesdate)_"^"_$g(quexdate)_"^"_"ins1"_"^"_xdate
 ..i (  (quetype=25) ! (quetype=26) ! (quetype=27) ! (quetype=23) ! (quetype=24) ! (quetype=34)) d 
 ...s flag="ins2"
 ...s ^TMP("dhcpha","que",pid,adm,prno,flag)=pano_"^"_bed_"^"_name_"^"_$g(quesdate)_"^"_$g(quexdate)_"^"_"ins2"_"^"_xdate
 i flag'="" s n=$$ListOequery(pid)
 quit n_"^"_pid
ListOequery(pid)
 s nn=0
 s adm=""
 f  s adm=$o(^TMP("dhcpha","que",pid,adm)) q:adm=""  d 
 .s quno=""
 .f  s quno=$o(^TMP("dhcpha","que",pid,adm,quno)) q:quno=""  d
 ..s insflag=""
 ..f  s insflag=$o(^TMP("dhcpha","que",pid,adm,quno,insflag)) q:insflag=""  d 
 ...s nn=nn+1
 ...s ^TMP("ListOequery",pid,nn)=^TMP("dhcpha","que",pid,adm,quno,insflag)
 k ^TMP("dhcpha","que",pid)
 k ^TMP("OEORDQUERY")
 quit nn
}

ClassMethod OeordQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OeordQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
			Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query OeordQuery(datefrom As %String, dateto As %String, admno As %String, wardid As %String) As %Query(ROWSPEC = "Tadm:%String,Tbed:%String,Tname:%String,Tdate0:%String,Tdate1:%String,Tdate2:%String,Tdate3:%String,Tdate4:%String,Tdate5:%String,Tdate6:%String,Tqsdate:%String,Tqxdate:%String,Tqtype:%String,Txdate:%String")
{
}

ClassMethod OeordQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OeordQueryExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(web.DHCSTPCHCOLLS).DocLoc(193)
ClassMethod DocLoc(phac As %String) As %String
{
 ;20070404
 n (phac)
 s ch=$o(^DHCPHAC(phac,"I",0))
 q:ch="" ""
 s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 q:oedis="" ""
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 q:ord="" ""
 q:itm="" ""
 s useradddept=$p($g(^OEORD(ord,"I",itm,7)),"^",2)
 s disptype=$p(^DHCPHAC(phac),"^",12)
 i disptype="XDCF" d 		;治疗绑定的协定方科室显示为主医嘱的开单科室！
 .s dsp=$p(^DHCPHAC(phac,"I",ch),"^",13)
 .q:dsp="" 
 .s admloc=$p(^DHCOEDISQTY(dsp),"^",22)
 .s:useradddept'=admloc useradddept=admloc 	
 q $g(useradddept)
}

ClassMethod SendToAuto(phac As %String) As %String
{
	//执行摆药机数据的插入(中间表)
	//返回: 1 - 失败 0 -成功或无需操作
	n (phac)
	q:phac="" 0
	s phac=+phac
	s ordtype=$p($g(^DHCPHAC(phac)),"^",12)
	q:ordtype'="KFBY" 0   //只有此发药分类需要插入摆药机数据
	q:$p(^DHCPHAC(phac),"^",15)="1" 100  //已经传送
	l +^DHCPHASENDAUTO(phac):5  e  q 999
	s err=##class(Ensemble.DHCCombinationXML).DHCCombinationXMLToBS("NO","BAIYAOJI",phac,"BAIYAOJI")
	i err=0 d
	.s flag="1" 
	.;&sql(update dhc_phacollected set dhc_sendautoflag=:flag where dhc_phacollect_rowid=:phac)
	l -^DHCPHASENDAUTO(phac)
	q err
}

ClassMethod GetDODIS(oeori As %String, NotAudit As %String = "") As %String
{
 //根据OsrdItmRowid查找其对应的DHC_OeDipensing记录
 //说明：
 //1.可能是多条
 //2.状态应当是"TC"的    
 //3.有可能需要有"审核"的限制
 n (oeori,NotAudit)
 q:oeori="" ""
 s ret="",result=""
 f  s ret=$o(^DHCOEDISQTY(0,"OEORI",oeori,ret))  q:ret=""  d
 . q:$p(^DHCOEDISQTY(ret),"^",7)'="TC"  //状态不是"TC"的不考虑
 . 
 . s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
 . s priority=$p(^OEORD(ord,"I",chl,1),"^",8)
 . 
 . //审核控制
 . q:(NotAudit'="1")&&(##Class(web.DHCSTCOMMONSRV).IfAuditByPriority(ret)=0)
 . i result="" s result=ret
 . e  s result=result_"^"_ret
 q result
}

ClassMethod CalDspQty(dodiss As %String, inci As %String) As %String
{
	//根据dodis串，汇总应发药数量
	n (dodiss,inci)
	s totalQty=0
	q:(dodiss="")||(inci="") totalQty
	s cnt=$l(dodiss,",")
	f i=1:1:cnt d
	. s dodis=$p(dodiss,",",i)
	. q:$p(^DHCOEDISQTY(dodis),"^",7)'="TC" 
	. s dodisSub=""
	. f  s dodisSub=$o(^DHCOEDISQTY(dodis,"I",dodisSub)) q:dodisSub=""  d
	.. q:+dodisSub=0
	.. s dodisInci=$p(^DHCOEDISQTY(dodis,"I",dodisSub),"^",5)
	.. s dosisInclb=$p(^DHCOEDISQTY(dodis,"I",dodisSub),"^",1)
	.. s dodisInci=$s(dodisInci'="":dodisInci,1:+dosisInclb)
	.. q:dodisInci'=inci
	.. s qty=$p(^DHCOEDISQTY(dodis,"I",dodisSub),"^",2)
	.. s totalQty=totalQty+qty
	q totalQty
}

ClassMethod ReGetDodis(dodiss As %String, ord As %String, chl As %String, prescno As %String = "") As %String [ ProcedureBlock = 1 ]
{
 //重新判断dhc_oedispensing状态
 s result=""
 q:dodiss="" result
 s AdmDr=$p(^OEORD(ord),"^",1)
 q:AdmDr="" result
 s ArcimId=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 q:ArcimId="" result
 s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 s PriorDr=$p(^OEORD(ord,"I",chl,1),"^",8) 
 q:PriorDr="" result							;优先级不存在的不予发放
 s Priority=$p($g(^OECPR(PriorDr)),"^",1) 					;医嘱优先级
 s oeori=ord_"||"_chl
 s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(AdmDr,ArcCatId_"^"_Priority_"^"_oeori)  ;最终结算,则不发药 //zhouyg 2013-05-15 添加oeori
 q:AmtFlag=0 result
 s dodiss=$tr(dodiss,"^",",") 
 s cnt=$l(dodiss,",")
 f i=1:1:cnt d
 .s dodis=$p(dodiss,",",i)
 .q:$p(^DHCOEDISQTY(dodis),"^",7)'="TC"
 .s ordexerowid=$p(^DHCOEDISQTY(dodis),"^",3) 
 .q:##class(web.DHCSTCOMMONSRV).GetOrdState(ordexerowid)=0  ;判断执行记录状态是否可配药
 .//护士领药审核控制
 .//q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(dodis)=0  ;需要审核但是配药记录未审核则不发药
 .q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(dodis,prescno)>0   ; 拒发药控制
 .i result="" s result=dodis
 .e  s result=result_","_dodis
 q result
}

ClassMethod UpdStatusForDODISS(phaci As %String, dodiss As %String) As %String
{
 //修改dhc_oedispensing的字段内容
 //phaci - dhc_phacollectitm.phaci_rowid
 //dodiss - dodis串
	n (phaci,dodiss)
	s err=0
	q:phaci="" err
	q:dodiss="" err
	//
	s phac=+phaci
	s RecLocID=$p($g(^DHCPHAC(phac)),"^",1)
	s HospID=$p(^CTLOC(RecLocID),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//价格规则
	s dd=+$h,tt=$p($h,",",2)
	s user=$p($g(^DHCPHAC(phac)),"^",5)
	s type="P" 
	s code="C"  //"已发药状态"
	s pointer=phaci
	s cnt=$l(dodiss,",")
	f i=1:1:cnt q:err'=0  d
	.s dhcoedis=$p(dodiss,",",i) 
	.q:dhcoedis=""
	.
	.&sql(update DHC_OEDispensing set dsp_status=:code,dsp_date=:dd,dsp_time=:tt,
	  dsp_user=:user,dsp_type=:type,dsp_pointer=:pointer where dsp_rowid=:dhcoedis)
	.i SQLCODE'=0  d
	..s err=-1 
	..s ret=$$SqlErrorRecord^DHCSTERROR("UpdStatusForDODISS:DHC_OEDispensing",phaci,SQLCODE_":"_$G(%msg))
	.q:err=-1
	.;改变打包子表的状态
	.&sql(update DHC_OEDispBatch set DSPB_Status=:code where DSPB_DSP_ParRef=:dhcoedis)
	.i SQLCODE'=0  d
	..s err=-2 
	..s ret=$$SqlErrorRecord^DHCSTERROR("UpdStatusForDODISS:DHC_OEDispBatch",dhcoedis,SQLCODE_":"_$G(%msg))
	.q:err=-2
	.i RuleFlag'=3 d
	..s dhcoedisSub=0
	..f  s dhcoedisSub=$o(^DHCOEDISQTY(dhcoedis,"I",dhcoedisSub)) q:dhcoedisSub=""  d
	...s dspQty=-$p($g(^DHCOEDISQTY(dhcoedis,"I",dhcoedisSub)),"^",2)
	...s inci=$p($g(^DHCOEDISQTY(dhcoedis,"I",dhcoedisSub)),"^",5)
	...s inciCh=$o(^INCI("IL_LOC",RecLocID,inci,""))
	...s incil=inci_"||"_inciCh
	...d ##class(web.DHCST01).UPDINVRESQTY(inci,RecLocID,dspQty)
	...s SqlStr=incil_"^"_3_"^"_dspQty_"^"_""_"^"_dhcoedis_"^"_RecLocID
 	...s Ret=##Class(User.DHCIncReservedQtyDetail).Insert(SqlStr)	//zhouyg 20160826
 	..
 	.
	q err
}

ClassMethod SendDrugInfosToAuto() As %String
{
	//执行摆药机数据的插入(中间表 )
	//返回: 1 - 失败 0 -成功或无需操作
	s err=##class(Ensemble.DHCCombinationXML).DHCCombinationXMLToBS("DrugInfo","BAIYAOJI","","BAIYAOJI")
	q err
}

ClassMethod AuditedDodis(dodis) As %String
{
	//dhc_oedispensing 记录是否审核
    q:dodis="" ""
	q:$p($g(^DHCOEDISQTY(dodis)),"^",17)="Y" 1
	q 0
}

ClassMethod ChkPhaItmInfo(coll, pamstr) As %String
{
	//根据发药明细表条件过滤主表      ret:0 不符合条件  ret:1 符合条件 
   n (coll, pamstr) 
   s regno=$p(pamstr,"^",1)
   s longord=$p(pamstr,"^",2)
   s shortord=$p(pamstr,"^",3)
   s ret=0
   s chl=""  f  s chl=$o(^DHCPHAC(coll,"I",chl)) q:chl=""  d
   .s adm=$p(^DHCPHAC(coll,"I",chl),"^",3)
   .s papmi=$p(^PAADM(adm),"^",1)
   .s pano=$p(^PAPER(papmi,"PAT",1),"^",1)
   .q:(pano'=regno)&(regno'="")  //登记号
   .s oedis=$p(^DHCPHAC(coll,"I",chl),"^",7) 
   .s ord=$p(oedis,"||",1)                                                                                    
   .s chd=$p(oedis,"||",2) 
   .s priority=$p(^OECPR($p(^OEORD(ord,"I",chd,1),"^",8)),"^",1)
   .q:(longord="1")&(priority'="S") //仅显示长嘱
   .q:(shortord="1")&(priority="S")
   .q:(shortord="1")&(priority="OUT") //仅显示临嘱
   .s ret=ret+1               
   q $g(ret)
}

ClassMethod KillDISPMQ(pid) As %String
{
  n (pid)
  k ^TMP("dhcpha",pid,"DISPMQ")
  q 0
}

ClassMethod GetPhacStr(pid, startno, endno, pamstr) As %String
{
  //根据已发药查询界面序号构造coll串,解决分页翻页逐条手工打勾问题
  //返回 coll1+"B"+pamstr+"A"+coll2+"B"+pamstr+...
  //create by lq 
  n (pid,startno,endno,pamstr)
  s phacstr=""
  s cnt=$o(^TMP("dhcpha",pid,"DISPMQ",""),-1)
  i startno<1 s startno=1
  i endno="" s endno=cnt
  i endno>cnt s endno=cnt
  f i=startno:1:endno   d
  . s str=^TMP("dhcpha",pid,"DISPMQ",i)
  . s coll=$p(str,"&",1)
  . s coll=coll_"B"_pamstr
  . i phacstr="" s phacstr=coll
  . e  s phacstr=phacstr_"A"_coll
  q phacstr
}

ClassMethod KillBeforeLoad(pid) As %String
{
	///Description:每次刷新前kill
	///Creator:lq
	n (pid)
	q:pid="" 0
	i $d(^TMP("dhcpha",pid)) d
	.k ^TMP("dhcpha",pid)
	q 0
}

/// Creator:Liang Qiang
/// CreatDate: 2008-11-16 
/// Descrition(测试用):当医嘱项 剂量单位 <> 药学项基本单位,且剂量*频次 / 基本单位数量<> 1, 
///           通过OrdItmRowid 计算出打包数量(实物发放数量) - 剂量*频次
/// Table:
/// Input:OrdItmRowid
/// Output:
/// Return:1.ReservedQty(保留数量) = 打包数量 - 剂量*频次
///        2.packqty 打包数量(实物发放数量)
/// Others:
ClassMethod GetResQtyByOrdItm(OrdItmRowid) As %String
{
   n (OrdItmRowid)
   s ord=$p(OrdItmRowid,"||",1),chl=$p(OrdItmRowid,"||",2)
   s adm=$p(^OEORD(ord),"^",1)  
   q:adm="" 0
   s warddr=$p(^PAADM(adm),"^",70)  ;病人所在病房
   s recloc=$p(^OEORD(ord,"I",chl,3),"^",6) q:recloc="" 
   ;
   s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量 
   s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId 
   s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  
   s doseuom=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2) ;剂量单位   
   ;
   s OrderDoseUOMRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",3)     ;OEORI_Unit_DR
   s OrderDrugFormRowid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",12)
   s OrderDoseQty=$p($g(^OEORD(ord,"I",chl,2)),"^",1) ;OEORI_DoseQty
   ;s BaseDoseQty=##class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid,OrderDrugFormRowid,OrderDoseQty)
   ;
   s OrderFreqRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
   s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2) ;
   s OrderDurRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",6) ;OEORI_Durat_DR
   s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2) ;
   s NumTimes=OrderFreqFactor*OrderDurFactor ;频次
   s dispqty=dosage*NumTimes ;发药总剂量
   
   s admresqty=$$getAdmResQty(recloc,inci,warddr,adm)
   ;-------------------------------
   i admresqty'=0 d
   .i (dispqty-admresqty>0) d
   ..s dispqty=dispqty-admresqty
   .e  d
   .s dispqty=admresqty-dispqty
   ;-----------------------------------------------
   ;w !,NumTimes
   ;s BaseDoseQtySum=BaseDoseQty*NumTimes
   ;                             
   s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
   s phcdfdr=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",12)
   s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""
   s buomdr=$p(^INCI(inci,1),"^",10)
   s buom=$p(^CT("UOM",buomdr),"^",2) ;基本单位
   q:doseuom=buom 0
   s eqchl=""
   f  s eqchl=$o(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl)) q:eqchl=""  d
   .s ctuomdr=$p(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl),"^",1)
   .s equom=$p(^CT("UOM",ctuomdr),"^",2) ;等效单位
   .s eqqty=$p(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl),"^",2) ;等效数量
   .q:equom'=doseuom
   .;w !,dispqty
   .i dispqty > eqqty d
   ..s packqty=dispqty/eqqty
   ..i $f(packqty,".") d 
   ...s qty=$p(packqty,".",1)
   ...s packqty=qty+1
   ..s ReservedQty=((eqqty*packqty)-dispqty)
   .e  d
   ..s ReservedQty=(eqqty-dispqty)
   .;w !,doseuom_"^"_buom_"^"_equom_"^"_eqqty_"^"_ReservedQty
   
   q $g(ReservedQty)
   
getAdmResQty(recloc,inci,warddr,adm)
  s presid=""
  f  s presid=$o(^DHCPRES(0,"LOCINCIWARD",recloc,inci,warddr,presid)) q:presid=""  d
  .s preschl=""
  .f  s preschl=$o(^DHCPRES(presid,"DET",preschl)) q:preschl=""  d 
  ..s prdetadm=$p(^DHCPRES(presid,"DET",preschl),"^",4)
  ..q:prdetadm'=adm
  ..s prdetqty=$p(^DHCPRES(presid,"DET",preschl),"^",3)
   
  q +$g(prdetqty)
}

/// Creator:Liang Qiang
/// CreatDate:2008-04-17
/// Table:PA_Que1 
/// Descriprtion:判断是否为关联医嘱  i=1:不是  i>1:是            
/// Input:OE_OrdItmRowid
/// Output:i_"%"_关联医嘱rowid串_"$$"_  (i--拒绝Oe_orditm总数  str--关联医嘱rowid串_"$$"_ )
/// Return:
/// Others:
ClassMethod CheckLinkOeord(oedis As %String) As %String
{
	s ord=$P(oedis,"||",1)
	s itm=$P(oedis,"||",2)	
	s i=1
	s str=""
	s oeoridr=$p(^OEORD(ord,"I",itm,11),"^",39) ;
	i oeoridr'="" d
	.s str=oeoridr
	.s childsub="" f  s childsub=$o(^OEORDi(0,"OEORI",ord,oeoridr,childsub)) q:childsub=""  d
	..s i=i+1
	..q:childsub=itm   
	..s str=str_"$$"_ord_"||"_childsub  
	e  d
	.s childsub="" f  s childsub=$o(^OEORDi(0,"OEORI",ord,oedis,childsub)) q:childsub=""  d
	..s i=i+1
	..i str="" s str=ord_"||"_childsub
	..e  s str=str_"$$"_ord_"||"_childsub
	q i_"%"_str
}

ClassMethod DispTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCSTPCHCOLLS","DispTotal","87^#88^#89^")

ClassMethod DispTotalExecute(ByRef qHandle As %Binary, phacrowidStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//q:coll="" $$$OK
	//实现已发药查询中显示发药单汇总  Creator :LQ
	d ResetVariablesGetDispTotal
	s amttotal=0
    s DetailLen=$length(phacrowidStr,"A")
	f l=1:1:DetailLen  d  
	.s pid=..NewPid()
	.s Detail=$p(phacrowidStr,"A",l)
	.s coll=$p(Detail,"^",1)
	.s PamStr=$p(Detail,"^",2,$l(Detail,"^"))
 	. d GetDispTotal(coll,PamStr,pid)

	s phacdr=""
	f  s phacdr=$o(^TMP("dhcpha","DispTotal",phacdr)) q:phacdr=""  d
	.s inci=""
	.f  s inci=$o(^TMP("dhcpha","DispTotal",phacdr,inci)) q:inci=""  d
	
	..s dispinfo=^TMP("dhcpha","DispTotal",phacdr,inci) 
	..d OutputRowsDisp
	
	d outputtotalDispTotal
	
	k ^TMP("dhcpha","DispTotal")
	
	Quit $$$OK
	
OutputRowsDisp
    s Tincicode=$p(dispinfo,"^",4)
    s Tincidesc=$p(dispinfo,"^",5)
	s Tqty=$p(dispinfo,"^",2)
	s Tinciamt=$p(dispinfo,"^",3)
	s Tgenedesc=$p(dispinfo,"^",6)
	i $f(Tgenedesc,"-") s Tgenedesc=$p(Tgenedesc,"-",2)
	s Tphcform=$p(dispinfo,"^",7)
	s Tspec=$p(dispinfo,"^",8)
	s Tmanf=$p(dispinfo,"^",9)
	i $f(Tmanf,"-") s Tmanf=$p(Tmanf,"-",2)
	s Tuom=$p(dispinfo,"^",10)
	s Tprice=$p(dispinfo,"^",11)
	s amttotal=amttotal+Tinciamt
	
	s Tinciamt=$fn(Tinciamt,"",2)
	s amttotal=$fn(amttotal,"",2)
 
	s Data=$lb(Tincicode,Tincidesc,Tqty,Tinciamt,Tgenedesc,Tphcform,Tspec,Tmanf,Tuom,Tprice)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q

outputtotalDispTotal
	;2007-8-7,zdm
	s Data=$lb("总计","","",amttotal)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
	
ResetVariablesGetDispTotal
	s (Tqty,Tinciamt,Tincicode,Tincidesc,Tgenedesc,Tphcform,Tspec,Tmanf,Tuom,Tprice)=""
	q
GetDispTotal(phacdr,pamstr,pid) 
 q:phacdr=""
 s regno="",longord="",shortord=""
 s regno=$p(pamstr,"^",1)
 s longord=$p(pamstr,"^",2)
 s shortord=$p(pamstr,"^",3)
 i '$d(^DHCPHAC(phacdr)) q -1
 s phaci="" f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
 .//s i=i+1
 .s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
 .s inci=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
 .s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)
 .s qty=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)
 .s price=$p(^DHCPHAC(phacdr,"I",phaci),"^",9)                                                    ;INCLB_ChildSub
 .s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
 .s phcform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
 .s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) 	        //规格
 .s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)		//厂家
 .s CTUOMDR=$p(^INCI(inci,1),"^",10) 							// 指向 CT_UOM 
 .s UOMDesc=$p(^CT("UOM",CTUOMDR),"^",2) 						//单位
 .s diagnose=""
 .i adm'="" s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
 .s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
 .s chl=$p(oedis,"||",2) 
 .s doctorlocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
 .s doctorloc=$p(^CTLOC(doctorlocdr),"^",2) 
 .i '$d(^OEORD(ord,"I",chl)) q 
 .s DocTor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)  
 .s ordmemo=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(oedis)                                 ;oeori_remarks
 .&sql(select oeori_doctor_dr into :doctor from oe_orditem where oeori_oeord_parref=:ord and oeori_childsub=:chl)   ;医师
 .i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)  
 .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;ARCIM_RowId     
 .s patnameid=$p(^PAADM(adm),"^",1)    ;PA_PatMas PAPMI_RowId
 .s patid=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)                 ;病人姓名   
 .s patno=$p(^PAPER(patnameid,"PAT",1),"^",1) 
 .q:(regno'="")&(regno'=patno)                  //过滤登记号条件
 .s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1) 
 .i longord="1" q:priority'="S"              //过滤仅显示长嘱条件
 .i shortord="1" q:(priority="S")!(priority="OUT") //过滤仅显示临嘱条件
 .s sexid =$p( ^PAPER(patnameid,"ALL"),"^",7)   
 .s sex =$p(^CT("SEX",sexid),"^",2 )            //性别
 .s PADob=$p( ^PAPER(patnameid,"ALL"),"^",6)
 .s Paold=""
 .i PADob'="" s Paold=$fn((+$h-PADob)/365,"",0) //年龄
 .s getaction=##class(web.DHCSTPCHCOLLS2).SkinTest2(ord_"||"_chl) ;//2007-10-26 皮试结果
 .s code="In Patient"                                  
 .&sql(select max(paadm_admdate) into :admdate from pa_adm where paadm_papmi_dr=:patnameid and paadm_type=:code)  ;入院日期
 .s admdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate,"IP") 
 .s deploc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)
 .s arcim=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
 .s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
 .s j=deploc_"||"_bed_"||"_arcim         ;i phactype="PJ"
 .s incicode=$p(^INCI(inci,1),"^",1)
 .s incidesc=$p(^INCI(inci,1),"^",2)
 .s inciamt=0,price=""
 .s phaclb=""
 .f  s phaclb=$o(^DHCPHAC(phacdr,"I",phaci,"B",phaclb)) q:phaclb=""  d
 ..s phaclbdata=^(phaclb)
 ..s inciamt=inciamt+$p(phaclbdata,"^",6) 
 ..i price="" s price=$p(phaclbdata,"^",5) 
 .s info=inci_"^"_qty_"^"_inciamt_"^"_incicode_"^"_incidesc_"^"_genedesc_"^"_phcform_"^"_Specifaction_"^"_manf_"^"_UOMDesc_"^"_price

 .i '$d(^TMP("dhcpha","DispTotal",phacdr,inci)) d
 ..s ^TMP("dhcpha","DispTotal",phacdr,inci)=info
 .e  d
 ..s $p(^TMP("dhcpha","DispTotal",phacdr,inci),"^",2)=$p(^TMP("dhcpha","DispTotal",phacdr,inci),"^",2)+qty
 ..s $p(^TMP("dhcpha","DispTotal",phacdr,inci),"^",3)=$p(^TMP("dhcpha","DispTotal",phacdr,inci),"^",3)+inciamt
 q
}

ClassMethod DispTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispTotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query DispTotal(phacrowidStr As %String) As %Query(ROWSPEC = "Tincicode:%String,Tincidesc:%String,Tqty:%String,Tinciamt:%String,Tgenedesc:%String,Tphcform:%String,Tspec:%String,Tmanf:%String,Tuom:%String,Tprice:%String")
{
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-03
/// Descriprtion:获得中草药煎药方式 
/// Table:PA_Que1 
/// Input:处方号
/// Output:煎药方式 
/// Others:
ClassMethod GetCookType(prescno)
{
   n (prescno)
   q:prescno="" ""
   s queid=""
   s i=1
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC")) 
   .s type=$p(^PAQUE1(queid,"DHC"),"^",15) ;
   .s i=i+1
   q $g(type)
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-03
/// Descriprtion:发前时,根据选择,保存需过滤的医嘱Rowid
/// Table:^TMP("dhcpha",pid)
/// Input:进程号,医嘱Rowid,标识:S -(SVAE) D -(Delete)
/// Output:
/// Others:
ClassMethod SaveToFilter(pid, oedispstr, flag)
{
   n (pid,oedispstr,flag)
   s oedisplen=$l(oedispstr,",")
   f i=1:1:oedisplen d
   .s oedisp=$p(oedispstr,",",i)
   .q:oedisp=""
   .i flag="S" d
   ..s ^TMP("dhcpha",pid,"D","Filter",oedisp)=""
   .i flag="D" d 
   ..i $d(^TMP("dhcpha",pid,"D","Filter",oedisp)) d
   ...k ^TMP("dhcpha",pid,"D","Filter",oedisp)
   q 0
}

/// Creator:Liang Qiang
/// CreatDate:2009-05-26
/// Descriprtion:沈阳(滚长嘱时,置^DispAllowed="N",滚完后,置^DispAllowed="Y")
/// Table:^DispAllowed
/// Input:OE_OrdItemRowid
/// Output:"Y" - 允许发  , "N" - 不允许发
/// Return:"Y" - 允许发  , "N" - 不允许发
/// Others:
ClassMethod CheckDispAllowed(phacidis) As %String
{
	s ord=$p(phacidis,"||",1)
	s chl=$p(phacidis,"||",2)
	s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1)
	i priority'="S" q "Y"
	i $d(^DispAllowed) d
	.s flag=^DispAllowed
	e  d
	.s flag="Y"
    q flag
}

/// Creator:Liang Qiang
/// CreatDate:2009-06-30
/// Description:根据医嘱明细表rowid取开医嘱时的患者所在病区
/// Input:OrdItmRowid
/// Output:开医嘱时的患者所在病区dr
/// Return:开医嘱时的患者所在病区dr_"^"_床dr
/// Others:
ClassMethod getOrdWard(OrdItmRowid) As %String
{
	//刚入院时有两条记录，其中一条TRANS_Main是"Y"
    s exit=0
    s admwarddr=""
    s admbeddr=""
    s ord=$p(OrdItmRowid,"||",1)
    s chl=$p(OrdItmRowid,"||",2)
    s adm=$p(^OEORD(ord),"^",1)  
    s orditmdate=$p(^OEORD(ord,"I",chl,3),"^",7)
    s orditmtime=$p(^OEORD(ord,"I",chl,1),"^",17)
    s transchl="" 
    f  s transchl=$o(^PAADM(adm,"TRANS",transchl),-1) q:(transchl="")!(exit=1)  d
    .s transmain=$p(^PAADM(adm,"TRANS",transchl),"^",13)
    .q:transmain="Y" ;转大夫记录
    .s startdate=$p(^PAADM(adm,"TRANS",transchl),"^",1)
    .s starttime=$p(^PAADM(adm,"TRANS",transchl),"^",2)
    .s enddate=$p(^PAADM(adm,"TRANS",transchl),"^",3)
    .s endtime=$p(^PAADM(adm,"TRANS",transchl),"^",4) 
    .;q:enddate=""  ;未发生转移
    .i endtime="" d
    ..i ((orditmdate=startdate)&&(orditmtime'<starttime))||(orditmdate>startdate) d
    ...s admwarddr=$p(^PAADM(adm),"^",70)
    ...s admbeddr=$p(^PAADM(adm),"^",73)
    ...s exit=1
    .i endtime'="" d
    ..i (((orditmdate=startdate)&&(orditmtime'<starttime))||(orditmdate>startdate))&&(((orditmdate=enddate)&&(orditmtime'>endtime))||(orditmdate<enddate)) d
    ...s transwarddr=$p(^PAADM(adm,"TRANS",transchl),"^",9)
    ...s admwarddr=transwarddr
    ...s transbeddr=$p(^PAADM(adm,"TRANS",transchl),"^",8)
    ...s admbeddr=transbeddr
    ...s exit=1
    ...
    i admwarddr="" d
    .s admwarddr=$p(^PAADM(adm),"^",70)
    i admbeddr="" d
    .s admbeddr=$p(^PAADM(adm),"^",73)
    q $g(admwarddr)_"^"_$g(admbeddr)
}

/// Creator:Liang Qiang
/// CreatDate:2009-09-31
/// Description:获取选择科室的发药退药汇总信息(按病区科室统)
/// Input:进程号,科室串
/// Output:记录数
ClassMethod SelAdmLocDisp(processid As %String, deptstr As %String) As %Integer
{
 n (processid,deptstr) 
 s num=0
 s TotalQty=0				//合计数量总计
 s TotalAmt=0				//合计金额总计
 s TotalAmtRp=0				//合计金额总计：进价
 s TotalDspQty=0  			//发药数量总计
 s TotalDspAmt=0  			//发药金额总计
 s TotalDspAmtRp=0  		//发药金额总计：进价
 s TotalRetQty=0  			//退药数量总计
 s TotalRetAmt=0  			//退药金额总计
 s TotalRetAmtRp=0  		//退药金额总计：进价
 s deptnum=$l(deptstr,"^")  
 ;科室统计
 f i=1:1:deptnum d
 .s dept=$p(deptstr,"^",i)
 .q:dept=""
 .s SubQty=0				//合计数量小计
 .s SubAmt=0				//合计金额小计
 .s SubAmtRp=0				//合计金额小计:进价
 .s SubDspQty=0  		//发药数量小计
 .s SubDspAmt=0  		//发药金额小计
 .s SubDspAmtRp=0  		//发药金额小计：进价
 .s SubRetQty=0  		//退药数量小计
 .s SubRetAmt=0  		//退药金额小计
 .s SubRetAmtRp=0  		//退药金额小计：进价
 .
 .s inci="" 
 .f  s inci=$o(^TMP("dhcpha",processid,"locsum1",dept,inci)) q:inci=""  d
 ..s sub=""
 ..f  s sub=$o(^TMP("dhcpha",processid,"locsum1",dept,inci,sub)) q:sub=""  d
 ...s ward=$p(^CTLOC(dept),"^",2)
 ...s inciname=$p(^INCI(inci,1),"^",2)
 ...s incicode=$p(^INCI(inci,1),"^",1)
 ...s rInciOriginalArcimDr=$p(^INCI(inci,1),"^",3) ;通过库存项的RowId取指向医嘱项的字段
 ...s rArcimRowId=rInciOriginalArcimDr ;指向医嘱项的内容=医嘱项的RowId
 ...s rSubscript=$p(rArcimRowId,"||",1) ;医嘱项RowId的前半部分
 ...s rVersion=$p(rArcimRowId,"||",2) ;医嘱项RowId的后半部分
 ...s rArcimPhcdfDr=$p(^ARCIM(rSubscript,rVersion,1),"^",12) ; 指向PHC_DrgForm
 ...s rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
 ...s rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
 ...q:(rPhcDrgForm1="")||(rPhcDrgForm2="") 
 ...q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2))
 ...s rPhcdfPhcfDr=$p($g(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,1)),"^",1) ;指向PHC_Form
 ...s rPhcfDesc=$p($g(^PHCF(+rPhcdfPhcfDr)),"^",2) ; 取剂型
 ...s rmanf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
 ...s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci) ;通用名//2007-10-13
 ...s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) ;规格 
 ...s uom=$p(^INCI(inci,1),"^",10)
 ...s uomname=$p(^CT("UOM",uom),"^",2)
 ...s phciprice=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",7) 
 ...s rp=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",8) 
 ...
 ...s retamt=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",5) 	;退药金额
 ...s retamtrp=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",6) 	;退药金额:进价
 ...s retqty=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",4)   	;退药数量
 ...s dispqty=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",1)    ;发药数量
 ...s amt=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",2)  		;发药金额
 ...s rpamt=$p(^TMP("dhcpha",processid,"locsum1",dept,inci,sub),"&",3)		;发药金额:进价
 ...
 ...s sumqty=dispqty-retqty							//合计数量
 ...s sumamt=amt-retamt								//合计金额
 ...s sumamtrp=rpamt-retamtrp						//合计金额:进价
 ...
 ...s SubQty=SubQty+sumqty							//合计数量小计
 ...s SubAmt=SubAmt+sumamt							//合计金额小计
 ...s SubAmtRp=SubAmtRp+sumamtrp					//合计金额小计:进价
 ...s SubDspQty=SubDspQty+dispqty  					//发药数量小计
 ...s SubDspAmt=SubDspAmt+amt 						//发药金额小计
 ...s SubDspAmtRp=SubDspAmtRp+rpamt  				//发药金额小计：进价
 ...s SubRetQty=SubRetQty+retqty  					//退药数量小计
 ...s SubRetAmt=SubRetAmt+retamt  					//退药金额小计
 ...s SubRetAmtRp=SubRetAmtRp+retamtrp  			//退药金额小计：进价
 ...
 ...s TotalQty=TotalQty+sumqty						//合计数量总计
 ...s TotalAmt=TotalAmt+sumamt						//合计金额总计
 ...s TotalAmtRp=TotalAmtRp+sumamtrp				//合计金额总计：进价
 ...s TotalDspQty=TotalDspQty+dispqty  					//发药数量总计
 ...s TotalDspAmt=TotalDspAmt+amt  						//发药金额总计
 ...s TotalDspAmtRp=TotalDspAmtRp+rpamt  				//发药金额总计：进价
 ...s TotalRetQty=TotalRetQty+retqty  					//退药数量总计
 ...s TotalRetAmt=TotalRetAmt+retamt  					//退药金额总计
 ...s TotalRetAmtRp=TotalRetAmtRp+retamtrp  			//退药金额总计：进价
 ...
 ...s subsumUom=##Class(web.DHCSTCOMINC).GetQtyIncUom(inci,sumqty)
 ...s num=num+1
 ...s ^TMP("dhcpha",processid,"ADMLOCDISP",num)=inciname_"&"_dispqty_"&"_retqty_"&"_sumqty_"&"_$g(uomname)_"&"_$g(sumamt)_"&"_$g(incicode)_"&"_rPhcfDesc_"&"_rmanf_"&"_Specifaction_"&"_phciprice_"&"_generic_"&"_subsumUom_"&"_ward_"&"_rp_"&"_sumamtrp
 ..
 .;s num=num+1 
 .;s ^TMP("dhcpha",processid,"ADMLOCDISP",num)="合计:"_"&"_SubDspQty_"&"_SubRetQty_"&"_SubQty_"&&"_SubAmt_"&&&&&&&&&&"_SubAmtRp
 .
 ;总计
 s num=num+1
 s ^TMP("dhcpha",processid,"ADMLOCDISP",num)=""_"&"_TotalDspQty_"&"_TotalRetQty_"&"_TotalQty_"&&"_TotalAmt_"&"_"总计:"_"&&&&&&&&&"_TotalAmtRp
 q num
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Description:构造某接收科室发药库存项Rowid,为发药前退药做准备
/// Input:接收科室Rowid,库存项Rowid,进程号,
/// Return:^TMP("dhcpha",pid,"DispItem")
/// Others:
ClassMethod getDispOrdItem(recloc, pid, inci, orditm, dhcoedis) As %String
{
	n (recloc, pid, inci, orditm,dhcoedis)
	q:##class(web.DHCSTCOMMONSRV).ReserveRetFlag(recloc)'="Y" ""
	q:##class(web.DHCSTCOMMONSRV).GetCatReserve(inci)'>0 ""
	s ord=+orditm
	s chl=$p(orditm,"||",2)
	s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1)
	q:priority="OUT" "" ;不包括出院带药
	;zdm,2012-02-24,由直接赋值改为累计拼串
	;s ^TMP("dhcpha",pid,"DispOrdItem",recloc,inci,orditm)=dhcoedis
	i $d(^TMP("dhcpha",pid,"DispOrdItem",recloc,inci,orditm))  d
	.s TmpDodis=^TMP("dhcpha",pid,"DispOrdItem",recloc,inci,orditm)
	.s ^TMP("dhcpha",pid,"DispOrdItem",recloc,inci,orditm)=TmpDodis_"^"_dhcoedis
	e  d
	.s ^TMP("dhcpha",pid,"DispOrdItem",recloc,inci,orditm)=dhcoedis
	q 0
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Description:发药前如果该药有申请退药,则先执行退药
///             1,发药数量>= 退药数量时,全退;
///             2,发药数量 < 退药数量时,部分退;
/// Input:进程号,用户ID
/// Return:完成提示
/// w ##class(web.DHCSTPCHCOLLS).ExeRetBeforeDisp("165984",1) 
/// Update:2012-08-06 zhouyg 修改7.0升级本函数未相应升级
ClassMethod ExeRetBeforeDisp(pid, DspUserID As %String) As %String
{
	n (pid,DspUserID,%session)
	s flag="Execute"
	s retno=""
	q:'$d(^TMP("dhcpha",pid,"DISPM")) ""
	s recloc=$p(^TMP("dhcpha",pid,"DISPM"),"^",1)
	q:recloc="" ""
    q:##class(web.DHCSTCOMMONSRV).ReserveRetFlag(recloc)'="Y" ""
	s wardid=$p(^TMP("dhcpha",pid,"DISPM"),"^",2)
	q:wardid="" ""
	s warddesc=$p(^PAWARD(wardid),"^",2)
	s locid=##class(web.DHCSTCOMMONSRV).LocToRowID(warddesc)
	d getLocRetConfig()
	s reqIDStr=""
    s inci=""
    f  s inci=$o(^TMP("dhcpha",pid,"DispOrdItem",recloc,inci)) q:inci=""  d
    .q:##class(web.DHCSTCOMMONSRV).GetCatReserve(inci)'>0
    .s inciqty=0
    .s orditm=""
    .f  s orditm=$o(^TMP("dhcpha",pid,"DispOrdItem",recloc,inci,orditm)) q:orditm=""  d
    ..s dhcoedis=^TMP("dhcpha",pid,"DispOrdItem",recloc,inci,orditm) 
    ..s ordqty=..getRetOrdItemQty(recloc, pid, inci, orditm,dhcoedis)
    ..s inciqty=inciqty+ordqty
    .s dispqty=inciqty
    .q:dispqty=0
	.s ret=0
	.s reqid=""
	.f  s reqid=$o(^RETRQ(0,"RECSTDEPT",recloc,"Prove",locid,reqid)) q:(reqid="")!(ret=1)  d
	..s requestdate=$p(^RETRQ(reqid),"^",16)
	..q:($g(rstdate)'="")&(requestdate<rstdate)
	..q:($g(renddate)'="")&(requestdate>renddate)
	..s reqSub="0"
	..f  s reqSub=$o(^RETRQ(0,"INCI",inci,reqid,reqSub)) q:(reqSub="")!(ret=1)  d
	...s RQIStatus=$p(^RETRQ(reqid,"I",reqSub),"^",10)
	...q:RQIStatus=flag
	...s reqiID=reqid_"||"_reqSub
	...s reqqty=##class(web.DHCSTPHARETURN).GetReqItmSurplus(reqiID)
	...q:($g(retallflag)="Y")&(reqqty>dispqty) //全退
	...i reqIDStr="" d
	....s reqIDStr=reqiID_"^"_reqqty
	...e  d
	....s reqIDStr=reqIDStr_","_reqiID_"^"_reqqty
	s ExeRet=""
	i reqIDStr'="" d
	.s ExeRet=##Class(web.DHCSTPHARETURN).ExecReturnByReq("","",recloc,DspUserID,"RT",reqIDStr)
	q ExeRet
getLocRetConfig()
    s pl=$o(^DHCPL(0,"Loc",recloc,""))
    ;取查找申请单时间范围
    s rstdate=$p(^DHCPL(pl),"^",18)
    s renddate=$p(^DHCPL(pl),"^",19)
    s rstdate=##Class(web.DHCSTKUTIL).GetDatH(rstdate)
    s renddate=##Class(web.DHCSTKUTIL).GetDatH(renddate)
    ;取"部分退","全退"配置,"Y"-全退
    s retallflag=$p(^DHCPL(pl),"^",20)
    q
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Description:根据医嘱项orditm获得发药数量
/// Input:接收科室Rowid,进程号,库存项Rowid,医嘱项orditmRowid,
/// Return:发药数量
/// Others:
ClassMethod getRetOrdItemQty(recloc, pid, inci, orditm, dhcoedis) As %String
{
	n (recloc,pid,inci,orditm,dhcoedis)
	q:recloc="" 0
	q:pid="" 0
	q:inci="" 0
	q:orditm="" 0
	q:dhcoedis="" 0
	q:##class(web.DHCSTCOMMONSRV).ReserveRetFlag(recloc)'="Y" 0
	q:##class(web.DHCSTCOMMONSRV).GetCatReserve(inci)'>0 0
	;
    s confqty=0
    s ord=+orditm
    s itm=$p(orditm,"||",2)
	l +^DHCOEDISPENSING(orditm):5  e  q 0   
    s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1) 
    i ordstatus="D"  l -^DHCOEDISPENSING(orditm)  q 0 
    i (ordstatus'="V")&(ordstatus'="E") l -^DHCOEDISPENSING(orditm)  q 0    
    i dhcoedis=""  l -^DHCOEDISPENSING(orditm)  q 0
    i ##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(orditm) l -^DHCOEDISPENSING(orditm)  q 0
    s adm=$p(^OEORD(ord),"^",1)
    s date=$p(^OEORD(ord),"^",2)
    ;s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrears(adm,recloc,date,ord)
    ;i AmtRet="N" l -^DHCOEDISPENSING(orditm) q 0
    ;i $d(^TMP("dhcpha",pid,"D","Filter",orditm)) l -^DHCOEDISPENSING(orditm) q 0
    s dodiss=..ReGetDodis(dhcoedis,ord,itm)
    i dodiss="" l -^DHCOEDISPENSING(orditm) q 0
    s confqty=..CalDspQty(dodiss)
    i confqty=0 l -^DHCOEDISPENSING(orditm) q 0
    s ch=$o(^INCI("IL_LOC",recloc,inci,"")) 
    i ch=""  l -^DHCOEDISPENSING(orditm) q 0
    s incil=inci_"||"_ch
    i ##class(web.DHCSTSTKQTY).GetPhaQty(incil,confqty)=0  l -^DHCOEDISPENSING(orditm) q 0
	l -^DHCOEDISPENSING(orditm)
	q +$g(confqty)
}

ClassMethod GetArcEndFlag(orditem) As %String
{
	n (orditem)
	s ret=0
   	s arcenddate=##class(web.DHCSTCOMMONSRV).GetarcEndDate(orditem) ;截止日期到期的医嘱项 
    s mainord=..GetMainOrdRowid(orditem)
    i (arcenddate'="")&&(arcenddate'>+$h) d
    .s ret=-1_"^"_arcenddate
    q ret
}

ClassMethod DispStatItmSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatItmSumExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query DispStatItmSum(ProcessID As %String) As %Query(ROWSPEC = "DispItmDesc:%String,DispQty:%String,RetQty:%String,Total:%String,Uom:%String,Amount:%String,PID:%String,DispItmCode:%String,AdmLocID:%String,TPhcfDesc:%String,TManf:%String,TBarCode:%String,TPhciPrice:%String,Tgeneric:%String,TTotalUom:%String,Tward:%String")
{
}

ClassMethod DispStatItmSumExecute(ByRef qHandle As %Binary, ProcessID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	i ProcessID=""  Set qHandle=$lb(0,repid,0) q $$$OK
	s inci=""
    f  s inci=$o(^TMP("dhcpha",processid,"locsum",inci)) q:inci=""  d
    .s inciname=$p(^INCI(inci,1),"^",2)
    .s incicode=$p(^INCI(inci,1),"^",1)
	.s rInciOriginalArcimDr=$p(^INCI(inci,1),"^",3) ;通过库存项的RowId取指向医嘱项的字段
	.s rArcimRowId=rInciOriginalArcimDr ;指向医嘱项的内容=医嘱项的RowId
	.s rSubscript=$p(rArcimRowId,"||",1) ;医嘱项RowId的前半部分
	.s rVersion=$p(rArcimRowId,"||",2) ;医嘱项RowId的后半部分
	.s rArcimPhcdfDr=$p(^ARCIM(rSubscript,rVersion,1),"^",12) ; 指向PHC_DrgForm
	.s rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
	.s rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
	.q:(rPhcDrgForm1="")&(rPhcDrgForm2="") 
	.q:'$d(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2))
	.s rPhcdfPhcfDr=$p(^PHCD(rPhcDrgForm1,"DF",rPhcDrgForm2,1),"^",1) ;指向PHC_Form
	.s rPhcfDesc=$p(^PHCF(rPhcdfPhcfDr),"^",2) ; 取剂型
	.;s rmanf=##class(web.DHCSTKUTIL).GetManfNameByInci(inci) ;产地
	.s rmanf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3) //厂家
	.s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci) //2007-10-13
	.s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) ;规格
	.s phciprice=$p(^TMP("dhcpha",processid,"locsum",inci),"&",9)
	.i phciprice="" s phciprice=$p(^TMP("dhcpha",processid,"locsum",inci),"&",5)
	.s uomname=$p(^CT("UOM",$p(^TMP("dhcpha",processid,"locsum",inci),"&",4)),"^",2)
	.s dispqty=$p(^TMP("dhcpha",processid,"locsum",inci),"&",1)
	.i dispqty="" s dispqty=0
	.s retqty=$p(^TMP("dhcpha",processid,"locsum",inci),"&",2) 
	.s subsum=+dispqty-(+retqty)
	.s amt=$p(^TMP("dhcpha",processid,"locsum",inci),"&",3)
	.s distotal1=distotal1+amt
	.s retotal=$p(^TMP("dhcpha",processid,"locsum",inci),"&",7)
	.s retotal1=retotal1+retotal
	.s num=num+1
	.s subsumUom=##Class(web.DHCSTCOMINC).GetQtyIncUom(inci,subsum)
	.s dispitm=inciname_"&"_$g(dispqty)_"&"_$g(retqty)_"&"_$g(subsum)_"&"_$g(uomname)_"&"_$g(amt)_"&"_$g(incicode)_"&"_rPhcfDesc_"&"_rmanf_"&"_Specifaction_"&"_phciprice_"&"_generic_"&"_subsumUom_"&"_"总计" //lq add 2007-10-13
	.s subtotal=subtotal+$p(^TMP("dhcpha",processid,"locsum",inci),"&",3)
	.d OutputDispStatItmSum
	;
	s retotal1=-retotal1
	s num=num+1
    s subtotal=distotal1-retotal1
    s dispitm="总计:"_"&"_$fn(subtotal,"",2)_"&"_-$fn(retotal1,"",2)_"&&&"_distotal1
    d OutputDispStatItmSum  
	;
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDispStatItmSum
	s DispItmDesc=$p(dispitm,"&",1)	
	s DispQty=$p(dispitm,"&",2)	
	s RetQty=$p(dispitm,"&",3)	
	s Total=$p(dispitm,"&",4)
	s Uom=$p(dispitm,"&",5)	
	s Amount=$p(dispitm,"&",6)	
	s DispItmCode=$p(dispitm,"&",7) 
	;---------------add by lq----- 
	s rPhcfDesc=$p(dispitm,"&",8)
	s rmanf=$p(dispitm,"&",9)
	s Specifaction=$p(dispitm,"&",10)
	s phciprice=$p(dispitm,"&",11)
	s generic=$p(dispitm,"&",12) //2007-10-13
	i $f(generic,"-") s generic=$p(generic,"-",2)
	S TotalUom=$P(dispitm,"&",13) //X盒X片 090402 zyg
	s ward=$p(dispitm,"&",14)
	i $f(ward,"-") s ward=$p(ward,"-",2)
	s PID=ProcessID
	;	
	s Data=$lb(DispItmDesc,DispQty,-RetQty,Total,Uom,$fn(Amount,"",2),PID,DispItmCode,AdmLocRowid,rPhcfDesc,rmanf,Specifaction,$fn(phciprice,"",4),generic,TotalUom,ward) //lq add
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod DispStatItmSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatItmSumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:准备欠费数据(按adm号)
/// Creator:Liang Qiang 
/// CreatDate:2009-09-29
/// Input:pid - 进程号
/// Ouput:0
/// 发药计费需判断欠费,下医嘱计费不判断
ClassMethod AuditAdmBill(pid, loc, loclog) As %String
{
	n (pid,loc,loclog)
	s amtRet=""
	s adm=""
	f  s adm=$o(^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid,adm)) q:adm=""  d
	.s str=^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid,adm)
	.s amtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew(pid,adm,str,loclog)
	.i amtRet="N" d
	..s ^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",pid,adm)=""
	q 0
}

/// Description:取发药批号
/// Creator:zdm
/// CreatDate:2012-03-05
/// Input:发药子表id
/// Ouput:0
ClassMethod GetDspBatno(phaci) As %String
{
	n (phaci)
	q:phaci="" ""
	s pha=+phaci
	s chl=$p(phaci,"||",2)
	q:chl="" ""
	s strbatno=""
	s sub=""
	f  s sub=$o(^DHCPHAC(pha,"I",chl,"B",sub)) q:sub=""  d
	.s inclb=$p(^DHCPHAC(pha,"I",chl,"B",sub),"^",1)
	.s inci=+inclb
	.s il=$p(inclb,"||",2)
	.s lb=$p(inclb,"||",3)
	.s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	.s batno=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)
	.i strbatno=""  d
	..s strbatno=batno
	.e  d
	..s strbatno=strbatno_","_batno
	.
	q strbatno
}

ClassMethod GetInclbCounter(recloc, inci) As %String
{
	 l +^DHCINCIL(recloc,inci):10  e  q -1   ;加锁
     //s pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter() //yunhaibao20170810,pid与门诊发药统一
     s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
     q pid
}

/// Description:欠费控制(按adm号)
/// Creator:CaoTing
ClassMethod RetBillControl(pid, adm) As %String
{
	n (pid,adm)
	//zhouyg 20141218 修改临时Global规范
	s str=$g(^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid,adm))
	s AmtRet=..CheckArrearsNew(pid,adm,str)
	q AmtRet
}

ClassMethod CheckArrearsNew(pid As %String, adm As %String, str As %String) As %String
{
	n (pid,adm,str)
	s rtn=""
    ;s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsNew(pid,adm, str,"")
    ;s ^tmplqxxx("CheckArrears",1)=adm_"^"_str_"^"_rtn
    s p5=$p(rtn,"^",5) ;控制等级类型 W/C (预警/控制) 
    s p9=$p(rtn,"^",9) ;是否允许发药 Y/N(允许/不允许)
    ;s ^tmplqxxx("CheckArrears",2)=adm_"^"_p5_"^"_p9
    i p5="C" q p9
    q "Y"
}

/// Creator:zhouyg
/// CreatDate:2012-08-08
/// Description:如果使用冲抵功能,必须发药后执行退药
/// Input:进程号,发药主表ID串("^"连接),操作人
/// Return:完成提示
ClassMethod ExeRetAfterDisp(pid, phacStr, DspUserID, dsyflag = "") As %String
{
	n (pid,phacStr,DspUserID,dsyflag,%session)
	q:phacStr="" ""
	k ^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid)
	s flag="Execute"
	s retno=""
	s phac=$p(phacStr,"A",1)
	q:phac="" ""
	q:'$d(^DHCPHAC(phac)) ""
	s recloc=$p(^DHCPHAC(phac),"^",1)
	q:recloc="" ""
    s RetConfigStr=..getLocRetConfig(recloc)
    s ResRetFlag=$p(RetConfigStr,"^",1)
    q:ResRetFlag'="Y" ""
    s retallflag=$p(RetConfigStr,"^",2)
    s rstdate=$p(RetConfigStr,"^",3)
    s renddate=$p(RetConfigStr,"^",4)
	s wardid=$p(^DHCPHAC(phac),"^",4)
	q:wardid="" ""  ;特殊科室不进行发药保留
	///计算发药总数
	i dsyflag="" d CPhacIncQty
	i dsyflag=1  d CPhacIncQtyDsy   //大输液冲减
	s errCode=""
	s wardid=""
	f  s wardid=$o(^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid)) q:wardid=""  d
	.s wardlocid=$p(^PAWARD(wardid),"^",5)
	.q:wardlocid=""
	.s reqiIDStr=""
	.s inci=""
	.f  s inci=$o(^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci)) q:inci=""  d 
    ..s dispqty=+^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci)
    ..q:dispqty=0
	..s ret=0,TReqQty=0
	..s reqid=""
	..f  s reqid=$o(^RETRQ(0,"RECSTDEPT",recloc,"Prove",wardlocid,reqid)) q:(reqid="")  d
	...s requestdate=$p(^RETRQ(reqid),"^",16)
	...q:($g(rstdate)'="")&(requestdate<rstdate)
	...q:($g(renddate)'="")&(requestdate>renddate)
	...s reqSub="0"
	...f  s reqSub=$o(^RETRQ(0,"INCI",inci,reqid,reqSub)) q:(reqSub="")  d
	....s RQIStatus=$p(^RETRQ(reqid,"I",reqSub),"^",10)
	....q:RQIStatus=flag
	....s reqiID=reqid_"||"_reqSub
	....
	....///结算不检查 否则影响其他退药
	....s refundstatus=$p(^RETRQ(reqid,"I",reqSub),"^",12)
	....s oeori=$p(^RETRQ(reqid,"I",reqSub),"^",1)
	....s dodis=$p(^RETRQ(reqid,"I",reqSub),"^",11)
	....s oeore=$p(^DHCOEDISQTY(dodis),"^",3) 
	....s admid=$p(^OEORD(+oeori),"^",1)
	....//s ret=##class(web.DHCSTPHARETURN).GetPayflag(oeori,admid)   //20160310 标准版开发
	....q:##Class(web.DHCSTKUTIL).IfRetForPaidNew(oeore)=0
 	....s ret=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admid)	//20160310 标准版开发
 	....Q:(ret=0)&(refundstatus'=1)
	....
	....s reqqty=##class(web.DHCSTPHARETURN).GetReqItmSurplus(reqiID)
	....q:($g(retallflag)'="Y")&(reqqty>dispqty) //全退
	....s ret=0
	....s TReqQty=TReqQty+reqqty
	....i (retallflag'="Y")&(TReqQty>dispqty) d
	.....s TReqQty=TReqQty-reqqty	//为了执行下次循环,尽可能可以退的就退掉
	.....s ret=1
	....q:ret=1
	....i reqiIDStr="" d
	.....s reqiIDStr=reqiID_"^"_reqqty
	....e  d
	.....s reqiIDStr=reqiIDStr_","_reqiID_"^"_reqqty
	.///对可以冲抵的申请明细执行退药
	.s ExeRet=""
	.i reqiIDStr'="" d
	..s ExeRet=##Class(web.DHCSTPHARETURN).ExecReturnByReq("","",recloc,DspUserID,"AUTORT",reqiIDStr,"1")
	..i ExeRet["fail" s errCode=ExeRet
	///冲抵操作,更新发药表、退药表、保留表
	s wardid=""
	f  s wardid=$o(^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid)) q:wardid=""  d
	.s wardlocid=$p(^PAWARD(wardid),"^",5)
	.q:wardlocid=""
	.s inci=""
	.f  s inci=$o(^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci)) q:inci=""  d 
	..s phaci=0
    ..f  s phaci=$o(^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci,phaci)) q:phaci=""  d
    ...s ret=..HandlePhaResQty(phaci)
	k ^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid)
	q errCode
CPhacIncQty
	s phacnum=$l(phacStr,"A")
	q:phacnum=0
	f i=1:1:phacnum d
	.s phac=$p(phacStr,"A",i)
	.q:phac=""
	.s wardid=$p(^DHCPHAC(phac),"^",4)
	.q:wardid=""
    .s inclb=""
    .f  s inclb=$o(^DHCPHAC(0,"PHACI",phac,"I",inclb)) q:inclb=""  d
    ..s inci=$p(inclb,"||",1)
    ..s ordtype=$p(^DHCPHAC(phac),"^",12)
   	..s ordtypeinfo=##class(web.DHCSTCOMMONSRV).getReservedCat()
    ..q:ordtypeinfo'[ordtype
    ..s phacisub="0"
    ..f  s phacisub=$o(^DHCPHAC(0,"PHACI",phac,"I",inclb,phacisub)) q:phacisub=""  d
    ...s ordqty=$p(^DHCPHAC(phac,"I",phacisub),"^",6)
    ...s phaci=phac_"||"_phacisub
    ...s ^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci)=ordqty+$g(^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci))
    ...s ^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci,phaci)=ordqty
    q
    
CPhacIncQtyDsy
    s phac=""
    f  s phac=$o(^TMP("dhcpha","DHCSTPCHCOLLPRN","SAVEDATA",pid,phac)) q:phac=""  d
    .s wardid=$p(^DHCPHAC(phac),"^",4)
	.q:wardid=""
    .s inci=""
    .f  s inci=$o(^TMP("dhcpha","DHCSTPCHCOLLPRN","SAVEDATA",pid,phac,inci))  q:inci=""  d
    ..q:##class(web.DHCSTCOMMONSRV).GetCatReserve(inci)'>0
    ..s phaci=""
    ..f  s phaci=$o(^TMP("dhcpha","DHCSTPCHCOLLPRN","SAVEDATA",pid,phac,inci,phaci))  q:phaci=""  d
    ...s sub=$p(phaci,"||",2)
    ...s ordqty=$p(^DHCPHAC(phac,"I",sub),"^",6)
    ...s ^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci)=ordqty+$g(^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci))
    ...s ^TMP("DHCST",$ClassName(),"ExeRetAfterDisp","PhaciInci",pid,wardid,inci,phaci)=ordqty
    k ^TMP("dhcpha","DHCSTPCHCOLLPRN","SAVEDATA",pid)
    q
}

/// Descript:	取冲抵属性
/// Creater:		zhouyg
/// CreateDate:	2012-08-08
/// Input:		reclocID-药房ctloc_RowID
/// Return:		是否冲抵^是否全退^检查的申请单开始日期^检查的申请单截止日期
ClassMethod getLocRetConfig(reclocID) As %String
{
    n (reclocID)
    q:reclocID="" ""
    s pl=$o(^DHCPL(0,"Loc",reclocID,""))
    q:pl="" ""
    s rstdate=$p(^DHCPL(pl),"^",18)
    s renddate=$p(^DHCPL(pl),"^",19)
    s rstdate=##Class(web.DHCSTKUTIL).GetDah(rstdate)
    s renddate=##Class(web.DHCSTKUTIL).GetDah(renddate)
    ;取"部分退","全退"配置="Y"
    s retallflag=$p(^DHCPL(pl),"^",20)
    //是否冲抵,是="Y"
    s ResRetFlag=$p(^DHCPL(pl),"^",16)
    s RetStr=ResRetFlag_"^"_retallflag_"^"_rstdate_"^"_renddate
    q RetStr
}

/// 界面加载颜色标识
ClassMethod GetColorType(InciQty, ArcEndDateFlag) As %String
{
	n (InciQty,ArcEndDateFlag)
	s coltype=""
	i InciQty=0 s coltype="G"
	i ArcEndDateFlag=1 s coltype="B"
	q coltype
}

ClassMethod SaveCatListByWard(wardid, catlist, pid) As %String
{
	n (wardid,catlist,pid)
	//i '$d(^TMP("dhcpha",pid,"CATINWARD",wardid)) d
	q:+pid=0 0
	q:+wardid=0 0
	s ^TMP("dhcpha",pid,"CATINWARD",wardid)=catlist
	q 0
}

/// Description:按医嘱分发时间过滤
/// Creator:Liang Qiang 
/// CreatDate:2010-10-20
/// Input:dsprowid串,开始时间,结束时间
/// Ouput:dsprowid串
ClassMethod FilterOrdDspTime(dspstring, orddate, datefrom, dateto, timefrom, timeto) As %String
{
	n (dspstring,orddate,datefrom,dateto,timefrom,timeto)
	//s ^testlq(1,dspstring,orddate,datefrom,dateto)=timefrom_","_timeto
	s cnt=$l(dspstring,"^")
	s DodisString=""
	f i=1:1:cnt d
	.s dsp=$p(dspstring,"^",i)
	.s dsptime=$p(^DHCOEDISQTY(dsp),"^",20)
	.q:(orddate=datefrom)&(timefrom'="")&(dsptime<timefrom)
	.q:(orddate=dateto)&(timeto'="")&(dsptime'<timeto)
	.//i dspstring="6917^6918^6919" s ^testlq(2,dspstring,orddate,datefrom,dateto,dsptime)=timefrom_","_timeto
	.i DodisString="" d
	..s DodisString=dsp
	.e  d
	..s DodisString=DodisString_"^"_dsp
	;s ^testlq(2,dspstring,orddate,datefrom,dateto)=timefrom_","_timeto
	q DodisString
}

ClassMethod KillTmp(catpid) As %String
{
	n (catpid)
	k ^TMP("dhcpha",catpid,"CATINWARD")
	q 0
}

ClassMethod GetWardDispType(catpid, WardId)
{
	n (catpid,WardId)
	s disptypestr=$g(^TMP("dhcpha",catpid,"CATINWARD",WardId))
	q disptypestr
}

/// Descript:	检查关联医嘱有任何一个不够发都不能发,只判断本药房的，如果关联医嘱不在本药房不进行判断
/// Creater:	zhouyg
/// CreateDate:	2015-12-17
/// Input:		DspIdStr(DHC_OEDispensing的RowID字符串,dspID1_","_dspID2)
/// ;1,够发，0：不可发
ClassMethod CheckAllowFlag(DspIdStr, pid) As %String
{
	n (DspIdStr, pid)
	s QtyFlag=1
	s RetFlag=1
	s DspId1=$p(DspIdStr,",",1)
	q:DspId1="" 0
 	s lenDspId=$l(DspIdStr,",")	//发几次的药
 	s DateDosing=$p($g(^DHCOEDISQTY(DspId1)),"^",21)
 	q:DateDosing="" 0
 	s reclocID=+$p(^DHCOEDISQTY(DspId1),"^",24)
 	//1 判断主医嘱
 	s oeordItmID=$p(^DHCOEDISQTY(DspId1),"^",1)
	q:oeordItmID="" 0
 	s oeordID=$p(oeordItmID,"||",1)
	s oeordItmSub=$p(oeordItmID,"||",2)
	q:(oeordID="")!(oeordItmSub="") 0
	q:'$d(^OEORD(oeordID,"I",oeordItmSub)) 0
 	s moeoei=$p($g(^OEORD(oeordID,"I",oeordItmSub,11)),"^",39) 
 	s mDspId=""
 	i moeoei="" d
 	.s moeoei=oeordItmID
 	.s mDspId=DspId1	// bug修改 mDspId取错 20160922 zhouyg
 	.s ord=+moeoei
	.s chl=$p(moeoei,"||",2)
	.s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1)
 	e  d
 	.s ord=+moeoei
	.s chl=$p(moeoei,"||",2)
	.s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1)
	.q:priority["OM"
 	.s seqno=""
 	.f  s seqno=$o(^DHCOEDISQTY(0,"SEQNO",moeoei,DateDosing,seqno)) q:(seqno="")!(mDspId'="")  d
 	..s DspId=""
 	..f  s DspId=$o(^DHCOEDISQTY(0,"SEQNO",moeoei,DateDosing,seqno,DspId)) q:(DspId="")!(mDspId'="")  d
 	...s mreclocID=+$p(^DHCOEDISQTY(DspId),"^",24)
 	...q:mreclocID'=reclocID	//仅判断本药房的医嘱
 	...s mDspId=DspId
 	i (mDspId'="")&(priority'["OM") d
 	.q:$p(^DHCOEDISQTY(mDspId),"^",7)="C"
 	.s inciID=##Class(web.DHCSTCOMINC).GetInciByOrditm(moeoei)
 	.i inciID="" s QtyFlag=0
 	.q:inciID=""
 	.s IncilSub=$o(^INCI("IL_LOC",reclocID,inciID,""))
 	.i IncilSub="" s QtyFlag=0
 	.q:IncilSub=""
 	.s Incil=inciID_"||"_IncilSub
 	.s DspQty=+$p(^DHCOEDISQTY(mDspId),"^",11)
 	.s tDspQty=DspQty*lenDspId	//发药总数量 	
 	.s QtyFlag=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,tDspQty)
 	i QtyFlag=0 d ..SetCantDispInfo(pid,moeoei,"库存不足")
 	q:QtyFlag=0 0
 	//2 判断关联医嘱是否够发
 	s oeordItmSub=""
	f  s oeordItmSub=$o(^OEORDi(0,"OEORI",oeordID,moeoei,oeordItmSub)) q:(oeordItmSub="")!(QtyFlag=0)  d
	.s oeordItmID=oeordID_"||"_oeordItmSub
	.s arcimid=$P($g(^OEORD(oeordID,"I",oeordItmSub,1)),"^",2)
	.q:arcimid="" 
	.s arcimm=$p(arcimid,"||",1)
	.q:arcimm="" 
	.s arcimsub=$p(arcimid,"||",2)
	.q:arcimsub="" 
	.s arcitemcat=$p($g(^ARCIM(arcimm,arcimsub,1)),"^",10)
	.q:arcitemcat="" 
	.s arcitmtype=$p($g(^ARC("IC",arcitemcat)),"^",7)
	.q:arcitmtype'="R" ; 过滤非药品医嘱
	.s priority=$p(^OECPR($p(^OEORD(oeordID,"I",oeordItmSub,1),"^",8)),"^",1)
	.q:priority["OM"
	.s seqno=""
	.f  s seqno=$o(^DHCOEDISQTY(0,"SEQNO",oeordItmID,DateDosing,seqno)) q:(seqno="")!(QtyFlag=0)  d
 	..s DspId=""
 	..f  s DspId=$o(^DHCOEDISQTY(0,"SEQNO",oeordItmID,DateDosing,seqno,DspId)) q:(DspId="")!(QtyFlag=0)  d
 	...s dreclocID=+$p(^DHCOEDISQTY(DspId),"^",24)
 	...q:dreclocID'=reclocID	//仅判断本药房的医嘱
 	...q:$p(^DHCOEDISQTY(DspId),"^",7)="C"
 	...s inciID=##Class(web.DHCSTCOMINC).GetInciByOrditm(oeordItmID)
 	...i inciID="" s QtyFlag=0
 	...q:inciID=""
 	...s IncilSub=$o(^INCI("IL_LOC",reclocID,inciID,""))
 	...i IncilSub="" s QtyFlag=0
 	...q:IncilSub=""
 	...s Incil=inciID_"||"_IncilSub
 	...s DspQty=+$p(^DHCOEDISQTY(DspId),"^",11)
 	...s tDspQty=DspQty*lenDspId	//发药总数量 	
 	...s QtyFlag=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,tDspQty)
 	...i QtyFlag=0 d
 	....//s RetFlag=0
 	....s ^TMP("dhcpha",pid,"Disp","tip",inciID)=""
 	....i QtyFlag=0 d ..SetCantDispInfo(pid,oeordItmID,"库存不足")
 	q QtyFlag
}

/// Descript:	取库存不足药品列表
/// CreateDate： 2015-12-17
/// Creater：	zhouyg
/// Input：		进程号
/// Return：		药品名称
/// w ##class(web.DHCSTPCHCOLLS).GetTipsOfNoStock(953949)
ClassMethod GetTipsOfNoStock(pid)
{
	s m=0
	s incidesc2=""
	s inci=""
	f  s inci=$o(^TMP("dhcpha",pid,"Disp","tip",inci)) q:(inci="")||(m>0)  d
	.i incidesc2="" d
	..s incidesc2=$p(^INCI(inci,1),"^",2) 
	.e  d
	..s incidesc2=incidesc2_","_$p(^INCI(inci,1),"^",2) 
	.s m=m+1
	q incidesc2
}

ClassMethod InsertDrugRefuse(StrDodis As %String, user As %String, refreason As %String)
{
	n (StrDodis,user,refreason)
	s len=$l(StrDodis,"^")
	f i=1:1:len d
	.s ret=##class(web.DHCSTPCHCOLLS2).InsertDrugRefuse("","",$p(StrDodis,"^",i),user,refreason)
	q 0
}

/// creator:     yunhaibao
/// createdate:  2017-01-22
/// description: 获取打包表下对应的批号
/// w ##class(web.DHCSTPCHCOLLS).GetBatInfoByDsp(33126)
ClassMethod GetBatInfoByDsp(dspid As %String) As %String
{
	n (dspid)
	s retstring=""
	s dspsubid=""
	f  s dspsubid=$o(^DHCOEDISQTY(dspid,"I",dspsubid)) q:dspsubid=""  d
	.s dspinclb=$p(^DHCOEDISQTY(dspid,"I",dspsubid),"^",1)
	.s dspinc=+dspinclb
	.s dspincch=$p(dspinclb,"||",2)
	.s dspincchlb=$p(dspinclb,"||",3)
	.q:dspincchlb=""
	.s incibdr=$p(^INCI(dspinc,"IL",dspincch,"LB",dspincchlb),"^",1)
	.s dspbatno=$p($g(^INCI(+incibdr,"IB",+$p(incibdr,"||",2))),"^",1)
	.q:dspbatno=""
	.s retstring=$s(retstring="":dspbatno,1:retstring_","_dspbatno)
	q retstring
}

/// creator:     yunhaibao
/// createdate:  2017-01-22
/// description: 判断字符是否存在于已知的字符串中,将不存在的返回新字符串
/// w ##class(web.DHCSTPCHCOLLS).CheckExistString("1,2,3,4","5,6,7",",")
ClassMethod CheckExistString(ExistStr As %String, ChkStr As %String, Split As %String) As %String
{
	N (ChkStr,ExistStr,Split)
	s retString=""
	s i=0
	s len=$l(ExistStr,Split)
	f i=1:1:len d  ; 先存于数组
	.s tmpExistStr=$p(ExistStr,Split,i)
	.q:tmpExistStr=""
	.s CheckExistString(tmpExistStr)=""
	q:'$d(CheckExistString) ""
	s i=0
	s len=$l(ChkStr,Split)
	f i=1:1:len d  
	.s tmpChkStr=$p(ChkStr,Split,i)
	.q:tmpChkStr=""
	.q:$d(CheckExistString(tmpChkStr))
	.s retString=$s(retString="":tmpChkStr,1:retString_","_tmpChkStr)
	q retString
}

/// 清除用于打印库存不足的临时global
ClassMethod KillNoStockTMP(pid)
{
	k ^TMP("dhcpha","NOSTOCK",pid)
	k ^TMP("dhcpha","NOSTOCK","WARDPAT",pid)
	q 0
}

/// description: 取开单医生科室Id
ClassMethod UserDept(oeori As %String) As %String
{
	n (oeori)
	s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
	q:ord="" ""
	q:chl="" ""
	s userdept=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
	q userdept
}

/// description: 记录发药可能的错误信息,发不出去的为少数
/// dispItmInfo:^1(登记号),^2(药品),^3(发不出原因)
/// w ##class(web.DHCSTPCHCOLLS).SetCantDispInfo("YHB201807051151","280||192","库存不足")
ClassMethod SetCantDispInfo(pid, oeori, errInfo = "")
{
	s ^TMP("DHCST","web.DHCSTPCHCOLLS","SetCantDispInfo",pid,oeori)=errInfo
	q 0
}

/// description: 显示发药产生的错误信息,仅当未发出药品时给与提示
/// w ##class(web.DHCSTPCHCOLLS).GetCantDispInfo("YHB201807051151")
ClassMethod GetCantDispInfo(pid, show)
{
	i show=0 k ^TMP("DHCST","web.DHCSTPCHCOLLS","SetCantDispInfo",pid) q ""
	q:pid="" ""
	q:'$d(^TMP("DHCST","web.DHCSTPCHCOLLS","SetCantDispInfo",pid)) ""
	s oeori=""
	f  s oeori=$o(^TMP("DHCST","web.DHCSTPCHCOLLS","SetCantDispInfo",pid,oeori)) q:oeori=""  d
	.s errInfo=^TMP("DHCST","web.DHCSTPCHCOLLS","SetCantDispInfo",pid,oeori)
	.q:errInfo=""
	.s ordId=+oeori
	.s ordItm=$p(oeori,"||",2)
	.s admId=$p(^OEORD(ordId),"^",1)
	.s patId=$p(^PAADM(admId),"^",1)
	.s patName=$p(^PAPER(patId,"ALL"),"^",1) 
	.s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
	.s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2) 
	.s arcItmDesc=$p($g(^ARCIM(+$p(arcItmId,"||",1),+$p(arcItmId,"||",2),1)),"^",2)
	.s sortIndex=patNo_"^"_patName
	.s GetCantDispInfoData(sortIndex,arcItmDesc)=arcItmDesc_"^"_errInfo
	q:'$d(GetCantDispInfoData)
	k ^TMP("DHCST","web.DHCSTPCHCOLLS","SetCantDispInfo",pid)
	s retHtml=""
	s sortIndex=""
	f  s sortIndex=$o(GetCantDispInfoData(sortIndex)) q:sortIndex=""  d
	.s patNo=$p(sortIndex,"^",1)
	.s patName=$p(sortIndex,"^",2)
	.s patHtml="<div style=font-weight:bold>"_patNo_"　"_patName_"</div>"
	.s retHtml=retHtml_patHtml
	.s itmsHtml=""
	.s arcItmDesc=""
	.f  s arcItmDesc=$o(GetCantDispInfoData(sortIndex,arcItmDesc)) q:arcItmDesc=""  d
	..s errData=GetCantDispInfoData(sortIndex,arcItmDesc)
	..s errInfo=$p(errData,"^",2)
	..s itmHtml="<div>"_arcItmDesc_" : "_errInfo_"</div>"
	..s retHtml=retHtml_itmHtml
	s retHtml="<div>"_retHtml_"</div>"
	q retHtml
}

}
