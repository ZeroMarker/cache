/// 同步天成电子票据服务接口统一调用方法
Class BILL.EINV.BI.TBTCA.HTTPRequest Extends %RegisteredObject
{

/// 2019-12-12
/// 百望电子票据 接口调用
/// http服务->返回结果
/// ResOutput 接收返回
/// ReqXmlStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(Message As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ResOutput As %String) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	set $ZT="UploadRequestET"
	
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"							;编码字符集
	set ServerPath=ObjUPConfig.IUCSerPath                			;路径
	Set HttpRequest.ContentType="application/xml"
	;b ;Message
	Do HttpRequest.EntityBody.Write(Message)
	Do HttpRequest.Post(ServerPath)
	
	set DataStream=##class(%GlobalCharacterStream).%New()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
    ;Set ResOutput=DataStream.ReadLine()
    Set ResOutput=DataStream.Read(DataStream.Size)
    b ;;http--ResOutput
   
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("响应参数-->"_ResOutput)
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest结束.")
    Quit "0"
    
UploadRequestET
	set $ZT=""
	set RtnFlg="-9999"
	set ErrMsg="程序处理错误:"_$ZERROR
	quit RtnFlg
}

}
