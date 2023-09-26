Class User.DHCSTMBCRegistration Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MBCR_Rowid, SqlTableName = DHCST_MBCRegistration, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MBCR_SoakStDate
Property MBCRSoakStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = MBCR_SoakStDate ];

/// MBCR_SoakStTime
Property MBCRSoakStTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = MBCR_SoakStTime ];

/// MBCR_SoakEnDate
Property MBCRSoakEnDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MBCR_SoakEnDate ];

/// MBCR_SoakEnTime
Property MBCRSoakEnTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = MBCR_SoakEnTime ];

/// MBCR_PlanDecStDate
Property MBCRPlanDecStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MBCR_PlanDecStDate ];

/// MBCR_PlanDecStTime
Property MBCRPlanDecStTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MBCR_PlanDecStTime ];

/// MBCR_PlanDecEnDate
Property MBCRPlanDecEnDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = MBCR_PlanDecEnDate ];

/// MBCR_PlanDecEnTime
Property MBCRPlanDecEnTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = MBCR_PlanDecEnTime ];

/// MBCR_MBC_Dr
Property MBCRMBCDr As User.DHCSTMBCCollDrug [ SqlColumnNumber = 10, SqlFieldName = MBCR_MBC_Dr ];

/// MBCR_DecPot
Property MBCRDecPot As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MBCR_DecPot ];

/// MBCR_DecWater
Property MBCRDecWater As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MBCR_DecWater ];

/// MBCR_DecRemarks
Property MBCRDecRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MBCR_DecRemarks ];

/// MBCR_RegUser_Dr
Property MBCRRegUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = MBCR_RegUser_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMBCR)</SqlIdExpression>
<SQLMap name="IndexMBCDr">
<Global>^DHCMBCR</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"MBCCollDrug"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCR_MBC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MBCR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MBCR_DecPot">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MBCR_DecRemarks">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MBCR_DecWater">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MBCR_MBC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MBCR_PlanDecEnDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MBCR_PlanDecEnTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MBCR_PlanDecStDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MBCR_PlanDecStTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MBCR_RegUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MBCR_SoakEnDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MBCR_SoakEnTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MBCR_SoakStDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MBCR_SoakStTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMBCR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MBCR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MBCR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MBCR_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCSTMBCRegistrationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMBCR)
	s oldI = +$g(^mdata("DHCSTMBCState"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMBCR = maxI
	s ^mdata("DHCSTMBCState") = maxI
}

}
