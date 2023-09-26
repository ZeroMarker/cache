Import sqluser

/// 月报分类润乾报表 相关Query
Class web.DHCSTMHUI.DHCStkMonCatRepQuery Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 月报信息
/// Author:xuchao
/// Date:2016-08-03
/// Argu:ParmStr
/// 月报ID^分类ID^类组ID
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonCatRepQuery","DHCStkMonSumTransLoc",427)
Query DHCStkMonSumTransLoc(sm As %String, ParamStr As %String) As Query(ROWSPEC = "TLRowid,Type,RelaLoc,RelaLocDesc,StkCat,CatDesc,Scg,ScgDesc,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod DHCStkMonSumTransLocExecute(ByRef qHandle As %Binary, sm As %String, ParamStr As %String) As %Status
{
 n (qHandle,sm,ParamStr)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 s PScg=$P(ParamStr,"^",1)
 s PStkCat=$P(ParamStr,"^",2)
 s ScgType=$p(ParamStr,"^",4)
 s:ScgType="" ScgType="M"
 i sm="" q $$$OK
 s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)					
 s sql="select SUMTL_RowId,"
 s sql=sql_"SUMTL_SM_DR,"
 s sql=sql_"SUMTL_Type,"
 s sql=sql_"SUMTL_RelaLoc_DR,"
 s sql=sql_"SUMTL_RelaLoc_DR->CTLOC_Desc,"
 s sql=sql_"SUMTL_StkCat_DR,"
 s sql=sql_"SUMTL_StkCat_DR->INCSC_Desc,"
 s sql=sql_"SUMTL_SCG_DR,"
 s sql=sql_"SUMTL_SCG_DR->SCG_Desc,"
 s sql=sql_"SUMTL_RpAmt,"
 s sql=sql_"SUMTL_SpAmt"
 s sql=sql_" from DHC_StkMonSum_TransLoc"
 s sql=sql_" where SUMTL_SM_DR= "_sm
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.RuntimeModeSet(0)
 d xrs.Prepare(sql)
 s ret=xrs.Execute()
 i $$$ISERR(ret) q $$$OK
 while (xrs.Next()) 
 {
  s Rowid=xrs.Data("SUMTL_RowId")
  s Type=xrs.Data("SUMTL_Type")
  s RelaLoc=xrs.Data("SUMTL_RelaLoc_DR")
  s RelaLocDesc=xrs.Data("CTLOC_Desc")
  i $f(RelaLocDesc,"-") s RelaLocDesc=$p(RelaLocDesc,"-",2)
  s StkCat=xrs.Data("SUMTL_StkCat_DR")
  continue:(PStkCat'="")&&(PStkCat'=StkCat)
  continue:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_StkCat_"^"))
  i ScgType="O" d
  .s ScgDesc=""
  .s Scg=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(StkCat,ScgType,0)
  .s:Scg'="" ScgDesc=$p(^DHCSCG(Scg),"^",2)
  e  d 
  .s Scg=xrs.Data("SUMTL_SCG_DR")
  .s ScgDesc=xrs.Data("SCG_Desc")
  continue:(PScg'="")&&(PScg'=Scg)
  s CatDesc=xrs.Data("INCSC_Desc")
  s RpAmt=xrs.Data("SUMTL_RpAmt")
  s SpAmt=xrs.Data("SUMTL_SpAmt")
 d OutPutRow
 } 
 Quit $$$OK

