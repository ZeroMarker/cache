Class User.DHCRBCTLocConrast Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_RBCTLocContrast, StorageStrategy = SQLStorage ]
{

Property RBRLCareTypeDR As User.RBResource [ SqlColumnNumber = 2, SqlFieldName = RBRL_CareType_DR ];

Property RBRLSessionTypeDR As User.RBCSessionType [ SqlColumnNumber = 3, SqlFieldName = RBRL_SessionType_DR ];

Property RBRLDeptDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = RBRL_Dept_DR ];

Property RBSLHospDR As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = RBRL_Hosp_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBLocContrast(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RBRL_CareType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBRL_Dept_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RBRL_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RBRL_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBLocContrast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RBRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RBRL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAll">
<Global>^DHCRBLocContrasti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RBRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALLField"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBRL_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBRL_CareType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBRL_SessionType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBRL_Dept_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RBRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCareTypeDept">
<Global>^DHCRBLocContrasti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RBRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBRL_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBRL_CareType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBRL_Dept_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Global>^DHCRBLocContrasti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RBRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBRL_Dept_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RBRL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCRBCTLocConrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
