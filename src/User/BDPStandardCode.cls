/// Function: 标准编码表定义
/// Creator:  sunfengchao
Class User.BDPStandardCode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = BDP_StandardCode ]
{

/// 国家标准编码
Property BDPInternalCode As %String;

/// 国家标准编码名称
Property BDPInternalDesc As %String;

/// 国家标准编码值
Property BDPInternalValue As %String;

/// 医院标准编码
Property BDPHospNationalCode As %String;

/// 医院标准编码名称
Property BDPPHospNationalDesc As %String;

/// 表名称 
Property TableName As %String(MAXLEN = "") [ Required ];

/// 对应表数据RowID
Property DataReference As %String(MAXLEN = "") [ Required ];

Index InternalCodeRef On (TableName As Exact, BDPInternalCode As Exact, DataReference As Exact);

Index InternalDescRef On (TableName As Exact, BDPInternalDesc As Exact, DataReference As Exact);

Index NationalCodeRef On (TableName As Exact, BDPHospNationalCode As Exact, DataReference As Exact);

Index NationalDescRef On (TableName As Exact, BDPPHospNationalDesc As Exact, DataReference As Exact);

Index DataRef On (TableName As Exact, DataReference As Exact);

Storage Default
{
<Data name="BDPStandardCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>BDPStandardDomainDR</Value>
</Value>
<Value name="4">
<Value>BDPStandardValue</Value>
</Value>
<Value name="5">
<Value>DataReference</Value>
</Value>
<Value name="6">
<Value>BDPInternalCode</Value>
</Value>
<Value name="7">
<Value>BDPInternalDesc</Value>
</Value>
<Value name="8">
<Value>BDPHospNationalCode</Value>
</Value>
<Value name="9">
<Value>BDPPHospNationalDesc</Value>
</Value>
<Value name="10">
<Value>BDPInternalValue</Value>
</Value>
</Data>
<DataLocation>^User.BDPStandardCodeD</DataLocation>
<DefaultData>BDPStandardCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPStandardCodeD</IdLocation>
<IndexLocation>^User.BDPStandardCodeI</IndexLocation>
<StreamLocation>^User.BDPStandardCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
