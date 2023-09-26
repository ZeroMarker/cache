/// 河南盘古电子票据服务接口统一调用方法
Class BILL.EINV.BI.PGA.HTTPRequest Extends %RegisteredObject
{

/// 徐保保
/// 2020-10-26
/// 博思发票HTTP服务接口
/// 加密签名->http服务->返回结果
/// ServiceCode 博思服务接口
/// HISUniqueID HIS端唯一流水
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// w ##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest()
ClassMethod InvoiceRequest(ServiceCode, Message, HISUniqueID, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef OutputObj As BILL.EINV.DTO.PGA.EInvResultRes) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	set RtnFlg="-1"
	set $ZT="UploadRequestET"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=InvociePam.ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=InvociePam.ObjUPConfig.IUCServer				;票据服务器地址
	set HttpRequest.Port=InvociePam.ObjUPConfig.IUCPort					;端口号
	set HttpRequest.ContentCharset="UTF-8"						;编码字符集
	;set SecretKey=InvociePam.ObjUPConfig.IUCSecretKey			;秘钥
	set ServerPath=InvociePam.ObjUPConfig.IUCSerPath						;路径
	;set Appid=InvociePam.ObjUPConfig.IUCAPPID								;应用账户										
	;set Version=InvociePam.ObjUPConfig.IUCVersion							;版本号
	;set requestId=HISUniqueID										;HIS端唯一流水
	s security=""
	
	Set Data64=Message
	Set Data64=##class(web.Util.Encryption).Base64Encode(Data64)
	set Data64=##class(ext.util.String).EvalJSON2(Data64)
	;set Input=SecretKey_Appid_datetime_format_Data64_Noise_ServiceCode_Version_SecretKey
	;Set security=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	;set security=$zcvt(security,"U")
	
	set ObjReq=##class(BILL.EINV.DTO.PGA.EInvComReq).%New() 
	s ObjReq.method=ServiceCode
	s ObjReq.content="\|"_Data64_"\|"
	s ObjReq.operatorCode=InvociePam.UserCode
	s ObjReq.operatorName=InvociePam.UserDesc
	s ObjReq.requestId=HISUniqueID
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ObjReq,.Stream)
	s ReqJsonStr=Stream.Read()
	s ReqJsonStr=$replace(ReqJsonStr,"\\|","")
	s ReqJsonStr=$replace(ReqJsonStr,"\\","")
	;w ReqJsonStr
	;b ;ReqJsonStr
	
	;do HttpRequest.SetParam("method",ServiceCode)
	;do HttpRequest.SetParam("content",Message)
	;do HttpRequest.SetParam("operatorCode",InvociePam.UserCode)
	;do HttpRequest.SetParam("operatorName",InvociePam.UserDesc)
	;do HttpRequest.SetParam("requestId",HISUniqueID)
	;;do HttpRequest.SetParam("security",security)
	
	Set HttpRequest.ContentType="application/json"
	Do HttpRequest.EntityBody.Write(ReqJsonStr)
	Do HttpRequest.Post(ServerPath)
   
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	;b ;DataStream
 	If DataStream'="" {
	    set OutputObj=##class(BILL.EINV.DTO.PGA.EInvResultRes).%New()
	    ;set DataStream=DataStream.Read(DataStream.Size)
	    set DataStream=DataStream.ReadLine()
	
   		set DataStream=##class(ext.util.String).EvalJSONNew($zcvt(DataStream,"I","UTF8"))
   		set DataStream=$replace(DataStream,"\","")
   		b ;DataStream
	    set Stream=##class(%GlobalCharacterStream).%New()
	    do Stream.Write(DataStream)
	    do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
	    ;set ResOutput=OutputObj.data
	    if (OutputObj.code="1"){
	    	s RtnFlg="0"
	    }
	    ;b ;00
    }else{
	    s InvociePam.ErrMsgInfo="请求电子票据服务未响应"
    }
    
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("响应参数-->"_OutputObj)
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest结束.")
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
