Import sqluser

Class web.DHCST.DHCStkMonRepQuery Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 查询月报按类组汇总
/// Author:wangjiabin
/// Date:2013-08-27
/// Argu:
///   Parref - 月报主表id
///   Type - 1 按售价, 其他 按进价
/// Return:
///  Json数据串
///  d ##class(web.DHCST.DHCStkMonRepQuery).jsStkMonSumBySCG(12,1)
ClassMethod jsStkMonSumBySCG(Parref As %String, Type As %String) As %String
{
	//s ^YSJTMP("jsStkMonSumBySCG")=$LB(Parref,Type)
	n (Parref,Type)
	q:Parref="" ""
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCStkMonRepQuery:StkMonSumBySCG")
	s sc=result.Execute(Parref,Type)	 
	i $$$ISERR(sc) q ""

	s colNum=result.GetColumnCount()
	s count = 0
	s tmp=""
	w "{rows:["
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
	w "{"_tmp_"}"
	w "],results:"_count_"}"
	d result.Close()
	q
}

/// w ##class(web.DHCST.DHCStkMonRepQuery).jsStkMonSumByCat(457,"G")	
ClassMethod jsStkMonSumByCat(Parref As %String, Type As %String) As %String
{
	//s ^YSJTMP("jsStkMonSumByCat")=$LB(Parref,Type)
	n (Parref,Type)
	q:Parref="" ""
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCStkMonRepQuery:StkMonSumByIncCat")
	s sc=result.Execute(Parref,Type)	 
	i $$$ISERR(sc) q ""

	s colNum=result.GetColumnCount()
	s count = 0
	s tmp=""
	w "{rows:["
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
	w "{"_tmp_"}"
	w "],results:"_count_"}"
	d result.Close()
	q
}

/// 按分类检索并汇总月报数据
/// Author:zhwh
/// Data:2012-11-05
/// Argu:
///  sm - 月报主表rowid
///  type - ( 0,进价;1-售价 )
Query StkMonSumByIncCat(sm As %String, type As %String) As %Query(ROWSPEC = "grpDesc:%String,catdesc:%String,LastAmt:%Float,Amt:%Float,RecAmt:%Float,RetAmt:%Float,TroAmt:%Float,TriAmt:%Float,AdjAmt:%Float,ConAmt:%Float,DisAmt:%Float,DspAmt:%Float,AspAmt:%Float,PhaRetAmt:%Float,RetAspAmt:%Float,PhaRetAspAmt:%Float,GiftRecAmt:%Float,giftTrfAmt:%Float,chgRecAmt:%Float,chgRetAmt:%Float,mRecAmt:%Float,stktkAdjAmt:%Float,manuXAmt:%Float,manuMAmt:%Float,phoRetAspAmt:%Float,trfIAspAmt:%Float,recAspAmt:%Double,In:%Double,Out:%Double,phaOutDispAspAmt:%Double,phaDispAspAmt:%Double,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO ") [ SqlProc ]
{
}

ClassMethod StkMonSumByIncCatExecute(ByRef qHandle As %Binary, sm As %String, type As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:sm="" $$$OK
 
  //获取报表中主数据的输出
 s DataStr=..GetMianInfo(sm)
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
 
 
 s LocId=$p(^DHCSM(sm),"^",1)
 s HospId=$p(^CTLOC(LocId),"^",22)
 
 k ^TMP("STKMONCAT",$j,sm)
 i type="1" s rows=..CalStkMonCat(sm)   //售价统计
 e  s rows=..CalStkMonCatIN(sm)   //进价统计
 q:rows'>0 0
 
 s (LastAmtSum,AmtSum,RecAmtSum,RetAmtSum,TroAmtSum,TriAmtSum,AdjAmtSum,ConAmtSum,DisAmtSum,DspAmtSum,AspAmtSum,PhaRetAmtSum,RetAspAmtSum,PhaRetAspAmtSum,GiftRecAmtSum,giftTrfAmtSum,chgRecAmtSum,chgRetAmtSum,mRecAmtSum,stktkAdjAmtSum,manuXAmtSum,manuMAmtSum,phoRetAspAmtSum,trfIAspAmtSum,recAspAmtSum,InSum,OutSum,phaOutDispAspAmtSum,phaDispAspAmtSum)=0
 s grpDesc=""
 f  s grpDesc=$o(^TMP("STKMONCAT",$j,sm,grpDesc)) q:grpDesc=""  d
 .s cat="" f  s cat=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat)) q:cat=""  d 
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
 ..
 ..//s GiftTroAmt=0
 ..//s ChgRecAmt=0
 ..//s ChgRetAmt=0
 ..s PhaRetAspAmt=0
 ..//s PhoRetAspAmt=0  
 ..s RetAspAmt=0
 ..//s TrfIAspAmt=0
 ..s PhaRetAmt=0   //退药金额汇总
 ..s giftTrfAmt=0
 ..s chgRecAmt=0
 ..s chgRetAmt=0
 ..s mRecAmt =0
 ..s stktkAdjAmt=0
 ..s manuXAmt=0
 ..s manuMAmt=0
 ..s phoRetAspAmt=0
 ..s trfIAspAmt= 0
 ..s DspAmtP=0
 ..s DspAmtF=0
 ..s DspAmtS=0
 ..s PhaRetAmtY=0
 ..s PhaRetAmtH=0
 ..s PhaRetAmtZ=0
 ..s recAspAmt=0
 ..s phaOutDispAspAmt=0
 ..s phaDispAspAmt=0
 ..s nn=0
 ..
 ..f  s nn=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)) q:nn=""  d
 ...s amt=^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)
 ...s LastAmt=$g(LastAmt)+$p(amt,"^",1)
 ...s Amt=$g(Amt)+$p(amt,"^",2)
 ...s RecAmt=$g(RecAmt)+$p(amt,"^",3)
 ...s RetAmt=$g(RetAmt)+$p(amt,"^",4)
 ...s TroAmt=$g(TroAmt)+$p(amt,"^",5)
 ...s TriAmt=$g(TriAmt)+$p(amt,"^",6)
 ...s AdjAmt=$g(AdjAmt)+$p(amt,"^",7)
 ...s ConAmt=$g(ConAmt)+$p(amt,"^",8)
 ...s DisAmt=$g(DisAmt)+$p(amt,"^",9)
 ...s DspAmtP=$G(DspAmtP)+$p(amt,"^",11)
 ...s DspAmtF=$G(DspAmtF)+$p(amt,"^",13)
 ...s DspAmtS=$G(DspAmtS)+$p(amt,"^",14)
 ...s DspAmt=$g(DspAmt)+$p(amt,"^",11)+$p(amt,"^",13)+$p(amt,"^",14)   //发药(门诊、住院汇总)
 ...s AspAmt=$g(AspAmt)+$p(amt,"^",10)
 ...s PhaRetAmtY=$G(PhaRetAmtY)+$p(amt,"^",12)
 ...s PhaRetAmtH=$G(PhaRetAmtH)+$p(amt,"^",15)
 ...s PhaRetAmtZ=$G(PhaRetAmtZ)+$p(amt,"^",16)
 ...s PhaRetAmt=$g(PhaRetAmt)+$p(amt,"^",12)+$p(amt,"^",15)+$p(amt,"^",16)  //退药(门诊、住院汇总)
 ...s GiftRecAmt=$g(GiftRecAmt)+$p(amt,"^",17)
 ...s RetAspAmt=$g(RetAspAmt)+$p(amt,"^",18)
 ...s PhaRetAspAmt=$g(PhaRetAspAmt)+$p(amt,"^",19)
 ...s giftTrfAmt=giftTrfAmt+$p(amt,"^",20)
 ...s chgRecAmt=chgRecAmt+$p(amt,"^",21)
 ...s chgRetAmt=chgRetAmt+$p(amt,"^",22)
 ...s mRecAmt = mRecAmt+$p(amt,"^",23)
 ...s stktkAdjAmt=stktkAdjAmt+$p(amt,"^",24)  
 ...s manuXAmt=manuXAmt+$p(amt,"^",25)  //??
 ...s manuMAmt=manuMAmt+$p(amt,"^",26)   //??
 ...s phoRetAspAmt=phoRetAspAmt+$p(amt,"^",27)
 ...s trfIAspAmt= trfIAspAmt+$p(amt,"^",28)  
 ...s recAspAmt=recAspAmt+$p(amt,"^",29) 
 ...s phaOutDispAspAmt=phaOutDispAspAmt+$p(amt,"^",30) 
 ...s phaDispAspAmt=phaDispAspAmt+$p(amt,"^",31) 
 ...s In=RecAmt+TriAmt+PhaRetAmt+$G(manuXAmt)+GiftRecAmt+chgRecAmt
 ...s Out=RetAmt+TroAmt+ConAmt+DisAmt+DspAmt+$g(manuMAmt)+chgRetAmt
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
 ..i recAspAmt>0 s In=In+recAspAmt
 ..e  s Out=Out+recAspAmt
 ..i phaOutDispAspAmt>0 s In=In+phaOutDispAspAmt
 ..e  s Out=Out+phaOutDispAspAmt
 ..i phaDispAspAmt>0 s In=In+phaDispAspAmt
 ..e  s Out=Out+phaDispAspAmt
 ..s LastAmtSum=LastAmtSum+LastAmt,AmtSum=AmtSum+Amt,RecAmtSum=RecAmtSum+RecAmt,RetAmtSum=RetAmtSum+RetAmt
 ..s TroAmtSum=TroAmtSum+TroAmt,TriAmtSum=TriAmtSum+TriAmt,AdjAmtSum=AdjAmtSum+AdjAmt,ConAmtSum=ConAmtSum+ConAmt
 ..s DisAmtSum=DisAmtSum+DisAmt,DspAmtSum=DspAmtSum+DspAmt,AspAmtSum=AspAmtSum+AspAmt,PhaRetAmtSum=PhaRetAmtSum+PhaRetAmt
 ..s RetAspAmtSum=RetAspAmtSum+RetAspAmt,PhaRetAspAmtSum=PhaRetAspAmtSum+PhaRetAspAmt,GiftRecAmtSum=GiftRecAmtSum+GiftRecAmt
 ..s giftTrfAmtSum=giftTrfAmtSum+giftTrfAmt,chgRecAmtSum=chgRecAmtSum+chgRecAmt,chgRetAmtSum=chgRetAmtSum+chgRetAmt
 ..s mRecAmtSum=mRecAmtSum+mRecAmt,stktkAdjAmtSum=stktkAdjAmtSum+stktkAdjAmt,manuXAmtSum=manuXAmtSum+manuXAmt
 ..s manuMAmtSum=manuMAmtSum+manuMAmt,phoRetAspAmtSum=phoRetAspAmtSum+phoRetAspAmt,trfIAspAmtSum=trfIAspAmtSum+trfIAspAmt
 ..s recAspAmtSum=recAspAmtSum+recAspAmt,phaDispAspAmtSum=phaDispAspAmtSum+phaDispAspAmt,phaOutDispAspAmtSum=phaOutDispAspAmtSum+phaOutDispAspAmt
 ..s InSum=InSum+In,OutSum=OutSum+Out
 ..s catdesc=$p(^INC("SC",cat),"^",2)
 ..s LastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmt,HospId)
 ..s Amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(Amt,HospId)
 ..s LastAmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmtSum,HospId)
 ..s AmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(AmtSum,HospId)
 ..d OutPutRow 
 d OutPutRowSumCat
 k ^TMP("STKMONCAT",$j,sm)  ;kill the temporary global variable
 Quit $$$OK
OutPutRow
 s Data=$lb(grpDesc,catdesc,LastAmt,Amt,RecAmt,RetAmt,TroAmt,TriAmt,AdjAmt,ConAmt,DisAmt,DspAmt,AspAmt,PhaRetAmt,RetAspAmt,PhaRetAspAmt,GiftRecAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt,recAspAmt,In,Out,phaOutDispAspAmt,phaDispAspAmt,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO )
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
OutPutRowSumCat
 s Data=$lb("合计:","",LastAmtSum,AmtSum,RecAmtSum,RetAmtSum,TroAmtSum,TriAmtSum,AdjAmtSum,ConAmtSum,DisAmtSum,DspAmtSum,AspAmtSum,PhaRetAmtSum,RetAspAmtSum,PhaRetAspAmtSum,GiftRecAmtSum,giftTrfAmtSum,chgRecAmtSum,chgRetAmtSum,mRecAmtSum,stktkAdjAmtSum,manuXAmtSum,manuMAmtSum,phoRetAspAmtSum,trfIAspAmtSum,recAspAmtSum,InSum,OutSum,phaOutDispAspAmtSum,phaDispAspAmtSum,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO )
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
}

