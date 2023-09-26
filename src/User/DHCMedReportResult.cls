Class User.DHCMedReportResult Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDSR_RowID, SqlTableName = DHC_MedReportResult, StorageStrategy = NewStorage1 ]
{

Property MEDSRRepDr As %String [ SqlColumnNumber = 2, SqlFieldName = MEDSR_RepDr ];

Property MEDSRReslutDr As %String [ SqlColumnNumber = 3, SqlFieldName = MEDSR_ReslutDr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVMEDRRET)</SqlIdExpression>
<SQLMap name="IndexRepDr">
<Global>^DHCADVMEDRRET</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_RepDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MEDSR_RepDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDSR_ReslutDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVMEDRRET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedReportResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
