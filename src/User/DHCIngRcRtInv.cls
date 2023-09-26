Class User.DHCIngRcRtInv Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = INGRINV_RowId, SqlTableName = DHC_IngRcRtInv, StorageStrategy = SQLStorage ]
{

Property INGRINVINGRTRowId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INGRINV_INGRT_RowId ];

Property INGRINVDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INGRINV_Date ];

Property INGRINVTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = INGRINV_Time ];

Property INGRINVSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = INGRINV_SSUSR_DR ];

Property INGRINVAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INGRINV_Audit_Date ];

Property INGRINVAuditTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INGRINV_Audit_Time ];

Property INGRINVAuditSSUSRDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = INGRINV_Audit_SSUSR_DR ];

Property INGRINVReAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = INGRINV_ReAudit_Date ];

Property INGRINVReAuditTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = INGRINV_ReAudit_Time ];

Property INGRINVReAuditSSUSRDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = INGRINV_ReAudit_SSUSR_DR ];

Property INGRINVType As %Library.String(DISPLAYLIST = ",Receive,Return", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",G,R") [ SqlColumnNumber = 12, SqlFieldName = INGRINV_Type ];

Property INGRINVRefuseReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INGRINV_RefuseReason ];

Property INGRINVINGRTItmRowId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INGRINV_INGRTItm_RowId ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRcRtInv)</SqlIdExpression>
<SQLMap name="DataMIngRcRtInv">
<Data name="INGRINV_Audit_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRINV_Audit_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGRINV_Audit_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGRINV_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRINV_INGRTItm_RowId">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGRINV_INGRT_RowId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRINV_ReAudit_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGRINV_ReAudit_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INGRINV_ReAudit_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INGRINV_RefuseReason">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INGRINV_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGRINV_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRINV_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCRcRtInv</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INGRINV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeAuditDate">
<Global>^DHCRcRtInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGRINV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TypeAuditDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_Audit_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCRcRtInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGRINV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeINGRTRowId">
<Global>^DHCRcRtInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGRINV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TypeINGRTRowId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_INGRT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeReAuditDate">
<Global>^DHCRcRtInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGRINV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TypeReAuditDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_ReAudit_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRINV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INGRINV_RowId</SqlRowIdName>
<StreamLocation>^User.DHCIngRcRtInvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCRcRtInv)
	s oldI = +$g(^mdata("DHCRcRtInv"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCRcRtInv = maxI
	s ^mdata("DHCRcRtInv") = maxI
}

}
