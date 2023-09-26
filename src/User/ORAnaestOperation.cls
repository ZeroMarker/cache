/// Anaesth. Operation(1012)
Class User.ORAnaestOperation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_Anaest_Operation, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ANAOPChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildORAnOperPosition As ORAnOperPosition [ Cardinality = children, Inverse = OPPOSParRef ];

Relationship ChildORAnOperScrubNurse As ORAnOperScrubNurse [ Cardinality = children, Inverse = OPSCNParRef ];

Relationship ChildORAnOperAssistant As ORAnOperAssistant [ Cardinality = children, Inverse = OPASParRef ];

Relationship ChildORAnOperCirculNurse As ORAnOperCirculNurse [ Cardinality = children, Inverse = CIRNParRef ];

Relationship ChildORAnOperDiagnosis As ORAnOperDiagnosis [ Cardinality = children, Inverse = DIAParREf ];

Relationship ChildORAnOperAnaestAssistant As ORAnOperAnaestAssistant [ Cardinality = children, Inverse = ANASSParRef ];

Relationship ChildORAnOperAdditionalStaff As ORAnOperAdditionalStaff [ Cardinality = children, Inverse = OPASParRef ];

Relationship ChildORAnOperSecProc As ORAnOperSecProc [ Cardinality = children, Inverse = SPRParRef ];

/// OR_Anaesthesia Parent Reference
Relationship ANAOPParRef As ORAnaesthesia [ Cardinality = parent, Inverse = ChildORAnaestOperation, Required, SqlFieldName = ANAOP_Par_Ref ];

/// Childsub
Property ANAOPChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ANA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"OP",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ANAOP_Childsub ];

/// Operation No
Property ANAOPNo As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ANAOP_No ];

/// Op Start Time
Property ANAOPOpStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ANAOP_OpStartTime ];

/// Op End Time
Property ANAOPOpEndTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ANAOP_OpEndTime ];

/// Des Ref Preoperation Diagnosis
Property ANAOPPreopDiagDR As %String [ SqlColumnNumber = 6, SqlFieldName = ANAOP_PreopDiag_DR ];

/// Des REf Postoperation Diagnosis
Property ANAOPPostDiagDR As %String [ SqlColumnNumber = 7, SqlFieldName = ANAOP_PostDiag_DR ];

/// Operation Notes
Property ANAOPNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ANAOP_Notes, SqlListType = SUBNODE ];

/// Operations/Procedures Des Ref
Property ANAOPTypeDR As ORCOperation [ SqlColumnNumber = 9, SqlFieldName = ANAOP_Type_DR ];

/// Circulating Nurse Des Ref to CTCP
Property ANAOPCirculNurseDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = ANAOP_Circul_Nurse_DR ];

/// Surgeon Des Ref to CTCP
Property ANAOPSurgeonDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = ANAOP_Surgeon_DR ];

/// Blade Des Ref to ORCBT
Property ANAOPBladeDR As ORCBladeType [ SqlColumnNumber = 12, SqlFieldName = ANAOP_Blade_DR ];

/// Location of Operation(DR to CTLOC)
Property ANAOPCTLOCDR As CTLoc [ SqlColumnNumber = 13, SqlFieldName = ANAOP_CTLOC_DR ];

/// Operation Type
Property ANAOPOperType As %String(DISPLAYLIST = ",Main,Sub", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",M,S") [ SqlColumnNumber = 14, SqlFieldName = ANAOP_OperType ];

/// Des Ref to OPBIL
Property ANAOPOPBILDR As ORCOperBillCondition [ SqlColumnNumber = 15, SqlFieldName = ANAOP_OPBIL_DR ];

/// Op Start Date
Property ANAOPOpStartDate As %Date [ SqlColumnNumber = 16, SqlFieldName = ANAOP_OpStartDate ];

