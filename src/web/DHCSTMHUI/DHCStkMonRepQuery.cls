Import sqluser

Class web.DHCSTMHUI.DHCStkMonRepQuery Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 按分类检索并汇总月报数据
/// Author:zhwh
/// Data:2012-11-05   
/// Update : 20181022 lihui
/// Argu:
///  sm - 月报主表rowid;StrParam 参数串
Query StkMonSumByIncCat(sm As %String, StrParam As %String) As Query(ROWSPEC = "grpDesc,catdesc,LastAmt:%Float,Amt:%Float,RecAmt:%Float,RetAmt:%Float,TroAmt:%Float,TriAmt:%Float,AdjAmt:%Float,ConAmt:%Float,DisAmt:%Float,DspAmt:%Float,AspAmt:%Float,PhaRetAmt:%Float,RetAspAmt:%Float,PhaRetAspAmt:%Float,GiftRecAmt:%Float,giftTrfAmt:%Float,chgRecAmt:%Float,chgRetAmt:%Float,mRecAmt:%Float,stktkAdjAmt:%Float,manuXAmt:%Float,manuMAmt:%Float,phoRetAspAmt:%Float,trfIAspAmt:%Float,InAmt:%Float,OutAmt:%Float,catCode,grpCode") [ SqlProc ]
{
}

ClassMethod StkMonSumByIncCatExecute(ByRef qHandle As %Binary, sm As %String, StrParam As %String) As %Status
{
	n (qHandle, sm, StrParam)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:sm="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(StrParam)
	s ScgType=PJobj.%Get("ScgType")
	s:ScgType="" ScgType=..sssCode()
	s type=PJobj.%Get("Type")
	k ^TMP("STKMONCAT",$j,sm)
	i type="1" s rows=..CalStkMonCat(sm,"",ScgType)   //售价统计
	e  s rows=..CalStkMonCatIN(sm,ScgType)   //进价统计
	q:rows'>0 $$$OK

	s grpDesc=""
	f  s grpDesc=$o(^TMP("STKMONCAT",$j,sm,grpDesc)) q:grpDesc=""  d
	.s cat="" 
	.f  s cat=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat)) q:cat=""  d 
	..
	..s In=0
	..s Out=0
	..s LastAmt=0
	..s Amt=0
	..s RecAmt=0
	..s RetAmt=0
	..s TroAmt=0
	..s TriAmt=0
	..s AdjAmt=0
	..s ConAmt=0
	..s DisAmt=0
	..s DspAmt=0  //发药金额汇总
	..s AspAmt=0
	..s GiftRecAmt=0
	..s PhaRetAspAmt=0
	..s RetAspAmt=0
	..s PhaRetAmt=0   //退药金额汇总
	..s giftTrfAmt=0
	..s chgRecAmt=0
	..s chgRetAmt=0
	..s mRecAmt=0
	..s stktkAdjAmt=0
	..s manuXAmt=0
	..s manuMAmt=0
	..s phoRetAspAmt=0
	..s trfIAspAmt=0
	..s DspAmtP=0
	..s DspAmtF=0
	..s DspAmtS=0
	..s PhaRetAmtY=0
	..s PhaRetAmtH=0
	..s PhaRetAmtZ=0
	..
	..s nn=0
	..f  s nn=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)) q:nn=""  d
	...s amt=^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)
	...s LastAmt=LastAmt+$p(amt,"^",1)
	...s Amt=Amt+$p(amt,"^",2)
	...s RecAmt=RecAmt+$p(amt,"^",3)
	...s RetAmt=RetAmt+$p(amt,"^",4)
	...s TroAmt=TroAmt+$p(amt,"^",5)
	...s TriAmt=TriAmt+$p(amt,"^",6)
	...s AdjAmt=AdjAmt+$p(amt,"^",7)
	...s ConAmt=ConAmt+$p(amt,"^",8)
	...s DisAmt=DisAmt+$p(amt,"^",9)
	...s DspAmtP=DspAmtP+$p(amt,"^",11)
	...s DspAmtF=DspAmtF+$p(amt,"^",13)
	...s DspAmtS=DspAmtS+$p(amt,"^",14)
	...s DspAmt=DspAmt+$p(amt,"^",11)+$p(amt,"^",13)+$p(amt,"^",14)   //发药(门诊、住院汇总)
	...s AspAmt=AspAmt+$p(amt,"^",10)
	...s PhaRetAmtY=PhaRetAmtY+$p(amt,"^",12)
	...s PhaRetAmtH=PhaRetAmtH+$p(amt,"^",15)
	...s PhaRetAmtZ=PhaRetAmtZ+$p(amt,"^",16)
	...s PhaRetAmt=PhaRetAmt+$p(amt,"^",12)+$p(amt,"^",15)+$p(amt,"^",16)  //退药(门诊、住院汇总)
	...s GiftRecAmt=GiftRecAmt+$p(amt,"^",17)
	...s RetAspAmt=RetAspAmt+$p(amt,"^",18)
	...s PhaRetAspAmt=PhaRetAspAmt+$p(amt,"^",19)
	...s giftTrfAmt=giftTrfAmt+$p(amt,"^",20)
	...s chgRecAmt=chgRecAmt+$p(amt,"^",21)
	...s chgRetAmt=chgRetAmt+$p(amt,"^",22)
	...s mRecAmt = mRecAmt+$p(amt,"^",23)
	...s stktkAdjAmt=stktkAdjAmt+$p(amt,"^",24)
	...s manuXAmt=manuXAmt+$p(amt,"^",25)
	...s manuMAmt=manuMAmt+$p(amt,"^",26)
	...s phoRetAspAmt=phoRetAspAmt+$p(amt,"^",27)
	...s trfIAspAmt= trfIAspAmt+$p(amt,"^",28)
	...s catCode=$p(amt,"^",29)
	...s grpCode=$p(amt,"^",30)
	..s In=RecAmt+TriAmt+PhaRetAmt+manuXAmt
	..s Out=RetAmt+TroAmt+ConAmt+DisAmt+DspAmt+manuMAmt+giftTrfAmt
	..i AdjAmt>0 s In=In+AdjAmt
	..e  s Out=Out+AdjAmt
	..i stktkAdjAmt>0 s In=In+stktkAdjAmt
	..e  s Out=Out+stktkAdjAmt
	..i AspAmt>0 s In=In+AspAmt
	..e  s Out=Out+AspAmt
	..i RetAspAmt>0 s In=In+RetAspAmt
	..e  s Out=Out+RetAspAmt
	..i PhaRetAspAmt>0 s In=In+PhaRetAspAmt
	..e  s Out=Out+PhaRetAspAmt
	..i phoRetAspAmt>0 s In=In+phoRetAspAmt
	..e  s Out=Out+phoRetAspAmt
	..i trfIAspAmt>0 s In=In+trfIAspAmt
	..e  s Out=Out+trfIAspAmt
	..s catdesc=$p(^INC("SC",cat),"^",2)
	..d OutPutRow 

	k ^TMP("STKMONCAT",$j,sm)
	Quit $$$OK
