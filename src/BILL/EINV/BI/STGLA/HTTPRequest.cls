/// 赛通港联电子票据服务接口统一调用方法
Class BILL.EINV.BI.STGLA.HTTPRequest Extends %RegisteredObject
{

/// 2020-10-15
/// 赛通港联票据 接口调用
/// http服务->返回结果
/// ResOutput 接收返回
/// ReqXmlStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(Message As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef OutputObj As BILL.EINV.DTO.STGLA.EInvResultRes) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	s RtnFlg="-1"
	set $ZT="UploadRequestET"
	
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=InvociePam.ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=InvociePam.ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=InvociePam.ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"							;编码字符集
	set ServerPath=InvociePam.ObjUPConfig.IUCSerPath                			;路径
	Set HttpRequest.ContentType="application/json"
	
	//进行URLEncoder.encode转码
	s Sign=##class(ext.util.String).EscapeURL(Message,"UTF8")
	
	//do HttpRequest.EntityBody.Write("SIGN="_Message)
	do HttpRequest.SetParam("SIGN",Sign)
	Do HttpRequest.Post(ServerPath)
	set DataStream=##class(%GlobalCharacterStream).%New()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
    ;Set ResOutput=DataStream.ReadLine()
    ;set ResOutput=##class(ext.util.String).EvalJSONNew($zcvt(ResOutput,"I","GB18030"))
    
    If DataStream'="" {
	    s OutputObj=##class(BILL.EINV.DTO.STGLA.EInvResultRes).%New()
	    set DataStream=DataStream.Read(DataStream.Size)
	    set Stream=##class(%GlobalCharacterStream).%New()
	    do Stream.Write(DataStream)
	    do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
	    set ResOutput=OutputObj.dataobj
	    if (OutputObj.code="0"){
	    	s RtnFlg="0"
	    }
    }else{
	    s InvociePam.ErrMsgInfo="请求电子票据服务未响应"
    }
    
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("响应参数-->"_ResOutput)
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest结束.")
    Quit RtnFlg
    
UploadRequestET
	set $ZT=""
	set RtnFlg="-9999"
	set InvociePam.ErrMsgInfo="请求电子票据服务发生异常:"_$ZERROR
	quit RtnFlg
}

}
