Class web.DHCOEDispensing Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod ChkStock(INCIrow, CTLOCrow, QtyNeed, NoMSG)
{
	&SQL(Select INCIL_LogQty,INCIL_ReservedQty into :LocQty,ResQty From SQLUser.INC_ItmLoc 
		Where INCIL_INCI_Parref=:inci and INCIL_CTLOC_DR=:stk)
	i SQLCODE d  q 0
	.q:$g(NOMSG)
	q:($g(LocQty)-$g(ResQty))'<QtyNeed 1
	q 0
}

ClassMethod EnoughStk(ARCIMrow, CTLOCrow, QtyNeed, NOMSG) As %String
{
	; Called from aOE6
	q:$g(ARCIMrow)="" 0
	s INCIrow=..GetINCI($p($p(ARCIMrow,$c(1)),"||",1))
	q:$g(INCIrow)="" 1
	q ..ChkStock(INCIrow,CTLOCrow,QtyNeed,0)
}

ClassMethod GetINCI(ARCIMsub) As %String
{
	;w ##class(web.DHCOEDispensing).GetINCI(4975)
	s ARCIMsub=$p(ARCIMsub,$c(1))
	s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
	q $g(INCIrow)
}

ClassMethod GetINCIL(inci As %String, stk As %String) As %String
{
	s inci=$p(inci,$c(1))
	s stk=$p(stk,$c(1))
	&SQL(Select INCIL_RowId into :INCILrow From SQLUser.INC_ItmLoc 
		Where INCIL_INCI_Parref=:inci and INCIL_CTLOC_DR=:stk)
	q $g(INCILrow)
}

ClassMethod Return(OrdItmRowId As %String) As %String
{
	s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",OrdItmRowId,0))
	While (DSPRowId'="") {
		s DSPStatus=$P(^DHCOEDISQTY(DSPRowId),"^",7)
		if DSPStatus="TC" {
			s DSPQty=$P(^DHCOEDISQTY(DSPRowId),"^",5)
			s DSPQty=-DSPQty
			//反库存
			s Rtn=##class(web.DHCOEDispensing).PortForDurg("O",OrdItmRowId,"",2,"")
			//d ..reserve(OrdItmRowId,DSPQty)
		}
		s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",OrdItmRowId,DSPRowId))
	}
	
	//反库存调用,暂不处理返回值,因为材料库存管理医院不一定启用,如果不启动调用返回值会不正确
	//门诊材料减库存,加库存在收费调用
	d ##class(appcom.OEOrdItem).ReturnMaterial(OrdItmRowId)
}

ClassMethod UpdRes(INCILrow As %String, Qty As %String) As %String
{
 ; Return 1 if OK, 0 if not OK
 ;
 ; Remove external value (ie. same as $p(Qty,$c(1),1))
 s Qty=+Qty
 s INCIL(1)=$p(INCILrow,$c(1),1)
 s INCI(1)=$p(INCIL(1),"||",1)
 s INCIL(2)=$p(INCIL(1),"||",2)       ; INCIL_ChildSub
 q:INCI(1)="" 0
 ;
 ; Lock INCIL
 L +^DBLock("StockTransRes",INCILrow):2
 e  q 0
 ;
 ;
 ; INCIL(18) - INCIL_ReservedQty : Following - to update INCIL_LogQty
 s INCIL(18)=+$p(^INCI(INCI(1),"IL",INCIL(2)),"^",10)
 s qty=INCIL(18)+Qty s:qty<0 qty=0 s $p(^INCI(INCI(1),"IL",INCIL(2)),"^",10)=qty
 L -^DBLock("StockTransRes",INCILrow):2
 ;
 q 1
}

ClassMethod reserve(oeitm As %String, qty As %String)
{
	s arcim=$P(^OEORD(+oeitm,"I",$P(oeitm,"||",2),1),"^",2)
	s recloc=$P(^OEORD(+oeitm,"I",$P(oeitm,"||",2),3),"^",6)
	q:recloc=""
	s arcim1=$p(arcim,"||")
	s inci=..GetINCI(arcim1) 
	q:inci=""
	s incil=..GetINCIL(inci,recloc) 
	q:incil=""
	Q:(qty="")||(qty=0)
	s err=..UpdRes(incil,qty)
}

