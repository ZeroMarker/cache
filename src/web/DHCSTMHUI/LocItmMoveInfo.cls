Class web.DHCSTMHUI.LocItmMoveInfo Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 检索科室内项目的动销情况信息
/// Author：zhwh
/// Date:202-07-30
/// Argu:
/// Loc - 科室rowoid
/// StartDate - 起始日期
/// StartTime -起始时间
/// EndDate - 截止日期
/// EndTime - 截止时间
/// SCG - 类组rowid
/// INCSC  -分类rowid
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmMoveInfo","LocItmMoveInfo",^tmpltx("0920"))
Query LocItmMoveInfo(StrPar As %String(MAXLEN="")) As Query(ROWSPEC = "incil,InciCode,InciDesc,Spec,Manf,OutQty:%Float,PurUom,SumOutAmt:%Float,SumOutRpAmt:%Float,InQty:%Float,SumInAmt:%Float,SumInRpAmt:%Float,SbDesc,CurStkQty:%Float,scgDesc,incscDesc,StartQty:%Float,LocDesc,TransInQty:%Float,TransInRpAmt:%Float,TransOutQty:%Float,TransOutRpAmt:%Float,DispQty:%Float,DispRpAmt:%Float,DispReturnQty:%Float,DispReturnRpAmt:%Float,StartRpAmt:%Float,EndRpAmt:%Float,AdjQty:%Float,AdjRpAmt:%Float,RecQty:%Float,RecRpAmt:%Float,RetQty:%Float,RetRpAmt:%Float,ScrapQty:%Float,ScrapRpAmt:%Float,InDispQty:%Float,InDispRpAmt:%Float,InDispRetQty:%Float,InDispRetRpAmt:%Float") [ SqlProc ]
{
}