OutPutRow
	s Data=$lb(grpDesc,catdesc,LastAmt,Amt,RecAmt,RetAmt,TroAmt,TriAmt,AdjAmt,ConAmt,DisAmt,DspAmt,AspAmt,PhaRetAmt,RetAspAmt,PhaRetAspAmt,GiftRecAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt,In,Out,catCode,grpCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 按分类汇总统计月报明细数据(售价)
/// Author:zhwh
/// Date:2012-11-06
/// Argu:
///  sm - 月报主表rowid
///  catdr - 库存分类rowid
/// Return:
///  条数
/// Table List:
///   DHC_StkMonReport
///   DHC_StkMonStat
ClassMethod CalStkMonCat(sm As %String, catdr As %String = "", ScgType = "M") As %String
{
	n (sm,catdr,ScgType)
	s:ScgType="" ScgType="M"
	s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)

	s n=0
	k ^TMP("STKMONCAT",$j,sm)
	s ch=""
	f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d   
	.s data=^DHCSM(sm,"R",ch)  
	.s rowid=sm_"||"_ch  ;rowid
	.s inci=$p(data,"^",3)    ;inci   
	.s cat=$p(^INCI(inci,2),"^",2)
	.i catdr'="" q:cat'=catdr
	.;根据科室类组权限的"月报标记"(对应的库存分类)做过滤
	.q:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_cat_"^"))
	.
	.s str=##class(web.DHCSTMHUI.Common.DrugInfoCommon).StkCatGrpStr(cat,ScgType)
	.s grpDesc=$p(str,"^",2)
	.i grpDesc="" s grpDesc="不详"
	.
	.s amount=$p(data,"^",7)  ;amount
	.s lastAmount=$p(data,"^",10)    ;amount of last month
	.s statrowid=$o(^SMSTAT(0,"SMR",rowid,""))
	.s (recAmt,retAmt,trOAmt,trIAmt,adjAmt,conAmt,disposAmt,aspAmt,phaDspAmtP,phaRetAmtY,phaDspAmtF,phaDspAmtS,phaRetAmtH,phaRetAmtZ,giftRecAmt,retAspAmt,phaRetAspAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt)=0
	.i statrowid'=""  d
	..s aaa=$G(^SMSTAT(statrowid))
	..s recAmt=$p(aaa,"^",3)
	..s retAmt=$p(aaa,"^",5)
	..s trOAmt=$p(aaa,"^",7)
	..s trIAmt=$p(aaa,"^",9)
	..s adjAmt=$p(aaa,"^",11)
	..s conAmt=$p(aaa,"^",13)
	..s disposAmt=$p(aaa,"^",15)
	..s aspAmt=$p(aaa,"^",18)
	..
	..s phaDspAmtP=$p(aaa,"^",17)   //住院发药
	..s phaRetAmtY=$p(aaa,"^",20) //住院退药
	..s phaDspAmtF=$p(aaa,"^",22)   //门诊发药
	..s phaDspAmtS=$p(aaa,"^",24)  //门诊发药(非正常)
	..s phaRetAmtH=$p(aaa,"^",26)  //门诊退药
	..s phaRetAmtZ=$p(aaa,"^",28)  //门诊退药(非正常)
	..
	..s giftRecAmt=$p(aaa,"^",30)  //赠品入库
	..s giftTrfAmt=$p(aaa,"^",32)  //赠品出库
	..
	..s chgRecAmt=$p(aaa,"^",34)
	..s chgRetAmt=$p(aaa,"^",36)
	..
	..s retAspAmt=$p(aaa,"^",37)  //退货调价损益
	..s phaRetAspAmt=$p(aaa,"^",38)  //住院退药调价损益
	..
	..s mRecAmt=$p(aaa,"^",40)		//制剂入库金额
	..s stktkAdjAmt=$p(aaa,"^",42)  //盘点调整
	..
	..s manuXAmt=$p(aaa,"^",44)
	..s manuMAmt=$p(aaa,"^",46)
	..
	..s phoRetAspAmt=$p(aaa,"^",47)  //门诊退药调价损益
	..s trfIAspAmt=$p(aaa,"^",48) //转移入库调价损益
	..
	.;
	.s n=n+1
	.s amt=lastAmount
	.s amt=amt_"^"_amount
	.s amt=amt_"^"_recAmt
	.s amt=amt_"^"_retAmt
	.s amt=amt_"^"_trOAmt
	.s amt=amt_"^"_trIAmt
	.s amt=amt_"^"_adjAmt
	.s amt=amt_"^"_conAmt
	.s amt=amt_"^"_disposAmt
	.s amt=amt_"^"_aspAmt
	.s amt=amt_"^"_phaDspAmtP
	.s amt=amt_"^"_phaRetAmtY
	.s amt=amt_"^"_phaDspAmtF
	.s amt=amt_"^"_phaDspAmtS
	.s amt=amt_"^"_phaRetAmtH
	.s amt=amt_"^"_phaRetAmtZ
	.s amt=amt_"^"_giftRecAmt
	.s amt=amt_"^"_retAspAmt
	.s amt=amt_"^"_phaRetAspAmt
	.s amt=amt_"^"_giftTrfAmt
	.s amt=amt_"^"_chgRecAmt
	.s amt=amt_"^"_chgRetAmt
	.s amt=amt_"^"_mRecAmt
	.s amt=amt_"^"_stktkAdjAmt
	.s amt=amt_"^"_manuXAmt
	.s amt=amt_"^"_manuMAmt
	.s amt=amt_"^"_phoRetAspAmt
	.s amt=amt_"^"_trfIAspAmt
	.
	.s ^TMP("STKMONCAT",$j,sm,grpDesc,cat,n)=amt
	q n
}

