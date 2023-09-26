/// 河南省信息化发展有限公司服务接口统一调用方法
Class BILL.EINV.BI.XAA.HTTPRequest Extends %RegisteredObject
{

/// 徐保保
/// 2020-01-07
/// 信安发票HTTP服务接口
/// 加密签名->http服务->返回结果
/// ServiceCode 博思服务接口
/// HISUniqueID HIS端唯一流水
/// Message 主报文消息
/// InvociePam 扩展信息对象(包含电子票据入参属性,系统属性等)
/// w ##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest()
ClassMethod InvoiceRequest(ServiceCode, Message, HISUniqueID, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef OutputObj As BILL.EINV.DTO.PGA.EInvResultRes) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest开始.")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("请求参数-->"_Message)
	
	set RtnFlg="-1"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=ObjUPConfig.IUCTimeout				;服务延时
	set HttpRequest.Server=ObjUPConfig.IUCServer				;票据服务器地址
	set HttpRequest.Port=ObjUPConfig.IUCPort					;端口号
	set HttpRequest.ContentCharset="UTF-8"						;编码字符集
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	set ServerPath=ObjUPConfig.IUCSerPath						;路径
	set Appid=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	set nonce=HISUniqueID										;HIS端唯一流水
	set timestamp=##class(BILL.EINV.COM.Common).GetBusDate(+$h,$p($h,",",2))
	
	//生成防伪码
	//1.请求体进行MD5加密，再转为大写，生成requestbody；
	if Message="" {
		set requestbody="D41D8CD98F00B204E9800998ECF8427E"      //空字符串MD5加密结果
	}else{
		Set requestbody=##class(web.Util.Encryption).MD5HexStr($zcvt(Message,"O","UTF8"))  ;MD5加密
		set requestbody=$zcvt(requestbody,"U")
	}
	
	//2.appkey+requestbody+nonce+timestamp+appkey
	Set Input=SecretKey_requestbody_nonce_timestamp_SecretKey
	
	//3.对字符串进行MD5加密,再转为大写。
	Set Input=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	set signature=$zcvt(Input,"U")
	
	set ObjReq=##class(BILL.EINV.DTO.XAA.EInvComReq).%New() 
	set ObjReq.appid=ServiceCode
	set ObjReq.nonce=""
	set ObjReq.timestamp=InvociePam.UserCode
	set ObjReq.signature=InvociePam.UserDesc
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ObjReq,.Stream)
	s ReqJsonStr=Stream.Read()
	
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
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest结束.")
    Quit RtnFlg
    
UploadRequestET
	set $ZT=""
	b ;zt
	set RtnFlg="-9999"
	set InvociePam.ErrMsgInfo="请求电子票据服务发生异常:"_$ZERROR
	do ##class(BILL.EINV.BL.COM.LogInfoCtl).Error("##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest执行时发生异常.")
	quit RtnFlg
}

}
