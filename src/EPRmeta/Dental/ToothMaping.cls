Class EPRmeta.Dental.ToothMaping Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//牙位映射函数

Property ToothMapingFunctionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

//界面模板ID

Property TemplateID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

//用来映射牙位的界面模板单元编码

Property MetaItemCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

//用来映射牙位的界面模板单元值类型

Property ValueType As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

//用来映射牙位处置内容的界面模板单元编码

Property ConentMetaItemCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

//用来映射牙位处置内容的界面模板单元值类型

Property ConentValueType As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Index IdxToothPosition On (ToothMapingFunctionCode, TemplateID, MetaItemCode) [ Unique ];

Index IdxMetaItemCode On (TemplateID, MetaItemCode) [ Unique ];

Storage Default
{
<Data name="ToothMapingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ToothMapingFunctionCode</Value>
</Value>
<Value name="3">
<Value>TemplateID</Value>
</Value>
<Value name="4">
<Value>MetaItemCode</Value>
</Value>
<Value name="5">
<Value>ValueType</Value>
</Value>
<Value name="6">
<Value>ConentMetaItemCode</Value>
</Value>
<Value name="7">
<Value>ConentValueType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.Dental.ToothMapingD</DataLocation>
<DefaultData>ToothMapingDefaultData</DefaultData>
<IdLocation>^DHCEPRM.Dental.ToothMapingD</IdLocation>
<IndexLocation>^DHCEPRM.Dental.ToothMapingI</IndexLocation>
<StreamLocation>^DHCEPRM.Dental.ToothMapingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
