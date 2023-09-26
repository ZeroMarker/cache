Class User.PHAINLocDrugList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = LDL_RowId, SqlTableName = PHAIN_LocDrugList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LDLDocLocDr [ Unique ];

Relationship ChildDHCLDL As User.PHAINLocDrugListItm [ Cardinality = children, Inverse = LDLPARREF ];

Relationship ChildDHCLDDL As User.PHAINLocDrugDocItm [ Cardinality = children, Inverse = LDDIPARREF ];

/// LDL_DocLoc_Dr   医生科室id
Property LDLDocLocDr As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = LDL_DocLoc_Dr ];

/// LDL_ActiveFlag  使用状态
Property LDLActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = LDL_ActiveFlag ];

/// LDL_Hos_Dr   医院id
Property LDLHosDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = LDL_Hos_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CF.PHA.IN.LocDrugList)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LDL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LDL_DocLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LDL_Hos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.IN.LocDrugList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LDL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LDL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosLoc">
<Global>^CF.PHA.IN.LocDrugListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LDL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HOSLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LDL_Hos_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LDL_DocLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LDL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LDL_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINLocDrugList</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.LocDrugList)
	s oldI = +$g(^mdata("PHAINLocDrugList"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.LocDrugList = maxI
	s ^mdata("PHAINLocDrugList") = maxI
}

}
