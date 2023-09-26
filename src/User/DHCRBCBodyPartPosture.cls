Class User.DHCRBCBodyPartPosture Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DBP_Rowid, SqlTableName = DHCRBC_BodyPart_Posture, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DBP_BodyPart_DR
Property DBPBodyPartDR As User.MRCBodyParts [ SqlColumnNumber = 2, SqlFieldName = DBP_BodyPart_DR ];

/// DBP_Desc
Property DBPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DBP_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("PosturetoBodyPart"))</SqlIdExpression>
<SQLMap name="IndexData">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DBP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PosturetoBodyPart"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DBP_BodyPart_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DBP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DBP_BodyPart_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DBP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DBP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PosturetoBodyPart"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DBP_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCBodyPartPostureS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
