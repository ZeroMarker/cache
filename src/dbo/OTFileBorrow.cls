Class dbo.OTFileBorrow Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileBorrow ]
{

Index IndexFile On (OTFileInfoDR, CreateDate, CreateTime) [ SqlName = Index_File, Type = index ];

Index IndexCreateUser On (CreateUser, CreateDate, CreateTime) [ SqlName = Index_CreateUser, Type = index ];

Index IndexExpectBackDate On (ExpectBackDate, OTFileInfoDR, CreateUser) [ SqlName = Index_ExpectBackDate, Type = index ];

/// DDL Primary Key Specification
Index PKOTFileBorrow On RowID [ PrimaryKey, SqlName = PK_OT_FileBorrow, Type = index, Unique ];

/// Foreign Key FKFileBorrowCreateUser created via DDL
ForeignKey FKFileBorrowCreateUser(CreateUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_FileBorrowCreateUser ];

/// Foreign Key FKOTFileBorrowInfoDR created via DDL
ForeignKey FKOTFileBorrowInfoDR(OTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OTFileBorrowInfoDR ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 文件
Property OTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 借阅日期
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 借阅时间
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 借阅人
Property CreateUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 预计归还日期
Property ExpectBackDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 预计归还人
Property ExpectBackUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审核日期
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审核时间
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 审核人
Property AuthUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 归还日期
Property BackDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 归还时间
Property BackTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 归还人
Property BackUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 状态（枚举类LQM.ENUM.OTFileBorrowStatus）
Property Status As %Library.SmallInt [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="OTFileBorrowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTFileInfoDR</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>ExpectBackDate</Value>
</Value>
<Value name="7">
<Value>ExpectBackUser</Value>
</Value>
<Value name="8">
<Value>AuthDate</Value>
</Value>
<Value name="9">
<Value>AuthTime</Value>
</Value>
<Value name="10">
<Value>AuthUser</Value>
</Value>
<Value name="11">
<Value>BackDate</Value>
</Value>
<Value name="12">
<Value>BackTime</Value>
</Value>
<Value name="13">
<Value>BackUser</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileBorrowD</DataLocation>
<DefaultData>OTFileBorrowDefaultData</DefaultData>
<IdLocation>^dbo.OTFileBorrowD</IdLocation>
<IndexLocation>^dbo.OTFileBorrowI</IndexLocation>
<StreamLocation>^dbo.OTFileBorrowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