ClassMethod LocItmMoveInfoExecute(ByRef qHandle As %Binary, StrPar As %String(MAXLEN="")) As %Status
{
	n (qHandle,StrPar)
	;s ^tmpltx("0920")=StrPar
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(StrPar)
	s Loc=PJObj.%Get("PhaLoc")
	s StartDate=PJObj.%Get("StartDate")
	s StartTime=PJObj.%Get("StartTime")
	s EndDate=PJObj.%Get("EndDate")
	s EndTime=PJObj.%Get("EndTime")
	s SCG=PJObj.%Get("StkGrpId")
	s User=PJObj.%Get("gUserId")
	;s SCG=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),Loc,SCG)  //用户类组串
	s TotalScgStr=""
	s LocLength=$l(Loc,",")
	f i=1:1:LocLength d
	.s LocId=$p(Loc,",",i)
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),LocId,SCG)
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s SCG=TotalScgStr
	s INCSC=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PInciDesc=PJObj.%Get("InciDesc")

	q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK

	s HospID=..sssHospId(Loc)
	s:HospID="" HospID=PJObj.%Get("gHospId")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s TmpStartDate=StartDate-1
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s:StartTime'="" StartTime=..TH2L(StartTime)
	s:EndTime'="" EndTime=..TH2L(EndTime)
	s:StartTime="86399" StartTime=""
	s:EndTime="86399" EndTime=""
	s sql="select incil_inci_parref inci,"
	s sql=sql_"incil_rowid incil,"
	s sql=sql_"incil_inci_parref->inci_incsc_dr incsc,"
	s sql=sql_"incil_inci_parref->inci_code code,"
	s sql=sql_"incil_inci_parref->inci_desc descx,"
	s sql=sql_"incil_logqty logQty,"
	s sql=sql_"incil_incsb_dr->incsb_desc sbDesc,"
	s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr pUom,"
	s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
	s sql=sql_"incil_inci_parref->inci_ctuom_dr bUom,"
	s sql=sql_"incil_ctloc_dr LocId,"
	s sql=sql_"incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
	s sql=sql_" from inc_itmloc"
	;s sql=sql_" where incil_ctloc_dr="_Loc
	s sql=sql_" where incil_ctloc_dr in ("_Loc_")"

	s xrs=##class(%ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	if $$$ISERR(sc) q $$$OK  
	while (xrs.Next())
	{
		s incil=xrs.Data("incil") 
		s inci=+incil
		continue:(PInci'="")&&(inci'=PInci)
		s IncscId=$p(^INCI(inci,2),"^",2)
		continue:(INCSC'="")&&(IncscId'=INCSC)
		s incsc=xrs.Data("incsc") 
		s scg=$o(^DHCSCG("STKCAT",incsc,""))
		i SCG'="" continue:("^"_SCG_"^")'[("^"_scg_"^")
		s scgDesc=$p(^DHCSCG(scg),"^",2)
		s incscDesc=$p(^INC("SC",incsc),"^",2)
		s grpType=""
		i scg'="" s grpType=$p($g(^DHCSCG(scg)),"^",3)
		i grpType'="" continue:grpType'=..sssCode()
		s sbDesc=xrs.Data("sbDesc")  //货位
		s bUom=xrs.Data("bUom") 
		s pUom=xrs.Data("pUom")
		s pUomDesc=xrs.Data("pUomDesc")
		s code=xrs.Data("code") 
		s desc=xrs.Data("descx") 
		continue:(PInciDesc'="")&&(desc'[PInciDesc) 
		s LocId=xrs.Data("LocId") 
		s LocDesc=$p(^CTLOC(LocId),"^",2)

		s sumOutQty=0,sumOutAmt=0,sumOutRpAmt=0
		s sumInQty=0,sumInAmt=0,sumInRpAmt=0
		s (TransInQty,TransInRpAmt)=0
		s (TransOutQty,TransOutRpAmt)=0
		s (DispQty,DispRpAmt)=0
		s (DispReturnQty,DispReturnRpAmt)=0
		s (AdjQty,AdjRpAmt,ScrapQty,ScrapRpAmt)=0
		s (RecQty,RecRpAmt,RetQty,RetRpAmt)=0
		s (InDispQty,InDispRpAmt)=0
		s (InDispRetQty,InDispRetRpAmt)=0
		s types="G^R^T^K^MP^MY^MF^MH^S^Z^A^D^L^C^MDP^MDY"
		f i=1:1:$l(types,"^") d
		.s type=$p(types,"^",i)
		.s statType=..GetInOut(type)
		.
		.f dd=StartDate:1:EndDate  d
		..s intr=""
		..f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,dd,intr)) q:intr=""  d
		...s trTime=$p(^DHCINTR(intr),"^",3)
		...q:(dd=StartDate)&&(StartTime'="")&&(trTime<StartTime)
		...q:(dd=EndDate)&&(EndTime'="")&&(trTime>=EndTime)
		...s qty=$p(^DHCINTR(intr),"^",6)
		...s amt=$p(^DHCINTR(intr),"^",8)   //售价金额
		...s rpAmt=$p(^DHCINTR(intr),"^",17)   //进价金额 
		...s uom=$p(^DHCINTR(intr),"^",10)
		...s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,bUom)
		...s qty=qty*fac
		...
		...i type="T" d
		....s TransOutQty=TransOutQty+qty
		....s TransOutRpAmt=TransOutRpAmt+rpAmt
		...e  i type="K" d
		....s TransInQty=TransInQty+qty
		....s TransInRpAmt=TransInRpAmt+rpAmt
		...e  i type="G" d
		....s RecQty=RecQty+qty
		....s RecRpAmt=RecRpAmt+rpAmt
		...e  i type="R" d
		....s RetQty=RetQty+qty
		....s RetRpAmt=RetRpAmt+rpAmt
		...e  i type="D" d
		....s ScrapQty=ScrapQty+qty
		....s ScrapRpAmt=ScrapRpAmt+rpAmt
		...e  i (type="MP")||(type="MF")||(type="MDP") d   ;开医嘱数量和停医嘱数量求和算是医嘱数量
		....s DispQty=DispQty+qty
		....s DispRpAmt=DispRpAmt+rpAmt
		...e  i (type="MY")||(type="MH")||(type="MDY") d
		....s DispReturnQty=DispReturnQty+qty
		....s DispReturnRpAmt=DispReturnRpAmt+rpAmt
		...e  i type="A" d
		....s AdjQty=AdjQty+qty
		....s AdjRpAmt=AdjRpAmt+rpAmt
		...e  i type="C" d
		....s InDispQty=InDispQty+qty
		....s InDispRpAmt=InDispRpAmt+rpAmt
		...e  i type="L" d
		....s InDispRetQty=InDispRetQty+qty
		....s InDispRetRpAmt=InDispRetRpAmt+rpAmt
		...//2013-12-03 wangjiabin: 缺省A为IN, 数量<0时为OUT
		...s:(type="A")&&(qty<0) statType="OUT"
		...i statType="OUT" d
		....s sumOutQty=sumOutQty+qty
		....s sumOutAmt=sumOutAmt+amt
		....s sumOutRpAmt=sumOutRpAmt+rpAmt
		...
		...i statType="IN" d
		....s sumInQty=sumInQty+qty
		....s sumInAmt=sumInAmt+amt
		....s sumInRpAmt=sumInRpAmt+rpAmt

		s currStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(inci,LocId,EndDate,EndTime)
		s pFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
		s TransInQty=TransInQty/pFac
		s TransOutQty=TransOutQty/pFac
		s DispQty=DispQty/pFac
		s DispReturnQty=DispReturnQty/pFac
		s AdjQty=AdjQty/pFac 
		s ScrapQty=ScrapQty/pFac
		s RecQty=RecQty/pFac
		s RetQty=RetQty/pFac
		s InDispQty=InDispQty/pFac
		s InDispRetQty=InDispRetQty/pFac
		
		s OutQty=sumOutQty/pFac
		s InQty=sumInQty/pFac
		s currStkQty=currStkQty/pFac
		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		s manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci),"^",3)
		s StartQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(inci,LocId,pUom,TmpStartDate,StartTime)
		continue:(sumOutQty=0)&&(sumInQty=0)&&(StartQty=0)  //没有进、出记录，认为是没有动销
		s StartRpAmt=##class(web.DHCSTMHUI.LocItmStk).GetRpAmt(incil,TmpStartDate,"")
		s EndRpAmt=##class(web.DHCSTMHUI.LocItmStk).GetRpAmt(incil,EndDate,"")
		s LastReailPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(inci,pUom,HospID)
		d OutPutRow
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(incil,code,desc,spec,manf,OutQty,pUomDesc,sumOutAmt,sumOutRpAmt,InQty,sumInAmt,sumInRpAmt,sbDesc,currStkQty,scgDesc,incscDesc,StartQty,LocDesc,TransInQty,TransInRpAmt,TransOutQty,TransOutRpAmt,DispQty,DispRpAmt,DispReturnQty,DispReturnRpAmt,StartRpAmt,EndRpAmt,AdjQty,AdjRpAmt,RecQty,RecRpAmt,RetQty,RetRpAmt,ScrapQty,ScrapRpAmt,InDispQty,InDispRpAmt,InDispRetQty,InDispRetRpAmt)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 取业务类型
/// Author:zhwh
/// Date:2012-07-31
/// Argu:
/// type - 业务类型代码(DHC_INTRANS.INTR_Type)
/// Return:
///  类型名称(IN-增加，OUT-减少)
ClassMethod GetInOut(type As %String) As %String
{
	n (type)
	i type="G" q "IN"
	i type="R" q "OUT"
	i type="T" q "OUT"
	i type="K" q "IN"
	i type="MF" q "OUT"
	i type="MH" q "IN"
	i type="S" q "OUT"
	i type="Z" q "IN"
	i type="MP" q "OUT"
	i type="MY" q "IN"
	i type="A" q "IN"
	i type="D" q "OUT"
	i type="C" q "OUT"     ;科室内物资发放
	i type="L" q "IN"      ;科室内物资退回
	i type="MDP" q "OUT"
	i type="MDY" q "IN"
	q "IN"
}

