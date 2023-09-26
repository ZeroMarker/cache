Class User.DHCAccMConGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AMCG_RowID, SqlTableName = DHC_AccMConGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AMCG_AbortDate
Property AMCGAbortDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AMCG_AbortDate ];

/// AMCG_AbortTime
Property AMCGAbortTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = AMCG_AbortTime ];

/// AMCG_AbortUser_DR
Property AMCGAbortUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = AMCG_AbortUser_DR ];

/// AMCG_AccManFrom_DR
Property AMCGAccManFromDR As User.DHCAccManager [ SqlColumnNumber = 5, SqlFieldName = AMCG_AccManFrom_DR ];

/// AMCG_AccManTo_DR
Property AMCGAccManToDR As User.DHCAccManager [ SqlColumnNumber = 7, SqlFieldName = AMCG_AccManTo_DR ];

/// AMCG_ActiveFlag
Property AMCGActiveFlag As %Library.String(DISPLAYLIST = ",Normal,Abort", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 12, SqlFieldName = AMCG_ActiveFlag ];

/// AMCG_Date
Property AMCGDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = AMCG_Date ];

/// AMCG_DateFrom
Property AMCGDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = AMCG_DateFrom ];

/// AMCG_DateTo
Property AMCGDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = AMCG_DateTo ];

/// AMCG_LimitAmt
Property AMCGLimitAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = AMCG_LimitAmt ];

/// AMCG_Note1
Property AMCGNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AMCG_Note1 ];

/// AMCG_Note2
Property AMCGNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AMCG_Note2 ];

/// AMCG_Note3
Property AMCGNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AMCG_Note3 ];

/// AMCG_Note4
Property AMCGNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AMCG_Note4 ];

/// AMCG_Note5
Property AMCGNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AMCG_Note5 ];

/// AMCG_PAPMI_DR
Property AMCGPAPMIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AMCG_PAPMI_DR ];

/// AMCG_PayAmt
Property AMCGPayAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AMCG_PayAmt ];

/// AMCG_Time
Property AMCGTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = AMCG_Time ];

/// AMCG_User_DR
Property AMCGUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AMCG_User_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACDMCG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AMCG_AbortDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AMCG_AbortTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AMCG_AbortUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AMCG_AccManFrom_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AMCG_AccManTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AMCG_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AMCG_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AMCG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AMCG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AMCG_LimitAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AMCG_Note1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AMCG_Note2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AMCG_Note3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AMCG_Note4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AMCG_Note5">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AMCG_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AMCG_PayAmt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AMCG_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AMCG_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCACDMCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AMCG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AMCG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAbortDate">
<Global>^DHCACDMCGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMCG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AbortDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMCG_AbortDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMCG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAbortUserDate">
<Global>^DHCACDMCGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AMCG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AUDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMCG_AbortUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMCG_AbortDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AMCG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCACDMCGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMCG_RowID</Field>
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
<Expression>{AMCG_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMCG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDR">
<Global>^DHCACDMCGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMCG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMIDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMCG_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMCG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCACDMCGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AMCG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMCG_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMCG_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AMCG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccMConGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
