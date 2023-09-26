/// 科室协定方申请主表（新疆中医院） 2017-12-14 hulihua 
/// d ##Class(User.DHCPhaAgrPartyReq).%BuildIndices()
Class User.DHCPhaAgrPartyReq Extends (%Library.Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHAAPR_RowId, SqlTableName = DHC_PhaAgrPartyReq, StorageStrategy = SQLStorage ]
{

/// 和子表做关联	
Relationship ChildDHCPhaAgrPartyReqItm As User.DHCPhaAgrPartyReqItm [ Cardinality = children, Inverse = PHAAPRIPHAAPRParRef ];

/// 申请病区ID
Property PHAAPRWardLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PHAAPR_WardLocDR ];

/// 发药药房ID
Property PHAAPRPHALocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHAAPR_PHALocDR ];

/// 申请日期
Property PHAAPRAgrReqDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHAAPR_AgrReqDate ];

/// 申请时间
Property PHAAPRAgrReqTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PHAAPR_AgrReqTime ];

/// 申请人DR
Property PHAAPRAgrReqUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PHAAPR_AgrReqUserDR ];

/// 申请单状态（R-申请，D-已发药，C-作废）
Property PHAAPRStatus As %Library.String(MAXLEN = 7, SELECTIVITY = "25.0000%", VALUELIST = ",R,D,C") [ SqlColumnNumber = 7, SqlFieldName = PHAAPR_Status ];

/// 发放日期
Property PHAAPRAgrDispDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PHAAPR_AgrDispDate ];

/// 发放时间
Property PHAAPRAgrDispTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PHAAPR_AgrDispTime ];

/// 发放人DR
Property PHAAPRAgrDispUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PHAAPR_AgrDispUserDR ];

/// 申请单号
Property PHAAPRAgrReqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHAAPR_AgrReqNo ];

/// 库存转移主表DR
Property PHAAPRInIsTrfDR As User.DHCInIsTrf [ SqlColumnNumber = 12, SqlFieldName = PHAAPR_InIsTrf_DR ];

/// 来源病区ID
Property PHAAPRFromWardLocDR As User.CTLoc [ SqlColumnNumber = 13, SqlFieldName = PHAAPR_FromWardLocDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHAAPR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHAAPR_AgrDispDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHAAPR_AgrDispTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHAAPR_AgrDispUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHAAPR_AgrReqDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHAAPR_AgrReqNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHAAPR_AgrReqTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAAPR_AgrReqUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHAAPR_FromWardLocDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHAAPR_InIsTrf_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHAAPR_PHALocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHAAPR_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHAAPR_WardLocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHAAPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAAPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAAPR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDispDatePhloc">
<Global>^DHCPHAAPRi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHAAPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DispDatePhloc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAAPR_AgrDispDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAAPR_PHALocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAAPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusDatePhloc">
<Global>^DHCPHAAPRi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHAAPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DatePhLocStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAAPR_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAAPR_AgrReqDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAAPR_PHALocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAAPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusWardLocPhLoc">
<Global>^DHCPHAAPRi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHAAPR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"StatusWardLocPhLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAAPR_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAAPR_WardLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAAPR_PHALocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAAPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaAgrPartyReqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
