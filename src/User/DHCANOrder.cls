/// DHC_AN_Order
Class User.DHCANOrder Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANO_RowId, SqlTableName = DHC_AN_Order, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 80000;

/// ANO_OPA_Dr
Property ANOOPADr As User.DHCANOPArrange [ SqlColumnNumber = 2, SqlFieldName = ANO_OPA_Dr ];

/// ANO_ANCORD_Dr
Property ANOANCORDDr As User.DHCANCCommonOrd [ SqlColumnNumber = 3, SqlFieldName = ANO_ANCORD_Dr ];

/// ANO_User_Dr
Property ANOUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ANO_User_Dr ];

/// ANO_StartDate
Property ANOStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = ANO_StartDate ];

/// ANO_StartTime
Property ANOStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = ANO_StartTime ];

/// ANO_EndDate
Property ANOEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ANO_EndDate ];

/// ANO_EndTime
Property ANOEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = ANO_EndTime ];

/// ANO_ARCIM_Dr
Property ANOARCIMDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ANO_ARCIM_Dr ];

/// ANO_Note
Property ANONote As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ANO_Note ];

/// ANO_Qty
Property ANOQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ANO_Qty ];

/// ANO_Uom_Dr
Property ANOUomDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ANO_Uom_Dr ];

/// ANO_Density
Property ANODensity As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = ANO_Density ];

/// ANO_Compli_Dr
Property ANOCompliDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ANO_Compli_Dr ];

/// ANO_Instr_Dr
Property ANOInstrDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ANO_Instr_Dr ];

/// ANO_ViewCat_Dr
Property ANOViewCatDr As User.DHCANCViewCat [ SqlColumnNumber = 16, SqlFieldName = ANO_ViewCat_Dr ];

/// ANO_Flag
Property ANOFlag As %Library.String(DISPLAYLIST = ",Normal,Pacu,Sedation,Other", MAXLEN = 6, SELECTIVITY = "20.00000%", TRUNCATE = 1, VALUELIST = ",N,P,S,O") [ SqlColumnNumber = 17, SqlFieldName = ANO_Flag ];

/// Property ANOFlag As %Library.String(DISPLAYLIST = ",Normal,Pacu", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,P") [ SqlColumnNumber = 17, SqlFieldName = ANO_Flag ];
/// ANO_DrugMode
Property ANODrugMode As %Library.String(DISPLAYLIST = ",Single,Continue,TCI", MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,C,T") [ SqlColumnNumber = 18, SqlFieldName = ANO_DrugMode ];

/// ANO_Speed
Property ANOSpeed As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = ANO_Speed ];

/// ANO_SpeedUnit_Dr
Property ANOSpeedUnitDr As User.DHCANCSpeedUnit [ SqlColumnNumber = 20, SqlFieldName = ANO_SpeedUnit_Dr ];

/// ANO_UpdateDate
Property ANOUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = ANO_UpdateDate ];

/// ANO_UpdateTime
Property ANOUpdateTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = ANO_UpdateTime ];

/// ANO_ANO_DR
Property ANOANODR As User.DHCANOrder [ SqlColumnNumber = 23, SqlFieldName = ANO_ANO_DR ];

/// ANO_Reason
Property ANOReason As %Library.String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = ANO_Reason ];

/// Property ANOReason As %Library.String(DISPLAYLIST = ",DataError,Need,WrongOper", MAXLEN = 9, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,N,W") [ SqlColumnNumber = 24, SqlFieldName = ANO_Reason ];
/// ANO_EditFlag
Property ANOEditFlag As %Library.String(DISPLAYLIST = ",Normal,Edit,Changed,Delete,Removed", MAXLEN = 7, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",N,E,C,D,R") [ SqlColumnNumber = 25, SqlFieldName = ANO_EditFlag ];

/// ANO_OEORI_Dr
Property ANOOEORIDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = ANO_OEORI_Dr ];

/// ANO_RecLoc_Dr
Property ANORecLocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = ANO_RecLoc_Dr ];

/// ANO_DocUser_Dr
Property ANODocUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = ANO_DocUser_Dr ];

/// ANO_Volume
Property ANOVolume As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = ANO_Volume ];

/// ANO_Source
Property ANOSource As %Library.String(DISPLAYLIST = ",Instrument,Manual", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,M") [ SqlColumnNumber = 30, SqlFieldName = ANO_Source ];

/// ANO_Type
Property ANOType As %Library.String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 31, SqlFieldName = ANO_Type ];

/// ANO_Qty2
Property ANOQty2 As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = ANO_Qty2 ];

/// ANO_Qty3
Property ANOQty3 As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = ANO_Qty3 ];

/// ANO_SubANOrder
Property ANOSubANOrder As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ANO_SubANOrder ];

/// ANO_MainANO_Dr
Property ANOMainANODr As User.DHCANOrder [ SqlColumnNumber = 35, SqlFieldName = ANO_MainANO_Dr ];

/// 20141011new
Property ANOAbbreviate As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = ANO_Abbreviate ];

Property ANOANPIDr As User.DHCANParaItem [ SqlColumnNumber = 37, SqlFieldName = ANO_ANPI_Dr ];

Storage SQLStorage
{
<ExtentSize>80000</ExtentSize>
<SqlIdExpression>$i(^DHCANOrder(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANO_ANCORD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANO_ANO_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ANO_ANPI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ANO_ARCIM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANO_Abbreviate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ANO_Compli_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANO_Density">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANO_DocUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ANO_DrugMode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANO_EditFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ANO_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANO_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANO_Flag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANO_Instr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANO_MainANO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ANO_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANO_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANO_OPA_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANO_Qty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANO_Qty2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ANO_Qty3">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ANO_Reason">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ANO_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ANO_Source">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ANO_Speed">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ANO_SpeedUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ANO_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANO_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANO_SubANOrder">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ANO_Type">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ANO_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ANO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ANO_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANO_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANO_Volume">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Global>^DHCANOrder</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ANO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ANO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCommOrd">
<Global>^DHCANOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CommOrd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANO_ANCORD_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANO_OPA_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpa">
<Global>^DHCANOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPApp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANO_OPA_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDateTime">
<Global>^DHCANOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ANO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdateDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANO_OPA_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANO_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANO_UpdateTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ANO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
