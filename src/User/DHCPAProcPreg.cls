/// DHC_PA_ProcPreg
Class User.DHCPAProcPreg Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PROCPR_RowId, SqlTableName = DHC_PA_ProcPreg, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PROCPR_Adm_DR
Property PROCPRAdmDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PROCPR_Adm_DR ];

/// PROCPR_BookingDate
Property PROCPRBookingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PROCPR_BookingDate ];

/// PROCPR_Date
Property PROCPRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PROCPR_Date ];

/// PROCPR_Time
Property PROCPRTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PROCPR_Time ];

/// PROCPR_GestatWeek
Property PROCPRGestatWeek As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PROCPR_GestatWeek ];

/// PROCPR_ChiefComplaint
Property PROCPRChiefComplaint As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PROCPR_ChiefComplaint ];

/// PROCPR_Weight
Property PROCPRWeight As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PROCPR_Weight ];

/// PROCPR_BPDiastolic
Property PROCPRBPDiastolic As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PROCPR_BPDiastolic ];

/// PROCPR_BPSystolic
Property PROCPRBPSystolic As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PROCPR_BPSystolic ];

/// PROCPR_UrineProtein
Property PROCPRUrineProtein As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PROCPR_UrineProtein ];

/// PROCPR_Hemoglobin
Property PROCPRHemoglobin As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PROCPR_Hemoglobin ];

/// PROCPR_Edema
Property PROCPREdema As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PROCPR_Edema ];

/// PROCPR_UterineHeight
Property PROCPRUterineHeight As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = PROCPR_UterineHeight ];

/// PROCPR_AbdomenCircum
Property PROCPRAbdomenCircum As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = PROCPR_AbdomenCircum ];

/// PROCPR_BabyPosition_DR
Property PROCPRBabyPositionDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PROCPR_BabyPosition_DR ];

/// PROCPR_FetalHeart
Property PROCPRFetalHeart As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PROCPR_FetalHeart ];

/// PROCPR_Quickening
Property PROCPRQuickening As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PROCPR_Quickening ];

/// PROCPR_Presentation_DR
Property PROCPRPresentationDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PROCPR_Presentation_DR ];

/// PROCPR_AmnioticFluidVol
Property PROCPRAmnioticFluidVol As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PROCPR_AmnioticFluidVol ];

/// PROCPR_UrineEstriol
Property PROCPRUrineEstriol As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PROCPR_UrineEstriol ];

/// PROCPR_BiparictalDis
Property PROCPRBiparictalDis As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = PROCPR_BiparictalDis ];

/// PROCPR_AmnioticFluidThick
Property PROCPRAmnioticFluidThick As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = PROCPR_AmnioticFluidThick ];

/// PROCPR_Disposal
Property PROCPRDisposal As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PROCPR_Disposal ];

/// PROCPR_Ctcp_DR
Property PROCPRCtcpDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = PROCPR_Ctcp_DR ];

/// PROCPR_Treat
Property PROCPRTreat As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PROCPR_Treat ];

/// PROCPR_Note
Property PROCPRNote As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PROCPR_Note ];

/// PROCPR_UpdateDate
Property PROCPRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = PROCPR_UpdateDate ];

/// PROCPR_UpdateTime
Property PROCPRUpdateTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = PROCPR_UpdateTime ];

/// PROCPR_UpdateUser_DR
Property PROCPRUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PROCPR_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCProcPreg(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PROCPR_AbdomenCircum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PROCPR_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROCPR_AmnioticFluidThick">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PROCPR_AmnioticFluidVol">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PROCPR_BPDiastolic">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PROCPR_BPSystolic">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PROCPR_BabyPosition_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PROCPR_BiparictalDis">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PROCPR_BookingDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROCPR_ChiefComplaint">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PROCPR_Ctcp_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PROCPR_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROCPR_Disposal">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PROCPR_Edema">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PROCPR_FetalHeart">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PROCPR_GestatWeek">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PROCPR_Hemoglobin">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PROCPR_Note">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PROCPR_Presentation_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PROCPR_Quickening">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PROCPR_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PROCPR_Treat">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PROCPR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PROCPR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PROCPR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PROCPR_UrineEstriol">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PROCPR_UrineProtein">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PROCPR_UterineHeight">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PROCPR_Weight">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCProcPreg</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PROCPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PROCPR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCProcPreg</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PROCPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PROCPR_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PROCPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCProcPreg</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PROCPR_RowId</Field>
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
<Expression>{PROCPR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PROCPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAProcPregS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
