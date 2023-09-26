Class User.DHCPEINVPRT Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRT_ROWID, SqlTableName = DHC_PE_INVPRT, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEINVPRT";

Parameter EXTENTSIZE = 250;

/// PRT_INVNO
Property PRTINVNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PRT_INVNO ];

/// PRT_PAADM_DR    User.PAAdm
Property PRTPAADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PRT_PAADM_DR ];

/// PRT_PB_DR
Property PRTPBDR As User.DHCPatientBill [ SqlColumnNumber = 4, SqlFieldName = PRT_PB_DR ];

/// PRT_ARRCP_DR    User.ARReceipts
Property PRTARRCPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PRT_ARRCP_DR ];

/// PRT_PAPMI_DR    User.PAPatMas
Property PRTPAPMIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PRT_PAPMI_DR ];

/// PRT_Deposit
Property PRTDeposit As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PRT_Deposit ];

/// PRT_Acount
Property PRTAcount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PRT_Acount ];

/// PRT_Flag
Property PRTFlag As %Library.String(DISPLAYLIST = ",Normal,Abort,Strike", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S") [ SqlColumnNumber = 9, SqlFieldName = PRT_Flag ];

/// PRT_REFINV_DR
Property PRTREFINVDR As User.DHCPEINVPRT [ SqlColumnNumber = 10, SqlFieldName = PRT_REFINV_DR ];

/// PRT_USER_DR    User.SSUser
Property PRTUSERDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PRT_USER_DR ];

/// PRT_DATE
Property PRTDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PRT_DATE ];

/// PRT_TIME
Property PRTTIME As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PRT_TIME ];

// Property PRTREPORTDR As User.DHCPEUSERREPORT [ SqlColumnNumber = 14, SqlFieldName = PRT_REPORT_DR ];

// 计费日结报表DHCINVPRTReports

/// PRT_REPORT_DR
Property PRTREPORTDR As User.DHCINVPRTReports [ SqlColumnNumber = 14, SqlFieldName = PRT_REPORT_DR ];

/// PRT_RPUSER_DR    User.SSUser
Property PRTRPUSERDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PRT_RPUSER_DR ];

/// PRT_RPDATE
Property PRTRPDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = PRT_RPDATE ];

/// PRT_RPTIME
Property PRTRPTIME As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = PRT_RPTIME ];

/// PRT_VERUSER_DR    User.SSUser
Property PRTVERUSERDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PRT_VERUSER_DR ];

/// PRT_VERDATE
Property PRTVERDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = PRT_VERDATE ];

/// PRT_VERTIME
Property PRTVERTIME As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = PRT_VERTIME ];

/// PRT_INVTITLE
Property PRTINVTITLE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PRT_INVTITLE ];

/// PRT_NOTE1
Property PRTNOTE1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PRT_NOTE1 ];

/// PRT_NOTE2
Property PRTNOTE2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PRT_NOTE2 ];

/// PRT_NOTE3
Property PRTNOTE3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PRT_NOTE3 ];

/// PRT_RPFLAG
Property PRTRPFLAG As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = PRT_RPFLAG ];

/// PRT_VERFLAG
Property PRTVERFLAG As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = PRT_VERFLAG ];

/// PRT_HospitalDR 院区
Property PRTHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PRT_Hospital_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEINVPRT)</SqlIdExpression>
<SQLMap name="dataDHCPEINVPRT">
<Data name="PRT_ARRCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRT_Acount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRT_DATE">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PRT_Deposit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PRT_INVNO">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRT_INVTITLE">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PRT_NOTE1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PRT_NOTE2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PRT_NOTE3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PRT_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRT_PB_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRT_REFINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PRT_REPORT_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PRT_RPDATE">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PRT_RPFLAG">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PRT_RPTIME">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PRT_RPUSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PRT_TIME">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PRT_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRT_VERDATE">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PRT_VERFLAG">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PRT_VERTIME">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PRT_VERUSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCPEINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexadm">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_DATE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinv">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_INVNO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpapmi">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMIADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_PAADM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpb">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_PB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexrefinv">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"REF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_REFINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexreport">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"REPORT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_REPORT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexreportdate">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RPDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_RPDATE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_RPUSER_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexrpflag">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RPFLAG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_USER_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_RPFLAG}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_USER_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_DATE}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexverflag">
<Global>^DHCPEINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"VERFLAG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_USER_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_VERFLAG}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEINVPRTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
