Class dhcserviceclient.CA.HBCAImageHttp2 Extends %RegisteredObject
{

/// This is the completed URL to access the http gateway. E.g. http://ip:port/ssoworker
Parameter Location As %String = "http://10.220.8.68:9230/";

/// This is the name of the Service
Parameter ServiceName As %String = "/UkeyToImage/image-getBase64";

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

/// 获取签章信息
Method GetImage(sealName As %String) As %String [ WebMethod ]
{
	//s sealName = "DR006"
	s httprequest=..NewHttpReq()
	s httprequest.ContentType="application/x-www-form-urlencoded"
	d httprequest.SetParam("workid",sealName)
	d httprequest.Post(..ServiceName)
	
	s response=httprequest.HttpResponse
	s (ret, content, jsonObj) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {  }
		else {
			while (ret.AtEnd = 0) { s content=content_ret.Read(32000)}
		}
	}
	s content = $ZSTRIP(content,"*C")
	q content
	
	/*s Stream= ##Class(%GlobalCharacterStream).%New()
	d Stream.Write(content)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s tmpobj = objJson.Deserialize(Stream)

	s respValue = tmpobj.GetAt("content")
	q respValue*/
}

}
