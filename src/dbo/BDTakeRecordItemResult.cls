Class dbo.BDTakeRecordItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TakeRecordItemResult, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFIRReqForm created via DDL
ForeignKey FKBDTRIRTakeRecord(TakeRecordDR) References dbo.BDTakeRecord(PKBDTAKERECORD) [ SqlName = FK_BD_TRIR_TakeRecord ];

/// Foreign Key FKBDRFIRResultUser created via DDL
ForeignKey FKBDTRIRResultUser(ResultUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRIR_ResultUser ];

/// Foreign Key FKBDRFIRTestItem created via DDL
ForeignKey FKBDTRIRTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BD_TRIR_TestItem ];

Index IndexMaster On (TakeRecordDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDTAKERECORDITEMRESULT On RowID [ PrimaryKey, SqlName = PK_BD_TAKERECORDITEMRESULT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 取血单  
Property TakeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

/// 参考范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 审核日期  
Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审核时间  
Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审核者  
Property ResultUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 异常标志  
Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 12 ];

/// 检测项目分组 1：输血前9项，2：输血适应症
Property TestItemGroup As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BDTakeRecordItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TakeRecordDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>ResultDate</Value>
</Value>
<Value name="8">
<Value>ResultTime</Value>
</Value>
<Value name="9">
<Value>ResultUserDR</Value>
</Value>
<Value name="10">
<Value>SeqNum</Value>
</Value>
<Value name="11">
<Value>AbFlag</Value>
</Value>
<Value name="12">
<Value>TestItemGroup</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTakeRecordItemResultD</DataLocation>
<DefaultData>BDTakeRecordItemResultDefaultData</DefaultData>
<IdLocation>^dbo.BDTakeRecordItemResultD</IdLocation>
<IndexLocation>^dbo.BDTakeRecordItemResultI</IndexLocation>
<StreamLocation>^dbo.BDTakeRecordItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
