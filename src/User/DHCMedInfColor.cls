Class User.DHCMedInfColor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIC_Rowid, SqlTableName = DHC_MedInfColor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MIC_RGB
Property MICRGB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MIC_RGB ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMINFCOLOR)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MIC_RGB">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMINFCOLOR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MIC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfColorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
