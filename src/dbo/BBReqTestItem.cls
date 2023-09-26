///     
Class dbo.BBReqTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKBBRTestItemHospital created via DDL
ForeignKey FKBBRTestItemHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_RTestItem_Hospital ];

/// Foreign Key FKBBRTestItemItem created via DDL
ForeignKey FKBBRTestItemItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BB_RTestItem_Item ];

/// Foreign Key FKBBRTestItemReqType created via DDL
ForeignKey FKBBRTestItemReqType(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BB_RTestItem_ReqType ];

Index IndexMaster On (ReqTypeDR, HospitalDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (ReqTypeDR, HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREQTESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_REQTESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property IsPrompt As %Library.Boolean [ SqlColumnNumber = 6 ];

Property ResultList As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Property Days As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BBReqTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqTypeDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>TestItemDR</Value>
</Value>
<Value name="5">
<Value>IsPrompt</Value>
</Value>
<Value name="6">
<Value>ResultList</Value>
</Value>
<Value name="7">
<Value>Days</Value>
</Value>
<Value name="8">
<Value>SeqNum</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqTestItemD</DataLocation>
<DefaultData>BBReqTestItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqTestItemD</IdLocation>
<IndexLocation>^dbo.BBReqTestItemI</IndexLocation>
<StreamLocation>^dbo.BBReqTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
