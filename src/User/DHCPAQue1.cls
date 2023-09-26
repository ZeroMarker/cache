/// Creator:tanjishan
/// CreatDate:2019-01-24
/// 草药处方扩展表
Class User.DHCPAQue1 Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCPA_Que1, StorageStrategy = SQLStorage ]
{

/// 处方费别
Property DHCQuePrescAdmReasonDr As User.PACAdmReason [ SqlColumnNumber = 2, SqlFieldName = DHCQue_PrescAdmReason_Dr ];

/// 处方类型
Property DHCQuePrescType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCQue_PrescType ];

/// 创建用户
Property DHCQueUserAddDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DHCQue_UserAdd_Dr ];

/// 创建时间
Property DHCQueCreatDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DHCQue_CreatDate ];

/// 创建时间
Property DHCQueCreatTime As %Time [ SqlColumnNumber = 6, SqlFieldName = DHCQue_CreatTime ];

/// 开始日期
Property DHCQuePrescStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DHCQue_PrescStartDate ];

/// 开始时间
Property DHCQuePrescStartTime As %Time [ SqlColumnNumber = 8, SqlFieldName = DHCQue_PrescStartTime ];

/// 处方状态
Property DHCQuePrescItemStatDR As User.OECOrderStatus [ SqlColumnNumber = 9, SqlFieldName = DHCQue_PrescItemStat_DR ];

/// 频次
Property DHCQuePrescFreqDr As User.PHCFreq [ SqlColumnNumber = 10, SqlFieldName = DHCQue_PrescFreq_Dr ];

/// 付数
Property DHCQuePrescDuratDR As User.PHCDuration [ SqlColumnNumber = 11, SqlFieldName = DHCQue_PrescDurat_DR ];

/// 用法
Property DHCQuePrescInstrDR As User.PHCInstruc [ SqlColumnNumber = 12, SqlFieldName = DHCQue_PrescInstr_DR ];

/// 接受科室
Property DHCQuePrescRecDepDR As User.CTLoc [ SqlColumnNumber = 13, SqlFieldName = DHCQue_PrescRecDep_DR ];

/// 用量
Property DHCQuePrescOrderQty As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCQue_PrescOrderQty ];

/// 用量单位
Property DHCQuePrescOrderQtyUOM As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DHCQue_PrescOrderQtyUOM ];

/// 煎药方式
Property DHCQuePrescCookMode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DHCQue_PrescCookMode ];

/// 药房用:打包方式
Property DHCQuePackMode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DHCQue_PackMode ];

/// 药房用:付数
Property DHCQuePackQty As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = DHCQue_PackQty ];

/// 停止日期
Property DHCQueXDate As %Date [ SqlColumnNumber = 19, SqlFieldName = DHCQue_XDate ];

/// 停止时间
Property DHCQueXTime As %Time [ SqlColumnNumber = 20, SqlFieldName = DHCQue_XTime ];

/// 停止用户
Property DHCQueXUserDr As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = DHCQue_XUser_Dr ];

/// 备注
Property DHCQuePrescNotes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = DHCQue_PrescNotes ];

/// 是否加急
Property DHCQuePrescEmergency As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = DHCQue_PrescEmergency ];

/// 处方诊断
Property DHCQueMRDiaRowIDS As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = DHCQue_MRDiaRowIDS ];

Property DHCQuePrescARCOSDR As User.ARCOrdSets [ SqlColumnNumber = 25, SqlFieldName = DHCQue_PrescARCOS_DR ];

/// 草药处方对应的长期医嘱
Property DHCQueAddLongOrderID As User.OEOrdItem [ SqlColumnNumber = 26, SqlFieldName = DHCQue_AddLongOrder_ID ];

/// 草药处方类型 ^DHCDocConfig("PrescTypeCharge",DHCQueCMPrescTypeCode)
Property DHCQueCMPrescTypeCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = DHCQue_CMPrescTypeCode ];

/// 新疆中医：处方配置方法
Property DHCQuePrescConfig As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = DHCQue_PrescConfig ];

/// 新疆中医：慢病表ID
Property DHCQueMBDiagnosID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = DHCQue_MBDiagnosID ];

/// 新疆中医：处方功效（解毒、一般、滋补）
Property DHCQueDrugInfo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = DHCQue_DrugInfo ];

/// 新疆中医：处方类别描述(儿、普、毒麻、急)
Property DHCQuePrescTypeInfo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DHCQue_PrescTypeInfo ];

/// 新疆中医：实际用药开始日期（今日、明日、后日）
Property DHCQueStartDateInfo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = DHCQue_StartDateInfo ];

/// 新疆中医：源处方表（复制出来的处方存储原处方）
Property DHCQuePrescDupDr As User.DHCPAQue1 [ SqlColumnNumber = 33, SqlFieldName = DHCQue_PrescDup_Dr ];

/// 新疆中医：处方名
Property DHCQuePrescName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = DHCQue_PrescName ];

/// 草药处方中的医嘱主医嘱
Property DHCQueLinkOrderItemDR As User.OEOrdItem [ SqlColumnNumber = 35, SqlFieldName = DHCQue_LinkOrderItem_DR ];

/// 新疆中医：服药方式
Property DHCQueMedicway As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = DHCQue_Medicway ];

///  用药水温
Property DHCQueMedicWater As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = DHCQue_MedicWater ];

///  取药方式
Property DHCQueTakingMedicineMethod As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = DHCQue_TakingMedicineMethod ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PAQUE1(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="DHCQue_AddLongOrder_ID">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="DHCQue_CMPrescTypeCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="DHCQue_CreatDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="DHCQue_CreatTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="DHCQue_DrugInfo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Data name="DHCQue_LinkOrderItem_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>34</Piece>
</Data>
<Data name="DHCQue_MBDiagnosID">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="DHCQue_MRDiaRowIDS">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="DHCQue_MedicWater">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>36</Piece>
</Data>
<Data name="DHCQue_Medicway">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>35</Piece>
</Data>
<Data name="DHCQue_PackMode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="DHCQue_PackQty">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="DHCQue_PrescARCOS_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="DHCQue_PrescAdmReason_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="DHCQue_PrescConfig">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="DHCQue_PrescCookMode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="DHCQue_PrescDup_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>32</Piece>
</Data>
<Data name="DHCQue_PrescDurat_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="DHCQue_PrescEmergency">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="DHCQue_PrescFreq_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="DHCQue_PrescInstr_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="DHCQue_PrescItemStat_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="DHCQue_PrescName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>33</Piece>
</Data>
<Data name="DHCQue_PrescNotes">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="DHCQue_PrescOrderQty">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="DHCQue_PrescOrderQtyUOM">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="DHCQue_PrescRecDep_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="DHCQue_PrescStartDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="DHCQue_PrescStartTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="DHCQue_PrescType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="DHCQue_PrescTypeInfo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="DHCQue_StartDateInfo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>31</Piece>
</Data>
<Data name="DHCQue_TakingMedicineMethod">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>37</Piece>
</Data>
<Data name="DHCQue_UserAdd_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="DHCQue_XDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="DHCQue_XTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="DHCQue_XUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Global>^PAQUE1</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCQUE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCQUE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAddLongOrder">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCQUE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DHCPAQue"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AddLongOrderID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCQue_AddLongOrder_ID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCQUE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkOrderItem">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCQUE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DHCPAQue"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LinkOrderItem"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCQue_LinkOrderItem_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCQUE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCQUE_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPAQue1S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
