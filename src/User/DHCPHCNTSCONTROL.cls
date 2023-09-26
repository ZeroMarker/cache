Class User.DHCPHCNTSCONTROL Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCC_RowID, SqlTableName = DHC_PHCNTSCONTROL, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PCC_Poison_Dr
Property PCCPoisonDr As User.PHCPoison [ SqlColumnNumber = 2, SqlFieldName = PCC_Poison_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCCON)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="PCC_Poison_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPCCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PCC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSCONTROLS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
