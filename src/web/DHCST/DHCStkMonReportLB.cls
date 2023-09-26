Import sqluser

Class web.DHCST.DHCStkMonReportLB Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 查询月报明细
/// Author:zhangdongmei
/// Date:2012-11-26
/// Argu:
///   Parref - 月报主表id
/// Return:
///  Json数据串
///  
ClassMethod jsStkMonRepLcBt(Parref As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %String
{
	n (Parref,stkgrpid,stkcatid,incdesc)
	q:Parref="" ""
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCStkMonReportLB:StkMonRepLcBt")
	s sc=result.Execute(Parref,stkgrpid,stkcatid,incdesc)	 
	i $$$ISERR(sc) q ""

	s colNum=result.GetColumnCount()
	s count = 0
	s tmp=""
	w "{results:999,rows:["
	While(result.Next())
	{ 
		i tmp'=""  d
		.w "{"_tmp_"},"     //输出上一条记录
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.GetColumnName(i)_":'"_result.%GetData(i)_"'"
		.e   s ret=ret_","_result.GetColumnName(i)_":'"_result.%GetData(i)_"'"

		s tmp=ret
		s count = count+1
	}
	//输出最后一条记录
	i tmp'="" w "{"_tmp_"}"
	w "]}"
	d result.Close()
	q
}

/// 检索批次明细月报数据
/// Author:zhwh
/// Date:2012-11-03
/// Argu:
///   sm - 月报主表rowid
/// dispamt是报损,dspamt是发药
Query StkMonRepLcBt(sm As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %Query(ROWSPEC = "incicode:%String,incidesc:%String,spec:%String,manf:%String,puomdesc:%String,IBNO:%String,qty:%String,lastqty:%String,amt:%String,coamt:%String,lastamt:%String,lastcoamt:%String,recqty:%String,recamt:%String,reccoamt:%String,retqty:%String,retamt:%String,retcoamt:%String,trfoqty:%String,trfoamt:%String,trfocoamt:%String,trfiqty:%String,trfiamt:%String,trficoamt:%String,adjqty:%String,adjamt:%String,adjcoamt:%String,conqty:%String,conamt:%String,concoamt:%String,dispqty:%String,dispamt:%String,dispcoamt:%String,dspqty:%String,dspamt:%String,dspcoamt:%String,dspretqty:%String,dspretamt:%String,dspretcoamt:%String,aspamt:%String,aspcoamt:%String,phaoutdispqty:%String,phaoutdispamt:%String,phaoutdispcoamt:%String,phaoutretqty:%String,phaoutretamt:%String,phaoutretcoamt:%String,recaspamt:%String,recaspcoamt:%String,trfinaspamt:%String,trfinaspcoamt:%String,retaspamt:%String,retaspcoamt:%String,pharetaspamt:%String,pharetaspcoamt:%String,phaoutretaspamt:%String,phaoutretaspcoamt:%String,stktkqty:%String,stktkamt:%String,stktkcoamt:%String,phaoutdispaspamt:%String,phadispaspamt:%String,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO") [ SqlProc ]
{
}

ClassMethod StkMonRepLcBtExecute(ByRef qHandle As %Binary, sm As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)

 q:sm="" ""
 
 //获取报表中主数据的输出
 s DataStr=##class(web.DHCST.DHCStkMonRepQuery).GetMianInfo(sm)
 s locDescIO=$P(DataStr,"^",1)
 s hospDescIO=$P(DataStr,"^",2)
 s UserDescIO=$P(DataStr,"^",3)
 s CreateDateIO=$P(DataStr,"^",4)
 s CreateTimeIO=$P(DataStr,"^",5)
 s FrDateIO=$P(DataStr,"^",6)
 s FrTimeIO=$P(DataStr,"^",7)
 s ToDateIO=$P(DataStr,"^",8)
 s ToTimeIO=$P(DataStr,"^",9)
 // locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO
 ;
 s n=0 
 s LocId=$p(^DHCSM(sm),"^",1)
 s HospId=$p(^CTLOC(LocId),"^",22)
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
 SMRLB_Asp_Amt,SMRLB_Asp_CoAmt,
 SMRLB_DspO_Qty,SMRLB_DspO_Amt,SMRLB_DspO_CoAmt,
 SMRLB_PhoRet_Qty,SMRLB_PhoRet_Amt,SMRLB_PhoRet_CoAmt,
 SMRLB_RecAsp_Amt,SMRLB_RecAsp_CoAmt,
 SMRLB_TrfIAsp_Amt,SMRLB_TrfIAsp_CoAmt,
 SMRLB_RetAsp_Amt,SMRLB_RetAsp_CoAmt,
 SMRLB_PhaRetAsp_Amt,SMRLB_PhaRetAsp_CoAmt,
 SMRLB_PhoRetAsp_Amt,SMRLB_PhoRetAsp_CoAmt,
 SMRLB_StkTk_Qty,SMRLB_StkTk_Amt,SMRLB_StkTk_CoAmt from DHC_StkMonRepLcBt
 where SMRLB_SMR_Parref->SMR_sm_Parref=:sm
 order by SMRLB_SMR_Parref->SMR_sm_Parref,
      SMRLB_SMR_Parref->SMR_Childsub,SMRLB_Childsub  )
 ;                               
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
 :aspamt,:aspcoamt,
 :phaoutdispqty,:phaoutdispamt,:phaoutdispcoamt,
 :phaoutretqty,:phaoutretamt,:phaoutretcoamt,
 :recaspamt,:recaspcoamt,
 :trfinaspamt,:trfinaspcoamt,
 :retaspamt,:retaspcoamt,
 :pharetaspamt,:pharetaspcoamt,
 :phaoutretaspamt,:phaoutretaspcoamt,
 :stktkqty,:stktkamt,:stktkcoamt  ) q:SQLCODE  d
 . q:INCLB=""
 . s INCI=+INCLB
 . s tmp=^INCI(INCI,1)
 . s incicode=$p(tmp,"^",1)
 . s incidesc=$p(tmp,"^",2)
 . s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(INCI)
 .s grpid=$p(stkgrpinfo,"^",5)
 .q:(stkgrpid'="")&(grpid'=stkgrpid)
 .s stkcat=$p(^INCI(INCI,2),"^",2)
 .q:(stkcatid'="")&(stkcat'=stkcatid)  
 .q:(incdesc'="")&('$f(incidesc,incdesc))
 .
 . s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",INCI)
 . s manf=$P(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(INCLB),"^",2)
 . s basicuom=$p(tmp,"^",10)
 . s puom=$p(^INCI(INCI,3),"^",6)
 . i puom="" s puom=basicuom
 . s puomdesc=$p(^CT("UOM",puom),"^",2)
 . s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,basicuom)
 . 
 . s qty=qty/fac,lastqty=lastqty/fac
 . s recqty=recqty/fac,retqty=retqty/fac
 . s trfoqty=trfoqty/fac,trfiqty=trfiqty/fac
 . s adjqty=adjqty/fac,conqty=conqty/fac
 . s dispqty=dispqty/fac,dspqty=dspqty/fac,dspretqty=dspretqty/fac
 . s phaoutdispqty=phaoutdispqty/fac,phaoutretqty=phaoutretqty/fac
 . s stktkqty=stktkqty/fac 
 . s INCIB=$p(^INCI(INCI,"IL",$p(INCLB,"||",2),"LB",$p(INCLB,"||",3)),"^",1)
 . q:$p(INCIB,"||",2)="" 
 . s IBNO=""
 . i INCIB'="" s IBNO=$p(^INCI(INCI,"IB",$p(INCIB,"||",2)),"^",1)
 . s n=n+1
 . //add wyx 2014-02-11
 . s amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(amt,HospId)
 . s lastamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(lastamt,HospId)
 . s lastcoamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(lastcoamt,HospId)
 . s coamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(coamt,HospId)
 . s qty=##class(web.DHCST.Common.AppCommon).FormatSq(qty,HospId,1,"G")
 . s lastqty=##class(web.DHCST.Common.AppCommon).FormatSq(lastqty,HospId,1,"G")
 . s phaoutdispaspamt=0
 . s phadispaspamt=0
 . d OutPutRow
 . 
 &sql(close currx)
 Quit $$$OK
 
