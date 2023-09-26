/// 河南兴财电子票据服务接口统一调用方法
Class BILL.EINV.BI.XCA.HTTPRequest Extends %RegisteredObject
{

/// 徐保保
/// 2020-10-26
/// 博思发票HTTP服务接口
/// 加密签名->http服务->返回结果
/// ServiceCode 博思服务接口
/// HISUniqueID HIS端唯一流水
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// w ##class(BILL.EINV.BI.XCA.HTTPRequest).InvoiceBSARequest("testServerConnect","HYD18071900012","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef OutputObj As BILL.EINV.DTO.XCA.EInvResultMessage) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.XCA.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	
	set RtnFlg="-1"
	set $ZT="UploadRequestET"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer				;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort					;端口号
	set HttpRequest.ContentCharset="UTF-8"						;编码字符集
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	set ServerPath=ObjUPConfig.IUCSerPath						;路径
	set Appid=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	set Noise=HISUniqueID										;HIS端唯一流水
	set datetime=##class(BILL.EINV.COM.Common).GetBusDate(+$h,$p($h,",",2))
	set format="json"
	
	Set Data=Message
	Set Data64=##class(web.Util.Encryption).Base64Encode(Data)
	;set Data64=##class(ext.util.String).EvalJSON2(Data64)
	
	set Input=SecretKey_Appid_datetime_format_Data64_Noise_ServiceCode_Version_SecretKey
	Set security=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	set security=$zcvt(security,"U")
	
	do HttpRequest.SetParam("app_id",Appid)
	do HttpRequest.SetParam("datetime",datetime)
	do HttpRequest.SetParam("format",format)
	do HttpRequest.SetParam("message",Data64)
	do HttpRequest.SetParam("message_id",Noise)
	do HttpRequest.SetParam("method",ServiceCode)
	do HttpRequest.SetParam("version",Version)
	do HttpRequest.SetParam("security",security)
	Do HttpRequest.Post(ServerPath)
    ;Do HttpRequest.HttpResponse.OutputToDevice()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	If DataStream'="" {
	    set OutputObj=##class(BILL.EINV.DTO.XCA.EInvResultMessage).%New()
	    set DataStream=DataStream.Read(DataStream.Size)
	    set Stream=##class(%GlobalCharacterStream).%New()
	    do Stream.Write(DataStream)
	    ;b ;DataStream
	    do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
	    ;set OutputObj.Message = $zcvt(OutputObj.Message,"I","UTF8")
	    s OutputObj.Message=$tr(OutputObj.Message,"_","/")	//兴财加密规则要求
		s OutputObj.Message=$tr(OutputObj.Message,"-","+")
		b ;OutputObj.Message
		
		s fileNM="File.txt"
		s realPath="E:\temp"_"/"_ServiceCode_fileNM
		S stream=##class(%FileCharacterStream).%New()
		S stream.Filename = realPath
		d stream.WriteLine(OutputObj.Message)
		d stream.SaveStream()
		d stream.%Close()
		
	    if (OutputObj.Code="200"){
		    set OutputObj.Message=##class(web.Util.Encryption).Base64Decode(OutputObj.Message,"UTF8")
	    	s RtnFlg="0"
	    }
    }else{
	    s OutputObj.Code=""
	    s OutputObj.Message="请求电子票据服务未响应"
    }
    
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("响应参数-->"_DataStream)
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.XCA.HTTPRequest).InvoiceRequest结束.")
    Quit RtnFlg
    
UploadRequestET
	set $ZT=""
	set RtnFlg="-9999"
	set OutputObj.Message="请求电子票据服务发生异常:"_$ZERROR
	do ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	quit RtnFlg
}

}
