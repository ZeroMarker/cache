Class User.DHCPHRETURN Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHRET_ROWID, SqlTableName = DHC_PHRETURN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHRETITM As User.DHCPHRETITM [ Cardinality = children, Inverse = PHRTIPHRETPARREF ];

/// PHRET_CODE
Property PHRETCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHRET_CODE ];

/// PHRET_DATE
Property PHRETDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHRET_DATE ];

/// PHRET_TIME
Property PHRETTIME As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PHRET_TIME ];

/// PHRET_PHL_DR
Property PHRETPHLDR As User.DHCPHLOC [ SqlColumnNumber = 5, SqlFieldName = PHRET_PHL_DR ];

/// PHRET_MONTH
Property PHRETMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PHRET_MONTH ];

/// PHRET_PRT_DR
Property PHRETPRTDR As User.DHCINVPRT [ SqlColumnNumber = 7, SqlFieldName = PHRET_PRT_DR ];

/// PHRET_INV
Property PHRETINV As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHRET_INV ];

/// PHRET_TOTAL
Property PHRETTOTAL As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PHRET_TOTAL ];

/// PHRET_PHD_DR
Property PHRETPHDDR As User.DHCPHDISPEN [ SqlColumnNumber = 10, SqlFieldName = PHRET_PHD_DR ];

/// PHRET_PHP_DR
Property PHRETPHPDR As User.DHCPHPERSON [ SqlColumnNumber = 11, SqlFieldName = PHRET_PHP_DR ];

/// PHRET_TYCLFLAG
Property PHRETTYCLFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHRET_TYCLFLAG ];

/// PHRET_PAADM_DR
Property PHRETPAADMDR As User.PAAdm [ SqlColumnNumber = 13, SqlFieldName = PHRET_PAADM_DR ];

/// PHRET_RFR_DR
Property PHRETRFRDR As User.DHCINVOPRefReason [ SqlColumnNumber = 14, SqlFieldName = PHRET_RFR_DR ];

/// PHRET_TYPE
Property PHRETTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHRET_TYPE ];

/// phret_ctlocdoctor
Property phretctlocdoctor As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = phret_ctlocdoctor ];

/// PHRET_NEWPRT_DR
Property PHRETNEWPRTDR As User.DHCINVPRT [ SqlColumnNumber = 17, SqlFieldName = PHRET_NEWPRT_DR ];

/// PHRET_REQ_DR
Property PHRETREQDR As User.DHCPHREQUEST [ SqlColumnNumber = 18, SqlFieldName = PHRET_REQ_DR ];

/// PHRET_ACKPHP_DR
Property PHRETACKPHPDR As User.DHCPHPERSON [ SqlColumnNumber = 19, SqlFieldName = PHRET_ACKPHP_DR ];

/// PHRET_RetClFlag
Property PHRETRetClFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PHRET_RetClFlag ];

/// PHRET_RetClDate
Property PHRETRetClDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = PHRET_RetClDate ];

/// PHRET_RetClTime
Property PHRETRetClTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = PHRET_RetClTime ];

/// PHRET_RetClUser_DR
Property PHRETRetClUserDR As User.DHCPHPERSON [ SqlColumnNumber = 23, SqlFieldName = PHRET_RetClUser_DR ];

Property PHRETRetClReason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PHRET_RetClReason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHRET)</SqlIdExpression>
<SQLMap name="DATAMASTER">
<Data name="PHRET_ACKPHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHRET_CODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHRET_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHRET_INV">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHRET_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHRET_NEWPRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHRET_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHRET_PHD_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHRET_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHRET_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHRET_PRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHRET_REQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHRET_RFR_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHRET_RetClDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHRET_RetClFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHRET_RetClReason">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHRET_RetClTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHRET_RetClUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHRET_TIME">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHRET_TOTAL">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHRET_TYCLFLAG">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHRET_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="phret_ctlocdoctor">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCPHRET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHRET_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHRET_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexdate">
<Global>^DHCPHRETi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHRET_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHRET_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHRET_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHRET_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHRETINDEXLOC">
<Global>^DHCPHRETi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHRET_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHRET_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHRET_PRT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHRET_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHRETINDEXNEWPRT">
<Global>^DHCPHRETi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHRET_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NEWPRT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHRET_NEWPRT_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHRET_PHL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHRET_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHRETINDEXPHD">
<Global>^DHCPHRETi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHRET_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHRET_PHL_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHRET_PHD_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHRET_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phretprt">
<Global>^DHCPHRETi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHRET_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHRET_PRT_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHRET_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHRETURNS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHRET)
	s oldI = +$g(^mdata("DHCPHRETURN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHRET = maxI
	s ^mdata("DHCPHRETURN") = maxI
}

}
