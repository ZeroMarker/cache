///     
Class dbo.BBAutoAssTypeTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AutoAssTypeTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKAutoAssTypeAutoAssTestItem created via DDL
ForeignKey FKAutoAssTypeAutoAssTestItem(TestItemDR) References dbo.BBAutologousAssTestItem(PKBBAutologousAssTestItem) [ SqlName = FKAutoAssTypeAutoAssTestItem ];

/// Foreign Key FKAutoAssTypeTestItemHospital created via DDL
ForeignKey FKAutoAssTypeTestItemHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FKAutoAssTypeTestItemHospital ];

Index IndexAutoAssType On AutologousAssType [ SqlName = Index_AutoAssType, Type = index ];

Index IndexMaster On (HospitalDR, AutologousAssType, TestItemDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBBAutoAssTypeTestItem On RowID [ PrimaryKey, SqlName = PK_BB_AutoAssTypeTestItem, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AutologousAssType As %Library.SmallInt [ Required, SqlColumnNumber = 4 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBAutoAssTypeTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>AutologousAssType</Value>
</Value>
<Value name="4">
<Value>TestItemDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAutoAssTypeTestItemD</DataLocation>
<DefaultData>BBAutoAssTypeTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BBAutoAssTypeTestItemD</IdLocation>
<IndexLocation>^dbo.BBAutoAssTypeTestItemI</IndexLocation>
<StreamLocation>^dbo.BBAutoAssTypeTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
