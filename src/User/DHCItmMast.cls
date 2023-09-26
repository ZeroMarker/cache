Class User.DHCItmMast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DARCIM_Rowid, SqlTableName = DHC_ItmMast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCItmAppend As User.DHCItmAppend [ Cardinality = children, Inverse = DHCIAParRef ];

Relationship ChildDHCItmConflict As User.DHCItmConflict [ Cardinality = children, Inverse = ITCParRef ];

Relationship ChildDHCItmReplace As User.DHCItmReplace [ Cardinality = children, Inverse = IRParRef ];

/// DARCIM_ARCIM_DR
Property DARCIMARCIMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DARCIM_ARCIM_DR ];

/// DARCIM_MinQty
Property DARCIMMinQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DARCIM_MinQty ];

/// DARCIM_MaxQty
Property DARCIMMaxQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DARCIM_MaxQty ];

/// DARCIM_ShowOEMessage
Property DARCIMShowOEMessage As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DARCIM_ShowOEMessage ];

/// DARCIM_RequireNote
Property DARCIMRequireNote As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DARCIM_RequireNote ];

/// DARCIM_NeedSkinTest
Property DARCIMNeedSkinTest As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DARCIM_NeedSkinTest ];

/// DARCIM_AlertStockQty
Property DARCIMAlertStockQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DARCIM_AlertStockQty ];

/// DARCIM_IPNeedBillQty
Property DARCIMIPNeedBillQty As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DARCIM_IPNeedBillQty ];

/*
Actual原始值(没有任何偏好,即按照实际填写的单次剂量进行累加计算),
Half 偏好取半(即不足一半取半,足够一半取整),
FullDown 偏好向下取整(即不为整数则向下取整，最小值不低于1),
FullUp 偏好向上取整(即不为整数则向上取整)
住院或出院带药在转为整包装数时均会向上取整
*/
/// 单次剂量的计算偏好值：
Property DARCIMPartialValue As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Actual,Half,FullDown,FullUp", MAXLEN = 30, VALUELIST = ",A,H,FD,FU") [ SqlColumnNumber = 10, SqlFieldName = DARCIM_PartialValue ];

/// 限制用量,即不可超过的数量,控制级别(新疆中医,药房借用)
Property DARCIMLimitQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DARCIM_LimitQty ];

/// 医嘱开始日期时间是否可修改
Property DARCIMCanCrossDay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = DARCIM_CanCrossDay ];

/// 限制用量，可做提醒。极限用量强制控制，不允许超过极限用量DARCIMMaxQty
Property DARCIMWarningUseQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DARCIM_WarningUseQty ];

/// 是否只允许录入一次
Property DARCIMAllowOnlyOnce As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DARCIM_AllowOnlyOnce ];

/// 医嘱互斥类型
Property DARCIMConflictType As %Library.String(DISPLAYLIST = ",OneWay,TwoWay", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",OW,TW") [ SqlColumnNumber = 15, SqlFieldName = DARCIM_ConflictType ];

/// 长期自备自动插入取药医嘱
Property DARCIMAutoInsertONEOrd As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = DARCIM_AutoInsertONEOrd ];

/// 医嘱提示是否悬浮
Property DARCIMOrdPrompt As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DARCIM_OrdPrompt ];

/// 单月费用上限
Property DARCIMCostlimits As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 18, SqlFieldName = DARCIM_Costlimits ];

/// 单月数量上限
Property DARCIMQtylimits As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 19, SqlFieldName = DARCIM_Qtylimits ];

/// 程序自动加锁标志
Property DARCIMAutoLockFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = DARCIM_AutoLockFlag ];

/// 不可提前退费
Property DARCIMNoAHRefund As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = DARCIM_NoAHRefund ];

/// 免费药标识
Property DARCIMFreeDrugFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = DARCIM_FreeDrugFlag ];

/// 同频次不同剂量标识
Property DARCIMSameFreqDifferentDosesFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = DARCIM_SameFreqDifferentDosesFlag ];

/// 开医嘱可选择库存项
Property DARCIMOeOrdIsSelectInci As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = DARCIM_OeOrdIsSelectInci ];

/// 开医嘱可选择库存项
Property DARCIMCustomDescOrd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = DARCIM_CustomDescOrd ];

/// 开医嘱日期时间是否可修改
Property DARCIMOrdDateCanCrossDay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = DARCIM_OrdDateCanCrossDay ];

