Import Sqluser

/// 批次价接口的实现类
Class web.DHCSTMHUI.SRVINTERFACE Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript： 	取库存数量、在途数
/// CreateDate：2015-01-19
/// Input：		Incil-科室库存项ID
/// Return：	当前库存数^可用库存数^医嘱占用数^库存业务占用数
/// w ##class(web.DHCSTMHUI.SRVINTERFACE).GetIncilQtyList("1399||2")
ClassMethod GetIncilQtyList(incil, IfCheckExpDate) As %String
{
	n (incil,IfCheckExpDate)
	s inci=$p(incil,"||",1)
	s ilSub=$p(incil,"||",2)
	q:(inci="")&(ilSub="") ""
	s locID=$p($g(^INCI(inci,"IL",ilSub)),"^",1)
	q:locID="" ""
	s HospID=$p($g(^CTLOC(locID)),"^",22)
	q:HospID="" ""
	s RuleFlag=..sssBatSpFlag(HospID,inci)
	s lbSub=0,CurQty=0,oeResQty=0,trResQty=0,AvailQty=0
	i RuleFlag'=1 d
	.s oeResQty=$p(^INCI(inci,"IL",ilSub),"^",10)
	f  s lbSub=$o(^INCI(inci,"IL",ilSub,"LB",lbSub)) q:lbSub=""  d
	.q:'$d(^INCI(inci,"IL",ilSub,"LB",lbSub))
    .s incib=$P(^INCI(inci,"IL",ilSub,"LB",lbSub),"^",1)
    .s cib=$p(incib,"||",2)
    .q:cib=""
	.s expdate=+$p(^INCI(inci,"IB",cib),"^",2)
	.q:(IfCheckExpDate="Y")&&(expdate'=0)&&(expdate<+$h) //过滤效期 
	.s inclb=incil_"||"_lbSub
	.q:'$d(^DHCINCLB(0,"LB",inclb))	
	.s sCurQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,+$h)	//实库存数
	.s strResQty=+$p(^INCI(inci,"IL",ilSub,"LB",lbSub),"^",3)	//库存业务占用数
	.s soeResQty=0
	.i RuleFlag=1 d
	..s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
	..i dhcinclb'="" d
	...s soeResQty=+$p(^DHCINCLB(dhcinclb),"^",3)	//批次医嘱占用数
	.
	.s CurQty=CurQty+sCurQty
	.s oeResQty=oeResQty+soeResQty
	.s trResQty=trResQty+strResQty
	s AvailQty=CurQty-oeResQty-trResQty
	
	s InciCode=$p(^INCI(inci,1),"^",1)
	s InciDesc=$p(^INCI(inci,1),"^",2)
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	s ArcimId=$p(^INCI(inci,1),"^",3)
	s BUomId=$p(^INCI(inci,1),"^",10)
	q:BUomId="" ""
	s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	s BillUomInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuom(ArcimId)
	s BillUomId=$p(BillUomInfo,"^",1)
	s BillUomDesc=$p(BillUomInfo,"^",2)	
	s RetStr=inci_"^"_InciCode_"^"_InciDesc_"^"_Spec_"^"_BUomId
		_"^"_BUomDesc_"^"_BillUomId_"^"_BillUomDesc_"^"_CurQty_"^"_AvailQty
		_"^"_oeResQty_"^"_trResQty
	q RetStr
}

