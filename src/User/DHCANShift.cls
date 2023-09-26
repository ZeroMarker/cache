Class User.DHCANShift Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANS_RowId, SqlTableName = DHC_AN_Shift, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ANSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_OPArrange Parent Reference
Relationship ANSParref As User.DHCANOPArrange [ Cardinality = parent, Inverse = ChildDHCANShift, Required, SqlFieldName = ANS_Parref ];

//Property ANSChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"Shift",0))}, SqlColumnNumber = 2, SqlFieldName = ANS_ChildSub ];

//  For P8

/// ANS_ChildSub
Property ANSChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Shift",0))}, SqlColumnNumber = 2, SqlFieldName = ANS_ChildSub ];

/// ANS_Type
Property ANSType As %Library.String(DISPLAYLIST = ",AreaIn,TheatreIn,Theatre,TheatreOut,PacuIn,Pacu,Ward,ICU,AreaOut", MAXLEN = 10, SELECTIVITY = "10.0000%", TRUNCATE = 1, VALUELIST = ",AI,TI,T,TO,PI,P,W,I,AO") [ SqlColumnNumber = 3, SqlFieldName = ANS_Type ];

/// ANS_Consciousness
Property ANSConsciousness As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ANS_Consciousness ];

/// ANS_RespRate
Property ANSRespRate As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ANS_RespRate ];

/// ANS_RespMode
Property ANSRespMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ANS_RespMode ];

/// ANS_Respiration
Property ANSRespiration As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ANS_Respiration ];

/// ANS_HeartRate
Property ANSHeartRate As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ANS_HeartRate ];

/// ANS_HeartRhythm
Property ANSHeartRhythm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ANS_HeartRhythm ];

/// ANS_BPSystolic
Property ANSBPSystolic As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ANS_BPSystolic ];

/// ANS_BPDiastolic
Property ANSBPDiastolic As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ANS_BPDiastolic ];

/// ANS_OxygenSaturation
Property ANSOxygenSaturation As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ANS_OxygenSaturation ];

/// ANS_Temperature
Property ANSTemperature As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = ANS_Temperature ];

/// ANS_ExtremityMove
Property ANSExtremityMove As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ANS_ExtremityMove ];

/// ANS_Complication
Property ANSComplication As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ANS_Complication ];

/// ANS_PatTransferMode
Property ANSPatTransferMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ANS_PatTransferMode ];

/// ANS_ShiftPlace
Property ANSShiftPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ANS_ShiftPlace ];

/// ANS_ShiftCtcp_Dr
Property ANSShiftCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ANS_ShiftCtcp_Dr ];

/// ANS_ReliefCtcp_Dr
Property ANSReliefCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ANS_ReliefCtcp_Dr ];

/// ANS_Date
Property ANSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = ANS_Date ];

/// ANS_Time
Property ANSTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = ANS_Time ];

/// ANS_CatheterType
Property ANSCatheterType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = ANS_CatheterType ];

/// ANS_Check
Property ANSCheck As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = ANS_Check ];

/// ANS_IntravenInfusion
Property ANSIntravenInfusion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = ANS_IntravenInfusion ];

/// ANS_IntravenPuncSite
Property ANSIntravenPuncSite As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ANS_IntravenPuncSite ];

/// ANS_DeepIntravenPunc
Property ANSDeepIntravenPunc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = ANS_DeepIntravenPunc ];

/// ANS_BodySurfIdentity
Property ANSBodySurfIdentity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = ANS_BodySurfIdentity ];

/// ANS_VadeMecum
Property ANSVadeMecum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ANS_VadeMecum ];

/// ANS_VadeMecumOther
Property ANSVadeMecumOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = ANS_VadeMecumOther ];

/// ANS_Catheter
Property ANSCatheter As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = ANS_Catheter ];

/// ANS_CathOther
Property ANSCathOther As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = ANS_CathOther ];

/// ANS_MonitorTech
Property ANSMonitorTech As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = ANS_MonitorTech ];

/// ANS_MonitorTechOther
Property ANSMonitorTechOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = ANS_MonitorTechOther ];

/// ANS_Note
Property ANSNote As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ANS_Note ];

/// ANS_Constitution
Property ANSConstitution As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = ANS_Constitution ];

/// ANS_BloodVessel
Property ANSBloodVessel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = ANS_BloodVessel ];

/// ANS_Mentation
Property ANSMentation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = ANS_Mentation ];

/// ANS_Skin
Property ANSSkin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = ANS_Skin ];

Property ANSBloodTranfused As %String(TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = ANS_BloodTranfused ];

Property ANSBloodTranfusedOther As %String(TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = ANS_BloodTranfusedOther ];

Property ANSCareProvType As %String(DISPLAYLIST = ",AnDoc,SupAnDoc,AssAnDoc,PacuAnDoc,ScrubNurse,CirculNurse,PacuNurse", VALUELIST = ",A,SA,AA,PA,SN,CN,PN") [ SqlColumnNumber = 41, SqlFieldName = ANS_CareProvType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANS_BPDiastolic">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANS_BPSystolic">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANS_BloodTranfused">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ANS_BloodTranfusedOther">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ANS_BloodVessel">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ANS_BodySurfIdentity">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ANS_CareProvType">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ANS_CathOther">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ANS_Catheter">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ANS_CatheterType">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ANS_Check">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ANS_Complication">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANS_Consciousness">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANS_Constitution">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ANS_Date">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANS_DeepIntravenPunc">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ANS_ExtremityMove">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANS_HeartRate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANS_HeartRhythm">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANS_IntravenInfusion">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ANS_IntravenPuncSite">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ANS_Mentation">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ANS_MonitorTech">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ANS_MonitorTechOther">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ANS_Note">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ANS_OxygenSaturation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANS_PatTransferMode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANS_ReliefCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANS_RespMode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANS_RespRate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANS_Respiration">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANS_ShiftCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANS_ShiftPlace">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANS_Skin">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ANS_Temperature">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANS_Time">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ANS_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANS_VadeMecum">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ANS_VadeMecumOther">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCANOPArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_OPArrange.OPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ANS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_OPArrange.OPA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shift"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANShiftS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
