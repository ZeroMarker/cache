Class User.DHCHVMatBarcodeBinds Extends (%Persistent, User.Abstract) [ SqlRowIdName = HVBB_RowId, SqlTableName = DHC_HVMat_BarcodeBinds, StorageStrategy = SQLStorage ]
{

/// 高值条码
Property HVBBBarcode As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = HVBB_Barcode ];

/// 病人登记号
Property HVBBPatientNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = HVBB_PatientNo ];

/// 医嘱号
Property HVBBOrdItmStr As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HVBB_OrdItmStr ];

/// 医嘱项目代码
Property HVBBItmMastCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = HVBB_ItmMastCode ];

/// 绑定日期
Property HVBBBindDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = HVBB_BindDate ];

/// 绑定时间
Property HVBBBindTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = HVBB_BindTime ];

/// 扫描者工号
Property HVBBScaningUserName As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = HVBB_ScaningUserName ];

/// 扫描者科室
Property HVBBScaningLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = HVBB_ScaningLoc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCHVMBB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HVBB_Barcode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HVBB_BindDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HVBB_BindTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HVBB_ItmMastCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HVBB_OrdItmStr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HVBB_PatientNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HVBB_ScaningLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HVBB_ScaningUserName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCHVMBB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HVBB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{HVBB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHisOrdItmStr">
<Global>^DHCHVMBB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HVBB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HISORDITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{HVBB_OrdItmStr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{HVBB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HVBB_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatBarcodeBinds</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMBB)
	s oldI = +$g(^mdata("DHCHVMATBARCODEBINDS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMBB = maxI
	s ^mdata("DHCHVMATBARCODEBINDS") = maxI
}

}
