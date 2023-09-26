/// 
Class dbo.BDXMRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_XMRecord ]
{

/// Foreign Key FKBDXMRecordAddUserDR created via DDL
ForeignKey FKBDXMRecordAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDXMRecordAddUserDR ];

/// Foreign Key FKBDXMRecordCheckUserDR created via DDL
ForeignKey FKBDXMRecordCheckUserDR(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDXMRecordCheckUserDR ];

/// DDL Primary Key Specification
Index PKBDXMRECORD On RowID [ PrimaryKey, SqlName = PK_BD_XMRECORD, Type = index, Unique ];

Index IndexMaster On RecordNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDXMRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordNo</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>CheckDate</Value>
</Value>
<Value name="7">
<Value>CheckTime</Value>
</Value>
<Value name="8">
<Value>CheckUserDR</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDXMRecordD</DataLocation>
<DefaultData>BDXMRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDXMRecordD</IdLocation>
<IndexLocation>^dbo.BDXMRecordI</IndexLocation>
<StreamLocation>^dbo.BDXMRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
