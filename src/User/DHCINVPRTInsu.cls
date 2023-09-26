Class User.DHCINVPRTInsu Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PrtInsu_Rowid, SqlTableName = DHC_INVPRTInsu, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCINVPRTInsuPaym As User.DHCINVPRTInsuPaym [ Cardinality = children, Inverse = IPMInsuPrtParref ];

/// PrtInsu_Prt_Dr
Property PrtInsuPrtDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PrtInsu_Prt_Dr ];

/// PrtInsu_Acount
Property PrtInsuAcount As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PrtInsu_Acount ];

/// PrtInsu_INVPrintFlag
Property PrtInsuINVPrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PrtInsu_INVPrintFlag ];

/// PrtInsu_ACCPINV_DR
Property PrtInsuACCPINVDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PrtInsu_ACCPINV_DR ];

/// PrtInsu_Date
Property PrtInsuDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = PrtInsu_Date ];

/// PrtInsu_Time
Property PrtInsuTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PrtInsu_Time ];

/// PrtInsu_User
Property PrtInsuUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PrtInsu_User ];

/// PrtInsu_DHCINVPRTR_DR
Property PrtInsuDHCINVPRTRDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PrtInsu_DHCINVPRTR_DR ];

/// PrtInsu_Flag
Property PrtInsuFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PrtInsu_Flag ];

/// PrtInsu_InsType_DR
Property PrtInsuInsTypeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PrtInsu_InsType_DR ];

/// PrtInsu_Handin
Property PrtInsuHandin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PrtInsu_Handin ];

/// PrtInsu_HandinDate
Property PrtInsuHandinDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 13, SqlFieldName = PrtInsu_HandinDate ];

/// PrtInsu_HandinTime
Property PrtInsuHandinTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = PrtInsu_HandinTime ];

/// PrtInsu_initinv_Dr
Property PrtInsuinitinvDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PrtInsu_initinv_Dr ];

/// PrtInsu_PAPMI_DR
Property PrtInsuPAPMIDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PrtInsu_PAPMI_DR ];

/// PrtInsu_OldINV_DR
Property PrtInsuOldINVDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PrtInsu_OldINV_DR ];

/// PrtInsu_InsDiv_DR
Property PrtInsuInsDivDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PrtInsu_InsDiv_DR ];

/// PrtInsu_YBPaySum
Property PrtInsuYBPaySum As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PrtInsu_YBPaySum ];

/// PrtInsu_FairType
Property PrtInsuFairType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PrtInsu_FairType ];

/// PrtInsu_OPCRoundErr
Property PrtInsuOPCRoundErr As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = PrtInsu_OPCRoundErr ];

/// PrtInsu_HospitalDR
Property PrtInsuHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PrtInsu_HospitalDR ];

/// PrtInsu_StrikeAcount --用于冲dhc_invprt表的支付宝/微信支付金额
Property PrtInsuStrikeAcount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PrtInsu_StrikeAcount ];

/// PrtInsu_Note2
Property PrtInsuNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PrtInsu_Note2 ];

/// PrtInsu_Note3
Property PrtInsuNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PrtInsu_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVPRTInsu)</SqlIdExpression>
<SQLMap name="indexaccdr">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ACCINV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_ACCPINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexhanddate">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_HandinDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexhosp">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_HospitalDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinitinvdr">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InitInv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_initinv_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinsdiv">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsDiv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_InsDiv_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinvrepdr">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_DHCINVPRTR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexoldinvdr">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OldINV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_OldINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpapmidr">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexprtdr">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_Prt_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtInsu_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterindex">
<Data name="PrtInsu_ACCPINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PrtInsu_Acount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PrtInsu_DHCINVPRTR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PrtInsu_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PrtInsu_FairType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PrtInsu_Flag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PrtInsu_Handin">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PrtInsu_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PrtInsu_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PrtInsu_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PrtInsu_INVPrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PrtInsu_InsDiv_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PrtInsu_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PrtInsu_Note2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PrtInsu_Note3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PrtInsu_OPCRoundErr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PrtInsu_OldINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PrtInsu_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PrtInsu_Prt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PrtInsu_StrikeAcount">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PrtInsu_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PrtInsu_User">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PrtInsu_YBPaySum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PrtInsu_initinv_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCINVPRTInsu</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PrtInsu_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PrtInsu_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTInsuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
