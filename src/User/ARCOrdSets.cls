/// ARC Order Set           (ARCOS,113)
Class User.ARCOrdSets Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 106;

Relationship ChildARCOrdSetDate As ARCOrdSetDate [ Cardinality = children, Inverse = DATEParRef ];

Relationship ChildARCOrdSetPrice As ARCOrdSetPrice [ Cardinality = children, Inverse = PRICEParRef ];

Relationship ChildARCOrdSetExternalCodes As ARCOrdSetExternalCodes [ Cardinality = children, Inverse = EXParRef ];

Relationship ChildARCOrdSetsHosp As ARCOrdSetsHosp [ Cardinality = children, Inverse = HOSPParRef ];

/// ARCOS Row ID
Property ARCOSRowId As %String(TRUNCATE = 1) [ InitialExpression = {$i(^ARCOS(0))}, Required, SqlFieldName = ARCOS_RowId ];

/// Order Set Code
Property ARCOSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ARCOS_Code ];

/// Archived Flag
Property ARCOSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = ARCOS_ActiveFlag ];

/// (needed? lsk) Des Ref to ARCIC
Property ARCOSItemTypeDR As ARCItemCat [ SqlColumnNumber = 5, SqlFieldName = ARCOS_ItemType_DR ];

/// Description
Property ARCOSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 6, SqlFieldName = ARCOS_Desc ];

/// Subscript
Property ARCOSSubscript As %Numeric(SCALE = 0) [ InitialExpression = {$i(^ARCOS(0))}, SqlColumnNumber = 8, SqlFieldName = ARCOS_Subscript ];

/// Version
Property ARCOSVersion As %Float [ InitialExpression = 1, SqlColumnNumber = 9, SqlFieldName = ARCOS_Version ];

/// Current Version
Property ARCOSCurVersDR As ARCOrdSets [ SqlColumnNumber = 10, SqlComputeCode = { S {ARCOS_CurVers_DR}=$$CO10^at113({ARCOS_Subscript})
}, SqlComputed, SqlFieldName = ARCOS_CurVers_DR, Transient ];

/// Current
Property ARCOSCurVerFlg As %String(COLLATION = "Exact", MAXLEN = 7, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlComputeCode = { S {ARCOS_CurVerFlg}=$$CURVER^at113({ARCOS_CurVers_DR},{ARCOS_RowId})
}, SqlComputed, SqlFieldName = ARCOS_CurVerFlg, Transient ];

/// Effective Date
Property ARCOSEffDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = ARCOS_EffDate ];

/// Effective Time
Property ARCOSEffTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = ARCOS_EffTime ];

/// Effective Date / Time
Property ARCOSEffDateTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlComputeCode = { s {ARCOS_EffDateTime}=$p({ARCOS_EffDate},$c(1))_"Z"_$p({ARCOS_EffTime},$c(1))
}, SqlComputed, SqlComputeOnChange = (ARCOSEffDate, ARCOSEffTime), SqlFieldName = ARCOS_EffDateTime ];

/// Des Ref to OrdCat
Property ARCOSOrdCatDR As OECOrderCategory [ SqlColumnNumber = 16, SqlFieldName = ARCOS_OrdCat_DR ];

/// Des Ref to OrdSubCat
Property ARCOSOrdSubCatDR As ARCItemCat [ SqlColumnNumber = 17, SqlFieldName = ARCOS_OrdSubCat_DR ];

/// Package Price
Property ARCOSPackagePrice As %Float [ SqlColumnNumber = 18, SqlFieldName = ARCOS_PackagePrice ];

/// LabTrak TestSet Code
Property ARCOSLabTrakTestSet As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ARCOS_LabTrakTestSet ];

/// ARCOS_Type_Calc
Property ARCOSTypeCalc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlComputeCode = { s {ARCOS_Type_Calc}="ARCOS"
}, SqlComputed, SqlFieldName = ARCOS_Type_Calc, Transient ];

/// Des Ref Service Group
Property ARCOSServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 22, SqlFieldName = ARCOS_ServiceGroup_DR ];

/// Minutes
Property ARCOSMinutes As %Float [ SqlColumnNumber = 23, SqlFieldName = ARCOS_Minutes ];

/// Days
Property ARCOSDays As %Float [ SqlColumnNumber = 24, SqlFieldName = ARCOS_Days ];

/// Effective Date From
Property ARCOSEffDateFrom As %Date [ Required, SqlColumnNumber = 25, SqlFieldName = ARCOS_EffDateFrom ];

/// Effective Date To
Property ARCOSEffDateTo As %Date [ SqlColumnNumber = 26, SqlFieldName = ARCOS_EffDateTo ];

/// Des Ref DefPriority
Property ARCOSDefPriorityDR As OECPriority [ SqlColumnNumber = 27, SqlFieldName = ARCOS_DefPriority_DR ];

/// Des Ref BillGroup
Property ARCOSBillGroupDR As ARCBillGrp [ SqlColumnNumber = 28, SqlFieldName = ARCOS_BillGroup_DR ];

/// Des Ref BillSub
Property ARCOSBillSubDR As ARCBillSub [ SqlColumnNumber = 29, SqlFieldName = ARCOS_BillSub_DR ];

/// Duration DR
Property ARCOSDurationDR As PHCDuration [ SqlColumnNumber = 30, SqlFieldName = ARCOS_DurationDR ];

/// FrequencyDR
Property ARCOSFrequencyDR As PHCFreq [ SqlColumnNumber = 31, SqlFieldName = ARCOS_FrequencyDR ];