/// 按分类汇总统计月报明细数据(进价)
/// Author:zhwh
/// Date:2012-11-06
/// Argu:
///  sm - 月报主表rowid
///  catdr - 库存分类rowid
/// Return:
///    记录数
/// Table List:
///   DHC_StkMonReport
///   DHC_StkMonStatIn
ClassMethod CalStkMonCatIN(sm As %String, ScgType As %String = "M") As %String
{
	n (sm,ScgType)
	s:ScgType="" ScgType="M"
	s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)

	s n=0
	k ^TMP("STKMONCAT",$j,sm)
	s ch=""
	f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	.s data=^DHCSM(sm,"R",ch)  
	.s rowid=sm_"||"_ch
	.s inci=$p(data,"^",3)
	.s cat=$p(^INCI(inci,2),"^",2)
	.;根据科室类组权限的"月报标记"做过滤
	.q:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_cat_"^"))
	.
	.s catCode=$p(^INC("SC",cat),"^",1)
	.s str=##class(web.DHCSTMHUI.Common.DrugInfoCommon).StkCatGrpStr(cat,ScgType)
	.s grpCode=$p(str,"^",1)
	.s grpDesc=$p(str,"^",2)
	.i grpDesc="" s grpDesc="不详"
	.
	.s amount=$p(data,"^",8)
	.s lastAmount=$p(data,"^",11)
	.s statinrowid=$o(^SMSTATI(0,"SMR",rowid,""))
	.s (recAmt,retAmt,trOAmt,trIAmt,adjAmt,conAmt,disposAmt,aspAmt,phaDspAmtP,phaRetAmtY,phaDspAmtF,phaDspAmtS,phaRetAmtH,phaRetAmtZ,giftRecAmt,retAspAmt,phaRetAspAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt,lastfinamount,finamount,fininamount,finoutamount)=0
	.i statinrowid'=""  d
	..s aaa=$G(^SMSTATI(statinrowid))
	..s recAmt=$p(aaa,"^",3)   //入库金额
	..s retAmt=$p(aaa,"^",5)   //退货金额
	..s trOAmt=$p(aaa,"^",7)   //转出金额
	..s trIAmt=$p(aaa,"^",9)    //转入金额
	..s adjAmt=$p(aaa,"^",11)    //调整金额
	..s conAmt=$p(aaa,"^",13)    //消耗金额
	..s disposAmt=$p(aaa,"^",15)  //报损金额
	..s aspAmt=$p(aaa,"^",18)     //调价损益金额
	..s phaDspAmtP=$p(aaa,"^",17)  //销售金额（住院）
	..s phaRetAmtY=$p(aaa,"^",20)  //销售退回金额（住院）
	..s phaDspAmtF=$p(aaa,"^",30)   //销售金额（门诊）
	..s phaDspAmtS=$p(aaa,"^",32)   //销售金额（特殊）
	..s phaRetAmtH=$p(aaa,"^",34)   //销售退回金额（门诊）
	..s phaRetAmtZ=$p(aaa,"^",36)   //销售退回金额（特殊）
	..
	..s giftRecAmt=$p(aaa,"^",22)  //赠品入库
	..s giftTrfAmt=$p(aaa,"^",24)  //赠品出库
	..
	..s chgRecAmt=$p(aaa,"^",26)  //调价换票入库金额
	..s chgRetAmt=$p(aaa,"^",28)  //调价换票退货金额
	..
	..s trfIAspAmt=$p(aaa,"^",38) //转移入库调价损益
	..s retAspAmt=$p(aaa,"^",39)  //退货调价损益
	..s stktkAdjAmt=$p(aaa,"^",41)  //盘点调整
	..
	..s manuXAmt=$p(aaa,"^",44)    //制剂生成数量
	..s manuMAmt=$p(aaa,"^",46)
	..s mRecAmt=$p(aaa,"^",47)
	..
	..s phoRetAspAmt=$p(aaa,"^",48)  //门诊退药调价损益
	..s phaRetAspAmt=$p(aaa,"^",49)  //住院退药调价损益
	..
	..s lastfinamount=$p(aaa,"^",58)
	..s finamount=$p(aaa,"^",59)
	..s fininamount=$p(aaa,"^",60)
	..s finoutamount=$p(aaa,"^",61)
	.s n=n+1
	.
	.s amt=lastAmount
	.s amt=amt_"^"_amount
	.s amt=amt_"^"_recAmt
	.s amt=amt_"^"_retAmt
	.s amt=amt_"^"_trOAmt
	.s amt=amt_"^"_trIAmt
	.s amt=amt_"^"_adjAmt
	.s amt=amt_"^"_conAmt
	.s amt=amt_"^"_disposAmt
	.s amt=amt_"^"_aspAmt
	.s amt=amt_"^"_phaDspAmtP
	.s amt=amt_"^"_phaRetAmtY
	.s amt=amt_"^"_phaDspAmtF
	.s amt=amt_"^"_phaDspAmtS
	.s amt=amt_"^"_phaRetAmtH
	.s amt=amt_"^"_phaRetAmtZ
	.s amt=amt_"^"_giftRecAmt
	.s amt=amt_"^"_retAspAmt
	.s amt=amt_"^"_phaRetAspAmt
	.s amt=amt_"^"_giftTrfAmt
	.s amt=amt_"^"_chgRecAmt
	.s amt=amt_"^"_chgRetAmt
	.s amt=amt_"^"_mRecAmt
	.s amt=amt_"^"_stktkAdjAmt
	.s amt=amt_"^"_manuXAmt
	.s amt=amt_"^"_manuMAmt
	.s amt=amt_"^"_phoRetAspAmt
	.s amt=amt_"^"_trfIAspAmt
	.s amt=amt_"^"_catCode
	.s amt=amt_"^"_grpCode
	.s amt=amt_"^"_lastfinamount
	.s amt=amt_"^"_finamount
	.s amt=amt_"^"_fininamount
	.s amt=amt_"^"_finoutamount
	.s ^TMP("STKMONCAT",$j,sm,grpDesc,cat,n)=amt
	q n
}

/// 按类组汇总并检索月报明细数据
/// Author:zhwh
/// Date:2012-11-07
/// Argu:
///   sm - 月报主表rowid
///   type - 核算价格类型(1 -售价 0 - 进价)
/// 
Query StkMonSumBySCG(sm As %String, type As %String, ScgType As %String = "M") As Query(ROWSPEC = "grpDesc,LastAmt:%Float,Amt:%Float,RecAmt:%Float,RetAmt:%Float,TroAmt:%Float,TriAmt:%Float,AdjAmt:%Float,ConAmt:%Float,DisAmt:%Float,DspAmt:%Float,AspAmt:%Float,PhaRetAmt:%Float,RetAspAmt:%Float,PhaRetAspAmt:%Float,GiftRecAmt:%Float,giftTrfAmt:%Float,chgRecAmt:%Float,chgRetAmt:%Float,stktkAdjAmt:%Float,phoRetAspAmt:%Float,trfIAspAmt:%Float,InAmt:%Float,OutAmt:%Float,lastfinamt:%Float,finamt:%Float,fininamt:%Float,finoutamt:%Float") [ SqlProc ]
{
}

