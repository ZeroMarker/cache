/// web.DHCEkg.Interface.EkgWebService
Class web.DHCEkg.Interface.EkgWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "EkgWebService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
/// w ##class(web.DHCEkg.Interface.EkgWebService).Test()
ClassMethod Test() As %String [ WebMethod ]
{
	s className="web.DHCEkgWebServiceNew"
	s methodName="GetOrdInfoByID"
	s @"InputParameter"="580||71"
	s exestr="rtn=##class("_className_")."_methodName_"(InputParameter)"
	s @exestr
	s outputContent=@"rtn"
	q outputContent
}

/// Creator：		yangyali 
/// CreatDate：		2018-5-22
/// Description：	提供接口调用统一入口
/// Table：
/// Input：			KeyName:方法参数,InputParameter:参数
/// Return：		0^成功
/// Others：		w ##class(web.DHCENS.EnsWebService).DHCWebInterface("GETPATINFO","1")
ClassMethod EKGWebInterface(KeyName As %String, InputParameter As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	s $zt="err"
	s n = $zu(41)
	s method = $zu(41,n-2)	
	s proc = ##class(%SYS.ProcessQuery).%OpenId($j)
	s ip = proc.StartupClientIPAddress
	s proc=""
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^方法代码为空!")
	q:(""=KeyName) stream
	s rowId=$o(^User.EnsInterfaceMethodI("MethodCode","webMethod", KeyName,""))
	s methodObj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
	if '$isobject(methodObj){
		d stream.Write("-1^方法不存在!")
		q stream
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		d stream.Write("-1^方法未启用!")
		q stream
	}
	s className=methodObj.methodClassName
	s methodName=methodObj.methodName
	s inputType=$p($p(methodObj.methodInput,$char(28),1),$char(2),1)
	s inputDesc=$p($p(methodObj.methodInput,$char(28),1),$char(2),3)
	s OutputType=$p($p(methodObj.methodOutput,$char(28),1),$char(2),1)
	s OutputDesc=$p($p(methodObj.methodOutput,$char(28),1),$char(2),2)
	s @"KeyName"=rowId
	s @"Method"=method
	s @"Ip"=ip
	s @"PerStream"=InputParameter
	s @"InputDesc"=inputDesc
	s exeStr="ensRtn=##class(web.DHCENS.STBLL.UTIL.EnsInterface).InsertEnsInterface(KeyName,Method,Ip,PerStream,InputDesc)"
	s @exeStr
	set resultStr=@"ensRtn"
	if inputType="%GlobalCharacterStream" {
		s @"InputParameter"=InputParameter
		s exeStr="rtn=##class("_className_")."_methodName_"(InputParameter)"
	}
	else {
		s @"InputParameter"=InputParameter.Read(InputParameter.Size)
		s exeStr="rtn=##class("_className_")."_methodName_"(InputParameter)"
	}
	s methodObj=""
	s @exeStr
	if OutputType="%GlobalCharacterStream" {
		set result=@"rtn"
		set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"Y",result)
		q result
	}
	else {
		set outputContent=@"rtn"
		set stream=##class(%GlobalCharacterStream).%New()
		d stream.Write(outputContent)
		set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"Y",stream)
		Quit stream
	}
err
	set resultStr=@"ensRtn"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"N",stream)
	q stream
}

}