/// 检验医嘱同一天可允许开立多次
Property DARCIMLabOrdDayAllowRepeat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = DARCIM_LabOrdDayAllowRepeat ];

/// 计入不记出医嘱标识
Property DARCIMCountInButNotOutFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = DARCIM_CountInButNotOutFlag ];

/// 计入不记出医嘱-无频次长嘱滚动默认开始时间
Property DARCIMCountInButNotOutIPLongOrdRollSttTime As %Library.String [ SqlColumnNumber = 29, SqlFieldName = DARCIM_CountInButNotOutIPLongOrdRollSttTime ];

/// 允许录入小数的草药，要求库存项基本单位和门诊发药单位、住院整包装单位必须一致时才能启用该配置
Property DARCIMCMAllowEntryDecimal As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = DARCIM_CMAllowEntryDecimal ];

/// 检查检验不控制数量
Property DARCIMNotLimitQty As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = DARCIM_NotLimitQty ];

/// 按该医嘱开始日期停止长期医嘱
Property DARCIMStopAfterLongOrder As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = DARCIM_StopAfterLongOrder ];

/// 默认开始日期
Property DARCIMStopDefSttDateDay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DARCIM_StopDefSttDateDay ];

/// 默认开始时间
Property DARCIMStopDefSttTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DARCIM_StopDefSttTime ];

/// 不能被自动停止的长期费用医嘱
Property DARCIMNotAutoStop As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = DARCIM_NotAutoStop ];

/// 允许该医嘱开长期(适用配置自动停所有长期后转科/术后/重整等非出院医嘱需开立成长期的项目)
Property DARCIMAllowLongOrder As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = DARCIM_AllowLongOrder ];

/// 一次就诊是否只允许录入一次
Property DARCIMAdmAllowOnlyOnce As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = DARCIM_AdmAllowOnlyOnce ];

/// 重复医嘱判断天数
Property DARCIMRepeatCheckDays As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = DARCIM_RepeatCheckDays ];

/*
Actual原始值(没有任何偏好,即按照实际填写的单次剂量进行累加计算),
Half 偏好取半(即不足一半取半,足够一半取整),
FullDown 偏好向下取整(即不为整数则向下取整，最小值不低于1),
FullUp 偏好向上取整(即不为整数则向上取整)
门诊或出院带药在转为整包装数时均会向上取整
*/
/// 门诊单次剂量的计算偏好值：
Property DARCIMOPPartialValue As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Actual,Half,FullDown,FullUp", MAXLEN = 30, VALUELIST = ",A,H,FD,FU") [ SqlColumnNumber = 39, SqlFieldName = DARCIM_OPPartialValue ];

/// 医嘱项关联专科表单代码
Property DARCIMSpecLocDiag As %Library.String [ SqlColumnNumber = 40, SqlFieldName = DARCIM_SpecLocDiag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCItmMast(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DARCIM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DARCIM_AdmAllowOnlyOnce">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DARCIM_AlertStockQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DARCIM_AllowLongOrder">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DARCIM_AllowOnlyOnce">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DARCIM_AutoInsertONEOrd">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DARCIM_AutoLockFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DARCIM_CMAllowEntryDecimal">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DARCIM_CanCrossDay">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DARCIM_ConflictType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DARCIM_Costlimits">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DARCIM_CountInButNotOutFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DARCIM_CountInButNotOutIPLongOrdRollSttTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DARCIM_CustomDescOrd">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DARCIM_FreeDrugFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DARCIM_IPNeedBillQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DARCIM_LabOrdDayAllowRepeat">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DARCIM_LimitQty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DARCIM_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DARCIM_MinQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DARCIM_NeedSkinTest">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DARCIM_NoAHRefund">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DARCIM_NotAutoStop">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DARCIM_NotLimitQty">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DARCIM_OPPartialValue">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DARCIM_OeOrdIsSelectInci">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DARCIM_OrdDateCanCrossDay">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DARCIM_OrdPrompt">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DARCIM_PartialValue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DARCIM_Qtylimits">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DARCIM_RepeatCheckDays">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DARCIM_RequireNote">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DARCIM_SameFreqDifferentDosesFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DARCIM_ShowOEMessage">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DARCIM_SpecLocDiag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DARCIM_StopAfterLongOrder">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DARCIM_StopDefSttDateDay">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DARCIM_StopDefSttTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DARCIM_WarningUseQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCItmMast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DARCIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DARCIM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^DHCItmMast</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DARCIM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DARCIM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DARCIM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmMastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
