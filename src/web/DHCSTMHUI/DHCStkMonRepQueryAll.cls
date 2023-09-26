Import sqluser

Class web.DHCSTMHUI.DHCStkMonRepQueryAll Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Creator:	wangjiabin
/// CreatDate:	2017-08-03
/// Description:全院临床科室的月报
/// Input:		库存项ID
/// Return:		类组代码^类组描述^类组类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonRepQueryAll","StkMonRepItmRpAll","2020-02")
Query StkMonRepItmRpAll(StrParam As %String) As websys.Query(ROWSPEC = "LocDesc,sm,smr,inciCode,inciDesc,spec,uomDesc,qty:%Float,amt:%Float,lastQty:%Float,lastAmt:%Float,recQty:%Float,recAmt:%Float,retQty:%Float,retAmt:%Float,trOutQty:%Float,trOutAmt:%Float,trInQty:%Float,trInAmt:%Float,adjQty:%Float,adjAmt:%Float,csmQty:%Float,csmAmt:%Float,disposeQty:%Float,disposeAmt:%Float,phaInDspQty:%Float,phaInDspAmt:%Float,aspAmt:%Float,phaInRetQty:%Float,phaInRetAmt:%Float,phaOutDspQty:%Float,phaOutDspAmt:%Float,phaOutDspQtyS:%Float,phaOutDspAmtS:%Float,phaOutRetQty:%Float,phaOutRetAmt:%Float,phaOutRetQtyZ:%Float,phaOutRetAmtZ:%Float,giftRecQty:%Float,giftRecAmt:%Float,giftTrOutQty:%Float,giftTrOutAmt:%Float,chgRecQty:%Float,chgRecAmt:%Float,chgRetQty:%Float,chgRetAmt:%Float,retAspAmt:%Float,phaRetAspAmt:%Float,mRecQty:%Float,mRecAmt:%Float,stktkAdjQty:%Float,stktkAdjAmt:%Float,manuXQty:%Float,manuXAmt:%Float,manuMQty:%Float,manuMAmt:%Float,phaOutRetAspAmt:%Float,trInAspAmt:%Float,IncscDesc,ScgDesc,ScgSet") [ SqlProc ]
{
}

