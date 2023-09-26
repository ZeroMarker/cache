Class EMRservice.BL.CDSSService Extends %RegisteredObject
{

/// yhy
/// w ##Class(EMRservice.BL.CDSSService).ConvertPython()
ClassMethod ConvertPythonHTTP(Avalue As %ArrayOfDataTypes, Uniquekey)
{
	s content=Avalue
	
	s NlpServer =##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("NlpServer")
	q:(NlpServer="")||($l(NlpServer,".")'=4)||($l(NlpServer,":")'=2) "ParamsErr"
	
	s req = ##class(%Net.HttpRequest).%New()
    s req.Server = $p(NlpServer,":",1)
    s req.Port=$p(NlpServer,":",2)
	s req.ContentType="application/x-www-form-urlencoded"
	s req.Timeout=2
	s response=""
    d req.SetParam("data",content)
	s err = ""
    s flag= req.Post("/tag")
    If $system.Status.IsError(flag) 
    {
	    // 如果响应产生错误，^CacheTempResponseFlag改为0，其它调用这个接口的方法，先检查一下^CacheTempResponseFlag，如果为0，则停止调用
	    s ^CacheTempResponseFlag=0  
	    Quit ""
    }
    If '$IsObject(req.HttpResponse) {
        s err = "Response Error"
        Quit ""
    }

    If '$IsObject(req.HttpResponse.Data) {
        s err = "Data Error"
        Quit ""
    }
    Set response = req.HttpResponse.Data
    d response.Rewind()
	s result=""
	while (response.AtEnd = 0)
	{
		s length = 1024
		s result =result_response.Read(length)
	}
	q result
}

/// w ##Class(EMRservice.BL.CDSSService).ConvertPython("腹痛")
ClassMethod ConvertPython(Content As %String, Uniquekey As %String)
{
	s NlpServer =##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("NlpServer")
	q:(NlpServer="")||($l(NlpServer,".")'=4)||($l(NlpServer,":")'=2) "ParamsErr"
	s httprequest = ##class(%Net.HttpRequest).%New()
	//s httprequest.Timeout = 3
	s httprequest.Server = $p(NlpServer,":",1)
	s httprequest.Https = 1
	s httprequest.Port = $p(NlpServer,":",2)
	d httprequest.SetHeader("Content-Type","application/x-www-form-urlencoded;charset=utf8")
	s httprequest.SSLConfiguration="SSLECP"
	s httprequest.SSLCheckServerIdentity = 0
	d httprequest.InsertFormData("data",Content)
	s src=httprequest.Post("/tag")
	If $system.Status.IsError(src) 
    {
	    set err = $system.Status.GetErrorText(src)
	    s ^CacheTempResponseFlag(Uniquekey)=0
	    Quit err
    }
	s retStream=httprequest.HttpResponse.Data	
	d retStream.Rewind()
	s result=""
	while (retStream.AtEnd = 0)
	{
		s length = 1024
		s result =result_retStream.Read(length)
	}
	q result
}

/// w ##Class(EMRservice.BL.CDSSService).ConvertPythonOld1("")
ClassMethod CDSSCheck(Avalue As %String, UniqueKey)
{
	q:$g(^CacheTempCDSSResFlag(UniqueKey))=0 ""
	s CDSSServer =##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("CDSSServer")
	q:(CDSSServer="")||($l(CDSSServer,".")'=4)||($l(CDSSServer,":")'=2) ""
	s req = ##class(%Net.HttpRequest).%New()
    s req.Server =$p(CDSSServer,":",1)
    s req.Port=$p(CDSSServer,":",2)
	s req.Https = 1
    Do req.SetHeader("Content-Type","application/json;charset=UTF-8")
	s req.SSLConfiguration="SSLECP"
	s req.SSLCheckServerIdentity = 0
    d req.EntityBody.Write(Avalue)
	set flag = req.Post("/api/recommend")

	s err = ""
    If $system.Status.IsError(flag) 
    {
	    set err = $system.Status.GetErrorText(flag)
	    s ^CacheTempCDSSResFlag(UniqueKey)=0
	    Quit ""
    }
    If '$IsObject(req.HttpResponse) {
        s err = "Response Error"
        Quit ""
    }
    If '$IsObject(req.HttpResponse.Data) {
        s err = "Data Error"
        Quit ""
    }
    Set response = req.HttpResponse.Data

    d response.Rewind()
	s result=""
	while (response.AtEnd = 0)
	{
		s length = 1024
		s result =result_response.Read(length)
	}
	s result=$zconvert(result,"I","UTF8")
	
	q result
}

/// w ##Class(EMRservice.BL.CDSSService).GetCDSSDiagBySymptom("")
ClassMethod GetCDSSDiagBySymptom(AContent As %String, AWeight As %String = "")
{
	s CDSSServer =##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("CDSSServer")
	q:(CDSSServer="")||($l(CDSSServer,".")'=4)||($l(CDSSServer,":")'=2) ""
	s httprequest = ##class(%Net.HttpRequest).%New()
	s httprequest.Server =$p(CDSSServer,":",1)
	s httprequest.Https = 1
	s httprequest.Port ="8080"
	Do httprequest.SetHeader("Content-Type","application/json")
	s httprequest.SSLConfiguration="SSLECP"
	s httprequest.SSLCheckServerIdentity = 0
	d httprequest.InsertParam("ChiefCompSum", $zconvert(AContent,"O","URL"))
	d httprequest.InsertParam("Weight",$zconvert(AWeight,"O","URL"))
	s src=httprequest.Get("/EmrRecordSuspectedDisease")
	If $system.Status.IsError(src) 
    {
	    set err = $system.Status.GetErrorText(src)
	    Quit ""
    }
	s retStream=httprequest.HttpResponse.Data	
	d retStream.Rewind()
	s result=""
	while (retStream.AtEnd = 0)
	{
		s length = 1024
		s result =result_retStream.Read(length)
	}
	s result=$zconvert(result,"I","UTF8")
	q result
}

}
