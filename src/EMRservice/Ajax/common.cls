/// desc:       公共ajax代理
/// creator:    candy
/// createdate: 2015-5-12
Class EMRservice.Ajax.common Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean
{
    //增加基础平台方法调用，解决后台方法无法获取Session问题
    d ##Class(websys.SessionEvents).SessionExpired()
	if ##class(websys.Conversions).IsValidClassName("websys.Filter") 
	{
		d ##class(websys.Filter).InjectionFilter()
	}
 	quit $$$OK
}

ClassMethod OnPage() As %Status
{
	s class = $Get(%request.Data("Class",1),"")
	s method = $Get(%request.Data("Method",1),"")
	s outputType = $Get(%request.Data("OutputType",1),"")
	s param = ""
	s name = "o"
	
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