/// 最后修改日期
Property ARCOSLastUpdateDate As %Library.Date [ SqlColumnNumber = 32, SqlFieldName = ARCOS_LastUpdateDate ];

/// 最后修改时间
Property ARCOSLastUpdateTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = ARCOS_LastUpdateTime ];

/// 最后修改人
Property ARCOSLastUpdateUserDR As SSUser [ SqlColumnNumber = 34, SqlFieldName = ARCOS_LastUpdateUserDR ];

/// 备注
Property ARCOSNotes As %String [ SqlColumnNumber = 35, SqlFieldName = ARCOS_Notes ];

/// 处方类型代码
Property ARCOSPrescTypeCode As %String [ SqlColumnNumber = 36, SqlFieldName = ARCOS_PrescTypeCode ];

/// 用法
Property ARCOSInstrDR As PHCInstruc [ SqlColumnNumber = 37, SqlFieldName = ARCOS_Instr_DR ];

/// 用法关联剂量--之前定义的PHCInstrucLinkDosage，写错了，修改为用量
Property ARCOSInstrLinkDosageDR As PHCDosage [ SqlColumnNumber = 38, SqlFieldName = ARCOS_InstrLinkDosage_DR ];

/// 创建人
Property ARCOSAddUserDR As SSUser [ SqlColumnNumber = 39, SqlFieldName = ARCOS_AddUserDR ];

/// 创建日期
Property ARCOSAddDate As %Library.Date [ SqlColumnNumber = 40, SqlFieldName = ARCOS_AddDate ];

/// 创建时间
Property ARCOSAddTime As %Library.Time [ SqlColumnNumber = 41, SqlFieldName = ARCOS_AddTime ];

Index RowIDBasedIDKeyIndex On ARCOSRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCOrdSets).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSets","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCOrdSets).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSets","OnAfterInsert")
 
 d POFILINS^at113
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCOrdSets).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSets","OnAfterUpdate")
 
 d POFILUPD^at113
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCOrdSets).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSets","OnBeforeDelete")
 
 d VALDEL^at113
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCOrdSets).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSets","OnBeforeUpdate")
 
 d VALUPD^at113
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSets","OnBeforeInsert")
 
 d VALINS^at113
}

Storage SQLStorage
{
<ExtentSize>156</ExtentSize>
<Property name="ARCOSActiveFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARCOSBillGroupDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ARCOSBillSubDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ARCOSCode">
<Selectivity>0.6711%</Selectivity>
</Property>
<Property name="ARCOSCurVerFlg">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCOSCurVersDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCOSDays">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ARCOSDefPriorityDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ARCOSDesc">
<Selectivity>0.6757%</Selectivity>
</Property>
<Property name="ARCOSDurationDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ARCOSEffDate">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="ARCOSEffDateFrom">
<Selectivity>1.2658%</Selectivity>
</Property>
<Property name="ARCOSEffDateTime">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="ARCOSEffDateTo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARCOSEffTime">
<Selectivity>5.0000%</Selectivity>
</Property>
<Property name="ARCOSFrequencyDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ARCOSItemTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCOSLabTrakTestSet">
<Selectivity>2.6316%</Selectivity>
</Property>
<Property name="ARCOSMinutes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARCOSOrdCatDR">
<Selectivity>4.5455%</Selectivity>
</Property>
<Property name="ARCOSOrdSubCatDR">
<Selectivity>2.2727%</Selectivity>
</Property>
<Property name="ARCOSPackagePrice">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCOSRowId">
<Selectivity>1</Selectivity>
</Property>
<Property name="ARCOSServiceGroupDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ARCOSSubscript">
<Selectivity>5.0000%</Selectivity>
</Property>
<Property name="ARCOSTypeCalc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCOSVersion">
<Selectivity>50.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARCOS(0))</SqlIdExpression>
<SQLMap name="DataMasterARCOS">
<Data name="ARCOS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCOS_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ARCOS_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ARCOS_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ARCOS_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ARCOS_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ARCOS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCOS_Days">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARCOS_DefPriority_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARCOS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARCOS_DurationDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ARCOS_EffDate">
<Delimiter>"^","Z"</Delimiter>
<Piece>5,1</Piece>
</Data>
<Data name="ARCOS_EffDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ARCOS_EffDateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARCOS_EffDateTo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARCOS_EffTime">
<Delimiter>"^","Z"</Delimiter>
<Piece>5,2</Piece>
</Data>
<Data name="ARCOS_FrequencyDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ARCOS_InstrLinkDosage_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ARCOS_Instr_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ARCOS_ItemType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCOS_LabTrakTestSet">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARCOS_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ARCOS_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ARCOS_LastUpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ARCOS_Minutes">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARCOS_Notes">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ARCOS_OrdCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARCOS_OrdSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARCOS_PackagePrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARCOS_PrescTypeCode">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ARCOS_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARCOS_Subscript">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARCOS_Version">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^ARCOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARCOS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAliasAll">
<Condition>1</Condition>
<Data name="ARCOS_RowId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCOS_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>100</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOSVisItems">
<Condition>1</Condition>
<Data name="ARCOS_RowId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCOS_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOrdCatAll">
<Condition>1</Condition>
<Data name="ARCOS_RowId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCOS_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>100</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCOS_OrdSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOrdCatOSVis">
<Condition>1</Condition>
<Data name="ARCOS_RowId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCOS_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCOS_OrdSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>1</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ARCOS_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ARCOS_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdSubcat">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARCOS_OrdSubCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderCategory">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARCOS_OrdCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceGroup">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCOS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARCOS_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCOS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCOS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
