/// 名称: 维护程序系统功能项定义表
/// 描述: 系统功能项
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRmeta.MainDictFunction Extends %Persistent [ ClassType = persistent, ProcedureBlock, StorageStrategy = default ]
{

Index IdxParentId On ParentID;

Index IdxFuncName On FuncName;

/// 功能名称
Property FuncName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 功能描述
Property FuncDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 父节点
Property ParentID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// Group/Item 
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 备注
Property Notes As %String(MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Storage default
{
<Data name="MainDictFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FuncName</Value>
</Value>
<Value name="3">
<Value>FuncDesc</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Notes</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.MainDictFunctionD</DataLocation>
<DefaultData>MainDictFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdExpression>^DHCEPRM.MainDictFunctionD</IdExpression>
<IdLocation>^DHCEPRM.MainDictFunctionD</IdLocation>
<IndexLocation>^DHCEPRM.MainDictFunctionI</IndexLocation>
<StreamLocation>^DHCEPRM.MainDictFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