ClassMethod StkMonSumByIncCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StkMonSumByIncCatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StkMonSumByIncCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StkMonSumByIncCatExecute ]
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
ClassMethod CalStkMonCat(sm As %String, catdr As %String = "") As %String
{
 n (sm,catdr)
 s n=0
 k ^TMP("STKMONCAT",$j,sm)
 s ch=""
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d   
 .s data=^DHCSM(sm,"R",ch)  
 .s rowid=sm_"||"_ch  ;rowid
 .s inci=$p(data,"^",3)    ;inci   
 .s cat=$p(^INCI(inci,2),"^",2)  ;cat dr
 .s str=##class(web.DHCST.Common.DrugInfoCommon).StkCatGrpStr(cat)
 .s grpDesc=$p(str,"^",2)
 .i grpDesc="" s grpDesc="不详"
 .
 .i catdr'="" q:cat'=catdr    ;zdm 2007-5-29
 .s amount=$p(data,"^",7)  ;amount
 .s lastAmount=$p(data,"^",10)    ;amount of last month
 .s statrowid=$o(^SMSTAT(0,"SMR",rowid,""))
 .i $g(statrowid)'=""  d
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
 ..s recAspAmt=0  //确保顺序和进价一致,售价损益就是0
 ..s phaOutDispAspAmt=$p(aaa,"^",54)  //门诊发药损益
 ..s phaDispAspAmt=$p(aaa,"^",53) //住院发药损益
 .s n=n+1
 .s amt=$g(lastAmount)
 .s amt=amt_"^"_$g(amount)
 .s amt=amt_"^"_$g(recAmt)
 .s amt=amt_"^"_$g(retAmt)
 .s amt=amt_"^"_$g(trOAmt)
 .s amt=amt_"^"_$g(trIAmt)
 .s amt=amt_"^"_$g(adjAmt)
 .s amt=amt_"^"_$g(conAmt)
 .s amt=amt_"^"_$g(disposAmt)
 .s amt=amt_"^"_$g(aspAmt)
 .s amt=amt_"^"_$g(phaDspAmtP)
 .s amt=amt_"^"_$g(phaRetAmtY)
 .s amt=amt_"^"_$g(phaDspAmtF)
 .s amt=amt_"^"_$g(phaDspAmtS)
 .s amt=amt_"^"_$g(phaRetAmtH)
 .s amt=amt_"^"_$g(phaRetAmtZ)
 .s amt=amt_"^"_$g(giftRecAmt)
 .s amt=amt_"^"_$g(retAspAmt)
 .s amt=amt_"^"_$g(phaRetAspAmt)
 .s amt=amt_"^"_$g(giftTrfAmt)
 .s amt=amt_"^"_$g(chgRecAmt)
 .s amt=amt_"^"_$g(chgRetAmt)
 .s amt=amt_"^"_$g(mRecAmt)
 .s amt=amt_"^"_$g(stktkAdjAmt)
 .s amt=amt_"^"_$g(manuXAmt)
 .s amt=amt_"^"_$g(manuMAmt)
 .s amt=amt_"^"_$g(phoRetAspAmt)
 .s amt=amt_"^"_$g(trfIAspAmt)
 .s amt=amt_"^"_$g(recAspAmt)
 .s amt=amt_"^"_$g(phaOutDispAspAmt)
 .s amt=amt_"^"_$g(phaDispAspAmt)
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
ClassMethod CalStkMonCatIN(sm As %String) As %String
{
 n (sm)
 s n=0
 k ^TMP("STKMONCAT",$j,sm)
 s ch=""
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d    
 .s data=^DHCSM(sm,"R",ch)  
 .s rowid=sm_"||"_ch                ;rowid
 .s inci=$p(data,"^",3)                  ;inci   
 .s cat=$p(^INCI(inci,2),"^",2)         ;cat dr
 .
 .s str=##class(web.DHCST.Common.DrugInfoCommon).StkCatGrpStr(cat)
 .s grpDesc=$p(str,"^",2)
 .i grpDesc="" s grpDesc="不详"
 .
 .s amount=$p(data,"^",8)                ;amount
 .s lastAmount=$p(data,"^",11)           ;amount of last month
 .s statinrowid=$o(^SMSTATI(0,"SMR",rowid,""))
 .i $g(statinrowid)'=""  d
 ..s aaa=$G(^SMSTATI(statinrowid))
 ..s recAmt=$p(aaa,"^",3)
 ..s retAmt=$p(aaa,"^",5)
 ..s trOAmt=$p(aaa,"^",7)
 ..s trIAmt=$p(aaa,"^",9)
 ..s adjAmt=$p(aaa,"^",11)
 ..s conAmt=$p(aaa,"^",13)
 ..s disposAmt=$p(aaa,"^",15)
 ..s aspAmt=$p(aaa,"^",18)
 ..s phaDspAmtP=$p(aaa,"^",17)
 ..s phaRetAmtY=$p(aaa,"^",20)
 ..s phaDspAmtF=$p(aaa,"^",30)
 ..s phaDspAmtS=$p(aaa,"^",32)
 ..s phaRetAmtH=$p(aaa,"^",34)
 ..s phaRetAmtZ=$p(aaa,"^",36)
 ..
 ..s giftRecAmt=$p(aaa,"^",22)  //赠品入库
 ..s giftTrfAmt=$p(aaa,"^",24)  //赠品出库
 ..
 ..s chgRecAmt=$p(aaa,"^",26)
 ..s chgRetAmt=$p(aaa,"^",28)
 ..
 ..s trfIAspAmt=$p(aaa,"^",38) //转移入库调价损益
 ..s retAspAmt=$p(aaa,"^",39)  //退货调价损益
 ..s stktkAdjAmt=$p(aaa,"^",41)  //盘点调整
 ..
 ..s manuXAmt=$p(aaa,"^",43)
 ..s manuMAmt=$p(aaa,"^",45)
 ..s mRecAmt=$p(aaa,"^",47)
 ..//w manuXAmt_"^"_manuMAmt_"^"_mRecAmt,!
 ..s phoRetAspAmt=$p(aaa,"^",48)  //门诊退药调价损益
 ..s phaRetAspAmt=$p(aaa,"^",49)  //住院退药调价损益
 ..s recAspAmt=$p(aaa,"^",37)  //入库损益
 ..s phaOutDispAspAmt=0 //门诊发药损益
 ..s phaDispAspAmt=0 //住院发药损益
 .s n=n+1
 .
 .s amt=$g(lastAmount)
 .s amt=amt_"^"_$g(amount)
 .s amt=amt_"^"_$g(recAmt)
 .s amt=amt_"^"_$g(retAmt)
 .s amt=amt_"^"_$g(trOAmt)
 .s amt=amt_"^"_$g(trIAmt)
 .s amt=amt_"^"_$g(adjAmt)
 .s amt=amt_"^"_$g(conAmt)
 .s amt=amt_"^"_$g(disposAmt)
 .s amt=amt_"^"_$g(aspAmt)
 .s amt=amt_"^"_$g(phaDspAmtP)
 .s amt=amt_"^"_$g(phaRetAmtY)
 .s amt=amt_"^"_$g(phaDspAmtF)
 .s amt=amt_"^"_$g(phaDspAmtS)
 .s amt=amt_"^"_$g(phaRetAmtH)
 .s amt=amt_"^"_$g(phaRetAmtZ)
 .s amt=amt_"^"_$g(giftRecAmt)
 .s amt=amt_"^"_$g(retAspAmt)
 .s amt=amt_"^"_$g(phaRetAspAmt)
 .s amt=amt_"^"_$g(giftTrfAmt)
 .s amt=amt_"^"_$g(chgRecAmt)
 .s amt=amt_"^"_$g(chgRetAmt)
 .s amt=amt_"^"_$g(mRecAmt)
 .s amt=amt_"^"_$g(stktkAdjAmt)
 .s amt=amt_"^"_$g(manuXAmt)
 .s amt=amt_"^"_$g(manuMAmt)
 .s amt=amt_"^"_$g(phoRetAspAmt)
 .s amt=amt_"^"_$g(trfIAspAmt)
 .s amt=amt_"^"_$g(recAspAmt)
 .s amt=amt_"^"_$g(phaOutDispAspAmt)
 .s amt=amt_"^"_$g(phaDispAspAmt)
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
Query StkMonSumBySCG(sm As %String, type As %String) As %Query(ROWSPEC = "grpDesc:%String,LastAmt:%String,Amt:%String,RecAmt:%String,RetAmt:%String,TroAmt:%String,TriAmt:%String,AdjAmt:%String,ConAmt:%String,DisAmt:%String,DspAmt:%String,AspAmt:%String,PhaRetAmt:%String,RetAspAmt:%String,PhaRetAspAmt:%String,GiftRecAmt:%String,giftTrfAmt:%String,chgRecAmt:%String,chgRetAmt:%String,mRecAmt:%String,stktkAdjAmt:%String,manuXAmt:%String,manuMAmt:%String,phoRetAspAmt:%String,trfIAspAmt:%String,recAspAmt:%String,In:%String,Out:%String,phaOutDispAspAmt:%String,phaDispAspAmt:%String,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO ") [ SqlProc ]
{
}

ClassMethod StkMonSumBySCGExecute(ByRef qHandle As %Binary, sm As %String, type As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:sm="" $$$OK
 
 //获取报表中主数据的输出
 s DataStr=..GetMianInfo(sm)
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
 
 
 s LocId=$p(^DHCSM(sm),"^",1)
 s HospId=$p(^CTLOC(LocId),"^",22)
 k ^TMP("STKMONCAT",$j,sm)
 i type="1" s rows=..CalStkMonCat(sm)   //售价统计
 e  s rows=..CalStkMonCatIN(sm)   //进价统计
 q:rows'>0 0
 s (LastAmtSum,AmtSum,RecAmtSum,RetAmtSum,TroAmtSum,TriAmtSum,AdjAmtSum,ConAmtSum,DisAmtSum,DspAmtSum,AspAmtSum,PhaRetAmtSum,RetAspAmtSum,PhaRetAspAmtSum,GiftRecAmtSum,giftTrfAmtSum,chgRecAmtSum,chgRetAmtSum,mRecAmtSum,stktkAdjAmtSum,manuXAmtSum,manuMAmtSum,phoRetAspAmtSum,trfIAspAmtSum,recAspAmtSum,phaOutDispAspAmtSum,phaDispAspAmtSum,InSum,OutSum)=0
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
 .
 .//s GiftTroAmt=0
 .//s ChgRecAmt=0
 .//s ChgRetAmt=0
 .s PhaRetAspAmt=0
 .//s PhoRetAspAmt=0  
 .s RetAspAmt=0
 .//s TrfIAspAmt=0
 .s PhaRetAmt=0   //退药金额汇总
 .s giftTrfAmt=0
 .s chgRecAmt=0
 .s chgRetAmt=0
 .s mRecAmt =0
 .s stktkAdjAmt=0
 .s manuXAmt=0
 .s manuMAmt=0
 .s phoRetAspAmt=0
 .s trfIAspAmt= 0
 .;
 .s DspAmtP=0
 .s DspAmtF=0
 .s DspAmtS=0
 .s PhaRetAmtY=0
 .s PhaRetAmtH=0
 .s PhaRetAmtZ=0
 .s RecAspAmt=0
 .s phaOutDispAspAmt=0
 .s phaDispAspAmt=0
 .s cat="" f  s cat=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat)) q:cat=""  d
 ..s nn=0
 ..f  s nn=$o(^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)) q:nn=""  d
 ...s amt=^TMP("STKMONCAT",$j,sm,grpDesc,cat,nn)
 ...s LastAmt=$g(LastAmt)+$p(amt,"^",1)
 ...s Amt=$g(Amt)+$p(amt,"^",2)
 ...s RecAmt=$g(RecAmt)+$p(amt,"^",3)
 ...s RetAmt=$g(RetAmt)+$p(amt,"^",4)
 ...s TroAmt=$g(TroAmt)+$p(amt,"^",5)
 ...s TriAmt=$g(TriAmt)+$p(amt,"^",6)
 ...s AdjAmt=$g(AdjAmt)+$p(amt,"^",7)
 ...s ConAmt=$g(ConAmt)+$p(amt,"^",8)
 ...s DisAmt=$g(DisAmt)+$p(amt,"^",9)
 ...s DspAmtP=$G(DspAmtP)+$p(amt,"^",11)
 ...s DspAmtF=$G(DspAmtF)+$p(amt,"^",13)
 ...s DspAmtS=$G(DspAmtS)+$p(amt,"^",14)
 ...s DspAmt=$g(DspAmt)+$p(amt,"^",11)+$p(amt,"^",13)+$p(amt,"^",14)   //发药(门诊、住院汇总)
 ...s AspAmt=$g(AspAmt)+$p(amt,"^",10)
 ...s PhaRetAmtY=$G(PhaRetAmtY)+$p(amt,"^",12)
 ...s PhaRetAmtH=$G(PhaRetAmtH)+$p(amt,"^",15)
 ...s PhaRetAmtZ=$G(PhaRetAmtZ)+$p(amt,"^",16)
 ...s PhaRetAmt=$g(PhaRetAmt)+$p(amt,"^",12)+$p(amt,"^",15)+$p(amt,"^",16)  //退药(门诊、住院汇总)
 ...s GiftRecAmt=$g(GiftRecAmt)+$p(amt,"^",17)
 ...s RetAspAmt=$g(RetAspAmt)+$p(amt,"^",18)
 ...s PhaRetAspAmt=$g(PhaRetAspAmt)+$p(amt,"^",19)
 ...s giftTrfAmt=giftTrfAmt+$p(amt,"^",20)
 ...s chgRecAmt=chgRecAmt+$p(amt,"^",21)
 ...s chgRetAmt=chgRetAmt+$p(amt,"^",22)
 ...s mRecAmt = mRecAmt+$p(amt,"^",23)
 ...s stktkAdjAmt=stktkAdjAmt+$p(amt,"^",24)  
 ...s manuXAmt=manuXAmt+$p(amt,"^",25) 
 ...s manuMAmt=manuMAmt+$p(amt,"^",26)  
 ...s phoRetAspAmt=phoRetAspAmt+$p(amt,"^",27)
 ...s trfIAspAmt= trfIAspAmt+$p(amt,"^",28)  
 ...s RecAspAmt=RecAspAmt+$p(amt,"^",29)
 ...s phaOutDispAspAmt=phaOutDispAspAmt+$p(amt,"^",30)
 ...s phaDispAspAmt=phaDispAspAmt+$p(amt,"^",31)
 .s In=RecAmt+TriAmt+PhaRetAmt+$G(manuXAmt)+GiftRecAmt+chgRecAmt
 .s Out=RetAmt+TroAmt+ConAmt+DisAmt+DspAmt+$g(manuMAmt)+chgRetAmt
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
 .i RecAspAmt>0 s In=In+RecAspAmt
 .e  s Out=Out+RecAspAmt
 .i phaOutDispAspAmt>0 s In=In+phaOutDispAspAmt
 .e  s Out=Out+phaOutDispAspAmt
 .i phaDispAspAmt>0 s In=In+phaDispAspAmt
 .e  s Out=Out+phaDispAspAmt
 .s LastAmtSum=LastAmtSum+LastAmt,AmtSum=AmtSum+Amt,RecAmtSum=RecAmtSum+RecAmt,RetAmtSum=RetAmtSum+RetAmt
 .s TroAmtSum=TroAmtSum+TroAmt,TriAmtSum=TriAmtSum+TriAmt,AdjAmtSum=AdjAmtSum+AdjAmt,ConAmtSum=ConAmtSum+ConAmt
 .s DisAmtSum=DisAmtSum+DisAmt,DspAmtSum=DspAmtSum+DspAmt,AspAmtSum=AspAmtSum+AspAmt,PhaRetAmtSum=PhaRetAmtSum+PhaRetAmt
 .s RetAspAmtSum=RetAspAmtSum+RetAspAmt,PhaRetAspAmtSum=PhaRetAspAmtSum+PhaRetAspAmt,GiftRecAmtSum=GiftRecAmtSum+GiftRecAmt
 .s giftTrfAmtSum=giftTrfAmtSum+giftTrfAmt,chgRecAmtSum=chgRecAmtSum+chgRecAmt,chgRetAmtSum=chgRetAmtSum+chgRetAmt
 .s mRecAmtSum=mRecAmtSum+mRecAmt,stktkAdjAmtSum=stktkAdjAmtSum+stktkAdjAmt,manuXAmtSum=manuXAmtSum+manuXAmt
 .s manuMAmtSum=manuMAmtSum+manuMAmt,phoRetAspAmtSum=phoRetAspAmtSum+phoRetAspAmt,trfIAspAmtSum=trfIAspAmtSum+trfIAspAmt
 .s recAspAmtSum=recAspAmtSum+RecAspAmt,phaOutDispAspAmtSum=phaOutDispAspAmtSum+phaOutDispAspAmt,phaDispAspAmtSum=phaDispAspAmtSum+phaDispAspAmt
 .s InSum=InSum+In,OutSum=OutSum+Out
 .
 .s LastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmt,HospId)
 .s Amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(Amt,HospId)
 .s LastAmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmtSum,HospId)
 .s AmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(AmtSum,HospId)
 .d OutPutRow2 
 d OutPutRowSum
 k ^TMP("STKMONCAT",$j,sm)  ;kill the temporary global variable
 Quit $$$OK
