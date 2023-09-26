Class CT.WS.DataValueMap Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxSystemCodeDicCode On (SystemCode, DicCode);

Index IdxSystemCodeDicMeaning On (SystemCode, DicCode, CtmDictDesc);

Index IdxSystemCodeDicCodeCode On (SystemCode, DicCode, CtmDictCode) [ Unique ];

/// 标准值域代码表标示符
Property DECVMID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 标准值域代码表数据元值域代码
Property DEVID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 标准值域代码表数据元值域描述
Property Meaning As %String(MAXLEN = 200, TRUNCATE = 1);

/// 自定义字典代码
Property CtmDictCode As %String(TRUNCATE = 1);

/// 自定义字典描述
Property CtmDictDesc As %String(TRUNCATE = 1);

/// 自定义字典定义编码
Property DicCode As %String(TRUNCATE = 1);

/// 系统编码
Property SystemCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DataValueMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GlossaryItemID</Value>
</Value>
<Value name="3">
<Value>TempID</Value>
</Value>
<Value name="4">
<Value>TempDes</Value>
</Value>
<Value name="5">
<Value>DECVMID</Value>
</Value>
<Value name="6">
<Value>DEVID</Value>
</Value>
<Value name="7">
<Value>DEVDes</Value>
</Value>
<Value name="8">
<Value>Meaning</Value>
</Value>
<Value name="9">
<Value>CtmDictCode</Value>
</Value>
<Value name="10">
<Value>CtmDictDesc</Value>
</Value>
<Value name="11">
<Value>DicCode</Value>
</Value>
<Value name="12">
<Value>SystemCode</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.DataValueMapD</DataLocation>
<DefaultData>DataValueMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.DataValueMapD</IdLocation>
<IndexLocation>^DHCCTWS.DataValueMapI</IndexLocation>
<StreamLocation>^DHCCTWS.DataValueMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
