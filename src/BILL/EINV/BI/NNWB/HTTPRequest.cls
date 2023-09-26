/// 诺诺网2.0版本请求
Class BILL.EINV.BI.NNWB.HTTPRequest Extends %RegisteredObject
{

/// http服务->返回结果
/// ServiceCode 诺诺网服务接口
/// ReqJsonStr 主报文消息
/// InvociePam As BILL.EINV.DTO.COM.InvocieInputPam
/// ResOutput 接收返回
/// w ##class(BILL.EINV.BI.NNWA.HTTPRequest).InvoiceRequest("testServerConnect","{""testValue"":""100.00""}","")
ClassMethod InvoiceRequest(ServiceCode As %String, ReqJsonStr As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, objInvUpDetails As BILL.EINV.PO.InvUpDetails) As %String
{
	s RtnFlg="-1"
	set $ZT="UploadRequestET"	
	s ObjUPConfig=InvociePam.ObjUPConfig
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout					;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"							;编码字符集
	set ServerPath=ObjUPConfig.IUCSerPath                			;路径
	//set ServerPath=ServiceCode 
	               		            	;路径+服务名称
	Set HttpRequest.ContentType="application/json"
	
	d HttpRequest.SetHeader("Content-type","application/json")  //MIME类型【消息头】
	d HttpRequest.SetHeader("X-Nuonuo-Sign","")    //签名（编码格式请使用UTF-8）【消息头】
	d HttpRequest.SetHeader("accessToken",InvociePam.HospitalInfoMap.GetAt("accessToken"))     //授权码【消息头】
	d HttpRequest.SetHeader("userTax",InvociePam.HospitalInfoMap.GetAt("userTax"))   //授权商户的税号（自用型应用非必填，第三方应用必填）【消息头】
	d HttpRequest.SetHeader("method",ServiceCode)          //请求api对应的方法名称【消息头】
    d HttpRequest.InsertFormData("senid",objInvUpDetails.IUDBusNo)        //唯一标识，由企业自己生成32位随机码【消息体】
    s nonce=##class(BILL.EINV.COM.Common).CreateCheckeCode("8")
    d HttpRequest.InsertFormData("nonce",nonce)        //8位随机正整数【消息体】
    s timestamp=##class(BILL.EINV.COM.Common).GetcurrentTimeMillis()
    d HttpRequest.InsertFormData("timestamp",timestamp)    //时间戳(当前时间的毫秒数)【消息体】
    d HttpRequest.InsertFormData("appkey",InvociePam.HospitalInfoMap.GetAt("appkey"))       //平台分配给应用的appKey【消息体】
    d HttpRequest.InsertFormData("order",ReqJsonStr)        //请求参数

	//Do HttpRequest.EntityBody.Write(ReqJsonStr)
	Do HttpRequest.Post(ServerPath)
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	
    b ;Set ResOutput=DataStream.ReadLine()
    If DataStream'="" {
	    set DataStream=DataStream.Read(DataStream.Size)
	    set Stream=##class(%GlobalCharacterStream).%New()
	    do Stream.Write(DataStream)
	    
    }else{
	    
    }
    Quit RtnFlg
UploadRequestET
	set $ZT=""
	set RtnFlg="-99999"
	quit RtnFlg
}

}