OutPutRow2
 s Data=$lb(grpDesc,LastAmt,Amt,RecAmt,RetAmt,TroAmt,TriAmt,AdjAmt,ConAmt,DisAmt,DspAmt,AspAmt,PhaRetAmt,RetAspAmt,PhaRetAspAmt,GiftRecAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt,RecAspAmt,In,Out,phaOutDispAspAmt,phaDispAspAmt,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO )
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
OutPutRowSum
 s Data=$lb("合计:",LastAmtSum,AmtSum,RecAmtSum,RetAmtSum,TroAmtSum,TriAmtSum,AdjAmtSum,ConAmtSum,DisAmtSum,DspAmtSum,AspAmtSum,PhaRetAmtSum,RetAspAmtSum,PhaRetAspAmtSum,GiftRecAmtSum,giftTrfAmtSum,chgRecAmtSum,chgRetAmtSum,mRecAmtSum,stktkAdjAmtSum,manuXAmtSum,manuMAmtSum,phoRetAspAmtSum,trfIAspAmtSum,recAspAmtSum,InSum,OutSum,phaOutDispAspAmtSum,phaDispAspAmtSum,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO )
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod StkMonSumBySCGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StkMonSumBySCGExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StkMonSumBySCGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StkMonSumBySCGExecute ]
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

