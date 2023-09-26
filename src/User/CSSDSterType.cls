Class User.CSSDSterType Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SterType ]
{

/// 灭菌类型
Property CSSDSTSterCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDST_SterCode ];

Property CSSDSTSterName As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDST_SterName ];

/// 是否需要灭菌 消毒灭菌方式的不需要灭菌
Property CSSDSTIsSter As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = CSSDST_IsSter ];

Property CSSDSTNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 5, SqlFieldName = CSSDST_NotUseFlag ];

Property CSSDSTIsLowerTemp As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 7, SqlFieldName = CSSDST_IsLowerTemp ];

/// 灭菌方式对应的颜色
Property CSSDSTDisplayColor As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CSSDST_DisplayColor ];

Index CSSDSTSterNameIndex On CSSDSTSterName As Exact;

Index CSSDSTSterCodeIndex On CSSDSTSterCode As Exact;

Storage Default
{
<Data name="CSSDSterTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSTSterCode</Value>
</Value>
<Value name="3">
<Value>CSSDSTSterName</Value>
</Value>
<Value name="4">
<Value>CSSDSTIsSter</Value>
</Value>
<Value name="5">
<Value>CSSDSTNotUseFlag</Value>
</Value>
<Value name="6"/>
<Value name="7">
<Value>CSSDSTIsLowerTemp</Value>
</Value>
<Value name="8">
<Value>CSSDSTDisplayColor</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSterTypeD</DataLocation>
<DefaultData>CSSDSterTypeDefaultData</DefaultData>
<IdLocation>^User.CSSDSterTypeD</IdLocation>
<IndexLocation>^User.CSSDSterTypeI</IndexLocation>
<StreamLocation>^User.CSSDSterTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
