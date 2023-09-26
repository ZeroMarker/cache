Class BILL.EINV.BI.JSB.HTTPRequest Extends %RegisteredObject
{

/// guoyunlong
/// 20200524
/// 江苏省南通中医电子发票HTTP服务接口
/// http服务->返回结果
/// ServiceCode 服务接口
/// ReqJsonStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ReqJsonStr As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	set $ZT="UploadRequestET"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"							;编码字符集
	set ServerPath=ObjUPConfig.IUCSerPath							;路径
	set HttpRequest.ContentType="application/json"
	do HttpRequest.EntityBody.Write(ReqJsonStr)
	do HttpRequest.Post(ServerPath)
	set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	set StatusCode=HttpRequest.HttpResponse.StatusCode
 	set DataStream=HttpRequest.HttpResponse.Data
    Set ResOutput=DataStream.ReadLine()
    Quit ResOutput
UploadRequestET
	set $ZT=""
	set OutputObj=##class(BILL.EINV.DTO.JSA.ResponseComm).%New()
	set Stream=##class(%GlobalCharacterStream).%New()
	set OutputObj.result="-99999"
	set OutputObj.information="程序处理错误:"_$ZERROR
	do ##class(ext.util.JsonObject).ObjectToJSONStream(OutputObj,.Stream)
	set ResOutput=Stream.Read()
	quit ResOutput
}

}
