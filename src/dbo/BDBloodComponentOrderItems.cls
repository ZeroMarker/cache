///     
Class dbo.BDBloodComponentOrderItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_BloodComponentOrderItems, StorageStrategy = Default ]
{

/// Foreign Key FKBDBOItemsBGroup created via DDL
ForeignKey FKBDBOItemsBGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_BOItems_BGroup ];

/// Foreign Key FKBDBOItemsBProduct created via DDL
ForeignKey FKBDBOItemsBdComponent(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BD_BOItems_Components ];

/// Foreign Key FKBDBOItemsBloodOrder created via DDL
ForeignKey FKBDBOItemsBloodOrder(BloodOrderDR) References dbo.BDBloodComponentOrder(PKBDBLOODCOMPONENTORDER) [ SqlName = FK_BD_BOItems_BloodComponentOrder ];

Index IndexMaster On (BloodOrderDR, BloodComponentsDR, BloodGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDBLOODORDERITEMS On RowID [ PrimaryKey, SqlName = PK_BD_BLOODORDERITEMS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodOrderDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property PackVolume As %Library.Float [ Required, SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDBloodComponentOrderItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodOrderDR</Value>
</Value>
<Value name="3">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="4">
<Value>BloodGroupDR</Value>
</Value>
<Value name="5">
<Value>PackVolume</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDBloodComponentOrderItemsD</DataLocation>
<DefaultData>BDBloodComponentOrderItemsDefaultData</DefaultData>
<IdLocation>^dbo.BDBloodComponentOrderItemsD</IdLocation>
<IndexLocation>^dbo.BDBloodComponentOrderItemsI</IndexLocation>
<StreamLocation>^dbo.BDBloodComponentOrderItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
