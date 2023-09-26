///     
Class dbo.BDPackDeliveryItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackDeliveryItems, StorageStrategy = Default ]
{

Index IndexMaster On (PackDeliveryDR, PackDR) [ SqlName = Index_Master, Type = index ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackDeliveryItems On RowID [ PrimaryKey, SqlName = PK_BD_PackDeliveryItems, Type = index, Unique ];

/// Foreign Key FKDeliveryItemsPackDelivery created via DDL
ForeignKey FKDeliveryItemsPackDelivery(PackDeliveryDR) References dbo.BDPackDelivery(PKBDPackDelivery) [ SqlName = FK_DeliveryItems_PackDelivery ];

/// Foreign Key FKPackDeliveryItemsPack created via DDL
ForeignKey FKPackDeliveryItemsPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_PackDeliveryItems_Pack ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackDeliveryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDPackDeliveryItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>PackDeliveryDR</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackDeliveryItemsD</DataLocation>
<DefaultData>BDPackDeliveryItemsDefaultData</DefaultData>
<IdLocation>^dbo.BDPackDeliveryItemsD</IdLocation>
<IndexLocation>^dbo.BDPackDeliveryItemsI</IndexLocation>
<StreamLocation>^dbo.BDPackDeliveryItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