OutPutRow
 s Data=$lb(Rowid,Type,RelaLoc,RelaLocDesc,StkCat,CatDesc,Scg,ScgDesc,RpAmt,SpAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 月报信息
/// Author:xuchao
/// Date:2016-08-03
/// Argu:
/// sm -月报ID
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonCatRepQuery","DHCStkMonCatSum",427)
Query DHCStkMonCatSum(sm As %String, ParamStr As %String) As Query(ROWSPEC = "Rowid,Scg,ScgDesc,StkCat,CatDesc,Amt:%Float,LastAmt:%Float,RecAmt:%Float,RetAmt:%Float,TrfOAmt:%Float,TrfIAmt:%Float,AdjAmt:%Float,ConsumeAmt:%Float,DisposalAmt:%Float,AspAmt:%Float,GiftRecAmt:%Float,GiftTrfAmt:%Float,ChgCheckRecAmt:%Float,ChgCheckRetAmt:%Float,DspPAmt:%Float,PhaRetYAmt:%Float,DspFAmt:%Float,PhaRetHAmt:%Float,DspSAmt:%Float,PhaRetZAmt:%Float,StkTkAmt:%Float,ManuXAmt:%Float,ManuMAmt:%Float,RecAspAmt:%Float,RetAspAmt:%Float,TrfIAspAmt:%Float,PhoRetAspAmt:%Float,PhaRetAspAmt:%Float") [ SqlProc ]
{
}

ClassMethod DHCStkMonCatSumExecute(ByRef qHandle As %Binary, sm As %String, ParamStr As %String) As %Status
{
 n (qHandle,sm,ParamStr)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 s PScg=$P(ParamStr,"^",1)
 s PStkCat=$P(ParamStr,"^",2)
 s ScgType=$p(ParamStr,"^",4)
 s:ScgType="" ScgType="M"
 i sm="" q $$$OK
 s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)							
 s sql="select SUMCG_RowId,"
 s sql=sql_"SUMCG_SM_DR,"
 s sql=sql_"SUMCG_StkCat_DR,"
 s sql=sql_"SUMCG_StkCat_DR->INCSC_Desc,"
 s sql=sql_"SUMCG_SCG_DR,"
 s sql=sql_"SUMCG_SCG_DR->SCG_Desc,"
 s sql=sql_"SUMCG_Amt,"
 s sql=sql_"SUMCG_LastAmt,"
 s sql=sql_"SUMCG_Amt,"
 s sql=sql_"SUMCG_LastAmt,"
 s sql=sql_"SUMCG_Rec_Amt,"
 s sql=sql_"SUMCG_Ret_Amt,"
 s sql=sql_"SUMCG_Trf_O_Amt,"
 s sql=sql_"SUMCG_Trf_I_Amt,"
 s sql=sql_"SUMCG_Adj_Amt,"
 s sql=sql_"SUMCG_Consume_Amt,"
 s sql=sql_"SUMCG_Disposal_Amt,"
 s sql=sql_"SUMCG_LastAmt,"
 s sql=sql_"SUMCG_Asp_Amt,"
 s sql=sql_"SUMCG_Gift_Rec_Amt,"
 s sql=sql_"SUMCG_Gift_Trf_Amt,"
 s sql=sql_"SUMCG_ChgCheck_Rec_Amt,"
 s sql=sql_"SUMCG_ChgCheck_Ret_Amt,"
 s sql=sql_"SUMCG_Dsp_P_Amt,"
 s sql=sql_"SUMCG_PhaRet_Y_Amt,"
 s sql=sql_"SUMCG_Dsp_F_Amt,"
 s sql=sql_"SUMCG_PhaRet_H_Amt,"
 s sql=sql_"SUMCG_Dsp_S_Amt,"
 s sql=sql_"SUMCG_PhaRet_Z_Amt,"
 s sql=sql_"SUMCG_StkTk_Amt,"
 s sql=sql_"SUMCG_Manu_X_Amt,"
 s sql=sql_"SUMCG_Manu_M_Amt,"
 s sql=sql_"SUMCG_M_Rec_Amt,"
 s sql=sql_"SUMCG_Rec_Asp_Amt,"
 s sql=sql_"SUMCG_Ret_Asp_Amt,"
 s sql=sql_"SUMCG_Trf_I_Asp_Amt,"
 s sql=sql_"SUMCG_Pho_Ret_Asp_Amt,"
 s sql=sql_"SUMCG_Pha_Ret_Asp_Amt"
 s sql=sql_" from DHC_StkMonSumIn_CatGrp"
 s sql=sql_" where SUMCG_SM_DR="_sm
 b
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.RuntimeModeSet(0)
 d xrs.Prepare(sql)
 s ret=xrs.Execute()
 i $$$ISERR(ret) q $$$OK
 while (xrs.Next()) 
 {

  s Rowid=xrs.Data("SUMCG_RowId")
  s StkCat=xrs.Data("SUMCG_StkCat_DR")
  continue:(PStkCat'="")&&(PStkCat'=StkCat)
  continue:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_StkCat_"^"))
  s CatDesc=xrs.Data("INCSC_Desc")
  i ScgType="O" d
  .s ScgDesc=""
  .s Scg=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(StkCat,ScgType,0)
  .s:Scg'="" ScgDesc=$p(^DHCSCG(Scg),"^",2)
  e  d 
  .s Scg=xrs.Data("SUMCG_SCG_DR")
  .s ScgDesc=xrs.Data("SCG_Desc")
  continue:(PScg'="")&&(PScg'=Scg)
  s Amt=xrs.Data("SUMCG_Amt")
  s LastAmt=xrs.Data("SUMCG_LastAmt")
  s RecAmt=xrs.Data("SUMCG_Rec_Amt")
  s RetAmt=xrs.Data("SUMCG_Ret_Amt")
  s TrfOAmt=xrs.Data("SUMCG_Trf_O_Amt")
  s TrfIAmt=xrs.Data("SUMCG_Trf_I_Amt")
  s AdjAmt=xrs.Data("SUMCG_Adj_Amt")
  s ConsumeAmt=xrs.Data("SUMCG_Consume_Amt")
  s DisposalAmt=xrs.Data("SUMCG_Disposal_Amt")
  s AspAmt=xrs.Data("SUMCG_Asp_Amt")
  s GiftRecAmt=xrs.Data("SUMCG_Gift_Rec_Amt")
  s GiftTrfAmt=xrs.Data("SUMCG_Gift_Trf_Amt")
  s ChgCheckRecAmt=xrs.Data("SUMCG_ChgCheck_Rec_Amt")
  s ChgCheckRetAmt=xrs.Data("SUMCG_ChgCheck_Ret_Amt")
  s DspPAmt=xrs.Data("SUMCG_Dsp_P_Amt")
  s PhaRetYAmt=xrs.Data("SUMCG_PhaRet_Y_Amt")
  s DspFAmt=xrs.Data("SUMCG_Dsp_F_Amt")
  s PhaRetHAmt=xrs.Data("SUMCG_PhaRet_H_Amt")
  s DspSAmt=xrs.Data("SUMCG_Dsp_S_Amt")
  s PhaRetZAmt=xrs.Data("SUMCG_PhaRet_Z_Amt")
  s StkTkAmt=xrs.Data("SUMCG_StkTk_Amt")
  s ManuXAmt=xrs.Data("SUMCG_Manu_X_Amt")
  s ManuMAmt=xrs.Data("SUMCG_Manu_M_Amt")
  s RecAspAmt=xrs.Data("SUMCG_Rec_Asp_Amt")
  s RetAspAmt=xrs.Data("SUMCG_Ret_Asp_Amt")
  s TrfIAspAmt=xrs.Data("SUMCG_Trf_I_Asp_Amt")
  s PhoRetAspAmt=xrs.Data("SUMCG_Pho_Ret_Asp_Amt")
  s PhaRetAspAmt=xrs.Data("SUMCG_Pha_Ret_Asp_Amt")
 d OutPutRow2
 } 
 Quit $$$OK

