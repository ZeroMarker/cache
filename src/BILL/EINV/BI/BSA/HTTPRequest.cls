Class BILL.EINV.BI.BSA.HTTPRequest Extends %RegisteredObject
{

/// wangjian
/// 2019-09-02
/// 博思发票HTTP服务接口
/// 加密签名->http服务->返回结果
/// ServiceCode 博思服务接口
/// HISUniqueID HIS端唯一流水
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// 修改履历：董科锋 2019 09 19 增加配置对象(减少访问数据库获取配置的次数)
///           董科锋 2020 06 28 http由于网络问题获取不到数据的时候 返回错误标志，防止多个业务继续往下走
/// w ##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest("testServerConnect","HYD18071900012","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig As BILL.EINV.PO.InvUpConfig, RtnCode As %String = "0") As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	set $ZT="UploadRequestET"
	if $isobject(ObjUPConfig)=0 d
	.s RtnConfig=##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjUPConfig)
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer				;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort					;端口号
	set HttpRequest.ContentCharset="UTF-8"						;编码字符集
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	set ServerPath=ObjUPConfig.IUCSerPath_"/"_ServiceCode		;路径
	set Appid=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	set Noise=HISUniqueID										;HIS端唯一流水
	
	
	//add by xubaobao 2021 03 02 调用方式;		1：调用平台组请求，2：通过webservice请求调用，其他：http请求调用
	s EINVUpFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","BILLEINV_RequestType",5)
	if (EINVUpFlg="1") {
		;宁波鄞州人民测试用--调用平台组接口
		s Data=##class(BILL.EINV.ADP.BSA).InvoiceENSRequest(ServiceCode,HISUniqueID,Message,ObjUPConfig)
		q Data 
	}elseif(EINVUpFlg="2") {
		;通过webservicce请求，目前webservice请求只处理开票相关接口
		if (ServiceCode="invoiceEBillOutpatient")||(ServiceCode="invEBillRegistration")||(ServiceCode="invEBillHospitalized")||(ServiceCode="invEBillCheckUp")||(ServiceCode="invEBillCheckUp") {
        	s SoapObj=##class(BILL.EINV.BI.BSA.EINVWebServiceSoap).%New()
        	s Data=SoapObj.InvoiceWebRequest(ObjUPConfig.FactoryCode,ServiceCode,HISUniqueID,Message,Appid,Noise,SecretKey,Version,ServerPath,ObjUPConfig.IUCServer,ObjUPConfig.IUCPort,ObjUPConfig.IUCTimeout)
        	s:Data="-1" RtnCode="-1"
       	 	q Data
    	}
	}
	
	;Set Data=$zcvt(Message,"O","UTF8")
	Set Data=Message
	Set Data64=##class(web.Util.Encryption).Base64Encode(Data)
	;set Data64=##class(ext.util.String).EvalJSON2(Data64)
	set Input="appid="_Appid_"&"_"data="_Data64_"&"_"noise="_Noise_"&"_"key="_SecretKey_"&"_"version="_Version
	Set Sign=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	set Sign=$zcvt(Sign,"U")
	
	/*
	//Update By Suhuide at 2022-06-20 修改Base64和MD5加密为流数据模式(如当前数据库不支持流数据加密转换,先联系基础数据平台升级)
	s Stream1=##class(%GlobalCharacterStream).%New()
	d Stream1.Write("appid="_Appid_"&"_"data=")
	s Stream2=##class(%GlobalCharacterStream).%New()
	d Stream2.Write("&"_"noise="_Noise_"&"_"key="_SecretKey_"&"_"version="_Version)
	
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.CopyFrom(Stream1)
	d Stream.CopyFrom(Data64)
	d Stream.CopyFrom(Stream2)
	Set Sign=##class(web.Util.Encryption).MD5HexStr(Stream)
	set Sign=$zcvt(Sign,"U")
	//+end;
	*/
	;b ;b111
	;do HttpRequest.SetParam("appid",Appid)
	;do HttpRequest.SetParam("data",Data64)
	;do HttpRequest.SetParam("noise",Noise)
	;do HttpRequest.SetParam("version",Version)
	;do HttpRequest.SetParam("sign",Sign)
	;改为body传值,处理明细太长导致错误
	s ReqJsonStr="{""appid"":"""_Appid_""",""data"":"""_Data64_""",""noise"":"""_Noise_""",""version"":"""_Version_""",""sign"":"""_Sign_"""}"
	Do HttpRequest.EntityBody.Write(ReqJsonStr)
	
	/*Data64是流    ,放开下面，注释掉上面两行
	s Stream=..LinkStream(Appid,Data64,Noise,Version,Sign)
	Do HttpRequest.EntityBody.CopyFrom(Stream)
	;Do HttpRequest.EntityBody.CopyFrom(ReqJsonStream)   ;传流对象
	*/
	/*
	//+Update By Suhuide at 2022-06-20 修改与博思交互模式为流数据模式
	s Stream3=##class(%GlobalCharacterStream).%New()
	d Stream3.Write("{""appid"":"""_Appid_""",""data"":""")
	s Stream4=##class(%GlobalCharacterStream).%New()
	d Stream4.Write(""",""noise"":"""_Noise_""",""version"":"""_Version_""",""sign"":"""_Sign_"""}")
	
	s Stream5=##class(%GlobalCharacterStream).%New()
	d Stream5.CopyFrom(Stream3)
	d Stream5.CopyFrom(Data64)
	d Stream5.CopyFrom(Stream4)
	Do HttpRequest.EntityBody.CopyFrom(Stream5)
	//+end;
	*/
	Do HttpRequest.Post(ServerPath)
    ;Do HttpRequest.HttpResponse.OutputToDevice()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	b ;DataStream
 	If DataStream'="" {
		set DataStream=DataStream.Read(DataStream.Size)
		set OutputObj=##class(BILL.EINV.DTO.BSA.InvoiceBaseRes).%New()
		set Stream=##class(%GlobalCharacterStream).%New()
		do Stream.Write(DataStream)
		do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
		set Data=##class(web.Util.Encryption).Base64Decode(OutputObj.data,"UTF8")
	}else{
		s RtnCode="-1"
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest结束.")
	quit Data
UploadRequestET
	s $ZT=""
	s RtnCode="-1"       ;+dongkf 2020 06 28
	/*-dongkf 2020 06 28
	set ETObj=##class(BILL.EINV.DTO.BSA.OPInvoiceRes).%New()
	Set ETObj.result=""
	Set ETObj.message=""
	set Data=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(ETObj,.Data)
	*/
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	
	quit Data
}

/// 调用博思打印exe接口
ClassMethod PrintInvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig As BILL.EINV.PO.InvUpConfig, RtnCode As %String = "0") As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)

	set $ZT="PrintInvoiceRequest"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout="5"    //ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server="127.0.0.1"   //ObjUPConfig.IUCServer				;票据服务器地址
	set HttpRequest.Port="13526"  ;ObjUPConfig.IUCPort					;端口号
	set HttpRequest.ContentCharset="UTF-8"						;编码字符集
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	set ServerPath="/extend?"   //ObjUPConfig.IUCSerPath_"/"_ServiceCode		;路径
	set Appid=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	set Noise=HISUniqueID										;HIS端唯一流水
	
	///http://IP:PORT/extend?dllName=DLL名称&func=DLL入口方法&payload=BASE64(JSON格式的请求参数)。
	b ;Set Data=$zcvt(Message,"O","UTF8")
	Set Data=Message
	Set Data64=##class(web.Util.Encryption).Base64Encode(Data)
	;set Data64=##class(ext.util.String).EvalJSON2(Data64)
	set Input="appid="_Appid_"&"_"data="_Data64_"&"_"noise="_Noise_"&"_"key="_SecretKey_"&"_"version="_Version
	Set Sign=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	set Sign=$zcvt(Sign,"U")
	
	;改为body传值,处理明细太长导致错误
	set ReqJsonStr="{""method"":"""_ServiceCode_""",""params"":{""appid"":"""_Appid_""",""data"":"""_Data64_""",""noise"":"""_Noise_""",""version"":"""_Version_""",""sign"":"""_Sign_"""}}"
	b ;;;ReqJsonStr
	Set ReqJsonStr=##class(web.Util.Encryption).Base64Encode(ReqJsonStr)
	set dllName="NontaxIndustry"  ;DLL名称
	set func="CallNontaxIndustry"     ;DLL入口方法
	set ServerPath="http://127.0.0.1:13526/extend?dllName=NontaxIndustry&func=CallNontaxIndustry&payload="_ReqJsonStr
	quit ServerPath
PrintInvoiceRequest
	s $ZT=""
	s RtnCode="-1"       ;+dongkf 2020 06 28
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(DHCBILL.Invoice.BI.HTTPRequest).InvoiceRequest执行时发生异常.")
	
	quit Data
}

/// 测试博思服务(目前适用于博思)，其他厂商可以参考该方法测试
/// 根据配置的地址测试服务是否OK
/// w ##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequestTest("testServerConnect","HYD18071900012","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequestTest(ServiceCode, HISUniqueID, Message, RtnCode As %String = "0") As %String
{
	set $ZT="InvoiceRequestTestErr"
	s RtnConfig=##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjUPConfig)
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer				;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort					;端口号
	set HttpRequest.ContentCharset="UTF-8"						;编码字符集
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	set ServerPath=ObjUPConfig.IUCSerPath_"/"_ServiceCode		;路径
	set Appid=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	set Noise=HISUniqueID										;HIS端唯一流水
	
	
	//add by xubaobao 2021 03 02 调用方式;		1：调用平台组请求，2：通过webservice请求调用，其他：http请求调用
	s EINVUpFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","BILLEINV_RequestType",5)
	if (EINVUpFlg="1") {
		;宁波鄞州人民测试用--调用平台组接口
		s Data=##class(BILL.EINV.ADP.BSA).InvoiceENSRequest(ServiceCode,HISUniqueID,Message,ObjUPConfig)
		q Data 
	}elseif(EINVUpFlg="2") {
		;通过webservicce请求，目前webservice请求只处理开票相关接口
		if (ServiceCode="invoiceEBillOutpatient")||(ServiceCode="invEBillRegistration")||(ServiceCode="invEBillHospitalized")||(ServiceCode="invEBillCheckUp")||(ServiceCode="invEBillCheckUp") {
        	s SoapObj=##class(BILL.EINV.BI.BSA.EINVWebServiceSoap).%New()
        	s Data=SoapObj.InvoiceWebRequest("BS",ServiceCode,HISUniqueID,Message,Appid,Noise,SecretKey,Version,ServerPath,ObjUPConfig.IUCServer,ObjUPConfig.IUCPort,ObjUPConfig.IUCTimeout)
        	s:Data="-1" RtnCode="-1"
       	 	q Data
    	}else{
	    	s RtnCode="-1"
	    	s Data="-1^接口编码不存在"
	    }
	}
	
	;Set Data=$zcvt(Message,"O","UTF8")
	Set Data=Message
	Set Data64=##class(web.Util.Encryption).Base64Encode(Data)
	;set Data64=##class(ext.util.String).EvalJSON2(Data64)
	set Input="appid="_Appid_"&"_"data="_Data64_"&"_"noise="_Noise_"&"_"key="_SecretKey_"&"_"version="_Version
	Set Sign=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	set Sign=$zcvt(Sign,"U")
	
	//Update by Suhuide at 2022-06-20 修改Base64加密和MD5加密为流模式(数据库不支持流模式时,先联系基础数据平台升级)
	s Stream1=##class(%GlobalCharacterStream).%New()
	d Stream1.Write("appid="_Appid_"&"_"data=")
	s Stream2=##class(%GlobalCharacterStream).%New()
	d Stream2.Write("&"_"noise="_Noise_"&"_"key="_SecretKey_"&"_"version="_Version)
	
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.CopyFrom(Stream1)
	d Stream.CopyFrom(Data64)
	d Stream.CopyFrom(Stream2)
	Set Sign=##class(web.Util.Encryption).MD5HexStr(Stream)
	set Sign=$zcvt(Sign,"U")
	//+end;
	;b ;b111
	;do HttpRequest.SetParam("appid",Appid)
	;do HttpRequest.SetParam("data",Data64)
	;do HttpRequest.SetParam("noise",Noise)
	;do HttpRequest.SetParam("version",Version)
	;do HttpRequest.SetParam("sign",Sign)
	;改为body传值,处理明细太长导致错误
	;s ReqJsonStr="{""appid"":"""_Appid_""",""data"":"""_Data64_""",""noise"":"""_Noise_""",""version"":"""_Version_""",""sign"":"""_Sign_"""}"
	;Do HttpRequest.EntityBody.Write(ReqJsonStr)
	;Do HttpRequest.EntityBody.CopyFrom(ReqJsonStream)   ;传流对象
	
	//Update by Suhuide at 2022-06-20 修改与博思交互模式为流模式
	s Stream3=##class(%GlobalCharacterStream).%New()
	d Stream3.Write("{""appid"":"""_Appid_""",""data"":""")
	s Stream4=##class(%GlobalCharacterStream).%New()
	d Stream4.Write(""",""noise"":"""_Noise_""",""version"":"""_Version_""",""sign"":"""_Sign_"""}")
	s Stream5=##class(%GlobalCharacterStream).%New()
	d Stream5.CopyFrom(Stream3)
	d Stream5.CopyFrom(Data64)
	d Stream5.CopyFrom(Stream4)
	Do HttpRequest.EntityBody.CopyFrom(Stream5)
	//+end;
	
	Do HttpRequest.Post(ServerPath)
    ;Do HttpRequest.HttpResponse.OutputToDevice()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	b ;DataStream
 	If (DataStream'="")&&(StatusCode="200") {
		set DataStream=DataStream.Read(DataStream.Size)
		set OutputObj=##class(BILL.EINV.DTO.BSA.InvoiceBaseRes).%New()
		set Stream=##class(%GlobalCharacterStream).%New()
		do Stream.Write(DataStream)
		do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
		set Data=##class(web.Util.Encryption).Base64Decode(OutputObj.data,"UTF8")
	}else{
		s RtnCode="-1"
		s Data="-1^接口调用异常"
	}
	quit Data
InvoiceRequestTestErr
	s $ZT=""
	s RtnCode="-1"
	s Data="-1^测试服务进入异常，请查看参数配置"       ;+dongkf 2020 06 28
	quit Data
}

/// w ##class(BILL.EINV.BL.EInvoiceLogic).TestStream()
/// 流拼接测试
ClassMethod LinkStream(Appid, Data64, Noise, Version, Sign) As %String
{
	
	s data="{""appid"":"""_1_""",""data"":"""_2_""",""noise"":"""_3_""",""version"":"""_4_""",""sign"":"""_5_"""}"
	
	s Stream1=##class(%GlobalCharacterStream).%New()
	d Stream1.Write("{""appid"":"""_Appid_""",""data"":""")
	
	s Stream2=##class(%GlobalCharacterStream).%New()
	d Stream2.Write(Data64)
	
	s Stream3=##class(%GlobalCharacterStream).%New()
	d Stream3.Write(""",""noise"":"""_Noise_""",""version"":"""_Version_""",""sign"":"""_Sign_"""}")
	
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.CopyFrom(Stream1)
	d Stream.CopyFrom(Stream2)
	d Stream.CopyFrom(Stream3)
	
	w Stream.Read()
	//{"appid":"1","data":"2","noise":"3","version":"4","sign":"5"}
	q Stream
}

}
