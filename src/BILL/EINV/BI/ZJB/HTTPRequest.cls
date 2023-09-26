Class BILL.EINV.BI.ZJB.HTTPRequest Extends %RegisteredObject
{

/// 诺诺网HTTP服务接口（浙江诸暨宏宇康复医院）
/// 加密签名->http服务->返回结果
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// MethodType   1-开具接口 2.流水号查询接口
/// 修改履历：董科锋 2019 09 19 增加配置对象(减少访问数据库获取配置的次数)
///           董科锋 2020 06 28 http由于网络问题获取不到数据的时候 返回错误标志，防止多个业务继续往下走
/// w ##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest("testServerConnect","HYD18071900012","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(Message, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, RtnCode As %String = "0", MethodType As %String = "1") As %String
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
    b ;加密完成
    q:InputJson="" "-1"   ;组织入参发生错误
    //s Stream=##class(%GlobalCharacterStream).%New()
    //d Stream.Write(InputJson)
	//do HttpRequest.SetParam("order",InputJson)       ;SetParam会导致超长错误。
	
	//s ReqJsonStr="{""order"":"""_InputJson_"""}"
	 
    b //Do HttpRequest.EntityBody.Write(ReqJsonStr)
    Do HttpRequest.InsertFormData("order",InputJson)
    //s InputJson=
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