/// 检索科室内项目批次的动销情况信息
/// Author：lihui
/// Date: 20210331
/// Argu:
/// Loc - 科室rowoid
/// StartDate - 起始日期
/// StartTime -起始时间
/// EndDate - 截止日期
/// EndTime - 截止时间
/// SCG - 类组rowid
/// INCSC  -分类rowid
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmMoveInfo","LocItmMoveInfoBat",^tmpsbx("StrPar"))
Query LocItmMoveInfoBat(StrPar As %String(MAXLEN="")) As Query(ROWSPEC = "incil,inclb,InciCode,InciDesc,Spec,Manf,OutQty:%Float,PurUom,SumOutAmt:%Float,SumOutRpAmt:%Float,InQty:%Float,SumInAmt:%Float,SumInRpAmt:%Float,SbDesc,CurStkQty:%Float,scgDesc,incscDesc,StartQty:%Float,LocDesc,TransInQty:%Float,TransInRpAmt:%Float,TransOutQty:%Float,TransOutRpAmt:%Float,DispQty:%Float,DispRpAmt:%Float,DispReturnQty:%Float,DispReturnRpAmt:%Float,StartRpAmt:%Float,EndRpAmt:%Float,AdjQty:%Float,AdjRpAmt:%Float,RecQty:%Float,RecRpAmt:%Float,RetQty:%Float,RetRpAmt:%Float,ScrapQty:%Float,ScrapRpAmt:%Float,InDispQty:%Float,InDispRpAmt:%Float,InDispRetQty:%Float,InDispRetRpAmt:%Float,Prp:%Float,Psp:%Float,Margin:%Float,AspAmoutRpAmt:%Float,AspAmoutSpAmt:%Float") [ SqlProc ]
{
}

