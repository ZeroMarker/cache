/// OE Order Executable     (OEORE,123)
Class User.OEOrdExec Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OE_OrdExec, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OEOREChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOEDispensing As OEDispensing [ Cardinality = children, Inverse = DSPOEOREParRef ];

Relationship ChildOEOrdExecStatus As OEOrdExecStatus [ Cardinality = children, Inverse = STCHParRef ];

/// Des Ref to OEORI
Relationship OEOREOEORIParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdExec, Required, SqlFieldName = OEORE_OEORI_ParRef ];

/// OEORE Child Sub (New Key)
/// Property OEOREChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$$DEF02^at123(initvalue)}, Required, SqlColumnNumber = 2, SqlFieldName = OEORE_Childsub ];
Property OEOREChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD(+$s($d(initvalue):initvalue,1:%d(0)),"I",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"X",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OEORE_Childsub ];

/// Quantity Ordered
Property OEOREPhQtyOrd As %Float [ SqlColumnNumber = 16, SqlFieldName = OEORE_PhQtyOrd ];

/// Cross Out Date
Property OEOREXDate As %Date [ SqlColumnNumber = 25, SqlFieldName = OEORE_XDate ];

/// Execute Start Date
Property OEOREExStDate As %Date [ SqlColumnNumber = 26, SqlFieldName = OEORE_ExStDate ];

/// Execute Start Time
Property OEOREExStTime As %Time [ SqlColumnNumber = 27, SqlFieldName = OEORE_ExStTime ];

/// Start Date Time
Property OEOREStDateTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlComputeCode = { s {OEORE_StDateTime}={OEORE_ExStDate}_"Z"_{OEORE_ExStTime}
}, SqlComputed, SqlFieldName = OEORE_StDateTime, Transient ];

/// Cross Out Time
Property OEOREXTime As %Time [ SqlColumnNumber = 36, SqlFieldName = OEORE_XTime ];

/// Des Ref to CTPCP
Property OEORECTPCPDR As CTCareProv [ SqlColumnNumber = 37, SqlFieldName = OEORE_CTPCP_DR ];

/// Order Status Des Ref to OECOrdStat
Property OEOREOrderStatusDR As OECOrderAdminStatus [ SqlColumnNumber = 40, SqlFieldName = OEORE_Order_Status_DR ];

/// Ph Qty Issued
Property OEOREPhQtyIss As %Float [ SqlColumnNumber = 41, SqlComputeCode = { s {OEORE_PhQtyIss}=$$CO41^at123({OEORE_RowId})
}, SqlComputed, SqlFieldName = OEORE_PhQtyIss, Transient ];

/// Quantity Administered
Property OEOREQtyAdmin As %Float [ SqlColumnNumber = 42, SqlFieldName = OEORE_QtyAdmin ];

/// OEORE_Billed Flag
Property OEOREBilled As %String(DISPLAYLIST = ",Billed,To Bill,Ignore,Refunded,Paid", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",B,TB,I,R,P") [ InitialExpression = {$$DEF43^at123($s($d(initvalue):initvalue,1:%d(0)))}, SqlColumnNumber = 43, SqlFieldName = OEORE_Billed ];

/// Des Ref CTUOM
Property OEORECTUOMDR As CTUOM [ SqlColumnNumber = 44, SqlFieldName = OEORE_CTUOM_DR ];

/// Des Ref RVIBC
Property OEORERVIBCDR As RVIInsCoBillCharges [ SqlColumnNumber = 45, SqlFieldName = OEORE_RVIBC_DR ];

/// Date Executed
Property OEOREDateExecuted As %Date [ SqlColumnNumber = 46, SqlFieldName = OEORE_DateExecuted ];

/// Time Executed
Property OEORETimeExecuted As %Time [ SqlColumnNumber = 47, SqlFieldName = OEORE_TimeExecuted ];

/// Short Description
Property OEOREDesc As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = OEORE_Desc ];

/// Signature
Property OEORESignature As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = OEORE_Signature ];

/// Signature File
Property OEORESignFile As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = OEORE_SignFile ];

/// PrimaryIntervention
Property OEOREPrimaryIntervention As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = OEORE_PrimaryIntervention ];

/// Des Ref Appt
Property OEOREApptDR As RBAppointment [ SqlColumnNumber = 52, SqlFieldName = OEORE_Appt_DR ];