ClassMethod StkMonRepItmRpAllExecute(ByRef qHandle As %Binary, StrParam As %String) As %Status
{
	n (qHandle,StrParam)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s SMMonth=$P(StrParam,"^",1)
    s StkType=..sssCode()
	
	s year=$P(SMMonth,"-",1)
	s month=$P(SMMonth,"-",2)
	s tmpym=year_"-"_month
	
	s stkgrpid=""
	s stkcatid=""
	s incdesc=""
	s PhaLocId=""
	s ScgSetStr=""
	s HV=""
	
	s SMMonth=$zdh(tmpym_"-01",3)
	k InciInfoArr
	s LocId=0
	f  s LocId=$o(^DHCSM(0,"MLOC",SMMonth,LocId)) q:LocId=""  d
	.q:(PhaLocId'="")&&(LocId'=PhaLocId)
	.;s IsMatMonLoc=##class(web.DHCSTMHUI.DHCStkMon).IsMatMonLoc(LocId)
	.;q:IsMatMonLoc'="Y"
	.s sm=$o(^DHCSM(0,"TML",StkType,SMMonth,LocId,0))
	.q:sm=""
	.s LocDesc=$p(^CTLOC(LocId),"^",2)
	.
	.s ch=0
	.f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	..s smr=sm_"||"_ch
	..s row=^DHCSM(sm,"R",ch)
	..s inci=$p(row,"^",3)
	..
	..s InciInfo=$$GetInciInfo(inci)
	..s inciCode=$p(InciInfo,"^",1)
	..s inciDesc=$p(InciInfo,"^",2)
	..s spec=$p(InciInfo,"^",3)
	..s inciuomdr=$p(InciInfo,"^",4)
	..s puruom=$p(InciInfo,"^",5)
	..s uomDesc=$p(InciInfo,"^",6)
	..s fac=$p(InciInfo,"^",7)
	..s stkcat=$p(InciInfo,"^",8)
	..s IncscDesc=$p(InciInfo,"^",9)
	..s grpid=$p(InciInfo,"^",10)
	..s ScgDesc=$p(InciInfo,"^",11)
	..s ScgType=$p(InciInfo,"^",12)
	..s ScgSet=$p(InciInfo,"^",13)
	..s HVFlag=$p(InciInfo,"^",14)
	..q:ScgType'=StkType
	..q:(ScgSetStr'="")&&((","_ScgSetStr_",")'[(","_ScgSet_","))
	..q:(stkgrpid'="")&(grpid'=stkgrpid)
	..q:(stkcatid'="")&(stkcat'=stkcatid)
	..q:(incdesc'="")&('$f(inciDesc,incdesc))
	..q:(HV'="")&&(HVFlag'=HV)
	..
	..s qty=$p(row,"^",6)
	..s qty=qty/fac
	..s amt=$p(row,"^",8)					;costamount
	..s lastQty=$p(row,"^",9)				;qty of last month
	..s lastQty=lastQty/fac
	..s lastAmt=$p(row,"^",11)				;costamount of last month
	..
	..s stat=$o(^SMSTATI(0,"SMR",smr,""))
	..q:stat=""
	..s stats=$G(^SMSTATI(stat))
	..
	..s recQty=$P(stats,"^",2)/fac			;入库数量
	..s recAmt=$P(stats,"^",3)				;入库金额
	..s retQty=$P(stats,"^",4)/fac			;退货数量
	..s retAmt=$P(stats,"^",5)				;退货金额
	..s trOutQty=$P(stats,"^",6)/fac		;转出数量
	..s trOutAmt=$P(stats,"^",7)			;转出金额
	..s trInQty=$P(stats,"^",8)/fac			;转入数量
	..s trInAmt=$P(stats,"^",9)				;转入金额
	..s adjQty=$P(stats,"^",10)/fac			;库存调整数量
	..s adjAmt=$P(stats,"^",11)				;库存调整金额
	..s csmQty=$P(stats,"^",12)/fac			;发放数量
	..s csmAmt=$P(stats,"^",13)				;发放金额
	..s disposeQty=$P(stats,"^",14)/fac		;报损数量
	..s disposeAmt=$P(stats,"^",15)			;报损金额
	..s phaInDspQty=$P(stats,"^",16)/fac	;发药数量(住院)
	..s phaInDspAmt=$P(stats,"^",17)		;发药金额(住院)
	..s aspAmt=$P(stats,"^",18)				;调价损益金额
	..s phaInRetQty=$P(stats,"^",19)/fac	;退药数量(住院)
	..s phaInRetAmt=$P(stats,"^",20)		;退药金额(住院)
	..s giftRecQty=$P(stats,"^",21)/fac		;入库数量(赠品)
	..s giftRecAmt=$P(stats,"^",22)			;入库(赠品)
	..s giftTrOutQty=$P(stats,"^",23)/fac	;转出数量(赠品)
	..s giftTrOutAmt=$P(stats,"^",24)		;转出金额(赠品)
	..s chgRecQty=$P(stats,"^",25)/fac		;入库数量(调价换票)
	..s chgRecAmt=$P(stats,"^",26)			;入库金额(调价换票)
	..s chgRetQty=$P(stats,"^",27)/fac		;退货数量(调价换票)
	..s chgRetAmt=$P(stats,"^",28)			;退货金额(调价换票)
	..
	..s phaOutDspQty=$P(stats,"^",29)/fac	;发药数量(门诊)
	..s phaOutDspAmt=$P(stats,"^",30)		;发药金额(门诊)
	..s phaOutDspQtyS=$P(stats,"^",31)/fac	;发药数量(门诊非正常)
	..s phaOutDspAmtS=$P(stats,"^",32)		;发药金额(门诊非正常)
	..
	..s phaOutRetQty=$P(stats,"^",33)/fac	;退药数量(门诊)
	..s phaOutRetAmt=$P(stats,"^",34)		;退药金额(门诊)
	..s phaOutRetQtyZ=$P(stats,"^",35)/fac	;退药数量(门诊非正常)
	..s phaOutRetAmtZ=$P(stats,"^",36)		;退药金额量(门诊非正常)
	..
	..s trInAspAmt=$P(stats,"^",38)			;库存转入调价损益
	..s retAspAmt=$P(stats,"^",39)			;退货调价损益
	..s stktkAdjQty=$P(stats,"^",40)/fac	;盘点调整数量
	..s stktkAdjAmt=$P(stats,"^",41)		;盘点调整金额 
	..s manuXQty=$P(stats,"^",42)/fac
	..s manuXAmt=$P(stats,"^",43)
	..s manuMQty=$P(stats,"^",44)/fac
	..s manuMAmt=$P(stats,"^",45)
	..s mRecQty=$P(stats,"^",46)/fac
	..s mRecAmt=$P(stats,"^",47)
	..s phaOutRetAspAmt=$P(stats,"^",48)	;门诊退药调价损益
	..s phaRetAspAmt=$P(stats,"^",49)		;住院退药调价损益
	..
	..d OutPutRowR
	
	k InciInfoArr
	Quit $$$OK

OutPutRowR
	s Data=$lb(LocDesc,sm,smr,
		inciCode,inciDesc,spec,uomDesc,qty,
		amt,lastQty,lastAmt,recQty,recAmt,
		retQty,retAmt,trOutQty,trOutAmt,trInQty,
		trInAmt,adjQty,adjAmt,csmQty,csmAmt,
		disposeQty,disposeAmt,phaInDspQty,phaInDspAmt,aspAmt,
		phaInRetQty,phaInRetAmt,phaOutDspQty,phaOutDspAmt,phaOutDspQtyS,
		phaOutDspAmtS,phaOutRetQty,phaOutRetAmt,phaOutRetQtyZ,phaOutRetAmtZ,
		giftRecQty,giftRecAmt,giftTrOutQty,giftTrOutAmt,chgRecQty,
		chgRecAmt,chgRetQty,chgRetAmt,retAspAmt,phaRetAspAmt,
		mRecQty,mRecAmt,stktkAdjQty,stktkAdjAmt,manuXQty,
		manuXAmt,manuMQty,manuMAmt,phaOutRetAspAmt,trInAspAmt,
		IncscDesc,ScgDesc,ScgSet
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

GetInciInfo(Inci)
	q:$d(InciInfoArr(inci)) InciInfoArr(inci)
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgId=$p(ScgInfo,"^",5)
	s ScgDesc=$p(ScgInfo,"^",2)
	s ScgType=$p(ScgInfo,"^",3)
	s ScgSet=$p(ScgInfo,"^",7)
	s Incsc=$p(^INCI(Inci,2),"^",2)
	s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s PUomId=$p(^INCI(Inci,3),"^",6)
	i PUomId="" s PUomId=BUomId
	s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	s InciInfoArr(inci)=InciCode_"^"_InciDesc_"^"_Spec_"^"_BUomId_"^"_PUomId
		_"^"_PUomDesc_"^"_UomFac_"^"_Incsc_"^"_IncscDesc_"^"_ScgId
		_"^"_ScgDesc_"^"_ScgType_"^"_ScgSet_"^"_HVFlag
	q InciInfoArr(inci)
}

}
