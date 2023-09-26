Class dbo.BDArchiveFile Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ArchiveFile, StorageStrategy = Default ]
{

Index IndexMater On (RecordNo, RecordType) [ SqlName = Index_Mater, Type = index, Unique ];

Index IndexLocationID On (RecordType, LocationID, AddDate) [ SqlName = Index_LocationID, Type = index ];

Index IndexUser On (AddUserDR, AddDate) [ SqlName = Index_User, Type = index ];

Index IndexExtRecordNo On (ExtRecordNo, RecordType) [ SqlName = Index_ExtRecordNo, Type = index, Unique ];

Index IndexAddDate On (AddDate, RecordType) [ SqlName = Index_AddDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDARCHIVEFILE On RowID [ PrimaryKey, SqlName = PK_BDARCHIVEFILE, Type = index, Unique ];

/// Foreign Key FKVisitNumberReportAuthUser created via DDL
ForeignKey FKBDArchiveFileAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDArchiveFileAddUser ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 内部记录单号  
Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 记录单类型 知情同意书:ARE，申请单:REQ，发血单:ISS  
Property RecordType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ Required, SqlColumnNumber = 4 ];

/// 文件来源 系统内:IN，系统外:OUT
Property FileSource As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 5 ];

/// 文件类型 PDF文件：PDF，图片文件：IMG
Property FileType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 6 ];

/// 文件相对路径+文件名称
Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 用来校验文件是否正确
Property FileHash As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

/// 外部记录单号 
Property ExtRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 外部机构名称 
Property ExtInstitution As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

/// 所属科室  临床系统：临床科室ID,输血科：工作组ID
Property LocationID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BDArchiveFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordNo</Value>
</Value>
<Value name="3">
<Value>RecordType</Value>
</Value>
<Value name="4">
<Value>FileSource</Value>
</Value>
<Value name="5">
<Value>FileType</Value>
</Value>
<Value name="6">
<Value>FileName</Value>
</Value>
<Value name="7">
<Value>FileHash</Value>
</Value>
<Value name="8">
<Value>ExtRecordNo</Value>
</Value>
<Value name="9">
<Value>ExtInstitution</Value>
</Value>
<Value name="10">
<Value>LocationID</Value>
</Value>
<Value name="11">
<Value>AddDate</Value>
</Value>
<Value name="12">
<Value>AddTime</Value>
</Value>
<Value name="13">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDArchiveFileD</DataLocation>
<DefaultData>BDArchiveFileDefaultData</DefaultData>
<IdLocation>^dbo.BDArchiveFileD</IdLocation>
<IndexLocation>^dbo.BDArchiveFileI</IndexLocation>
<StreamLocation>^dbo.BDArchiveFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
