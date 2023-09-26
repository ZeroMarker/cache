Class User.DHCEQCGroupHospital Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UH_RowID, SqlTableName = DHC_EQCGroupHospital, StorageStrategy = SQLStorage ]
{

/// UH_GroupDR
Property URGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UH_GroupDR ];

/// UH_HospitalDR
Property UHHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UH_HospitalDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupHospital",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UH_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UH_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>UH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupHospital"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{UH_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroupHospital">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCGroupHospital"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GroupHospital"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UH_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UH_HospitalDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCGroupHospital"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hospital"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UH_HospitalDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupHospitalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
