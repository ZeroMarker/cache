Class User.DHCEQPCReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = R_RowID, SqlTableName = DHC_EQPCReason, StorageStrategy = SQLStorage ]
{

/// 医院
Property RHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = R_HospitalDR ];

/// 原因类型
Property RReasonType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = R_ReasonType ];

/// 辅助类型
Property RSubType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = R_SubType ];

/// 代码
Property RCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = R_Code ];

/// 描述
Property RDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = R_Desc ];

/// 备注
Property RRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = R_Remark ];

/// 需要补录其他信息标志
Property ROtherInfoFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = R_OtherInfoFlag ];

/// 无效标志
Property RInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = R_InvalidFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQPCReason("0"))</SqlIdExpression>
<SQLMap name="DateMap">
<Data name="R_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="R_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="R_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="R_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="R_OtherInfoFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="R_ReasonType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="R_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="R_SubType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQPCReason</Global>
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
<SQLMap name="IndexRReasonType">
<Global>^DHCEQPCReason</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RReasonType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_ReasonType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRSubType">
<Global>^DHCEQPCReason</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RSubType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_SubType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPCReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
