Import sqluser

/// 此类用来完成符合医院规则的库存项目代码自动生成
/// 
Class web.DHCSTMHUI.DrugInfoMaintainCode Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTDRUGMAINTAINM";

/// 获取新的物资项目代码( 适用医院：太和妇产)
/// Arguments：
///    incsc -库存分类rowid
/// Return：
///   代码
/// 
ClassMethod NewCode1(incsc) As %String
{
	n (incsc)
	q:incsc="" ""
	s ret=""
	s cnt=0
	s incscCode=$P(^INC("SC",incsc),"^",1)
	s ret=incscCode
	&sql(select scgr_scg_parref into :scg from dhc_stkcatgrprelations where scgr_stkcat_dr=:incsc)
	s par=""
	i scg'="" d
	.s par=scg
	.s cnt=cnt+1
	.f  s scg=$p($g(^DHCSCG(scg)),"^",4) q:(scg="")  d
    ..s par=scg
    ..s scgCode=$p(^DHCSCG(scg),"^",1)
    ..s cnt=cnt+1
    s prefix=ret
    s sxNo=$i(^dhccSTKCATGRPSXNO(prefix))
    s sxNoLen=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"AutoCodeLengthOfSerialNo")
    i cnt>1 s sxNoLen=sxNoLen-2
    s sxNo=$tr($j(sxNo,sxNoLen)," ","0")
   s nextInciCode=prefix_sxNo
   q nextInciCode
}

}
