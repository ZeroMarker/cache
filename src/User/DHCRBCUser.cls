Class User.DHCRBCUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DGU_RowID, SqlTableName = DHCRBC_User, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DGU_SSUSR_DR
Property DGUCareProDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DGU_CarePro_DR ];

/// DGU_SSGroup_DR
Property DGUSSGroupDR As User.DHCRBCGroup [ SqlColumnNumber = 3, SqlFieldName = DGU_SSGroup_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("User"))</SqlIdExpression>
<SQLMap name="IndexGroupDR">
<Global>^DHCRBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DGU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Group-User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DGU_SSGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DGU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCRBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DGU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"User-Group"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DGU_CarePro_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DGU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterIndex">
<Data name="DGU_CarePro_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DGU_SSGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DGU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DGU_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
