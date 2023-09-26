Import sqluser

/// Portal Chart 数据支持
Class web.DHCSTMHUI.Charts Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// -------------------------Charts-----------------------------------------
/// w ##class(web.DHCSTMHUI.Charts).GetScgChildNode("AllSCG","153^541")
ClassMethod GetScgChildNode(NodeId As %String, StrParam As %String, Type As %String = "M", ArrData = "", ArrDataFlag = "") As %String
{
	n (NodeId,StrParam,Type,ArrData,ArrDataFlag)
	s NodeType=$p(NodeId,"-",1)
	s NodeRowId=$p(NodeId,"-",2)
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	s xLocId=$p(StrParam,"^",3)
	s ScgSet=$p(StrParam,"^",4)
	s HospId=""
	s DataType=$p(StrParam,"^",5)
	s:Type="" Type=..sssCode()
	i ArrDataFlag'="Y" d
	.s ArrDataFlag=..GetRpAmt(LocId,HospId,.ArrData)
	s ScgStr=""
	s Param=LocId_"^"_UserId
	s TmpScgStr=##class(web.DHCSTMHUI.Util.StkGrp).GetAuthorOnlyScg(Param,Type)	;仅显示有权限的类组
	;若未授权,取所有类组
	s:TmpScgStr="" TmpScgStr=$$GetAllScgStr(Type)
	i xLocId'="" d
	.s xLocScgStr=##class(web.DHCSTMHUI.Util.StkGrp).GetAuthorOnlyScg(xLocId_"^",Type)
	.s:xLocScgStr="" xLocScgStr=$$GetAllScgStr(Type)
	.f i=1:1:$l(TmpScgStr,",") d
	..s TmpScg=$p(TmpScgStr,",",i)
	..i (","_xLocScgStr_",")[(","_TmpScg_",") d
	...i ScgStr="" s ScgStr=TmpScg
	...e  s ScgStr=ScgStr_","_TmpScg
	e  d
	.s ScgStr=TmpScgStr
	q:ScgStr="" "[]"
	;获取权限顶层
	s TopAuthorScgStr=""
	f i=1:1:$l(ScgStr,",") d
	.s Scg=$p(ScgStr,",",i)
	.s ParScg=$p($g(^DHCSCG(Scg)),"^",4)
	.i (ParScg="")||((","_ScgStr_",")'[(","_ParScg_",")) d
	..;上级类组非空,或不再该串内,为授权顶级类组
	..i TopAuthorScgStr="" s TopAuthorScgStr=Scg
	..e  s TopAuthorScgStr=TopAuthorScgStr_","_Scg
	q:TopAuthorScgStr="" "[]"
	
	s result = ##class(%Library.ResultSet).%New()
	i NodeType="AllSCG" d
	.s sqlStr="select 'SCG-'||scg_rowid as Id,scg_code as Code, scg_desc as Description From dhc_stkcatgroup where scg_type='"_Type_"' and %id in ("_TopAuthorScgStr_") order by scg_desc"
	e  i NodeType="SCG" d
	.s sqlStr="select 'SCG-'||scg_rowid as Id, scg_code as Code, scg_desc as Description From dhc_stkcatgroup where scg_catgrp_dr="_NodeRowId
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s ResultStr=""
	While(result.Next())
	{
		s Id=result.Data("Id")
		s Token=$p(Id,"-",1)
		s RowId=+$p(Id,"-",2)
		continue:RowId=0
		continue:(LocId'="")&&(Token="SCG")&&((","_ScgStr_",")'[(","_RowId_","))
		;类组集合过滤
		s SCGSet=$p($G(^DHCSCG(RowId)),"^",5)
		continue:(Token="SCG")&&(ScgSet'="")&&((SCGSet="") || (ScgSet'[SCGSet))
		
		s Desc=result.Data("Description")
		s checked="''"
		s Description=Desc
		s ChildScgStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).ChildScgStr(RowId)
		s SumInfo=..SumChildScg(.ArrData,ChildScgStr)
		i DataType="Qty"	d
		.s value=$p(SumInfo,"^",2)
		e  d
		.s value=$p(SumInfo,"^",1)
		s value=##class(web.DHCSTMHUI.Common.JsonObj).FormatColValue(value)
		//拼接Json
		s:(ResultStr'="") ResultStr=ResultStr_","
		s ResultStr=ResultStr_"{"
		//s ResultStr=ResultStr_"""value"":"_""_value_",""name"":"""_Desc_""""
		s ChildStr=..GetScgChildNode(Id,Param,Type,.ArrData,"Y")
		i ChildStr'="[]"  d
		.s ResultStr=ResultStr_"""name"":"""_Desc_""""
		.s ResultStr=ResultStr_",""children"":"
		.s ResultStr=ResultStr_ChildStr
		e  d
		.s ResultStr=ResultStr_"""value"":"_""_value_",""name"":"""_Desc_""""

		s ResultStr=ResultStr_"}"
	}
	s ResultStr="["_ResultStr_"]"
	q ResultStr

GetAllScgStr(Type)
	n (Type)
	s AllScgStr=""
	s ScgId=0
	f  s ScgId=$o(^DHCSCG(ScgId)) q:ScgId=""  d
	.q:(+ScgId'>0)||'$d(^DHCSCG(ScgId))
	.s ScgType=$p($G(^DHCSCG(ScgId)),"^",3)
	.q:ScgType'=Type
	.q:('$d(^DHCSCG(ScgId,"RE"))&&('$d(^DHCSCG(0,"Parent",ScgId))))		;未关联库存分类的,过滤
	.i AllScgStr="" d
	..s AllScgStr=ScgId
	.e  d
	..s AllScgStr=AllScgStr_","_ScgId
	q AllScgStr
}

ClassMethod SumChildScg(ArrData, ScgStr)
{
	n (ArrData,ScgStr)
	s sumamt=0,sumqty=0
	f i=1:1:$l(ScgStr,",") d
	.s Scg=$p(ScgStr,",",i)
	.q:'$d(ArrData(Scg))
	.s sumInfo=ArrData(Scg)
 	.s amt=$p(sumInfo,"^",1)
 	.s qty=$p(sumInfo,"^",2)
	.s sumamt=sumamt+amt
	.s sumqty=sumqty+qty
	q sumamt_"^"_sumqty
}

/// w ##class(web.DHCSTMHUI.Charts).GetRpAmt(153,2)
ClassMethod GetRpAmt(loc, hospid, ArrData)
{
	n (loc,hospid,ArrData)
	s ArrData="",ArrDataFlag="Y"
	s inci=""
 	f  s inci=$o(^INCI("IL_LOC",loc,inci)) q:inci=""  d
 	.s ch="",ch=$o(^INCI("IL_LOC",loc,inci,ch)) 
 	.s incil=inci_"||"_ch
 	.s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 	.s grptype=$p(stkgrpinfo,"^",3)
 	.q:grptype'=..sssCode()
 	.s scg=$p(stkgrpinfo,"^",5)
 	.s suminfo=..GetIncilRpAmt(incil,+$h,hospid)
 	.s amt=$p(suminfo,"^",1)
 	.s qty=$p(suminfo,"^",2)
 	.i $d(ArrData(scg)) d
 	..s ArrData(scg)=($p(ArrData(scg),"^",1)+amt)_"^"_($p(ArrData(scg),"^",2)+qty)
 	.e  d
 	..s ArrData(scg)=suminfo
 	q ArrDataFlag
}

/// 获取批次进价金额
ClassMethod GetIncilRpAmt(incil, dtend, hospid) As %String
{
	n (incil,dtend,hospid)
	s inci=$p(incil,"||",1)
	s il=$p(incil,"||",2)
	
	s sumamt=0,sumqty=0
	s lb=0
	f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
	.s inclb=incil_"||"_lb
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,dtend)
	.s buom=$p(^INCI(inci,1),"^",10)
	.s rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buom,hospid)
	.s rpamt=rp*qty
	.s sumamt=sumamt+rpamt
	.s sumqty=sumqty+qty
	s sumamt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(sumamt,hospid)
	q sumamt_"^"_sumqty
}

}
