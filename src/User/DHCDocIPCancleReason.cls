Class User.DHCDocIPCancleReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDocIPCancleReason, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 10000;

/// 作废原因代码
Property CancleReasonCode As %String [ SqlColumnNumber = 2, SqlFieldName = CancleReason_Code ];

/// 作废原因描述
Property CancleReasonDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CancleReason_Desc ];

/// 是否是维护的
Property IsActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = IsActive ];

/// 医院
Property HospDr As CTHospital [ SqlColumnNumber = 5, SqlFieldName = Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>10000</ExtentSize>
<SqlIdExpression>$i(^DHCDocIPCR(0))</SqlIdExpression>
<SQLMap name="CddeIdx">
<Global>^DHCDocIPCRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CancleReasonCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CancleReason_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CodeActiveIdx">
<Global>^DHCDocIPCRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CancleReasonCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CancleReason_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"IsActive"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IsActive}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMasterMap">
<Data name="CancleReason_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CancleReason_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocIPCR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPCancleReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