ClassMethod StkMonSumBySCGExecute(ByRef qHandle As %Binary, sm As %String, type As %String, ScgType As %String = "M") As %Status
{
	n (qHandle,sm,type,ScgType)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:sm="" $$$OK
	s:ScgType="" ScgType="M"
	k ^TMP("STKMONCAT",$j,sm)
	i type="1" s rows=..CalStkMonCat(sm,"",ScgType)   //售价统计
	e  s rows=..CalStkMonCatIN(sm,ScgType)   //进价统计
	q:rows'>0 $$$OK

	s grpDesc=""
	f  s grpDesc=$o(^TMP("STKMONCAT",$j,sm,grpDesc)) q:grpDesc=""  d
	.
	.s In=0
	.s Out=0
	.s LastAmt=0
	.s Amt=0
	.s RecAmt=0
	.s RetAmt=0
	.s TroAmt=0
	.s TriAmt=0
	.s AdjAmt=0
	.s ConAmt=0
	.s DisAmt=0
	.s DspAmt=0  //发药金额汇总
	.s AspAmt=0
	.s GiftRecAmt=0
	.s PhaRetAspAmt=0
	.s RetAspAmt=0
	.s PhaRetAmt=0   //退药金额汇总
	.s giftTrfAmt=0
	.s chgRecAmt=0
	.s chgRetAmt=0
	.s stktkAdjAmt=0
	.s phoRetAspAmt=0
	.s trfIAspAmt=0
	.s DspAmtP=0
	.s DspAmtF=0
	.s PhaRetAmtY=0
	.s PhaRetAmtH=0
	.s PhaRetAmtZ=0
	.s lastfinamt=0
	.s finamt=0
	.s fininamt=0
	.s finoutamt=0
	.
	.s cat="" f  s cat=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat)) q:cat=""  d
	..s nn=0
	..f  s nn=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)) q:nn=""  d
	...s amt=^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)
	...s LastAmt=$g(LastAmt)+$p(amt,"^",1)
	...s Amt=$g(Amt)+$p(amt,"^",2)
	...s RecAmt=RecAmt+$p(amt,"^",3)
	...s RetAmt=RetAmt+$p(amt,"^",4)
	...s TroAmt=TroAmt+$p(amt,"^",5)
	...s TriAmt=TriAmt+$p(amt,"^",6)
	...s AdjAmt=AdjAmt+$p(amt,"^",7)
	...s ConAmt=ConAmt+$p(amt,"^",8)
	...s DisAmt=DisAmt+$p(amt,"^",9)
	...s DspAmtP=DspAmtP+$p(amt,"^",11)
	...s DspAmtF=DspAmtF+$p(amt,"^",13)
	...s DspAmt=DspAmt+$p(amt,"^",11)+$p(amt,"^",13)   //发药(门诊、住院汇总)
	...s AspAmt=AspAmt+$p(amt,"^",10)
	...s PhaRetAmtY=PhaRetAmtY+$p(amt,"^",12)
	...s PhaRetAmtH=PhaRetAmtH+$p(amt,"^",15)
	...s PhaRetAmtZ=PhaRetAmtZ+$p(amt,"^",16)
	...s PhaRetAmt=PhaRetAmt+$p(amt,"^",12)+$p(amt,"^",15)+$p(amt,"^",16)  //退药(门诊、住院汇总)
	...s GiftRecAmt=GiftRecAmt+$p(amt,"^",17)
	...s RetAspAmt=RetAspAmt+$p(amt,"^",18)
	...s PhaRetAspAmt=PhaRetAspAmt+$p(amt,"^",19)
	...s giftTrfAmt=giftTrfAmt+$p(amt,"^",20)
	...s chgRecAmt=chgRecAmt+$p(amt,"^",21)
	...s chgRetAmt=chgRetAmt+$p(amt,"^",22)
	...s stktkAdjAmt=stktkAdjAmt+$p(amt,"^",24)
	...s phoRetAspAmt=phoRetAspAmt+$p(amt,"^",27)
	...s trfIAspAmt= trfIAspAmt+$p(amt,"^",28)
	...s lastfinamt=lastfinamt+$p(amt,"^",31)
	...s finamt=finamt+$p(amt,"^",32)
	...s fininamt=fininamt+$p(amt,"^",33)
	...s finoutamt=finoutamt+$p(amt,"^",34)
	.s In=RecAmt+TriAmt+PhaRetAmt //入库金额+转入金额+患者退药金额
	.s Out=RetAmt+TroAmt+ConAmt+DisAmt+DspAmt+giftTrfAmt //退货金额+转出金额+消耗金额+报损金额+发药金额+赠品出库
	.i AdjAmt>0 s In=In+AdjAmt
	.e  s Out=Out+AdjAmt
	.i stktkAdjAmt>0 s In=In+stktkAdjAmt
	.e  s Out=Out+stktkAdjAmt
	.i AspAmt>0 s In=In+AspAmt
	.e  s Out=Out+AspAmt
	.i RetAspAmt>0 s In=In+RetAspAmt
	.e  s Out=Out+RetAspAmt
	.i PhaRetAspAmt>0 s In=In+PhaRetAspAmt
	.e  s Out=Out+PhaRetAspAmt
	.i phoRetAspAmt>0 s In=In+phoRetAspAmt
	.e  s Out=Out+phoRetAspAmt
	.i trfIAspAmt>0 s In=In+trfIAspAmt
	.e  s Out=Out+trfIAspAmt
	.
	.d OutPutRow2 
	k ^TMP("STKMONCAT",$j,sm)
	Quit $$$OK
