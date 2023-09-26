Class User.DHCConTrack Extends (%Persistent, User.Abstract) [ SqlRowIdName = Cont_RowId, SqlTableName = DHC_Contrack, StorageStrategy = SQLStorage ]
{

Property ContNo As %Library.String [ SqlColumnNumber = 2, SqlFieldName = Cont_No ];

Property ContDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = Cont_Date ];

Property ContRemark As %Library.String [ SqlColumnNumber = 4, SqlFieldName = Cont_Remark ];

Property ContPicUrl As %Library.String [ SqlColumnNumber = 5, SqlFieldName = Cont_PicUrl ];

Property ContEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = Cont_EndDate ];

Property ContCTLOCDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = Cont_CTLOC_DR ];

Property ContRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = Cont_RegDate ];

Property ContAPCVMDR As User.APCVendor [ SqlColumnNumber = 9, SqlFieldName = Cont_APCVM_DR ];

/// 临采标记
Property ContLcFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = Cont_LcFlag ];

/// 停用标记
Property ContStopFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = Cont_StopFlag ];

/// 审核标记
Property ContAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = Cont_AuditFlag ];

/// 审核标记
Property ContAuditUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = Cont_AuditUser_DR ];

Property ContAuditDate As %Library.Date [ SqlColumnNumber = 14, SqlFieldName = Cont_AuditDate ];

/// 提交标记
Property ContCompFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 15, SqlFieldName = Cont_CompFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCSTMCONTRACK)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Cont_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Cont_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Cont_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Cont_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Cont_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Cont_CompFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Cont_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Cont_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Cont_LcFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Cont_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Cont_PicUrl">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Cont_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Cont_Remark">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Cont_StopFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCSTMCONTRACK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Cont_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Cont_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>Cont_RowId</SqlRowIdName>
<StreamLocation>^User.DHCConTrackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTMCONTRACK)
	s oldI = +$g(^mdata("DHCSTMCONTRACK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTMCONTRACK = maxI
	s ^mdata("DHCSTMCONTRACK") = maxI
}

}
