Class User.OEOrdExecExt Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = OEORE_RowId, SqlTableName = OE_OrdExecExt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OEOREChildsub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to OEORI
Relationship OEOREOEORIParRef As OEOrdItemExt [ Cardinality = parent, Inverse = ChildOEOrdExec, Required, SqlFieldName = OEORE_OEORI_ParRef ];

Relationship ChildOEOrdExecFreeCharge As User.OEOrdExecFreeCharge [ Cardinality = children, Inverse = FCCHParRef ];

Relationship ChildOEOrdExecOrdStatus As User.OEOrdExecOrdStatus [ Cardinality = children, Inverse = OSCHParRef ];

/// OEORE Child Sub (New Key)
Property OEOREChildsub As %Numeric(SCALE = 0) [ SqlColumnNumber = 2, SqlFieldName = OEORE_Childsub ];

/// 打印标记 执行单，输液卡
Property OEOREPrinted As %String [ SqlColumnNumber = 3, SqlFieldName = OEORE_Printed ];

/// 执行单打印日期
Property OEOREPrintDate As %Date [ SqlColumnNumber = 4, SqlFieldName = OEORE_PrintDate ];

/// 执行单打印时间
Property OEOREPrintTime As %Time [ SqlColumnNumber = 5, SqlFieldName = OEORE_PrintTime ];

/// 执行单打印人
Property OEOREPrintUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = OEORE_PrintUser_DR ];

/// 病人当前所在科室
Property OEORECTLOCDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = OEORE_CTLOC_DR ];

/// 病人当前所在科室
Property OEOREWardDR As User.PACWard [ SqlColumnNumber = 8, SqlFieldName = OEORE_Ward_DR ];

/// 单据代码
Property OEOREQueryCode As %String [ SqlColumnNumber = 9, SqlFieldName = OEORE_QueryCode ];

/// 护士专业组   ???
Property OEOREGroup As %String [ SqlColumnNumber = 10, SqlFieldName = OEORE_Group ];

/// 输液座位号
Property OEORESeatNo As %String [ SqlColumnNumber = 11, SqlFieldName = OEORE_SeatNo ];

/// 采血人
Property OEORESpecCollUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = OEORE_SpecCollUser_DR ];

/// 采血日期
Property OEORESpecCollDate As %Date [ SqlColumnNumber = 13, SqlFieldName = OEORE_SpecCollDate ];

/// 采血时间
Property OEORESpecCollTime As %Time [ SqlColumnNumber = 14, SqlFieldName = OEORE_SpecCollTime ];

/// 置皮试医护人员指针
Property OEORESkinTestCTCPDR As User.CTCareProv [ SqlColumnNumber = 15, SqlFieldName = OEORE_SkinTestCTCP_DR ];

/// 置皮试结果日期
Property OEORESkinTestDate As %Date [ SqlColumnNumber = 16, SqlFieldName = OEORE_SkinTestDate ];

/// 置皮试结果时间
Property OEORESkinTestTime As %Time [ SqlColumnNumber = 17, SqlFieldName = OEORE_SkinTestTime ];

/// 皮试结果审核人
Property OEORESkinTestAuditCTCPDR As User.CTCareProv [ SqlColumnNumber = 18, SqlFieldName = OEORE_SkinTestAuditCTCP_DR ];

/// 皮试结果审核日期
Property OEORESkinTestAuditDate As %Date [ SqlColumnNumber = 19, SqlFieldName = OEORE_SkinTestAuditDate ];

/// 皮试结果审核时间
Property OEORESkinTestAuditTime As %Time [ SqlColumnNumber = 20, SqlFieldName = OEORE_SkinTestAuditTime ];

/// 过敏表指针
Property OEOREPAALGDR As User.PAAllergy [ SqlColumnNumber = 21, SqlFieldName = OEORE_PAALG_DR ];

/// 执行记录类型,   ST:皮试
Property OEOREType As %String [ SqlColumnNumber = 22, SqlFieldName = OEORE_Type ];

/// 执行记录加锁护士
Property OEORELockUserDR As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = OEORE_LockUser_DR ];

/// 执行记录加锁日期
Property OEORELockDate As %Date [ SqlColumnNumber = 24, SqlFieldName = OEORE_LockDate ];

/// 执行记录加锁时间
Property OEORELockTime As %Time [ SqlColumnNumber = 25, SqlFieldName = OEORE_LockTime ];

/// 以下是计费使用的字段
/// 医嘱执行状态  用于医嘱执行后计费和判断重新计费的条件
Property OEOREOrderStatusDR As OECOrderStatus [ SqlColumnNumber = 30, SqlFieldName = OEORE_OrderStatus_DR ];

/// 账单指针
Property OEOREPBODR As User.DHCPatBillOrder [ SqlColumnNumber = 31, SqlFieldName = OEORE_PBO_DR ];

