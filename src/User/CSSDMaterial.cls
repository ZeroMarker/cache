/// 包装材料字典
Class User.CSSDMaterial Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_Material ]
{

Property CSSDMCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDM_Code ];

Property CSSDMDesc As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CSSDM_Desc ];

/// 是否可用
Property CSSDMIsUsed As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 4, SqlFieldName = CSSDM_IsUsed ];

/// 效期天数
Property CSSDMExpLength As %Integer [ SqlColumnNumber = 5, SqlFieldName = CSSDM_ExpLength ];

Index CSSDMCodeIndex On CSSDMCode As Exact;

Index CSSDMDescIndex On CSSDMDesc As Exact;

Storage Default
{
<Data name="CSSDMaterialDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDMCode</Value>
</Value>
<Value name="3">
<Value>CSSDMDesc</Value>
</Value>
<Value name="4">
<Value>CSSDMIsUsed</Value>
</Value>
<Value name="5">
<Value>CSSDMExpLength</Value>
</Value>
</Data>
<DataLocation>^User.CSSDMaterialD</DataLocation>
<DefaultData>CSSDMaterialDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDMaterialD</IdLocation>
<IndexLocation>^User.CSSDMaterialI</IndexLocation>
<StreamLocation>^User.CSSDMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
