Class User.DHCWMRExamRDtlACR Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_WMR_ExamRDtlACR, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ExamRDtlDr
Property ExamRDtlDr As User.DHCWMRExamRDtl [ SqlColumnNumber = 2 ];

/// ACRDr
Property ACRDr As User.DHCWMRAutoCheckRule [ SqlColumnNumber = 3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRERSTACR)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="ACRDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ExamRDtlDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCWMRERSTACR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExamDtl">
<Global>^DHCWMRERSTACR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ExamDtl"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ExamRDtlDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRExamRDtlACRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
