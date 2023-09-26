///     
Class dbo.BBAdvReactTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AdvReactTestItem, StorageStrategy = Default ]
{

/// DDL Primary Key Specification
Index PKBBAdvReactTestItem1 On RowID [ PrimaryKey, SqlName = PK_BB_AdvReactTestItem_1, Type = index, Unique ];

/// Foreign Key FKBBAdvReactTestItemBTHospital created via DDL
ForeignKey FKBBAdvReactTestItemBTHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_AdvReactTestItem_BT_Hospital ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property SCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

Property Type As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBAdvReactTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>SCode</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>HospitalDR</Value>
</Value>
<Value name="8">
<Value>SeqNum</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAdvReactTestItemD</DataLocation>
<DefaultData>BBAdvReactTestItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBAdvReactTestItemD</IdLocation>
<IndexLocation>^dbo.BBAdvReactTestItemI</IndexLocation>
<StreamLocation>^dbo.BBAdvReactTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