/// 关联执行记录指针
Property OEOREOEOREDR As User.OEOrdExec [ SqlColumnNumber = 32, SqlFieldName = OEORE_OEORE_DR ];

/// 小时医嘱开始时间
Property OEOREHourOrderStartTime As %Time [ SqlColumnNumber = 33, SqlFieldName = OEORE_HourOrderStartTime ];

/// 小时医嘱停止时间
Property OEOREHourOrderEndTime As %Time [ SqlColumnNumber = 34, SqlFieldName = OEORE_HourOrderEndTime ];

/// 记账/医保审核状态
Property OEOREApproved As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = OEORE_Approved ];

/// 记账/医保审核人
Property OEOREApprovedUserDR As User.SSUser [ SqlColumnNumber = 36, SqlFieldName = OEORE_ApprovedUser_DR ];

/// 记账/医保审核日期
Property OEOREApprovedDate As %Date [ SqlColumnNumber = 37, SqlFieldName = OEORE_ApprovedDate ];

/// 记账/医保审核时间
Property OEOREApprovedTime As %Time [ SqlColumnNumber = 38, SqlFieldName = OEORE_ApprovedTime ];

/// 记账审核比例
Property OEOREApprovedPercent As %String [ SqlColumnNumber = 39, SqlFieldName = OEORE_ApprovedPercent ];

/// 记账审核限额
Property OEOREApprovedLimit As %String [ SqlColumnNumber = 40, SqlFieldName = OEORE_ApprovedLimit ];

/// 记账审核类型  1:修改比例了  2:国产限价
Property OEOREApprovedFlag As %String [ SqlColumnNumber = 41, SqlFieldName = OEORE_ApprovedFlag ];

/// 医保需审类型  1:医保特病  2:医保处方超限  3:特殊药品  4:特殊材料
Property OEOREApproveType As %String [ SqlColumnNumber = 42, SqlFieldName = OEORE_ApproveType ];

/// 财务审核标志  
Property OEOREConfirmFlag As %String [ SqlColumnNumber = 43, SqlFieldName = OEORE_ConfirmFlag ];

/// 财务审核日期
Property OEOREConfirmDate As %Date [ SqlColumnNumber = 44, SqlFieldName = OEORE_ConfirmDate ];

/// 财务审核时间
Property OEOREConfirmTime As %Time [ SqlColumnNumber = 45, SqlFieldName = OEORE_ConfirmTime ];

/// 财务审核人
Property OEOREConfirmUserDR As %String [ SqlColumnNumber = 46, SqlFieldName = OEORE_ConfirmUser_DR ];

/// 免费标志
Property OEOREFreeChargeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = OEORE_FreeChargeFlag ];

/// 可计费标志(持续性医嘱计费用,帐单程序优先判断此标志决定是否可以计费)
Property OEOREBlillFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = OEORE_BlillFlag ];

/// 费别
Property OEOREBillType As User.PACAdmReason [ SqlColumnNumber = 49, SqlFieldName = OEORE_BillType ];

/// 运送日期
Property OEOREShipDate As %Date [ SqlColumnNumber = 50, SqlFieldName = OEORE_ShipDate ];

/// 运送时间
Property OEOREShipTime As %Time [ SqlColumnNumber = 51, SqlFieldName = OEORE_ShipTime ];

/// 产生执行记录后,程序调用错误标识,使用场景:执行记录插入成功后,调用了例如批次价,材料减库存等接口,如果失败则记录为Y
Property OEOREGenAfterErrFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = OEORE_GenAfterErrFlag ];

/// 产生执行记录后,程序调用错误描述
Property OEOREGenAfterErrDesc As %String(MAXLEN = 255) [ SqlColumnNumber = 53, SqlFieldName = OEORE_GenAfterErrDesc ];

/// 执行医嘱的终端设备类型  1:个人电脑(PC)  2:个人数字助理(PDA)
Property OEOREDeviceType As %String [ SqlColumnNumber = 54, SqlFieldName = OEORE_DeviceType ];

/// 申请登记日期(现用于多部位检查登记,)
Property OEOREOrderStatusDate As %Date [ SqlColumnNumber = 55, SqlFieldName = OEORE_OrderStatusDate ];

/// 申请登记时间
Property OEOREOrderStatusTime As %Time [ SqlColumnNumber = 56, SqlFieldName = OEORE_OrderStatusTime ];

/// 皮试医嘱批号(置皮试结果时保存的药品批号)
Property OEORESkinBatch As %String [ SqlColumnNumber = 57, SqlFieldName = OEORE_SkinBatch ];

/// 皮试开始日期
Property OEORESkinStDate As %Date [ SqlColumnNumber = 58, SqlFieldName = OEORE_SkinStDate ];

/// 皮试开始时间
Property OEORESkinStTime As %Time [ SqlColumnNumber = 59, SqlFieldName = OEORE_SkinStTime ];