ClassMethod Insert(oeitm As %String) As %String
{
	s Date=..%SysDate(),Time=..%SysTime()
	s arcim=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",2)
	Q:arcim="" 0
	s INCIrow=..GetINCI(+arcim)
	Q:INCIrow="" 0
	
	s drgform=$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",12)
	s arcgrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	s cattype=$p(^ARC("IC",arcgrp),"^",7)
	s stttime=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",10)
	s PackQty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),9)),"^",4)
	s phqtyord=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",12)
	s prior=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",8)
	s freq=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",4)
	s dur=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",6)
	s doseqty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",1)
	s uom=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",3)
	s recloc=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),3)),"^",6)
	s baseuom=##class(web.DHCaOET).baseuom(arcim)
	s billuom=$p(^ARCIM(+arcim,$p(arcim,"||",2),8),"^",14)
	s:'doseqty doseqty=1 ;Dose Qty
	i cattype="R"{
		i PackQty="" {
			;get frequency factor
			s FreqFactor=##class(web.DHCaOET).freq($g(freq))
			s DurFactor=##class(web.DHCaOET).dur(dur)
			s WeekFlag=$P($g(^PHCFR(+$g(freq),"DHC")),"^",1)
			if WeekFlag'=1 {
				s Counter=0
				For i=1:1:DurFactor {
					Set childsub=0  f  s childsub=$O(^PHCFR(freq,"DT",childsub)) Q:childsub=""  d
		 			.s Counter=Counter+1
	 				.s ExeTList(Counter)=$p(^PHCFR(freq,"DT",childsub),"^",1)
	 			}
			}else {
				s FreqFactor=1
				s ExeTList(1)=stttime
			}
			s dispqty=##class(web.DHCaOET).calcqty(drgform,uom,doseqty)
			s NumTimes=FreqFactor*DurFactor
			s TotalQty=NumTimes*dispqty
		}else{
			s NumTimes=1
			s ExeTList(NumTimes)=stttime
			s convFac=##class(web.DHCaOET).ConvFac(billuom,baseuom)
			s dispqty=PackQty*convFac
			s TotalQty=dispqty
			
		}
	}else{
		s NumTimes=1
		s ExeTList(NumTimes)=stttime
		i phqtyord="" s phqtyord=1
		s dispqty=phqtyord
		s TotalQty=phqtyord
	}
	
	;Set $ZT="ERROR^DHCSSERR"
	TS
	For i=1:1:NumTimes {
		k OEDISP 
		s OEDISP(2)=oeitm,OEDISP(5)=i
		s OEDISP(6)=dispqty,OEDISP(7)=baseuom,OEDISP(8)="TC",OEDISP(12)=dispqty
		s OEDISP(16)=Date,OEDISP(17)=Time
		S OEDISP(3)=TotalQty
		s OEDISP(21)=ExeTList(i)
 &SQL(Insert into SQLUser.DHC_OEDispensing values :OEDISP())
 }

 /* reserve^aOET1()已经有更新逻辑库存的处理
 s INCILrow=$$GetINCIL(INCIrow,recloc)
 i INCILrow'="" {
 s err=$$UpdRes(INCILrow,TotalQty)
	}
 */
	TC
	Q 0
}

