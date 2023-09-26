Class User.DHCEQPReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = R_RowID, SqlTableName = DHC_EQPReason, StorageStrategy = SQLStorage ]
{

/// 医院
Property RHospitalDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = R_HospitalDR ];

/// 业务类型
Property RSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = R_SourceType ];

/// 业务ID
Property RSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = R_SourceID ];

/// 原因
Property RReasonDR As DHCEQPCReason [ SqlColumnNumber = 5, SqlFieldName = R_ReasonDR ];

/// 备注
Property RRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = R_Remark ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQPReason("0"))</SqlIdExpression>
<SQLMap name="DateMap">
<Data name="R_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="R_ReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="R_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="R_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="R_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQPReason</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{R_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRReasonDR">
<Global>^DHCEQPReason</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RReasonDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_ReasonDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRSourceID">
<Global>^DHCEQPReason</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RSourceID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_SourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRSourceType">
<Global>^DHCEQPReason</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RSourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
