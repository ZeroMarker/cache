///     
Class dbo.BDPackDelivery Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackDelivery, StorageStrategy = Default ]
{

Index IndexMaster On DeliveryNo [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackDelivery On RowID [ PrimaryKey, SqlName = PK_BD_PackDelivery, Type = index, Unique ];

/// Foreign Key FKPackDeliveryCancelUser created via DDL
ForeignKey FKPackDeliveryCancelUser(CancellUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackDelivery_CancelUser ];

/// Foreign Key FKPackDeliveryDeliveryUser created via DDL
ForeignKey FKPackDeliveryDeliveryUser(DeliveryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackDelivery_DeliveryUser ];

/// Foreign Key FKPackDeliveryIssUser created via DDL
ForeignKey FKPackDeliveryIssUser(IssueUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackDelivery_IssUser ];

/// Foreign Key FKPackDeliveryWorkGroup created via DDL
ForeignKey FKPackDeliveryWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_PackDelivery_WorkGroup ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property DeliveryNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property IssueUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property DeliveryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 9 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CancellUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BDPackDeliveryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>DeliveryNo</Value>
</Value>
<Value name="4">
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>IssueUserDR</Value>
</Value>
<Value name="8">
<Value>DeliveryUserDR</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>CancelDate</Value>
</Value>
<Value name="11">
<Value>CancelTime</Value>
</Value>
<Value name="12">
<Value>CancellUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackDeliveryD</DataLocation>
<DefaultData>BDPackDeliveryDefaultData</DefaultData>
<IdLocation>^dbo.BDPackDeliveryD</IdLocation>
<IndexLocation>^dbo.BDPackDeliveryI</IndexLocation>
<StreamLocation>^dbo.BDPackDeliveryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
