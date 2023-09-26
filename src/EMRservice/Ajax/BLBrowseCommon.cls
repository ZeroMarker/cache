/// desc:       公共ajax代理
/// creator:    candy
/// createdate: 2015-5-12
Class EMRservice.Ajax.BLBrowseCommon Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean
{
	if ##class(websys.Conversions).IsValidClassName("websys.Filter") 
	{
		d ##class(websys.Filter).InjectionFilter()
	}
 	quit $$$OK
}

ClassMethod OnPage() As %Status
{
	s separator = "-----------------------------8eb5b37251gef"
	if (%request.Method = "POST")
	{
		s paramsStream = ##class(%GlobalBinaryStream).%New()
		d paramsStream.CopyFrom(%request.Content)
		s objJson = ##Class(EMR.ART.COM.Parser.Json).%New()  
		s argInParams = objJson.Deserialize(paramsStream)
		s content = argInParams.GetAt("content")
		s askParam = argInParams.GetAt("askParam")
				
		//请求的数据
		s data = content.GetAt("data")
		s instanID = askParam.GetAt("p1") 
		s uriStr = ##class(web.Util.Encryption).Base64Decode(data)
		//对url进行decode，然后改变字符集编码为utf8
		//s strData = $zcvt($zcvt(uriStr,"I","URL"),"I","UTF-16")
		s uriStr = $replace(uriStr,"+","%2B")
		s strData =$zcvt(uriStr,"I","URL")
		s argInData = ##class(%GlobalBinaryStream).%New()
		d argInData.Write(strData)
		s instanID = $REPLACE(instanID,"_","||")
		//s ^TempContent(instanID) = argInData.Read()
		s strRes = ##class(EMRservice.BL.FtpService).FTPStoreData(instanID,argInData)
		
		q $$$OK
	}
	else
	{
		s class = $Get(%request.Data("Class",1),"")
		s method = $Get(%request.Data("Method",1),"")
		s outputType = $Get(%request.Data("OutputType",1),"")
		s param = ""
		s name = "o"
	}
	
	for
	{
		s name = $Order(%request.Data(name))
		q:(name = "")
		s:(param '= "") param = param_","
		
		//如果入参中包含双引号，替换为2个双引号，保证参数格式。
		s param = param_""""_$replace($Get(%request.Data(name,1),""),"""","""""")_""""
	}
	
	if (""=outputType) 
	{
        s execCode = "##class("_class_")."_method_"("_param_")"
        d @execCode	
        	
	}
    else
    {
        s execCode = "result=##class("_class_")."_method_"("_param_")"
        s @execCode
        s result = @"result" 
        if (outputType = "Stream")
        {
            while (result.AtEnd = 0)
            {
                w $ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2))
            }
        }
        else
        {
            w $ZSTRIP(result,"*C",,$c(1)_$c(2))
        }

	}
	
	
	Quit $$$OK
}

}
