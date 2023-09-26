Class dbo.BBReqAssTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqAssTestItem ]
{

/// Foreign Key FKBBAgreeTestItemHospital created via DDL
ForeignKey FKBBReqAssTestItemHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_AssTestItem_Hospital ];

/// Foreign Key FKBBAgreeTestItemItem created via DDL
ForeignKey FKBBReqAssTestItemItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BB_AssTestItem_Item ];

Index IndexMaster On (HospitalDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREQASSTESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_REQASSTESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsPrompt As %Library.Boolean [ SqlColumnNumber = 5 ];

Property ResultList As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property Days As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBReqAssTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>IsPrompt</Value>
</Value>
<Value name="5">
<Value>ResultList</Value>
</Value>
<Value name="6">
<Value>Days</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqAssTestItemD</DataLocation>
<DefaultData>BBReqAssTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BBReqAssTestItemD</IdLocation>
<IndexLocation>^dbo.BBReqAssTestItemI</IndexLocation>
<StreamLocation>^dbo.BBReqAssTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
