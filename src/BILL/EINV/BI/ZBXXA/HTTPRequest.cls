Class BILL.EINV.BI.ZBXXA.HTTPRequest Extends %RegisteredObject
{

/// http服务->返回结果
/// ServiceCode 中博信息有限公司服务接口
/// ReqJsonStr 主报文消息
/// InvociePam As BILL.EINV.DTO.COM.InvocieInputPam
/// ResOutput 接收返回
/// w ##class(BILL.EINV.BI.ZBXXA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ServiceCode As %String, ReqJsonStr As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef ResOutput As %String) As %String
{
	s RtnFlg="-1"
	set $ZT="UploadRequestET"	
	s ObjUPConfig=InvociePam.ObjUPConfig
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"							;编码字符集
	;set ServerPath=ObjUPConfig.IUCSerPath                			;路径
	set ServerPath=ServiceCode               		            	;路径+服务名称
	               		            	
	;调用平台接口进行GZIP压缩
	Set HttpRequest.ContentType="application/json"
	Do HttpRequest.EntityBody.Write(ReqJsonStr)
	Do HttpRequest.Post(ServerPath)
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	
    ;Set ResOutput=DataStream.ReadLine()
    If DataStream'="" {
	    set DataStream=DataStream.Read(DataStream.Size)
		set OutputObj=##class(BILL.EINV.DTO.ZBXXA.EInvComDataRes).%New()
		do ##class(ext.util.JsonObject).JSONStreamToObject(DataStream,.OutputObj,"")
	    if (OutputObj.ifResult="0"){
		    s ResOutput=OutputObj.ifResultInfo
		    s RtnFlg="0"
		}else{
			s InvociePam.ErrMsgInfo=OutputObj.ifError   ;错误信息
			s RtnFlg="-1"
			}
    }else{
	    s RtnFlg="-1"
	    s InvociePam.ErrMsgInfo="开票失败！错误信息"_DataStream.Read()_",状态码为："_StatusCode
    }
    Quit RtnFlg
UploadRequestET
	set $ZT=""
	set RtnFlg="-99999"
	quit RtnFlg
}

}
