/// DHC_ICU_Order
Class User.DHCICUOrder Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUO_RowId, SqlTableName = DHC_ICU_Order, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCICUOrderDetail As User.DHCICUOrderDetail [ Cardinality = children, Inverse = ICUODParref ];

/// ICUO_ICUA_Dr
Property ICUOICUADr As User.DHCICUArrange [ SqlColumnNumber = 2, SqlFieldName = ICUO_ICUA_Dr ];

/// ICUO_ComOrd_Dr
Property ICUOComOrdDr As User.DHCICUCRecordItem [ SqlColumnNumber = 3, SqlFieldName = ICUO_ComOrd_Dr ];

/// ICUO_Oeore_Dr
Property ICUOOeoreDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ICUO_Oeore_Dr ];

/// ICUO_User_Dr
Property ICUOUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ICUO_User_Dr ];

/// ICUO_StartDate
Property ICUOStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = ICUO_StartDate ];

/// ICUO_StartTime
Property ICUOStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = ICUO_StartTime ];

/// ICUO_EndDate
Property ICUOEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = ICUO_EndDate ];

/// ICUO_EndTime
Property ICUOEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = ICUO_EndTime ];

/// ICUO_Arcim_Dr
Property ICUOArcimDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ICUO_Arcim_Dr ];

/// ICUO_Note
Property ICUONote As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ICUO_Note ];

/// ICUO_Qty
Property ICUOQty As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ICUO_Qty ];

/// ICUO_Uom_Dr
Property ICUOUomDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ICUO_Uom_Dr ];

/// ICUO_Concentration
Property ICUOConcentration As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = ICUO_Concentration ];

/// ICUO_OriginateFromICUO_Dr
Property ICUOOriginateFromICUODr As User.DHCICUOrder [ SqlColumnNumber = 15, SqlFieldName = ICUO_OriginateFromICUO_Dr ];

/// ICUO_Instr_Dr
Property ICUOInstrDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ICUO_Instr_Dr ];

/// ICUO_ViewCat_Dr
Property ICUOViewCatDr As User.DHCICUCViewCat [ SqlColumnNumber = 17, SqlFieldName = ICUO_ViewCat_Dr ];

/// ICUO_Flag
Property ICUOFlag As %Library.String(DISPLAYLIST = ",Normal,TimeExclude", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,T") [ SqlColumnNumber = 18, SqlFieldName = ICUO_Flag ];

/// ICUO_DrugMode
Property ICUODrugMode As %Library.String(DISPLAYLIST = ",Single,Continue", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",S,C") [ SqlColumnNumber = 19, SqlFieldName = ICUO_DrugMode ];

/// ICUO_Speed
Property ICUOSpeed As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = ICUO_Speed ];

/// ICUO_SpeedUnit_Dr
Property ICUOSpeedUnitDr As User.DHCANCSpeedUnit [ SqlColumnNumber = 21, SqlFieldName = ICUO_SpeedUnit_Dr ];

/// ICUO_UpdateDate
Property ICUOUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = ICUO_UpdateDate ];

/// ICUO_UpdateTime
Property ICUOUpdateTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = ICUO_UpdateTime ];

/// ICUO_ICUO_DR
Property ICUOICUODR As User.DHCICUOrder [ SqlColumnNumber = 24, SqlFieldName = ICUO_ICUO_DR ];

/// ICUO_Reason
Property ICUOReason As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ICUO_Reason ];

/// ICUO_EditFlag
Property ICUOEditFlag As %Library.String(DISPLAYLIST = ",Normal,Edit,Changed,Delete,Removed,Pause,Undo,Ignore", MAXLEN = 7, SELECTIVITY = "11.1111%", TRUNCATE = 1, VALUELIST = ",N,E,C,D,R,P,U,I") [ SqlColumnNumber = 26, SqlFieldName = ICUO_EditFlag ];

/// ICUO_RecLoc_Dr
Property ICUORecLocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = ICUO_RecLoc_Dr ];

/// ICUO_DocUser_Dr
Property ICUODocUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = ICUO_DocUser_Dr ];

/// ICUO_Volume
Property ICUOVolume As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = ICUO_Volume ];

/// ICUO_Source
Property ICUOSource As %Library.String(DISPLAYLIST = ",Instrument,Manual,Assistant", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,M,A") [ SqlColumnNumber = 30, SqlFieldName = ICUO_Source ];

/// ICUO_Type
Property ICUOType As %Library.String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 31, SqlFieldName = ICUO_Type ];

/// ICUO_PreparedVolume
Property ICUOPreparedVolume As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = ICUO_PreparedVolume ];

/// ICUO_AttachOeoriId
Property ICUOAttachOeoriId As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = ICUO_AttachOeoriId ];

/// ICUO_ReportResult
Property ICUOReportResult As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ICUO_ReportResult ];

Property ICUOAbbreviate As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = ICUO_Abbreviate ];

Property ICUOOrdItemNote As %String [ SqlColumnNumber = 36, SqlFieldName = ICUO_OrdItemNote ];

Property ICUOMainIcuoDr As User.DHCICUOrder [ SqlColumnNumber = 37, SqlFieldName = ICUO_MainIcuo_Dr ];

Property ICUORemarks As %String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = ICUO_Remarks ];

Property ICUOICUPIDr As User.DHCICUParaItem [ SqlColumnNumber = 39, SqlFieldName = ICUO_ICUPI_Dr ];

Property ICUOTotalQty As %Float [ SqlColumnNumber = 40, SqlFieldName = ICUO_TotalQty ];

Property ICUODoseSpeed As %Float [ SqlColumnNumber = 41, SqlFieldName = ICUO_DoseSpeed ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUOrder(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUO_Abbreviate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ICUO_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUO_AttachOeoriId">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ICUO_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUO_Concentration">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUO_DocUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ICUO_DoseSpeed">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ICUO_DrugMode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ICUO_EditFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ICUO_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUO_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUO_Flag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ICUO_ICUA_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUO_ICUO_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ICUO_ICUPI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ICUO_Instr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ICUO_MainIcuo_Dr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ICUO_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUO_Oeore_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUO_OrdItemNote">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ICUO_OriginateFromICUO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ICUO_PreparedVolume">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ICUO_Qty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUO_Reason">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ICUO_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ICUO_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ICUO_ReportResult">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ICUO_Source">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ICUO_Speed">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ICUO_SpeedUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ICUO_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUO_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUO_TotalQty">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ICUO_Type">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ICUO_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ICUO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ICUO_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUO_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ICUO_Volume">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Global>^DHCICUOrder</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICUO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ICUO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArrange">
<Global>^DHCICUOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUO_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCommOrd">
<Global>^DHCICUOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICUO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CommOrd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUO_ComOrd_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUO_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeore">
<Global>^DHCICUOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICUO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUO_Oeore_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUO_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecordItem">
<Global>^DHCICUOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ICUO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecordItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUO_ComOrd_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUO_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUO_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ICUO_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ICUO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDateTime">
<Global>^DHCICUOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ICUO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SttDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUO_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUO_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{ICUO_StartTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ICUO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