/// Transfer To Loc
Property ANAOPTransferToLoc As CTLoc [ SqlColumnNumber = 17, SqlFieldName = ANAOP_TransferToLoc ];

/// Counted Items
Property ANAOPCountedItems As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = ANAOP_CountedItems ];

/// Op End Date
Property ANAOPOpEndDate As %Date [ SqlColumnNumber = 19, SqlFieldName = ANAOP_OpEndDate ];

/// Des Ref SSUSR
Property ANAOPSSUSRDR As SSUser [ SqlColumnNumber = 20, SqlFieldName = ANAOP_SSUSR_DR ];

/// Theatre In Time
Property ANAOPTheatreInTime As %Time [ SqlColumnNumber = 21, SqlFieldName = ANAOP_TheatreInTime ];

/// Theatre In Date
Property ANAOPTheatreInDate As %Date [ SqlColumnNumber = 22, SqlFieldName = ANAOP_TheatreInDate ];

/// Des Ref CTLOC
Property ANAOPDeparOperDR As CTLoc [ SqlColumnNumber = 23, SqlFieldName = ANAOP_Depar_Oper_DR ];

/// Boipsy Performed
Property ANAOPBiopsyPerformed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = ANAOP_BiopsyPerformed ];

/// Day Surgery
Property ANAOPDaySurgery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = ANAOP_DaySurgery ];

/// Area In Date
Property ANAOPAreaInDate As %Date [ SqlColumnNumber = 26, SqlFieldName = ANAOP_AreaInDate ];

/// Area In Time
Property ANAOPAreaInTime As %Time [ SqlColumnNumber = 27, SqlFieldName = ANAOP_AreaInTime ];

/// Des REf Resource
Property ANAOPResourceDR As RBResource [ SqlColumnNumber = 28, SqlFieldName = ANAOP_Resource_DR ];

/// Theatre Out Date
Property ANAOPTheatreOutDate As %Date [ SqlColumnNumber = 29, SqlFieldName = ANAOP_TheatreOutDate ];

/// Theatre Out Time
Property ANAOPTheatreOutTime As %Time [ SqlColumnNumber = 30, SqlFieldName = ANAOP_TheatreOutTime ];

/// Area Out Date
Property ANAOPAreaOutDate As %Date [ SqlColumnNumber = 31, SqlFieldName = ANAOP_AreaOutDate ];

/// Area Out Time
Property ANAOPAreaOutTime As %Time [ SqlColumnNumber = 32, SqlFieldName = ANAOP_AreaOutTime ];

/// Effective Elective
Property ANAOPEffectiveElective As %String(DISPLAYLIST = ",Elective,Emergency", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",EL,EM") [ SqlColumnNumber = 36, SqlFieldName = ANAOP_EffectiveElective ];

/// Cancellation Reason
Property ANAOPCancelReason As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = ANAOP_CancelReason, SqlListType = SUBNODE ];

/// Status
Property ANAOPStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = ANAOP_Status ];

/// Last Update Date
Property ANAOPUpdateDate As %Date [ SqlColumnNumber = 39, SqlFieldName = ANAOP_UpdateDate ];

/// Last Update Time
Property ANAOPUpdateTime As %Time [ SqlColumnNumber = 40, SqlFieldName = ANAOP_UpdateTime ];

/// Last Update Hospital
Property ANAOPUpdateHospitalDR As CTHospital [ SqlColumnNumber = 41, SqlFieldName = ANAOP_UpdateHospital_DR ];

/// Des Ref OEC_BodySite_DR
Property ANAOPBodySiteDR As OECBodySite [ SqlColumnNumber = 42, SqlFieldName = ANAOP_BodySite_DR ];

/// Des Ref CTCareProv Items Counted By
Property ANAOPItemsCountedByDR As CTCareProv [ SqlColumnNumber = 43, SqlFieldName = ANAOP_ItemsCountedBy_DR ];

/// DR PACStatePPP
Property ANAOPStatePPPDR As PACStatePPP [ SqlColumnNumber = 44, SqlFieldName = ANAOP_StatePPP_DR ];

