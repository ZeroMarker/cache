/// dhcservice.Interface
Class dhcservice.Interface Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "dhcInterface";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 调用Cache中类方法<br>
/// methodCode : 类方法对应代码<br>
/// p1,p2,p3...p16为要调用的类方法入参
Method invoke(methodCode, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %String [ WebMethod ]
{
	; Set ^Wanghc("ws","Interface",1)=methodCode
	if methodCode="" quit "NullMethodCode"
	if (methodCode[":"){
		Set cn = $p(methodCode,":")
		Set mn = $p(methodCode,":",2)
	}else{
		; 通过medthodcode找到类名与方法名
		Set mobj = ##class(websys.DHCInterface).CodeIndexOpen(methodCode,0)
		if 'mobj.AllowWSInvoke Set mobj="" Quit "NotAllowWSInvoke"
		Set cn = mobj.Cls
		Set mn = mobj.Mth
		do mobj.%Close()
		Set mobj=""
	}
	Quit:(cn="")||(mn="") "MethodCodeError"
	Quit:'##class(websys.Conversions).IsValidMethodName(cn,mn) "NotValidMethodName"
	Set myobj=##class(%Dictionary.CompiledMethod).%OpenId(cn_"||"_mn,0)
	Quit:'$IsObject(myobj) "OpenMethodError"
	s mycminlist=myobj.FormalSpecParsed d myobj.%Close() set myobj = ""
	s pcount=$ll(mycminlist)
	; Set ^Wanghc("ws","Interface",2)=pcount
	; Set ^Wanghc("pcount")=$lb(pcount,methodCode,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
	; 为了性能与解析统一 写成 if
	if (pcount=0) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn)
	if (pcount=1) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1)
	if (pcount=2) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2)
	if (pcount=3) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3)
	if (pcount=4) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4)
	if (pcount=5) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5)
	if (pcount=6) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6)
	if (pcount=7) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7)
	if (pcount=8) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8)
	if (pcount=9) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9)
	if (pcount=10) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
	if (pcount=11) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
	if (pcount=12) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
	if (pcount=13) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	if (pcount=14) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14)
	if (pcount=15) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)
	if (pcount=16) Quit ##class(websys.Configuration).CSPServerConnect(cn,mn,p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
	Quit "ParamCountError"
}

}