/// 查询月报明细
/// Author:zhangdongmei
/// Date:2012-11-26
/// Argu:
///   Parref - 月报主表id
/// Return:
///  Json数据串
///  
ClassMethod jsStkMonRepItm(Parref As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %String
{
	n (Parref,stkgrpid,stkcatid,incdesc)
	q:Parref="" ""
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCStkMonRepQuery:StkMonRepItm")
	s sc=result.Execute(Parref,stkgrpid,stkcatid,incdesc)	 
	i $$$ISERR(sc) q ""

	s colNum=result.GetColumnCount()
	s count = 0
	s tmp=""
	w "{rows:["
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
	w "],results:"_count_"}"
	d result.Close()
	q
}

/// 检索月报明细记录(售价)
/// Author:zhwh
/// Date:2012-11-05
/// Argu:
///  sm -月报主表rowid
/// 
Query StkMonRepItm(sm As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %Query(ROWSPEC = "Rowid:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,uomDesc:%String,qty:%String,amt:%String,lastQty:%String,lastAmt:%String,recQty:%String,recAmt:%String,retQty:%String,retAmt:%String,trOutQty:%String,trOutAmt:%String,trInQty:%String,trInAmt:%String,adjQty:%String,adjAmt:%String,csmQty:%String,csmAmt:%String,disposeQty:%String,disposeAmt:%String,phaInDspQty:%String,phaInDspAmt:%String,aspAmt:%String,phaInRetQty:%String,phaInRetAmt:%String,phaOutDspQty:%String,phaOutDspAmt:%String,phaOutDspQtyS:%String,phaOutDspAmtS:%String,phaOutRetQty:%String,phaOutRetAmt:%String,phaOutRetQtyZ:%String,phaOutRetAmtZ:%String,giftRecQty:%String,giftRecAmt:%String,giftTrOutQty:%String,giftTrOutAmt:%String,chgRecQty:%String,chgRecAmt:%String,chgRetQty:%String,chgRetAmt:%String,retAspAmt:%String,phaRetAspAmt:%String,mRecQty:%String,mRecAmt:%String,stktkAdjQty:%String,stktkAdjAmt:%String,manuXQty:%String,manuXAmt:%String,manuMQty:%String,manuMAmt:%String,phaOutRetAspAmt:%String,trInAspAmt:%String,recAspAmt:%String,phaOutDispAspAmt:%String,phaDispAspAmt:%String,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO") [ SqlProc ]
{
}

ClassMethod StkMonRepItmExecute(ByRef qHandle As %Binary, sm As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %Status
{
 q:sm="" $$$OK
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 //获取报表中主数据的输出
 s DataStr=..GetMianInfo(sm)
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
 
 
 s stkcode=$g(stkcode)
 s n=0
 k mPLIST
 s ch=""
 s LocId=$p(^DHCSM(sm),"^",1)
 s HospId=$p(^CTLOC(LocId),"^",22)
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
 .s smr=sm_"||"_ch
 .s row=^DHCSM(sm,"R",ch)
 .s inci=$p(row,"^",3)  ;inci  
 .
 .s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 .s grpid=$p(stkgrpinfo,"^",5)
 .q:(stkgrpid'="")&(grpid'=stkgrpid)
 .s stkcat=$p(^INCI(inci,2),"^",2)
 .q:(stkcatid'="")&(stkcat'=stkcatid)  
 .s inciCode=$p(^INCI(inci,1),"^",1)    ;inci code
 .s inciDesc=$p(^INCI(inci,1),"^",2)    ;inci desc
 .q:(incdesc'="")&('$f(inciDesc,incdesc))
 .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 .s inciuomdr=$p(^INCI(inci,1),"^",10)      ;uom dr
 .s puruom=$p(^INCI(inci,3),"^",6)      ;purch uom dr 
 .i puruom="" s puruom=inciuomdr
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,inciuomdr)
 .s uomDesc=$p(^CT("UOM",puruom),"^",2)  ;uom desc
 .s qty=$p(row,"^",6)     ;qty
 .s qty=qty/fac
 .s qty=##class(web.DHCST.Common.AppCommon).FormatSq(qty,HospId,1,"G")
 .s amt=$p(row,"^",7)  ;amount
 .//add wyx 2014-02-11
 .s amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(amt,HospId)
 .s lastQty=$p(row,"^",9) ;qty of last month
 .s lastQty=lastQty/fac
 .s lastQty=##class(web.DHCST.Common.AppCommon).FormatSq(lastQty,HospId,1,"G")
 .s lastAmt=$p(row,"^",10)    ;amount of last month
 .s lastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(lastAmt,HospId)
 .;
 .s stat=$o(^SMSTAT(0,"SMR",smr,""))
 .q:$g(stat)=""
 .s stats=$G(^SMSTAT(stat))
 .s recQty=+$P(stats,"^",2)/fac  ;入库数量
 .s recAmt=+$P(stats,"^",3) ;入库金额
 .s retQty=+$P(stats,"^",4)/fac ;退货数量
 .s retAmt=+$P(stats,"^",5) ;退货金额
 .s trOutQty=+$P(stats,"^",6)/fac  ;转出数量
 .s trOutAmt=+$P(stats,"^",7) ;转出金额
 .s trInQty=+$P(stats,"^",8)/fac ;转入数量
 .s trInAmt=+$P(stats,"^",9) ;转入金额
 .s adjQty=+$P(stats,"^",10)/fac  ;库存调整数量
 .s adjAmt=+$P(stats,"^",11) ;库存调整金额
 .s csmQty=+$P(stats,"^",12)/fac   ;报损数量
 .s csmAmt=+$P(stats,"^",13) ;报损金额
 .s disposeQty=+$P(stats,"^",14)/fac ;发放数量
 .s disposeAmt=+$P(stats,"^",15) ;发放金额
 .s phaInDspQty=+$P(stats,"^",16)/fac ;发药数量(住院)
 .s phaInDspAmt=+$P(stats,"^",17)  ;发药金额(住院)
 .s aspAmt=+$P(stats,"^",18)  ;调价损益金额
 .s phaInRetQty=+$P(stats,"^",19)/fac ;退药数量(住院)
 .s phaInRetAmt=+$P(stats,"^",20)  ;退药金额(住院)
 .
 .s phaOutDspQty=+$P(stats,"^",21)/fac ;发药数量(门诊)
 .s phaOutDspAmt=+$P(stats,"^",22)   ;发药金额(门诊)
 .s phaOutDspQtyS=+$P(stats,"^",23)/fac  ;发药数量(门诊非正常)
 .s phaOutDspAmtS=+$P(stats,"^",24) ;发药金额(门诊非正常)
 .s phaOutRetQty=+$P(stats,"^",25)/fac  ;退药数量(门诊)
 .s phaOutRetAmt=+$P(stats,"^",26)  ;退药金额(门诊)
 .s phaOutRetQtyZ=+$P(stats,"^",27)/fac   ;退药数量(门诊非正常)
 .s phaOutRetAmtZ=+$P(stats,"^",28)  ;退药金额量(门诊非正常)
 .s giftRecQty=+$P(stats,"^",29)/fac ;入库数量(赠品)
 .s giftRecAmt=+$P(stats,"^",30)  ;入库(赠品)
 .s giftTrOutQty=+$P(stats,"^",31)/fac ;转出数量(赠品)
 .s giftTrOutAmt=+$P(stats,"^",32)  ;转出金额(赠品)
 .s chgRecQty=+$P(stats,"^",33)/fac ;入库数量(调价换票)
 .s chgRecAmt=+$P(stats,"^",34)  ;入库金额(调价换票)
 .s chgRetQty=+$P(stats,"^",35)/fac ;退货数量(调价换票)
 .s chgRetAmt=+$P(stats,"^",36)  ;退货金额(调价换票)
 .
 .s retAspAmt=+$P(stats,"^",37)    ;退货调价损益
 .s phaRetAspAmt=+$P(stats,"^",38)  ;住院退药调价损益
 .s mRecQty=+$P(stats,"^",39)/fac  //制剂入库数量
 .s mRecAmt=+$P(stats,"^",40)	  //制剂入库金额
 .s stktkAdjQty=+$P(stats,"^",41)/fac  ;盘点调整数量
 .s stktkAdjAmt=+$P(stats,"^",42)  ;盘点调整金额 
 .
 .s manuXQty=+$P(stats,"^",43)/fac
 .s manuXAmt=+$P(stats,"^",44)
 .s manuMQty=+$P(stats,"^",45)/fac
 .s manuMAmt=+$P(stats,"^",46)
 .s phaOutRetAspAmt=+$P(stats,"^",47)  ;门诊退药调价损益
 .s trInAspAmt=+$P(stats,"^",48)  ;库存转入调价损益
 .s recAspAmt=0 ;入库损益,售价应为0
 .s phaOutDispAspAmt=+$P(stats,"^",54) //门诊发药损益
 .s phaDispAspAmt=+$P(stats,"^",53) //住院发药损益
 .d OutPutRow1
 .
 Quit $$$OK
 
OutPutRow1
 s Data=$lb(stat,inci,inciCode,inciDesc,spec,uomDesc,qty,amt,lastQty,lastAmt,recQty,recAmt,retQty,retAmt,trOutQty,trOutAmt,trInQty,trInAmt,adjQty,adjAmt,csmQty,csmAmt,disposeQty,disposeAmt,phaInDspQty,phaInDspAmt,aspAmt,phaInRetQty,phaInRetAmt,phaOutDspQty,phaOutDspAmt,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty,phaOutRetAmt,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty,giftRecAmt,giftTrOutQty,giftTrOutAmt,chgRecQty,chgRecAmt,chgRetQty,chgRetAmt,retAspAmt,phaRetAspAmt,mRecQty,mRecAmt,stktkAdjQty,stktkAdjAmt,manuXQty,manuXAmt,manuMQty,manuMAmt,phaOutRetAspAmt,trInAspAmt,recAspAmt,phaOutDispAspAmt,phaDispAspAmt,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod StkMonRepItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StkMonRepItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StkMonRepItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StkMonRepItmExecute ]
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

/// 查询月报明细(进价)
/// Author:zhangdongmei
/// Date:2013-02-18
/// Argu:
///   Parref - 月报主表id
///   stkgrpid - 类组id
///   stkcatid - 库存分类id
///   incdesc - 药品名称
/// Return:
///  Json数据串
///  
ClassMethod jsStkMonRepItmRp(Parref As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %String
{
	n (Parref,stkgrpid,stkcatid,incdesc)
	q:Parref="" ""
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCStkMonRepQuery:StkMonRepItmRp")
	s sc=result.Execute(Parref,stkgrpid,stkcatid,incdesc)	 
	i $$$ISERR(sc) q ""

	s colNum=result.GetColumnCount()
	s count = 0
	//s resultString = ""
	//s end = Start+Limit
	//s json = ##class(Code.JsonObj).%New()
	s tmp=""
	w "{rows:["
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
	w "{"_tmp_"}"
	w "],results:"_count_"}"
	d result.Close()
	q
}

/// 检索月报明细记录(进价)
/// Author:zhwh
/// Date:2012-11-05
/// Argu:
///  sm -月报主表rowid
/// D ##class(%ResultSet).RunQuery("web.DHCST.DHCStkMonRepQuery","StkMonRepItmRp","9","3","","")
Query StkMonRepItmRp(sm As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %Query(ROWSPEC = "Rowid:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,uomDesc:%String,qty:%String,amt:%String,lastQty:%String,lastAmt:%String,recQty:%String,recAmt:%String,retQty:%String,retAmt:%String,trOutQty:%String,trOutAmt:%String,trInQty:%String,trInAmt:%String,adjQty:%String,adjAmt:%String,csmQty:%String,csmAmt:%String,disposeQty:%String,disposeAmt:%String,phaInDspQty:%String,phaInDspAmt:%String,aspAmt:%String,phaInRetQty:%String,phaInRetAmt:%String,phaOutDspQty:%String,phaOutDspAmt:%String,phaOutDspQtyS:%String,phaOutDspAmtS:%String,phaOutRetQty:%String,phaOutRetAmt:%String,phaOutRetQtyZ:%String,phaOutRetAmtZ:%String,giftRecQty:%String,giftRecAmt:%String,giftTrOutQty:%String,giftTrOutAmt:%String,chgRecQty:%String,chgRecAmt:%String,chgRetQty:%String,chgRetAmt:%String,retAspAmt:%String,phaRetAspAmt:%String,mRecQty:%String,mRecAmt:%String,stktkAdjQty:%String,stktkAdjAmt:%String,manuXQty:%String,manuXAmt:%String,manuMQty:%String,manuMAmt:%String,phaOutRetAspAmt:%String,trInAspAmt:%String,recAspAmt:%String,phaOutDispAspAmt:%String,phaDispAspAmt:%String,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO") [ SqlProc ]
{
}

ClassMethod StkMonRepItmRpExecute(ByRef qHandle As %Binary, sm As %String, stkgrpid As %String = "", stkcatid As %String = "", incdesc As %String = "") As %Status
{
 q:sm="" $$$OK
 ;
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 //获取报表中主数据的输出
 s DataStr=..GetMianInfo(sm)
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
 
 s stkcode=$g(stkcode)
 s n=0
 k mPLIST
 s ch=""
 s LocId=$p(^DHCSM(sm),"^",1)
 s HospId=$p(^CTLOC(LocId),"^",22)
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
 .s smr=sm_"||"_ch
 .s row=^DHCSM(sm,"R",ch)
 .s inci=$p(row,"^",3)  ;inci   .  
 .s inciCode=$p(^INCI(inci,1),"^",1)    ;inci code
 .s inciDesc=$p(^INCI(inci,1),"^",2)    ;inci desc
 .
 .s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 .s grpid=$p(stkgrpinfo,"^",5)
 .q:(stkgrpid'="")&(grpid'=stkgrpid)
 .s stkcat=$p(^INCI(inci,2),"^",2)
 .q:(stkcatid'="")&(stkcat'=stkcatid)  
 .s inciCode=$p(^INCI(inci,1),"^",1)    ;inci code
 .s inciDesc=$p(^INCI(inci,1),"^",2)    ;inci desc
 .q:(incdesc'="")&('$f(inciDesc,incdesc))
 .
 .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 .s inciuomdr=$p(^INCI(inci,1),"^",10)      ;uom dr
 .s puruom=$p(^INCI(inci,3),"^",6)      ;purch uom dr 
 .i puruom="" s puruom=inciuomdr
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,inciuomdr)
 .s uomDesc=$p(^CT("UOM",puruom),"^",2)  ;uom desc
 .s qty=$p(row,"^",6)     ;qty
 .s qty=qty/fac
 .s qty=##class(web.DHCST.Common.AppCommon).FormatSq(qty,HospId,1,"G")
 .s amt=$p(row,"^",8)  ;amount
 .s amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(amt,HospId)
 .s lastQty=$p(row,"^",9) ;qty of last month
 .s lastQty=lastQty/fac
 .s lastQty=##class(web.DHCST.Common.AppCommon).FormatSq(lastQty,HospId,1,"G")
 .s lastAmt=$p(row,"^",11)    ;amount of last month
 .s lastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(lastAmt,HospId)
 .;
 .s stat=$o(^SMSTATI(0,"SMR",smr,""))
 .q:$g(stat)=""
 .s stats=$G(^SMSTATI(stat))
 .
 .s recQty=+$P(stats,"^",2)/fac  ;入库数量
 .s recAmt=+$P(stats,"^",3) ;入库金额
 .s retQty=+$P(stats,"^",4)/fac ;退货数量
 .s retAmt=+$P(stats,"^",5) ;退货金额
 .s trOutQty=+$P(stats,"^",6)/fac  ;转出数量
 .s trOutAmt=+$P(stats,"^",7) ;转出金额
 .s trInQty=+$P(stats,"^",8)/fac ;转入数量
 .s trInAmt=+$P(stats,"^",9) ;转入金额
 .s adjQty=+$P(stats,"^",10)/fac  ;库存调整数量
 .s adjAmt=+$P(stats,"^",11) ;库存调整金额
 .s csmQty=+$P(stats,"^",12)/fac   ;报损数量
 .s csmAmt=+$P(stats,"^",13) ;报损金额
 .s disposeQty=+$P(stats,"^",14)/fac ;发放数量
 .s disposeAmt=+$P(stats,"^",15) ;发放金额
 .s phaInDspQty=+$P(stats,"^",16)/fac ;发药数量(住院)
 .s phaInDspAmt=+$P(stats,"^",17)  ;发药金额(住院)
 .s aspAmt=+$P(stats,"^",18)  ;调价损益金额
 .s phaInRetQty=+$P(stats,"^",19)/fac ;退药数量(住院)
 .s phaInRetAmt=+$P(stats,"^",20)  ;退药金额(住院)
 .
 .s giftRecQty=+$P(stats,"^",21)/fac ;入库数量(赠品)
 .s giftRecAmt=+$P(stats,"^",22)  ;入库(赠品)
 .s giftTrOutQty=+$P(stats,"^",23)/fac ;转出数量(赠品)
 .s giftTrOutAmt=+$P(stats,"^",24)  ;转出金额(赠品)
 .
 .s chgRecQty=+$P(stats,"^",25)/fac ;入库数量(调价换票)
 .s chgRecAmt=+$P(stats,"^",26)  ;入库金额(调价换票)
 .s chgRetQty=+$P(stats,"^",27)/fac ;退货数量(调价换票)
 .s chgRetAmt=+$P(stats,"^",28)  ;退货金额(调价换票)
 .
 .s phaOutDspQty=+$P(stats,"^",29)/fac ;发药数量(门诊)
 .s phaOutDspAmt=+$P(stats,"^",30)   ;发药金额(门诊)
 .s phaOutDspQtyS=+$P(stats,"^",31)/fac  ;发药数量(门诊非正常)
 .s phaOutDspAmtS=+$P(stats,"^",32) ;发药金额(门诊非正常)
 .
 .s phaOutRetQty=+$P(stats,"^",33)/fac  ;退药数量(门诊)
 .s phaOutRetAmt=+$P(stats,"^",34)  ;退药金额(门诊)
 .s phaOutRetQtyZ=+$P(stats,"^",35)/fac   ;退药数量(门诊非正常)
 .s phaOutRetAmtZ=+$P(stats,"^",36)  ;退药金额量(门诊非正常)
 .
 .s trInAspAmt=+$P(stats,"^",38)  ;库存转入调价损益
 .s retAspAmt=+$P(stats,"^",39)    ;退货调价损益
 .s stktkAdjQty=+$P(stats,"^",40)/fac  ;盘点调整数量
 .s stktkAdjAmt=+$P(stats,"^",41)  ;盘点调整金额 
 .s manuXQty=+$P(stats,"^",42)/fac
 .s manuXAmt=+$P(stats,"^",43)
 .s manuMQty=+$P(stats,"^",44)/fac
 .s manuMAmt=+$P(stats,"^",45)
 .s mRecQty=+$P(stats,"^",46)/fac
 .s mRecAmt=+$P(stats,"^",47)
 .s phaOutRetAspAmt=+$P(stats,"^",48)  ;门诊退药调价损益
 .s phaRetAspAmt=+$P(stats,"^",49)  ;住院退药调价损益
 .s recAspAmt=+$P(stats,"^",37) ;入库损益
 .s phaOutDispAspAmt=0
 .s phaDispAspAmt=0 
 .d OutPutRowR
 .
 Quit $$$OK
 
OutPutRowR
 s Data=$lb(stat,inci,inciCode,inciDesc,spec,uomDesc,qty,amt,lastQty,lastAmt,recQty,recAmt,retQty,retAmt,trOutQty,trOutAmt,trInQty,trInAmt,adjQty,adjAmt,csmQty,csmAmt,disposeQty,disposeAmt,phaInDspQty,phaInDspAmt,aspAmt,phaInRetQty,phaInRetAmt,phaOutDspQty,phaOutDspAmt,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty,phaOutRetAmt,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty,giftRecAmt,giftTrOutQty,giftTrOutAmt,chgRecQty,chgRecAmt,chgRetQty,chgRetAmt,retAspAmt,phaRetAspAmt,mRecQty,mRecAmt,stktkAdjQty,stktkAdjAmt,manuXQty,manuXAmt,manuMQty,manuMAmt,phaOutRetAspAmt,trInAspAmt,recAspAmt,phaOutDispAspAmt,phaDispAspAmt,locDescIO,hospDescIO,UserDescIO,CreateDateIO,CreateTimeIO,FrDateIO,FrTimeIO,ToDateIO,ToTimeIO)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod StkMonRepItmRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StkMonRepItmRpExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StkMonRepItmRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StkMonRepItmRpExecute ]
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

/// 检索月报汇总
/// Author:wyx
/// Date:2014-02-12
/// Argu:
///  month-月报月份
/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCStkMonRepQuery","StkMonRepItmT","2013-11-01")
Query StkMonRepItmT(month As %String) As %Query(ROWSPEC = "locid:%String,Locdesc:%String,stkcat:%String,stkcatdesc:%String,pricetype:%String,lastAmt:%String,amt:%String,trinsum:%String,recAmt:%String,phaOutRetAmt:%String,phaInRetAmt:%String,outsum:%String,retAmt:%String,troutsum:%String,canelsum:%String,phaOutDspAmt:%String,phaInDspAmt:%String,aspAmt:%String,stktkAdjAmt") [ SqlProc ]
{
}

ClassMethod StkMonRepItmTExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
 q:month="" $$$OK
 s ^tmpsm=month
 ;
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 s stkcode=$g(stkcode)
 
 s month=$zdh(month,3)
 s pid=..NewPid()
 s retnum=..GetStkMonRepAllSp(pid,month)
 s retrpnum=..GetStkMonRepAllRp(pid,month)
 s index=""
 s lastAmtSumRp=0,lastAmtSum=0,lastAmt=0
 s amtSumRp=0,amtSum=0,amt=0
 s trinsumSumRp=0,trinsumSum=0,trinsum=0
 s recAmtSumRp=0,recAmtSum=0,recAmt=0
 s phaOutRetAmtSumRp=0,phaOutRetAmtSum=0,phaOutRetAmt=0
 s phaInRetAmtSumRp=0,phaInRetAmtSum=0,phaInRetAmt=0
 s outsumSumRp=0,outsumSum=0,outsum=0
 s retAmtSumRp=0,retAmtSum=0,retAmt=0
 s troutsumSumRp=0,troutsumSum=0,troutsum=0
 s canelsumSumRp=0,canelsumSum=0,canelsum=0
 s phaOutDspAmtSumRp=0,phaOutDspAmtSum=0,phaOutDspAmt=0
 s phaInDspAmtSumRp=0,phaInDspAmtSum=0,phaInDspAmt=0
 s aspAmtSumRp=0,aspAmtSum=0,aspAmt=0
 s stktkAdjAmtSumRp=0,stktkAdjAmtSum=0,stktkAdjAmt=0
 f  s index=$o(^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)) q:index=""  d
 .s locid=$p(index,",",1)
 .s HospId=$p(^CTLOC(locid),"^",22)
 .s locdesc=$p(index,",",2)
 .s stkcatdesc=$p(index,",",3)
 .s pricetype=$p(index,",",4)
 .s data=^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)
 .s lastAmt=$p(data,"^",1)
 .s amt=$p(data,"^",2)
 .s trinsum=$p(data,"^",3)
 .s recAmt=$p(data,"^",4)
 .s phaOutRetAmt=$p(data,"^",5)
 .s phaInRetAmt=$p(data,"^",6)
 .s outsum=$p(data,"^",7)
 .s retAmt=$p(data,"^",8)
 .s troutsum=$p(data,"^",9)
 .s canelsum=$p(data,"^",10)
 .s phaOutDspAmt=$p(data,"^",11)
 .s phaInDspAmt=$p(data,"^",12)
 .s aspAmt=$p(data,"^",13)
 .s stktkAdjAmt=$p(data,"^",14)
 .s lastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(lastAmt,HospId)
 .s amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(amt,HospId)
 .i pricetype="售价" d
 ..s lastAmtSum=lastAmtSum+lastAmt
 ..s amtSum=amtSum+amt
 ..s trinsumSum=trinsumSum+trinsum
 ..s recAmtSum=recAmtSum+recAmt
 ..s phaOutRetAmtSum=phaOutRetAmtSum+phaOutRetAmt
 ..s phaInRetAmtSum=phaInRetAmtSum+phaInRetAmt
 ..s outsumSum=outsumSum+outsum
 ..s retAmtSum=retAmtSum+retAmt
 ..s troutsumSum=troutsumSum+troutsum
 ..s canelsumSum=canelsumSum+canelsum
 ..s phaOutDspAmtSum=phaOutDspAmtSum+phaOutDspAmt
 ..s phaInDspAmtSum=phaInDspAmtSum+phaInDspAmt
 ..s aspAmtSum=aspAmtSum+aspAmt
 ..s stktkAdjAmtSum=stktkAdjAmtSum+stktkAdjAmt
 .
 .i pricetype="进价" d
 ..s lastAmtSumRp=lastAmtSumRp+lastAmt
 ..s amtSumRp=amtSumRp+amt
 ..s trinsumSumRp=trinsumSumRp+trinsum
 ..s recAmtSumRp=recAmtSumRp+recAmt
 ..s phaOutRetAmtSumRp=phaOutRetAmtSumRp+phaOutRetAmt
 ..s phaInRetAmtSumRp=phaInRetAmtSumRp+phaInRetAmt
 ..s outsumSumRp=outsumSumRp+outsum
 ..s retAmtSumRp=retAmtSumRp+retAmt
 ..s troutsumSumRp=troutsumSumRp+troutsum
 ..s canelsumSumRp=canelsumSumRp+canelsum
 ..s phaOutDspAmtSumRp=phaOutDspAmtSumRp+phaOutDspAmt
 ..s phaInDspAmtSumRp=phaInDspAmtSumRp+phaInDspAmt
 ..s aspAmtSumRp=aspAmtSumRp+aspAmt
 ..s stktkAdjAmtSumRp=stktkAdjAmtSumRp+stktkAdjAmt
 .d OutPutRow11
 .
 d OutPutRowSumSp
 d OutPutRowSumRp
 k ^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid)
 Quit $$$OK
 
OutPutRow11
 s Data=$lb(locid,locdesc,stkcat,stkcatdesc,pricetype,lastAmt,amt,trinsum,recAmt,phaOutRetAmt,phaInRetAmt,outsum,retAmt,troutsum,canelsum,phaOutDspAmt,phaInDspAmt,aspAmt,stktkAdjAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
OutPutRowSumSp
 s Data=$lb("","","","合计","售价",lastAmtSum,amtSum,trinsumSum,recAmtSum,phaOutRetAmtSum,phaInRetAmtSum,outsumSum,retAmtSum,troutsumSum,canelsumSum,phaOutDspAmtSum,phaInDspAmtSum,aspAmtSum,stktkAdjAmtSum)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
OutPutRowSumRp
 s Data=$lb("","","","合计","进价",lastAmtSumRp,amtSumRp,trinsumSumRp,recAmtSumRp,phaOutRetAmtSumRp,phaInRetAmtSumRp,outsumSumRp,retAmtSumRp,troutsumSumRp,canelsumSumRp,phaOutDspAmtSumRp,phaInDspAmtSumRp,aspAmtSumRp,stktkAdjAmtSumRp)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod StkMonRepItmTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StkMonRepItmTExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StkMonRepItmTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StkMonRepItmTExecute ]
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

ClassMethod GetStkMonRepAllSp(pid, month)
{
 n (pid,month)
 s locid=""
 s n=0
 f  s locid=$o(^DHCSM(0,"MLOC",month,locid)) q:locid=""  d
 .//add wyx 2014-02-21 根据科室的库房类别判断哪些科室需要汇总
 .s dhclocdr=$o(^DHCLOC(0,"LOC",locid,""))
 .s loctype=$p(^DHCLOC(dhclocdr),"^",5) //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
 .q:(loctype'="R")&(loctype'="I")&(loctype'="O")
 .//s ligdr=$p(^DHCLOC(dhclocdr),"^",2) //科室项目组dr
 .//q:ligdr=""
 .//s ligcode=$p(^DHCLIG(ligdr),"^",1)
 .//q:ligcode'="DrugStkAllSum"
 .
 .s sm=$o(^DHCSM(0,"MLOC",month,locid,""),-1) 
 .s ch=""
 .s LocId=$p(^DHCSM(sm),"^",1)
 .s LocDesc=$p(^CTLOC(LocId),"^",2)
 .s HospId=$p(^CTLOC(LocId),"^",22)
 .f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
 ..s smr=sm_"||"_ch
 ..s row=^DHCSM(sm,"R",ch)
 ..s inci=$p(row,"^",3)  ;inci  
 ..s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 ..s grpid=$p(stkgrpinfo,"^",5)
 ..//q:(stkgrpid'="")&(grpid'=stkgrpid)
 ..s stkcat=$p(^INCI(inci,2),"^",2)
 ..//q:(stkcatid'="")&(stkcat'=stkcatid)  
 ..s stkcatdesc=$p(stkgrpinfo,"^",2)
 ..s inciCode=$p(^INCI(inci,1),"^",1)    ;inci code
 ..s inciDesc=$p(^INCI(inci,1),"^",2)    ;inci desc
 ..//q:(incdesc'="")&('$f(inciDesc,incdesc))
 ..s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ..s inciuomdr=$p(^INCI(inci,1),"^",10)      ;uom dr
 ..s puruom=$p(^INCI(inci,3),"^",6)      ;purch uom dr 
 ..i puruom="" s puruom=inciuomdr
 ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,inciuomdr)
 ..s uomDesc=$p(^CT("UOM",puruom),"^",2)  ;uom desc
 ..s qty=$p(row,"^",6)     ;qty
 ..s qty=qty/fac
 ..//s qty=$fn(qty,"",2)
 ..s amt=$p(row,"^",7)  ;amount
 ..//add wyx 2014-02-11
 ..//s amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(amt,HospId)
 ..s lastQty=$p(row,"^",9) ;qty of last month
 ..s lastQty=lastQty/fac
 ..//s lastQty=$fn(lastQty,"",2)
 ..s lastAmt=$p(row,"^",10)    ;amount of last month
 ..//s lastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(lastAmt,HospId)
 ..;
 ..//售价
 ..s stat=$o(^SMSTAT(0,"SMR",smr,""))
 ..q:$g(stat)=""
 ..s stats=$G(^SMSTAT(stat))
 ..s recQty=$P(stats,"^",2)/fac  ;入库数量
 ..s recAmt=$P(stats,"^",3) ;入库金额
 ..s retQty=$P(stats,"^",4)/fac ;退货数量
 ..s retAmt=$P(stats,"^",5) ;退货金额
 ..s trOutQty=$P(stats,"^",6)/fac  ;转出数量
 ..s trOutAmt=$P(stats,"^",7) ;转出金额
 ..s trInQty=$P(stats,"^",8)/fac ;转入数量
 ..s trInAmt=$P(stats,"^",9) ;转入金额
 ..s adjQty=$P(stats,"^",10)/fac  ;库存调整数量
 ..s adjAmt=$P(stats,"^",11) ;库存调整金额
 ..s csmQty=$P(stats,"^",12)/fac   ;报损数量
 ..s csmAmt=$P(stats,"^",13) ;报损金额
 ..s disposeQty=$P(stats,"^",14)/fac ;发放数量
 ..s disposeAmt=$P(stats,"^",15) ;发放金额
 ..s phaInDspQty=$P(stats,"^",16)/fac ;发药数量(住院)
 ..s phaInDspAmt=$P(stats,"^",17)  ;发药金额(住院)
 ..s aspAmt=$P(stats,"^",18)  ;调价损益金额
 ..s phaInRetQty=$P(stats,"^",19)/fac ;退药数量(住院)
 ..s phaInRetAmt=$P(stats,"^",20)  ;退药金额(住院)
 ..
 ..s phaOutDspQty=$P(stats,"^",21)/fac ;发药数量(门诊)
 ..s phaOutDspAmt=$P(stats,"^",22)   ;发药金额(门诊)
 ..s phaOutDspQtyS=$P(stats,"^",23)/fac  ;发药数量(门诊非正常)
 ..s phaOutDspAmtS=$P(stats,"^",24) ;发药金额(门诊非正常)
 ..s phaOutRetQty=$P(stats,"^",25)/fac  ;退药数量(门诊)
 ..s phaOutRetAmt=$P(stats,"^",26)  ;退药金额(门诊)
 ..s phaOutRetQtyZ=$P(stats,"^",27)/fac   ;退药数量(门诊非正常)
 ..s phaOutRetAmtZ=$P(stats,"^",28)  ;退药金额量(门诊非正常)
 ..s giftRecQty=$P(stats,"^",29)/fac ;入库数量(赠品)
 ..s giftRecAmt=$P(stats,"^",30)  ;入库(赠品)
 ..s giftTrOutQty=$P(stats,"^",31)/fac ;转出数量(赠品)
 ..s giftTrOutAmt=$P(stats,"^",32)  ;转出金额(赠品)
 ..s chgRecQty=$P(stats,"^",33)/fac ;入库数量(调价换票)
 ..s chgRecAmt=$P(stats,"^",34)  ;入库金额(调价换票)
 ..s chgRetQty=$P(stats,"^",35)/fac ;退货数量(调价换票)
 ..s chgRetAmt=$P(stats,"^",36)  ;退货金额(调价换票)
 ..
 ..s retAspAmt=$P(stats,"^",37)    ;退货调价损益
 ..s phaRetAspAmt=$P(stats,"^",38)  ;住院退药调价损益
 ..s mRecQty=$P(stats,"^",39)/fac
 ..s mRecAmt=$P(stats,"^",40)
 ..s stktkAdjQty=$P(stats,"^",41)/fac  ;盘点调整数量
 ..s stktkAdjAmt=$P(stats,"^",42)  ;盘点调整金额 
 ..
 ..s manuXQty=$P(stats,"^",43)/fac
 ..s manuXAmt=$P(stats,"^",44)
 ..s manuMQty=$P(stats,"^",45)/fac
 ..s manuMAmt=$P(stats,"^",46)
 ..s phaOutRetAspAmt=$P(stats,"^",47)  ;门诊退药调价损益
 ..s trInAspAmt=$P(stats,"^",48)  ;库存转入调价损益
 ..//add wyx 2014-02-18 
 ..s retstr=..GetStkMonTrans(LocDesc,sm,ch)
 ..s trinsum=$p(retstr,"^",1) //调入
 ..s troutsum=$p(retstr,"^",3) //调出
 ..s insum=$p(retstr,"^",5)  //入库
 ..i LocDesc '[ "药库" s recAmt=insum
 ..s outsum=$p(retstr,"^",7) //退库
 ..s canelsum=$p(retstr,"^",9) //出库
 ..
 ..s pricetype="售价"
 ..s data1=lastAmt_"^"_amt_"^"_trinsum_"^"_recAmt_"^"_phaOutRetAmt
 ..s data2=phaInRetAmt_"^"_outsum_"^"_retAmt_"^"_troutsum_"^"_canelsum
 ..s data3=phaOutDspAmt_"^"_phaInDspAmt_"^"_aspAmt_"^"_stktkAdjAmt
 ..s index=locid_","_LocDesc_","_stkcatdesc_","_pricetype
 ..i '$d(^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)) d
 ...s ^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)=data1_"^"_data2_"^"_data3
 ...s n=n+1
 ..e  d
 ...s datatmp=^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)
 ...s $p(datatmp,"^",1)=$p(datatmp,"^",1)+lastAmt
 ...s $p(datatmp,"^",2)=$p(datatmp,"^",2)+amt
 ...s $p(datatmp,"^",3)=$p(datatmp,"^",3)+trinsum
 ...s $p(datatmp,"^",4)=$p(datatmp,"^",4)+recAmt
 ...s $p(datatmp,"^",5)=$p(datatmp,"^",5)+phaOutRetAmt
 ...s $p(datatmp,"^",6)=$p(datatmp,"^",6)+phaInRetAmt
 ...s $p(datatmp,"^",7)=$p(datatmp,"^",7)+outsum
 ...s $p(datatmp,"^",8)=$p(datatmp,"^",8)+retAmt
 ...s $p(datatmp,"^",9)=$p(datatmp,"^",9)+troutsum
 ...s $p(datatmp,"^",10)=$p(datatmp,"^",10)+canelsum
 ...s $p(datatmp,"^",11)=$p(datatmp,"^",11)+phaOutDspAmt
 ...s $p(datatmp,"^",12)=$p(datatmp,"^",12)+phaInDspAmt
 ...s $p(datatmp,"^",13)=$p(datatmp,"^",13)+aspAmt
 ...s $p(datatmp,"^",14)=$p(datatmp,"^",14)+stktkAdjAmt
 ...
 ...s ^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)=datatmp
 ...s n=n+1
 ...
 ...
 q n
}

