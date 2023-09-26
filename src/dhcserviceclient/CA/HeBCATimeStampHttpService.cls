Class dhcserviceclient.CA.HeBCATimeStampHttpService Extends %RegisteredObject
{

/// This is the completed URL to access the http gateway. E.g. http://ip:port/ssoworker
Parameter Location As %String = "http://172.18.2.74:8080/tsaservice/";

/// This is the name of the Service
Parameter ServiceName As %String = "/tsaservice";

/// This is the URL used to access the http gateway
Property Location As %String [ InitialExpression = {..#Location}, Transient ];

/// This is the name of the Service
Property ServiceName As %String [ InitialExpression = {..#ServiceName}, Transient ];

Method NewHttpReq() As %Net.HttpRequest
{
	s request = ##class(%Net.HttpRequest).%New()
	s request.OpenTimeout = 10
	s request.Timeout = 10
	s request.Server = $p($p(##this.Location,"/",3),":",1)
	s request.Port   = $p($p(##this.Location,":",3),"/",1)
	
	q request
}

Method CreateTimeStamp(originalData As %String) As %String [ WebMethod ]
{
	s httprequest=..NewHttpReq()
	//s httprequest.ContentType="text/html;"
	//s httprequest.ContentCharset = "ASCII"
	d httprequest.InsertFormData("original",originalData)
	s service = ..ServiceName_"/interface/v1/timestamp/make"
	d httprequest.Post(service)
	
	s response=httprequest.HttpResponse
	s (ret, content, jsonObj) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {  }
		else {
			while (ret.AtEnd = 0) { s content=content_ret.Read(32000)}
		}
	}

	s Stream= ##Class(%GlobalCharacterStream).%New()
	d Stream.Write(content)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s tmpobj = objJson.Deserialize(Stream)

	//获取接口状态，为0时为成功
	s Status = tmpobj.GetAt("status")
	q:(Status'="0") ""
	
	s respValue = tmpobj.GetAt("data").GetAt("resp")
	q respValue
}

Method VerifyTimeStamp(originalData As %String, timeStampString As %String) As %String [ WebMethod ]
{
	s httprequest=..NewHttpReq()
	//s httprequest.ContentType="text/html;"
	//s httprequest.ContentCharset = "ASCII"
	d httprequest.InsertFormData("original",originalData)
	d httprequest.InsertFormData("resp",timeStampString)
	d httprequest.Post(..ServiceName_"/interface/v1/timestamp/verify")
	
	s response=httprequest.HttpResponse
	
	s (ret, content, jsonObj) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {  }
		else {
			while (ret.AtEnd = 0) { s content=content_ret.Read(32000)}
		}
	}
	
	s Stream= ##Class(%GlobalCharacterStream).%New()
	d Stream.Write(content)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s tmpobj = objJson.Deserialize(Stream)

	//q tmpobj.GetAt("data").GetAt("gentime")_tmpobj.GetAt("data").GetAt("sn")
	//返回验证结果，0为成功，其余失败
	s Status = tmpobj.GetAt("status")
	q Status
}

}
