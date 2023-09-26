Class web.DHCST.SCI.HisInfoServiceInterfacePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// 医院调价同步平台的订单
Method adjRp(usename As %String, password As %String, incCode As %String, rp As %xsd.float) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("adjRp").Invoke($this,"",.usename,.password,.incCode,.rp)
}

/// 高值条码完成，确认完成信息,或者取消flag=Y 入库完成 flag=N 取消入库完成
Method cmpHvInv(usename As %String, password As %String, label As %String, vendorCode As %String, flag As %String) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("cmpHvInv").Invoke($this,"",.usename,.password,.label,.vendorCode,.flag)
}

/// 确认入库成功
Method cmpInGdRec(usename As %String, password As %String, ingdrecId As %Integer) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("cmpInGdRec").Invoke($this,"",.usename,.password,.ingdrecId)
}

/// 库房扫码确认完成 flag=T 入库完成 flag=Y 取消入库完成
Method cmpOrder(usename As %String, password As %String, ordsubs As web.DHCST.SCI.ns1.stringArray, flag As %String) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("cmpOrder").Invoke($this,"",.usename,.password,.ordsubs,.flag)
}

Method cmpRec(hisCmpRecWeb As web.DHCST.SCI.tns.hisCmpRecWeb) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("cmpRec").Invoke($this,"",.hisCmpRecWeb)
}

/// 下载图片
Method downLoadPic(type As %String, path As %String) As web.DHCST.SCI.tns.fileWrapper(XMLNAME="fileWrapper") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("downLoadPic").Invoke($this,"",.type,.path)
}

Method getHisOrder(hisOrderWebVo As web.DHCST.SCI.tns.hisOrderWebVo) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHisOrder").Invoke($this,"",.hisOrderWebVo)
}

Method getHopInc(hisIncWeb As web.DHCST.SCI.tns.hisIncWeb) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopInc").Invoke($this,"",.hisIncWeb)
}

Method getHopLoc(hisLocWeb As web.DHCST.SCI.tns.hisLocWeb) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopLoc").Invoke($this,"",.hisLocWeb)
}

Method getHopLocIncQty(hisIncLocQtyWeb As web.DHCST.SCI.tns.hisIncLocQtyWeb) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopLocIncQty").Invoke($this,"",.hisIncLocQtyWeb)
}

/// 同步医院订单
Method getHopOrder(hisOrderWeb As web.DHCST.SCI.tns.hisOrderWeb) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopOrder").Invoke($this,"",.hisOrderWeb)
}

/// 同步医院供应商
Method getHopVendor(hisVendorWeb As web.DHCST.SCI.tns.hisVendorWeb) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHopVendor").Invoke($this,"",.hisVendorWeb)
}

/// 给his返回高值发票号信息
Method getHvInvNo(usename As %String, password As %String, label As %String, vendorCode As %String) As web.DHCST.SCI.tns.hisHvInvWeb(XMLNAME="hisHvInvWeb") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHvInvNo").Invoke($this,"",.usename,.password,.label,.vendorCode)
}

/// his传送高值医嘱条码信息
Method getHvLabel(usename As %String, password As %String, hisHvLabelWeb As web.DHCST.SCI.tns.hisHvLabelWeb) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHvLabel").Invoke($this,"",.usename,.password,.hisHvLabelWeb)
}

/// 医院获取供应商商品上传图片名称
Method getIncPicName(usename As %String, password As %String, vendorCode As %String, incCode As %String) As web.DHCST.SCI.ns1.stringArray(XMLNAME="name") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, SoapTypeNameSpace = "http://jaxb.dev.java.net/array", WebMethod ]
{
 Quit ..WebMethod("getIncPicName").Invoke($this,"",.usename,.password,.vendorCode,.incCode)
}

/// 获取发票号,通过微信入库子表id
Method getInvByRec(usename As %String, password As %String, ingdrecId As %Integer) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getInvByRec").Invoke($this,"",.usename,.password,.ingdrecId)
}

/// 获取发票信息,通过发货子表id T_ORD_ORDETAILSUB
Method getInvBySubId(usename As %String, password As %String, subId As %String) As web.DHCST.SCI.tns.hisInvInfoItmWeb(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getInvBySubId").Invoke($this,"",.usename,.password,.subId)
}

/// 根据订单号,查入库明细,库房电脑扫码入库返回的信息
Method getOrderDetail(orderno As %String) As web.DHCST.SCI.tns.hisInGdRec(XMLNAME="hisInGdRec") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getOrderDetail").Invoke($this,"",.orderno)
}

Method getRecItmByInv(invNo As %String, hopName As %String, venName As %String) As web.DHCST.SCI.tns.hisInvInfoWeb(XMLNAME="hisInvInfoWeb") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getRecItmByInv").Invoke($this,"",.invNo,.hopName,.venName)
}

/// 供应商品商图片信息
Method getVenIncPic(usename As %String, password As %String, hopVenIncCode As %String) As web.DHCST.SCI.tns.hisPicWebArray(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getVenIncPic").Invoke($this,"",.usename,.password,.hopVenIncCode)
}

/// 供应商品商资质信息
Method getVenIncQualify(usename As %String, password As %String, hopVenIncCode As %String) As web.DHCST.SCI.tns.venQualifyWeb(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getVenIncQualify").Invoke($this,"",.usename,.password,.hopVenIncCode)
}

/// 供应商资质信息
Method getVenQualify(usename As %String, password As %String, hopVenCodes As web.DHCST.SCI.ns1.stringArray) As web.DHCST.SCI.tns.venQualifyWeb(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getVenQualify").Invoke($this,"",.usename,.password,.hopVenCodes)
}

/// 查询入库单信息
Method listInGdRec(usename As %String, password As %String) As web.DHCST.SCI.tns.hisInGdRec(XMLNAME="hisInGdRec") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("listInGdRec").Invoke($this,"",.usename,.password)
}

/// 通过微信入库表 更新平台发票号
Method syncInvByRec(usename As %String, password As %String, ingdrecId As %Integer, invno As %String) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("syncInvByRec").Invoke($this,"",.usename,.password,.ingdrecId,.invno)
}

/// 通过发货子表id T_ORD_ORDETAILSUB更新平台发票号
Method syncInvBySub(usename As %String, password As %String, subId As %String, invno As %String) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("syncInvBySub").Invoke($this,"",.usename,.password,.subId,.invno)
}

/// 高值条码同步入库单号
Method updHvRecNo(usename As %String, password As %String, label As %String, vendorCode As %String, no As %String) As web.DHCST.SCI.tns.operateResult(XMLNAME="operateResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("updHvRecNo").Invoke($this,"",.usename,.password,.label,.vendorCode,.no)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://hospscm.jiankangle.com/sci/ws/hisInfoService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "HisInfoServiceInterfaceService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// Non-default use of element/type attribute in parts.
Parameter XMLELEMENT = 0;

}