/// Procedure
Property ANAOPProcedure As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = ANAOP_Procedure ];

/// Des Ref RBOPSecProc
Property ANAOPRBOPSecProcDR As RBOperRoomSecProc [ SqlColumnNumber = 46, SqlFieldName = ANAOP_RBOPSecProc_DR ];

/// OperationComplication
Property ANAOPOperationComplication As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = ANAOP_OperationComplication, SqlListType = SUBNODE ];

/// Des Ref ItemsReCountedBy
Property ANAOPItemsReCountedByDR As CTCareProv [ SqlColumnNumber = 48, SqlFieldName = ANAOP_ItemsReCountedBy_DR ];

/// DSReportFlag
Property ANAOPDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = ANAOP_DSReportFlag ];

/// Des Ref PrevSurg
Property ANAOPPrevSurgDR As CTCareProv [ SqlColumnNumber = 50, SqlFieldName = ANAOP_PrevSurg_DR ];

/// Des Ref PrevType
Property ANAOPPrevTypeDR As ORCOperation [ SqlColumnNumber = 51, SqlFieldName = ANAOP_PrevType_DR ];

/// Des Ref PrevSPPP
Property ANAOPPrevSPPPDR As PACStatePPP [ SqlColumnNumber = 52, SqlFieldName = ANAOP_PrevSPPP_DR ];

/// Quantity
Property ANAOPQuantity As %Float [ SqlColumnNumber = 53, SqlFieldName = ANAOP_Quantity ];

/// ProperlyIncision
Property ANAOPProperlyIncision As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = ANAOP_ProperlyIncision ];

/// PatholEsthetOper
Property ANAOPPatholEsthetOper As %String(DISPLAYLIST = ",Pathologic,Esthetical", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",P,E") [ SqlColumnNumber = 55, SqlFieldName = ANAOP_PatholEsthetOper ];

/// DoctorCommission
Property ANAOPDoctorCommission As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = ANAOP_DoctorCommission ];

/// Des Ref DiathermyBodySite
Property ANAOPDiathermyBodySiteDR As OECBodySite [ SqlColumnNumber = 57, SqlFieldName = ANAOP_DiathermyBodySite_DR ];

/// Des Ref TorniquetBodySite
Property ANAOPTorniquetBodySiteDR As OECBodySite [ SqlColumnNumber = 58, SqlFieldName = ANAOP_TorniquetBodySite_DR ];

/// TorniquetDateFrom
Property ANAOPTorniquetDateFrom As %Date [ SqlColumnNumber = 59, SqlFieldName = ANAOP_TorniquetDateFrom ];

/// TorniquetDateTo
Property ANAOPTorniquetDateTo As %Date [ SqlColumnNumber = 60, SqlFieldName = ANAOP_TorniquetDateTo ];

/// TorniquetTimeFrom
Property ANAOPTorniquetTimeFrom As %Time [ SqlColumnNumber = 61, SqlFieldName = ANAOP_TorniquetTimeFrom ];

/// TorniquetTimeTo
Property ANAOPTorniquetTimeTo As %Time [ SqlColumnNumber = 62, SqlFieldName = ANAOP_TorniquetTimeTo ];

