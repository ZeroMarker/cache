Class User.DHCEPManager Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EPM_RowID, SqlTableName = DHC_EPManager, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEPPayList As User.DHCEPPayList [ Cardinality = children, Inverse = EPPLParref ];

Relationship ChildDHCEPPreDeposit As User.DHCEPPreDeposit [ Cardinality = children, Inverse = EPMDParRef ];

/// EPM_ AccountNo
Property EPMAccountNo As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EPM_AccountNo ];

/// EPM_Adm_DR
Property EPMAdmDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = EPM_Adm_DR ];

/// EPM_PAPMI_DR
Property EPMPAPMIDR As User.PAPatMas [ SqlColumnNumber = 4, SqlFieldName = EPM_PAPMI_DR ];

/// EPM_PAPMINo
Property EPMPAPMINo As %Library.String(COLLATION = "Exact", MAXLEN = 12, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EPM_PAPMINo ];

/// Card No Same to DHC_CardRef No
Property EPMCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EPM_CardNo ];

/// EPM_OCDate
Property EPMOCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = EPM_OCDate ];

/// EPM_OCTime
Property EPMOCTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = EPM_OCTime ];

/// EPM_CUser_DR
Property EPMCUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = EPM_CUser_DR ];

/// EPM_Balance
Property EPMBalance As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = EPM_Balance ];

/// EPM_WoffDate
Property EPMWoffDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = EPM_WoffDate ];

/// EPM_WoffTime
Property EPMWoffTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = EPM_WoffTime ];

/// EPM_DUser_DR
Property EPMDUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = EPM_DUser_DR ];

/// EPM_Status
Property EPMStatus As %Library.String(DISPLAYLIST = ",Normal,Foot,Suspend", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 14, SqlFieldName = EPM_Status ];

/// EPM_BadPrice
Property EPMBadPrice As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = EPM_BadPrice ];

/// Ref DHC_CredType
Property EPMCredTypeDR As User.DHCCredType [ SqlColumnNumber = 16, SqlFieldName = EPM_CredType_DR ];

/// EPM_CredNo
Property EPMCredNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EPM_CredNo ];

/// EPM_Note1
Property EPMNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = EPM_Note1 ];

/// EPM_Note2
Property EPMNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = EPM_Note2 ];

/// EPM_Note3
Property EPMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = EPM_Note3 ];

/// EPM_Note4
Property EPMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = EPM_Note4 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEPM("EPM"))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="EPM_AccountNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPM_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EPM_BadPrice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EPM_Balance">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EPM_CUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EPM_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EPM_CredNo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EPM_CredType_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EPM_DUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EPM_Note1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EPM_Note2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EPM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EPM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EPM_OCDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EPM_OCTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EPM_PAPMINo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EPM_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EPM_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EPM_WoffDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EPM_WoffTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEPM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccountNO">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"AccountNO"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_AccountNo}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPAdm"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_Adm_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_OCDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCUserDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"CUserDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_CUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{EPM_OCDate}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateUser">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"CreateUser"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_CUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDUserDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EMP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"DUserDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_DUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{EPM_WoffDate}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPMPapmi"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmiAdm">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPMPapmiAdm"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{EPM_Adm_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPMStatus"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_Status}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWoffDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"WoffDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_WoffDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWoffUser">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"WoffUser"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPM_DUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEPManagerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
