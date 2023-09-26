Class User.DHCJFQFTotal Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = QF_RowId, SqlTableName = DHC_JFQFTotal, StorageStrategy = SQLStorage ]
{

/// QF_Adm
Property QFAdm As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = QF_Adm ];

/// QF_Date
Property QFDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 3, SqlFieldName = QF_Date ];

/// QF_Time
Property QFTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 4, SqlFieldName = QF_Time ];

/// QF_Amount
Property QFAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = QF_Amount ];

/// QF_Flag (Q:欠费结算, B:补交, C:结存结算, T:退款)
Property QFFlag As %Library.String(VALUELIST = ",Q,B,C,T") [ SqlColumnNumber = 6, SqlFieldName = QF_Flag ];

/// QF_AddUser
Property QFAddUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = QF_AddUser ];

/// QF_Comment
Property QFComment As %Library.String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = QF_Comment ];

/// QF_Status
Property QFStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = QF_Status ];

/// QF_Prt_dr
Property QFPrtdr As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = QF_Prt_dr ];

/// QF_Pb_dr
Property QFPbdr As User.DHCPatientBill [ SqlColumnNumber = 11, SqlFieldName = QF_Pb_dr ];

/// QF_Remain1
Property QFRemain1 As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = QF_Remain1 ];

/// QF_Remain2
Property QFRemain2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = QF_Remain2 ];

/// QF_PayMode_Dr
Property QFPayModeDr As User.CTPayMode [ SqlColumnNumber = 14, SqlFieldName = QF_PayMode_Dr ];

/// QF_HandIn
Property QFHandIn As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = QF_HandIn ];

/// QF_HandinDate
Property QFHandinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = QF_HandinDate ];

/// QF_HandinTime
Property QFHandinTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = QF_HandinTime ];

/// QF_JK_DR
Property QFJKDR As User.DHCJFUSERJK [ SqlColumnNumber = 18, SqlFieldName = QF_JK_DR ];

/// QF_Hosp_DR
Property QFHospDR As User.CTHospital [ SqlColumnNumber = 19, SqlFieldName = QF_Hosp_DR ];

/// QF_InitQF_DR
Property QFInitQFDR As User.DHCJFQFTotal [ SqlColumnNumber = 20, SqlFieldName = QF_InitQF_DR ];

/// QF_Comment3
Property QFComment3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = QF_Comment3 ];

/// QF_CurrentNo
Property QFCurrentNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = QF_CurrentNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFQFTOTAL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="QF_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QF_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QF_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QF_Comment">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QF_Comment3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="QF_CurrentNo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="QF_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QF_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QF_HandIn">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="QF_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="QF_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="QF_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="QF_InitQF_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="QF_JK_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="QF_PayMode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="QF_Pb_dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="QF_Prt_dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="QF_Remain1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="QF_Remain2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="QF_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QF_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCJFQFTOTAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{QF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandin">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandIn"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_HandIn}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_AddUser}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandinDate">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandinDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_HandinDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJKDR">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JKDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_JK_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPRTDR">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRTDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Prt_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPBDR">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pbdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Pb_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexRemain1">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Remain1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Remain1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexRemain2">
<Global>^DHCJFQFTOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Remain2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Remain2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFQFTotalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