/// PostOperInstructions
Property ANAOPPostOperInstructions As list Of %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 63, SqlFieldName = ANAOP_PostOperInstructions, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnaestOperation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestOperation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnaestOperation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestOperation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnaestOperation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestOperation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnaestOperation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestOperation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestOperation","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnaestOperation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestOperation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>32038</ExtentSize>
<Property name="ANAOPAreaInDate">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPAreaInTime">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPAreaOutDate">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPAreaOutTime">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPBiopsyPerformed">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPBladeDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="ANAOPBodySiteDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPCTLOCDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="ANAOPCancelReason">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPChildsub">
<Selectivity>0.0043%</Selectivity>
</Property>
<Property name="ANAOPCirculNurseDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPCountedItems">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPDaySurgery">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPDeparOperDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ANAOPDiathermyBodySiteDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPDoctorCommission">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPEffectiveElective">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPItemsCountedByDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPItemsReCountedByDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPNo">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="ANAOPNotes">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="ANAOPOPBILDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPOpEndDate">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ANAOPOpEndTime">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ANAOPOpStartDate">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ANAOPOpStartTime">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANAOPOperType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPOperationComplication">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="ANAOPParRef">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="ANAOPPatholEsthetOper">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPPostDiagDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPPostOperInstructions">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPPreopDiagDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPPrevSPPPDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPPrevSurgDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPPrevTypeDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPProcedure">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="ANAOPProperlyIncision">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAOPQuantity">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPRBOPSecProcDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="ANAOPResourceDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANAOPSSUSRDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANAOPStatePPPDR">
<Selectivity>16.6666%</Selectivity>
</Property>
<Property name="ANAOPStatus">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="ANAOPSurgeonDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ANAOPTheatreInDate">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="ANAOPTheatreInTime">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="ANAOPTheatreOutDate">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="ANAOPTheatreOutTime">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="ANAOPTorniquetBodySiteDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPTorniquetDateFrom">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPTorniquetDateTo">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPTorniquetTimeFrom">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPTorniquetTimeTo">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPTransferToLoc">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="ANAOPTypeDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ANAOPUpdateDate">
<Selectivity>16.6666%</Selectivity>
</Property>
<Property name="ANAOPUpdateHospitalDR">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="ANAOPUpdateTime">
<Selectivity>12.5000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ANAOP_AreaInDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ANAOP_AreaInTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ANAOP_AreaOutDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ANAOP_AreaOutTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ANAOP_BiopsyPerformed">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ANAOP_Blade_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANAOP_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ANAOP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANAOP_CancelReason">
<Node>"CRS"</Node>
</Data>
<Data name="ANAOP_Circul_Nurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANAOP_CountedItems">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANAOP_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ANAOP_DaySurgery">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ANAOP_Depar_Oper_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ANAOP_DiathermyBodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ANAOP_DoctorCommission">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ANAOP_EffectiveElective">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ANAOP_ItemsCountedBy_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ANAOP_ItemsReCountedBy_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ANAOP_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANAOP_Notes">
<Node>"REM"</Node>
</Data>
<Data name="ANAOP_OPBIL_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANAOP_OpEndDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANAOP_OpEndTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANAOP_OpStartDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANAOP_OpStartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANAOP_OperType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANAOP_OperationComplication">
<Node>"COMPL"</Node>
</Data>
<Data name="ANAOP_PatholEsthetOper">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ANAOP_PostDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANAOP_PostOperInstructions">
<Node>"POSTOP"</Node>
</Data>
<Data name="ANAOP_PreopDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANAOP_PrevSPPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ANAOP_PrevSurg_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ANAOP_PrevType_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ANAOP_Procedure">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ANAOP_ProperlyIncision">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ANAOP_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ANAOP_RBOPSecProc_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ANAOP_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ANAOP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANAOP_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ANAOP_Status">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ANAOP_Surgeon_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANAOP_TheatreInDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ANAOP_TheatreInTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANAOP_TheatreOutDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ANAOP_TheatreOutTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ANAOP_TorniquetBodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ANAOP_TorniquetDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ANAOP_TorniquetDateTo">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ANAOP_TorniquetTimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ANAOP_TorniquetTimeTo">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="ANAOP_TransferToLoc">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANAOP_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANAOP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ANAOP_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ANAOP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ANAOP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANAOP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^OR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ANAOP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANAOP_OpStartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ANAOP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpNo">
<Global>^OR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ANAOP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OpNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANAOP_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ANAOP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANAOP_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnaestOperationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
