Class User.DHCSTCtLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCLoc_RowID, SqlTableName = DHCST_CtLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCLoc_Ctloc_dr
Property DHCLocCtlocdr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DHCLoc_Ctloc_dr ];

/// DHCLoc_LIG_Dr
Property DHCLocLIGDr As User.DHCLocItemGrp [ SqlColumnNumber = 3, SqlFieldName = DHCLoc_LIG_Dr ];

/// DHC_StkLocGrp
Property DHCLocSLGDr As User.DHCStkLocGroup [ SqlColumnNumber = 4, SqlFieldName = DHCLoc_SLG_Dr ];

/// DHCLoc_Flag
Property DHCLocFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DHCLoc_Flag ];

/// DHCLoc_Type
Property DHCLocType As %Library.String(DISPLAYLIST = ",Drug Storehouse,In Pharmacy,Out Pharmacy,Appliance,General,Other", MAXLEN = 15, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",R,I,O,A,G,E") [ SqlColumnNumber = 6, SqlFieldName = DHCLoc_Type ];

/// DHCLoc_MainLoc_DR
Property DHCLocMainLocDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = DHCLoc_MainLoc_DR ];

/// 科室等级
Property DHCLocLevel As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCLoc_Level ];

/// DHCLoc_ReqAllItm
Property DHCLocReqAllItm As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DHCLoc_ReqAllItm ];

/// DHCLoc_Alias
Property DHCLocAlias As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCLoc_Alias ];

/// DHCLoc_BillPrtMode (缺省票据打印模式)
Property DHCLocBillPrtMode As %Library.String(MAXLEN = 2) [ SqlColumnNumber = 11, SqlFieldName = DHCLoc_BillPrtMode ];

/// DHCLoc_ReportSeq 报表中科室顺序
Property DHCReportSeq As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCLoc_ReportSeq ];

/// DHCLoc_AutoMonFlag 自动月报标志
Property DHCLocAutoMonFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DHCLoc_AutoMonFlag ];

/// DHCLoc_LimitAmt 科室领用限额
Property DHCLocLimitAmt As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 14, SqlFieldName = DHCLoc_LimitAmt ];

/// DHCLoc_Instktk 盘点锁定标志
Property DHCLocInstktk As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCLoc_Instktk ];

Property DHCLocBillPrtPrefix As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DHCLoc_BillPrtPrefix ];

/// 为空按Y处理
Property DHCLocStockControlFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 17, SqlFieldName = DHCLoc_StockControlFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLOC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCLoc_Alias">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCLoc_AutoMonFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCLoc_BillPrtMode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCLoc_BillPrtPrefix">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCLoc_Ctloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCLoc_Flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCLoc_Instktk">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCLoc_LIG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCLoc_Level">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCLoc_LimitAmt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCLoc_MainLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCLoc_ReportSeq">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCLoc_ReqAllItm">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCLoc_SLG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCLoc_StockControlFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCLoc_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCLoc_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCLoc_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCLoc_RowI</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLoc_Alias}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLoc_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^DHCLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCLoc_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLoc_Ctloc_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLoc_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLOCITEMGRP">
<Global>^DHCLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCLoc_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLoc_LIG_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLoc_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMain">
<Global>^DHCLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCLoc_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MAINLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCLoc_MainLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCLoc_Ctloc_dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHCLoc_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStkLocGrp">
<Global>^DHCLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCLoc_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SLG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLoc_SLG_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLoc_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeLoc">
<Global>^DHCLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCLoc_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPELOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLoc_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLoc_Ctloc_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCLoc_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTCtLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLOC)
	s oldI = +$g(^mdata("DHCCTLOC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLOC = maxI
	s ^mdata("DHCCTLOC") = maxI
}

}
