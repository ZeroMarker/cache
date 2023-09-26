Class User.DHCRBCSaveAppFiled Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSA_Rowid, SqlTableName = DHCRBC_Save_AppFiled, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSA_Paadm_DR
Property DSAPaadmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = DSA_Paadm_DR ];

/// DSA_OEOrdItem_DR
Property DSAOEOrdItemDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DSA_OEOrdItem_DR ];

/// DSA_AppField_DR
Property DSAAppFieldDR As User.DHCRBCApplicationField [ SqlColumnNumber = 4, SqlFieldName = DSA_AppField_DR ];

/// DSA_AppField_Value
Property DSAAppFieldValue As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DSA_AppField_Value ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCSAF("SAVE-APPFIELD"))</SqlIdExpression>
<SQLMap name="IndexAppFieldDR">
<Global>^DHCRBCSAFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DSA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APPFILED-ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSA_Paadm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSA_AppField_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadmDR">
<Global>^DHCRBCSAFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAADMDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSA_Paadm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DSA_AppField_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSA_AppField_Value">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSA_OEOrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSA_Paadm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCSAF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DSA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SAVE-APPFIELD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCSaveAppFiledS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
