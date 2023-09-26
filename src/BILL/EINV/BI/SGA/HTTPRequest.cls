/// 税歌发票HTTP服务接口
Class BILL.EINV.BI.SGA.HTTPRequest Extends %RegisteredObject
{

/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// w ##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceBSARequest("testServerConnect","HYD18071900012","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)

	set $ZT="UploadRequestET"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"									;编码字符集
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	
	set ServerPath=ObjUPConfig.IUCSerPath_"/"_ServiceCode		;路径
	set Appid=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	set Noise=HISUniqueID													;HIS端唯一流水
	
	Set Data=$zcvt(Message,"O","UTF8")
	Set Data=Message
	;Set Data64=##class(web.Util.Encryption).Base64Encode(Data)
	;set Input="appid="_Appid_"&"_"data="_Data64_"&"_"noise="_Noise_"&"_"key="_SecretKey_"&"_"version="_Version
	;Set Sign=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	;set Sign=$zcvt(Sign,"U")
	;设置请求头部
	do HttpRequest.SetHeader("",Appid)
	do HttpRequest.SetHeader("",SecretKey)
	do HttpRequest.SetParam("data",Data64)
	Do HttpRequest.Post(ServerPath)
    ;Do HttpRequest.HttpResponse.OutputToDevice()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	If DataStream'="" {
		set DataStream=DataStream.Read(DataStream.Size)
		set OutputObj=##class(BILL.EINV.DTO.BSA.InvoiceBaseRes).%New()
		set Stream=##class(%GlobalCharacterStream).%New()
		do Stream.Write(DataStream)
		do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
		set Data=##class(web.Util.Encryption).Base64Decode(OutputObj.data,"UTF8")
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest结束.")
	quit Data
UploadRequestET
	set ETObj=##class(BILL.EINV.DTO.BSA.OPInvoiceRes).%New()
	Set ETObj.result=""
	Set ETObj.message=""
	set Data=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(ETObj,.Data)
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	
	quit Data
}

/// Get请求
ClassMethod InvoiceRequestGet(ServiceCode, Message, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef ResOutput As BILL.EINV.DTO.SGA.EInvStatusRes) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
    
    s RtnFlg="-1"
    s $ZT="UploadRequestGetET"
	i $isobject(ResOutput)=0 d
	.s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRes).%New()
	s ObjUPConfig=InvociePam.ObjUPConfig
	
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"									;编码字符集
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	
	set ServerPath=ObjUPConfig.IUCSerPath_"/"_ServiceCode		;路径
	set Appid=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	;set Noise=HISUniqueID							            ;HIS端唯一流水
	
	Set Data=$zcvt(Message,"O","UTF8")
	Set Data=Message

	;设置请求头部
	do HttpRequest.SetHeader("",Appid)
	do HttpRequest.SetHeader("",SecretKey)
	
	;Get请求URL传值 https:// 114.55.62.130:8888/gateway/medicalbill/einvoices
	s URL=ServerPath_"?"_Data
	do HttpRequest.SetParam("data",Data)
	Do HttpRequest.Get(URL)
    ;Do HttpRequest.HttpResponse.OutputToDevice()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	If DataStream'="" {
		set DataStream=DataStream.Read()
		set Stream=##class(%GlobalCharacterStream).%New()
		do Stream.Write(DataStream)
		do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResOutput,"")
		if (ResOutput.code="1") d
	    .s RtnFlg="0"
    }else{
	    s ResOutput.code="-1"
	    s ResOutput.msg="服务无响应"
    
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest结束.")
	quit RtnFlg
UploadRequestGetET
	set ETObj=##class(BILL.EINV.DTO.BSA.OPInvoiceRes).%New()
	Set ETObj.result=""
	Set ETObj.message=""
	set Data=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(ETObj,.Data)
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	
	quit Data
}

}
