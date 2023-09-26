/// BDP.BDPInterfaceWebService
Class BDP.BDPInterfaceWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// http://localhost/imedical/web/BDP.BDPInterfaceWebService.cls?wsdl
/// WebService 的名称.
Parameter SERVICENAME = "BDPInterfaceWebService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// 描述：HR同步入院信息到HIS，同时保存当前登录科室
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年2月11日
/// Input：工号^姓名^安全组^科室代码^科室描述^医护人员类型^资格证书号^密码^开始日期^结束日期
/// (工号，姓名，安全组，科室代码，科室描述，密码，开始日期不能为空；日期格式为xxxx-xx-xx)
/// (医护人员类型不为空，则同时新增关联医护人员，否则仅新增用户)
/// 
/// w ##class(BDP.BDPInterfaceWebService).%New().SaveSSUser("YH01^用户01^门诊部^KESHI01^科室01^主任医师^1000001^123^2020-02-11^")
Method SaveSSUser(datastr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.BDP.BDPInterface).SaveSSUser(datastr)
	q result
}

/// 描述：HR信息时，同步到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年2月10日
/// Input：CTLOCCode^CTLOCDesc^CTLOCType^CTLOCAddress^CTLOCDep^CTLOCHospital^CTLOCTelephone^CTLOCDateFrom^CTLOCDateTo
/// 科室代码，科室描述，科室类型，开始日期不能为空
/// w ##class(BDP.BDPInterfaceWebService).%New().SaveCTLoc("KESHI01^科室01^E^门诊楼一楼^门急诊科室^东华标准版数字化医院[总院]^0707007^2020-02-06^")
Method SaveCTLoc(datastr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.BDP.BDPInterface).SaveCTLoc(datastr)
	q result
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生维护轮转科室时，同步科室信息到HIS；若HIS没有该用户，则新增用户
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^医护人员类型^资格证书编号^密码^科室代码^科室描述^安全组^开始日期^结束如期
/// 工号，姓名，密码，科室代码，科室描述，安全组，开始日期不能为空；日期格式为xxxx-xx-xx
/// Debug：w ##class(BDP.BDPInterfaceWebService).%New().SyncSSUserAndLogonLoc("JKCSV1^接口测试V1^学生^00014455^1^ZYMZ001^呼吸内科门诊^其他^2020-01-11^2020-03-01")
Method SyncSSUserAndLogonLoc(datastr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.BDP.BDPInterface).SyncSSUserAndLogonLoc(datastr)
	q result
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生注册信息时，同步基本信息到HIS用户
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月2日
/// Input：工号^姓名^安全组^医护人员类型^资格证书号^密码^开始日期^结束日期
/// (工号，姓名，安全组，开始日期不能为空；日期格式为xxxx-xx-xx)
/// (医护人员类型不为空，则同时新增关联医护人员，否则仅新增用户；资格证书号仅存到关联医护人员里)
/// Debug：w ##class(BDP.BDPInterfaceWebService).%New().AddSSUser("JKCSV1^接口测试V1^其他^学生^12321^1^2019-11-27^")
Method AddSSUser(datastr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.BDP.BDPInterface).AddSSUser(datastr)
	q result
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生出院时，同步结束日期到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^结束日期，都不能为空，日期格式为xxxx-xx-xx)
/// Debug：w ##class(BDP.BDPInterfaceWebService).%New().EndSSUser("JKCSV1^接口测试V1^2020-01-10")
Method EndSSUser(datastr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.BDP.BDPInterface).EndSSUser(datastr)
	q result
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生维护轮转科室时，同步科室信息到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^科室代码^科室描述^安全组^科室轮转开始日期^科室轮转结束如期
/// 工号，姓名，科室代码，科室描述，安全组，开始日期不能为空；日期格式为xxxx-xx-xx
/// Debug：w ##class(BDP.BDPInterfaceWebService).%New().AddLogonLoc("JKCSV1^接口测试V1^ZYMZ001^呼吸内科门诊^其他^2019-11-27^")
Method AddLogonLoc(datastr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.BDP.BDPInterface).AddLogonLoc(datastr)
	q result
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：修改调整规培生出科日期时调用，同步该科室结束日期到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^科室代码^科室描述^安全组^科室轮转结束如期，都不能为空；日期格式为xxxx-xx-xx
/// Debug：w ##class(BDP.BDPInterfaceWebService).%New().EndLogonLoc("JKCSV1^接口测试V1^ZYMZ001^呼吸内科门诊^其他^2019-12-27")
Method EndLogonLoc(datastr As %String) As %String [ WebMethod ]
{
	s result=##class(web.DHCBL.BDP.BDPInterface).EndLogonLoc(datastr)
	q result
}

}
