Class User.DHCRBResContrast Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_RBResContrast, StorageStrategy = SQLStorage ]
{

Property RBRCDeptDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = RBRC_Dept_DR ];

Property RBRCResourceDR As User.RBResource [ SqlColumnNumber = 3, SqlFieldName = RBRC_Resource_DR ];

Property RBRCSessionTypeDR As User.RBCSessionType [ SqlColumnNumber = 4, SqlFieldName = RBRC_SessionType_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBResContrast(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RBRC_Dept_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBRC_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RBRC_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBResContrast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RBRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RBRC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Global>^DHCRBResContrast</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RBRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBRC_Dept_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBRC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeptRes">
<Condition>$p({RBRC_Resource_DR},$c(1))'=""</Condition>
<ConditionFields>RBRC_Resource_DR</ConditionFields>
<Global>^DHCRBResContrast</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RBRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptRes"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBRC_Dept_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBRC_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBRC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RBRC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCRBResContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
