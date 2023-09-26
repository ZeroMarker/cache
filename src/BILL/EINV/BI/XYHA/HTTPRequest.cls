/// 河南郑州新益华电子票据服务接口统一调用方法
Class BILL.EINV.BI.XYHA.HTTPRequest Extends %RegisteredObject
{

/// 徐保保
/// 2020-11-08
/// 博思发票HTTP服务接口
/// 加密签名->http服务->返回结果
/// ServiceCode 新益华服务接口
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// w ##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest()
ClassMethod InvoiceRequest(ServiceCode, Message, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef OutputObj As BILL.EINV.DTO.XYHA.InvoiceRes) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	set RtnFlg="-1"
	set $ZT="UploadRequestET"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=InvociePam.ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=InvociePam.ObjUPConfig.IUCServer				;票据服务器地址
	set HttpRequest.Port=InvociePam.ObjUPConfig.IUCPort					;端口号
	set HttpRequest.ContentCharset="UTF-8"						;编码字符集
	set ServerPath=InvociePam.ObjUPConfig.IUCSerPath						;路径
	s HttpRequest.ContentType="application/json"
	
	d HttpRequest.EntityBody.Write(Message)
	d HttpRequest.Post(ServerPath)
   
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	If DataStream'="" {
	    set OutputObj=##class(BILL.EINV.DTO.XYHA.InvoiceRes).%New()
	    ;set DataStream=DataStream.Read(DataStream.Size)
	    set DataStream=DataStream.ReadLine()
   		set DataStream=##class(ext.util.String).EvalJSONNew($zcvt(DataStream,"I","UTF8"))
   		set DataStream=$replace(DataStream,"\","")
   		b ;DataStream
	    set Stream=##class(%GlobalCharacterStream).%New()
	    do Stream.Write(DataStream)
	    do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
	    ;set ResOutput=OutputObj.data
	    if (OutputObj.code="200"){
	    	s RtnFlg="0"
	    }
	    ;b ;00
    }else{
	    s InvociePam.ErrMsgInfo="请求电子票据服务未响应"
    }
    
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("响应参数-->"_DataStream)
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest结束.")
    Quit RtnFlg
    
UploadRequestET
	set $ZT=""
	b ;zt
	set RtnFlg="-9999"
	set InvociePam.ErrMsgInfo="请求电子票据服务发生异常:"_$ZERROR
	do ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	quit RtnFlg
}

}
