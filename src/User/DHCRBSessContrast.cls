Class User.DHCRBSessContrast Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_RBSessContrast, StorageStrategy = SQLStorage ]
{

Property RBSCCarePrvTypeDR As User.CTCarPrvTp [ SqlColumnNumber = 2, SqlFieldName = RBSC_CarePrvType_DR ];

Property RBSCSessionTypeDR As User.RBCSessionType [ SqlColumnNumber = 3, SqlFieldName = RBSC_SessionType_DR ];

Property RBSCHospDR As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = RBSC_Hosp_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBSessContrast(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RBSC_CarePrvType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBSC_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RBSC_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBSessContrast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RBSC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RBSC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCareType">
<Global>^DHCRBSessContrast</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RBSC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRVTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBSC_CarePrvType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBSC_Hosp_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBSC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RBSC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCRBSessContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
