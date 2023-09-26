Class EMRmeta.MedicalConceptValues Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 据元目录ID索引
Index IdxCategoryID On CategoryID;

/// 数据元标示符索引
Index IdxCode On Code;

/// 目录ID
Property CategoryID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据值域标示符
Property Code As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值含义
Property DisplayName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果1列类型
Property AllowInput As %String(MAXLEN = 100, TRUNCATE = 1);

/// 固定结构
Property FixedStructs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字字体
Property FontName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字大小
Property FontSize As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字粗细
Property FontWeight As %String(MAXLEN = 100, TRUNCATE = 1);

/// 斜体
Property FontStyle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字颜色
Property TextColor As %String(MAXLEN = 100, TRUNCATE = 1);

Property SubItems As %GlobalBinaryStream(LOCATION = "^DHCEMRM.MedConceptVS");

Storage Default
{
<Data name="MedicalConceptValuesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>AllowInput</Value>
</Value>
<Value name="7">
<Value>FixedStructs</Value>
</Value>
<Value name="8">
<Value>FontName</Value>
</Value>
<Value name="9">
<Value>FontSize</Value>
</Value>
<Value name="10">
<Value>FontWeight</Value>
</Value>
<Value name="11">
<Value>FontStyle</Value>
</Value>
<Value name="12">
<Value>TextColor</Value>
</Value>
<Value name="13">
<Value>SubItems</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.MedConceptVD</DataLocation>
<DefaultData>MedicalConceptValuesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.MedConceptVD</IdLocation>
<IndexLocation>^DHCEMRM.MedConceptVI</IndexLocation>
<StreamLocation>^DHCEMRM.MedConceptVS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
