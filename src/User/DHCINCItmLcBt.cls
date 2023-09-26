Class User.DHCINCItmLcBt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCLB_RowId, SqlTableName = DHC_INCItmLcBt, StorageStrategy = SQLStorage ]
{

/// w ##Class(User.DHCINCItmLcBt).%BuildIndices()
Parameter EXTENTSIZE = 250;

/// INCLB_LB_DR
Property INCLBLBDR As User.INCItmLcBt [ Required, SqlColumnNumber = 2, SqlFieldName = INCLB_LB_DR ];

/// INCLB_Active(控制开医嘱)
Property INCLBActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 3, SqlFieldName = INCLB_Active ];

/// INCLB_CTLOC_DR
Property INCLBCTLOCDR As User.CTLoc [ SqlColumnNumber = 4, SqlComputeCode = { i '$d(^INCI(+{INCLB_LB_DR},"IL",+$P({INCLB_LB_DR},"||",2))) s {INCLB_CTLOC_DR}="" q
 s {INCLB_CTLOC_DR}=$P($G(^INCI(+{INCLB_LB_DR},"IL",+$P({INCLB_LB_DR},"||",2))),"^",1)
}, SqlComputed, SqlFieldName = INCLB_CTLOC_DR, Transient ];

/// 医嘱占用数(批次价格使用)
Property INCLBReservedQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = INCLB_ReservedQty ];

/// INCLB_STKActive(控制库存业务)
Property INCLBSTKActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = INCLB_STKActive ];

/// INCLB_Backup(备用字段)
Property INCLBBackup As %Library.String [ SqlColumnNumber = 7, SqlFieldName = INCLB_Backup ];

/// INCLB_LockUser_Dr
Property INCLBLockUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = INCLB_LockUser_Dr ];

/// INCLB_LockDate
Property INCLBLockDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 9, SqlFieldName = INCLB_LockDate ];

/// INCLB_LockTime
Property INCLBLockTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = INCLB_LockTime ];

/// 手工冻结库存数量
Property INCLBFreezeQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INCLB_FreezeQty ];

/// 加锁原因
Property INCLBLockReason As %Library.String [ SqlColumnNumber = 12, SqlFieldName = INCLB_LockReason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINCLB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INCLB_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCLB_Backup">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCLB_FreezeQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCLB_LB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCLB_LockDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCLB_LockReason">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCLB_LockTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCLB_LockUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCLB_ReservedQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCLB_STKActive">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINCLB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCLB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INCLB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCINCLB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCLB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCLB_Active}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INCLB_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCLB_LB_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INCLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBtActive">
<Global>^DHCINCLBi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ACIBT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCLB_Active}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCLB_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$p({INCLB_LB_DR},"||")</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCLB_LB_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBtStkActive">
<Global>^DHCINCLBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ACISTKBT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCLB_STKActive}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCLB_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$p({INCLB_LB_DR},"||")</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCLB_LB_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCLB">
<Condition>{INCLB_LB_DR}'=""</Condition>
<ConditionFields>INCLB_LB_DR</ConditionFields>
<Global>^DHCINCLB</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCLB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCLB_LB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStkActive">
<Global>^DHCINCLBi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ACSTK"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCLB_STKActive}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCLB_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCLB_LB_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINCItmLcBtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINCLB)
	s oldI = +$g(^mdata("DHCINCITMLCBT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINCLB = maxI
	s ^mdata("DHCINCITMLCBT") = maxI
}

}
