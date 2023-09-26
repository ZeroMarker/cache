Class User.DHCRBReturnReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DBRR_Rowid, SqlTableName = DHCRB_ReturnReason, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 252;

/// DBRR_Reason
Property DBRRReason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DBRR_Reason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBRR("Reason",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DBRR_Reason">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBRR</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DBRR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Reason"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DBRR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBReturnReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
