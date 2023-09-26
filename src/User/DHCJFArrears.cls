Class User.DHCJFArrears Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JFA_RowID, SqlTableName = DHC_JFArrears, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCJFArrearsMoney As User.DHCJFArrearsMoney [ Cardinality = children, Inverse = JFAMJFAParref ];

/// JFA_AdmCat_Dr
Property JFAAdmCatDr As User.PACAdmCategory [ SqlColumnNumber = 2, SqlFieldName = JFA_AdmCat_Dr ];

/// JFA_GreenWay
Property JFAGreenWay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = JFA_GreenWay ];

/// JFA_AdmReason_Dr
Property JFAAdmReasonDr As User.PACAdmReason [ SqlColumnNumber = 4, SqlFieldName = JFA_AdmReason_Dr ];

/// JFA_AdmType
Property JFAAdmType As %Library.String(MAXLEN = 1, SELECTIVITY = "16.6667%", VALUELIST = ",I,O,E,H,A,P") [ SqlColumnNumber = 5, SqlFieldName = JFA_AdmType ];

/// JFA_DiaCat_Dr
Property JFADiaCatDr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = JFA_DiaCat_Dr ];

/// JFA_Loc_Dr
Property JFALocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = JFA_Loc_Dr ];

/// JFA_Ward_Dr
Property JFAWardDr As User.PACWard [ SqlColumnNumber = 8, SqlFieldName = JFA_Ward_Dr ];

/// JFA_Flag
Property JFAFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = JFA_Flag ];

/// JFA_Desc
Property JFADesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = JFA_Desc ];

/// JFA_Remark
Property JFARemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = JFA_Remark ];

/// JFA_User_Dr
Property JFAUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = JFA_User_Dr ];

/// JFA_Date
Property JFADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = JFA_Date ];

/// JFA_Time
Property JFATime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = JFA_Time ];

/// JFA_UpdateUser_Dr
Property JFAUpdateUserDr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = JFA_UpdateUser_Dr ];

/// JFA_UpdateDate
Property JFAUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = JFA_UpdateDate ];

/// JFA_UpdateTime
Property JFAUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = JFA_UpdateTime ];

/// JFA_DateFrom
Property JFADateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = JFA_DateFrom ];

/// JFA_DateTo
Property JFADateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = JFA_DateTo ];

/// JFA_EPS_Dr
Property JFAEPSDr As User.PACEpisodeSubType [ SqlColumnNumber = 20, SqlFieldName = JFA_EPS_Dr ];

/// JFA_Hosp_Dr
Property JFAHospDr As User.CTHospital [ SqlColumnNumber = 21, SqlFieldName = JFA_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFARREARS)</SqlIdExpression>
<SQLMap name="DataDHCJFARREARS">
<Data name="JFA_AdmCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JFA_AdmReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JFA_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JFA_Date">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JFA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="JFA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="JFA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JFA_DiaCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JFA_EPS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="JFA_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JFA_GreenWay">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JFA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="JFA_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JFA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JFA_Time">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="JFA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="JFA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="JFA_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="JFA_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JFA_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCJFARREARS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JFA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{JFA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexAdmReason">
<Global>^DHCJFARREARS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>JFA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AdmReason"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{JFA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDiaCat">
<Global>^DHCJFARREARS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>JFA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DiaCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{JFA_DiaCat_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{JFA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexLoc">
<Global>^DHCJFARREARS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>JFA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{JFA_Loc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{JFA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexWard">
<Global>^DHCJFARREARS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>JFA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{JFA_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{JFA_Ward_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{JFA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFArrearsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
