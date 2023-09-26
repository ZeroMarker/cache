Import sqluser

Class web.DHCSTMHUI.DHCStkMonReportLB Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 检索批次明细月报数据
/// Author:zhwh
/// Date:2012-11-03
/// Argu:
///   sm - 月报主表rowid, 类组rowid, 库存分类rowid, 物资描述, StrParam(资金来源id^类组标志(M/O)^...)
/// Return : inci, 物资代码,物资名称,规格,生产厂家,
/// 		单位,批次,本期结存数量,上期结存数量,本期结存金额(售价),
/// 		本期结存金额,上期结存金额(售价),上期结存金额,入库数量,入库金额(售价),
/// 		入库金额,退货数量,退货金额(售价),退货金额,转出数量,
/// 		转出金额(售价),转出金额,转入数量,转入金额(售价),转入金额,
/// 		调整数量,调整金额(售价),调整金额,报损数量,报损金额(售价),
/// 		报损金额,dispqty:%String,dispamt:%String,dispcoamt:%String,dspqty:%String,
/// 		dspamt:%String,dspcoamt:%String,dspretqty:%String,dspretamt:%String,dspretcoamt:%String,
/// 		调价损益(售价),调价损益,盘点调整数量,盘点调整金额(售价),盘点调整金额,
/// 		库存分类,类组,资金来源
/// 	d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonReportLB","StkMonRepLcBt",380,"","","","")
Query StkMonRepLcBt(Params As %List) As Query(ROWSPEC = "inci,incicode,incidesc,spec,manf,puomdesc,IBNO,qty:%Float,lastqty:%Float,amt:%Float,coamt:%Float,lastamt:%Float,lastcoamt:%Float,recqty:%Float,recamt:%Float,reccoamt:%Float,retqty:%Float,retamt:%Float,retcoamt:%Float,trfoqty:%Float,trfoamt:%Float,trfocoamt:%Float,trfiqty:%Float,trfiamt:%Float,trficoamt:%Float,adjqty:%Float,adjamt:%Float,adjcoamt:%Float,conqty:%Float,conamt:%Float,concoamt:%Float,dispqty:%Float,dispamt:%Float,dispcoamt:%Float,dspqty:%Float,dspamt:%Float,dspcoamt:%Float,dspretqty:%Float,dspretamt:%Float,dspretcoamt:%Float,aspamt:%Float,aspcoamt:%Float,stkqty:%Float,stkamt:%Float,stkcoamt:%Float,IncscDesc,ScgDesc,SourceOfFundDesc,diffQty:%Float,diffAmt:%Float,diffAmtRp:%Float,PuomRp:%Float,PuomSp:%Float") [ SqlProc ]
{
}

