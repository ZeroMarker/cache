Class User.DHCRBCCancelRegisterNotes Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCN_Rowid, SqlTableName = DHCRBC_CancelRegister_Notes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCN_OEOrdItem_Dr
Property DCNOEOrdItemDr As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DCN_OEOrdItem_Dr ];

/// DCN_RecLoc_Dr
Property DCNRecLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DCN_RecLoc_Dr ];

/// DCN_Status
Property DCNStatus As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DCN_Status ];

/// DCN_Date
Property DCNDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DCN_Date ];

/// DCN_Time
Property DCNTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DCN_Time ];

/// DCN_User_DR
Property DCNUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DCN_User_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCCREG("Cancel-Register"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBCCREGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc-Cancel"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCN_RecLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEOrdItemID">
<Global>^DHCRBCCREGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OEORDITEMID-Cancel"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCN_OEOrdItem_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DCN_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCN_OEOrdItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCN_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCN_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCN_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCN_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBCCREG</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Cancel-Register"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCN_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCCancel93AS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