/// Descript：	开医嘱或发药取可用库存的批次
/// Creater：	zhouyg
/// CreateDate：2013-08-12
/// Input：		Incil-科室库存项ID,ReqQty-需要数量,pid-进程ID,ReseFlag-是否考虑在途数(1-发放使用只考虑出库占用,2-开医嘱使用考虑医嘱占用数和出库占用数)RollFlag 1 滚医嘱
/// Output：	^TMP("DHCST","web.DHCST01","Inclb",pid,Inclb),输出结果必须是相同售价的批次
/// Return：	0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
ClassMethod GetInclbQty(Incil As %Library.String, ReqQty As %Library.String, pid As %String, ReseFlag As %String = "", barcode As %String = "", RollFlag As %String = "")
{
	n (Incil,ReqQty,pid,ReseFlag,barcode,RollFlag)
	q:Incil="" 0
	q:+ReqQty=0 0
	s Inci=$p(Incil,"||",1),IL=$p(Incil,"||",2)
	q:(Inci="")||(IL="") 0
	s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	q:LocId="" 0
	s HospID=$p($g(^CTLOC(LocId)),"^",22)
	k ^TMPDHCSTM("Inclb",pid)
	k ^TMPDHCSTM("EXSP",pid)
	k ^TMPDHCSTM("MANF",pid)
	
	i barcode'="" d 
	.s stkflag=0
	.;医嘱rowid^status^Inclb^stkQty(逻辑库存)^avaQty(可用库存)^LocId(当前科室)^locDesc(当前科室描述)
	.s retstr=##Class(web.DHCSTMHUI.PCHCOLLSM).GetArcimByLabel(barcode,LocId)
	.s Inclb=$p(retstr,"^",3)
	.s avaQty=$p(retstr,"^",5)
	.i avaQty>0 s stkflag=1
	.s sp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurSp(Inclb,"",HospID)
	.s rp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurRp(Inclb,"",HospID)
	.s ^TMPDHCSTM("Inclb",pid,1)=1_"^"_sp_"^"_rp_"^"_Inclb
	q:barcode'="" stkflag
	
	;取所有库存大于0的批次
	;SelBatFlag: 1-效期优先; 0-先进先出;
	s SelBatFlag=##class(web.DHCSTMHUI.SRVCOMMON).GetSelBatRule(HospID)
	
	s CheckExpFlag="Y"
	i $d(^DHCSTM("CheckExp")) d
	.s CheckExpFlag=^DHCSTM("CheckExp")
	
	s LB="0"
	f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB)) q:(LB="")  d
	.s Inclb=Inci_"||"_IL_"||"_LB
	.s incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	.q:incib=""
	.s IB=$p(incib,"||",2)
	.q:IB=""
	.q:'$d(^INCI(Inci,"IB",IB))
	.
	.s reccallflag=$p(^INCI(Inci,"IB",IB),"^",3)
	.q:reccallflag="Y"					//批次锁定
	.S lbqty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,"",ReseFlag)
	.q:lbqty'>0
	.
	.s ExpDate=$p($g(^INCI(Inci,"IB",IB)),"^",2)
	.i +ExpDate=0 s ExpDate=$zdh("9999-12-31",3)
	.q:(CheckExpFlag="Y")&&(ExpDate<=+$h)
	.
	.s sp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurSp(Inclb,"",HospID)
	.s (DateAdd,TimeAdd,ManfID)="0"
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,""))
	.i dhcincib'="" d
	..s DateAdd=+$p(^DHCINCIB(dhcincib),"^",10)
	..s TimeAdd=+$p(^DHCINCIB(dhcincib),"^",11)
	..s ManfID=$p(^DHCINCIB(dhcincib),"^",7)
	.
	.i SelBatFlag=1 d
	..s index1=ExpDate	//有效期优先
	..s index2=DateAdd
	..s index3=TimeAdd
	.e  d
	..s index1=DateAdd	//先进先出
	..s index2=TimeAdd
	..s index3=ExpDate
	.
	.s ^TMPDHCSTM("EXSP",pid,index1,index2,index3,IB,+ManfID,sp,Inclb)=lbqty
	.//开医嘱和发药时每次必须是同生产厂家的
	.s ^TMPDHCSTM("MANF",pid,+ManfID)=$g(^TMPDHCSTM("MANF",pid,+ManfID))+lbqty
	
	//确定所有符合条件的批次
	s dda="",newqty=+ReqQty,LastSp="",stkflag=0,iNum=0
	f  s dda=$o(^TMPDHCSTM("EXSP",pid,dda)) q:(dda="")!(stkflag=1)  d
	.s tta=""
	.f  s tta=$o(^TMPDHCSTM("EXSP",pid,dda,tta)) q:(tta="")!(stkflag=1)  d
	..s expd=""
	..f  s expd=$o(^TMPDHCSTM("EXSP",pid,dda,tta,expd)) q:(expd="")!(stkflag=1)  d
	...s ibb=""
	...f  s ibb=$o(^TMPDHCSTM("EXSP",pid,dda,tta,expd,ibb)) q:(ibb="")!(stkflag=1)  d
	....s ManfID=""
	....f  s ManfID=$o(^TMPDHCSTM("EXSP",pid,dda,tta,expd,ibb,ManfID)) q:(ManfID="")!(stkflag=1)  d
	.....q:^TMPDHCSTM("MANF",pid,ManfID)<+ReqQty
	.....s sp=""
	.....f  s sp=$o(^TMPDHCSTM("EXSP",pid,dda,tta,expd,ibb,ManfID,sp)) q:(sp="")!(stkflag=1)  d
	......s Inclb=""
	......f  s Inclb=$o(^TMPDHCSTM("EXSP",pid,dda,tta,expd,ibb,ManfID,sp,Inclb)) q:(Inclb="")!(stkflag=1)  d
	.......s clbstr=^(Inclb)
	.......s lbqty=+$p(clbstr,"^",1)
	.......s rp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurRp(Inclb,"",HospID)
	.......s iNum=iNum+1
	.......i lbqty'<newqty d
	........s ^TMPDHCSTM("Inclb",pid,iNum)=newqty_"^"_sp_"^"_rp_"^"_Inclb
	........s newqty=0
	........s stkflag=1
	.......e  d
	........s ^TMPDHCSTM("Inclb",pid,iNum)=lbqty_"^"_sp_"^"_rp_"^"_Inclb
	........s newqty=newqty-lbqty

	;滚医嘱时,待遍历完成,若库存不足(newqty>0),放在最后一个批次上
	i (stkflag'=1)&&(RollFlag=1)&&(newqty>0) d
	.i (iNum>0) d
	..s lastInclbQty=newqty+$p(^TMPDHCSTM("Inclb",pid,iNum),"^",1)
	..s $p(^TMPDHCSTM("Inclb",pid,iNum),"^",1)=lastInclbQty
	..s newqty=0
	..s stkflag=1
	.e  d
	..s Inclb=##Class(web.DHCSTMHUI.SRVCOMMON).GetLastInclbByLoc(Incil)
	..q:Inclb=""
	..s iNum=iNum+1
	..s rp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurRp(Inclb,"",HospID)
	..s sp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurSp(Inclb,"",HospID)
	..s ^TMPDHCSTM("Inclb",pid,iNum)=newqty_"^"_sp_"^"_rp_"^"_Inclb
	..s newqty=0
	..s stkflag=1
	
	i stkflag'=1 d
	.k ^TMPDHCSTM("Inclb",pid)

	k ^TMPDHCSTM("EXSP",pid)
	k ^TMPDHCSTM("MANF",pid)
	q stkflag
}

/// Descript：	开医嘱时取价格显示(批次价格使用,仅仅开医嘱使用)
/// Creater：	zhouyg
/// CreateDate：2014-12-24
/// Table：		Arc_ItmMast,Inc_itm,inc_itmloc,inc_itmlcbt
/// Input：		Arc_ItmMast的ID,接收科室ID
/// Output：	批次售价
/// Return：	批次售价,-100加锁失败,-102医嘱项为空,-103科室为空,-104对应库存项不存在,-106科室库存项不存在
ClassMethod GetBatSp(Arcim As %String, RecLoc As %String, BarCode As %String = "") As %String
{
	n (Arcim,RecLoc,BarCode)
	q:Arcim="" 0
	s Inci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),"")) 
	q:Inci="" 0
	s RetSp=0
	i RecLoc="" d
	.s RetSp=##Class(web.DHCSTMHUI.SRVCOMMON).GetCurSp(Inci,"","")
	q:RecLoc="" RetSp
	
	s ILSub=$o(^INCI("IL_LOC",RecLoc,Inci,""))
	q:ILSub="" 0
	s Incil=Inci_"||"_ILSub
	
	s HospID=$p($g(^CTLOC(RecLoc)),"^",22) 
	s DspQty=1		//取库存满足大于等于1的批次即可
	
	s pid=..NewPid()
	s RetCode=..GetInclbQty(Incil,DspQty,pid,2,BarCode)
	i RetCode'=1 d
	.s RetSp=##Class(web.DHCSTMHUI.SRVCOMMON).GetCurSp(Inci,"",HospID)
	e  d
	.s iNum=$o(^TMPDHCSTM("Inclb",pid,""))
	.q:iNum=""
	.s RetSp=$p(^TMPDHCSTM("Inclb",pid,iNum),"^",2)
	k ^TMPDHCSTM("Inclb",pid)
	q RetSp
}