ClassMethod StkMonRepLcBtExecute(ByRef qHandle As %Binary, Params As %List) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s sm=PJobj.%Get("smRowid")
	q:sm="" $$$OK
	s stkgrpid=PJobj.%Get("stkgrpid")
	s stkcatid=PJobj.%Get("stkcatid") 
	s incdesc=PJobj.%Get("incdesc")
	s incid=PJobj.%Get("incid")
	s ScgType=PJobj.%Get("ScgType") ;类组类型(M:物资类组,O:财务类组)
	s:ScgType="" ScgType=..sssCode()
	s SourceFund=PJobj.%Get("SourceFund")
	k InclbInfoArr,InciInfoArr
	s MonLoc=$p(^DHCSM(sm),"^",1)
	s HospId=..sssHospId(MonLoc)
	s stkgrpid=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",stkgrpid,HospId)
	s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)
	s n=0 
	&sql(declare currx cursor for select 
		SMRLB_INCLB_DR,
		SMRLB_Qty,
		SMRLB_LastQty,
		SMRLB_Amount,SMRLB_CostAmount,
		SMRLB_LastAmount,SMRLB_LastCostAmount,
		SMRLB_Rec_Qty,SMRLB_Rec_Amt,SMRLB_Rec_CoAmt,
		SMRLB_Ret_Qty,SMRLB_Ret_Amt,SMRLB_Ret_CoAmt,
		SMRLB_Trfo_Qty,SMRLB_Trfo_Amt,SMRLB_Trfo_CoAmt,
		SMRLB_TrfI_Qty,SMRLB_TrfI_Amt,SMRLB_TrfI_CoAmt,
		SMRLB_Adj_Qty,SMRLB_Adj_Amt,SMRLB_Adj_CoAmt,
		SMRLB_Cons_Qty,SMRLB_Cons_Amt,SMRLB_Cons_CoAmt,
		SMRLB_Disp_Qty,SMRLB_Disp_Amt,SMRLB_Disp_CoAmt,
		SMRLB_Dsp_Qty,SMRLB_Dsp_Amt,SMRLB_Dsp_CoAmt,
		SMRLB_PhaRet_Qty,SMRLB_PhaRet_Amt,SMRLB_PhaRet_CoAmt,
		SMRLB_Asp_Amt,SMRLB_Asp_CoAmt,SMRLB_StkTk_Qty,
		SMRLB_StkTk_Amt,SMRLB_StkTk_CoAmt 
		from DHC_StkMonRepLcBt
		where SMRLB_SMR_Parref->SMR_sm_Parref=:sm
		order by SMRLB_SMR_Parref->SMR_sm_Parref,
		SMRLB_SMR_Parref->SMR_Childsub,SMRLB_Childsub  )
	&sql(open currx)                
	f  &sql(fetch currx into :INCLB, 
		:qty,:lastqty,
		:amt,:coamt,
		:lastamt,:lastcoamt,
		:recqty,:recamt,:reccoamt,
		:retqty,:retamt,:retcoamt,
		:trfoqty,:trfoamt,:trfocoamt,
		:trfiqty,:trfiamt,:trficoamt,   
		:adjqty,:adjamt,:adjcoamt,
		:conqty,:conamt,:concoamt,
		:dispqty,:dispamt,:dispcoamt,
		:dspqty,:dspamt,:dspcoamt,
		:dspretqty,:dspretamt,:dspretcoamt,
		:aspamt,:aspcoamt,:stkqty,:stkamt,:stkcoamt) q:SQLCODE  d
	.q:INCLB=""
	.s INCI=+INCLB
	.s tmp=^INCI(INCI,1)
	.q:(incid'="")&(incid'=INCI)			;库存项不符
	.s incicode=$p(tmp,"^",1)
	.s incidesc=$p(tmp,"^",2)
	.
	.i '$d(InciInfoArr(INCI)) d
	..s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(INCI,ScgType)
	..s ScgDesc=$p(stkgrpinfo,"^",2)
	..s grpid=$p(stkgrpinfo,"^",5)
	..s stkcat=$p(^INCI(INCI,2),"^",2)
	..s IncscDesc=$s(stkcat'="":$p(^INC("SC",stkcat),"^",2),1:"")
	..s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",INCI)
	..s InciInfoArr(INCI)=grpid_"^"_ScgDesc_"^"_stkcat_"^"_IncscDesc_"^"_spec
	.
	.s InciInfo=InciInfoArr(INCI)
	.s grpid=$p(InciInfo,"^",1)
	.s ScgDesc=$p(InciInfo,"^",2)
	.s stkcat=$p(InciInfo,"^",3)
	.s IncscDesc=$p(InciInfo,"^",4)
	.s spec=$p(InciInfo,"^",5)
	.
	.q:(stkgrpid'="")&&(("^"_stkgrpid_"^")'[("^"_grpid_"^"))
	.q:(stkcatid'="")&(stkcat'=stkcatid)  
	.q:(incdesc'="")&('$f(incidesc,incdesc))
	.
	.;根据科室类组权限的"月报标记"做过滤
	.q:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_stkcat_"^"))
	.
	.s basicuom=$p(tmp,"^",10)
	.s puom=$p(^INCI(INCI,3),"^",6)
	.i puom="" s puom=basicuom
	.s puomdesc=$p(^CT("UOM",puom),"^",2)
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,basicuom)
	.
	.s qty=qty/fac,lastqty=lastqty/fac
	.s recqty=recqty/fac,retqty=retqty/fac
	.s trfoqty=trfoqty/fac,trfiqty=trfiqty/fac
	.s adjqty=adjqty/fac,conqty=conqty/fac
	.s dispqty=dispqty/fac,dspqty=dspqty/fac,dspretqty=dspretqty/fac
	.s stkqty=stkqty/fac
	.
	.i '$d(InclbInfoArr(INCLB)) d
	..s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(INCLB)
	..s IBNO=$p(BatExp,"^",1)
	..s SourceOfFundInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb(INCLB)
	..s SourceOfFund=$p(SourceOfFundInfo,"^",1)
	..s SourceOfFundDesc=$p(SourceOfFundInfo,"^",2)
	..s manf=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(INCLB),"^",2)
	..s PuomRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(INCLB,puom,HospId)
	..s PuomSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(INCLB,+$h,puom,HospId)
	..s InclbInfoArr(INCLB)=IBNO_"^"_SourceOfFund_"^"_SourceOfFundDesc_"^"_manf_"^"_PuomRp_"^"_PuomSp
	.
	.s InclbInfo=InclbInfoArr(INCLB)
	.s IBNO=$p(InclbInfo,"^",1)
	.s SourceOfFund=$p(InclbInfo,"^",2)
	.s SourceOfFundDesc=$p(InclbInfo,"^",3)
	.s manf=$p(InclbInfo,"^",4)
	.s PuomRp=$p(InclbInfo,"^",5)
	.s PuomSp=$p(InclbInfo,"^",6)
	.q:(SourceFund'="")&&(SourceOfFund'=SourceFund)
	.s diffQty=lastqty+recqty+retqty+trfoqty+trfiqty+adjqty+conqty-qty+stkqty
	.s diffAmt=lastamt+recamt+retamt+trfoamt+trfiamt+adjamt+conamt+aspamt-amt+stkamt
	.s diffAmtRp=lastcoamt+reccoamt+retcoamt+trfocoamt+trficoamt+adjcoamt+concoamt+aspcoamt-coamt+stkcoamt
	.s coamt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(coamt,HospId)
	.s amt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(amt,HospId)
	.s diffAmtRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(diffAmtRp,HospId)
	.s diffAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(diffAmt,HospId)
	.s n=n+1
	.d OutPutRow
	.
	&sql(close currx)
	Quit $$$OK

OutPutRow
	s Data=$lb(INCI,incicode,incidesc,spec,manf,
		puomdesc,IBNO,+qty,+lastqty,+amt,
		+coamt,+lastamt,+lastcoamt,+recqty,+recamt,
		+reccoamt,+retqty,+retamt,+retcoamt,+trfoqty,
		+trfoamt,+trfocoamt,+trfiqty,+trfiamt,+trficoamt,
		+adjqty,+adjamt,+adjcoamt,+conqty,+conamt,
		+concoamt,+dispqty,+dispamt,+dispcoamt,+dspqty,
		+dspamt,+dspcoamt,+dspretqty,+dspretamt,+dspretcoamt,
		+aspamt,+aspcoamt,+stkqty,+stkamt,+stkcoamt,
		IncscDesc,ScgDesc,SourceOfFundDesc,diffQty,diffAmt,
		diffAmtRp,PuomRp,PuomSp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