OutPutRow
 s Data=$lb(incicode,incidesc,spec,manf,puomdesc,IBNO,+qty,+lastqty,+amt,+coamt,+lastamt,+lastcoamt,+recqty,+recamt,+reccoamt,+retqty,+retamt,+retcoamt,+trfoqty,+trfoamt,+trfocoamt,+trfiqty,+trfiamt,+trficoamt,+adjqty,+adjamt,+adjcoamt,+conqty,+conamt,+concoamt,+dispqty,+dispamt,+dispcoamt,+dspqty,+dspamt,+dspcoamt,+dspretqty,+dspretamt,+dspretcoamt,+aspamt,+aspcoamt, +phaoutdispqty,+phaoutdispamt,+phaoutdispcoamt,+phaoutretqty,+phaoutretamt,+phaoutretcoamt,+recaspamt,+recaspcoamt,+trfinaspamt,+trfinaspcoamt,+retaspamt,+retaspcoamt,+pharetaspamt,+pharetaspcoamt,+phaoutretaspamt,+phaoutretaspcoamt,+stktkqty,+stktkamt,+stktkcoamt,+phaoutdispaspamt,+phadispaspamt,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod StkMonRepLcBtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StkMonRepLcBtExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StkMonRepLcBtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StkMonRepLcBtExecute ]
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

}
