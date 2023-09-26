Class User.DHCTmpReqRecords Extends (%Persistent, User.Abstract) [ SqlRowIdName = TMPRR_RowId, SqlTableName = DHC_TmpReqRecords, StorageStrategy = SqlStorage ]
{

Property TMPRRSSUSRDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = TMPRR_SSUSR_DR ];

Property TMPRRCTLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = TMPRR_CTLOC_DR ];

Property TMPRRINCIDR As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = TMPRR_INCI_DR ];

Property TMPRRQty As %String [ SqlColumnNumber = 5, SqlFieldName = TMPRR_Qty ];

Property TMPRRCTUOMDR As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = TMPRR_CTUOM_DR ];

Property TMPRRRp As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = TMPRR_Rp ];

Property TMPRRPHMNFDR As User.PHManufacturer [ SqlColumnNumber = 8, SqlFieldName = TMPRR_PHMNF_DR ];

Property TMPRRRemark As %String [ SqlColumnNumber = 9, SqlFieldName = TMPRR_Remark ];

Property TMPRRDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = TMPRR_Date ];

Property TMPRRTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = TMPRR_Time ];

Property TMPRRProvLOCDR As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = TMPRR_ProvLOC_DR ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCTMPREQREC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TMPRR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TMPRR_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TMPRR_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TMPRR_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TMPRR_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TMPRR_ProvLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TMPRR_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TMPRR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TMPRR_Rp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TMPRR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TMPRR_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCTMPREQREC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TMPRR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{TMPRR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUserLoc">
<Global>^DHCTMPREQREC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TMPRR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"UserLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{TMPRR_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{TMPRR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{TMPRR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TMPRR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCTmpReqRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCTMPREQREC)
	s oldI = +$g(^mdata("DHCTMPREQRECORDS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCTMPREQREC = maxI
	s ^mdata("DHCTMPREQRECORDS") = maxI
}

}
