Class User.DHCRBNO Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RNO_Rowid, SqlTableName = DHCRB_NO, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 252;

/// RNO_PAPATMAS_DR
Property RNOPAPATMASDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RNO_PAPATMAS_DR ];

/// RNO_LOC_DR
Property RNOLOCDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RNO_LOC_DR ];

/// RNO_NO
Property RNONO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RNO_NO ];

/// RNO_Desc
Property RNODesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RNO_Desc ];

/// RNO_EQ_DR
Property RNOEQGroupDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RNO_EQGroup_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACRegInfoNO("NO",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RNO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RNO_EQGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RNO_LOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RNO_NO">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RNO_PAPATMAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPACRegInfoNO</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RNO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RNO_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEQ">
<Global>^DHCPACRegInfoNOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RNO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EQGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RNO_PAPATMAS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RNO_LOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RNO_EQGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RNO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCPACRegInfoNOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RNO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RNO_LOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RNO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCPACRegInfoNOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RNO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="2">
<Expression>1</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RNO_NO}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RNO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadm">
<Global>^DHCPACRegInfoNOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RNO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RNO_PAPATMAS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RNO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexpatmasloc">
<Global>^DHCPACRegInfoNOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RNO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Patmas-Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RNO_PAPATMAS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RNO_LOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RNO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBNOS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
