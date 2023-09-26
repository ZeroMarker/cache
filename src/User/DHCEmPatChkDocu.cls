Class User.DHCEmPatChkDocu Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCD_RowID, SqlTableName = DHC_EmPatChkDocu, StorageStrategy = NewStorage ]
{

/// 分诊ID 
Property PCDChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCD_Chk_Dr ];

/// 上传日期
Property PCDDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PCD_Date ];

/// 上传时间
Property PCDTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PCD_Time ];

/// 上传人
Property PCDUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PCD_User_Dr ];

/// 文件路径
Property PCDDocuUrl As %Text(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PCD_DocuUrl ];

/// 文件类型
Property PCDDocType As %String [ SqlColumnNumber = 7, SqlFieldName = PCD_Doc_Type ];

/// 文件BASE64
Property PCDBase As %Text(COLLATION = "Exact", MAXLEN = 99999999, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PCD_Base ];

Storage NewStorage
{
<SqlIdExpression>$I(^DHCEMPATCHKDOCU)</SqlIdExpression>
<SQLMap name="DataIndex">
<Global>^DHCEMPCDO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PCLID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCD_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaste">
<Data name="PCD_Base">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCD_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCD_Doc_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCD_DocuUrl">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCD_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPCDO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkDocuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
