Class User.DHCStockVoucher Extends (%Persistent, User.Abstract) [ SqlRowIdName = SVC_ROWID, SqlTableName = DHC_StockVoucher, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCStockVoucherItm As User.DHCStockVoucherItm [ Cardinality = children, Inverse = SVCISVCParref ];

Property SVCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SVC_Type ];

Property SVCPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SVC_Pointer ];

Property SVCSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = SVC_SSUSR_DR ];

Property SVCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = SVC_Date ];

Property SVCTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = SVC_Time ];

Property SVCVoucherNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SVC_VoucherNo ];

Property SVCLocDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = SVC_Loc_Dr ];

Property SVCMonth As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = SVC_Month ];

Property SVCStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = SVC_StartDate ];

Property SVCEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = SVC_EndDate ];

Property SVCSCGDr As User.DHCStkCatGroup [ SqlColumnNumber = 12, SqlFieldName = SVC_SCG_Dr ];

Property SVCAPCVMDr As User.APCVendor [ SqlColumnNumber = 13, SqlFieldName = SVC_APCVM_Dr ];

Property SVCRpAmt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = SVC_RpAmt ];

Property SVCSpAmt As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = SVC_SpAmt ];

Property SVCExpUserDr As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = SVC_ExpUser_Dr ];

Property SVCExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = SVC_ExpDate ];

Property SVCExpTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = SVC_ExpTime ];

Property SVCExpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = SVC_ExpFlag ];

Property SVCYEAR As %Library.String [ SqlColumnNumber = 20, SqlFieldName = SVC_YEAR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSVC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SVC_APCVM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SVC_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SVC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SVC_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SVC_ExpFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SVC_ExpTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SVC_ExpUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SVC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SVC_Month">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SVC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SVC_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SVC_SCG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SVC_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SVC_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SVC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SVC_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SVC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SVC_VoucherNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SVC_YEAR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCSVC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SVC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SVC_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocMonth">
<Global>^DHCSVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SVC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCMONTH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SVC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SVC_Month}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SVC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocYearMonth">
<Global>^DHCSVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SVC_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCYEARMONTH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SVC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SVC_YEAR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SVC_Month}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SVC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonth">
<Global>^DHCSVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SVC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MONTH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SVC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SVC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SVC_Month}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SVC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCSVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SVC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SVC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SVC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SVC_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SVC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexpointer">
<Global>^DHCSVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SVC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SVC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SVC_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SVC_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SVC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SVC_ROWID</SqlRowIdName>
<StreamLocation>^User.DHCStockVoucherS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSVC)
	s oldI = +$g(^mdata("DHCSTOCKVOUCHER"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSVC = maxI
	s ^mdata("DHCSTOCKVOUCHER") = maxI
}

Parameter EXTENTSIZE = 250;

}
