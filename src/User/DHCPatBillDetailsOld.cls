Class User.DHCPatBillDetailsOld Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PBDO_RowId, SqlTableName = DHC_PatBillDetailsOld, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PBDO_PBD_DR
Property PBDOPBDDR As User.DHCPatBillDetails [ SqlColumnNumber = 2, SqlFieldName = PBDO_PBD_DR ];

/// PBDO_OEORI_DR
Property PBDOTARIDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = PBDO_TARI_DR ];

/// PBDO_UnitPrice
Property PBDOUnitPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PBDO_UnitPrice ];

/// PBDO_BillQty
Property PBDOBillQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PBDO_BillQty ];

/// PBDO_DiscPerc
Property PBDODiscPerc As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PBDO_DiscPerc ];

/// PBDO_TotalAmount
Property PBDOTotalAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PBDO_TotalAmount ];

/// PBDO_DiscAmount
Property PBDODiscAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PBDO_DiscAmount ];

/// PBDO_PayOrShare
Property PBDOPayOrShare As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PBDO_PayOrShare ];

/// PBDO_PatientShare
Property PBDOPatientShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PBDO_PatientShare ];

/// PBDO_BillDate
Property PBDOBillDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PBDO_BillDate ];

/// PBDO_BillTime
Property PBDOBillTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PBDO_BillTime ];

/// PBDO_BillStatusFlag
Property PBDOBillStatusFlag As %Library.String(DISPLAYLIST = ",Normal,Abort,Strike,Deleted", MAXLEN = 7, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S,D") [ SqlColumnNumber = 13, SqlFieldName = PBDO_BillStatusFlag ];

/// PBDO_CreateDate
Property PBDOCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PBDO_CreateDate ];

/// PBDO_CreateTime
Property PBDOCreateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = PBDO_CreateTime ];

/// PBDO_BillUser
Property PBDOBillUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PBDO_BillUser ];

/// PBDO_ExecDept_DR
Property PBDOExecDeptDR As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = PBDO_ExecDept_DR ];

/// PBDO_DiscPrice
Property PBDODiscPrice As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PBDO_DiscPrice ];

/// PBDO_InsPrice
Property PBDOInsPrice As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PBDO_InsPrice ];

/// PBDO_PatPrice
Property PBDOPatPrice As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = PBDO_PatPrice ];

/// PBDO_BillOperateFlag
Property PBDOBillOperateFlag As %Library.String(DISPLAYLIST = ",ReBill,OrderChange,InitBill", MAXLEN = 11, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",RB,OC,IB") [ SqlColumnNumber = 21, SqlFieldName = PBDO_BillOperateFlag ];

/// PBDO_OEORI_DR
Property PBDOOEORIDR As User.OEOrdItem [ SqlColumnNumber = 22, SqlFieldName = PBDO_OEORI_DR ];

/// PBDO_PAADM_DR
Property PBDOPAADMDR As User.PAAdm [ SqlColumnNumber = 23, SqlFieldName = PBDO_PAADM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPBDO)</SqlIdExpression>
<SQLMap name="indexBillDate">
<Global>^DHCPBDOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PBDO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBDO_BillDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBDO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCreateDate">
<Global>^DHCPBDOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PBDO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBDO_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBDO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPBD">
<Global>^DHCPBDOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PBDO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatBillDetails"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBDO_PBD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBDO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpaadm">
<Global>^DHCPBDOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PBDO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBDO_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBDO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterdata">
<Data name="PBDO_BillDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PBDO_BillOperateFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PBDO_BillQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PBDO_BillStatusFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PBDO_BillTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PBDO_BillUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PBDO_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PBDO_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PBDO_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PBDO_DiscPerc">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PBDO_DiscPrice">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PBDO_ExecDept_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PBDO_InsPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PBDO_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PBDO_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PBDO_PBD_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PBDO_PatPrice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PBDO_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PBDO_PayOrShare">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PBDO_TARI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBDO_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PBDO_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPBDO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PBDO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PBDO_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPatBillDetailsOldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
