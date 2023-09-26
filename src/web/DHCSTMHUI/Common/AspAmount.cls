Import sqluser

/// 该类主要是补充调价损益
Class web.DHCSTMHUI.Common.AspAmount Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 判断业务价格与调价表数据是否一致，不一致生成调价损益
/// 2021-05--10
/// hsc
ClassMethod CreateAdjAmount(lstData As %String, tranId As %String) As %String
{
	n (lstData,tranId)
	s Ret=0
	s Type=$p(lstData,"^",1)       		;INTR_Type
	s Inclb=$p(lstData,"^",3)      		;INCLBRowID
	s Inci=+Inclb
	s Qty=+$p(lstData,"^",4)        		;INTR_Qty
	s UomId=$p(lstData,"^",5)        	;Itm_UOM DESC
	s Sp=+$p(lstData,"^",6)    			;sp
	s UserId=$p(lstData,"^",7)    
	s Rp=$p(lstData,"^",9)    ;进价
	s LocId=$p(^INCI(Inci,"IL",$p(Inclb,"||",2)),"^",1)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Buomdr=$p(^INCI(Inci,1),"^",10)	;基本单位
	s bfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,Buomdr)
	s bRp=Rp/bfac
	s bSp=Sp/bfac
	s Qty=Qty*bfac
	;取是否走批次售价
	;类型判断
	q:Type="G" 0
	s BatSpFlag=..sssBatSpFlag(HospId,Inci)
	
	i BatSpFlag=0 d
	.s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceToAspAmount(Inci,+$h,Buomdr,HospId)	//统一售价
	.s AdjbSp=$P(RetStr,"^",1)
	.q:bSp=AdjbSp
	.s diffSp=AdjbSp-bSp
	.s AspId=$P(RetStr,"^",2)
	.i AspId="" d
	..;插入调价记录（已生效）
	..s AdjDate=$p($h,",",1)			;调价日期
	..s StkCatId=$p(^INCI(Inci,2),"^",2)
	..S PuomDr=$P(^INCI(Inci,3),"^",6)
	..s PriorSp=0
	..s PriorRp=0
	..s ResultSp=0
	..s PreExDate=+$h
	..s ExecuteDate=+$h
	..s AdjSPCat="调价"
	..s Status="Yes"
	..s AuditDate=+$h
	..s AuditTime=$p($h,",",2)
	..s AdjspNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo("DHCSTADJSPM","",LocId)
	..&sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,inasp_resultsp,
		inasp_ssusr_dr,inasp_status,inasp_no,inasp_ctuom_dr,inasp_ctuom_price,
		INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,INASP_PreExeDate,INASP_ExecuteDate,INASP_Cat
		,INASP_AuditUser,INASP_AuditDate,INASP_Audittime,INASP_StartUser_dr) 
	  values(:AdjDate,:Inci,:StkCatId,:PriorSp,:PriorSp,
		:UserId,:Status,:AdjspNo,:PuomDr,:PriorRp,
		:PriorRp,:PriorRp,:PriorRp,:HospId,
		:PreExDate,:ExecuteDate,:AdjSPCat,
		:UserId,:AuditDate,:AuditTime,:UserId))
	..i SQLCODE=0 d
	..i SQLCODE'=0  d
	...s Ret=-21
	..q:Ret'=0 
	..s AspId=$p(%ROWID,$c(1))
	.q:Ret'=0
	.s Ret=..NormalAspAmount(AspId,Qty,Inclb,diffSp,bRp,tranId)
	.i Ret<0 d
	..s Ret=-22
	e  d
	.s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByInclb(Inclb,+$h,Buomdr,HospId) //批次进价,按批次调价表
	.s AdjbRp=+$p(RetStr,"^",1)
	.S AdjbSp=+$p(RetStr,"^",2)
	.s AspId=$p(RetStr,"^",5)
	.q:(bSp=AdjbSp)&&(bRp=AdjbRp)
	.s diffRp=AdjbRp-bRp
	.s diffSp=AdjbSp-bSp
	.s Ret=..BatchAspAmount(AspId,Qty,Inclb,diffSp,diffRp,bRp,UserId,tranId)
	.i Ret<0 d
	..s Ret=-23
	q Ret
}

