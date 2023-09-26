Class BILL.EINV.BI.ZJA.HTTPRequest Extends %RegisteredObject
{

/// guoyunlong
/// 20200917
/// 杭州整形医院电子发票HTTP服务接口
/// http服务->返回结果
/// ServiceCode 服务接口
/// ReqJsonStr 主报文消息
/// ObjUPConfig 系统属性对象
/// w ##class(BILL.EINV.BI.ZJA.HTTPRequest).InvoiceRequest()
ClassMethod InvoiceRequest(ServiceCode As %String, ReqJsonStr As %GlobalCharacterStream, ResOutput, ByRef ErrMsg As %String) As %String
{
    ////走平台接口  -平台提供接口，改造
    set $ZT="UploadRequestZJA"
    s RtnFlg="-1"
    ;;ServiceCode

    if (ServiceCode="MES0159") {
         s Jsonstream={}.%FromJSON(ReqJsonStr)
         s acceskeyid=Jsonstream.%Get("acceskeyid")
         s username=Jsonstream.%Get("username")
         s password=Jsonstream.%Get("password")
         s soap=##class(web.DHCENS.BLL.Invoice.SOAP.PUB0010Soap).%New()
         s result=soap.auth(acceskeyid,username,password)
         b ;
    }elseif(ServiceCode="MES0160"){							//MES0160 电子票据发票开具
	   	 s soap=##class(web.DHCENS.BLL.Invoice.SOAP.PUB0010Soap).%New()
	     s result=soap.fpkj(ReqJsonStr)
	}elseif(ServiceCode="MES0161"){							//MES0161 电子票据发票查询
		 s soap=##class(web.DHCENS.BLL.Invoice.SOAP.PUB0010Soap).%New()
	     s result=soap.fpcx(ReqJsonStr)
	}elseif(ServiceCode="MES0162"){ 						//MES0162 电子发票作废
		 s soap=##class(web.DHCENS.BLL.Invoice.SOAP.PUB0010Soap).%New()
	     s result=soap.fpzf(ReqJsonStr)
	}else{
	     d result.Write("请输入正确的消息编码 如MES0159，MES0160，MES0161，MES0162")
			
	}
    b ;result
    ///一下是我们自己调用第三方接口参数数据，走平台需改造
	
	If result'="" {
		;s result=##class(web.Util.Encryption).RSADecrypt(result,"d:\913300000000000000.pfx")
		s resultObjOld={}.%FromJSON(result)  //加密前
		s decryString=resultObjOld.%Get("resultObj")
		;s decryStream=##class(%GlobalCharacterStream).%New()
		;d decryStream.Write(decryString)
		;s soap=##class(web.DHCENS.SOAPNew.PUB0014Soap).%New()
		;s resultStream=soap.decryptData("MES0091",decryStream)
		s resultString=##class(web.DHCENS.BLL.Invoice.RSAUtil).RSADecrypt(decryString)
		s resultobj=##class(%GlobalCharacterStream).%New()    //拿到返回值后需要做UTF-8的转码
		;s resultString=$tr(resultString,"\","")
		s resultString=$zcvt(resultString,"I","UTF8")
		d resultobj.Write(resultString)
	    b ;resultobj
	    do ##class(ext.util.JsonObject).JSONStreamToObject(resultobj,.ResOutput,"")
	    if (ResOutput.resultCode="000000") d
	    .s RtnFlg="0"
	    else  d
	    .s RtnFlg="-1"
	    .s ErrMsg=ResOutput.resultMsg
    }else{
	    ;s ResOutput.resultCode="-1"
	    ;s ResOutput.resultMsg="服务无响应"
    }
    
    
    Quit RtnFlg
UploadRequestZJA
	set $ZT=""
	set OutputObj=##class(BILL.EINV.DTO.ZJA.EInvoiceRes).%New()
	set Stream=##class(%GlobalCharacterStream).%New()
	set OutputObj.resultCode="-99999"
	;set OutputObj.resultMsg="程序处理错误:"_$ZERROR
	do ##class(ext.util.JsonObject).ObjectToJSONStream(OutputObj,.Stream)
	set ResOutput=Stream.Read()
	quit ResOutput
}

/// w ##class(BILL.EINV.BI.ZJA.HTTPRequest).GetPDFFile(12345)
/// ceshi 
ClassMethod GetPDFFile(PrtRowid As %String = "") As %String
{
	s Rtn=""
	s $zt="GetPDFFile"
	set HttpRequest=##class(%Net.HttpRequest).%New()
	set HttpRequest.Timeout=5			;服务延时
	;set HttpRequest.Server=ObjUPConfig.IUCServer					;票据服务器地址
	;set HttpRequest.Port=ObjUPConfig.IUCPort						;端口号
	set HttpRequest.ContentCharset="UTF-8"									;编码字符集
	set ServerPath="http://192.168.0.69:81/filedacx/file/getfilestream/byid/4873f59497cd43ef8eed99d4bd0b9eec/dzfp.pdf.do" 
	Do HttpRequest.Get(ServerPath)
	Set ContentInfo=HttpRequest.HttpResponse.ContentInfo
 	Set StatusCode=HttpRequest.HttpResponse.StatusCode
 	Set DataStream=HttpRequest.HttpResponse.Data
 	b ;2323
 	
 	If DataStream'="" {
	 	set InputStr=DataStream.Read(DataStream.Size)
	 	b ;555
	    ;set Data=##class(web.Util.Encryption).Base64Decode(InputStr,"UTF8")
	    b ;
	 	s outfile=##class(%FileBinaryStream).%New()
	    s outfile.Filename="d:\dthealth\app\dthis\web\pdf\"_PrtRowid_".pdf"
	    d outfile.Write(DataStream)
	    s sc=outfile.%Save()
	    b ;;99999
	    set Rtn=Data
	}else{
		s Rtn="-1"
	}
	q Rtn
GetPDFFile
   set Rtn="-1"
   q Rtn
}

}