ClassMethod GetStkMonRepAllRp(pid, month)
{
 
 n (pid,month)
 s locid=""
 s n=0
 f  s locid=$o(^DHCSM(0,"MLOC",month,locid)) q:locid=""  d
 .//add wyx 2014-02-21 根据科室的库房类别判断哪些科室需要汇总
 .s dhclocdr=$o(^DHCLOC(0,"LOC",locid,""))
 .s loctype=$p(^DHCLOC(dhclocdr),"^",5) //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
 .q:(loctype'="R")&(loctype'="I")&(loctype'="O")
 .//s ligdr=$p(^DHCLOC(dhclocdr),"^",2) //科室项目组dr
 .//q:ligdr=""
 .//s ligcode=$p(^DHCLIG(ligdr),"^",1)
 .//q:ligcode'="DrugStkAllSum"
 .
 .s sm=$o(^DHCSM(0,"MLOC",month,locid,""),-1) 
 .s ch=""
 .s LocId=$p(^DHCSM(sm),"^",1)
 .s LocDesc=$p(^CTLOC(LocId),"^",2)
 .s HospId=$p(^CTLOC(LocId),"^",22)
 .f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
 ..s smr=sm_"||"_ch
 ..s row=^DHCSM(sm,"R",ch)
 ..s inci=$p(row,"^",3)  ;inci  
 ..s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 ..s grpid=$p(stkgrpinfo,"^",5)
 ..//q:(stkgrpid'="")&(grpid'=stkgrpid)
 ..s stkcat=$p(^INCI(inci,2),"^",2)
 ..//q:(stkcatid'="")&(stkcat'=stkcatid)  
 ..s stkcatdesc=$p(stkgrpinfo,"^",2)
 ..s inciCode=$p(^INCI(inci,1),"^",1)    ;inci code
 ..s inciDesc=$p(^INCI(inci,1),"^",2)    ;inci desc
 ..//q:(incdesc'="")&('$f(inciDesc,incdesc))
 ..s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ..s inciuomdr=$p(^INCI(inci,1),"^",10)      ;uom dr
 ..s puruom=$p(^INCI(inci,3),"^",6)      ;purch uom dr 
 ..i puruom="" s puruom=inciuomdr
 ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,inciuomdr)
 ..s uomDesc=$p(^CT("UOM",puruom),"^",2)  ;uom desc
 ..///进价
 ..s amtRp=$p(row,"^",8)  ;amount
 ..//s amtRp=##class(web.DHCST.Common.AppCommon).FormatSpAmt(amtRp,HospId)
 ..//s lastQty=$p(row,"^",9) ;qty of last month
 ..//s lastQty=lastQty/fac
 ..s lastAmtRp=$p(row,"^",11)    ;amount of last month
 ..//s lastAmtRp=##class(web.DHCST.Common.AppCommon).FormatSpAmt(lastAmtRp,HospId)
 ..;
 ..s stat=$o(^SMSTATI(0,"SMR",smr,""))
 ..q:$g(stat)=""
 ..s stats=$G(^SMSTATI(stat))
 ..
 ..s recQtyRp=$P(stats,"^",2)/fac  ;入库数量
 ..s recAmtRp=$P(stats,"^",3) ;入库金额
 ..s retQtyRp=$P(stats,"^",4)/fac ;退货数量
 ..s retAmtRp=$P(stats,"^",5) ;退货金额
 ..s trOutQtyRp=$P(stats,"^",6)/fac  ;转出数量
 ..s trOutAmtRp=$P(stats,"^",7) ;转出金额
 ..s trInQtyRp=$P(stats,"^",8)/fac ;转入数量
 ..s trInAmtRp=$P(stats,"^",9) ;转入金额
 ..s adjQtyRp=$P(stats,"^",10)/fac  ;库存调整数量
 ..s adjAmtRp=$P(stats,"^",11) ;库存调整金额
 ..s csmQtyRp=$P(stats,"^",12)/fac   ;报损数量
 ..s csmAmtRp=$P(stats,"^",13) ;报损金额
 ..s disposeQtyRp=$P(stats,"^",14)/fac ;发放数量
 ..s disposeAmtRp=$P(stats,"^",15) ;发放金额
 ..s phaInDspQtyRp=$P(stats,"^",16)/fac ;发药数量(住院)
 ..s phaInDspAmtRp=$P(stats,"^",17)  ;发药金额(住院)
 ..s aspAmtRp=$P(stats,"^",18)  ;调价损益金额
 ..s phaInRetQtyRp=$P(stats,"^",19)/fac ;退药数量(住院)
 ..s phaInRetAmtRp=$P(stats,"^",20)  ;退药金额(住院)
 ..
 ..s giftRecQtyRp=$P(stats,"^",21)/fac ;入库数量(赠品)
 ..s giftRecAmtRp=$P(stats,"^",22)  ;入库(赠品)
 ..s giftTrOutQtyRp=$P(stats,"^",23)/fac ;转出数量(赠品)
 ..s giftTrOutAmtRp=$P(stats,"^",24)  ;转出金额(赠品)
 ..
 ..s chgRecQtyRp=$P(stats,"^",25)/fac ;入库数量(调价换票)
 ..s chgRecAmtRp=$P(stats,"^",26)  ;入库金额(调价换票)
 ..s chgRetQtyRp=$P(stats,"^",27)/fac ;退货数量(调价换票)
 ..s chgRetAmtRp=$P(stats,"^",28)  ;退货金额(调价换票)
 ..
 ..s phaOutDspQtyRp=$P(stats,"^",29)/fac ;发药数量(门诊)
 ..s phaOutDspAmtRp=$P(stats,"^",30)   ;发药金额(门诊)
 ..s phaOutDspQtySRp=$P(stats,"^",31)/fac  ;发药数量(门诊非正常)
 ..s phaOutDspAmtSRp=$P(stats,"^",32) ;发药金额(门诊非正常)
 ..
 ..s phaOutRetQtyRp=$P(stats,"^",33)/fac  ;退药数量(门诊)
 ..s phaOutRetAmtRp=$P(stats,"^",34)  ;退药金额(门诊)
 ..s phaOutRetQtyZRp=$P(stats,"^",35)/fac   ;退药数量(门诊非正常)
 ..s phaOutRetAmtZRp=$P(stats,"^",36)  ;退药金额量(门诊非正常)
 ..
 ..s trInAspAmtRp=$P(stats,"^",38)  ;库存转入调价损益
 ..s retAspAmtRp=$P(stats,"^",39)    ;退货调价损益
 ..s stktkAdjQtyRp=$P(stats,"^",40)/fac  ;盘点调整数量
 ..s stktkAdjAmtRp=$P(stats,"^",41)  ;盘点调整金额 
 ..s manuXQtyRp=$P(stats,"^",42)/fac
 ..s manuXAmtRp=$P(stats,"^",43)
 ..s manuMQtyRp=$P(stats,"^",44)/fac
 ..s manuMAmtRp=$P(stats,"^",45)
 ..s mRecQtyRp=$P(stats,"^",46)/fac
 ..s mRecAmtRp=$P(stats,"^",47)
 ..s phaOutRetAspAmtRp=$P(stats,"^",48)  ;门诊退药调价损益
 ..s phaRetAspAmtRp=$P(stats,"^",49)  ;住院退药调价损益
 ..
 ..//add wyx 2014-02-18 
 ..s retstr=..GetStkMonTrans(LocDesc,sm,ch)
 ..s trinsumRp=$p(retstr,"^",2) //调入
 ..s troutsumRp=$p(retstr,"^",4) //调出
 ..s insumRp=$p(retstr,"^",6)  //入库
 ..i LocDesc '[ "药库" s recAmtRp=inRpsum
 ..s outsumRp=$p(retstr,"^",8) //退库
 ..s canelsumRp=$p(retstr,"^",10) //出库
 ..
 ..s pricetype="进价"
 ..s data1=lastAmtRp_"^"_amtRp_"^"_trinsumRp_"^"_recAmtRp_"^"_phaOutRetAmtRp
 ..s data2=phaInRetAmtRp_"^"_outsumRp_"^"_retAmtRp_"^"_troutsumRp_"^"_canelsumRp
 ..s data3=phaOutDspAmtRp_"^"_phaInDspAmtRp_"^"_aspAmtRp_"^"_stktkAdjAmtRp
 ..s index=locid_","_LocDesc_","_stkcatdesc_","_pricetype
 ..i '$d(^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)) d
 ...s ^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)=data1_"^"_data2_"^"_data3
 ...s n=n+1
 ..e  d
 ...s datatmp=^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)
 ...s $p(datatmp,"^",1)=$p(datatmp,"^",1)+lastAmtRp
 ...s $p(datatmp,"^",2)=$p(datatmp,"^",2)+amtRp
 ...s $p(datatmp,"^",3)=$p(datatmp,"^",3)+trinsumRp
 ...s $p(datatmp,"^",4)=$p(datatmp,"^",4)+recAmtRp
 ...s $p(datatmp,"^",5)=$p(datatmp,"^",5)+phaOutRetAmtRp
 ...s $p(datatmp,"^",6)=$p(datatmp,"^",6)+phaInRetAmtRp
 ...s $p(datatmp,"^",7)=$p(datatmp,"^",7)+outsumRp
 ...s $p(datatmp,"^",8)=$p(datatmp,"^",8)+retAmtRp
 ...s $p(datatmp,"^",9)=$p(datatmp,"^",9)+troutsumRp
 ...s $p(datatmp,"^",10)=$p(datatmp,"^",10)+canelsumRp
 ...s $p(datatmp,"^",11)=$p(datatmp,"^",11)+phaOutDspAmtRp
 ...s $p(datatmp,"^",12)=$p(datatmp,"^",12)+phaInDspAmtRp
 ...s $p(datatmp,"^",13)=$p(datatmp,"^",13)+aspAmtRp
 ...s $p(datatmp,"^",14)=$p(datatmp,"^",14)+stktkAdjAmtRp
 ...s ^TMP("DHCST","DHCStkMonRepQuery","StkMonRepItmT",pid,index)=datatmp
 ...s n=n+1
 ...
 ...
 q n
}

