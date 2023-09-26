/// web.DHCEkg.Interface.HIS.EkgToThirdHis
Class web.DHCEkg.Interface.HIS.EkgToThirdHis Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "EkgToThirdHis";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// 方法说明：	把医嘱信息保存到心电数据库
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-19
/// 入参：		申请单信息(xml流), 医嘱项信息(xml流)
/// 返回值：	保存结果(xml流)
/// w ##class(web.DHCEkg.Interface.HIS.EkgToThirdHis).SaveAppToEKG(param)
ClassMethod SaveAppToEKG(SaveAppInfo As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $namespace
	s CurrentSpace=$znspace
	;d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	zn "dhc-ekg"
	s saveString=##class(Interface.HIS.Service.EKGService).SaveAppToEKG(SaveAppInfo)
	zn CurrentSpace
	q saveString
}

/// 方法说明：	查询报告路径
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-19
/// 入参：		申请单ID(医嘱唯一标识)
/// 返回值：	报告信息(xml流)
/// w ##class(web.DHCEkg.Interface.HIS.EkgToThirdHis).GetImgUrlByHISAPPID("")
ClassMethod GetImgUrlByHISAPPID(HISAPPID As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $namespace
	s CurrentSpace=$znspace
	;d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	zn "dhc-ekg"
	s getString=##class(Interface.HIS.Service.EKGService).GetImgUrlByHISAPPID(HISAPPID)
	zn CurrentSpace
	q getString
}

}
