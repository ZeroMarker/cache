/// PA Traffic Accident(1530)
Class User.PATrafficAccident Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_TrafficAccident, StorageStrategy = SQLStorage ]
{

Relationship ChildPATrafficAccidentContact As PATrafficAccidentContact [ Cardinality = children, Inverse = CONTParRef ];

/// Des REf TRF_AccidentCode_DR
Property TRFAccidentCodeDR As PACTrafAccidCode [ SqlColumnNumber = 27, SqlFieldName = TRF_AccidentCode_DR ];

/// Accident Date
Property TRFAccidentDate As %Date [ SqlColumnNumber = 25, SqlFieldName = TRF_AccidentDate ];

/// Accident Time
Property TRFAccidentTime As %Time [ SqlColumnNumber = 26, SqlFieldName = TRF_AccidentTime ];

/// Assist Centre
Property TRFAssistCentre As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TRF_AssistCentre ];

/// Court City
Property TRFCourtCity As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = TRF_CourtCity ];

/// Court Number
Property TRFCourtNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = TRF_CourtNumber ];

/// Employer
Property TRFEmployer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 58, SqlFieldName = TRF_Employer ];

/// Des Ref ICD1
Property TRFICD1DR As MRCICDDx [ SqlColumnNumber = 40, SqlFieldName = TRF_ICD1_DR ];

/// Des Ref ICD2
Property TRFICD2DR As MRCICDDx [ SqlColumnNumber = 41, SqlFieldName = TRF_ICD2_DR ];

/// ID
Property TRFID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = TRF_ID ];

/// Informed Employer
Property TRFInformedEmployer As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = TRF_InformedEmployer ];

/// Injury
Property TRFInjury As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = TRF_Injury ];

/// Des Ref InsType
Property TRFInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 53, SqlFieldName = TRF_InsType_DR ];

/// LastUpdateDate
Property TRFLastUpdateDate As %Date [ SqlColumnNumber = 55, SqlFieldName = TRF_LastUpdateDate ];

/// Des Ref LastUpdateHospital
Property TRFLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 57, SqlFieldName = TRF_LastUpdateHospital_DR ];

/// LastUpdateTime
Property TRFLastUpdateTime As %Time [ SqlColumnNumber = 56, SqlFieldName = TRF_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property TRFLastUpdateUserDR As SSUser [ SqlColumnNumber = 54, SqlFieldName = TRF_LastUpdateUser_DR ];

/// Des Ref LocationInj
Property TRFLocationInjDR As PACLocationInjury [ SqlColumnNumber = 48, SqlFieldName = TRF_LocationInj_DR ];

/// Notes
Property TRFNotes As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TRF_Notes, SqlListType = SUBNODE ];

/// Owner Address
Property TRFOwnerAddress As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = TRF_OwnerAddress ];

/// Owner City
Property TRFOwnerCity As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = TRF_OwnerCity ];

/// OwnerFaxNo
Property TRFOwnerFaxNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = TRF_OwnerFaxNo ];

/// Owner Id
Property TRFOwnerID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = TRF_OwnerID ];

/// Owner Name1
Property TRFOwnerName1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TRF_OwnerName1 ];

/// Owner Phone1
Property TRFOwnerPhone1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = TRF_OwnerPhone1 ];

/// Des REf Province
Property TRFOwnerProvinceDR As CTProvince [ SqlColumnNumber = 13, SqlFieldName = TRF_OwnerProvince_DR ];

/// OwnerZipCode
Property TRFOwnerZipCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = TRF_OwnerZipCode ];

/// Des Ref PatientRole
Property TRFPatientRoleDR As PACPatientRoleRA [ SqlColumnNumber = 47, SqlFieldName = TRF_PatientRole_DR ];

/// Des Ref Person
Property TRFPersonDR As PAPerson [ SqlColumnNumber = 50, SqlFieldName = TRF_Person_DR ];

/// Place
Property TRFPlace As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TRF_Place ];

/// Police Badge
Property TRFPoliceBadge As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = TRF_PoliceBadge ];

/// Police Station
Property TRFPoliceStation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = TRF_PoliceStation ];

/// Service Rank
Property TRFServiceRank As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = TRF_ServiceRank ];

/// Ship Name
Property TRFShipName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = TRF_ShipName ];

/// Veh2 Model
Property TRFVeh2Model As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = TRF_Veh2Model ];

/// Veh 3 Model
Property TRFVeh3Model As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = TRF_Veh3Model ];

/// Veh Driver Address 2
Property TRFVehDriverAddress2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = TRF_VehDriverAddress2 ];

/// Veh Driver Address 2
Property TRFVehDriverAddress3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = TRF_VehDriverAddress3 ];

/// Driver City
Property TRFVehDriverCity As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = TRF_VehDriverCity ];

/// VehDriverID
Property TRFVehDriverID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = TRF_VehDriverID ];

/// VehDriverName
Property TRFVehDriverName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = TRF_VehDriverName ];

/// Veh Driver Name 2
Property TRFVehDriverName2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = TRF_VehDriverName2 ];

/// Veh Driver Name 3
Property TRFVehDriverName3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = TRF_VehDriverName3 ];

