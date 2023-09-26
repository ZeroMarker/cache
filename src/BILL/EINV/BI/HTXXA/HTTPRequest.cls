Class BILL.EINV.BI.HTXXA.HTTPRequest Extends %RegisteredObject
{

/// 航天信息 接口调用
/// http服务->返回结果
/// ResOutput 接收返回
/// ReqXmlStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.HTXXA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ReqXmlStr As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ResOutput As %String, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	b ;HTXXA
	set $ZT="UploadRequestET"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	;set HttpRequest.ContentCharset="GBK18030"							;编码字符集
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
    set tSC=tDocument.EvaluateExpression("/EInvoiceIFS/ReturnInfo/ReturnCode","text()",.tRes)	
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set RtnCode=$tr(fieldValue,$c(0),"")
		if (RtnCode="200") {   ;执行成功
			s RtnFlg="0"
		}else{                  ;执行失败 获取错误信息
			s tRes=""
			set tSCTmp=tDocument.EvaluateExpression("/EInvoiceIFS/ReturnInfo/ReturnMessage","text()",.tRes)
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

/// /把传入的key_value 键值对中的value 进行URL 编码 解码
ClassMethod ConvertData(Data, type) As %String
{
	set rtn=""
	set len=$l(Data,"&")
	for num=1:1:len do
	.set dataStr=$p(Data,"&",num)
	.set key=$p(dataStr,"=",1)
	.set value=$p(dataStr,"=",2)
	.set value=$zcvt(value,type,"UTF8")
	.set value=$ZCONVERT(value,type,"URL")
	.set value=$zcvt(value,type,"UTF8")
	.if type="O" do
	..set value=$replace(value,"/","%2F")
	..set value=$replace(value,"%0D","")
	.///end
	.if rtn="" set rtn=key_"="_value
	.else  set rtn=rtn_"&"_key_"="_value
	quit rtn
}

}
