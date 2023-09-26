/// 百望电子票据服务接口统一调用方法
Class BILL.EINV.BI.BWA.HTTPRequest Extends %RegisteredObject
{

/// 2019-12-12
/// 百望电子票据 接口调用
/// http服务->返回结果
/// ResOutput 接收返回
/// ReqXmlStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ReqXmlStr As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ResOutput As %String, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	b ;BW
	set $ZT="UploadRequestET"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="GBK18030"							;编码字符集
	set ServerPath=ObjUPConfig.IUCSerPath                			;路径
	Set HttpRequest.ContentType="application/xml"
	
	Do HttpRequest.EntityBody.Write(ReqXmlStr)
	Do HttpRequest.Post(ServerPath)
	
	set DataStream=##class(%GlobalCharacterStream).%New()
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
    Set ResOutput=DataStream.ReadLine()
    b ;;http
    
    s ResOutput=##class(web.Util.Encryption).Base64Decode(ResOutput)    ;Base64解密
	s tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResOutput, .tDocument)
	s tRes=""
    set tSC=tDocument.EvaluateExpression("/business/RESPONSE_COMMON_FPKJ/RETURNCODE","text()",.tRes)	
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set RtnCode=$tr(fieldValue,$c(0),"")
		if (RtnCode="0000") {   ;执行成功
			s RtnFlg="0"
		}else{                  ;执行失败 获取错误信息
			s tRes=""
			set tSCTmp=tDocument.EvaluateExpression("/business/RESPONSE_COMMON_FPKJ/RETURNMSG","text()",.tRes)
			if ($$$ISOK(tSCTmp)&&(tRes.GetAt(1)'="")){
				set fieldValue=tRes.GetAt(1).Value
				set ErrMsg=$tr(fieldValue,$c(0),"")
			}
		}
	}
    
    Quit RtnFlg
    
UploadRequestET
	set $ZT=""
	set RtnFlg="-99999"
	set ErrMsg="程序处理错误:"_$ZERROR
	quit RtnFlg
}

/// 2019-12-13
/// 百望纸质票据 接口调用
/// http服务->返回结果
/// ResOutput 接收返回
/// ReqXmlStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod PInvoiceRequest(ReqXmlStr As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ResOutput As %String, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	set $ZT="UploadRequestET"
	;Set ReqXmlStr=##class(web.Util.Encryption).Base64Encode(ReqXmlStr)
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.ContentCharset="GBK"							;编码字符集
	
	//纸质票据服务的端口号和服务名称与电子票据不同
	s IUCPort=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","PInv_Server_Port", 5)
	s:IUCPort="" IUCPort=ObjUPConfig.IUCPort
	set HttpRequest.Port=IUCPort						        ;端口号
	s IUCSerPath=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","PInv_Server_Path", 5)
	s:IUCSerPath="" IUCSerPath=ObjUPConfig.IUCSerPath
	set ServerPath=IUCSerPath                			            ;路径
	set DataStream=##class(%GlobalCharacterStream).%New()
	Set ReqXmlStr=$zcvt(ReqXmlStr,"I","GB18030")
	Set HttpRequest.ContentType="application/xml"
	Do HttpRequest.EntityBody.Write(ReqXmlStr)
	Do HttpRequest.Post(ServerPath)
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
    Set ResOutput=DataStream.ReadLine()
    b ;45454
    ;特殊字符处理
    set ResOutput=$replace(DataStream.Read(),$c(13),"")
    s ResOutput1=ResOutput
    Set ResOutput=$zcvt(ResOutput,"O","GB18030")
    s tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(ResOutput, .tDocument)
	;set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResOutput, .tDocument)
	;b ;ExampleDisplayResults
	s tRes=""
    set tSC=tDocument.EvaluateExpression("/business/body/returncode","text()",.tRes)
  
    ;set tSC=ResOutput.EvaluateExpression("/business/body/returncode","text()",.tRes)	
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set RtnCode=$tr(fieldValue,$c(0),"")
	   b ;2342
		if (RtnCode="0") {   ;执行成功
			s RtnFlg="0"
		}else{                  ;执行失败 获取错误信息
			s tRes=""
			set tSCTmp=tDocument.EvaluateExpression("/business/body/returnmsg","text()",.tRes)
			if ($$$ISOK(tSCTmp)&&(tRes.GetAt(1)'="")){
				set fieldValue=tRes.GetAt(1).Value
				set ErrMsg=$tr(fieldValue,$c(0),"")
			}
		}
	}
    Quit RtnFlg_"^"_ResOutput1
    
UploadRequestET
	set $ZT=""
	set RtnFlg="-99999"
	set ErrMsg="程序处理错误:"_$ZERROR
	quit RtnFlg
}

}
