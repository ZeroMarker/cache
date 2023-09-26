Import SQLUser

Class web.DHCXMLPConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##Class(web.DHCBillPrint).InvBillPrintCLSID()
ClassMethod PrintCAB() As %String
{
}

/// NeedCLodop为1时，强制使用CLodop打印
/// d ##Class(web.DHCXMLPConfig).LODOPInit()
ClassMethod LODOPInit(NeedCLodop = "") As %String
{
}

ClassMethod DelByRowID(RowID As %String) As %String
{
}

ClassMethod ReadByFlag(pFlag As %String) As User.DHCXMLPConfig
{
}

ClassMethod ReadByID(RowID As %String) As User.DHCXMLPConfig
{
}

/// /w ##class(%ResultSet).RunQuery("web.DHCXMLPConfig","ReadAll")
Query ReadAll() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,XPC_Flag FROM SQLUser.DHC_XMLPConfig
}

Query XMLPConfigQuery(Name As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "模板名称:%String")
{
	SELECT XPC_Flag FROM SQLUser.DHC_XMLPConfig
	WHERE (XPC_Flag %StartsWith :Name)
}

Query ReadAllByName(Name As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,XPC_Flag,XPC_Note1 FROM SQLUser.DHC_XMLPConfig
	WHERE (%UPPER(XPC_Flag)[%UPPER(:Name) or XPC_Note1[:Name or :Name is null or :Name='')
}

/// w ##class(web.DHCXMLPConfig).AddNewReport("","Test","TestNote")
ClassMethod AddNewReport(xml As %String, flgName As %String, Note As %String) As %String
{
}

ClassMethod UpdateReport(ID As %String, xml As %String, Note As %String) As %Status
{
}

/// 修改名字与描述
ClassMethod ModifyFlagNote(ID, flgName, Note)
{
}

ClassMethod ReadXmlByName(Name As %String) As %String
{
}

ClassMethod ReadXmlByID(RowID As %String) As %String
{
}

ClassMethod ReadXmlStrByName(Name As %String) As %String
{
}

ClassMethod DeleteReportByID(ID As %String) As %Status
{
}

ClassMethod GetIdByName(Name)
{
}

/// Set XMLInfo = ##class(web.DHCXMLPConfig).GetXMLInfo("test")
ClassMethod GetXMLInfo(Name)
{
}

/// 用来查找xml模板中包含某个字符串的模板，例如：
/// find key : CT 检查申请单 in xml : DHCRisBill_CT1 CT检查申请单
/// find key : CT 检查申请单 in xml : DHCAPP_CT CT申请单打印
/// d ##class(web.DHCXMLPConfig).searchXMLModelByContent("")
ClassMethod searchXMLModelByContent(stringKey)
{
}

/// d ##class(web.DHCXMLPConfig).getStreamLines("",1)
ClassMethod getStreamLines(stream As %AbstractStream, writeFlag = 0)
{
}

/// 用来查找xml模板中包含非法的数字字符 lodop 打印的时候，提示报错
/// d ##class(web.DHCXMLPConfig).searchXMLModelIlleagel()
ClassMethod searchXMLModelIlleagel()
{
}

/// 用来查找字符中包含非法的数字字符
/// content : 原字符
/// 数字属性的名称，送了只检查这一个，否则用代码里面的默认 $lb
/// w ##class(web.DHCXMLPConfig).checkValidNumber("height=""10.79"" width=""18.89"" ")
ClassMethod checkValidNumber(content, key1 = "")
{
}

}
