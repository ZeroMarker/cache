Class User.DHCCardINVPRT Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CIP_RowID, SqlTableName = DHC_CardINVPRT, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCCardINVPRTPayMode As User.DHCCardINVPRTPayMode [ Cardinality = children, Inverse = CPMCIPParRef ];

/// CIP_PAPMI_DR
Property CIPPAPMIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CIP_PAPMI_DR ];

/// CIP_Flag
Property CIPFlag As %Library.String(DISPLAYLIST = ",Normal,Strike,Abort", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,S,A") [ SqlColumnNumber = 3, SqlFieldName = CIP_Flag ];

/// CIP_Amount
Property CIPAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CIP_Amount ];

/// CIP_Date
Property CIPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = CIP_Date ];

/// CIP_Time
Property CIPTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = CIP_Time ];

/// CIP_PUser_DR
Property CIPPUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CIP_PUser_DR ];

/// CIP_INVNo
Property CIPINVNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CIP_INVNo ];

/// CIP_INVPay_DR
Property CIPINVPayDR As User.DHCCardINVPRT [ SqlColumnNumber = 9, SqlFieldName = CIP_INVPay_DR ];

/// CIP_INVReports_DR
Property CIPINVReportsDR As User.DHCINVPRTReports [ SqlColumnNumber = 10, SqlFieldName = CIP_INVReports_DR ];

/// CIP_Note1
Property CIPNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CIP_Note1 ];

/// CIP_Note2
Property CIPNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CIP_Note2 ];

/// CIP_Note3
Property CIPNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CIP_Note3 ];

/// CIP_Note4
Property CIPNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CIP_Note4 ];

/// CIP_Note5
Property CIPNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CIP_Note5 ];

/// CIP_Note6
Property CIPNote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CIP_Note6 ];

/// CIP_Note7
Property CIPNote7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CIP_Note7 ];

/// CIP_Note8
Property CIPNote8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CIP_Note8 ];

/// CIP_Note9
Property CIPNote9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CIP_Note9 ];

/// CIP_Note10
Property CIPNote10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CIP_Note10 ];

/// CIP_HospitalDR
Property CIPHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CIP_HospitalDR ];

/// CIP_Handin
Property CIPHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = CIP_Handin ];

/// CIP_HandinDate
Property CIPHandinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = CIP_HandinDate ];

/// CIP_HandinTime
Property CIPHandinTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = CIP_HandinTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARDINVPRT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CIP_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CIP_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CIP_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CIP_Handin">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CIP_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CIP_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CIP_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CIP_INVNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CIP_INVPay_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CIP_INVReports_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CIP_Note1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CIP_Note10">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CIP_Note2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CIP_Note3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CIP_Note4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CIP_Note5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CIP_Note6">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CIP_Note7">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CIP_Note8">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CIP_Note9">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CIP_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CIP_PUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CIP_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCCARDINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CIP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CIP_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandInDate">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CIP_HandinDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandin">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandIn"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CIP_Handin}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CIP_PUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINVNo">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INVNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CIP_INVNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINVPayDR">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INVPAYDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CIP_INVPay_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINVReportsDR">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CIP_INVReports_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDR">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CIP_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CIP_PUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCCARDINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CIP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CIP_PUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CIP_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCardINVPRTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