/// 执行人当前所在科室
Property OEOREUserCTLOCDR As User.CTLoc [ SqlColumnNumber = 60, SqlFieldName = OEORE_User_CTLOCDR ];

/// 执行人当前所在病区
Property OEOREUserWardDR As User.PACWard [ SqlColumnNumber = 61, SqlFieldName = OEORE_User_Ward_DR ];

/// 执行记录核对人
Property OEORECheckUserDR As User.SSUser [ SqlColumnNumber = 62, SqlFieldName = OEORE_CheckUser_DR ];

/// 执行记录核对日期
Property OEORECheckDate As %Date [ SqlColumnNumber = 63, SqlFieldName = OEORE_CheckDate ];

/// 执行记录核对时间
Property OEORECheckTime As %Time [ SqlColumnNumber = 64, SqlFieldName = OEORE_CheckTime ];

/// 住院医嘱所在费用套餐编号(计费用),对应User.OEOrdItemExt表中的OEORIPkgOrderNo
Property OEOREPkgOrderNo As %String [ SqlColumnNumber = 65, SqlFieldName = OEORE_PkgOrderNo ];

/// 取消登记日期(现用于多部位检查登记,)
Property OEOREOrderStatusCancelDate As %Date [ SqlColumnNumber = 66, SqlFieldName = OEORE_OrderStatusCancelDate ];

/// 取消登记时间
Property OEOREOrderStatusCancelTime As %Time [ SqlColumnNumber = 67, SqlFieldName = OEORE_OrderStatusCancelTime ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexOEORE">
<Global>^OEORDi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_OrdItemExt.OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItemExt.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_OEORE_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_OrdItemExt.OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItemExt.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShipDate">
<Global>^OEORDi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SHIPDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_ShipDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_OrdItemExt.OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItemExt.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecCollDate">
<Global>^OEORDi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_OrdItemExt.OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItemExt.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SPECCOLLDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_SpecCollDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_OrdItemExt.OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItemExt.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="OEORE_ApproveType">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORE_Approved">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORE_ApprovedDate">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORE_ApprovedFlag">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORE_ApprovedLimit">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORE_ApprovedPercent">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORE_ApprovedTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORE_ApprovedUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORE_BillType">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORE_BlillFlag">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORE_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORE_CheckDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>33</Piece>
</Data>
<Data name="OEORE_CheckTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>34</Piece>
</Data>
<Data name="OEORE_CheckUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>32</Piece>
</Data>
<Data name="OEORE_ConfirmDate">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORE_ConfirmFlag">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORE_ConfirmTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORE_ConfirmUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORE_DeviceType">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>26</Piece>
</Data>
<Data name="OEORE_FreeChargeFlag">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORE_GenAfterErrDesc">
<Delimiter>"^"</Delimiter>
<Node>"ERR"</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORE_GenAfterErrFlag">
<Delimiter>"^"</Delimiter>
<Node>"ERR"</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORE_Group">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORE_HourOrderEndTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORE_HourOrderStartTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORE_LockDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORE_LockTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>23</Piece>
</Data>
<Data name="OEORE_LockUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORE_OEORE_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORE_OrderStatusCancelDate">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>24</Piece>
</Data>
<Data name="OEORE_OrderStatusCancelTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>25</Piece>
</Data>
<Data name="OEORE_OrderStatusDate">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORE_OrderStatusTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORE_OrderStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORE_PAALG_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORE_PBO_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORE_PkgOrderNo">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>23</Piece>
</Data>
<Data name="OEORE_PrintDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORE_PrintTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORE_PrintUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORE_Printed">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORE_QueryCode">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORE_SeatNo">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORE_ShipDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>24</Piece>
</Data>
<Data name="OEORE_ShipTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>25</Piece>
</Data>
<Data name="OEORE_SkinBatch">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>27</Piece>
</Data>
<Data name="OEORE_SkinStDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>28</Piece>
</Data>
<Data name="OEORE_SkinStTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>29</Piece>
</Data>
<Data name="OEORE_SkinTestAuditCTCP_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORE_SkinTestAuditDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORE_SkinTestAuditTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORE_SkinTestCTCP_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORE_SkinTestDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORE_SkinTestTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORE_SpecCollDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORE_SpecCollTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORE_SpecCollUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORE_Type">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORE_User_CTLOCDR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>30</Piece>
</Data>
<Data name="OEORE_User_Ward_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>31</Piece>
</Data>
<Data name="OEORE_Ward_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>6</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_OrdItemExt.OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItemExt.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OE_OrdItemExt.OEORI_OEORD_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItemExt.OEORI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>"X"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEORE_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdExecExtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
