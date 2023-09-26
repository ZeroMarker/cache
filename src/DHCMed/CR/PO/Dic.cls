/// 名称: DHCMed.CR.PO.Form
/// 描述: 字典定义
/// 编写者：wuqk
/// 编写日期: 2012-11-29
Class DHCMed.CR.PO.Dic Extends (%Persistent, %XML.Adaptor) [ Owner = {}, Not ProcedureBlock ]
{

/// 字典代码
Property dicCode As %String(TRUNCATE = 1) [ Required ];

/// 字典名称
Property dicName As %String(TRUNCATE = 1) [ Required ];

/// 类名称
Property className As %String(TRUNCATE = 1) [ Required ];

/// Query名称
Property queryName As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 字段列表
Property fields As %String(MAXLEN = 300, TRUNCATE = 1) [ Required ];

/// 参数说明
Property formalSpec As %String(MAXLEN = 300, TRUNCATE = 1);

Index IndexCode On dicCode [ Unique ];

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,className,dicCode,dicName,fields,formalSpec,queryName FROM Dic
}

Storage Default
{
<Data name="DicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>dicCode</Value>
</Value>
<Value name="3">
<Value>dicName</Value>
</Value>
<Value name="4">
<Value>className</Value>
</Value>
<Value name="5">
<Value>queryName</Value>
</Value>
<Value name="6">
<Value>fields</Value>
</Value>
<Value name="7">
<Value>formalSpec</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.PO.DicD</DataLocation>
<DefaultData>DicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.PO.DicD</IdLocation>
<IndexLocation>^DHCMed.CR.PO.DicI</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.DicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
