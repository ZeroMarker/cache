/// 名称: 规则档案表
/// 描述: 用于新框架模板权限
/// 编写者：chenwenjun
/// 编写日期: 09/07/28
Class EPRmeta.EPRDocRestriction.DocGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//规则名称

Property GroupName As %String(TRUNCATE = 1);

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,GroupName:%String")
{
	SELECT ID,GroupName
	FROM EPRmeta_EPRDocRestriction.DocGroup
	ORDER BY ID
}

Storage Default
{
<Data name="DocGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRDoc.DocGroupD</DataLocation>
<DefaultData>DocGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRDoc.DocGroupD</IdLocation>
<IndexLocation>^DHCEPRM.EPRDoc.DocGroupI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRDoc.DocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
