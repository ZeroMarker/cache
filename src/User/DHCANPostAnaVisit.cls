/// DHC_AN_PostAnaVisit
Class User.DHCANPostAnaVisit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAV_RowId, SqlTableName = DHC_AN_PostAnaVisit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PAVChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_OPArrange Parent Reference
Relationship PAVParref As User.DHCANOPArrange [ Cardinality = parent, Inverse = ChildDHCANPostAnaVisit, Required, SqlFieldName = PAV_Parref ];

//  For P8

/// PAV_ChildSub
Property PAVChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"PAV",0))}, SqlColumnNumber = 2, SqlFieldName = PAV_ChildSub ];

/// PAV_IntrathEpiduralAmt
Property PAVIntrathEpiduralAmt As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PAV_IntrathEpiduralAmt ];

/// PAV_VenipunctureAmt
Property PAVVenipunctureAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PAV_VenipunctureAmt ];

/// PAV_PeripheryNerveAmt
Property PAVPeripheryNerveAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PAV_PeripheryNerveAmt ];

/// PAV_PumpCount
Property PAVPumpCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PAV_PumpCount ];

/// PAV_PumpCountAvail
Property PAVPumpCountAvail As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PAV_PumpCountAvail ];

/// PAV_PumpFailure
Property PAVPumpFailure As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PAV_PumpFailure ];

/// PAV_PumpFailureDispose
Property PAVPumpFailureDispose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PAV_PumpFailureDispose ];

/// PAV_VasScore
Property PAVVasScore As %Library.String [ SqlColumnNumber = 10, SqlFieldName = PAV_VasScore ];

/// PAV_AnalgesiaScore
Property PAVAnalgesiaScore As %Library.String [ SqlColumnNumber = 11, SqlFieldName = PAV_AnalgesiaScore ];

/// PAV_MuscleRelaxScore
Property PAVMuscleRelaxScore As %Library.String [ SqlColumnNumber = 12, SqlFieldName = PAV_MuscleRelaxScore ];

/// PAV_SedationScore
Property PAVSedationScore As %Library.String [ SqlColumnNumber = 13, SqlFieldName = PAV_SedationScore ];

/// PAV_NauseaScore
Property PAVNauseaScore As %Library.String [ SqlColumnNumber = 14, SqlFieldName = PAV_NauseaScore ];

/// PAV_VomitingScore
Property PAVVomitingScore As %Library.String [ SqlColumnNumber = 15, SqlFieldName = PAV_VomitingScore ];

/// PAV_UrinaryRetentionScore
Property PAVUrinaryRetentionScore As %Library.String [ SqlColumnNumber = 16, SqlFieldName = PAV_UrinaryRetentionScore ];

/// PAV_Complication
Property PAVComplication As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PAV_Complication ];

/// PAV_ComplicGeneral
Property PAVComplicGeneral As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PAV_ComplicGeneral ];

/// PAV_ComplicIntrathecal
Property PAVComplicIntrathecal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PAV_ComplicIntrathecal ];

/// PAV_ComplicNerveBlock
Property PAVComplicNerveBlock As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PAV_ComplicNerveBlock ];

/// PAV_ComplicOther
Property PAVComplicOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PAV_ComplicOther ];

/// PAV_ObserveCtcp_Dr
Property PAVObserveCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PAV_ObserveCtcp_Dr ];

/// PAV_Ctcp_Dr
Property PAVCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PAV_Ctcp_Dr ];

/// PAV_Date
Property PAVDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = PAV_Date ];

/// PAV_Time
Property PAVTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = PAV_Time ];

/// PAV_Note
Property PAVNote As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PAV_Note ];

Property PAVBPSystolic As %Float [ SqlColumnNumber = 27, SqlFieldName = PAV_BPSystolic ];

Property PAVBPDiastolic As %Float [ SqlColumnNumber = 28, SqlFieldName = PAV_BPDiastolic ];

Property PAVHeartRate As %Float [ SqlColumnNumber = 29, SqlFieldName = PAV_HeartRate ];

Property PAVRespRate As %Float [ SqlColumnNumber = 30, SqlFieldName = PAV_RespRate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PAV_AnalgesiaScore">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAV_BPDiastolic">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PAV_BPSystolic">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PAV_ComplicGeneral">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PAV_ComplicIntrathecal">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PAV_ComplicNerveBlock">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PAV_ComplicOther">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PAV_Complication">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PAV_Ctcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PAV_Date">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PAV_HeartRate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PAV_IntrathEpiduralAmt">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAV_MuscleRelaxScore">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAV_NauseaScore">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAV_Note">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PAV_ObserveCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PAV_PeripheryNerveAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAV_PumpCount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAV_PumpCountAvail">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAV_PumpFailure">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAV_PumpFailureDispose">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAV_RespRate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PAV_SedationScore">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAV_Time">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PAV_UrinaryRetentionScore">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PAV_VasScore">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAV_VenipunctureAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAV_VomitingScore">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCANOPArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_OPArrange.OPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_OPArrange.OPA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAV_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANPostAnaVisitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
