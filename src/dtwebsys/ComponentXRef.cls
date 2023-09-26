Include webgen

/// 生成DTDTGCOM的类
Class dtwebsys.ComponentXRef Extends %Persistent [ Inheritance = right, Owner = {_SYSTEM}, Not ProcedureBlock ]
{

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// 593-2020-01-03,列值中有"时报错问题处理
/// 594-2021-12-23,列定义取配置，支持科室保存
Parameter BUILD = 594;

Parameter MAJORVERSION;

Parameter MINORVERSION;

Parameter SQLCODE;

Parameter SQLDESCRIPTION;

Parameter SQLFILTER;

Parameter SQLROWID;

Parameter RTNPREFIX = "DTGCOM";

/// /Complier Qualifiers /display=none
Parameter QUALIFIERS = "/display=all";

/// [Previously private]
ClassMethod Gen(cmpid As %Library.String, template As %Library.String, rtn As %Library.String, ActiveObject As %Library.String, ActiveReference As %Library.String, ActiveContext As %Library.String)
{
}

ClassMethod GenRoutine()
{
}

ClassMethod SaveRoutine()
{
}

ClassMethod GenScripts(JsName As %String)
{
}

/// not use replace by ##class(websys.Conversions).QuotedCacheString zhouzq
ClassMethod GenDoubleQuote(str) As %String
{
}

ClassMethod GenRequestData(str) As %String
{
}

/// w ##class(dtwebsys.ComponentXRef).TransferDelim(a,"""","\'")
/// 因为$tr只能按字符依次替换,所以通过以下方法来完成被替换的字符串小于替换字符串长度的处理
ClassMethod TransferDelim(str, olddelim, newdelim) As %String
{
}

ClassMethod GenComponentCaption(token As %Library.String)
{
}

ClassMethod GenForm()
{
}

/// tblitmcnt - applies only to table items and is the GetAt(index)
ClassMethod GenItem(itm As %Library.String, itmid As %Library.String, isinlist As %Library.String, tblitmcnt As %Library.String = "")
{
}

ClassMethod GenItemAnchor(itm As %Library.String, itmid As %Library.String, isinlist As %Library.String)
{
}

ClassMethod GenItemButton(itm As %Library.String, itmid As %Library.String)
{
}

ClassMethod GenItemCaption(itm As %Library.String, isinheader As %Library.Boolean, inlinequit As %Library.String = 0)
{
}

ClassMethod GenItemCustom(itm As %Library.String, itmid As %Library.String) As %Library.Status
{
}

ClassMethod GenItemDescription(itm As %Library.String)
{
}

ClassMethod GenItemIconProfile(itm As %Library.String, itmid As %Library.String)
{
}

ClassMethod GenItemListBox(itm As %Library.String, itmid As %Library.String)
{
}

ClassMethod GenItemNestedStub(itm As %Library.String, itmid As %Library.String)
{
}

ClassMethod GenItemRTF(itm As %Library.String, itmid As %Library.String)
{
}

ClassMethod GenItemTextArea(itm As %Library.String, itmid As %Library.String)
{
}

ClassMethod GenItemTextBox(itm As %Library.String, itmid As %Library.String)
{
}

ClassMethod GenListLookup(firstrtn As %Library.String)
{
}

ClassMethod GenList(firstrtn As %Library.String)
{
}

/// add by zhouzq
ClassMethod GenListCell() As %Library.Status
{
}

/// add by zhouzq
ClassMethod GenListHidden() As %Library.Status
{
}

ClassMethod GenListEnd() As %Library.Status
{
}

ClassMethod GenListInit() As %Library.Status
{
}

ClassMethod GenListValues(rtn As %Library.String) As %Library.Status
{
}

ClassMethod GenPageUrl() As %Library.Integer
{
}

/// Get (and create) Xref entry
ClassMethod GenPageUrlSort() As %Library.Integer
{
}

ClassMethod GenPageUrlX() As %Library.Integer
{
}

/// called by GenPageUrl,GenPageUrlX,GenPageUrlSort - keep PassThruParams for urls in one place instead of 3 times
ClassMethod GenPageUrlParam() As %Library.Integer
{
}

/// 取得组件对应的实体类名称
ClassMethod GetUserClassName(WebClassName As %String) As %String
{
}

ClassMethod GetParentClassName(packageName, className As %String) As %String
{
}

/// 生成Edit组件的后台数据保存M
ClassMethod GenSave()
{
}

ClassMethod GenLookup()
{
}

ClassMethod GenTemplate(template As %Library.String)
{
}

/// 此方法被组件逻辑类的websyssave方法调用,如果移动到websys.ComponentXRf中，注意参数#RTNPREFIX
ClassMethod GetSave(compref As %Library.String, id As %Library.String)
{
}

/// Get (and create) Xref entry
/// s cmp=##class(websys.Component).%OpenId(50307)
/// d ##class(dtwebsys.ComponentXRef).GetXRef(cmp,"W50010", 20, "SITE", "DHCHEALTH",0)
ClassMethod GetXRef(ByRef cmp As %Library.String, ActiveContext As %Library.String, langid As %Library.String, ActiveObject As %Library.String, ActiveReference As %Library.String, isnested As %Library.String)
{
}

/// 初始化Routine Header
ClassMethod Init()
{
}

ClassMethod Kill() [ CodeMode = generator ]
{
}

ClassMethod MakeDirtyAll()
{
}

ClassMethod MakeDirtyComponent(componentid As %Library.String)
{
}

ClassMethod MakeDirtyLanguage(langid As %Library.String)
{
}

ClassMethod GetQuerySQLUrl(QuerySQL As %String)
{
}

Storage Default
{
<Data name="ComponentXRefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dtwebsys.ComponentXRefD</DataLocation>
<DefaultData>ComponentXRefDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dtwebsys.ComponentXRefD</IdLocation>
<IndexLocation>^dtwebsys.ComponentXRefI</IndexLocation>
<StreamLocation>^dtwebsys.ComponentXRefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
