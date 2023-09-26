Class User.DHCRBApptScheduleStatusChangeLog Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ASSL_RowId, SqlTableName = DHC_RBApptScheduleStatusChangeLog, StorageStrategy = SQLStorage ]
{

/// ASSLRBASDR 
Property ASSLRBASDR As %Library.String [ SqlColumnNumber = 2, SqlFieldName = ASSL_RBAS_DR ];

/// ASSLUpdateDate  修改日期
Property ASSLUpdateDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = ASSL_UpdateDate ];

/// ASSLUpdateTime 修改时间
Property ASSLUpdateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = ASSL_UpdateTime ];

/// ASLUpdateUser 修改操作人
Property ASSLUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ASSL_UpdateUser ];

/// ASSLType 修改状态
Property ASSLStatusDR As DHCRBCASStatus [ SqlColumnNumber = 6, SqlFieldName = ASSL_Status_DR ];

/// ASLUpdateUser 修改操作人
Property ASSLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ASSL_Remark ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCASSLOG(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ASSL_RBAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASSL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASSL_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASSL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASSL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASSL_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCASSLOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASSL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ASSL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRBApptSchedule">
<Global>^DHCASSLOGi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ASSL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"APPTSCHEDULE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASSL_RBAS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASSL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASSL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBApptScED07S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
