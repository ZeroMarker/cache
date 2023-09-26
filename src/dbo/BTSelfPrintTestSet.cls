///     
Class dbo.BTSelfPrintTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SelfPrintTestSet ]
{

/// Foreign Key FKBTSelfPrintTestSetTestSetDR created via DDL
ForeignKey FKBTSelfPrintTestSetTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTSelfPrintTestSetTestSetDR ];

Index IndexMaster On (IP, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestSet On (TestSetDR, IP) [ SqlName = Index_TestSet, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSELFPRINTTESTSET On RowID [ PrimaryKey, SqlName = PK_BT_SELFPRINTTESTSET, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// IP
Property IP As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

/// 开始日期  
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 结束日期  
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTSelfPrintTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IP</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSelfPrintTestSetD</DataLocation>
<DefaultData>BTSelfPrintTestSetDefaultData</DefaultData>
<IdLocation>^dbo.BTSelfPrintTestSetD</IdLocation>
<IndexLocation>^dbo.BTSelfPrintTestSetI</IndexLocation>
<StreamLocation>^dbo.BTSelfPrintTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
