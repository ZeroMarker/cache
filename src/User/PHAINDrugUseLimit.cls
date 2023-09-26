Class User.PHAINDrugUseLimit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = DUL_RowId, SqlTableName = PHAIN_DrugUseLimit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index ARCKeyIndex On (DULHosDr, DULPhlDr, DULArcDr) [ Unique ];

Index PHCGKeyIndex On (DULHosDr, DULPhcgDr, DULArcDr) [ Unique ];

// Index PROPKeyIndex On (DULHosDr, DULDrugProp) [ Unique ];

Relationship ChildDHCDUL As User.PHAINDrugULComb [ Cardinality = children, Inverse = DULIDULPARREF ];

/// DUL_DrugType  限制数据类型：处方通用名/医嘱项
Property DULDrugType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DUL_DrugType ];

/// DUL_Arc_Dr  医嘱项指向
Property DULArcDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DUL_Arc_Dr ];

/// DUL_Phcg_Dr  处方通用名指向
Property DULPhcgDr As User.PHCGeneric [ SqlColumnNumber = 4, SqlFieldName = DUL_Phcg_Dr ];

/// DUL_Hos_Dr   医院id
Property DULHosDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = DUL_Hos_Dr ];

/// DUL_Phl_Dr   药房科室id
Property DULPhlDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = DUL_Phl_Dr ];

/// DUL_ActiveFlag  使用状态
Property DULActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DUL_ActiveFlag ];

/// DUL_GroupType  限制范围类型：医院/药房
Property DULGroupType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DUL_GroupType ];

/// DUL_DrugProp  药品属性
Property DULDrugProp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DUL_DrugProp ];

/// DUL_ALLNotUseFlag  全部禁止
Property DULALLNotUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DUL_ALLNotUseFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CF.PHA.IN.DrugUseLimit)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DUL_ALLNotUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DUL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DUL_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DUL_DrugProp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DUL_DrugType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DUL_GroupType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DUL_Hos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DUL_Phcg_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DUL_Phl_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF.PHA.IN.DrugUseLimit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DUL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArc">
<Global>^CF.PHA.IN.DrugUseLimiti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ARC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUL_Arc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUL_Hos_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DUL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHosType">
<Global>^CF.PHA.IN.DrugUseLimiti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HosType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUL_Hos_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUL_GroupType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DUL_DrugType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DUL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCG">
<Global>^CF.PHA.IN.DrugUseLimiti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHCG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUL_Phcg_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUL_Hos_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DUL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProp">
<Global>^CF.PHA.IN.DrugUseLimiti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DUL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PROP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUL_DrugProp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUL_Hos_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DUL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DUL_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINDrugUseLimit</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.DrugUseLimit)
	s oldI = +$g(^mdata("PHAINDrugUseLimit"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.DrugUseLimit = maxI
	s ^mdata("PHAINDrugUseLimit") = maxI
}

}
