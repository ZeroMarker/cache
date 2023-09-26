///     
Class dbo.STBillItemData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = ST_BillItemData ]
{

/// Foreign Key FKSTBillItemDataBillItemDR created via DDL
ForeignKey FKSTBillItemDataBillItemDR(BillItemDR) References dbo.BTBillItem(PKBTBILLITEM) [ SqlName = FK_STBillItemDataBillItemDR ];

/// Foreign Key FKSTBillItemDataTestSetDR created via DDL
ForeignKey FKSTBillItemDataTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_STBillItemDataTestSetDR ];

/// Foreign Key FKSTBillItemDataTestCodeDR created via DDL
ForeignKey FKSTBillItemDataTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_STBillItemDataTestCodeDR ];

/// Foreign Key FKSTBillItemDataPackDR created via DDL
ForeignKey FKSTBillItemDataPackDR(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_STBillItemDataPackDR ];

/// Foreign Key FKSTBillItemDataBillItemTypeDR created via DDL
ForeignKey FKSTBillItemDataBillItemTypeDR(BillItemTypeDR) References dbo.BTBillItemType(PKBTBILLITEMTYPE) [ SqlName = FK_STBillItemDataBillItemTypeDR ];

/// Foreign Key FKSTBillItemDataLocationDR created via DDL
ForeignKey FKSTBillItemDataLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_STBillItemDataLocationDR ];

/// Foreign Key FKSTBillItemDataWorkGroupDR created via DDL
ForeignKey FKSTBillItemDataWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_STBillItemDataWorkGroupDR ];

/// Foreign Key FKSTBillItemDataWorkGroupMachineDR created via DDL
ForeignKey FKSTBillItemDataWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_STBillItemDataWorkGroupMachineDR ];

/// DDL Primary Key Specification
Index PKSTBILLITEMDATA On RowID [ PrimaryKey, SqlName = PK_ST_BILLITEMDATA, Type = index, Unique ];

Index IndexMaster On (BillMode, BillDataID, BillItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexBillItem On (BillDate, BillItemDR) [ SqlName = Index_BillItem, Type = index ];

Index IndexLocation On (ReqDate, LocationDR) [ SqlName = Index_Location, Type = index ];

Index IndexWorkGroup On (ExecDate, WorkGroupDR) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexHISOrderID On HISOrderID [ SqlName = Index_HISOrderID, Type = index ];

Index IndexTestSet On (ExecDate, TestSetDR) [ SqlName = Index_TestSet, Type = index ];

Index IndexTestCode On (ExecDate, TestCodeDR) [ SqlName = Index_TestCode, Type = index ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BillMode As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 3 ];

Property BillDataID As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property BillItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property HISOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property Amounts As %Library.Float [ SqlColumnNumber = 7 ];

Property Quantity As %Library.Float [ SqlColumnNumber = 8 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property BillItemTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property ReqDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property ReqTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property BillDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property BillTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property ExecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property ExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property ReqType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 22 ];

Storage Default
{
<Data name="STBillItemDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BillMode</Value>
</Value>
<Value name="3">
<Value>BillDataID</Value>
</Value>
<Value name="4">
<Value>BillItemDR</Value>
</Value>
<Value name="5">
<Value>HISOrderID</Value>
</Value>
<Value name="6">
<Value>Amounts</Value>
</Value>
<Value name="7">
<Value>Quantity</Value>
</Value>
<Value name="8">
<Value>TestSetDR</Value>
</Value>
<Value name="9">
<Value>TestCodeDR</Value>
</Value>
<Value name="10">
<Value>PackDR</Value>
</Value>
<Value name="11">
<Value>BillItemTypeDR</Value>
</Value>
<Value name="12">
<Value>LocationDR</Value>
</Value>
<Value name="13">
<Value>WorkGroupDR</Value>
</Value>
<Value name="14">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="15">
<Value>ReqDate</Value>
</Value>
<Value name="16">
<Value>ReqTime</Value>
</Value>
<Value name="17">
<Value>BillDate</Value>
</Value>
<Value name="18">
<Value>BillTime</Value>
</Value>
<Value name="19">
<Value>ExecDate</Value>
</Value>
<Value name="20">
<Value>ExecTime</Value>
</Value>
<Value name="21">
<Value>ReqType</Value>
</Value>
</Data>
<DataLocation>^dbo.STBillItemDataD</DataLocation>
<DefaultData>STBillItemDataDefaultData</DefaultData>
<IdLocation>^dbo.STBillItemDataD</IdLocation>
<IndexLocation>^dbo.STBillItemDataI</IndexLocation>
<StreamLocation>^dbo.STBillItemDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
