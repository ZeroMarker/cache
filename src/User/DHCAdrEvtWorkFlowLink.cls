Class User.DHCAdrEvtWorkFlowLink Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADREWL_RowID, SqlTableName = DHC_AdrEvtWorkFlowLink, StorageStrategy = SQLStorage ]
{

Property ADREWLLinkDr As %String [ SqlColumnNumber = 2, SqlFieldName = ADREWL_LinkDr ];

Property ADREWLRepLevel As %String [ SqlColumnNumber = 3, SqlFieldName = ADREWL_RepLevel ];

/// 多院区改造 2021-04-12 cy
Property ADREWLHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = ADREWL_HospDr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADREVTWFL)</SqlIdExpression>
<SQLMap name="IndexLinkDr">
<Global>^DHCADREVTWFL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADREWL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADREWL_LinkDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADREWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkDrHosp">
<Global>^DHCADREVTWFL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADREWL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkDrHosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADREWL_LinkDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADREWL_HospDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADREWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADREWL_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADREWL_LinkDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADREWL_RepLevel">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADREVTWFL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADREWL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADREWL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdrEvtWorkFlowLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
