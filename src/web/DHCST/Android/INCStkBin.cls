Import sqluser

/// Creator: yunhaibao
/// CreateDate: 2016-09-27
/// Descript:PDA货位管理
Class web.DHCST.Android.INCStkBin Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20150818
/// description:仅供pda关联货位用
/// input:批次id^货位码,为防止以后变动为批次关联,单独建方法
/// output:0成功;"-1,该货位已不存在"失败;可以$c(1)为节点拼串 
/// w ##class(web.DHCST.INCStkBin).LinkInclbStkBin("29488||17||1^1302P28")
ClassMethod LinkInclbStkBin(ListDetail)
{
	n (ListDetail)
	//s ^yunhaibao("LinkInclbStkBin")=ListDetail
	s $ZT="Error^DHCSTERROR"  
	q:ListDetail="" "-1,数据传入有误,为空!"
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListDetail,rowDelim)
    s locstkbinret=0
    f i=1:1:Len q:locstkbinret'=0  d
    .s Detail=$p(ListDetail,rowDelim,i)
	.s inclb=$p(Detail,"^",1)
	.s incilrowid=$p(inclb,"||",1,2)
	.s stkbincode=$p(Detail,"^",2)
	.q:inclb="" 
	.q:stkbincode=""
	.i '$d(^INC("SB",0,"Code",$$ALPHAUP^SSUTIL4(stkbincode))) s locstkbinret="-2,不存在该货位!" q
	.s stkbin=$o(^INC("SB",0,"Code",$$ALPHAUP^SSUTIL4(stkbincode),""),-1)
	.q:stkbin=""
	.//插入数据
	.s locstkbinret=##class(web.DHCST.INCStkBin).SaveLocItmBin(incilrowid_"^"_stkbin)
	.i locstkbinret[":" s locstkbinret=$tr(locstkbinret,":",",")
	q locstkbinret
}

}
