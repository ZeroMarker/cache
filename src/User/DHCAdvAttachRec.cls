Class User.DHCAdvAttachRec Extends %Persistent [ SqlRowIdName = ATTR_RowID, SqlTableName = DHC_ADVAttachRec, StorageStrategy = SQLStorage ]
{

/// 报告ID 
Property ATTRRepDr As User.DHCAdvMaster [ SqlColumnNumber = 2, SqlFieldName = ATTR_Rep_Dr ];

/// 报告类型
Property ATTRRepTypeDr As %String [ SqlColumnNumber = 3, SqlFieldName = ATTR_RepType_Dr ];

/// 上传文件类型 img图片、word文档、Execl文档
Property ATTRFileType As %String [ SqlColumnNumber = 4, SqlFieldName = ATTR_FileType ];

/// 上传人
Property ATTRUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = ATTR_User_Dr ];

/// 上传日期
Property ATTRDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ATTR_Date ];

/// 上传时间
Property ATTRTime As %Time [ SqlColumnNumber = 7, SqlFieldName = ATTR_Time ];

/// 上传文件名称
Property ATTRFileName As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ATTR_FileName ];

/// 上传文件信息
Property ATTRFileList As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ATTR_FileList ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVATTR)</SqlIdExpression>
<SQLMap name="IndexRepType">
<Global>^DHCADVATTR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ATTR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepIdType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATTR_Rep_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATTR_RepType_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATTR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ATTR_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATTR_FileList">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ATTR_FileName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ATTR_FileType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATTR_RepType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATTR_Rep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATTR_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ATTR_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVATTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATTR_RowI</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ATTR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvAttachRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
