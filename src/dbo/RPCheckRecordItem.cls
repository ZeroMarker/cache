Class dbo.RPCheckRecordItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_CheckRecordItem ]
{

/// Foreign Key FKRPCheckRecordItemCheckRecordDR created via DDL
ForeignKey FKRPCheckRecordItemCheckRecordDR(CheckRecordDR) References dbo.RPCheckRecord(PKRPCheckRecord) [ SqlName = FK_RPCheckRecordItemCheckRecordDR ];

/// Foreign Key FKRPCheckRecordItemTestCodeDR created via DDL
ForeignKey FKRPCheckRecordItemTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_RPCheckRecordItemTestCodeDR ];

/// Foreign Key FKRPCheckRecordSaveUserDR created via DDL
ForeignKey FKRPCheckRecordItemCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPCheckRecordItemCheckUser ];

/// DDL Primary Key Specification
Index PKRPCheckRecordItem On RowID [ PrimaryKey, SqlName = PK_RP_CheckRecordItem, Type = index, Unique ];

Index IndexMaster On (CheckRecordDR, TestCodeDR, CheckDate, CheckTime) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 复查主键
Property CheckRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 复查项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 复查人	
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 复查日期
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 复查时间
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="RPCheckRecordItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckRecordDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>CheckUserDR</Value>
</Value>
<Value name="5">
<Value>CheckDate</Value>
</Value>
<Value name="6">
<Value>CheckTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPCheckRecordItemD</DataLocation>
<DefaultData>RPCheckRecordItemDefaultData</DefaultData>
<IdLocation>^dbo.RPCheckRecordItemD</IdLocation>
<IndexLocation>^dbo.RPCheckRecordItemI</IndexLocation>
<StreamLocation>^dbo.RPCheckRecordItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
