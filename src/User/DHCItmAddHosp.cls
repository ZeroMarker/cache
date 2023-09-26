Class User.DHCItmAddHosp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IAH_ROWID, SqlTableName = DHC_ItmAddHosp, StorageStrategy = SQLStorage ]
{

/// IAH_IncItm_DR  库存项表ID
Property IAHIncItmDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = IAH_IncItm_DR ];

/// IAH_Hospital_DR  医院ID
Property IAHHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = IAH_Hospital_DR ];

/// IAH_EndDate  
Property IAHEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = IAH_EndDate ];

/// IAH_StartDate  
Property IAHStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = IAH_StartDate ];

/// Not Use Flag
Property IAHNotUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = IAH_NotUseFlag ];

/// IAH_ABC_Flag  药品ABC属性
Property IAHABCFlag As %Library.String [ SqlColumnNumber = 7, SqlFieldName = IAH_ABC_Flag ];

/// IAH_PreRec_Flag  处方购药标志
Property IAHPreRecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = IAH_PreRec_Flag ];

/// IAH_DiscRate  折扣率 
Property IAHDiscRate As %Library.String [ SqlColumnNumber = 9, SqlFieldName = IAH_DiscRate ];

/// IAH_NotUseReason_Dr   停用原因
Property IAHNotUseReasonDr As User.DHCItmNotUseReason [ SqlColumnNumber = 10, SqlFieldName = IAH_NotUseReason_Dr ];

/// IAH_TmpRecFlag  临时购药标志
Property IAHTmpRecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = IAH_TmpRecFlag ];

/// IAH_MonitorFlag  重点监控标志
Property IAHMonitorFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = IAH_MonitorFlag ];

/// IAH_LimitQty  限购数量 入库单位
Property IAHLimitQty As %Library.String [ SqlColumnNumber = 13, SqlFieldName = IAH_LimitQty ];

/// 招标供应商
Property IAHAPCVMDr As User.APCVendor [ SqlColumnNumber = 14, SqlFieldName = IAH_APCVM_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ITMADDHOP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IAH_ABC_Flag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IAH_APCVM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IAH_DiscRate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IAH_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IAH_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IAH_IncItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IAH_LimitQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IAH_MonitorFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IAH_NotUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IAH_NotUseReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IAH_PreRec_Flag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IAH_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IAH_TmpRecFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^ITMADDHOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IAH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IAH_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexHosp">
<Global>^ITMADDHOP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAH_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAH_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexHospInc">
<Global>^ITMADDHOP</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IAH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospInc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAH_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAH_IncItm_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IAH_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexInc">
<Global>^ITMADDHOP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IAH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inci"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAH_IncItm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAH_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmAddHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^ITMADDHOP)
	s oldI = +$g(^mdata("DHCITMADDHOSP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^ITMADDHOP = maxI
	s ^mdata("DHCITMADDHOSP") = maxI
}

}
