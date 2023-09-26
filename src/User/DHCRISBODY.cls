Class User.DHCRISBODY Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCRISBody_Rowid, SqlTableName = DHC_RISBODY, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCRISBody_ARCIM_DR
Property DHCRISBodyARCIMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DHCRISBody_ARCIM_DR ];

/// DHCRISBody_BODYDesc
Property DHCRISBodyBODYDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCRISBody_BODYDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRISBODY)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCRISBody_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCRISBody_BODYDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCRISBody_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRISBODY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCRISBody_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCRISBody_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIMDR">
<Global>^DHCRISBODY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRISBody_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCRISBody_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCRISBody_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRISBODYS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
