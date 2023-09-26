/// HIS与前置机交互使用,存于前置机,提供给HIS访问
/// web.DHCST.SCI.DHCSTSCIService
Class web.DHCST.SCI.DHCSTSCIService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCSTSCIService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/dhcstservice";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

Parameter TimeOut = 40;

/// 同步科室信息
Method getHopLoc(hisLocWebObj As web.DHCST.SCI.tns.hisLocWeb) As web.DHCST.SCI.tns.operateResult [ WebMethod ]
{
    s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
    s operateResultObj=HisInfoServiceObj.getHopLoc(hisLocWebObj)
    q operateResultObj
}

/// 同步药品字典
Method getHopInc(hisIncWeb As web.DHCST.SCI.tns.hisIncWeb) As web.DHCST.SCI.tns.operateResult [ WebMethod ]
{
	s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
    s operateResultObj=HisInfoServiceObj.getHopInc(hisIncWeb)
    q operateResultObj
}

/// 同步药库供应商
Method getHopVendor(hisVendorWeb As web.DHCST.SCI.tns.hisVendorWeb) As web.DHCST.SCI.tns.operateResult [ WebMethod ]
{
	s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
    s operateResultObj=HisInfoServiceObj.getHopVendor(hisVendorWeb)
    q operateResultObj
}

/// 同步科室库存上下限
Method getHopLocIncQty(hisIncLocQtyWeb As web.DHCST.SCI.tns.hisIncLocQtyWeb) As web.DHCST.SCI.tns.operateResult [ WebMethod ]
{
	s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
	s HisInfoServiceObj.Timeout=..#TimeOut
    s operateResultObj=HisInfoServiceObj.getHopLocIncQty(hisIncLocQtyWeb)
    q operateResultObj
}

/// 发送订单到SCI
Method getHopOrder(hisOrderWeb As web.DHCST.SCI.tns.hisOrderWeb) As web.DHCST.SCI.tns.operateResult [ WebMethod ]
{
     s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
     //s HisInfoServiceObj.OpenTimeout=..#TimeOut
 	 s operateResultObj=HisInfoServiceObj.getHopOrder(hisOrderWeb)
	 q operateResultObj
}

/// 更新订单使用标志(ordsubs发货子表的ID)
Method cmpOrder(usename As %String, password As %String, ordsubs As web.DHCST.SCI.ns1.stringArray, flag As %String) As web.DHCST.SCI.tns.operateResult [ WebMethod ]
{
    s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
    s operateResultObj=HisInfoServiceObj.cmpOrder(usename,password,ordsubs,flag)    
    q operateResultObj
}

/// 通过随行单(SCI订单号) 获取SCI订单相关信息
Method getOrderDetail(orderno As %String) As web.DHCST.SCI.tns.hisInGdRec [ WebMethod ]
{
   	s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
	s HisInGdRec=HisInfoServiceObj.getOrderDetail(orderno)
    q HisInGdRec
}

/// 获取SCI微信入库相关信息
Method listInGdRec(usename As %String, password As %String) As web.DHCST.SCI.tns.hisInGdRec(XMLNAME="hisInGdRec") [ WebMethod ]
{
   	s HisInfoServiceObj=##class(web.DHCSTST.HisInfoServiceInterfacePort).%New()
	s HisInGdRec=HisInfoServiceObj.listInGdRec(usename,password)
    q HisInGdRec
}

/// 更新SCI入库明细状态
Method cmpInGdRec(usename As %String, password As %String, ingdrecId As %Integer) As web.DHCST.SCI.tns.operateResult [ WebMethod ]
{
    s HisInfoServiceObj=##class(web.DHCST.SCI.HisInfoServiceInterfacePort).%New()
    s operateResultObj=HisInfoServiceObj.cmpInGdRec(usename,password,ingdrecId)    
    q operateResultObj
}

}
