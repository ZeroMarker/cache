/// PA_Adm Extend
Class User.DHCPAAdm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCADM_RowId, SqlTableName = DHC_PA_Adm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 800000;

Relationship ChildDHCPAAdmDischarge As User.DHCPAAdmDischarge [ Cardinality = children, Inverse = ADMDParref ];

/// DHCADM_PAADM_Dr
Property DHCADMPAADMDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCADM_PAADM_Dr ];

/// DHCADM_MainNurse_Dr
Property DHCADMMainNurseDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCADM_MainNurse_Dr ];

/// DHCADM_Status
Property DHCADMStatus As %Library.String(DISPLAYLIST = ",Discharge,Return,Admit", MAXLEN = 9, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,R,A") [ SqlColumnNumber = 4, SqlFieldName = DHCADM_Status ];

/// DHCADM_DischgDoc_Dr
Property DHCADMDischgDocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCADM_DischgDoc_Dr ];

/// DHCADM_DischgDate
Property DHCADMDischgDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCADM_DischgDate ];

/// DHCADM_DischgTime
Property DHCADMDischgTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DHCADM_DischgTime ];

/// DHCADM_ReturnUser_Dr
Property DHCADMReturnUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DHCADM_ReturnUser_Dr ];

/// DHCADM_ReturnDate
Property DHCADMReturnDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCADM_ReturnDate ];

/// DHCADM_ReturnTime
Property DHCADMReturnTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCADM_ReturnTime ];

/// DHCADM_UnableOrder
Property DHCADMUnableOrder As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DHCADM_UnableOrder ];

/// DHCADM_UnableOrdReason
Property DHCADMUnableOrdReason As %Library.String(DISPLAYLIST = ",Discharge,FinanceDisch,IntMedicare,CancelReg,OverdueReg,WaitingArea,NoDoctor", MAXLEN = 12, SELECTIVITY = "12.5000%", TRUNCATE = 1, VALUELIST = ",D,F,I,C,O,W,N") [ SqlColumnNumber = 12, SqlFieldName = DHCADM_UnableOrdReason ];

/// DHCADM_UnableOrdUser_Dr
Property DHCADMUnableOrdUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DHCADM_UnableOrdUser_Dr ];

/// DHCADM_UnableOrdDate
Property DHCADMUnableOrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCADM_UnableOrdDate ];

/// DHCADM_UnableOrdTime
Property DHCADMUnableOrdTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DHCADM_UnableOrdTime ];

/// DHCADM_IntMedicareStatus
Property DHCADMIntMedicareStatus As %Library.String(DISPLAYLIST = ",Normal,Billed,Finish", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,B,F") [ SqlColumnNumber = 16, SqlFieldName = DHCADM_IntMedicareStatus ];

/// DHCADM_IntMedicareUser_Dr
Property DHCADMIntMedicareUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DHCADM_IntMedicareUser_Dr ];

/// DHCADM_IntMedicareDate
Property DHCADMIntMedicareDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = DHCADM_IntMedicareDate ];

/// DHCADM_IntMedicareTime
Property DHCADMIntMedicareTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = DHCADM_IntMedicareTime ];

/// DHCADM_SeniorDoctor_Dr
Property DHCADMSeniorDoctorDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = DHCADM_SeniorDoctor_Dr ];

/// DHCADM_MainNurse2_Dr
Property DHCADMMainNurse2Dr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = DHCADM_MainNurse2_Dr ];

/// 质控护士
Property DHCADMQualityNurseId As %String [ SqlColumnNumber = 22, SqlFieldName = DHCADM_QualityNurse_Id ];

/// DHCADM_MainDoctor2_Dr 主管医生2
Property DHCADMMainDoctor2Dr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = DHCADM_MainDoctor2_Dr ];

Index DHCADMPAADMDrUnqIdx1 On DHCADMPAADMDr [ Unique ];

Storage SQLStorage
{
<ExtentSize>800000</ExtentSize>
<SqlIdExpression>$i(^DHCPAAdm(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCADM_DischgDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCADM_DischgDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCADM_DischgTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCADM_IntMedicareDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCADM_IntMedicareStatus">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCADM_IntMedicareTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCADM_IntMedicareUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCADM_MainDoctor2_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCADM_MainNurse2_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCADM_MainNurse_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCADM_PAADM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCADM_QualityNurse_Id">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCADM_ReturnDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCADM_ReturnTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCADM_ReturnUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCADM_SeniorDoctor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCADM_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCADM_UnableOrdDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCADM_UnableOrdReason">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCADM_UnableOrdTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCADM_UnableOrdUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCADM_UnableOrder">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCPAAdm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDischarge">
<Global>^DHCPAAdm</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DischDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCADM_DischgDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAAdm">
<Global>^DHCPAAdm</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCADM_PAADM_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReturnDate">
<Global>^DHCPAAdm</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReturnDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCADM_ReturnDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