/// Veh Driver Ph 2
Property TRFVehDriverPh2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = TRF_VehDriverPh2 ];

/// Veh Driver Ph 3
Property TRFVehDriverPh3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = TRF_VehDriverPh3 ];

/// VehDriverPhone
Property TRFVehDriverPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = TRF_VehDriverPhone ];

/// Des REf VehDriverProvince
Property TRFVehDriverProvinceDR As CTProvince [ SqlColumnNumber = 33, SqlFieldName = TRF_VehDriverProvince_DR ];

/// Veh Ins Comp2
Property TRFVehInsComp2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = TRF_VehInsComp2 ];

/// Veh Ins Company 3
Property TRFVehInsComp3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = TRF_VehInsComp3 ];

/// Veh Ins Company
Property TRFVehInsCompany As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TRF_VehInsCompany ];

/// Veh Ins Policy
Property TRFVehInsPolicy As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TRF_VehInsPolicy ];

/// VehMake
Property TRFVehMake As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = TRF_VehMake ];

/// Veh  Model
Property TRFVehModel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TRF_VehModel ];

/// Vehicle Rego 4
Property TRFVehReg4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = TRF_VehReg4 ];

/// Veh Req
Property TRFVehReq As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = TRF_VehReq ];

/// Veh Req 2
Property TRFVehReq2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = TRF_VehReq2 ];

/// Veh Req 3
Property TRFVehReq3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = TRF_VehReq3 ];

Parameter EXTENTSIZE = 351;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PATrafficAccident).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccident","OnAfterDelete")

 d Table^HL7Outbound("PATrafficAccident",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PATrafficAccident).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccident","OnAfterInsert")

 d Table^HL7Outbound("PATrafficAccident",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PATrafficAccident).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccident","OnAfterUpdate")

 d Table^HL7Outbound("PATrafficAccident",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PATrafficAccident).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccident","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PATrafficAccident).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccident","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>351</ExtentSize>
<Property name="TRFAccidentCodeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFAccidentDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFAccidentTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFAssistCentre">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFCourtCity">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFCourtNumber">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFEmployer">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFICD1DR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFICD2DR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFID">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFInformedEmployer">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRFInjury">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFLastUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFLastUpdateHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFLastUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFLastUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFLocationInjDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFNotes">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerAddress">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerCity">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerFaxNo">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerID">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerName1">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerPhone1">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerProvinceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFOwnerZipCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFPatientRoleDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFPersonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFPlace">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFPoliceBadge">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFPoliceStation">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFServiceRank">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFShipName">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVeh2Model">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVeh3Model">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverAddress2">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverAddress3">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverCity">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverID">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverName">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverName2">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverName3">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverPh2">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverPh3">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverPhone">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehDriverProvinceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehInsComp2">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehInsComp3">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehInsCompany">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehInsPolicy">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehMake">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehModel">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehReg4">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehReq">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehReq2">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRFVehReq3">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PATRF(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="TRF_AccidentCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRF_AccidentDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRF_AccidentTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRF_AssistCentre">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRF_CourtCity">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRF_CourtNumber">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRF_Employer">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Data name="TRF_ICD1_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="TRF_ICD2_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="TRF_ID">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="TRF_InformedEmployer">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>23</Piece>
</Data>
<Data name="TRF_Injury">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="TRF_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRF_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="TRF_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="TRF_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="TRF_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="TRF_LocationInj_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>21</Piece>
</Data>
<Data name="TRF_Notes">
<Node>"REM"</Node>
</Data>
<Data name="TRF_OwnerAddress">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="TRF_OwnerCity">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="TRF_OwnerFaxNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="TRF_OwnerID">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="TRF_OwnerName1">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="TRF_OwnerPhone1">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="TRF_OwnerProvince_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="TRF_OwnerZipCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="TRF_PatientRole_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>22</Piece>
</Data>
<Data name="TRF_Person_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="TRF_Place">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRF_PoliceBadge">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>20</Piece>
</Data>
<Data name="TRF_PoliceStation">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>17</Piece>
</Data>
<Data name="TRF_ServiceRank">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>18</Piece>
</Data>
<Data name="TRF_ShipName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>19</Piece>
</Data>
<Data name="TRF_Veh2Model">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>11</Piece>
</Data>
<Data name="TRF_Veh3Model">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="TRF_VehDriverAddress2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="TRF_VehDriverAddress3">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="TRF_VehDriverCity">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="TRF_VehDriverID">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="TRF_VehDriverName">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="TRF_VehDriverName2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="TRF_VehDriverName3">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="TRF_VehDriverPh2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="TRF_VehDriverPh3">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="TRF_VehDriverPhone">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="TRF_VehDriverProvince_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="TRF_VehInsComp2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="TRF_VehInsComp3">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="TRF_VehInsCompany">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="TRF_VehInsPolicy">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="TRF_VehMake">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="TRF_VehModel">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="TRF_VehReg4">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>15</Piece>
</Data>
<Data name="TRF_VehReq">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="TRF_VehReq2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="TRF_VehReq3">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Global>^PATRF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TRF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TRF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^PATRF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRF_Person_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRF_RowId</SqlRowIdName>
<StreamLocation>^User.PATrafficAccidentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