/// lxz 处理门诊、住院批次和在途。  集成药房接口
/// desc 
/// ActiveType O门诊 I住院 处理类型
/// OEOrder 医嘱ID  OEOrderExec执行记录ID  
/// OrderActive 1 插入医嘱或执行记录  2 停止、撤销、作废执行记录或医嘱
/// ExpStr	RollOrderFlag^HosipitalDr... 
/// 			滚医嘱标志^医院ID...
/// 住院传入执行记录ID 门诊传入执行记录ID
/// return 0 成功 -1 失败
/// w ##class(web.DHCOEDispensing).PortForDurg("O","81||5","",2,"")
ClassMethod PortForDurg(ActiveType As %String, OEOrder As %String, OEOrderExec As %String, OrderActive As %String, ExpStr As %String)
{
	
	s ^lxz("PortForDurg")=ActiveType_","_OEOrder_","_OEOrderExec_","_OrderActive_","_ExpStr
	s $ZT="PortForDurgError"
	Q:(OEOrder="")&&(OEOrderExec="") "-1"
	Q:ActiveType="" "-2"
	Q:(OrderActive'=1)&&(OrderActive'=2) "-3"
	s ExecFlag="N"
	s Rtn=0
	s:OEOrderExec'="" ExecFlag="Y"
	s (Ord,Ord1,Ord2,OEDisping,HospitalId,RollOrderFlag)=""
	if ActiveType="I" d
	.s Ord=+OEOrderExec
	.s Ord1=$P(OEOrderExec,"||",2)
	.s Ord2=$P(OEOrderExec,"||",3)
	.s DSPRowId=$O(^DHCOEDISQTY(0,"OEORE",OEOrderExec,0))
	else  d
	.s Ord=+OEOrder
	.s Ord1=$P(OEOrder,"||",2)
	.s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",OEOrder,0))
	Q:(ActiveType="I")&&((+Ord=0)||(+Ord1=0)||(+Ord2=0)) "-4" ;住院必须传入有效的执行记录
	Q:(ActiveType'="I")&&((+Ord=0)||(+Ord1=0)) "-5" ;门诊必须传入有效的医嘱
	;获取扩展入参
	s RollOrderFlag=$P(ExpStr,"^",1)
	s HospitalId=$P(ExpStr,"^",2)	
	s arcim=$p($g(^OEORD(Ord,"I",Ord1,1)),"^",2)
	Q:arcim="" "-6"
	s arcgrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
 	s cattype=$p(^ARC("IC",arcgrp),"^",7)
 	s Adm=$P(^OEORD(Ord),"^",1)
	s admloc=$p(^PAADM(Adm),"^",4)
	s RecLocRowId=$P($G(^OEORD(Ord,"I",Ord1,3)),"^",6)
	s:HospitalId="" HospitalId=$p($G(^CTLOC(RecLocRowId)),"^",22) ;如果传入的为空先取接受科室
	s:HospitalId="" HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	;药品走批次价标识
	s DrugRuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospitalId)
	;材料走批次价标识
	s MaterialRuleFlag=##class(web.DHCSTMHUI.DHCSTMSERVICE).GetBatSpFlag(HospitalId,arcim)
	if (OrderActive="1"){
		;插入医嘱处理 ;(药房这边统一走一个接口，不再区分批次和非批次)
		if (ActiveType="I"){
			;住院 插入批次和在途
			 s ret=##Class(web.DHCSTINTERFACE).InsDspBatch(DSPRowId,RollOrderFlag)
			 if ret'=1 s Rtn="-101"
		 }else{
			;门诊 插入批次和在途
			 s ret=##CLass(web.DHCSTINTERFACE).InsDspBatchForOut(OEOrder)
			 if ret'=1 s Rtn="-102"
		 }
		/*;插入医嘱处理
		if ..IsEnableBatItem(arcim,Adm,HospitalId)=1{
		   ;批次
			 if (ActiveType="I"){
				;住院 插入批次和在途
				 s ret=##Class(web.DHCSTINTERFACE).InsDspBatch(DSPRowId,RollOrderFlag)
				 if ret'=1 s Rtn="-101"
			 }else{
				;门诊 插入批次和在途
				 s ret=##CLass(web.DHCSTINTERFACE).InsDspBatchForOut(OEOrder)
				 if ret'=1 s Rtn="-102"
			 }
		 
		}else{
			;非批次
			if (ActiveType="I"){
				 ;住院
				 s rtn=##class(web.DHCSTINTERFACE).SetOeResQty("",OEOrderExec,1)
				 if rtn'=0  s Rtn="-103"
			}else{
				;门诊
				 s rtn=##class(web.DHCSTINTERFACE).SetOeResQty(OEOrder,"",1)
				 if rtn'=0  s Rtn="-104"
				
			}
				
		}*/
	}elseif (OrderActive="2"){
		;撤销医嘱 取消在途
		if (ActiveType="I"){
			s rtn=##class(web.DHCSTINTERFACE).SetOeResQty("",OEOrderExec,2)
			if rtn'=0  s Rtn="-105"
		}else{
			s rtn=##class(web.DHCSTINTERFACE).SetOeResQty(OEOrder,"",2)
			if rtn'=0  s Rtn="-106"
		}
		
	}
	q Rtn
	
PortForDurgError
  q "-100"
}

/// creator:郭荣勇
/// date:2016-3-25
/// desc:是否是启用了批次价的医嘱项目
/// 0 不是,1 是
/// w ##class(web.DHCOEDispensing).IsEnableBatItem("1||1","",2)
ClassMethod IsEnableBatItem(ARCIMRowId As %String, EpisodeID As %String, HospitalId As %String = "") As %String
{
	Q:(ARCIMRowId="") 0
	s arcgrp=$p(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1),"^",10)
 	s cattype=$p(^ARC("IC",arcgrp),"^",7)
	i EpisodeID'="",HospitalId="" {
		s admloc=$p(^PAADM(EpisodeID),"^",4)
		s HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	}
	;药品走批次价标识
	s DrugRuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospitalId)
	;材料走批次价标识
	//s MaterialRuleFlag=##class(web.DHCSTM.DHCSTMSERVICE).GetBatSpFlag(HospitalId)
	s MaterialRuleFlag=##class(web.DHCSTMHUI.DHCSTMSERVICE).GetBatSpFlag(HospitalId,ARCIMRowId)
	 
	if ((+DrugRuleFlag=3)&&(cattype="R"))||((+MaterialRuleFlag=1)&&(cattype="M")){
		q 1
	}else{
		q 0
	}
}

}
