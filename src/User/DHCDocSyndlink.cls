/// DHCDocSyndlink
Class User.DHCDocSyndlink Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Syndlink_Rowid, SqlTableName = DHCDocSyndlink, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// syndrome_MRCICDDR
Property syndromeMRCICDDR As User.MRCICDDx [ SqlColumnNumber = 2, SqlFieldName = syndrome_MRCICDDR ];

/// syndrome_MRCDiaSymptomDr
Property syndromeMRCDiaSymptomDr As User.MRCDiagnosSignSymptom [ SqlColumnNumber = 3, SqlFieldName = syndrome_MRCDiaSymptomDr ];

/// synd_MRCICDDR
Property syndCMMRCICDDR As User.MRCICDDx [ SqlColumnNumber = 4, SqlFieldName = synd_CMMRCICDDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocSyndLink)</SqlIdExpression>
<SQLMap name="IndexofCMMRCIcd">
<Global>^DHCDocSyndLink</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CMMRCICDDX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{synd_CMMRCICDDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Syndlink_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofMRCDiagnosSymp">
<Global>^DHCDocSyndLink</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Syndlink_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MRCDiagnosSymptom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{syndrome_MRCDiaSymptomDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Syndlink_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofMRCICDDX">
<Global>^DHCDocSyndLink</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Syndlink_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MRCICDDX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{syndrome_MRCICDDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Syndlink_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="synd_CMMRCICDDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="syndrome_MRCDiaSymptomDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="syndrome_MRCICDDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocSyndLink</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Syndlink_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Syndlink_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocSyndlinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