/// Descript：	根据医嘱医嘱处理在途数(医生站接口,批次价和非批次价通用)
/// Creater：	zhouyg
/// CreateDate：2015-01-15
/// Table：			
/// Input：		医嘱ID,医嘱执行ID,seFlag(开医嘱:1，停医嘱或执行:2)
/// 			医嘱ID,医嘱执行ID只能输入其一，如果两个都录入就按执行ID处理
/// 			批次价时开医嘱不能调用此函数(批次价时已经在开医嘱插入批次表同时处理了在途数)
/// Return：	0-成功,其它-失败
ClassMethod SetOeResQty(OeItmID As %String, OeExeID As %String, seFlag As %String) As %String
{
	n (OeItmID,OeExeID,seFlag)
	q:(OeItmID="")&&(OeExeID="") -1
	q:(seFlag'=1)&&(seFlag'=2) -2
	
	s retCode=0
	i OeExeID'="" d
	.s OeordID=$p(OeExeID,"||",1)
	.s OeItmSub=$p(OeExeID,"||",2)
	e  d
	.s OeordID=$p(OeItmID,"||",1)
	.s OeItmSub=$p(OeItmID,"||",2)
	q:(OeordID="")||(OeItmSub="") -3
	
	;自备药,嘱托,不设置在途数
	;OM^自备药即刻, OMST^自备药长期, OMCQZT^长期嘱托, OMLSZT^临时嘱托
	s ArcimID=$p(^OEORD(OeordID,"I",OeItmSub,1),"^",2)
	s PriorID=$p(^OEORD(OeordID,"I",OeItmSub,1),"^",8)
	s RecLocID=$p(^OEORD(OeordID,"I",OeItmSub,3),"^",6)
	
	s PriorCode=$s(PriorID'="":$p($g(^OECPR(PriorID)),"^",1),1:"")
	q:$ZCVT(PriorCode,"U")["OM" 0
	s incID=##Class(web.DHCSTMHUI.SRVCOMMON).GetInciID(ArcimID)
	q:incID="" -4
	q:RecLocID="" -5
	s IL=$o(^INCI("IL_LOC",RecLocID,incID,""))
	q:IL="" -4
	s Incil=incID_"||"_IL
	s HospID=$p($g(^CTLOC(RecLocID)),"^",22)
	s RuleFlag=..sssBatSpFlag(HospID,incID)
	q:(RuleFlag=1)&&(seFlag=1) 0   ///处理批次打包表时处理
	i RuleFlag=1 d
	.s ResQty=0	//批次价
	.i OeExeID'="" d
	..s dspID=""
	..f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",OeExeID,dspID)) q:(dspID="")||(retCode'=0)  d
	...s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
	...q:(dspStatus'="TC")
	...s dspbID="0"
	...f  s dspbID=$o(^DHCOEDISQTY(dspID,"I",dspbID)) q:(dspbID="")||(retCode'=0)  d
	....s Inclb=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",1)
	....s ResQty=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",2)
	....i seFlag=2 s ResQty=-ResQty		//停医嘱减在途
	....;记录在途明细信息
	....s DspBatId=dspID_"||"_dspbID
	....s ReservedObj={}
	....s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspBatId,ReservedObj.Inclb=Inclb,ReservedObj.Qty=ResQty
	....s ReservedParams=ReservedObj.%ToJSON()
	....s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	....i RtnObj.success<0 s retCode=-1 q
	.e  d
	..s admID=$p($g(^OEORD(OeordID)),"^",1)
	..q:admID=""
	..s admType=$p($g(^PAADM(admID)),"^",2)
	..q:(admType="I")	//住院病人不能按照医嘱ID处理
	..s dspID=""
	..f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",OeItmID,dspID)) q:(dspID="")||(retCode'=0)  d
	...s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
	...q:(dspStatus'="TC")
	...s dspbID="0"
	...f  s dspbID=$o(^DHCOEDISQTY(dspID,"I",dspbID)) q:(dspbID="")||(retCode'=0)  d
	....s Inclb=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",1)
	....s ResQty=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",2)
	....i seFlag=2 s ResQty=-ResQty	//停医嘱减在途
	....;s retCode=##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty(Inclb,ResQty)
	....;记录在途明细信息
	....s DspBatId=dspID_"||"_dspbID
	....s ReservedObj={}
	....s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspBatId,ReservedObj.Inclb=Inclb,ReservedObj.Qty=ResQty
	....s ReservedParams=ReservedObj.%ToJSON()
	....s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	....i RtnObj.success<0 s retCode=-1 q
	e  d
	.s ResQty=$$GetResQty()	//非批次价
	.q:ResQty=0
	.i seFlag=2 s ResQty=-ResQty	//停医嘱减在途
	.;s retCode=##class(web.DHCSTMHUI.Common.StockHandle).UpdateResQty(Incil,ResQty)
	.;记录在途明细信息
	.s ReservedObj={}
	.s ResPointer=$s(OeExeID'="":OeExeID,1:OeItmID)
	.s ReservedObj.Type="Oeori",ReservedObj.Pointer=ResPointer,ReservedObj.Incil=Incil,ReservedObj.Qty=ResQty
	.s ReservedParams=ReservedObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	.i RtnObj.success<0 s retCode=-1 q
	q:retCode<0 retCode
	q 0

GetResQty()
	s ResQty=0
	i OeExeID'="" d
	.s dspID=""
	.f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",OeExeID,dspID)) q:(dspID="")  d
	..s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
	..q:(dspStatus'="TC")
	..s dspQty=$p(^DHCOEDISQTY(dspID),"^",11)
	..s ResQty=ResQty+dspQty
	else  d
	.s admID=$p($g(^OEORD(OeordID)),"^",1)
	.q:admID=""
	.s admType=$p($g(^PAADM(admID)),"^",2)
	.q:(admType="I")	//住院病人不能按照医嘱ID处理
	.s dspID=""
	.f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",OeItmID,dspID)) q:(dspID="")  d
	..s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
	..q:(dspStatus'="TC")
	..s dspQty=$p(^DHCOEDISQTY(dspID),"^",11)
	..s ResQty=ResQty+dspQty
	q ResQty
}

/// Descript：	DHC_OEDispBatch表处理的相关操作
/// Creater：	zhouyg
/// CreateDate：2014-12-24
/// Table：		DHC_OEDispensing,DHCOEDispBatch
/// Input：		DspbStr:DspID^Inclb^数量^售价^进价
/// Return：	SQLCODE
ClassMethod InsDspBat(DspbStr As %String) As RtnObj
{
	n (DspbStr)
	s RtnObj=##class(RtnObj).%New()
	s DspID=$p(DspbStr,"^",1)
	s Inclb=$p(DspbStr,"^",2)
	s qty=+$p(DspbStr,"^",3)
	s sp=+$p(DspbStr,"^",4)
	s rp=+$p(DspbStr,"^",5)
	k OEDISP
	s OEDISP(0)=DspID
	s OEDISP(3)=Inclb
	s OEDISP(4)=qty
	s OEDISP(5)=sp
	s OEDISP(6)=rp
	&sql(Insert Into DHC_OEDispBatch Values :OEDISP())
	i SQLCODE q RtnObj.Err(-1,"","DHC_OEDispBatch插入错误")
	
	s DspBatId=%ROWID
	s RtnObj.rowid=DspBatId
	q RtnObj
}

/// Descript：	住院开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// Creater：	zhouyg
/// CreateDate：2013-08-08
/// Table：		DHC_OEDispensing,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input：		DHC_OEDispensing的ID,RollFlag是否滚医嘱(1为滚医嘱)
/// Output：	INCLB^数量^进价^售价
/// Return：	0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// 20141224修改
/// w ##class(web.DHCSTMHUI.SRVINTERFACE).InsDspBatch(26279,1,"")
ClassMethod InsDspBatch(DspID As %String, RollFlag As %String, barcode As %String) As %String
{
	n (DspID,RollFlag,barcode)
	q:(DspID="")||'$d(^DHCOEDISQTY(DspID)) 0
	s OeoriID=$p(^DHCOEDISQTY(DspID),"^",1)
	s Oeore=$p(^DHCOEDISQTY(DspID),"^",3)
	s DspQty=$p(^DHCOEDISQTY(DspID),"^",11)
	s RecLocId=$p(^DHCOEDISQTY(DspID),"^",24)
	q:RecLocId="" 0

	s OrdID=$p(OeoriID,"||",1)
	s OrdSub=$p(OeoriID,"||",2)
	s Arcim=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2) 
	q:Arcim="" 0
	s Arc=$p(Arcim,"||",1)
	q:Arc="" 0
	s Inci=$o(^INCI(0,"ARCIM_DR",Arc,"")) 
	q:Inci="" 0

	s HospID=$p($g(^CTLOC(RecLocId)),"^",22)
	s RuleFlag=..sssBatSpFlag(HospID,Inci)
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(Inci)
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	;非批次价模式,跟台高值不进行相关处理
	q:(RuleFlag'=1)&&(TableFlag="Y")&&(HVFlag="Y") 1
	s WoStockFlag=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ChkWoStock(Arcim)
	q:(HVFlag'="Y")&&(WoStockFlag=1)&&(RuleFlag'=1) 1	;统一价低值无库存医嘱不插入在途
	s StockControl=##class(web.DHCSTMHUI.Common.UtilCommon).GetStockControl(RecLocId)
	q:(HVFlag'="Y")&&(StockControl="N")&&(RuleFlag=0) 1

	s RetCode=0
	;1 非批次价, 设置在途
	i RuleFlag=0 d
	.s IL=$o(^INCI("IL_LOC",RecLocId,Inci,""))
	.q:IL=""
	.s Incil=Inci_"||"_IL
	.;s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateResQty(Incil,DspQty)
	.;i Ret=0 s RetCode=1
	.;记录在途明细信息
	.s ReservedObj={}
	.s ResPointer=Oeore
	.s ReservedObj.Type="Oeori",ReservedObj.Pointer=ResPointer,ReservedObj.Incil=Incil,ReservedObj.Qty=DspQty
	.s ReservedParams=ReservedObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	.i RtnObj.success=0 s RetCode=1
	q:RuleFlag=0 RetCode
	;s IL=$o(^INCI("IL_LOC",RecLocId,Inci,""))
	;q:IL="" 0
	;如没有批次,生成零库存批次记录
	s IncilId=##class(web.DHCSTMHUI.Common.StockHandle).CreateZeroIncil(RecLocId,Inci)
	s IL=$p(IncilId,"||",2)
	q:IL="" 0
	s Incil=Inci_"||"_IL
	;2 批次价计算批次后插入打包子表
	s Pid=..NewPid()
	i $$LK1()<0 q -100
	;RetCode:  1-有满足条件的批次; 其他-没有满足条件的批次
	s RetCode=..GetInclbQty(Incil,DspQty,Pid,2,barcode,RollFlag)
	i (RetCode'=1)&&(RollFlag'=1) d
	.d UK1
	.k ^TMPDHCSTM("Inclb",Pid)
	;获取不到批次,非滚医嘱模式
	i (RetCode'=1)&&(RollFlag'=1) q 0
	
	ts
	s Ret=0
	
	i (RetCode'=1)&&(RollFlag=1) d
	.;2.1-获取不到批次,滚医嘱模式
	.;滚医嘱时如果库存不足取科室最后一个批次
	.s Inclb=##Class(web.DHCSTMHUI.SRVCOMMON).GetLastInclbByLoc(Incil)
	.i Inclb="" s Ret=-1 q
	.s Sp=##Class(web.DHCSTMHUI.SRVCOMMON).GetCurSp(Inclb,"",HospID)
	.s Rp=##Class(web.DHCSTMHUI.SRVCOMMON).GetCurRp(Inclb,"",HospID)
	.s DspBatStr=DspID_"^"_Inclb_"^"_DspQty_"^"_Sp_"^"_Rp
	.s RtnObj=..InsDspBat(DspBatStr)
	.i RtnObj.success'=0 s Ret=-2 q
	e  d
	.;2.2-获取到批次,正常处理
	.s Num=""
	.f  s Num=$o(^TMPDHCSTM("Inclb",Pid,Num)) q:(Num="")||(Ret'=0)  d
	..s InclbStr=^(Num)
	..s Qty=+$p(InclbStr,"^",1)
	..s Sp=+$p(InclbStr,"^",2)
	..s Rp=+$p(InclbStr,"^",3)
	..s Inclb=$p(InclbStr,"^",4)
	..s DspbStr=DspID_"^"_Inclb_"^"_Qty_"^"_Sp_"^"_Rp
	..s RtnObj=..InsDspBat(DspbStr)
	..i RtnObj.success<0 s Ret=-3 q
	..s DspBatId=RtnObj.rowid
	..//处理批次在途数(医嘱)
	..;s ResRet=##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty(Inclb,Qty)
	..;i ResRet<0 s Ret=-4 q
	..;设置在途
	..s ReservedObj={}
	..s ResPointer=DspBatId
	..s ReservedObj.Type="DspBatch",ReservedObj.Pointer=ResPointer,ReservedObj.Inclb=Inclb,ReservedObj.Qty=Qty
	..s ReservedParams=ReservedObj.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	..i RtnObj.success<0 s Ret=-4 q
	.q:Ret<0
	
	i Ret<0 d
	.tro 1
	.d UK1
	.k ^TMPDHCSTM("Inclb",Pid)
	i Ret<0 q 0
	
	//开医嘱处理条码状态
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i barcode'="" d
	.s User=+$p(^OEORD(OrdID,"I",OrdSub,1),"^",11)		;开单医生(CT_CareProv)
	.s:User'="" User=$o(^SSU("SSUSR",0,"CTPCP",User,0))
	.s OperData="^"_User_"^"_Inci_"^^^^"
	.s IntrTypeInfo=..sssOeoriTrType(OeoriID)
	.s IntrType=$p(IntrTypeInfo,"^",1)
	.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(IntrType,OeoriID,barcode,OperData)
	.i RtnObj.success'=0 s Ret=-5 q
	
	i Ret<0 d
	.tro 1
	.d UK1
	.k ^TMPDHCSTM("Inclb",Pid)
	i Ret<0 q 0
	
	d UK1
	k ^TMPDHCSTM("Inclb",Pid)
	tc
	q 1
	
LK1()
	l +^INCI(Inci,"IL",IL):20 e  q -1
	q 0
UK1
	l -^INCI(Inci,"IL",IL)
	q
}

/// Descript：	门诊开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// Creater：	zhouyg
/// CreateDate：2013-08-08
/// Table：		OE_OrdItem,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input：		OE_OrdItem的ID, 高值条码, RollFlag:传1时,可减为负库存
/// Output：	INCLB^数量^进价^售价
/// Return：	0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// w ##class(web.DHCSTMHUI.SRVINTERFACE).InsDspBatchForOut("475||4","","")
ClassMethod InsDspBatchForOut(OeoriID As %String, barcode As %String, RollFlag = "") As %String
{
	n (OeoriID,barcode,RollFlag)
	q:OeoriID="" 0
	s OrdID=$p(OeoriID,"||",1)
	s OrdSub=$p(OeoriID,"||",2)
	s Arcim=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2) 
	s RecLocId=$p(^OEORD(OrdID,"I",OrdSub,3),"^",6) 
	q:Arcim="" 0
	q:RecLocId="" 0
	s Arc=$p(Arcim,"||",1)
	q:Arc="" 0
	s Inci=$o(^INCI(0,"ARCIM_DR",Arc,"")) 
	q:Inci="" 0
	s HospID=$p($g(^CTLOC(RecLocId)),"^",22)
	s RuleFlag=..sssBatSpFlag(HospID,Inci)
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(Inci)
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	;非批次价模式,跟台高值不进行相关处理
	q:(RuleFlag'=1)&&(TableFlag="Y")&&(HVFlag="Y") 1
	s WoStockFlag=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ChkWoStock(Arcim)
	q:(HVFlag'="Y")&&(WoStockFlag=1)&&(RuleFlag'=1) 1
	s StockControl=##class(web.DHCSTMHUI.Common.UtilCommon).GetStockControl(RecLocId)
	q:(HVFlag'="Y")&&(StockControl="N")&&(RuleFlag=0) 1

	;s ILSub=$o(^INCI("IL_LOC",RecLocId,Inci,""))
	;q:ILSub="" -106
	;如没有批次,生成零库存批次记录
	s IncilId=##class(web.DHCSTMHUI.Common.StockHandle).CreateZeroIncil(RecLocId,Inci)
	s ILSub=$p(IncilId,"||",2)
	q:ILSub="" 0
	
	//门急诊单机应急系统(导回数据后关于批次售价取值信息，支持负库存)
	s (ContFlag,ContInclb,ContSp,ContBatchSp)=""
	i RuleFlag=1 d
	.s OeoriInfo=$g(^OEORD(OrdID,"I",OrdSub,"DHC"))
	.s ContFlag=$p(OeoriInfo,"^",62)
	.q:ContFlag'="Y"
	.s ContBatchSp=$p(OeoriInfo,"^",63)
	.s ContInclb=$p(ContBatchSp,",",1)
	.s ContSp=$p(ContBatchSp,",",2)
	q:(ContFlag="Y")&&(ContInclb="") 0
	
	s Incil=Inci_"||"_ILSub
	s TotalQty=0
	s DspID=""
	f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,DspID)) q:DspID=""  d
	.s DspQty=$p($g(^DHCOEDISQTY(DspID)),"^",11)
	.s TotalQty=TotalQty+DspQty
	q:TotalQty=0 0
	i $$LKOut()<0 q 0
	
	s Ret=0
	ts
	s Pid=""
	i RuleFlag=0 d
	.;1 非批次价直接用医嘱计算出的库存项和数量插入打包子表
	.;s ResRet=##class(web.DHCSTMHUI.Common.StockHandle).UpdateResQty(Incil,TotalQty)
	.;i ResRet s Ret=-1 q
	.;记录在途明细信息
	.s ReservedObj={}
	.s ResPointer=OeoriID
	.s ReservedObj.Type="Oeori",ReservedObj.Pointer=ResPointer,ReservedObj.Incil=Incil,ReservedObj.Qty=TotalQty
	.s ReservedParams=ReservedObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	.i RtnObj.success<0 s Ret=-1 q
	e  i (RuleFlag=1)&&(ContFlag="Y") d	//门急诊单机应急系统批次价处理
	.s Rp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurRp(ContInclb,"",HospID)
	.s DspID=""
	.f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,DspID)) q:(DspID="")||(Ret'=0)  d
	..s DspQty=$p($g(^DHCOEDISQTY(DspID)),"^",11)
	..s DspbStr=DspID_"^"_ContInclb_"^"_DspQty_"^"_ContSp_"^"_Rp
	..s RtnObj=..InsDspBat(DspbStr)
	..i RtnObj.success<0 s Ret=-1000 q
	..s DspBatId=RtnObj.rowid
	..;设置在途
	..s ReservedObj={}
	..s ResPointer=DspBatId
	..s ReservedObj.Type="DspBatch",ReservedObj.Pointer=ResPointer,ReservedObj.Inclb=ContInclb,ReservedObj.Qty=DspQty
	..s ReservedParams=ReservedObj.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	..i RtnObj.success<0 s Ret=-4 q
	e  d
	.;2 批次价计算批次后插入打包子表
	.s Pid=..NewPid()
	.s RetCode=..GetInclbQty(Incil,TotalQty,Pid,2,barcode,RollFlag)
	.i RetCode'=1 s Ret=-1 q
	.s DspID=""
	.f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,DspID)) q:(DspID="")||(Ret'=0)  d
	..s DspQty=$p($g(^DHCOEDISQTY(DspID)),"^",11)
	..s Num=""
	..f  s Num=$o(^TMPDHCSTM("Inclb",Pid,Num)) q:(Num="")||(Ret'=0)||(DspQty=0)  d
	...s InclbStr=^(Num)
	...s rqty=+$p(InclbStr,"^",1)
	...s Sp=+$p(InclbStr,"^",2)
	...s Rp=+$p(InclbStr,"^",3)
	...s Inclb=$p(InclbStr,"^",4)
	...q:rqty=0
	...
	...i rqty'<DspQty d
	....s DspbQty=DspQty
	....s DspQty=DspQty-DspbQty
	....s $p(^TMPDHCSTM("Inclb",Pid,Num),"^",1)=rqty-DspbQty
	...e  d
	....s DspbQty=rqty
	....s DspQty=DspQty-DspbQty
	....s $p(^TMPDHCSTM("Inclb",Pid,Num),"^",1)=rqty-DspbQty
	...
	...s DspbStr=DspID_"^"_Inclb_"^"_DspbQty_"^"_Sp_"^"_Rp
	...s RtnObj=..InsDspBat(DspbStr)
	...i RtnObj.success<0 s Ret=-1000 q
	...s DspBatId=RtnObj.rowid
	...;s ResRet=##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty(Inclb,DspbQty)
	...;i ResRet<0 s Ret=-3 q
	...;设置在途
	...s ReservedObj={}
	...s ResPointer=DspBatId
	...s ReservedObj.Type="DspBatch",ReservedObj.Pointer=ResPointer,ReservedObj.Inclb=Inclb,ReservedObj.Qty=DspbQty
	...s ReservedParams=ReservedObj.%ToJSON()
	...s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	...i RtnObj.success<0 s Ret=-4 q
	i Ret'=0 d
	.trollback 1
	.d UKOut
	.i Pid'="" k ^TMPDHCSTM("Inclb",Pid)
	q:Ret'=0 0
	
	//门诊开医嘱处理条码状态
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i barcode'="" d
	.s User=+$p(^OEORD(OrdID,"I",OrdSub,1),"^",11)		;开单医生(CT_CareProv)
	.s:User'="" User=$o(^SSU("SSUSR",0,"CTPCP",User,0))
	.s OperData="^"_User_"^"_Inci_"^^^^"
	.s IntrTypeInfo=..sssOeoriTrType(OeoriID)
	.s IntrType=$p(IntrTypeInfo,"^",1)
	.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(IntrType,OeoriID,barcode,OperData)
	.i RtnObj.success'=0 s Ret=-4 q
	i Ret'=0 d
	.trollback 1
	.d UKOut
	.i Pid'="" k ^TMPDHCSTM("Inclb",Pid)
	q:Ret'=0 0
	
	tc
	d UKOut
	i Pid'="" k ^TMPDHCSTM("Inclb",Pid)
	q 1
	
LKOut()
	l +^INCI(Inci,"IL",ILSub):20 e  q -1
	q 0
UKOut
	l -^INCI(Inci,"IL",ILSub)
	q
}

/// OutPut:		1-成功; 其他-失败;
ClassMethod UPDINCI(INTRDATA)
{
	N (INTRDATA)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	S Type=$p(INTRDATA,"^",1)
	S Inclb=$p(INTRDATA,"^",3)
	S QTY=$p(INTRDATA,"^",4)
	
	S Inci=$P(Inclb,"||",1),IL=$P(Inclb,"||",2)
	Q:(Inci="")||(IL="") 0
	L +^INCI(Inci,"IL",IL):20 E  Q 0
	ts
	s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,QTY)
	i ret'=0 tro 1 L -^INCI(Inci,"IL",IL) q 0
	
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(INTRDATA)
	i RtnObj.success'=0  tro 1 L -^INCI(Inci,"IL",IL) q 0
	tc
	L -^INCI(Inci,"IL",IL)
	Q 1
}

/// 门诊住院 审核医嘱减库存 2012-06-10  
/// zdm,2010-06-09
/// 1 根据批次打包表 减库存  不再找批次
/// 2 处理该材料记录的库存
/// 3 处理dhc_intrans表
/// 3 处理INC_ItmLcBt和INC_ItmLoc,dhc_locdailytotal,dhc_locbtdailytotal
/// 备注：库存类型不是"M"的不处理,无库存医嘱不处理
/// Input:	oeori-医嘱RowID(长期医嘱传入执行记录rowid)   CallFlag(调用标记:审核医嘱-"ORDER",计费-"BILL")
/// Return:0-正确;-1,-2,-3,-4医嘱错误;-5没有医嘱数量;-6已经发药或已经退药,-7库存不足;1,2,3,4处理库存错误
/// w ##class(web.DHCSTMHUI.SRVINTERFACE).DispMaterial("152||137||1","","ORDER")
ClassMethod DispMaterial(oeore As %String, barcode As %String, CallFlag = "") As %Library.String
{
	n (oeore,barcode,CallFlag)
	s oeori=$p(oeore,"||",1,2)
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	
	q:(ord="")!(itm="") -1
	q:'$d(^OEORD(ord,"I",itm)) -1
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" -2
	
	;低值 自备,嘱托,不进行库存消减
	;OM^自备药即刻, OMST^自备药长期, OMCQZT^长期嘱托, OMLSZT^临时嘱托
	s PriorID=$p(^OEORD(ord,"I",itm,1),"^",8)
	s PriorCode=$s(PriorID'="":$p($g(^OECPR(PriorID)),"^",1),1:"")
	q:(barcode="")&&($ZCVT(PriorCode,"U")["OM") 0
	
	s paadm=$P(^OEORD(ord),"^",1)
	s admtype=$p(^PAADM(paadm),"^",2)
	s admloc=$p(^PAADM(paadm),"^",4)
	s HospitalId=$p($G(^CTLOC(admloc)),"^",22)
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
	q:recloc="" -3
	s Param="^"_recloc_"^^"_HospitalId
	s matDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM","MatDisp",Param)
	s InMatDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTINMATDISPM","InMatDisp",Param)
	q:(admtype="O")&&(matDisp="Y") 0     ;普通物资走门诊发放时不处理
	q:(admtype="E")&&(matDisp="Y") 0     ;急诊物资走门诊发放时不处理
	q:(barcode="")&&(admtype="I")&&(InMatDisp="Y") 0     ;住院物资走门诊发放时不处理
	
	s Inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) 
	q:Inci="" -4
	s stkCatGrpType=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetItmStkGrpType(Inci)
	q:stkCatGrpType'="M" 0	//非材料医嘱退出
	s ILSub=$o(^INCI("IL_LOC",recloc,Inci,"")) 
	q:ILSub="" -106
	s HospID=$p(^CTLOC(recloc),"^",22)
	s Incil=Inci_"||"_ILSub
	
	s paadm=$p(^OEORD($p(oeori,"||",1)),"^",1)
	s admtype=$p(^PAADM(paadm),"^",2)
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	
	q:(admtype="I")&&(CallFlag="BILL") 0
	q:(barcode="")&&(admtype="O")&&(CallFlag="ORDER") 0
	
	;paymodeflag: 1-押金收费模式 0-普通收费模式
	s paymodeflag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(HospID)
	;stayFlag: 1-有留观医嘱 0-无留观医嘱
	s stayFlag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayStatus(paadm)
	q:(admtype="E")&&(paymodeflag=1)&&(stayFlag'=-1)&&(CallFlag="BILL") 0	;急诊患者,押金模式下留观计费时调用不再处理
	q:(admtype="E")&&(paymodeflag=1)&&(stayFlag=-1)&&(CallFlag="ORDER") 0	;急诊患者,押金模式下非留观审核医嘱时调用不再处理
	q:(admtype="E")&&(paymodeflag=0)&&(CallFlag="ORDER") 0	;急诊患者,普通模式下审核医嘱时调用不再处理
	l +^DHCINCIL(recloc,Inci):20  e  q -1
	s oeStatus=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ChkDspStatus(oeore)
	i oeStatus'="TC" l -^DHCINCIL(recloc,Inci) q -6
	s user=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s:user'="" user=$o(^SSU("SSUSR",0,"CTPCP",user,0))
	s basuom=$p(^INCI(Inci,1),"^",10)
	s pointer=oeore
	s operData="^"_user_"^"_Inci_"^^^^"
	s RetCode=0
	
	ts
	i '((admtype="O")&&(CallFlag="ORDER")) {
		i $p(oeore,"||",3)="" d     ///门诊
		.s DspID=""
		.f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",oeori,DspID)) q:(DspID="")!(RetCode'=0)  d
		..s DspSub=0,TemDspSub=0
		..s TemDspSub=$o(^DHCOEDISQTY(DspID,"I",TemDspSub))
		..i TemDspSub="" s RetCode=-10 q
		..s Sp=$p(^DHCOEDISQTY(DspID,"I",TemDspSub),"^",4)
		..f  s DspSub=$o(^DHCOEDISQTY(DspID,"I",DspSub)) q:(DspSub="")!(RetCode'=0)  d
		...s Inclb=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",1)
		...s qty=-$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",2)
		...s Rp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",3)
		...s RpAmt=qty*Rp
		...s SpAmt=qty*Sp
		...
		...;清在途
		...s ReservedObj={}
		...s DspBatId=DspID_"||"_DspSub
		...s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspBatId,ReservedObj.Inclb=Inclb,ReservedObj.Qty=qty
		...s ReservedParams=ReservedObj.%ToJSON()
		...s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
		...i RtnObj.success<0 s RetCode=-11 q
		...
		...s Data=intrType_"^^"_Inclb_"^"_qty_"^"_basuom_"^"_Sp_"^"_user_"^"_pointer_"^"_Rp_"^"_RpAmt_"^"_SpAmt
		...s Ret=..UPDINCI(Data)
		...i Ret'=1  s RetCode=-12 q
		...i barcode'="" d
		....s Ret=..RecodHV(oeori,Inclb,barcode,operData,Rp,Sp,-qty,CallFlag)
		....i Ret'=0  s RetCode=-13 q
		e   d
		.s DspID=""
		.f  s DspID=$o(^DHCOEDISQTY(0,"OEORE",oeore,DspID)) q:(DspID="")!(RetCode'=0)  d
		..s DspSub=0,TemDspSub=0
		..s TemDspSub=$o(^DHCOEDISQTY(DspID,"I",TemDspSub))
		..i TemDspSub="" s RetCode=-1 q
		..s Sp=$p(^DHCOEDISQTY(DspID,"I",TemDspSub),"^",4)
		..f  s DspSub=$o(^DHCOEDISQTY(DspID,"I",DspSub)) q:(DspSub="")!(RetCode'=0)  d
		...s Inclb=$p($g(^DHCOEDISQTY(DspID,"I",DspSub)),"^",1)
		...s qty=-$p($g(^DHCOEDISQTY(DspID,"I",DspSub)),"^",2)
		...s Rp=$p($g(^DHCOEDISQTY(DspID,"I",DspSub)),"^",3)
		...s RpAmt=qty*Rp
		...s SpAmt=qty*Sp
		...
		...;清在途
		...s ReservedObj={}
		...s DspBatId=DspID_"||"_DspSub
		...s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspBatId,ReservedObj.Inclb=Inclb,ReservedObj.Qty=qty
		...s ReservedParams=ReservedObj.%ToJSON()
		...s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
		...i RtnObj.success<0 s RetCode=-21 q
		...
		...s Data=intrType_"^^"_Inclb_"^"_qty_"^"_basuom_"^"_Sp_"^"_user_"^"_pointer_"^"_Rp_"^"_RpAmt_"^"_SpAmt
		...s Ret=..UPDINCI(Data)
		...i Ret'=1  s RetCode=-22 q
		...i barcode'="" d
		....s Ret=..RecodHV(oeori,Inclb,barcode,operData,Rp,Sp,-qty,CallFlag)
		....i Ret'=0  s RetCode=-23 q
		
		i RetCode'=0 d
		.trollback 1
		.l -^DHCINCIL(recloc,Inci)
		q:RetCode'=0 RetCode
		s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(oeore,"C",+$h,$p($h,",",2),user,intrType,pointer)
		i err'=0 d
		.trollback 1
		.l -^DHCINCIL(recloc,Inci) 
		q:err'=0 err
	}
	tc
	l -^DHCINCIL(recloc,Inci)
	q 0
}

ClassMethod RecodHV(oeori, Inclb, barcode, operData, rp, sp, qty, CallFlag = "")
{
	n (oeori,Inclb,barcode, operData,rp,sp,qty,CallFlag)
	s ret=0
	
	s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,""))
	q:dhcit="" -1
	
	s spAmt=sp*qty
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	s user=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生
	s Inci=+Inclb
	s buomDr=$p(^INCI(Inci,1),"^",10)
	s incib="",batno="", expdate="",manf="",vendor=""
	s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	s incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	i incib'="" d
	.s IB=$p(incib,"||",2)
	.s batno=$p(^INCI(Inci,"IB",IB),"^",1)
	.s expdate=$p(^INCI(Inci,"IB",IB),"^",2)
	.s dhcIncib=$o(^DHCINCIB(0,"INCIB",incib,""),-1)
	.i dhcIncib'="" s manf=$p(^DHCINCIB(dhcIncib),"^",7)
	s vendor=$p(^DHCIT(dhcit),"^",11)
	s admLoc=$p(^OEORD(ord,"I",itm,9),"^",2)
	s canceled="",invno="",invdate="",invamt=""
	s remark="高值材料发放"
	i expdate'="" s expdate=$zd(expdate,3)
	i invdate'="" s invdate=$zd(invdate,3)
	s ingri=##class(web.DHCSTMHUI.PCHCOLLSM).GetIngri(barcode)
	s $p(data,"^",1)=""
	s $p(data,"^",2)=oeori
	s $p(data,"^",3)=""
	s $p(data,"^",4)=""
	s $p(data,"^",5)=""
	s $p(data,"^",6)=""  //收费状态
	s $p(data,"^",7)=spAmt   //收费金额
	s $p(data,"^",8)=admLoc
	s $p(data,"^",9)=user
	s $p(data,"^",10)=""
	s $p(data,"^",11)=batno
	s $p(data,"^",12)=manf
	s $p(data,"^",13)=vendor
	s $p(data,"^",14)=buomDr
	s $p(data,"^",15)=qty
	s $p(data,"^",16)=rp
	s $p(data,"^",17)=sp
	s $p(data,"^",18)=barcode
	s $p(data,"^",19)=expdate
	s $p(data,"^",20)=canceled
	s $p(data,"^",21)=invno
	s $p(data,"^",22)=invdate
	s $p(data,"^",23)=invamt
	s $p(data,"^",24)=Inci
	s $p(data,"^",25)=remark
	s $p(data,"^",26)=ingri
	s Rowid=##class(web.DHCSTMHUI.HVMatOrdItm).Update(data)
	s:+Rowid'>0 ret=-2
	q ret
}

}