// add:wyx 2014-02-17

// input:locDesc月报科室,sm月报主表rowid，ch月报子表Childsub

// output:调入（就是不是药库调拨过来的而是药房调拨过来的） --K

//     --调出（就是这个药房调拨给别的药房的）  --T

//     --入库（就是药库调拨给药房的，或者供应商给药库的(在此方法里不计算)）--K

//     --退库（就是药房退给药库的 也就是药房调拨回药库的）--T(药房发给药库--负数)--K(药库接收药房-正数)

//     --出库（就是只记录类型为药库的 调拨给药房的）--T

//     --

ClassMethod GetStkMonTrans(locDesc, sm, ch)
{
  s smt=""
  s locflag=""
  i locDesc [ "药库" s locflag="1"
  e  i locDesc [ "药房" s locflag="2"
  s trinsum=0 //调入
  s troutsum=0 //调出
  s insum=0    //入库
  s outsum=0    //退库
  s canelsum=0   //出库
  
  s trinRpsum=0 //调入
  s troutRpsum=0 //调出
  s inRpsum=0    //入库
  s outRpsum=0    //退库
  s canelRpsum=0   //出库

 
  f  s smt=$o(^DHCSM(sm,"R",ch,"T",smt)) q:smt=""  d
  .s trtype=$p(^DHCSM(sm,"R",ch,"T",smt),"^",1)
  .s trpointer=$p(^DHCSM(sm,"R",ch,"T",smt),"^",2) //dhc_intrans 的 Dr
  .s pointer=$p(^DHCINTR(trpointer),"^",9) //DHC_InIsTrfItm 的 Dr
  .s tramt=$p(^DHCSM(sm,"R",ch,"T",smt),"^",4)
  .s trrpamt=$p(^DHCSM(sm,"R",ch,"T",smt),"^",5)
  .s oplocflag=""
  .i trtype="T" d
  ..s toloc=$p(^DHCINIT(+pointer),"^",6)
  ..s tolocdesc=$p(^CTLOC(toloc),"^",2)
  ..i tolocdesc [ "药库" s oplocflag="1"
  ..e  i tolocdesc [ "药房" s oplocflag="2"
  ..//调出--退库--出库
  ..//调出
  ..i (locflag="2")&&(oplocflag="2") d 
  ...s troutsum=troutsum+tramt
  ...s troutRpsum=troutRpsum+trrpamt
  ..//退库
  ..i (locflag="2")&&(oplocflag="1") d 
  ...s outsum=outsum+tramt
  ...s outRpsum=outRpsum+trrpamt
  ..//出库
  ..i (locflag="1")&&(oplocflag="2") d 
  ...//s tramt=tramt*(-1)
  ...//s trrpamt=trrpamt*(-1)
  ...s tramt=tramt
  ...s trrpamt=trrpamt
  ...s canelsum=canelsum+tramt
  ...s canelRpsum=canelRpsum+trrpamt
  ..
  .i trtype="K" d
  ..s toloc=$p(^DHCINIT(+pointer),"^",5)
  ..s tolocdesc=$p(^CTLOC(toloc),"^",2)
  ..i tolocdesc [ "药库" s oplocflag="1"
  ..e  i tolocdesc [ "药房" s oplocflag="2"
  ..//调入--入库--退库(药库接收药房)
  ..//调入
  ..i (locflag="2")&&(oplocflag="2") d 
  ...s trinsum=trinsum+tramt
  ...s trinRpsum=trinRpsum+trrpamt
  ..//入库--对于接收方是药库的要再处理即type=G的供应商入库的要另算(因为报表中"入库"此行是药房和药库没有分开，所以在输出时如果是药房输出insum，如果是药库输出recAmt)
  ..i (locflag="2")&&(oplocflag="1") d 
  ...s insum=insum+tramt
  ...s inRpsum=inRpsum+trrpamt
  ..//退库
  ..i (locflag="1")&&(oplocflag="2") d 
  ...s outsum=outsum+tramt
  ...s outRpsum=outRpsum+trrpamt
  ..
 q trinsum_"^"_trinRpsum_"^"_troutsum_"^"_troutRpsum_"^"_insum_"^"_inRpsum_"^"_outsum_"^"_outRpsum_"^"_canelsum_"^"_canelRpsum
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DHCStkMonRepQuery"))
}

/// 根据选择的日期时段汇总月报数据
/// Author:wyx
/// Data:2014-08-20
/// Argu:
///  monthstr 开始日期^截至日期
///  type - ( 0,进价;1-售价 )
Query StkMonSumByLocSelMonQuery(locid As %String, monthstr As %String, type As %String) As %Query(ROWSPEC = "grpDesc:%String,LastAmt:%String,Amt:%String,RecAmt:%String,RetAmt:%String,TroAmt:%String,TriAmt:%String,AdjAmt:%String,ConAmt:%String,DisAmt:%String,DspAmt:%String,AspAmt:%String,PhaRetAmt:%String,RetAspAmt:%String,PhaRetAspAmt:%String,GiftRecAmt:%String,giftTrfAmt:%String,chgRecAmt:%String,chgRetAmt:%String,mRecAmt:%String,stktkAdjAmt:%String,manuXAmt:%String,manuMAmt:%String,phoRetAspAmt:%String,trfIAspAmt:%String,InAmt:%String,OutAmt:%String") [ SqlProc ]
{
}

ClassMethod StkMonSumByLocSelMonQueryExecute(ByRef qHandle As %Binary, locid As %String, monthstr As %String, type As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s pid=..NewPid()
  s LocDesc=$p(^CTLOC(locid),"^",2)
  s HospId=$p(^CTLOC(locid),"^",22)
  s StartMonth=$p(monthstr,"^",1)
  s EndMonth=$p(monthstr,"^",2)
  s StartMonth=$G(StartMonth),EndMonth=$G(EndMonth)
  s conv=$s(StartMonth["/":4,StartMonth["-":3,1:"")
  i conv'=""  s StartMonth=$zdh(StartMonth,conv)
  s conv=$s(EndMonth["/":4,EndMonth["-":3,1:"")
  i conv'=""  s EndMonth=$zdh(EndMonth,conv)

  &sql(declare xxx cursor for select dhcsm_rowid from dhc_stkmon
       where dhcsm_ctloc_dr=:locid and dhcsm_month between :StartMonth and :EndMonth)
  &sql(open xxx)
 s sm=""
 s (LastAmtSum,AmtSum,RecAmtSum,RetAmtSum,TroAmtSum,TriAmtSum,AdjAmtSum,ConAmtSum,DisAmtSum,DspAmtSum,AspAmtSum,PhaRetAmtSum,RetAspAmtSum,PhaRetAspAmtSum,GiftRecAmtSum,giftTrfAmtSum,chgRecAmtSum,chgRetAmtSum,mRecAmtSum,stktkAdjAmtSum,manuXAmtSum,manuMAmtSum,phoRetAspAmtSum,trfIAspAmtSum,InSum,OutSum)=0
 f  &sql(fetch xxx into :sm)   q:SQLCODE  d
 .i type="1" s rows=..CalStkMonCatByLocSel(pid,sm)   //售价统计
 .e  s rows=..CalStkMonCatINByLocSel(pid,sm)   //进价统计
 .s grpDesc=""
 .f  s grpDesc=$o(^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid,sm,grpDesc)) q:grpDesc=""  d
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
 ..
 ..//s GiftTroAmt=0
 ..//s ChgRecAmt=0
 ..//s ChgRetAmt=0
 ..s PhaRetAspAmt=0
 ..//s PhoRetAspAmt=0  
 ..s RetAspAmt=0
 ..//s TrfIAspAmt=0
 ..s PhaRetAmt=0   //退药金额汇总
 ..s giftTrfAmt=0
 ..s chgRecAmt=0
 ..s chgRetAmt=0
 ..s mRecAmt =0
 ..s stktkAdjAmt=0
 ..s manuXAmt=0
 ..s manuMAmt=0
 ..s phoRetAspAmt=0
 ..s trfIAspAmt= 0
 ..;
 ..s DspAmtP=0
 ..s DspAmtF=0
 ..s DspAmtS=0
 ..s PhaRetAmtY=0
 ..s PhaRetAmtH=0
 ..s PhaRetAmtZ=0
 ..
 ..s cat="" f  s cat=$o(^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid,sm,grpDesc,cat)) q:cat=""  d
 ...s nn=0
 ...f  s nn=$o(^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid,sm,grpDesc,cat,nn)) q:nn=""  d
 ....s amt=^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid,sm,grpDesc,cat,nn)
 ....s LastAmt=$g(LastAmt)+$p(amt,"^",1)
 ....s Amt=$g(Amt)+$p(amt,"^",2)
 ....s RecAmt=$g(RecAmt)+$p(amt,"^",3)
 ....s RetAmt=$g(RetAmt)+$p(amt,"^",4)
 ....s TroAmt=$g(TroAmt)+$p(amt,"^",5)
 ....s TriAmt=$g(TriAmt)+$p(amt,"^",6)
 ....s AdjAmt=$g(AdjAmt)+$p(amt,"^",7)
 ....s ConAmt=$g(ConAmt)+$p(amt,"^",8)
 ....s DisAmt=$g(DisAmt)+$p(amt,"^",9)
 ....s DspAmtP=$G(DspAmtP)+$p(amt,"^",11)
 ....s DspAmtF=$G(DspAmtF)+$p(amt,"^",13)
 ....s DspAmtS=$G(DspAmtS)+$p(amt,"^",14)
 ....s DspAmt=$g(DspAmt)+$p(amt,"^",11)+$p(amt,"^",13)+$p(amt,"^",14)   //发药(门诊、住院汇总)
 ....s AspAmt=$g(AspAmt)+$p(amt,"^",10)
 ....s PhaRetAmtY=$G(PhaRetAmtY)+$p(amt,"^",12)
 ....s PhaRetAmtH=$G(PhaRetAmtH)+$p(amt,"^",15)
 ....s PhaRetAmtZ=$G(PhaRetAmtZ)+$p(amt,"^",16)
 ....s PhaRetAmt=$g(PhaRetAmt)+$p(amt,"^",12)+$p(amt,"^",15)+$p(amt,"^",16)  //退药(门诊、住院汇总)
 ....s GiftRecAmt=$g(GiftRecAmt)+$p(amt,"^",17)
 ....s RetAspAmt=$g(RetAspAmt)+$p(amt,"^",18)
 ....s PhaRetAspAmt=$g(PhaRetAspAmt)+$p(amt,"^",19)
 ....s giftTrfAmt=giftTrfAmt+$p(amt,"^",20)
 ....s chgRecAmt=chgRecAmt+$p(amt,"^",21)
 ....s chgRetAmt=chgRetAmt+$p(amt,"^",22)
 ....s mRecAmt = mRecAmt+$p(amt,"^",23)
 ....s stktkAdjAmt=stktkAdjAmt+$p(amt,"^",24)  
 ....s manuXAmt=manuXAmt+$p(amt,"^",25)  //??
 ....s manuMAmt=manuMAmt+$p(amt,"^",26)   //??
 ....s phoRetAspAmt=phoRetAspAmt+$p(amt,"^",27)
 ....s trfIAspAmt= trfIAspAmt+$p(amt,"^",28)  
 ..s In=RecAmt+TriAmt+PhaRetAmt+$G(manuXAmt)
 ..s Out=RetAmt+TroAmt+ConAmt+DisAmt+DspAmt+$g(manuMAmt)
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
 ..s LastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmt,HospId)
 ..s Amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(Amt,HospId)
 ..s LastAmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmtSum,HospId)
 ..s AmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(AmtSum,HospId)
 ..d OutPutRow22 
 k ^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid)  ;kill the temporary global variable
 &sql(close xxx)
 Quit $$$OK
OutPutRow22
 s Data=$lb(grpDesc,LastAmt,Amt,RecAmt,RetAmt,TroAmt,TriAmt,AdjAmt,ConAmt,DisAmt,DspAmt,AspAmt,PhaRetAmt,RetAspAmt,PhaRetAspAmt,GiftRecAmt,giftTrfAmt,chgRecAmt,chgRetAmt,mRecAmt,stktkAdjAmt,manuXAmt,manuMAmt,phoRetAspAmt,trfIAspAmt,In,Out)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
OutPutRowSum1
 s Data=$lb("合计:",LastAmtSum,AmtSum,RecAmtSum,RetAmtSum,TroAmtSum,TriAmtSum,AdjAmtSum,ConAmtSum,DisAmtSum,DspAmtSum,AspAmtSum,PhaRetAmtSum,RetAspAmtSum,PhaRetAspAmtSum,GiftRecAmtSum,giftTrfAmtSum,chgRecAmtSum,chgRetAmtSum,mRecAmtSum,stktkAdjAmtSum,manuXAmtSum,manuMAmtSum,phoRetAspAmtSum,trfIAspAmtSum,InSum,OutSum)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod StkMonSumByLocSelMonQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StkMonSumByLocSelMonQueryExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StkMonSumByLocSelMonQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StkMonSumByLocSelMonQueryExecute ]
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

ClassMethod CalStkMonCatByLocSel(pid, sm)
{
 n (pid,sm)
 s n=0
 k ^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid)
 s ch=""
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d   
 .s data=^DHCSM(sm,"R",ch)  
 .s rowid=sm_"||"_ch  ;rowid
 .s inci=$p(data,"^",3)    ;inci   
 .s cat=$p(^INCI(inci,2),"^",2)  ;cat dr
 .s str=##class(web.DHCST.Common.DrugInfoCommon).StkCatGrpStr(cat)
 .s grpDesc=$p(str,"^",2)
 .i grpDesc="" s grpDesc="不详"
 .//i catdr'="" q:cat'=catdr    ;zdm 2007-5-29
 .s amount=$p(data,"^",7)  ;amount
 .s lastAmount=$p(data,"^",10)    ;amount of last month
 .s statrowid=$o(^SMSTAT(0,"SMR",rowid,""))
 .i $g(statrowid)'=""  d
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
 .s amt=$g(lastAmount)
 .s amt=amt_"^"_$g(amount)
 .s amt=amt_"^"_$g(recAmt)
 .s amt=amt_"^"_$g(retAmt)
 .s amt=amt_"^"_$g(trOAmt)
 .s amt=amt_"^"_$g(trIAmt)
 .s amt=amt_"^"_$g(adjAmt)
 .s amt=amt_"^"_$g(conAmt)
 .s amt=amt_"^"_$g(disposAmt)
 .s amt=amt_"^"_$g(aspAmt)
 .s amt=amt_"^"_$g(phaDspAmtP)
 .s amt=amt_"^"_$g(phaRetAmtY)
 .s amt=amt_"^"_$g(phaDspAmtF)
 .s amt=amt_"^"_$g(phaDspAmtS)
 .s amt=amt_"^"_$g(phaRetAmtH)
 .s amt=amt_"^"_$g(phaRetAmtZ)
 .s amt=amt_"^"_$g(giftRecAmt)
 .s amt=amt_"^"_$g(retAspAmt)
 .s amt=amt_"^"_$g(phaRetAspAmt)
 .s amt=amt_"^"_$g(giftTrfAmt)
 .s amt=amt_"^"_$g(chgRecAmt)
 .s amt=amt_"^"_$g(chgRetAmt)
 .s amt=amt_"^"_$g(mRecAmt)
 .s amt=amt_"^"_$g(stktkAdjAmt)
 .s amt=amt_"^"_$g(manuXAmt)
 .s amt=amt_"^"_$g(manuMAmt)
 .s amt=amt_"^"_$g(phoRetAspAmt)
 .s amt=amt_"^"_$g(trfIAspAmt)
 .s ^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid,sm,grpDesc,cat,n)=amt
 q n
}

ClassMethod CalStkMonCatINByLocSel(pid, sm)
{
 n (pid,sm)
 s n=0
 k ^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid,sm)
 s ch=""
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d    
 .s data=^DHCSM(sm,"R",ch)  
 .s rowid=sm_"||"_ch                ;rowid
 .s inci=$p(data,"^",3)                  ;inci   
 .s cat=$p(^INCI(inci,2),"^",2)         ;cat dr
 .
 .s str=##class(web.DHCST.Common.DrugInfoCommon).StkCatGrpStr(cat)
 .s grpDesc=$p(str,"^",2)
 .i grpDesc="" s grpDesc="不详"
 .
 .s amount=$p(data,"^",8)                ;amount
 .s lastAmount=$p(data,"^",11)           ;amount of last month
 .s statinrowid=$o(^SMSTATI(0,"SMR",rowid,""))
 .i $g(statinrowid)'=""  d
 ..s aaa=$G(^SMSTATI(statinrowid))
 ..s recAmt=$p(aaa,"^",3)
 ..s retAmt=$p(aaa,"^",5)
 ..s trOAmt=$p(aaa,"^",7)
 ..s trIAmt=$p(aaa,"^",9)
 ..s adjAmt=$p(aaa,"^",11)
 ..s conAmt=$p(aaa,"^",13)
 ..s disposAmt=$p(aaa,"^",15)
 ..s aspAmt=$p(aaa,"^",18)
 ..s phaDspAmtP=$p(aaa,"^",17)
 ..s phaRetAmtY=$p(aaa,"^",20)
 ..s phaDspAmtF=$p(aaa,"^",30)
 ..s phaDspAmtS=$p(aaa,"^",32)
 ..s phaRetAmtH=$p(aaa,"^",34)
 ..s phaRetAmtZ=$p(aaa,"^",36)
 ..
 ..s giftRecAmt=$p(aaa,"^",22)  //赠品入库
 ..s giftTrfAmt=$p(aaa,"^",24)  //赠品出库
 ..
 ..s chgRecAmt=$p(aaa,"^",26)
 ..s chgRetAmt=$p(aaa,"^",28)
 ..
 ..s trfIAspAmt=$p(aaa,"^",38) //转移入库调价损益
 ..s retAspAmt=$p(aaa,"^",39)  //退货调价损益
 ..s stktkAdjAmt=$p(aaa,"^",41)  //盘点调整
 ..
 ..s manuXAmt=$p(aaa,"^",43)
 ..s manuMAmt=$p(aaa,"^",45)
 ..s mRecAmt=$p(aaa,"^",47)
 ..
 ..s phoRetAspAmt=$p(aaa,"^",48)  //门诊退药调价损益
 ..s phaRetAspAmt=$p(aaa,"^",49)  //住院退药调价损益
 ..
 .s n=n+1
 .
 .s amt=$g(lastAmount)
 .s amt=amt_"^"_$g(amount)
 .s amt=amt_"^"_$g(recAmt)
 .s amt=amt_"^"_$g(retAmt)
 .s amt=amt_"^"_$g(trOAmt)
 .s amt=amt_"^"_$g(trIAmt)
 .s amt=amt_"^"_$g(adjAmt)
 .s amt=amt_"^"_$g(conAmt)
 .s amt=amt_"^"_$g(disposAmt)
 .s amt=amt_"^"_$g(aspAmt)
 .s amt=amt_"^"_$g(phaDspAmtP)
 .s amt=amt_"^"_$g(phaRetAmtY)
 .s amt=amt_"^"_$g(phaDspAmtF)
 .s amt=amt_"^"_$g(phaDspAmtS)
 .s amt=amt_"^"_$g(phaRetAmtH)
 .s amt=amt_"^"_$g(phaRetAmtZ)
 .s amt=amt_"^"_$g(giftRecAmt)
 .s amt=amt_"^"_$g(retAspAmt)
 .s amt=amt_"^"_$g(phaRetAspAmt)
 .s amt=amt_"^"_$g(giftTrfAmt)
 .s amt=amt_"^"_$g(chgRecAmt)
 .s amt=amt_"^"_$g(chgRetAmt)
 .s amt=amt_"^"_$g(mRecAmt)
 .s amt=amt_"^"_$g(stktkAdjAmt)
 .s amt=amt_"^"_$g(manuXAmt)
 .s amt=amt_"^"_$g(manuMAmt)
 .s amt=amt_"^"_$g(phoRetAspAmt)
 .s amt=amt_"^"_$g(trfIAspAmt)
 .
 .s ^TMP("web","DHCST","DHCStkMonRepQuery","StkMonCatByLocSel",pid,sm,grpDesc,cat,n)=amt
  q n
}