/// Time Taken
Property OEORETimeTaken As %Float [ SqlColumnNumber = 53, SqlFieldName = OEORE_TimeTaken ];

/// Des Ref Outcome
Property OEOREOutcomeDR As MRCClinPathOutcome [ SqlColumnNumber = 54, SqlFieldName = OEORE_Outcome_DR ];

/// Des Ref Route
Property OEORERouteDR As OECRoute [ SqlColumnNumber = 55, SqlFieldName = OEORE_Route_DR ];

/// StockBatches
Property OEOREStockBatches As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = OEORE_StockBatches ];

/// Des Ref OverseeUser
Property OEOREOverseeUserDR As SSUser [ SqlColumnNumber = 57, SqlFieldName = OEORE_OverseeUser_DR ];

/// PRNReason
Property OEOREPRNReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 58, SqlFieldName = OEORE_PRNReason ];

/// Des Ref AltRecLoc
Property OEOREAltRecLocDR As CTLoc [ SqlColumnNumber = 59, SqlFieldName = OEORE_AltRecLoc_DR ];

/// Des Ref Dispensing
Property OEOREDispensingDR As OEDispensing [ SqlColumnNumber = 60, SqlFieldName = OEORE_Dispensing_DR ];

/// Des Ref AdminRoute
Property OEOREAdminRouteDR As PHCAdministrationRoute [ SqlColumnNumber = 61, SqlFieldName = OEORE_AdminRoute_DR ];

/// ExVol
Property OEOREExVol As %Float [ SqlColumnNumber = 62, SqlFieldName = OEORE_ExVol ];

/// ExEnDate
Property OEOREExEnDate As %Date [ SqlColumnNumber = 63, SqlFieldName = OEORE_ExEnDate ];

/// ExEnTime
Property OEOREExEnTime As %Time [ SqlColumnNumber = 64, SqlFieldName = OEORE_ExEnTime ];

/// PrevAdminEndDate
Property OEOREPrevAdminEndDate As %Date [ SqlColumnNumber = 65, SqlFieldName = OEORE_PrevAdminEndDate ];

/// PrevAdminEndTime
Property OEOREPrevAdminEndTime As %Time [ SqlColumnNumber = 66, SqlFieldName = OEORE_PrevAdminEndTime ];

/// Des Ref MedOutcome
Property OEOREMedOutcomeDR As PACMedicationOutcome [ SqlColumnNumber = 67, SqlFieldName = OEORE_MedOutcome_DR ];

/// Des Ref CTPCPStarted
Property OEORECTPCPStartedDR As CTCareProv [ SqlColumnNumber = 68, SqlFieldName = OEORE_CTPCPStarted_DR ];

/// PrevBagVolume
Property OEOREPrevBagVolume As %Float [ SqlColumnNumber = 69, SqlFieldName = OEORE_PrevBagVolume ];

/// Des Ref AlertReason
Property OEOREAlertReasonDR As OECAlertReason [ SqlColumnNumber = 70, SqlFieldName = OEORE_AlertReason_DR ];

/// Des Ref SkinTestOutcome
Property OEORESkinTestOutcomeDR As PHCSkinTestOutcome [ SqlColumnNumber = 71, SqlFieldName = OEORE_SkinTestOutcome_DR ];

/// OEORENotes 执行备注
Property OEORENotes As %String(MAXLEN = "") [ SqlColumnNumber = 72, SqlFieldName = OEORE_Notes ];

/// 保存系统日期
Property OEOREInsertDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 73, SqlFieldName = OEORE_InsertDate ];

/// 保存系统时间
Property OEOREInsertTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 74, SqlFieldName = OEORE_InsertTime ];

/// 计费日期 add by 郭荣勇 2019.01.20 
Property OEOREBillPriceDate As %Date [ SqlColumnNumber = 75, SqlFieldName = OEORE_BillPriceDate ];

/// 计费时间 add by 郭荣勇 2019.01.20
Property OEOREBillPriceTime As %Time [ SqlColumnNumber = 76, SqlFieldName = OEORE_BillPriceTime ];

