Class web.DHCENS.STBLL.LIS.METHOD.SendOrderInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.SendOrderInfo).SendPatOrder("147||1^147||2^147||3^147||4")
/// 同步发送检验医嘱到检验系统 
ClassMethod SendPatOrder(Input As %String) As %String
{
	s $zt="Erro"
	s stream=##class(%GlobalCharacterStream).%New()
	s stream=##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).SendLisInfoByOrdRowID(Input)
	s soap=##class(web.DHCENS.STBLL.LIS.SOAP.PUB0008Soap).%New()
	s soap.Timeout="3"
	s tSC=soap.SendLISOrder("T0043",stream)
	s return=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	b ;yy
	q return
Erro
    q "-1^"_$ze
}

}
