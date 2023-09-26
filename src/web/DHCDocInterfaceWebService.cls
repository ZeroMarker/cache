/// Author：李旭  
/// CreatDate：2022-02-09
/// Description：为HIS对外提供WebService服务的统一入口
Class web.DHCDocInterfaceWebService Extends %SOAP.WebService
{

/// WebService 的名称.
Parameter SERVICENAME = "DocWebService";

/// TODO:将此更改为实际 SOAP 命名空间.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 命名空间 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Desc：提供统一的webservice供外部调用
/// Input：KeyName：表Doc_InterfaceMethod的接口代码、ParamStr:入参串、ParamExtStr:扩展入参串
ClassMethod DHCWebInterface(KeyName As %String, ParamStr As %Stream.GlobalCharacter, ParamExtStr As %Stream.GlobalCharacter = "") As %Stream.GlobalCharacter [ WebMethod ]
{
	s $zt="DHCWebInterfaceErr"
	s RowID=$o(^User.DocInterfaceMethodI("methodCode",KeyName,""))
	s:RowID'="" methodInput=$lg($g(^User.DocInterfaceMethodD(RowID)),13)
	
	s @("Input1")=KeyName
	s tmpInput="Input1"
	for len=1:1:$l($g(methodInput),$c(28)) {
		s type=$p($p($g(methodInput),$c(28),len),$c(14),1)
		continue:(len>2)||(type="")	;最大只提供两个入参
		;解析维护的入参
		if (type'="%Stream.GlobalCharacter") {
			s:len=1 ParamStr=ParamStr.Read(30000)
			s:len=2 ParamExtStr=ParamExtStr.Read(30000)
		}
		s @("Input2")=ParamStr
		s @("Input3")=ParamExtStr
		s tmpInput=tmpInput_","_"Input"_(len+1)
	}
	;s Ret=##class(web.DHCDocInterfaceMethod).WebServiceInterface(KeyName,ParamStr,ParamExtStr)
	;不直接调用，避免参数个数不匹配
	s exeStr="Ret=##class(web.DHCDocInterfaceMethod).WebServiceInterface("_tmpInput_")"
	s @exeStr
	s Ret=@"Ret"
	d ##class(web.DHCDocInterfaceLog).SaveInterfaceLog(KeyName,"",Ret,ParamStr,ParamExtStr)
	
	s OutPut=..FormatOutPut(KeyName,Ret)
	Q OutPut

DHCWebInterfaceErr
	s $zt=""
	s OutPut=..FormatOutPut(KeyName,$ze)
	Q OutPut
}

/// w ##class(web.DHCDocInterfaceWebService).FormatOutPut("1","-1^方法不存在")
ClassMethod FormatOutPut(KeyName, Data) As %Stream.GlobalCharacter
{
	s $zt="FormatOutPut"
	Q:$isobject(Data) Data

	;字符串需判断是否是异常数据
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i ($e(Data,1,3)="-1^"){
		;失败信息
		s msg=$e(Data,4,$l(Data))
		i $e(msg,1)'="<"{
			s msg=##class(web.DHCDocInterfaceMethod).FormatMethodOutPut(KeyName,msg,"web")
			i $e(msg,1)'="<" s msg="<Response><Code>-1</Code><Desc>"_msg_"</Desc></Response>"
		}
		d Stream.Write(msg)
	}else{
		d Stream.Write(Data)
	}
	Q Stream

FormatOutPut
	s $zt=""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write(Data)
	Q Stream
}

}
