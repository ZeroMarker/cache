Class User.BDPEXFieldConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_EXFieldConfig ]
{

Relationship ParRef As User.BDPEXConfig [ Cardinality = parent, Inverse = ChildField ];

/// 字段中文描述
Property EXFCFieldDesc As %String(MAXLEN = "") [ Required ];

/// 表字段名称
Property EXFCFieldName As %String(MAXLEN = "") [ Required ];

/// 字段类型
Property EXFCFieldType As %String(MAXLEN = "");

/// 通过ID找Code 只有DR类型的使用
Property EXFCIDToCode As %String(MAXLEN = "");

/// 如何取字段（Global）
Property EXFCGetField As %String(MAXLEN = "");

/// 通过ID找Code字段名 只有DR类型的使用
Property EXFCIDToCodeName As %String(MAXLEN = "");

/// 是否导出 2022-1-21 add
Property EXFCExport As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 顺序字段 2022-1-21add
Property EXFCOrder As %Float;

Index FieldNameIndex On (EXFCFieldName As Exact, EXFCFieldType As Exact, ParRef);

Index FieldNameUniqueI On (EXFCFieldName, ParRef) [ Unique ];

Index DescNameIndex On (EXFCFieldDesc As Exact, EXFCFieldName As Exact, ParRef);

Index ParSeqIdx On (ParRef, EXFCOrder);

Storage Default
{
<Data name="BDPEXFieldConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EXFCFieldDesc</Value>
</Value>
<Value name="3">
<Value>EXFCFieldName</Value>
</Value>
<Value name="4">
<Value>EXFCFieldType</Value>
</Value>
<Value name="5">
<Value>EXFCIDToCode</Value>
</Value>
<Value name="6">
<Value>EXFCGetField</Value>
</Value>
<Value name="7">
<Value>EXFCIDToCodeName</Value>
</Value>
<Value name="8">
<Value>EXFCExport</Value>
</Value>
<Value name="9">
<Value>EXFCOrder</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildField")</DataLocation>
<DefaultData>BDPEXFieldConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPEXConfigC("ChildField")</IdLocation>
<IndexLocation>^User.BDPEXFieldConfigI</IndexLocation>
<StreamLocation>^User.BDPEXFieldConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
