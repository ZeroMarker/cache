Class User.DHCASPAmtVend Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASPAV_RowId, SqlTableName = DHC_ASPAmtVend, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Relationship ChildDHCASPAmtVendItm As User.DHCASPAmtVendItm [ Cardinality = children, Inverse = ASPAVIASPAVParRef ];

/// 保存日期
Property ASPAVDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 2, SqlFieldName = ASPAV_Date ];

/// 保存时间
Property ASPAVTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = ASPAV_Time ];

/// 保存人 SSUSR :User.SSUser
Property ASPAVSSUSRDR As User.SSUser [ Required, SqlColumnNumber = 4, SqlFieldName = ASPAV_SSUSR_DR ];

/// 状态 10保存,20确认,30审核
Property ASPAVStatus As %Library.String [ SqlColumnNumber = 5, SqlFieldName = ASPAV_Status ];

/// 单号
Property ASPAVNo As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, SELECTIVITY = 1, TRUNCATE = 0) [ Required, SqlColumnNumber = 6, SqlFieldName = ASPAV_No ];

/// 供应商 ASPAV_APCVM_DR : User.APCVendor
Property ASPAVAPCVMDR As User.APCVendor [ SqlColumnNumber = 7, SqlFieldName = ASPAV_APCVM_DR ];

/// 开始日期
Property ASPAVFromDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = ASPAV_FromDate ];

/// 结束日期
Property ASPAVToDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 9, SqlFieldName = ASPAV_ToDate ];

/// 备注 ASPAV_Remarks 
Property ASPAVRemarks As %Library.String [ SqlColumnNumber = 10, SqlFieldName = ASPAV_Remarks ];

/// 审核日期
Property ASPAVAuditDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 11, SqlFieldName = ASPAV_AuditDate ];

/// 审核时间
Property ASPAVAuditTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = ASPAV_AuditTime ];

/// 审核人 SSUSR :User.SSUser
Property ASPAVAuditUsrDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = ASPAV_AuditUsr_DR ];

/// ASPAV_INASP_DR
Property ASPAVINASPDR As User.INAdjSalePrice [ SqlColumnNumber = 14, SqlFieldName = ASPAV_INASP_DR ];

/// ASPAV_DifAmt
Property ASPAVDifAmt As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = ASPAV_DifAmt ];

/// ASPAV_Hosp_Dr
Property ASPAVHospDr As User.CTHospital [ SqlColumnNumber = 16, SqlFieldName = ASPAV_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SqlIdExpression>$i(^DHCASPAV)</SqlIdExpression>
<SQLMap name="AspNoIndex">
<Global>^DHCASPAV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASPAV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AspNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPAV_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASPAV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="ASPAV_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASPAV_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASPAV_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ASPAV_AuditUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ASPAV_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASPAV_DifAmt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ASPAV_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ASPAV_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ASPAV_INASP_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ASPAV_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASPAV_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ASPAV_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASPAV_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASPAV_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASPAV_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCASPAV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASPAV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ASPAV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DateIndex">
<Global>^DHCASPAV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASPAV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ASPAVDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPAV_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASPAV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="VenDateIndex">
<Global>^DHCASPAV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ASPAV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VenDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPAV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASPAV_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASPAV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCASPAmtVendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCASPAV)
	s oldI = +$g(^mdata("DHCASPAV"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCASPAV = maxI
	s ^mdata("DHCASPAV") = maxI
}

}
