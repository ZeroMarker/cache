/// web.DHCBL.MKB.SDSDiagnosService
Class web.DHCBL.MKB.SDSDiagnosService Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter LOCATION = "http://127.0.0.1/imedical/web/";

/// WebService 的名称.
Parameter SERVICENAME = "SDSDiagnosService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Description：获取授权
/// Return：Y/N
Method GetAuthorize() As %String [ WebMethod ]
{
	s mkbData=##class(web.DHCBL.MKB.MKBPreferences).GetValueData()
	s result=$p(mkbData,"^",3)
	q result
}

/// Description：判断诊断是否可结构化
/// Input：诊断描述，多个以^分隔
/// Return：true/false  全部不能结构化则返回false，否则返回true
Method GetStructDiagnosExists(desc As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetStructDiagnosExists(desc)
	q result
}

/// Description：医生站诊断保存成功后后台调用基础数据平台接口存储关联表信息及引用日志
/// Input：患者登记号，就诊号，医生站标识，引用场景，诊断串医生站诊断id^结构化诊断id，多个以&分隔
/// Return：true/false
Method SaveStructDiagnosRef(MRInfo As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.MKB.SDSDiagnosInterface).SaveStructDiagnosRef(MRInfo)
	q result
}

/// Description：医生站诊断删除同步删除结构化诊断
/// Input：就诊号; 医生站诊断表id串，多个以^分隔
/// Return：true/false
Method DeleteStructDiagnos(ADMNo As %String, DiagItemRowStr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.MKB.SDSDiagnosInterface).DeleteStructDiagnos(ADMNo, DiagItemRowStr)
	q result
}

}
