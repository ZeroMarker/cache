Class User.DHCMDTPatChkDocu Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MPCD_RowID, SqlTableName = DHC_MDTPatChkDocu, StorageStrategy = NewStorage ]
{

/// 会诊ID 
Property PCDChkDr As User.DHCMDTConsult [ SqlColumnNumber = 2, SqlFieldName = MPCD_Chk_Dr ];

/// 上传日期
Property MPCDDate As %Date [ SqlColumnNumber = 3, SqlFieldName = MPCD_Date ];

/// 上传时间
Property MPCDTime As %Time [ SqlColumnNumber = 4, SqlFieldName = MPCD_Time ];

/// 上传人
Property MPCDUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = MPCD_User_Dr ];

/// 文件路径
Property MPCDDocuUrl As %Text(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MPCD_DocuUrl ];

/// 文件类型
Property MPCDDocType As %String [ SqlColumnNumber = 7, SqlFieldName = MPCD_Doc_Type ];

Storage NewStorage
{
<SqlIdExpression>$I(^DHCMDTPATCHKDOCU)</SqlIdExpression>
<SQLMap name="DataIndex">
<Global>^DHCMDTPCD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MPCD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PCLID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MPCD_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MPCD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaste">
<Data name="MPCD_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MPCD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MPCD_Doc_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MPCD_DocuUrl">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MPCD_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MPCD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMDTPCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MPCD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTPatChkDocuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
