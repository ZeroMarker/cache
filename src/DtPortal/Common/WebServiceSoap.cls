Class DtPortal.Common.WebServiceSoap Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Each web service needs to supply this parameter.
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// This is the name of our web service.
/// Each web service needs to supply this parameter.
Parameter SERVICENAME = "WebServicePortalSoap";

/// 结果集
Property Source As %ResultSet;

/// w ##class(DtPortal.Common.WebServiceSoap).GetWebserviceDataByXml("","<Request><Header><SourceSystem>SYS0001</SourceSystem><MessageID></MessageID></Header><Body><type>query</type><clsName>DtPortal.Common.PortalSoap</clsName><queryName>getUserData</queryName><parameterStr>2♕30</parameterStr></Body></Request>")
ClassMethod GetWebserviceDataByXml(aType As %String, params As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	/*
	s params="<Request><Header><SourceSystem>30</SourceSystem><MessageID></MessageID></Header><Body>"
	s params=params_"<type>GetClassMethodData</type>"
	s params=params_"<clsName>DtPortal.MD.MD01Focus.MD0100FocusNum</clsName>"
	s params=params_"<methodName>MD010001</methodName>"
	s params=params_"<parameterStr>2"_$C(9813)_"30"_"</parameterStr>"
	s params=params_"</Body></Request>"
	*/
	set responseStream=##class(%GlobalCharacterStream).%New()
	set type="",clsName="",queryName="",parameterStr="",serviceCode=""
	try{
		set tSC=##class(%XML.XPATH.Document).CreateFromStream(params,.tDocument)
		if $$$ISERR(tSC) {
			
			set ResponseString="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>"_-1_"</ResultCode><ResultContent>"_"<![CDATA["_tSC_"]]>"_"</ResultContent></Body></Response>"
			set responseStream=##class(%GlobalCharacterStream).%New()
			d responseStream.Write(ResponseString)
		}else{
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/type","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set type=tRes.GetAt(1).Value
			}
			set tSC=tDocument.EvaluateExpression("/Request/Body/clsName","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set clsName=tRes.GetAt(1).Value
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/methodName","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set queryName=tRes.GetAt(1).Value
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/parameterStr","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set parameterStr=tRes.GetAt(1).Value
				
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/serviceCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set serviceCode=tRes.GetAt(1).Value
				
			}
			s serviceCodeStream=##class(%GlobalCharacterStream).%New()
			d serviceCodeStream.Write(serviceCode)
			s parameterStream=##class(%GlobalCharacterStream).%New()
			d parameterStream.Write(parameterStr)
			if (type="GetQueryData"){
				s dataStream=##class(DtPortal.Common.Data2JsonService).GetQueryData(clsName, queryName , parameterStream , serviceCodeStream )
				
				
			}elseif (type="GetClassMethodData"){
				s dataStream=##class(DtPortal.Common.Data2JsonService).GetClassMethodData(clsName, queryName , parameterStream , serviceCodeStream )
			}
		}
	}catch{
		
		
		//set ResponseString="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>"_-1_"</ResultCode><ResultContent>"_"<![CDATA["_$ze_"]]>"_"</ResultContent></Body></Response>"
		
		
		s errStr=$tr($ze,"""","'")
		//s errData="{""status"":-1,""errMSG"":""程序错误，类："_clsName_"，方法："_queryName_"，参数："_parametersTemp_"(转为^分割符输出)"",""data"":[],""total"":""0""}"
		s errData="{""status"":-1,""errMSG"":"_$c(34)_errStr_$c(34)_",""data"":[],""total"":""0"",""clsName"":"_$c(34)_clsName_$c(34)_",""clsMethod"":"_$c(34)_queryName_$c(34)_",""parameters"":"_$c(34)_parameters_$c(34)_",""serviceCode"":"_$c(34)_serviceCode_$c(34)_"}"
		set dataStream=##class(%GlobalCharacterStream).%New()
		d dataStream.Write(errData)
		
	}
	q dataStream
}

}