OutPutRow2
	s Data=$lb(grpDesc,LastAmt,Amt,RecAmt,RetAmt,TroAmt,TriAmt,AdjAmt,ConAmt,DisAmt,DspAmt,AspAmt,PhaRetAmt,RetAspAmt,PhaRetAspAmt,GiftRecAmt,giftTrfAmt,chgRecAmt,chgRetAmt,stktkAdjAmt,phoRetAspAmt,trfIAspAmt,In,Out,lastfinamt,finamt,fininamt,finoutamt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 检索月报明细记录(售价)
/// Author:zhwh
/// Date:2012-11-05
/// update : 20181022 lihui
/// Argu:
///  Params 参数对象  %List
/// "{""smRowid"":""23"",""ScgType"":""O"",""stkgrpid"":""14"",""stkcatid"":""62"",""incdesc"":"""",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonRepQuery","StkMonRepItm",^templxt("mon"))
Query StkMonRepItm(Params As %Text) As Query(ROWSPEC = "Rowid,inci,inciCode,inciDesc,spec,uomDesc,qty:%Float,amt:%Float,lastQty:%Float,lastAmt:%Float,recQty:%Float,recAmt:%Float,retQty:%Float,retAmt:%Float,trOutQty:%Float,trOutAmt:%Float,trInQty:%Float,trInAmt:%Float,adjQty:%Float,adjAmt:%Float,csmQty:%Float,csmAmt:%Float,disposeQty:%Float,disposeAmt:%Float,phaInDspQty:%Float,phaInDspAmt:%Float,aspAmt:%Float,phaInRetQty:%Float,phaInRetAmt:%Float,phaOutDspQty:%Float,phaOutDspAmt:%Float,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty:%Float,phaOutRetAmt:%Float,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty:%Float,giftRecAmt:%Float,giftTrOutQty:%Float,giftTrOutAmt:%Float,chgRecQty:%Float,chgRecAmt:%Float,chgRetQty:%Float,chgRetAmt:%Float,retAspAmt:%Float,phaRetAspAmt:%Float,mRecQty:%Float,mRecAmt:%Float,stktkAdjQty:%Float,stktkAdjAmt:%Float,manuXQty:%Float,manuXAmt:%Float,manuMQty:%Float,manuMAmt:%Float,phaOutRetAspAmt:%Float,trInAspAmt:%Float,diffQty:%Float,diffAmt:%Float") [ SqlProc ]
{
}

ClassMethod StkMonRepItmExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
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
	s ScgType=PJobj.%Get("ScgType")
	s:ScgType="" ScgType=..sssCode()
	s MonLoc=$p(^DHCSM(sm),"^",1)
	s HospId=..sssHospId(MonLoc)
	s stkgrpid=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",stkgrpid,HospId)
	s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)
	s n=0
	s ch=""
	f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	.s smr=sm_"||"_ch
	.s row=^DHCSM(sm,"R",ch)
	.s inci=$p(row,"^",3)
	.q:(incid'="")&(incid'=inci)			;库存项不符
	.s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci,ScgType)
	.s grpid=$p(stkgrpinfo,"^",5)
	.q:(stkgrpid'="")&&(("^"_stkgrpid_"^")'[("^"_grpid_"^"))
	.s stkcat=$p(^INCI(inci,2),"^",2)
	.q:(stkcatid'="")&(stkcat'=stkcatid)
	.;根据科室类组权限的"月报标记"做过滤
	.q:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_stkcat_"^"))
	.s inciCode=$p(^INCI(inci,1),"^",1)
	.s inciDesc=$p(^INCI(inci,1),"^",2)
	.q:(incdesc'="")&('$f(inciDesc,incdesc))
	.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	.s inciuomdr=$p(^INCI(inci,1),"^",10)
	.s puruom=$p(^INCI(inci,3),"^",6)
	.i puruom="" s puruom=inciuomdr
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruom,inciuomdr)
	.s uomDesc=$p(^CT("UOM",puruom),"^",2)
	.s qty=$p(row,"^",6)
	.s qty=qty/fac
	.s amt=$p(row,"^",7)
	.s amt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(amt,HospId)
	.s lastQty=$p(row,"^",9)
	.s lastQty=lastQty/fac
	.s lastAmt=$p(row,"^",10)
	.s stat=$o(^SMSTAT(0,"SMR",smr,""))
	.q:stat=""
	.s stats=$G(^SMSTAT(stat))
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
	.s phaOutDspQty=$P(stats,"^",21)/fac ;发药数量(门诊)
	.s phaOutDspAmt=$P(stats,"^",22)   ;发药金额(门诊)
	.s phaOutDspQtyS=$P(stats,"^",23)/fac  ;发药数量(门诊非正常)
	.s phaOutDspAmtS=$P(stats,"^",24) ;发药金额(门诊非正常)
	.s phaOutRetQty=$P(stats,"^",25)/fac  ;退药数量(门诊)
	.s phaOutRetAmt=$P(stats,"^",26)  ;退药金额(门诊)
	.s phaOutRetQtyZ=$P(stats,"^",27)/fac   ;退药数量(门诊非正常)
	.s phaOutRetAmtZ=$P(stats,"^",28)  ;退药金额量(门诊非正常)
	.s giftRecQty=$P(stats,"^",29)/fac ;入库数量(赠品)
	.s giftRecAmt=$P(stats,"^",30)  ;入库(赠品)
	.s giftTrOutQty=$P(stats,"^",31)/fac ;转出数量(赠品)
	.s giftTrOutAmt=$P(stats,"^",32)  ;转出金额(赠品)
	.s chgRecQty=$P(stats,"^",33)/fac ;入库数量(调价换票)
	.s chgRecAmt=$P(stats,"^",34)  ;入库金额(调价换票)
	.s chgRetQty=$P(stats,"^",35)/fac ;退货数量(调价换票)
	.s chgRetAmt=$P(stats,"^",36)  ;退货金额(调价换票)
	.
	.s retAspAmt=$P(stats,"^",37)    ;退货调价损益
	.s phaRetAspAmt=$P(stats,"^",38)  ;住院退药调价损益
	.s mRecQty=$P(stats,"^",39)/fac
	.s mRecAmt=$P(stats,"^",40)
	.s stktkAdjQty=$P(stats,"^",41)/fac  ;盘点调整数量
	.s stktkAdjAmt=$P(stats,"^",42)  ;盘点调整金额 
	.
	.s manuXQty=$P(stats,"^",43)/fac
	.s manuXAmt=$P(stats,"^",44)
	.s manuMQty=$P(stats,"^",45)/fac
	.s manuMAmt=$P(stats,"^",46)
	.s phaOutRetAspAmt=$P(stats,"^",47)  ;门诊退药调价损益
	.s trInAspAmt=$P(stats,"^",48)  ;库存转入调价损益
	.s diffQty=lastQty+recQty+retQty+trOutQty+trInQty+adjQty+csmQty+disposeQty+giftRecQty+giftTrOutQty+chgRecQty+chgRetQty+mRecQty+stktkAdjQty+manuXQty+manuMQty-qty
	.s diffAmt=lastAmt+recAmt+retAmt+trOutAmt+trInAmt+adjAmt+csmAmt+disposeAmt+giftRecAmt+giftTrOutAmt+chgRecAmt+chgRetAmt+mRecAmt+stktkAdjAmt+manuXAmt+manuMAmt+trInAspAmt+aspAmt+retAspAmt-amt
	.d OutPutRow1
	.
	Quit $$$OK
	
