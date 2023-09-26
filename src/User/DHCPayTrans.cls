/// 付款(或发票确认)台帐,主要记录业务单据的财务流水,场景可以为发票审批,也可为付款审批
Class User.DHCPayTrans Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = PAYTR_RowId, SqlTableName = DHC_PayTrans, StorageStrategy = SQLStorage ]
{

/// 业务类型, G(入库发票), R(退货发票), GC(入库发票取消), RC(退货发票取消)
Property PAYTRType As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PAYTR_Type ];

Property PAYTRPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PAYTR_Pointer ];

Property PAYTRCTLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PAYTR_CTLoc_DR ];

Property PAYTRAPCVMDR As User.APCVendor [ SqlColumnNumber = 5, SqlFieldName = PAYTR_APCVM_DR ];

Property PAYTRINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 6, SqlFieldName = PAYTR_INCLB_DR ];

Property PAYTRRpAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PAYTR_RpAmount ];

Property PAYTRDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = PAYTR_Date ];

Property PAYTRTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PAYTR_Time ];

Property PAYTRSSUSRDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PAYTR_SSUSR_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPAYTRANS(0))</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="PAYTR_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAYTR_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAYTR_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAYTR_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAYTR_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAYTR_RpAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAYTR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAYTR_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAYTR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPAYTRANS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAYTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PAYTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexdateinclb">
<Global>^DHCPAYTRANS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAYTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATEINCLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PAYTR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PAYTR_INCLB_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PAYTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexloctypedate">
<Global>^DHCPAYTRANS</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PAYTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCTYPEDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAYTR_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAYTR_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAYTR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAYTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indextypepointer">
<Global>^DHCPAYTRANS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAYTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAYTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAYTR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAYTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAYTR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPayTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
