Class User.DHCEmPatChkNo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCN_RowID, SqlTableName = DHC_EmPatChkNo, StorageStrategy = SQLStorage ]
{

/// 记录日期 PCN_Date
Property PCNDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PCN_Date ];

/// 递增号 PCN_No
Property PCNNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCN_No ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPCN)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCN_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCN_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkNoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