/// 获取报表中主数据的输出
/// w ##class(web.DHCST.DHCStkMonRepQuery).GetMianInfo(1)
ClassMethod GetMianInfo(sm)
{
	 q:sm="" ""
	 s loc=$P(^DHCSM(sm),"^",1)
	 s locDescIO=$P(^CTLOC(loc),"^",2)
	 s hospId=$P(^CTLOC(loc),"^",22)
	 s hospDescIO=$P(^CT("HOSP",hospId),"^",2)
	 s User=$P(^DHCSM(sm),"^",5)
	 s UserDescIO=$P(^SSU("SSUSR",User),"^",2)
	 s CreateDate=$P(^DHCSM(sm),"^",6)
	 s CreateDateIO=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate)
	 s CreateTime=$P(^DHCSM(sm),"^",9)
	 s CreateTimeIO=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CreateTime)
	 s FrDate=$P(^DHCSM(sm),"^",3)
	 s FrDateIO=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(FrDate)
	 s FrTime=$P(^DHCSM(sm),"^",7)
	 s FrTimeIO=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(FrTime)
	 s ToDate=$P(^DHCSM(sm),"^",4)
	 s ToDateIO=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ToDate)
	 s ToTime=$P(^DHCSM(sm),"^",8)
	 s ToTimeIO=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ToTime)
	 s DataStr=locDescIO_"^"_hospDescIO_"^"_UserDescIO_"^"_CreateDateIO_"^"_CreateTimeIO_"^"_FrDateIO_"^"_FrTimeIO_"^"_ToDateIO_"^"_ToTimeIO
	 
	 q DataStr
}

}