/// 医保标志
Property OEORECoverMainIns As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = OEORE_CoverMainIns ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdExec).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExec","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdExec).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExec","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdExec).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExec","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdExec).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExec","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExec","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdExec).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExec","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>356156</ExtentSize>
<Property name="OEOREAdminRouteDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREAlertReasonDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREAltRecLocDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREApptDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="OEOREBilled">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="OEORECTPCPDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="OEORECTPCPStartedDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEORECTUOMDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OEOREChildsub">
<Selectivity>0.1737%</Selectivity>
</Property>
<Property name="OEOREDateExecuted">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="OEOREDesc">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREDispensingDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREExEnDate">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREExEnTime">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREExStDate">
<Selectivity>0.1708%</Selectivity>
</Property>
<Property name="OEOREExStTime">
<Selectivity>2.6316%</Selectivity>
</Property>
<Property name="OEOREExVol">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREMedOutcomeDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREOEORIParRef">
<Selectivity>0.0395%</Selectivity>
</Property>
<Property name="OEOREOrderStatusDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="OEOREOutcomeDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREOverseeUserDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREPRNReason">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREPhQtyIss">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="OEOREPhQtyOrd">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="OEOREPrevAdminEndDate">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREPrevAdminEndTime">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OEOREPrevBagVolume">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREPrimaryIntervention">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OEOREQtyAdmin">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="OEORERVIBCDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEORERouteDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OEORESignFile">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEORESignature">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEORESkinTestOutcomeDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREStDateTime">
<Selectivity>0.0716%</Selectivity>
</Property>
<Property name="OEOREStockBatches">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OEORETimeExecuted">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="OEORETimeTaken">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREXDate">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="OEOREXTime">
<Selectivity>99.9993%</Selectivity>
</Property>
<SQLMap name="IndexARCIM">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$P($G(^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub},1)),"^",2)</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppoint">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Appt1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_Appt_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillPriceDat">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillPDat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_BillPriceDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateExec">
<Global>^OEORDi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateExec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{OEORE_ExStTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateExecute">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateExecute"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_DateExecuted}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTime">
<Global>^OEORDi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORE_ExStTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotExec">
<Condition>'{OEORE_Order_Status_DR}</Condition>
<ConditionFields>OEORE_Order_Status_DR,OEORE_ExStDate,OEORE_ExStTime</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotExecE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORE_ExStTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDept">
<Condition>$P($G(^OEORD(+{OEORE_RowId},"I",$P({OEORE_RowId},"||",2),7)),"^",2)'=""</Condition>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$P($G(^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub},7)),"^",2)</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^OEORDi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecLoc">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$P($G(^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub},3)),"^",6)</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStopExec">
<Condition>{OEORE_Order_Status_DR}</Condition>
<ConditionFields>OEORE_Order_Status_DR,OEORE_XDate,OEORE_XTime</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StopExecE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORE_XDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{OEORE_XTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVol">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Vol"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORE_ExStDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORE_ExVol}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="OEOREDataMasterMap">
<Data name="OEORE_AdminRoute_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OEORE_AlertReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OEORE_AltRecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OEORE_Appt_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OEORE_BillPriceDate">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="OEORE_BillPriceTime">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="OEORE_Billed">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OEORE_CTPCPStarted_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OEORE_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OEORE_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OEORE_CoverMainIns">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="OEORE_DateExecuted">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OEORE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OEORE_Dispensing_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OEORE_ExEnDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OEORE_ExEnTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OEORE_ExStDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OEORE_ExStTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OEORE_ExVol">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OEORE_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OEORE_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="OEORE_MedOutcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OEORE_Notes">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OEORE_Order_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OEORE_Outcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OEORE_OverseeUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OEORE_PRNReason">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OEORE_PhQtyIss">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OEORE_PhQtyOrd">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OEORE_PrevAdminEndDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OEORE_PrevAdminEndTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OEORE_PrevBagVolume">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OEORE_PrimaryIntervention">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OEORE_QtyAdmin">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OEORE_RVIBC_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OEORE_Route_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OEORE_SignFile">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OEORE_Signature">
<Node>"SIGN"</Node>
</Data>
<Data name="OEORE_SkinTestOutcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="OEORE_StockBatches">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OEORE_TimeExecuted">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OEORE_TimeTaken">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OEORE_XDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OEORE_XTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OEORE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"X"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{OEORE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEORE_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdExecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
