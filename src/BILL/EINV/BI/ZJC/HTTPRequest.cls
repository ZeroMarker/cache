/// 浙江慈林医院电子发票接口（诺诺网2.0版本）
Class BILL.EINV.BI.ZJC.HTTPRequest Extends %RegisteredObject
{

/// 诺诺网HTTP服务接口（浙江慈林医院）
/// 加密签名->http服务->返回结果
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// MethodType   1-开具接口 2.流水号查询接口
/// w ##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest("testServerConnect","HYD18071900012","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(Message, ServerCode As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, RtnCode As %String = "0", MethodType As %String = "1") As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	s RtnFlag="-1"
	set $ZT="UploadRequestET"
	s ObjUPConfig=InvociePam.ObjUPConfig
	if $isobject(ObjUPConfig)=0 d
	.s RtnConfig=##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjUPConfig)
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout				;服务延时
	//set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	//set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"									;编码字符集
	d HttpRequest.SetHeader("Content-type","application/json")     ;String	Y	MIME类型【消息头】
	d HttpRequest.SetHeader("X-Nuonuo-Sign","")   ;String	Y	签名（编码格式请使用UTF-8）【消息头】
	d HttpRequest.SetHeader("accessToken","")     ;String	Y	授权码【消息头】
	d HttpRequest.SetHeader("userTax","")         ;String	N	授权商户的税号（自用型应用非必填，第三方应用必填）【消息头】
	d HttpRequest.SetHeader("method",ServerCode)          ;String	Y	请求api对应的方法名称【消息头】
	if MethodType="1" d
	 .set ServerPath="http://nnfp.jss.com.cn/shop/buyer/allow/cxfKp/cxfServerKpOrderSync.action"
	;.set ServerPath="http://nnfpbox.nuonuocs.cn/shop/buyer/allow/cxfKp/cxfServerKpOrderSync.action"   ;ObjUPConfig.IUCSerPath	;路径
	if MethodType="2" d
	 .set ServerPath="http://nnfp.jss.com.cn/shop/buyer/allow/ecOd/queryElectricKp.action"
	;.set ServerPath="http://nnfpbox.nuonuocs.cn/shop/buyer/allow/ecOd/queryElectricKp.action"
	;Set Data=$zcvt(Message,"O","UTF8")
	;Set Data=Message
	;Set Data64=##class(web.Util.Encryption).Base64Encode(Data)
    b ;调用平台接口加密
    s InputJson=##class(web.DHCENS.BLL.Invoice.Method.DESUtil).DESEncrypt(Message)
    
    
    ///senid	String	Y	唯一标识，由企业自己生成32位随机码【消息体】
    Do HttpRequest.InsertFormData("senid",InputJson)
    ///nonce	String	Y	8位随机正整数【消息体】
    s nonce=##class(BILL.EINV.COM.Common).CreateCheckeCode(8)
    Do HttpRequest.InsertFormData("nonce",InputJson)
   ///timestamp	String	Y	时间戳(当前时间的毫秒数)【消息体】
   s timestamp=##class(BILL.EINV.COM.Common).GetcurrentTimeMillis()
   Do HttpRequest.InsertFormData("timestamp",timestamp)
   ///appkey	String	Y	平台分配给应用的appKey【消息体】

   Do HttpRequest.InsertFormData("appkey","")
   
   Do HttpRequest.InsertFormData("order",Message)
    
	//do HttpRequest.EntityBody.CopyFrom(InputJson)
	Do HttpRequest.Post(ServerPath)
    ;Do HttpRequest.HttpResponse.OutputToDevice()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	b ;DataStream
 	If DataStream'="" {
		set DataStream=DataStream.Read(DataStream.Size)
		b ;调用平台组方法进行解密
		;set OutData=##class(web.DHCENS.BLL.Invoice.Method.DESUtil).DESDecrypt(DataStream)
		s result="",status="",message=""
		set ObjJsonStream={}.%FromJSON(DataStream)
		if MethodType="1" d
		.set status=ObjJsonStream.%Get("status")
		.set message=ObjJsonStream.%Get("message")
		if MethodType="2" d
		.set result=ObjJsonStream.%Get("result")
		.set message=ObjJsonStream.%Get("errorMsg")
		b ;status
		if (status="0000")||(result="success") d
		.s RtnCode="0"	
		else  d 
		.s RtnCode="-1"
		.s InvociePam.ErrMsgInfo=message
	}else{
		s RtnCode="-1"
	}
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest结束.")
	quit DataStream
UploadRequestET
	s $ZT=""
	s RtnCode="-1"       ;+dongkf 2020 06 28
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	quit RtnCode
}

}
