Class BILL.EINV.BI.AXNHTA.WebServiceRequest Extends %RegisteredObject
{

/// ans
/// 2020-06-19
/// 上海爱心诺航天有限公司
/// ServiceCode 开票服务接口服务接口
/// HISUniqueID HIS端唯一流水
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// w ##class(BILL.EINV.BI.AXNHTA.WebServiceRequest).InvoiceBSARequest("testServerConnect","HYD18071900012","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.AXNHTA.WebServiceRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	set $ZT="UploadRequestET"
	set webServiceObj=""
	set Data=webServiceObj
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.AXNHTA.WebServiceRequest).InvoiceRequest结束.")
	quit Data
UploadRequestET
	s $ZT=""
	set ETObj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceRes).%New()
	Set ETObj.result=""
	Set ETObj.message=""
	set Data=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(ETObj,.Data)
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	
	quit Data
}

}
