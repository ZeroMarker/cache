Class User.DHCEQCRoleBuss Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RB_RowID, SqlTableName = DHC_EQCRoleBuss, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RB_BussTypeDR
Property RBBussTypeDR As User.DHCEQCBussType [ SqlColumnNumber = 3, SqlFieldName = RB_BussTypeDR ];

/// RB_RoleDR
Property RBRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 2, SqlFieldName = RB_RoleDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCRoleBuss",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RB_BussTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RB_RoleDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCRoleBuss"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBussType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCRoleBuss"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BussType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_BussTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoleBuss">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCRoleBuss"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RoleBuss"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_RoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_BussTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCRoleBussS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