OutPutRow2
 s Data=$lb(Rowid,Scg,ScgDesc,StkCat,CatDesc,Amt,LastAmt,RecAmt,RetAmt,TrfOAmt,
 			TrfIAmt,AdjAmt,ConsumeAmt,DisposalAmt,AspAmt,GiftRecAmt,GiftTrfAmt,ChgCheckRecAmt,ChgCheckRetAmt,DspPAmt,
 			PhaRetYAmt,DspFAmt,PhaRetHAmt,DspSAmt,PhaRetZAmt,StkTkAmt,ManuXAmt,ManuMAmt,RecAspAmt,RetAspAmt,
 			TrfIAspAmt,PhoRetAspAmt,PhaRetAspAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 检索月报明细记录(进价)
/// Author:zhwh
/// Date:2012-11-05
/// Argu:
///  sm -月报主表rowid
/// 
Query StkMonRepItmRp(sm As %String, ParamStr As %String) As Query(ROWSPEC = "inciCode,inciDesc,spec,uomDesc,qty:%Float,amt:%Float,lastQty:%Float,lastAmt:%Float,recQty:%Float,recAmt:%Float,retQty:%Float,retAmt:%Float,trOutQty:%Float,trOutAmt:%Float,trInQty:%Float,trInAmt:%Float,adjQty:%Float,adjAmt:%Float,csmQty:%Float,csmAmt:%Float,disposeQty:%Float,disposeAmt:%Float,phaInDspQty:%Float,phaInDspAmt:%Float,aspAmt:%Float,phaInRetQty:%Float,phaInRetAmt:%Float,phaOutDspQty:%Float,phaOutDspAmt:%Float,phaOutDspQtyS:%Float,phaOutDspAmtS:%Float,phaOutRetQty:%Float,phaOutRetAmt:%Float,phaOutRetQtyZ:%Float,phaOutRetAmtZ:%Float,giftRecQty:%Float,giftRecAmt:%Float,giftTrOutQty:%Float,giftTrOutAmt:%Float,chgRecQty:%Float,chgRecAmt:%Float,chgRetQty:%Float,chgRetAmt:%Float,retAspAmt:%Float,phaRetAspAmt:%Float,mRecQty:%Float,mRecAmt:%Float,stktkAdjQty:%Float,stktkAdjAmt:%Float,manuXQty:%Float,manuXAmt:%Float,manuMQty:%Float,manuMAmt:%Float,phaOutRetAspAmt:%Float,trInAspAmt:%Float") [ SqlProc ]
{
}

ClassMethod StkMonRepItmRpExecute(ByRef qHandle As %Binary, sm As %String, ParamStr As %String) As %Status
{
 n (qHandle,sm,ParamStr)
 q:sm="" $$$OK
 ;
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 s stkgrpid=$p(ParamStr,"^",1)
 s stkcatid=$p(ParamStr,"^",2)
 s incdesc=$p(ParamStr,"^",3)
 s ScgType=$p(ParamStr,"^",4)
 s:ScgType="" ScgType="M"
 s MonLoc=$p(^DHCSM(sm),"^",1)
 s HospId=..sssHospId(MonLoc)
 s stkgrpid=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",stkgrpid,HospId)
 s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)
 s n=0
 s ch=""
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
 .s smr=sm_"||"_ch
 .s row=^DHCSM(sm,"R",ch)
 .s inci=$p(row,"^",3)  ;inci
 .
 .s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci,ScgType)
 .s grpid=$p(stkgrpinfo,"^",5)
 .q:(stkgrpid'="")&&(("^"_stkgrpid_"^")'[("^"_grpid_"^"))
 .
 .s stkcat=$p(^INCI(inci,2),"^",2)
 .q:(stkcatid'="")&(stkcat'=stkcatid)
 .;根据科室类组权限的"月报标记"做过滤
 .q:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_stkcat_"^"))
 .
 .s inciCode=$p(^INCI(inci,1),"^",1)    ;inci code
 .s inciDesc=$p(^INCI(inci,1),"^",2)    ;inci desc
 .q:(incdesc'="")&('$f(inciDesc,incdesc))
 .
 .s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
 .s inciuomdr=$p(^INCI(inci,1),"^",10)      ;uom dr
 .s puruom=$p(^INCI(inci,3),"^",6)      ;purch uom dr 
 .i puruom="" s puruom=inciuomdr
 .s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruom,inciuomdr)
 .s uomDesc=$p(^CT("UOM",puruom),"^",2)  ;uom desc
 .s qty=$p(row,"^",6)		;qty
 .s qty=qty/fac
 .s amt=$p(row,"^",8)		;costamount
 .s lastQty=$p(row,"^",9)	;qty of last month
 .s lastQty=lastQty/fac
 .s lastAmt=$p(row,"^",11)	;costamount of last month
 .;
 .s stat=$o(^SMSTATI(0,"SMR",smr,""))
 .q:stat=""
 .s stats=$G(^SMSTATI(stat))
 .
 .s recQty=$P(stats,"^",2)/fac  ;入库数量
 .s recAmt=$P(stats,"^",3) ;入库金额
 .s retQty=$P(stats,"^",4)/fac ;退货数量
 .s retAmt=$P(stats,"^",5) ;退货金额
 .s trOutQty=$P(stats,"^",6)/fac  ;转出数量
 .s trOutAmt=$P(stats,"^",7) ;转出金额
 .s trInQty=$P(stats,"^",8)/fac ;转入数量
 .s trInAmt=$P(stats,"^",9) ;转入金额
 .s adjQty=$P(stats,"^",10)/fac  ;库存调整数量
 .s adjAmt=$P(stats,"^",11) ;库存调整金额
 .s csmQty=$P(stats,"^",12)/fac   ;报损数量
 .s csmAmt=$P(stats,"^",13) ;报损金额
 .s disposeQty=$P(stats,"^",14)/fac ;发放数量
 .s disposeAmt=$P(stats,"^",15) ;发放金额
 .s phaInDspQty=$P(stats,"^",16)/fac ;发药数量(住院)
 .s phaInDspAmt=$P(stats,"^",17)  ;发药金额(住院)
 .s aspAmt=$P(stats,"^",18)  ;调价损益金额
 .s phaInRetQty=$P(stats,"^",19)/fac ;退药数量(住院)
 .s phaInRetAmt=$P(stats,"^",20)  ;退药金额(住院)
 .
 .s giftRecQty=$P(stats,"^",21)/fac ;入库数量(赠品)
 .s giftRecAmt=$P(stats,"^",22)  ;入库(赠品)
 .s giftTrOutQty=$P(stats,"^",23)/fac ;转出数量(赠品)
 .s giftTrOutAmt=$P(stats,"^",24)  ;转出金额(赠品)
 .
 .s chgRecQty=$P(stats,"^",25)/fac ;入库数量(调价换票)
 .s chgRecAmt=$P(stats,"^",26)  ;入库金额(调价换票)
 .s chgRetQty=$P(stats,"^",27)/fac ;退货数量(调价换票)
 .s chgRetAmt=$P(stats,"^",28)  ;退货金额(调价换票)
 .
 .s phaOutDspQty=$P(stats,"^",29)/fac ;发药数量(门诊)
 .s phaOutDspAmt=$P(stats,"^",30)   ;发药金额(门诊)
 .s phaOutDspQtyS=$P(stats,"^",31)/fac  ;发药数量(门诊非正常)
 .s phaOutDspAmtS=$P(stats,"^",32) ;发药金额(门诊非正常)
 .
 .s phaOutRetQty=$P(stats,"^",33)/fac  ;退药数量(门诊)
 .s phaOutRetAmt=$P(stats,"^",34)  ;退药金额(门诊)
 .s phaOutRetQtyZ=$P(stats,"^",35)/fac   ;退药数量(门诊非正常)
 .s phaOutRetAmtZ=$P(stats,"^",36)  ;退药金额量(门诊非正常)
 .
 .s trInAspAmt=$P(stats,"^",38)  ;库存转入调价损益
 .s retAspAmt=$P(stats,"^",39)    ;退货调价损益
 .s stktkAdjQty=$P(stats,"^",40)/fac  ;盘点调整数量
 .s stktkAdjAmt=$P(stats,"^",41)  ;盘点调整金额 
 .s manuXQty=$P(stats,"^",42)/fac
 .s manuXAmt=$P(stats,"^",43)
 .s manuMQty=$P(stats,"^",44)/fac
 .s manuMAmt=$P(stats,"^",45)
 .s mRecQty=$P(stats,"^",46)/fac
 .s mRecAmt=$P(stats,"^",47)
 .s phaOutRetAspAmt=$P(stats,"^",48)  ;门诊退药调价损益
 .s phaRetAspAmt=$P(stats,"^",49)  ;住院退药调价损益
 .
 .
 .d OutPutRow3
 .
 Quit $$$OK
 
