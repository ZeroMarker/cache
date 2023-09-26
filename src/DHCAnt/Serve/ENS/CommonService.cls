/// CTOR: QP
/// DATE: 2018-08-10
/// DESC: 抗菌药物对外公共Service [V4.1.0++]
Class DHCAnt.Serve.ENS.CommonService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "CommonService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// CTOR: QP
/// SENO: C0001
/// DATE: 2018-08-10
/// DESC: 变更医师开具抗菌药物权限 【医师资质系统】
/// IN  : "医师工号^抗菌药code^开立权限!医师工号^抗菌药code^开立权限"
/// NOTE: http://127.0.0.1:57772/dthealth/web/DHCAnt.Serve.ENS.CommonService.cls?wsdl
/// OUT : 1:更新成功   其他：更新失败
Method ChangeDocAuthority(input) As %String [ WebMethod ]
{
	set mRtn=##class(DHCAnt.Serve.ComOut).ChangeDocAuthority(input)
	Quit mRtn
}

}
