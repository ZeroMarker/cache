/// 为HIS对外提供WebService服务的统一入口
Class web.DHCENS.EnsWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "EnsWebService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// Creator：WuXianPu
/// CreatDate：2012—03-06
/// Description：平台提供给其他产品组调用统一入口
/// Table：Ens_Interface
/// Input：Input:方法参数,KeyName:事件参数
/// Return：0^成功
/// Others：w ##class(web.DHCENS.EnsWebService).DHCWebInterface("GETPATINFO","1")
ClassMethod DHCWebInterface(KeyName As %String, InputParameter As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
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
	//set resultStr=@"ensRtn"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	//set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"N",stream)
	q stream
}

ClassMethod SavePatientInfo(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set result=##class(web.DHCInsertPatient).PatientRegistry(inputContent,"")
	Quit result
}

// w ##class(web.DHCENS.EnsWebService).Test()

ClassMethod Test()
{
	set inputStream=##class(%GlobalCharacterStream).%New()
	do inputStream.Write("<Request><Header></Header><Body><CT_IdentifierTypeList><CT_IdentifierType><CTIT_Code>01</CTIT_Code><CTIT_Desc>居民身份证</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType><CT_IdentifierType><CTIT_Code>02</CTIT_Code><CTIT_Desc>居民户口簿</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType><CT_IdentifierType><CTIT_Code>03</CTIT_Code><CTIT_Desc>护照</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType><CT_IdentifierType><CTIT_Code>04</CTIT_Code><CTIT_Desc>军官证</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType><CT_IdentifierType><CTIT_Code>05</CTIT_Code><CTIT_Desc>驾驶证</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType><CT_IdentifierType><CTIT_Code>06</CTIT_Code><CTIT_Desc>港澳居民来往内地通行证</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType><CT_IdentifierType><CTIT_Code>07</CTIT_Code><CTIT_Desc>台湾居民来往内地通行证</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType><CT_IdentifierType><CTIT_Code>99</CTIT_Code><CTIT_Desc>其他法定有效证件</CTIT_Desc><CTIT_CodesystemCode>CT_IdentifierType</CTIT_CodesystemCode><CTIT_Status>1</CTIT_Status><CTIT_UpdateUserCode>无</CTIT_UpdateUserCode><CTIT_Remarks>无</CTIT_Remarks></CT_IdentifierType></CT_IdentifierTypeList></Body></Request>")
	
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_IdentifierType",inputStream)
	
	//set soap=##class(DHC.Register.REG0002.SOAP.EnsWebServiceSoap).%New()
	//set stream=..DHCWebInterface("W00000008",inputStream)
	b ;kk
}

}