OutPutRow1
	s Data=$lb(stat,inci,inciCode,inciDesc,spec,uomDesc,qty,amt,lastQty,lastAmt,recQty,recAmt,retQty,retAmt,trOutQty,trOutAmt,trInQty,trInAmt,adjQty,adjAmt,csmQty,csmAmt,disposeQty,disposeAmt,phaInDspQty,phaInDspAmt,aspAmt,phaInRetQty,phaInRetAmt,phaOutDspQty,phaOutDspAmt,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty,phaOutRetAmt,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty,giftRecAmt,giftTrOutQty,giftTrOutAmt,chgRecQty,chgRecAmt,chgRetQty,chgRetAmt,retAspAmt,phaRetAspAmt,mRecQty,mRecAmt,stktkAdjQty,stktkAdjAmt,manuXQty,manuXAmt,manuMQty,manuMAmt,phaOutRetAspAmt,trInAspAmt,diffQty,diffAmt)
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
Query StkMonRepItmRp(Params As %List) As Query(ROWSPEC = "inciCode,inciDesc,spec,uomDesc,qty:%Float,amt:%Float,lastQty:%Float,lastAmt:%Float,recQty:%Float,recAmt:%Float,retQty:%Float,retAmt:%Float,trOutQty:%Float,trOutAmt:%Float,trInQty:%Float,trInAmt:%Float,adjQty:%Float,adjAmt:%Float,csmQty:%Float,csmAmt:%Float,disposeQty:%Float,disposeAmt:%Float,phaInDspQty:%Float,phaInDspAmt:%Float,aspAmt:%Float,phaInRetQty:%Float,phaInRetAmt:%Float,phaOutDspQty:%Float,phaOutDspAmt:%Float,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty:%Float,phaOutRetAmt:%Float,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty:%Float,giftRecAmt:%Float,giftTrOutQty:%Float,giftTrOutAmt:%Float,chgRecQty:%Float,chgRecAmt:%Float,chgRetQty:%Float,chgRetAmt:%Float,retAspAmt:%Float,phaRetAspAmt:%Float,mRecQty:%Float,mRecAmt:%Float,stktkAdjQty:%Float,stktkAdjAmt:%Float,manuXQty:%Float,manuXAmt:%Float,manuMQty:%Float,manuMAmt:%Float,phaOutRetAspAmt:%Float,trInAspAmt:%Float,diffQty:%Float,diffAmt:%Float") [ SqlProc ]
{
}

