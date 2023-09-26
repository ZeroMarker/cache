/// web.DHCEkg.NDEY.EmrPaymentTip
Class web.DHCEkg.NDEY.EmrPaymentTip Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "EmrPaymentTip";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：      yangyali
/// CreatDate：    2019-12-18
/// Description:   保存急诊病人交费提示信息
/// Table：        dbo.tblPayReminder
/// Input：        医嘱信息
/// Output：       保存结果
/// Return：       
/// Others：
/// w ##class(web.DHCEkg.NDEY.EmrPaymentTip).EmrPay("333||23^3||262")
ClassMethod EmrPay(ordId As %String) As %String [ WebMethod ]
{
	q:(ordId="") "失败^医嘱号不能为空"
	s rtn=""
	;s ^tmpDHCEKG("EmrPay",ordId,$zdt($h,3))=""
	
	s tmpordId=ordId
	f i=1:1:$l(ordId,"^") d
	.s ordId=$p(tmpordId,"^",i)
	.q:ordId=""
	.q:ordId'["||"
	.s tmpOrd=$g(^OEORD($p(ordId,"||",1),"I",$p(ordId,"||",2),3))
	.q:(tmpOrd="")
	.s ordInfo=##class(web.DHCEkgService).getDHCEKGOrderInfoBylistOrderItem(ordId)
	.;b ;ordInfo
	.q:(ordInfo="") //"失败^未查询到医嘱号相关的医嘱信息"
	.s OrderId=$p(ordId,"||",1)
	.s paadmdr=$p(^OEORD(OrderId),"^",1)
	.s patienttype=$p($g(^PAADM(paadmdr)),"^",2) ;病人类型
	.q:(patienttype'="E") //只取急诊的病人
	.s OrderSub=$p(ordId,"||",2)
	.s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	.q:(ordInfo="") //"失败^未查询到医嘱接收科室信息"
	
	.new $namespace
	.s CurrSpace=$ZNSPACE
	.d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	.;zn "dhc-ekg-ndey"		
	.s rtn=##class(Interface.NDEY.EmrPaymentTip).EmrPay(ordInfo,recLocId)
	.zn CurrSpace
	.;s ^tmpDHCEKG("EmrPay",ordId,$zdt($h,3),"rtn")=rtn
	q rtn
}

}
