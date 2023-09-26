Class User.DHCPHAdrProcess Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRP_RowID, SqlTableName = DHC_PHAdrProcess, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ADRP_Status_DR
Property ADRPStatusDR As User.DHCPHAdrStatus [ SqlColumnNumber = 2, SqlFieldName = ADRP_Status_DR ];

/// ADRP_NextStat_DR
Property ADRPNextStatDR As User.DHCPHAdrStatus [ SqlColumnNumber = 3, SqlFieldName = ADRP_NextStat_DR ];

/// ADRP_CombDepend
Property ADRPCombDepend As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ADRP_CombDepend ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHADRP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADRP_CombDepend">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADRP_NextStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRP_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHADRP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADRP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNextStatus">
<Global>^DHCPHADRP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADRP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NextStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRP_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRP_NextStat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrProcessS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
