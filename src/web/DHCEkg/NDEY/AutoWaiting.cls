/// web.DHCEkg.NDEY.AutoWaiting
Class web.DHCEkg.NDEY.AutoWaiting Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "AutoWaiting";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：      yangyali
/// CreatDate：    2018-11-1
/// Description:   把医嘱加入到心电候诊队列
/// Table：        tblPatient, tblRequest, tblWaitingArray
/// Input：        医嘱号
/// Output：       候诊信息
/// Return：       
/// Others：
/// w ##class(web.DHCEkg.NDEY.AutoWaiting).AddWaiting("")
ClassMethod AddWaiting(ordId As %String) As %String [ WebMethod ]
{
	q:(ordId="") "-1,医嘱号不能为空"
	s ^tmpDHCEKG("AddWaiting",ordId,$zdt($h,3))=""
	s ordInfo=##class(web.DHCEkgService).getDHCEKGOrderInfoBylistOrderItem(ordId)
	q:(ordInfo="") "-2,未查询到医嘱信息"
	s OrderId=$p(ordId,"||",1)
	s OrderSub=$p(ordId,"||",2)
	s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	q:(ordInfo="") "-3,未查询到接收科室信息"
	
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()		
	s rtn=##class(Interface.NDEY.AutoWait).AddWaiting(ordInfo,recLocId)
	zn CurrSpace
	s ^tmpDHCEKG("AddWaiting",ordId,$zdt($h,3),"rtn")=rtn
	q rtn
}

}
