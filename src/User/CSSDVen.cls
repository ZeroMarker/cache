Class User.CSSDVen Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDVen_Rowid, SqlTableName = CSSD_Ven ]
{

Property CSSDVenCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDVen_Code ];

Property CSSDVenName As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDVen_Name ];

Property CSSDVenSaleManName As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CSSDVen_SaleManName ];

Property CSSDVenTelephone As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDVen_Telephone ];

Property CSSDVenAddress As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDVen_Address ];

Property CSSDVenIsStop As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 7, SqlFieldName = CSSDVen_IsStop ];

/// 机器编号
Property CSSDVenNumber As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDVen_Number ];

/// 机器型号
Property CSSDVenModel As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = CSSDVen_Model ];

/// 机器类型
Property CSSDVenType As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = CSSDVen_Type ];

Index IndexCSSDVenNameCode On (CSSDVenCode As Exact, CSSDVenName As Exact);

Index IndexCSSDVenName On CSSDVenName As Exact;

Index IndexCSSDVenCode On CSSDVenCode As Exact;

Storage Default
{
<Data name="CSSDVenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDVenCode</Value>
</Value>
<Value name="3">
<Value>CSSDVenName</Value>
</Value>
<Value name="4">
<Value>CSSDVenSaleManName</Value>
</Value>
<Value name="5">
<Value>CSSDVenTelephone</Value>
</Value>
<Value name="6">
<Value>CSSDVenAddress</Value>
</Value>
<Value name="7">
<Value>CSSDVenIsStop</Value>
</Value>
<Value name="8">
<Value>CSSDVenNumber</Value>
</Value>
<Value name="9">
<Value>CSSDVenModel</Value>
</Value>
<Value name="10">
<Value>CSSDVenType</Value>
</Value>
</Data>
<DataLocation>^User.CSSDVenD</DataLocation>
<DefaultData>CSSDVenDefaultData</DefaultData>
<IdLocation>^User.CSSDVenD</IdLocation>
<IndexLocation>^User.CSSDVenI</IndexLocation>
<SqlRowIdName>CSSDVen_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDVenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
