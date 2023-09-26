Class User.DHCPHDrgQuaEvtReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DQER_RowID, SqlTableName = DHC_PHDrgQuaEvtReport, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHDQEVTREPDRGITM As User.DHCPHDQEvtRepDrgItm [ Cardinality = children, Inverse = DQERDIDQERParref ];

Relationship ChildDHCPHDQEVTREPTRIFAC As User.DHCPHDQEvtRepTriFac [ Cardinality = children, Inverse = DQERTFDQERParref ];

/// DQER_RepLoc_Dr
Property DQERRepLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DQER_RepLoc_Dr ];

/// DQER_Date
Property DQERDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DQER_Date ];

/// DQER_PatID
Property DQERPatID As User.PAPatMas [ SqlColumnNumber = 4, SqlFieldName = DQER_PatID ];

/// DQER_PatName
Property DQERPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DQER_PatName ];

/// DQER_PatSex
Property DQERPatSex As User.CTSex [ SqlColumnNumber = 6, SqlFieldName = DQER_PatSex ];

/// DQER_PatAge
Property DQERPatAge As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DQER_PatAge ];

/// DQER_PatDOB
Property DQERPatDOB As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DQER_PatDOB ];

/// DQER_PatMedNo
Property DQERPatMedNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DQER_PatMedNo ];

/// DQER_AdmLoc_Dr
Property DQERAdmLocDr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = DQER_AdmLoc_Dr ];

/// DQER_EvtOccDate
Property DQEREvtOccDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DQER_EvtOccDate ];

/// DQER_DisEvtDate
Property DQERDisEvtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DQER_DisEvtDate ];

/// DQER_EvtLevel
Property DQEREvtLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DQER_EvtLevel ];

/// DQER_OccLocation
Property DQEROccLocation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DQER_OccLocation ];

/// DQER_OccLocDesc
Property DQEROccLocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DQER_OccLocDesc ];

/// DQER_RelateInfo
Property DQERRelateInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DQER_RelateInfo ];

/// DQER_RelateInfoDesc
Property DQERRelateInfoDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DQER_RelateInfoDesc ];

/// DQER_Death
Property DQERDeath As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DQER_Death ];

/// DQER_ImCauseOfDeath
Property DQERImCauseOfDeath As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DQER_ImCauseOfDeath ];

/// DQER_DeathDate
Property DQERDeathDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DQER_DeathDate ];

/// DQER_DeathTime
Property DQERDeathTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = DQER_DeathTime ];

/// DQER_RecProc
Property DQERRecProc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DQER_RecProc ];

/// DQER_HarmLevel
Property DQERHarmLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DQER_HarmLevel ];

/// DQER_HarmDesc
Property DQERHarmDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DQER_HarmDesc ];

/// DQER_ExtHospTime
Property DQERExtHospTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DQER_ExtHospTime ];

/// DQER_CriticallyIll
Property DQERCriticallyIll As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DQER_CriticallyIll ];

/// DQER_CriIllReport
Property DQERCriIllReport As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DQER_CriIllReport ];

/// DQER_GeneProc
Property DQERGeneProc As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DQER_GeneProc ];

/// DQER_HandleInfo
Property DQERHandleInfo As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DQER_HandleInfo ];

/// DQER_ImproMeasure
Property DQERImproMeasure As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DQER_ImproMeasure ];

/// DQER_Reporter
Property DQERReporter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DQER_Reporter ];

/// DQER_PriOfRepLoc
Property DQERPriOfRepLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DQER_PriOfRepLoc ];

/// DQER_RepCode
Property DQERRepCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DQER_RepCode ];

/// DQER_CurStatus_DR  -liyarong 2016-09-18
Property DQERCurStatusDr As %Library.String [ SqlColumnNumber = 34, SqlFieldName = DQER_CurStatus_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDQER)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DQER_AdmLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DQER_CriIllReport">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DQER_CriticallyIll">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DQER_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DQER_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DQER_Death">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DQER_DeathDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DQER_DeathTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DQER_DisEvtDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DQER_EvtLevel">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DQER_EvtOccDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DQER_ExtHospTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DQER_GeneProc">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DQER_HandleInfo">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DQER_HarmDesc">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DQER_HarmLevel">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DQER_ImCauseOfDeath">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DQER_ImproMeasure">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DQER_OccLocDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DQER_OccLocation">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DQER_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DQER_PatDOB">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DQER_PatID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DQER_PatMedNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DQER_PatName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DQER_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DQER_PriOfRepLoc">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DQER_RecProc">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DQER_RelateInfo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DQER_RelateInfoDesc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DQER_RepCode">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DQER_RepLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DQER_Reporter">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCPHDQER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DQER_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DQER_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHDQER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DQER_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DQER_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DQER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDrgQuaEvtReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
