///     
Class dbo.BDBloodOrderItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_BloodOrderItems, StorageStrategy = Default ]
{

/// Foreign Key FKBDBOItemsBGroup created via DDL
ForeignKey FKBDBOItemsBGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_BOItems_BGroup ];

/// Foreign Key FKBDBOItemsBProduct created via DDL
ForeignKey FKBDBOItemsBProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BD_BOItems_BProduct ];

/// Foreign Key FKBDBOItemsBloodOrder created via DDL
ForeignKey FKBDBOItemsBloodOrder(BloodOrderDR) References dbo.BDBloodOrder(PKBDBLOODORDER) [ SqlName = FK_BD_BOItems_BloodOrder ];

Index IndexMaster On (BloodOrderDR, BloodProductDR, BloodGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDBLOODORDERITEMS On RowID [ PrimaryKey, SqlName = PK_BD_BLOODORDERITEMS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property BloodOrderDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property PackVolume As %Library.Float [ Required, SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDBloodOrderItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodOrderDR</Value>
</Value>
<Value name="3">
<Value>BloodProductDR</Value>
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
<DataLocation>^dbo.BDBloodOrderItemsD</DataLocation>
<DefaultData>BDBloodOrderItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDBloodOrderItemsD</IdLocation>
<IndexLocation>^dbo.BDBloodOrderItemsI</IndexLocation>
<StreamLocation>^dbo.BDBloodOrderItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