ClassMethod StkMonRepItmRpExecute(ByRef qHandle As %Binary, Params As %List) As %Status
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
	s ScgType=PJobj.%Get("ScgType")
	s:ScgType="" ScgType=..sssCode()
	s MonLoc=$p(^DHCSM(sm),"^",1)
	s HospId=..sssHospId(MonLoc)
	s stkgrpid=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",stkgrpid,HospId)
	s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)
	s n=0
	s ch=""
	f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	.s smr=sm_"||"_ch
	.s row=^DHCSM(sm,"R",ch)
	.s inci=$p(row,"^",3)
	.q:(incid'="")&(incid'=inci)			;库存项不符
	.s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci,ScgType)
	.s grpid=$p(stkgrpinfo,"^",5)
	.q:(stkgrpid'="")&&(("^"_stkgrpid_"^")'[("^"_grpid_"^"))
	.
	.s stkcat=$p(^INCI(inci,2),"^",2)
	.q:(stkcatid'="")&(stkcat'=stkcatid)
	.;根据科室类组权限的"月报标记"做过滤
	.q:(locIncscStr'="")&&(("^"_locIncscStr_"^")'[("^"_stkcat_"^"))
	.
	.s inciCode=$p(^INCI(inci,1),"^",1)
	.s inciDesc=$p(^INCI(inci,1),"^",2)
	.q:(incdesc'="")&('$f(inciDesc,incdesc))
	.
	.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	.s inciuomdr=$p(^INCI(inci,1),"^",10)
	.s puruom=$p(^INCI(inci,3),"^",6)
	.i puruom="" s puruom=inciuomdr
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruom,inciuomdr)
	.s uomDesc=$p(^CT("UOM",puruom),"^",2)
	.s qty=$p(row,"^",6)
	.s qty=qty/fac
	.s amt=$p(row,"^",8)
	.s amt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(amt,HospId)
	.s lastQty=$p(row,"^",9)
	.s lastQty=lastQty/fac
	.s lastAmt=$p(row,"^",11)
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
	.s diffQty=lastQty+recQty+retQty+trOutQty+trInQty+adjQty+csmQty+disposeQty+giftRecQty+giftTrOutQty+chgRecQty+chgRetQty+mRecQty+stktkAdjQty+manuXQty+manuMQty-qty
	.s diffAmt=lastAmt+recAmt+retAmt+trOutAmt+trInAmt+adjAmt+csmAmt+disposeAmt+giftRecAmt+giftTrOutAmt+chgRecAmt+chgRetAmt+mRecAmt+stktkAdjAmt+manuXAmt+manuMAmt+trInAspAmt+aspAmt+retAspAmt-amt
	.d OutPutRowR
	.
	Quit $$$OK

OutPutRowR
	s Data=$lb(inciCode,inciDesc,spec,uomDesc,qty,amt,lastQty,lastAmt,recQty,recAmt,retQty,retAmt,trOutQty,trOutAmt,trInQty,trInAmt,adjQty,adjAmt,csmQty,csmAmt,disposeQty,disposeAmt,phaInDspQty,phaInDspAmt,aspAmt,phaInRetQty,phaInRetAmt,phaOutDspQty,phaOutDspAmt,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty,phaOutRetAmt,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty,giftRecAmt,giftTrOutQty,giftTrOutAmt,chgRecQty,chgRecAmt,chgRetQty,chgRetAmt,retAspAmt,phaRetAspAmt,mRecQty,mRecAmt,stktkAdjQty,stktkAdjAmt,manuXQty,manuXAmt,manuMQty,manuMAmt,phaOutRetAspAmt,trInAspAmt,diffQty,diffAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据dhc_stkmontrans数据,查询出库汇总数据
/// Author:	wangjiabin
/// Date:	2015-08-06
/// Argu:
///   sm - 月报主表rowid, StkGrpId, StrParam(类组类型(M:物资类组,O财务类组)^...)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonRepQuery","StkMonRepTransDetail",407,"")
Query StkMonRepTransDetail(sm As %String, StrParam As %String = "") As Query(ROWSPEC = "smtID,inci,InciCode,InciDesc,PUomDesc,transType,qty:%Float,qtyPUom:%Float,transRpAmt:%Float,transSpAmt:%Float,transLoc,transLocDesc,transSLG,tranSLGDesc,Incsc,IncscDesc,Scg,ScgDesc,VenId,VenDesc") [ SqlProc ]
{
}

ClassMethod StkMonRepTransDetailExecute(ByRef qHandle As %Binary, sm As %String, StrParam As %String = "") As %Status
{
	n (qHandle, sm, StrParam)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:sm="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(StrParam)
	s ScgType=PJobj.%Get("ScgType")
	s:ScgType="" ScgType=..sssCode()
	s StkGrpId=PJobj.%Get("StkGrpId")
	
	k InclbInfoArr
	s ch=""
	f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	.q:'$d(^DHCSM(sm,"R",ch,"T"))
	.s data=^DHCSM(sm,"R",ch)
	.s rowid=sm_"||"_ch
	.s inci=$p(data,"^",3)
	.s InciCode=$p($g(^INCI(inci,1)),"^",1)
	.s InciDesc=$p($g(^INCI(inci,1)),"^",2)
	.s BUom=$p($g(^INCI(inci,1)),"^",10)
	.s PUom=$p($g(^INCI(inci,3)),"^",6)
	.s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUom,BUom)
	.s:PUom'="" PUomDesc=$p($g(^CT("UOM",PUom)),"^",2)
	.
	.s:inci'="" Incsc=$p($g(^INCI(inci,2)),"^",2)
	.s:Incsc'="" IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).StkCatGrpStr(Incsc,ScgType)
	.s ScgDesc=$p(ScgInfo,"^",2)
	.s Scg=$p(ScgInfo,"^",5)
	.q:(StkGrpId'="")&&(StkGrpId'=Scg)
	.
	.s sub=""
	.f  s sub=$o(^DHCSM(sm,"R",ch,"T",sub)) q:sub=""  d
	..s smtID=sm_"||"_ch_"||"_sub
	..s transInfo=^DHCSM(sm,"R",ch,"T",sub)
	..s transType=$p(transInfo,"^",1)
	..q:(transType'="T")&&(transType'="K")&&(transType'="G")&&(transType'="R")
	..s pointer=$p(transInfo,"^",2)
	..s qty=-$p(transInfo,"^",3)			;转出(转入)按正数(负数)统计,乘以-1
	..s qtyPUom=qty/UomFac
	..s transSpAmt=$p(transInfo,"^",4)
	..s transRpAmt=$p(transInfo,"^",5)
	..s transLoc=$p(transInfo,"^",6)
	..s transLocDesc=$s(transLoc'="":$p(^CTLOC(transLoc),"^",2),1:"")
	..s transSLG=$p(transInfo,"^",10)
	..s tranSLGDesc=$s(transSLG'="":$p(^DHCSLG(transSLG),"^",2),1:"")
	..s transOrg=$p(transInfo,"^",14)		;transType为R,G时,记录供应商
	..
	..s VenId=$s(((transType="G")||(transType="R")):transOrg,1:"")
	..s VenDesc=$s(VenId'="":$p(^APC("APCVM",VenId),"^",3),1:"")
	..
	..d OutPutRowTransDetail
	q $$$OK

OutPutRowTransDetail
	s Data=$lb(smtID,inci,InciCode,InciDesc,PUomDesc,
			transType,qty,qtyPUom,transRpAmt,transSpAmt,
			transLoc,transLocDesc,transSLG,tranSLGDesc,Incsc,
			IncscDesc,Scg,ScgDesc,VenId,VenDesc
		)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据dhc_stkmontrans数据,查询出库汇总数据
/// Author:	wangjiabin
/// Date:	2016-09-19
/// Argu:
///   sm - 月报主表rowid,ParamStr(^^^_类组类型(M:物资类组,O财务类组)^...)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonRepQuery","GetScgForReport",426,"M")
Query GetScgForReport(sm As %String, ParamStr As %String) As Query(ROWSPEC = "ScgId,ScgCode,ScgDesc") [ SqlProc ]
{
}

ClassMethod GetScgForReportExecute(ByRef qHandle As %Binary, sm As %String, ParamStr As %String) As %Status
{
	n (qHandle,sm,ParamStr)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(ParamStr)
	s ScgType=PJobj.%Get("ScgType")
	s:ScgType="" ScgType=..sssCode()
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s ScgStr=$$GetScgStrInStkMon(sm,ScgType)	;顶层类组
	&sql(declare TopScgCursor cursor for
		select %id from DHC_StkCatGroup where SCG_Type=:ScgType and SCG_CATGRP_DR is null
			order by SCG_desc
	)
	&sql(open TopScgCursor)
	f  &sql(fetch TopScgCursor into :ScgId) q:SQLCODE  d
	.q:("^"_ScgStr_"^")'[("^"_ScgId_"^")
	.;遍历ScgId取子类组
	.d GetScgChild(ScgId,0)
	&sql(close TopScgCursor)
	Quit $$$OK

GetScgStrInStkMon(sm,ScgType)
	n (sm,ScgType)
	s:ScgType="" ScgType="M"
	s locIncscStr=##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(sm)
	s ScgStr=""
	q:locIncscStr="" ""
	s IncscLen=$l(locIncscStr,"^")
	f i=1:1:IncscLen d
	.s Incsc=$p(locIncscStr,"^",i)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).StkCatGrpStr(Incsc,ScgType,0)
	.s Scg=$p(ScgInfo,"^",5)
	.q:("^"_ScgStr_"^")[("^"_Scg_"^")
	.i ScgStr="" s ScgStr=Scg
	.e  s ScgStr=ScgStr_"^"_Scg
	q ScgStr
GetScgChild(ScgId,Level)
	n (ScgId,Level,repid,ind)
	q:ScgId=""
	s ScgCode=$p(^DHCSCG(ScgId),"^",1)
	s PreStr="",Pre=" ",PreLen=Level*3
	f i=1:1:PreLen d
	.s PreStr=PreStr_Pre
	s ScgDesc=PreStr_$p(^DHCSCG(ScgId),"^",2)	;描述前拼接前缀(顶层之后,每层添加两个字符(空格等))
	d OutPutScgRow
	i $d(^DHCSCG(0,"Parent",ScgId)) d
	.;有子类组的,递归
	.&sql(declare ChildScgCursor cursor for
		select %id from DHC_StkCatGroup where SCG_CATGRP_DR=:ScgId order by SCG_Desc)
	.&sql(open ChildScgCursor)
	.f  &sql(fetch ChildScgCursor into :ChildScgId) q:SQLCODE  d
	..d GetScgChild(ChildScgId,Level+1)
	.&sql(close ChildScgCursor)
	q
OutPutScgRow
	s Data=$lb(ScgId,ScgCode,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 按类组汇总并检索月报明细数据(适用于多级类组的特殊显示,结合上面的GetScgForReport使用)
/// Author:	wangjiabin
/// Date:	2016-09-19
/// Argu:	sm - 月报主表rowid, ^^^类组类型(M/O等)^type(0:进价,1:售价)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMonRepQuery","StkMonSumMulSCG",426,"0","M")
Query StkMonSumMulSCG(sm As %String, ParamStr As %String) As Query(ROWSPEC = "grpDesc,LastAmt:%Float,Amt:%Float,RecAmt:%Float,RetAmt:%Float,TroAmt:%Float,TriAmt:%Float,AdjAmt:%Float,ConAmt:%Float,DisAmt:%Float,DspAmt:%Float,AspAmt:%Float,PhaRetAmt:%Float,RetAspAmt:%Float,PhaRetAspAmt:%Float,GiftRecAmt:%Float,giftTrfAmt:%Float,chgRecAmt:%Float,chgRetAmt:%Float,mRecAmt:%Float,stktkAdjAmt:%Float,manuXAmt:%Float,manuMAmt:%Float,phoRetAspAmt:%Float,trfIAspAmt:%Float,InAmt:%Float,OutAmt:%Float,grpCode") [ SqlProc ]
{
}

ClassMethod StkMonSumMulSCGExecute(ByRef qHandle As %Binary, sm As %String, ParamStr As %String) As %Status
{
	n (qHandle,sm,ParamStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:sm="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(ParamStr)
	s ScgType=PJobj.%Get("ScgType")
	s type=PJobj.%Get("Type")
	s:ScgType="" ScgType="M"
	k ^TMP("STKMONCAT",$j,sm)
	i type="1" s rows=..CalStkMonCat(sm,"",ScgType)   //售价统计
	e  s rows=..CalStkMonCatIN(sm,ScgType)   //进价统计
	q:rows'>0 $$$OK

	s grpDesc=""
	f  s grpDesc=$o(^TMP("STKMONCAT",$j,sm,grpDesc)) q:grpDesc=""  d
	.s tmpGrpDesc=grpDesc
	.s scg=$o(^DHCSCG(0,"TYPE",ScgType,tmpGrpDesc,0))
	.s grpCode=$s(scg'="":$p($g(^DHCSCG(scg)),"^",1),1:"不详")
	.s (In,Out,LastAmt,Amt,RecAmt,RetAmt,TroAmt,TriAmt,AdjAmt,ConAmt,DisAmt,DspAmt,AspAmt,GiftRecAmt,PhaRetAspAmt,RetAspAmt,PhaRetAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt,DspAmtP,DspAmtF,DspAmtS,PhaRetAmtY,PhaRetAmtH,PhaRetAmtZ)=0
	.s cat="" f  s cat=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat)) q:cat=""  d
	..s nn=0
	..f  s nn=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)) q:nn=""  d
	...s amt=^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)
	...s LastAmt=LastAmt+$p(amt,"^",1)
	...s Amt=Amt+$p(amt,"^",2)
	...s RecAmt=RecAmt+$p(amt,"^",3)
	...s RetAmt=RetAmt+$p(amt,"^",4)
	...s TroAmt=TroAmt+$p(amt,"^",5)
	...s TriAmt=TriAmt+$p(amt,"^",6)
	...s AdjAmt=AdjAmt+$p(amt,"^",7)
	...s ConAmt=ConAmt+$p(amt,"^",8)
	...s DisAmt=DisAmt+$p(amt,"^",9)
	...s DspAmtP=DspAmtP+$p(amt,"^",11)
	...s DspAmtF=DspAmtF+$p(amt,"^",13)
	...s DspAmtS=DspAmtS+$p(amt,"^",14)
	...s DspAmt=DspAmt+$p(amt,"^",11)+$p(amt,"^",13)+$p(amt,"^",14)   //发药(门诊、住院汇总)
	...s AspAmt=AspAmt+$p(amt,"^",10)
	...s PhaRetAmtY=PhaRetAmtY+$p(amt,"^",12)
	...s PhaRetAmtH=PhaRetAmtH+$p(amt,"^",15)
	...s PhaRetAmtZ=PhaRetAmtZ+$p(amt,"^",16)
	...s PhaRetAmt=PhaRetAmt+$p(amt,"^",12)+$p(amt,"^",15)+$p(amt,"^",16)  //退药(门诊、住院汇总)
	...s GiftRecAmt=GiftRecAmt+$p(amt,"^",17)
	...s RetAspAmt=RetAspAmt+$p(amt,"^",18)
	...s PhaRetAspAmt=PhaRetAspAmt+$p(amt,"^",19)
	...s giftTrfAmt=giftTrfAmt+$p(amt,"^",20)
	...s chgRecAmt=chgRecAmt+$p(amt,"^",21)
	...s chgRetAmt=chgRetAmt+$p(amt,"^",22)
	...s mRecAmt = mRecAmt+$p(amt,"^",23)
	...s stktkAdjAmt=stktkAdjAmt+$p(amt,"^",24)
	...s manuXAmt=manuXAmt+$p(amt,"^",25)
	...s manuMAmt=manuMAmt+$p(amt,"^",26)
	...s phoRetAspAmt=phoRetAspAmt+$p(amt,"^",27)
	...s trfIAspAmt= trfIAspAmt+$p(amt,"^",28)
	.s In=RecAmt+TriAmt+PhaRetAmt+manuXAmt //入库金额+转入金额+患者退药金额+制剂消耗金额
	.s Out=RetAmt+TroAmt+ConAmt+DisAmt+DspAmt+manuMAmt+giftTrfAmt //退货金额+转出金额+消耗金额+报损金额+发药金额+制剂生成金额+赠品出库
	.i AdjAmt>0 s In=In+AdjAmt
	.e  s Out=Out+AdjAmt
	.i stktkAdjAmt>0 s In=In+stktkAdjAmt
	.e  s Out=Out+stktkAdjAmt
	.i AspAmt>0 s In=In+AspAmt
	.e  s Out=Out+AspAmt
	.i RetAspAmt>0 s In=In+RetAspAmt
	.e  s Out=Out+RetAspAmt
	.i PhaRetAspAmt>0 s In=In+PhaRetAspAmt
	.e  s Out=Out+PhaRetAspAmt
	.i phoRetAspAmt>0 s In=In+phoRetAspAmt
	.e  s Out=Out+phoRetAspAmt
	.i trfIAspAmt>0 s In=In+trfIAspAmt
	.e  s Out=Out+trfIAspAmt
	.d OutPutRowMulScg
	.
	.q:scg=""
	.;2016-09-19 多级类组特殊处理,逐层返回这条数据
	.f  s tmpScg=scg,scg=$p($g(^DHCSCG(scg)),"^",4) q:(scg="")!(scg=tmpScg)  d
	..s scgtype=$p(^DHCSCG(scg),"^",3)
	..;q:scgtype'=ScgType
	..s grpCode=$p(^DHCSCG(scg),"^",1)
	..s grpDesc=$p(^DHCSCG(scg),"^",2)
	..d OutPutRowMulScg			;遍历上级类组,修改grpDesc后再次输出,用于报表统计
	.
	.s grpDesc=tmpGrpDesc		;grpDesc设置为遍历上级类组前的初值(避免影响外层的遍历)
	.

	k ^TMP("STKMONCAT",$j,sm)
	Quit $$$OK
OutPutRowMulScg
	s Data=$lb(grpDesc,LastAmt,Amt,RecAmt,RetAmt,TroAmt,TriAmt,AdjAmt,ConAmt,DisAmt,DspAmt,AspAmt,PhaRetAmt,RetAspAmt,PhaRetAspAmt,GiftRecAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt,In,Out,grpCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
