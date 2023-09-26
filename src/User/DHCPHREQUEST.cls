Class User.DHCPHREQUEST Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHReq_Rowid, SqlTableName = DHC_PHREQUEST, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHREQITEM As User.DHCPHREQITEM [ Cardinality = children, Inverse = PHReqiPHReqparref ];

/// PHReq_CancelFlag
Property PHReqCancelFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHReq_CancelFlag ];

/// PHReq_Code
Property PHReqCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHReq_Code ];

/// PHReq_Ctloc_dr
Property PHReqCtlocdr As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = PHReq_Ctloc_dr ];

/// PHReq_Date
Property PHReqDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHReq_Date ];

/// PHReq_NewPrt_dr
Property PHReqNewPrtdr As User.DHCINVPRT [ SqlColumnNumber = 16, SqlFieldName = PHReq_NewPrt_dr ];

/// PHReq_Papmi_dr
Property PHReqPapmidr As User.PAPatMas [ SqlColumnNumber = 7, SqlFieldName = PHReq_Papmi_dr ];

/// PHReq_Phd_dr
Property PHReqPhddr As User.DHCPHDISPEN [ SqlColumnNumber = 8, SqlFieldName = PHReq_Phd_dr ];

/// PHReq_Prescno
Property PHReqPrescno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHReq_Prescno ];

/// PHReq_Prt_dr
Property PHReqPrtdr As User.DHCINVPRT [ SqlColumnNumber = 15, SqlFieldName = PHReq_Prt_dr ];

/// PHReq_RetDate
Property PHReqRetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PHReq_RetDate ];

/// PHReq_RetFlag
Property PHReqRetFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHReq_RetFlag ];

/// PHReq_RetLoc_dr
Property PHReqRetLocdr As User.CTLoc [ SqlColumnNumber = 19, SqlFieldName = PHReq_RetLoc_dr ];

/// PHReq_RetReason
Property PHReqRetReason As User.DHCINVOPRefReason [ SqlColumnNumber = 9, SqlFieldName = PHReq_RetReason ];

/// PHReq_RetTime
Property PHReqRetTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = PHReq_RetTime ];

/// PHReq_RetUsr
Property PHReqRetUsr As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = PHReq_RetUsr ];

/// PHReq_Time
Property PHReqTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PHReq_Time ];

/// PHReq_Usr
Property PHReqUsr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHReq_Usr ];

/// PHReq_Year
Property PHReqYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHReq_Year ];

/// 拒绝退药标志
Property PHReqRefuseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = PHReq_RefuseFlag ];

/// 拒绝退药原因
Property PHReqRefuseReason As User.PHRRefuseReason [ SqlColumnNumber = 21, SqlFieldName = PHReq_RefuseReason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHREQ)</SqlIdExpression>
<SQLMap name="phreqindexdate">
<Global>^DHCPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHReq_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHReq_Date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHReq_Ctloc_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHReq_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phreqindexpapmi">
<Global>^DHCPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHReq_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHReq_Papmi_dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHReq_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHReq_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phreqindexphdisp">
<Global>^DHCPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHReq_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DISP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHReq_Phd_dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHReq_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phreqindexreqcode">
<Global>^DHCPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHReq_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHReq_Year}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHReq_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHReq_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phreqmaster">
<Data name="PHReq_CancelFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHReq_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHReq_Ctloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHReq_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHReq_NewPrt_dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHReq_Papmi_dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHReq_Phd_dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHReq_Prescno">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHReq_Prt_dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHReq_RefuseFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHReq_RefuseReason">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHReq_RetDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHReq_RetFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHReq_RetLoc_dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHReq_RetReason">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHReq_RetTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHReq_RetUsr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHReq_Time">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHReq_Usr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHReq_Year">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCPHREQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHReq_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHReq_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHREQUESTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHREQ)
	s oldI = +$g(^mdata("DHCPHREQUEST"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHREQ = maxI
	s ^mdata("DHCPHREQUEST") = maxI
}

}