OutPutRow3
 s Data=$lb(inciCode,inciDesc,spec,uomDesc,qty,amt,lastQty,lastAmt,recQty,recAmt,retQty,retAmt,trOutQty,trOutAmt,trInQty,trInAmt,adjQty,adjAmt,csmQty,csmAmt,disposeQty,disposeAmt,phaInDspQty,phaInDspAmt,aspAmt,phaInRetQty,phaInRetAmt,phaOutDspQty,phaOutDspAmt,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty,phaOutRetAmt,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty,giftRecAmt,giftTrOutQty,giftTrOutAmt,chgRecQty,chgRecAmt,chgRetQty,chgRetAmt,retAspAmt,phaRetAspAmt,mRecQty,mRecAmt,stktkAdjQty,stktkAdjAmt,manuXQty,manuXAmt,manuMQty,manuMAmt,phaOutRetAspAmt,trInAspAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

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
Query StkMonRepLcBt(sm As %String, ParamStr As %String) As Query(ROWSPEC = "INCLB,inci,incicode,incidesc,spec,manf,puomdesc,IBNO,qty:%Float,lastqty:%Float,amt:%Float,coamt:%Float,lastamt:%Float,lastcoamt:%Float,recqty:%Float,recamt:%Float,reccoamt:%Float,retqty:%Float,retamt:%Float,retcoamt:%Float,trfoqty:%Float,trfoamt:%Float,trfocoamt:%Float,trfiqty:%Float,trfiamt:%Float,trficoamt:%Float,adjqty:%Float,adjamt:%Float,adjcoamt:%Float,conqty:%Float,conamt:%Float,concoamt:%Float,dispqty:%Float,dispamt:%Float,dispcoamt:%Float,dspqty:%Float,dspamt:%Float,dspcoamt:%Float,dspretqty:%Float,dspretamt:%Float,dspretcoamt:%Float,aspamt:%Float,aspcoamt:%Float,stkqty:%Float,stkamt:%Float,stkcoamt:%Float,IncscDesc,ScgDesc,SourceOfFundDesc") [ SqlProc ]
{
}

ClassMethod StkMonRepLcBtExecute(ByRef qHandle As %Binary, sm As %String, ParamStr As %String) As %Status
{
 n (qHandle,sm,ParamStr)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)

 q:sm="" $$$OK
 s stkgrpid=$p(ParamStr,"^",1)
 s stkcatid=$p(ParamStr,"^",2)
 s incdesc=$p(ParamStr,"^",3)
 s ScgType=$p(ParamStr,"^",4)		;2016-06-04 类组类型(M:物资类组,O:财务类组)
 s:ScgType="" ScgType="M"			;缺省为物资类组
 k InclbInfoArr,InciInfoArr
 s MonLoc=$p(^DHCSM(sm),"^",1)
 s HospId=..sssHospId(MonLoc)
 s stkgrpid=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",stkgrpid,HospId)
 s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)
 ;
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
 :aspamt,:aspcoamt,:stkqty,:stkamt,:stkcoamt) q:SQLCODE  d
 . q:INCLB=""
 . s INCI=+INCLB
 . s tmp=^INCI(INCI,1)
 . s incicode=$p(tmp,"^",1)
 . s incidesc=$p(tmp,"^",2)
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
 . s basicuom=$p(tmp,"^",10)
 . s puom=$p(^INCI(INCI,3),"^",6)
 . i puom="" s puom=basicuom
 . s puomdesc=$p(^CT("UOM",puom),"^",2)
 . s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,basicuom)
 . 
 . s qty=qty/fac,lastqty=lastqty/fac
 . s recqty=recqty/fac,retqty=retqty/fac
 . s trfoqty=trfoqty/fac,trfiqty=trfiqty/fac
 . s adjqty=adjqty/fac,conqty=conqty/fac
 . s dispqty=dispqty/fac,dspqty=dspqty/fac,dspretqty=dspretqty/fac
 . s stkqty=stkqty/fac
 . 
 . i '$d(InclbInfoArr(INCLB)) d
 . .s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(INCLB)
 . .s IBNO=$p(BatExp,"^",1)
 . .s SourceOfFundInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb(INCLB)
 . .s SourceOfFund=$p(SourceOfFundInfo,"^",1)
 . .s SourceOfFundDesc=$p(SourceOfFundInfo,"^",2)
 . .s manf=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(INCLB),"^",2)
 . .s InclbInfoArr(INCLB)=IBNO_"^"_SourceOfFund_"^"_SourceOfFundDesc_"^"_manf
 .
 .s InclbInfo=InclbInfoArr(INCLB)
 .s IBNO=$p(InclbInfo,"^",1)
 .s SourceOfFund=$p(InclbInfo,"^",2)
 .s SourceOfFundDesc=$p(InclbInfo,"^",3)
 .s manf=$p(InclbInfo,"^",4)
 .
 .s n=n+1
 .d OutPutRow4
 . 
 &sql(close currx)
 Quit $$$OK
 
OutPutRow4
 s Data=$lb(INCLB,INCI,incicode,incidesc,spec,manf,
 		puomdesc,IBNO,+qty,+lastqty,+amt,
 		+coamt,+lastamt,+lastcoamt,+recqty,+recamt,
 		+reccoamt,+retqty,+retamt,+retcoamt,+trfoqty,
 		+trfoamt,+trfocoamt,+trfiqty,+trfiamt,+trficoamt,
 		+adjqty,+adjamt,+adjcoamt,+conqty,+conamt,
 		+concoamt,+dispqty,+dispamt,+dispcoamt,+dspqty,
 		+dspamt,+dspcoamt,+dspretqty,+dspretamt,+dspretcoamt,
 		+aspamt,+aspcoamt,+stkqty,+stkamt,+stkcoamt,
 		IncscDesc,ScgDesc,SourceOfFundDesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
