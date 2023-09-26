Class web.DHCST.SCI.DHCSTSCIServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
/// 上线需修改为前置机地址
Parameter LOCATION = "http://127.0.0.1/dthealth/web/web.DHCST.SCI.DHCSTSCIService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn/dhcstservice";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DHCSTSCIService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// 同步科室
Method getHopLoc(hisLocWebObj As web.DHCST.SCI.tns.hisLocWeb) As web.DHCST.SCI.tns.operateResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopLoc").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.getHopLoc",.hisLocWebObj)
}

/// 同步药品字典
Method getHopInc(hisIncWeb As web.DHCST.SCI.tns.hisIncWeb) As web.DHCST.SCI.tns.operateResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopInc").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.getHopInc",.hisIncWeb)
}

/// 同步药品供应商
Method getHopVendor(hisVendorWeb As web.DHCST.SCI.tns.hisVendorWeb) As web.DHCST.SCI.tns.operateResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopVendor").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.getHopVendor",.hisVendorWeb)
}

/// 同步库存上下限
Method getHopLocIncQty(hisIncLocQtyWeb As web.DHCST.SCI.tns.hisIncLocQtyWeb) As web.DHCST.SCI.tns.operateResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopLocIncQty").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.getHopLocIncQty",.hisIncLocQtyWeb)
}

/// 发送订单到SCI
Method getHopOrder(hisOrderWeb As web.DHCST.SCI.tns.hisOrderWeb) As web.DHCST.SCI.tns.operateResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopOrder").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.getHopOrder",.hisOrderWeb)
}

/// 更新订单使用标志(ordsubs发货子表的ID)
Method cmpOrder(usename As %String, password As %String, ordsubs As web.DHCST.SCI.ns1.stringArray, flag As %String) As web.DHCST.SCI.tns.operateResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("cmpOrder").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.cmpOrder",.usename,.password,.ordsubs,.flag)
}

/// 通过随行单(SCI订单号) 获取SCI订单相关信息
Method getOrderDetail(orderno As %String) As web.DHCST.SCI.tns.hisInGdRec [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getOrderDetail").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.getOrderDetail",.orderno)
}

/// 获取微信入库信息
Method listInGdRec(usename As %String, password As %String) As web.DHCST.SCI.tns.hisInGdRec(XMLNAME="hisInGdRec") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("listInGdRec").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.listInGdRec",.usename,.password)
}

/// 更新SCI入库状态
Method cmpInGdRec(usename As %String, password As %String, ingdrecId As %Integer) As web.DHCST.SCI.tns.operateResult [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("cmpInGdRec").Invoke($this,"http://www.dhcc.com.cn/dhcstservice/web.DHCST.SCI.DHCSTSCIService.cmpInGdRec",.usename,.password,.ingdrecId)
}

}
