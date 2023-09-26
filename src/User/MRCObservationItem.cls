/// MRC Observation Item(1711)
Class User.MRCObservationItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ObservationItem, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCObservationItemLookUp As MRCObservationItemLookUp [ Cardinality = children, Inverse = LUParRef ];

/// Code 体征项代码
Property ITMCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ITM_Code ];

/// Description 体征项描述
Property ITMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ITM_Desc ];

/// Input Type 数据类型
Property ITMInputType As %String(DISPLAYLIST = ",Number,Text,External,Calculated,LookUp", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",N,T,E,C,L") [ SqlColumnNumber = 4, SqlFieldName = ITM_InputType ];

/// Des Ref CTUOM
Property ITMCTUOMDR As CTUOM [ SqlColumnNumber = 5, SqlFieldName = ITM_CTUOM_DR ];

/// Length of Input
Property ITMLength As %Float [ SqlColumnNumber = 6, SqlFieldName = ITM_Length ];

/// Fluid Balance Type
Property ITMFluidBalanceType As %String(DISPLAYLIST = ",Input,Output", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 7, SqlFieldName = ITM_FluidBalanceType ];

/// Formula 录入的次数/天
Property ITMFormula As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ITM_Formula ];

/// Confirmation 是否空白栏标题
Property ITMConfirmation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ITM_Confirmation ];

/// Graph Color 特殊符号
Property ITMGraphColor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ITM_GraphColor ];

/// System created
Property ITMSystem As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ITM_System ];

/// Graph Marker
Property ITMGraphMarker As %Float [ SqlColumnNumber = 12, SqlFieldName = ITM_GraphMarker ];

/// Graph Pattern
Property ITMGraphPattern As %Float [ SqlColumnNumber = 13, SqlFieldName = ITM_GraphPattern ];

/// Range From 正常值起始范围
Property ITMRangeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ITM_RangeFrom ];

/// RangeTo 正常值截至范围
Property ITMRangeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ITM_RangeTo ];

/// Values  体征备选项
Property ITMValues As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ITM_Values ];

/// HighRange
Property ITMHighRange As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ITM_HighRange ];

/// LowRange
Property ITMLowRange As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ITM_LowRange ];

/// not used  顺序值
Property ITMObservStatusDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ITM_ObservStatus_DR ];

/// Alert Range From  错误低值上限
Property ITMAlertRangeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = ITM_AlertRangeFrom ];

/// Alert Range To  错误高值下限
Property ITMAlertRangeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = ITM_AlertRangeTo ];

/// Alert Value List
Property ITMAlertValueList As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ITM_AlertValueList ];

/// DecimalPlaces
Property ITMDecimalPlaces As %Float [ SqlColumnNumber = 23, SqlFieldName = ITM_DecimalPlaces ];

/// BabyFlag 成人婴儿标志
Property ITMBabyFlag As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = ITM_BabyFlag ];

/// ,首次分床显示,首次分床必填
Property ITMIsFirstShow As %String(DISPLAYLIST = ",SHOW,REQUIRE", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",S,R") [ SqlColumnNumber = 25, SqlFieldName = ITM_IsFirstShow ];

/// ,出量,入量,血糖,非出入量,体温
Property ITMSignType As %String(DISPLAYLIST = ",OUT,IN,BLOODSUGAR,NOTINOUT,TEMPERATURE", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",O,I,B,N,T") [ SqlColumnNumber = 26, SqlFieldName = ITM_SignType ];

Property ITMValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = ITM_Valid ];

Property ITMHospital As %String [ SqlColumnNumber = 28, SqlFieldName = ITM_HOSPITAL ];

/// 缩写
Property ITMAbbrCode As %String [ SqlColumnNumber = 29, SqlFieldName = ITM_AbbrCode ];

/// 昨日描述
Property ITMYestDesc As %String [ SqlColumnNumber = 30, SqlFieldName = ITM_YestDesc ];

/// 是否支持自定义（体征项配置特殊值后是否支持自定义输入，User Define）
Property ITMUDFlag As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = ITM_UDFlag ];

/// 是否控制录入频次
Property ITMFormulaControl As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = ITM_FormulaControl ];

/// 是否延续空白栏标题到下一页（下周）
Property ITMTitleLastWeek As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = ITM_TitleLastWeek ];

/// 多人体征列宽
Property ITMColWidth As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = ITM_ColWidth ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCObservationItem).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItem","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCObservationItem).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItem","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCObservationItem).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItem","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCObservationItem).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItem","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCObservationItem).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItem","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItem","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>158</ExtentSize>
<Property name="ITMAlertRangeFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMAlertRangeTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMAlertValueList">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMCTUOMDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ITMCode">
<Selectivity>0.6452%</Selectivity>
</Property>
<Property name="ITMConfirmation">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ITMDecimalPlaces">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ITMDesc">
<Selectivity>0.6993%</Selectivity>
</Property>
<Property name="ITMFluidBalanceType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ITMFormula">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ITMGraphColor">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="ITMGraphMarker">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="ITMGraphPattern">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ITMHighRange">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ITMInputType">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ITMLength">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ITMLowRange">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ITMObservStatusDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMRangeFrom">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="ITMRangeTo">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ITMSystem">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ITMValues">
<Selectivity>50.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^MRC("OBITM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ITM_AbbrCode">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ITM_AlertRangeFrom">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ITM_AlertRangeTo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ITM_AlertValueList">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ITM_BabyFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ITM_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_ColWidth">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ITM_Confirmation">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ITM_DecimalPlaces">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ITM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_FluidBalanceType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITM_Formula">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITM_FormulaControl">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ITM_GraphColor">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ITM_GraphMarker">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITM_GraphPattern">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ITM_HOSPITAL">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ITM_HighRange">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ITM_InputType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_IsFirstShow">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ITM_Length">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITM_LowRange">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ITM_ObservStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ITM_RangeFrom">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ITM_RangeTo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ITM_SignType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ITM_System">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ITM_TitleLastWeek">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ITM_UDFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ITM_Valid">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ITM_Values">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ITM_YestDesc">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBITM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ITM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBITM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ITM_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBITM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ITM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OBITM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hospital"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_HOSPITAL}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_ObservStatus_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospitalCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OBITM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOSPCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_HOSPITAL}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ITM_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexObservStatusDR">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OBITM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ObservStatusDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_ObservStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.MRCObservationItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
