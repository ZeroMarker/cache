Class User.DHCIncReservedQtyDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCRQD_RowID, SqlTableName = DHC_IncReservedQtyDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 科室库存项
Property INCRQDIncilDr As User.INCItmLoc [ SqlColumnNumber = 2, SqlFieldName = INCRQD_Incil_Dr ];

/// 类型(1-开医嘱DHCOEDispensing,2-停医嘱DHCOEDispensing，3-发药DHCOEDispensing,4-清在途数,5-欠药DHCOEDispensing，6-欠药退药DHCOEDispensing)
Property INCRQDType As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INCRQD_Type ];

/// 在途数
Property INCRQDQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = INCRQD_Qty ];

/// 科室库存批次ID
Property INCRQDInclbDr As User.INCItmLcBt [ SqlColumnNumber = 5, SqlFieldName = INCRQD_Inclb_Dr ];

/// 指向表ID(与Type对应),各类型均指向打包子表
Property INCRQDPointer As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INCRQD_Pointer ];

/// 日期
Property INCRQDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = INCRQD_Date ];

/// 时间
Property INCRQDTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = INCRQD_Time ];

/// 科室ID
Property INCRQDCtlocDr As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = INCRQD_Ctloc_Dr ];

/// 本次处理在途数之后总的在途数
Property INCRQDILQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INCRQD_ILQty ];

/// 是否做了清除处理
Property INCRQDClrFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = INCRQD_ClrFlag ];

/// 操作人ID
Property INCRQDSSUSRDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = INCRQD_SSUSR_Dr ];

/// Descript: 	新增在途记录
/// Creater：	zhouyg
/// CreateDate：2016-08-26
/// Input：		SqlStr=inc_itmloc的ID^类型^在途数^inc_itmlcbt的ID^指向表ID^科室ID
/// Return：	>0，记录ID;<0，错误	
/// s SqlStr=
ClassMethod Insert(SqlStr As %String) As %Library.String
{
	n (SqlStr)
	s Err=0
	s incilID=$p(SqlStr,"^",1)
	q:incilID="" -1
	s inci=$p(incilID,"||",1)
	s ilSub=$p(incilID,"||",2)
	q:(inci="")!(ilSub="") -1
	s ctrlFlag="N"
	s type=$p(SqlStr,"^",2)
	s pointer=$p(SqlStr,"^",5)
	i (type'="1")&&(type'="5") s ctrlFlag="Y"	// 使清除任务的索引尽量少数据
	s ilQty=+$p($g(^INCI(inci,"IL",ilSub)),"^",10)
	k PLIST
	s PLIST(2)=incilID
	s PLIST(3)=type
	s PLIST(4)=+$p(SqlStr,"^",3)
	s PLIST(5)=$p(SqlStr,"^",4)
	s PLIST(6)=pointer
	s PLIST(7)=$p($h,",",1)
	s PLIST(8)=$p($h,",",2)
	s PLIST(9)=$p(SqlStr,"^",6)
	s PLIST(10)=ilQty
	s PLIST(11)=ctrlFlag
	&SQL(Insert Into DHC_IncReservedQtyDetail values :PLIST())
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_IncReservedQtyDetail",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-100
	q:SQLCODE'=0 Err
	s RetID=$p($g(%ROWID),$c(1))
	q RetID
}

/// Descript: 	清除在途数时按日期对当天的在途做标记
/// Creater：	zhouyg
/// CreateDate：2017-02-21
/// Input：		inc_itmloc的ID,日期
/// Return：	>0，记录ID;<0，错误	
/// s SqlStr=
ClassMethod UpdateClrFlag(incilID As %String, Dah As %String) As %Library.String
{
	n (incilID,Dah)
	s ClrFlagN="N"
	&SQL(Update DHC_IncReservedQtyDetail set INCRQD_ClrFlag="Y" where INCRQD_Date=:Dah and INCRQD_ClrFlag=:ClrFlagN and INCRQD_Incil_Dr=:incilID )
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateClrFlag:DHC_IncReservedQtyDetail",incilID_"^"_Dah,SQLCODE_":"_$g(%msg))
    .s Err=-100
	q:SQLCODE'=0 Err
	s RetID=$p($g(%ROWID),$c(1))
	q RetID
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTINCRQD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INCRQD_ClrFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCRQD_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCRQD_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCRQD_ILQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCRQD_Incil_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCRQD_Inclb_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCRQD_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCRQD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCRQD_SSUSR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCRQD_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCRQD_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSTINCRQD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INCRQD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateFlagIncil">
<Global>^DHCSTINCRQDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DateFlagIncil"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCRQD_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCRQD_ClrFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCRQD_Incil_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCRQD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateIncil">
<Global>^DHCSTINCRQDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DateIncil"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCRQD_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCRQD_Incil_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCRQD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateInclb">
<Global>^DHCSTINCRQDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DateInclb"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCRQD_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCRQD_Inclb_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCRQD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIncilDate">
<Global>^DHCSTINCRQDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IncilDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCRQD_Incil_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCRQD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCRQD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIncilFlagTypeDate">
<Global>^DHCSTINCRQDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IncilFlagTypeDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCRQD_Incil_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCRQD_ClrFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCRQD_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCRQD_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCRQD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCSTINCRQDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCRQD_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCRQD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCRQD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCSTINCRQDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCRQD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCRQD_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCRQD_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCRQD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCRQD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCIncReservedQtyDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTINCRQD)
	s oldI = +$g(^mdata("DHCIncReservedQtyDetail"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTINCRQD = maxI
	s ^mdata("DHCIncReservedQtyDetail") = maxI
}

}
