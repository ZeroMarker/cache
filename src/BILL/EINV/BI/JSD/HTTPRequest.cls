Class BILL.EINV.BI.JSD.HTTPRequest Extends %RegisteredObject
{

/// guoyunlong
/// 20200917
/// 江苏宿迁钟吾电子发票HTTP服务接口（江苏百旺）
/// http服务->返回结果
/// ServiceCode 服务接口
/// ReqJsonStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.ZJA.HTTPRequest).InvoiceRequest()
ClassMethod InvoiceRequest(ServiceCode As %String, ReqJsonStr As %String, ResOutput) As %String
{
    ////走平台接口  -平台提供接口，改造
    set $ZT="UploadRequestET"
    s soap=##class(web.DHCENS.SOAP.PUB0009Soap).%New()
    s result=soap.HIPMessageServer(ServiceCode,ReqJsonStr)
    b ;result
    ///一下是我们自己调用第三方接口参数数据，走平台需改造
	If result'="" {
	    do ##class(ext.util.JsonObject).JSONStreamToObject(result,.ResOutput,"")
	    if (ResOutput.resultCode="000000") d
	    .s RtnFlg="0"
    }else{
	    s ResOutput.resultMsg="-1"
	    s ResOutput.msg="服务无响应"
    }
    
    Quit result
UploadRequestET
	set $ZT=""
	quit -1
}

}
