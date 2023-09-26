Class User.DHCEQCGroupRole Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UR_RowID, SqlTableName = DHC_EQCGroupRole, StorageStrategy = SQLStorage ]
{

/// UR_GroupDR
Property URGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UR_GroupDR ];

/// UR_RoleDR
Property URRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 3, SqlFieldName = UR_RoleDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupRole",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UR_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UR_RoleDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupRole"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroupRole">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCGroupRole"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GroupRole"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UR_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UR_RoleDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRole">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCGroupRole"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Role"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UR_RoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupRoleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
