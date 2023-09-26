/// 富深电子票据服务接口统一调用方法
Class BILL.EINV.BI.FSA.HTTPRequest Extends %RegisteredObject
{

/// http服务->返回结果
/// ServiceCode 富深服务接口
/// ReqJsonStr 主报文消息
/// InvociePam As BILL.EINV.DTO.COM.InvocieInputPam
/// ResOutput 接收返回
/// w ##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ServiceCode As %String, ReqJsonStr As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef ResOutput As BILL.EINV.DTO.FSA.EInvComRes) As %String
{
	s RtnFlg="-1"
	set $ZT="UploadRequestET"
	i $isobject(ResOutput)=0 d
	.s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRes).%New()
	
	s ObjUPConfig=InvociePam.ObjUPConfig
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"							;编码字符集
	;set ServerPath=ObjUPConfig.IUCSerPath                			;路径
	set ServerPath=ServiceCode 
	               		            	;路径+服务名称
	Set HttpRequest.ContentType="application/json"
	Do HttpRequest.EntityBody.Write(ReqJsonStr)
	Do HttpRequest.Post(ServerPath)
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	
    ;Set ResOutput=DataStream.ReadLine()
    If DataStream'="" {
	    set DataStream=DataStream.Read(DataStream.Size)
	    set Stream=##class(%GlobalCharacterStream).%New()
	    do Stream.Write(DataStream)
	    do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResOutput,"")
	    if (ResOutput.code="1") d
	    .s RtnFlg="0"
    }else{
	    s ResOutput.code="-1"
	    s ResOutput.msg="服务无响应"
    }
    
    Quit RtnFlg
    
UploadRequestET
	set $ZT=""
	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRes).%New()
	set RtnFlg="-99999"
	set ErrMsg="程序处理错误:"_$ZERROR
	s ResOutput.code=RtnFlg
	s ResOutput.msg=ErrMsg
	quit RtnFlg
}

}
