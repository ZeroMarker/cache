Class User.DHCEPPreDeposit Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EPMD_RowID, SqlTableName = DHC_EPPreDeposit, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EPMDSub [ IdKey, PrimaryKey, Unique ];

/// DHC_EPManager Parent Reference
Relationship EPMDParRef As User.DHCEPManager [ Cardinality = parent, Inverse = ChildDHCEPPreDeposit, Required, SqlFieldName = EPMD_ParRef ];

Relationship ChildDHCEPPrePayMode As User.DHCEPPrePayMode [ Cardinality = children, Inverse = EPDPMEPMDParref ];

/// EPMD_Sub
Property EPMDSub As %Library.Float [ InitialExpression = {$i(^DHCEPM("EPM",+$p($s($d(p1):p1,1:%d(0)),$c(1)),"EPMD",0))}, SqlColumnNumber = 2, SqlFieldName = EPMD_Sub ];

/// EPMD_Type
Property EPMDType As %Library.String(DISPLAYLIST = ",Pay,Refund,Trans,Foot", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",P,R,T,F") [ SqlColumnNumber = 3, SqlFieldName = EPMD_Type ];

/// EPMD_PreSum
Property EPMDPreSum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = EPMD_PreSum ];

/// EPMD_PreDate
Property EPMDPreDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = EPMD_PreDate ];

/// EPMD_PreTime
Property EPMDPreTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = EPMD_PreTime ];

/// EPMD_User_DR
Property EPMDUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = EPMD_User_DR ];

/// EPMD_BillNum
Property EPMDBillNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EPMD_BillNum ];

/// EPMD_Report_DR
Property EPMDReportDR As User.DHCINVPRTReports [ SqlColumnNumber = 9, SqlFieldName = EPMD_Report_DR ];

/// EPMD_Left
Property EPMDLeft As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = EPMD_Left ];

/// EPMD_BackReason
Property EPMDBackReason As User.DHCINVOPRefReason [ SqlColumnNumber = 11, SqlFieldName = EPMD_BackReason ];

/// EPMD_FootDate
Property EPMDFootDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = EPMD_FootDate ];

/// EPMD_FootTime
Property EPMDFootTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = EPMD_FootTime ];

/// EPMD_FootUser_DR
Property EPMDFootUserDR As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = EPMD_FootUser_DR ];

/// EPMD_Hospital_DR
Property EPMDHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 15, SqlFieldName = EPMD_Hospital_DR ];

/// EPMD_Inv_DR
Property EPMDInvDR As User.DHCINVPRT [ SqlColumnNumber = 16, SqlFieldName = EPMD_Inv_DR ];

/// EPMD_Remark
Property EPMDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EPMD_Remark ];

/// EPMD_IPAddress
Property EPMDIPAddress As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = EPMD_IPAddress ];

/// EPMD_Note3
Property EPMDNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = EPMD_Note3 ];

/// EPMD_Note4
Property EPMDNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = EPMD_Note4 ];

/// EPMD_InitDep_DR
Property EPMDInitDepDR As User.DHCEPPreDeposit [ SqlColumnNumber = 21, SqlFieldName = EPMD_InitDep_DR ];

/// EPMD_Status
Property EPMDStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = EPMD_Status ];

/// EPMD_Handin
Property EPMDHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = EPMD_Handin ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EPMD_BackReason">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EPMD_BillNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EPMD_FootDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EPMD_FootTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EPMD_FootUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EPMD_Handin">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EPMD_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EPMD_IPAddress">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EPMD_InitDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EPMD_Inv_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EPMD_Left">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EPMD_Note3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EPMD_Note4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EPMD_PreDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EPMD_PreSum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EPMD_PreTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EPMD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EPMD_Report_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EPMD_Status">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EPMD_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPMD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEPM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EPMD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillNum">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDBillNum"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_BillNum}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFootDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDFootDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_FootDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFootUserDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDFDUserDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_FootUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{EPMD_FootDate}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="9">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandin">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>EPMD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HandIn"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EPMD_Handin}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EPMD_User_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInitDR">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"InitDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_InitDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPreDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDPreDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_PreDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReport">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDReport"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Report_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDUser"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDUserDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{EPMD_PreDate}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="9">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserType">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>EPMD_Sub</Field>
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
<Expression>"EPMDUserBillNo"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPMD_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Type}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{EPMD_BillNum}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="9">
<AccessType>Sub</AccessType>
<Expression>{EPMD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEPPreDepositS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