ClassMethod LocItmMoveInfoBatExecute(ByRef qHandle As %Binary, StrPar As %String(MAXLEN="")) As %Status
{
	n (qHandle,StrPar)
	;s ^litmp("LocItmMoveInfoBat")=StrPar
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(StrPar)
	s Loc=PJObj.%Get("PhaLoc")
	s StartDate=PJObj.%Get("StartDate")
	s StartTime=PJObj.%Get("StartTime")
	s EndDate=PJObj.%Get("EndDate")
	s EndTime=PJObj.%Get("EndTime")
	s SCG=PJObj.%Get("StkGrpId")
	s User=PJObj.%Get("gUserId")
	s TotalScgStr=""
	s LocLength=$l(Loc,",")
	f i=1:1:LocLength d
	.s LocId=$p(Loc,",",i)
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),LocId,SCG)
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s SCG=TotalScgStr  //用户类组串
	s INCSC=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PInciDesc=PJObj.%Get("InciDesc")

	q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK

	s HospID=..sssHospId(Loc)
	s:HospID="" HospID=PJObj.%Get("gHospId")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s TmpStartDate=StartDate-1
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s:StartTime'="" StartTime=..TH2L(StartTime)
	s:EndTime'="" EndTime=..TH2L(EndTime)
	s:StartTime="86399" StartTime=""
	s:EndTime="86399" EndTime=""
	s sql="select incil_inci_parref inci,"
	s sql=sql_"incil_rowid incil,"
	s sql=sql_"incil_inci_parref->inci_incsc_dr incsc,"
	s sql=sql_"incil_inci_parref->inci_code code,"
	s sql=sql_"incil_inci_parref->inci_desc descx,"
	s sql=sql_"incil_logqty logQty,"
	s sql=sql_"incil_incsb_dr->incsb_desc sbDesc,"
	s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr pUom,"
	s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
	s sql=sql_"incil_inci_parref->inci_ctuom_dr bUom,"
	s sql=sql_"incil_ctloc_dr LocId,"
	s sql=sql_"incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
	s sql=sql_" from inc_itmloc"
	;s sql=sql_" where incil_ctloc_dr="_Loc
	s sql=sql_" where incil_ctloc_dr in ("_Loc_")"

	s xrs=##class(%ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	if $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s incil=xrs.Data("incil")
		s inci=+incil
		continue:(PInci'="")&&(inci'=PInci)
		s IncscId=$p(^INCI(inci,2),"^",2)
		continue:(INCSC'="")&&(IncscId'=INCSC)
		s incsc=xrs.Data("incsc")
		s scg=$o(^DHCSCG("STKCAT",incsc,""))
		i SCG'="" continue:("^"_SCG_"^")'[("^"_scg_"^")
		s scgDesc=$p(^DHCSCG(scg),"^",2)
		s incscDesc=$p(^INC("SC",incsc),"^",2)
		s grpType=""
		i scg'="" s grpType=$p($g(^DHCSCG(scg)),"^",3)
		i grpType'="" continue:grpType'=..sssCode()
		s sbDesc=xrs.Data("sbDesc")  //货位
		s bUom=xrs.Data("bUom")
		s pUom=xrs.Data("pUom")
		s pUomDesc=xrs.Data("pUomDesc")
		s code=xrs.Data("code")
		s desc=xrs.Data("descx")
		continue:(PInciDesc'="")&&(desc'[PInciDesc)
		s LocId=xrs.Data("LocId")
		s LocDesc=$p(^CTLOC(LocId),"^",2)
		
		s chl=0
		f  s chl=$o(^INCI(inci,"IL",$p(incil,"||",2),"LB",chl))  q:chl=""  d
		.q:+chl'>0
		.s inclb=incil_"||"_chl
		.s types="^G^R^T^K^MP^MY^MF^MH^S^Z^A^D^L^C^MDP^MDY^"
		.s sumOutQty=0,sumOutAmt=0,sumOutRpAmt=0
		.s sumInQty=0,sumInAmt=0,sumInRpAmt=0
		.s (TransInQty,TransInRpAmt)=0
		.s (TransOutQty,TransOutRpAmt)=0
		.s (DispQty,DispRpAmt)=0
		.s (DispReturnQty,DispReturnRpAmt)=0
		.s (AdjQty,AdjRpAmt,ScrapQty,ScrapRpAmt)=0
		.s (RecQty,RecRpAmt,RetQty,RetRpAmt)=0
		.s (InDispQty,InDispRpAmt)=0
		.s (InDispRetQty,InDispRetRpAmt)=0
		.s (AspAmoutRpAmt,AspAmoutSpAmt)=0
		.f dd=StartDate:1:EndDate  d
		..s intr=""
		..f  s intr=$o(^DHCINTR(0,"INCLB",inclb,dd,intr)) q:intr=""  d
		...q:'$d(^DHCINTR(intr))
		...s trinfo=^DHCINTR(intr)
		...s trTime=$p(trinfo,"^",3)
		...q:(dd=StartDate)&&(StartTime'="")&&(trTime<StartTime)
		...q:(dd=EndDate)&&(EndTime'="")&&(trTime>EndTime)
		...s type=$p(trinfo,"^",1)
		...q:(types'["^"_type_"^")
		...s statType=..GetInOut(type)
		...s qty=$p(trinfo,"^",6)
		...s amt=$p(trinfo,"^",8)   //售价金额
		...s rpAmt=$p(trinfo,"^",17)   //进价金额 
		...s uom=$p(trinfo,"^",10)
		...s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,bUom)
		...s qty=qty*fac
		...
		...i type="T" d
		....s TransOutQty=TransOutQty+qty
		....s TransOutRpAmt=TransOutRpAmt+rpAmt
		...e  i type="K" d
		....s TransInQty=TransInQty+qty
		....s TransInRpAmt=TransInRpAmt+rpAmt
		...e  i type="G" d
		....s RecQty=RecQty+qty
		....s RecRpAmt=RecRpAmt+rpAmt
		...e  i type="R" d
		....s RetQty=RetQty+qty
		....s RetRpAmt=RetRpAmt+rpAmt
		...e  i type="D" d
		....s ScrapQty=ScrapQty+qty
		....s ScrapRpAmt=ScrapRpAmt+rpAmt
		...e  i (type="MP")||(type="MF")||(type="MDP") d   ;开医嘱数量和停医嘱数量求和算是医嘱数量
		....s DispQty=DispQty+qty
		....s DispRpAmt=DispRpAmt+rpAmt
		...e  i (type="MY")||(type="MH")||(type="MDY") d
		....s DispReturnQty=DispReturnQty+qty
		....s DispReturnRpAmt=DispReturnRpAmt+rpAmt
		...e  i type="A" d
		....s AdjQty=AdjQty+qty
		....s AdjRpAmt=AdjRpAmt+rpAmt
		...e  i type="C" d
		....s InDispQty=InDispQty+qty
		....s InDispRpAmt=InDispRpAmt+rpAmt
		...e  i type="L" d
		....s InDispRetQty=InDispRetQty+qty
		....s InDispRetRpAmt=InDispRetRpAmt+rpAmt
		...//2013-12-03 wangjiabin: 缺省A为IN, 数量<0时为OUT
		...s:(type="A")&&(qty<0) statType="OUT"
		...
		...i statType="OUT" d
		....s sumOutQty=sumOutQty+qty
		....s sumOutAmt=sumOutAmt+amt
		....s sumOutRpAmt=sumOutRpAmt+rpAmt
		...
		...i statType="IN" d
		....s sumInQty=sumInQty+qty
		....s sumInAmt=sumInAmt+amt
		....s sumInRpAmt=sumInRpAmt+rpAmt
		...s AspId=""
		...f  s AspId=$O(^ASPA(0,"TranType","KC","Trans",intr,AspId)) q:AspId=""  d	// KC--调价损益,YW--台账损益
		....s AspAmoutRpAmt=AspAmoutRpAmt+$p(^ASPA(AspId),"^",12)
		....s AspAmoutSpAmt=AspAmoutSpAmt+$p(^ASPA(AspId),"^",5)
		...s AspId=""
		...f  s AspId=$O(^ASPA(0,"TranType","YW","Trans",intr,AspId)) q:AspId=""  d
		....s AspAmoutRpAmt=AspAmoutRpAmt+$p(^ASPA(AspId),"^",12)
		....s AspAmoutSpAmt=AspAmoutSpAmt+$p(^ASPA(AspId),"^",5)
		.s currStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(inclb,EndDate,bUom,EndTime)
		.s pFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
		.
		.s TransInQty=TransInQty/pFac
		.s TransOutQty=TransOutQty/pFac
		.s DispQty=DispQty/pFac
		.s DispReturnQty=DispReturnQty/pFac
		.s AdjQty=AdjQty/pFac
		.s ScrapQty=ScrapQty/pFac
		.s RecQty=RecQty/pFac
		.s RetQty=RetQty/pFac
		.s InDispQty=InDispQty/pFac
		.s InDispRetQty=InDispRetQty/pFac
		.
		.s OutQty=sumOutQty/pFac
		.s InQty=sumInQty/pFac
		.s currStkQty=currStkQty/pFac
		.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		.
		.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
		.s ManfDr=$p(ManfInfo,"^",1)
		.s manf=$p(ManfInfo,"^",2)
		.
		.s StartQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(inclb,TmpStartDate,bUom,StartTime)
		.q:(sumOutQty=0)&&(sumInQty=0)&&(StartQty=0)  //没有进、出记录，认为是没有动销
		.s rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,bUom,HospID,"",EndDate)
		.s StartRpAmt=StartQty*rp
		.s EndRpAmt=currStkQty*rp
		.s AspAmoutRpAmt=AspAmoutRpAmt*pFac
		.s AspAmoutSpAmt=AspAmoutSpAmt*pFac
		.s StartQty=StartQty/pFac
		.s Prp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,pUom,HospID,"",EndDate)
		.s Psp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbSp(inclb,EndDate,pUom,HospID,"")
		.s Margin=Psp-Prp
		.d OutPutRowBat
	}
	Quit $$$OK

OutPutRowBat
	s Data=$lb(incil,inclb,code,desc,spec,manf,OutQty,pUomDesc,sumOutAmt,sumOutRpAmt,InQty,sumInAmt,sumInRpAmt,
				sbDesc,currStkQty,scgDesc,incscDesc,StartQty,LocDesc,TransInQty,TransInRpAmt,TransOutQty,TransOutRpAmt,
				DispQty,DispRpAmt,DispReturnQty,DispReturnRpAmt,StartRpAmt,EndRpAmt,AdjQty,AdjRpAmt,RecQty,RecRpAmt,RetQty,RetRpAmt,
				ScrapQty,ScrapRpAmt,InDispQty,InDispRpAmt,InDispRetQty,InDispRetRpAmt,Prp,Psp,Margin,AspAmoutRpAmt,AspAmoutSpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