/// 普通调价损益
ClassMethod NormalAspAmount(RowId As %String, diffQty As %String, inclb As %String, diffSp As %String, PriorRp As %String, tranId As %String)
{
	n (RowId,diffQty,inclb,diffSp,PriorRp,tranId)
	s Ret=0
	s type="YW"
	s CurDate=$p($h,",",1)
	s CurTime=$p($h,",",2)
	s AspNo=$p(^INASP(RowId),"^",5)
	s InciId=$p(^INASP(RowId),"^",4)
	s AdjUserId=$p(^INASP(RowId),"^",3)
	s PriorRp=$p(^INASP(RowId),"^",15)
	s HospId=$p(^INASP(RowId),"^",20)	;	;医院id
	s LocId=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    s SpAmt=diffQty*diffSp
	s RpAmt=0
	s DiffRp=0
	S SpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	S RpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	&sql(insert into dhc_aspamount(aspa_no,aspa_ctloc_dr,aspa_adjprice,aspa_inasp_dr,
	  aspa_inci_dr,aspa_stkqty,aspa_amount,aspa_date,aspa_time,aspa_ssusr_dr,ASPA_AdjRP,ASPA_RPAmt,ASPA_ASPTran_Dr,ASPA_TranType)
	  values(:AspNo,:LocId,:diffSp,:RowId,
	  :InciId,:diffQty,:SpAmt,:CurDate,:CurTime,:AdjUserId,:DiffRp,:RpAmt,:tranId,:type))  
	i SQLCODE'=0  d
	.s Ret=-1
	q:Ret'=0 Ret
	s AspaId=$p(%ROWID,$c(1))  
	s AspalbCh=1+$o(^ASPA(AspaId,"LB",""),-1)
	&sql(insert into Dhc_AspAmountLB (aspalb_aspa_parref,aspalb_childsub,aspalb_inclb_dr,
	    aspalb_qty,aspalb_adjdiff,aspalb_adjamt,ASPALB_AdjRP,ASPALB_RPAmt,ASPALB_PriorRP)
	    values(:AspaId,:AspalbCh,:inclb,
	    :diffQty,:diffSp,:SpAmt,:DiffRp,:RpAmt,:PriorRp) )
	i SQLCODE'=0  d
	.s Ret=-2
	q:Ret'=0 Ret
	q AspaId
}

ClassMethod BatchAspAmount(ApbId As %String, diffQty As %String, inclb As %String, diffSp As %String, diffRp As %String, PriorRp As %String, UserId As %String, tranId As %String) As %Library.String
{
	n (ApbId,diffQty,inclb,diffSp,diffRp,PriorRp,UserId,tranId)
	s Ret=0
	s CurDate=$p($h,",",1)
	s CurTime=$p($h,",",2)
	s AspBatNo=$p(^DHCSTINAPB(ApbId),"^",2)
	s type="YW"
	s HospId=$p(^DHCSTINAPB(ApbId),"^",1)
	s LocId=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	s Incib=$p(^DHCSTINAPB(ApbId),"^",4)
	s Inci=$o(^INCI("LB_IB",Incib,""))
	s SpAmt=diffQty*diffSp
	s RpAmt=diffQty*diffRp
	S SpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	S RpAmt=+##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	&sql(insert into DHC_ASPAmount
       (ASPA_No,ASPA_CTLOC_DR,ASPA_AdjPrice,ASPA_INCI_DR,ASPA_StkQty,ASPA_Amount,
         ASPA_Date,ASPA_Time,ASPA_SSUSR_DR,ASPA_AdjRP,ASPA_RPAmt,ASPA_INAPB_Dr,
         ASPA_INCLB_Dr,ASPA_ASPTran_Dr,ASPA_TranType) 
        values(:AspBatNo,:LocId,:diffSp,:Inci,:diffQty,:SpAmt,
               :CurDate,:CurTime,:UserId,:diffRp,:RpAmt,:ApbId,
               :inclb,:tranId,:type) )
 	i SQLCODE'=0 d
	.s Ret=-1
	q:Ret'=0 Ret
	s AspaId=$p(%ROWID,$c(1))
 	s AspalbAspaParref=AspaId
 	s AspalbChildsub=$o(^ASPA(AspaId,"LB",""),-1)+1
	&sql(insert into DHC_ASPAmountLB
        (ASPALB_ASPA_Parref,ASPALB_Childsub,ASPALB_INCLB_DR,ASPALB_Qty,
         ASPALB_AdjDiff,ASPALB_AdjAmt,ASPALB_AdjRP,ASPALB_RPAmt,
         ASPALB_PriorRP)
      	values(:AspalbAspaParref,:AspalbChildsub,:inclb,:diffQty,
         :diffSp,:SpAmt,:diffRp,:RpAmt,
         :PriorRp) )
	
	i SQLCODE'=0  d
	.s Ret=-2
	q:Ret'=0 Ret
	q AspaId
}

/// 获取某科室库存项最后一个台账
/// w ##class(web.DHCSTMHUI.Common.AspAmount).getLastINCLocTrans(198,28)
ClassMethod getLastINCLocTrans(loc As %String, inci As %String) As %String
{
	n (loc,inci)
	q:loc="" ""
	s ch=$o(^INCI("IL_LOC",loc,inci,""))
	q:ch="" ""
	s incil=inci_"||"_ch
	s rowid=""
	s type=""
	f  s type=$o(^DHCINTR(0,"ILTYPEDATE",incil,type)) q:type=""  d
	.s lastdate=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,+$h+1),-1)
	.q:lastdate=""
	.s trid=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,lastdate,""),-1)
	.q:trid=""
	.i rowid="" d
	..s rowid=trid
	.e  d
	..i trid>rowid d
	...s rowid=trid
	q rowid
}

}
