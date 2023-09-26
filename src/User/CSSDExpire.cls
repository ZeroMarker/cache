Class User.CSSDExpire Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDEX_Rowid, SqlTableName = CSSD_Expire ]
{

Property CSSDEXBegDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CSSDEX_BegDate ];

Property CSSDEXEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CSSDEXC_EndDate ];

Property CSSDEXLength As %Numeric [ SqlColumnNumber = 8, SqlFieldName = CSSDEX_Length ];

Property CSSDEXPackage As User.CSSDPackage [ SqlColumnNumber = 10, SqlFieldName = CSSDEX_Package_DR ];

Property CSSDEXMaterialDr As User.CSSDMaterial [ SqlColumnNumber = 11, SqlFieldName = CSSDEX_Material_DR ];

Property CSSDEXPrice As %Numeric [ SqlColumnNumber = 12, SqlFieldName = CSSDEX_Price ];

/// 是否为默认值
Property CSSDExIsDefault As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 13, SqlFieldName = CSSDEx_IsDefault ];

Index IndexCSSDEXPkgMatLen On (CSSDEXPackage As Exact, CSSDEXMaterialDr As Exact, CSSDEXLength As Exact);

Index IndexCSSDEXPkgIsDefault On (CSSDEXPackage As Exact, CSSDExIsDefault As Exact);

Index IndexCSSDEXPackageMat On (CSSDEXPackage As Exact, CSSDEXMaterialDr As Exact);

Index IndexCSSDEXPackage On CSSDEXPackage As Exact;

Storage Default
{
<Data name="CSSDExpireDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3"/>
<Value name="4"/>
<Value name="5"/>
<Value name="6">
<Value>CSSDEXBegDate</Value>
</Value>
<Value name="7">
<Value>CSSDEXEndDate</Value>
</Value>
<Value name="8">
<Value>CSSDEXLength</Value>
</Value>
<Value name="9"/>
<Value name="10">
<Value>CSSDEXPackage</Value>
</Value>
<Value name="11">
<Value>CSSDEXMaterialDr</Value>
</Value>
<Value name="12">
<Value>CSSDEXPrice</Value>
</Value>
<Value name="13">
<Value>CSSDExIsDefault</Value>
</Value>
</Data>
<DataLocation>^User.CSSDExpireD</DataLocation>
<DefaultData>CSSDExpireDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDExpireD</IdLocation>
<IndexLocation>^User.CSSDExpireI</IndexLocation>
<SqlRowIdName>CSSDEX_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDExpireS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
