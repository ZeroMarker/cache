/// creator:yunhaibao
/// createdate:2016-09-22
/// description:药库pda webservice方式调数据库,避免占用licence
/// web.DHCSTPDAService.DHCST
Class web.DHCSTPDAService.DHCST Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCSTPDAService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhccdhcst.com.cn";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 数据库地址
Parameter LOCATION = "http://10.8.240.9/dthealth/web";

/// input:类名,方法名,参数,执行类型(查询,)
/// 执行方法,返回流数据
/// 注意:params参数的顺序与对应执行的方法的参数顺序相同
/// 登录:			##class(web.DHCST.Android.Common).logon(username,password)
/// 类组列表:		##class(web.DHCST.Android.Common).GetStkCatGroup("G")
/// 拆包查询:		##class(web.DHCST.Android.UnPack).QueryIncBatPackList(userloc,barcode,"","webservice")
/// 拆包执行: 		##class(web.DHCST.Android.UnPack).UnPack(locdr, inclb, uom, qty, parbarcode) 
/// 药品单位列表:	##class(web.DHCST.Android.UnPack).getUomList(578)
/// 出库类:			web.DHCST.Android.TransferOut.cls
/// 转移接收类:		web.DHCST.Android.TransferIn.cls
/// 依据请求出库类: web.DHCST.Android.TransferByReq.cls
/// w ##class(web.DHCST.Android.Common).GetParamCount("web.DHCST.Android.Common","GetGroupDept")
Method ExecuteMethod(className As %String, methodName As %String, params As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	//s ^yunhaibao("ExecuteMethod")=className_"^"_methodName_","_params
	s params=$tr(params,$c(0),"")
	s executestring="s returndata=##class("_className_")."_methodName_"("
	s parametersNum=##class(web.DHCST.Android.Execute).GetParamCount(className,methodName)
	f i=1:1:parametersNum{
		s parameterName=##class(web.DHCST.Android.Execute).GetParamName(className,methodName,i)
		s parameterVal="" //$g(%request.Data(parameterName,1))
		i params["$$" s parameterVal=$p(params,"$$",i)
		e  i params["!!" s parameterVal=$p(params,"!!",i)
		e  s parameterVal=$p(params,"^",i)
		s executestring=executestring_""""_parameterVal_""""
		i i'=parametersNum s executestring=executestring_","
	}
	s executestring=executestring_")"
	x executestring
	s methodType=##class(web.DHCST.Android.Execute).GetMethodType(className,methodName)
	//i methodType["GlobalCharacterStream" d
	//.s tmpstream=##class(%GlobalCharacterStream).%New()
	//.d tmpstream.CopyFrom(returndata)
	//.s ^yunhaibao("rem",methodName)=tmpstream.Read()
	q:methodType["GlobalCharacterStream" returndata
	s outputstream=##class(%GlobalCharacterStream).%New()
	d outputstream.Clear()
	d outputstream.Write(returndata)
	q outputstream
}

}
