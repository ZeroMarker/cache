Class web.DHCENS.STBLL.REGISTER.UTIL.Common Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：liyan
/// CreatDate：2020-12-11
/// Description：在指定接口类里，生成各个功能的入口方法
/// Input：
/// Others: w ##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).CreateMethod("test003OnReg0001")
ClassMethod CreateMethod(MethodCode As %String = "") As %String
{
	s $zt="Exception"
	s tSC=0
	s cName="web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface"
	s CDef=##class(%Dictionary.ClassDefinition).%OpenId(cName)
	s mName=MethodCode
	set methodcount=CDef.Methods.Count()
	set rowId=0
	for i=1:1:methodcount {
		set methodName=CDef.Methods.GetAt(i).Name
		if methodName=mName {
			set rowId=CDef.Methods.GetAt(i).%Id()
		}
	}
	if rowId'=0 
	{
		s sc=CDef.%Close()
		q "0^方法已存在"
	}
	s MDef=##class(%Dictionary.MethodDefinition).%New()
	s MDef.Name=mName
	s MDef.FormalSpec="inputcontent:%GlobalCharacterStream"
	s MDef.ReturnType="%GlobalCharacterStream"
	s MDef.ClassMethod=1
	s MDef.Description="w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface)."_mName_"(inputcontent)"
	d MDef.Implementation.WriteLine($c(9)_"s $ZTrap = ""SendMessageET""")
	d MDef.Implementation.WriteLine($c(9)_"s currentmethod=##safeexpression(""""""""_$get(%methodname)_"""""""")")
	d MDef.Implementation.WriteLine($c(9)_"s messagecode=$p(currentmethod,""On"",1)")
	d MDef.Implementation.WriteLine($c(9)_"s servicecode=$p(currentmethod,""On"",2)")
	d MDef.Implementation.WriteLine($c(9)_"s methodcode="""",ip="""",port="""",buscode=""""")
	d MDef.Implementation.WriteLine($c(9)_"&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)")
	d MDef.Implementation.WriteLine($c(9)_"s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)")
	d MDef.Implementation.WriteLine($c(9)_"s retstream=##class(%GlobalCharacterStream).%New()")
	d MDef.Implementation.WriteLine($c(9)_"d retstream.Write(returnstring)")
	d MDef.Implementation.WriteLine($c(9)_"q retstream")
	d MDef.Implementation.WriteLine("SendMessageET")
	d MDef.Implementation.WriteLine($c(9)_"s retstream=##class(%GlobalCharacterStream).%New()")
	d MDef.Implementation.WriteLine($c(9)_"d retstream.Write(""-1^""_$ze)")
	d MDef.Implementation.WriteLine($c(9)_"q retstream")
	s tSC1 = CDef.Methods.Insert(MDef)
	q:$$$ISERR(tSC1) tSC1
	s tSC2 = CDef.%Save()
	q:$$$ISERR(tSC2) tSC2
	s tSC3 = $system.OBJ.Compile(cName,"ck/displaylog=0")
	q tSC
Exception
	b ;$ZE
	q -1
}

/// Creator：ZhangXinying
/// CreatDate：2020-12-11
/// Description:http调soap服务
/// Debug:w ##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP("114.116.37.147","80","PUB0003","HIPMessageServer","MES002",stream)
ClassMethod InvokeSOAPViaHTTP(IP As %String, Port As %String, BusCode As %String, MethodCode As %String, MessageCode As %String, inputContent As %GlobalCharacterStream) As %String
{
	s $zt="err",%objlasterror=""
	s req=##class(%Net.HttpRequest).%New()
	s server=IP
	s port=Port
	s url="/csp/hsb/DHC.Published."_BusCode_".BS."_BusCode_".cls"
	s req.Server=server
	s req.Port=port
	d req.SetHeader("Content-Type","text/xml;charset=utf-8")
	d req.SetHeader("SOAPAction","http://dhcc.com.cn/DHC.Published."_BusCode_".BS."_BusCode_"."_MethodCode)
	s inputStream=##class(%Stream.TmpCharacter).%New()
	d inputStream.Write("<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:dhcc=""http://www.dhcc.com.cn"">")
   	d inputStream.Write("<soapenv:Header/><soapenv:Body><dhcc:"_MethodCode_"><dhcc:input1>"_MessageCode_"</dhcc:input1><dhcc:input2>"_"<![CDATA[")
   	d inputStream.CopyFrom(inputContent)
   	d inputStream.Write("]]>""</dhcc:input2></dhcc:"_MethodCode_"></soapenv:Body></soapenv:Envelope>")
    d req.EntityBody.CopyFrom(inputStream)
    s sc=req.Post(url)
    s statusCode=req.HttpResponse.StatusCode
    s repData=req.HttpResponse.Data
    s size=repData.Size
    s repStr=repData.Read(.size,.sc)
    s repStr=$zcvt(repStr,"O","UTF8")
	s namespaceUri="http://www.dhcc.com.cn"
	set Result=""
	set rtnStream=##class(%Stream.TmpCharacter).%New()
	do rtnStream.Write(repStr)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(rtnStream,.tDocument,,,,,"a "_namespaceUri)
	set tSC=tDocument.EvaluateExpression("/SOAP-ENV:Envelope/SOAP-ENV:Body/a:HIPMessageServerResponse/a:HIPMessageServerResult","text()",.tRes)	
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
		set fieldValue=tRes.GetAt(1).Value
		set Result=$tr(fieldValue,$c(0),"")
	}
 	q Result
err
	s errInfo=""
	if %objlasterror=""{
		s errInfo=$system.Status.GetErrorText($ze)
	}else{
		s errInfo=$system.Status.GetErrorText(%objlasterror)
	}
	q errInfo
}

}
