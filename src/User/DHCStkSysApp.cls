Class User.DHCStkSysApp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSA_RowID, SqlTableName = DHC_StkSysApp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 50;

Relationship ChildDHCStkSysAFrm As User.DHCStkSysAFrm [ Cardinality = children, Inverse = SSAFSSAParref ];

Relationship ChildDHCStkSysAProp As User.DHCStkSysAProp [ Cardinality = children, Inverse = SSAPSSAParref ];

Relationship ChildDHCStkSysCounter As User.DHCStkSysCounter [ Cardinality = children, Inverse = SSCSSAParref ];

Relationship ChildDHCStkSysGridSet As User.DHCStkSysGridSet [ Cardinality = children, Inverse = GSSSAParRef ];

/// Application Code
Property SSACode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SSA_Code ];

/// Application Name
Property SSADesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SSA_Desc ];

/// Stk_Cat_Grp_Type
Property SSAGrpType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",G,M,O") [ SqlColumnNumber = 4, SqlFieldName = SSA_GrpType ];

/// SSA_ModuType
Property SSAModuType As %Library.String(DISPLAYLIST = ",Business,Query,Statistics,Maintenance", MAXLEN = 11, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",B,Q,S,M") [ SqlColumnNumber = 5, SqlFieldName = SSA_ModuType ];

/// 产品线指向
Property SSAProDR As User.DHCStkSysPro [ SqlColumnNumber = 6, SqlFieldName = SSA_Pro_DR ];

/// 显示序号
Property SSASortNum As %Library.String(COLLATION = "EXACT", MAXLEN = 5) [ SqlColumnNumber = 7, SqlFieldName = SSA_SortNum ];

/// 用于单号规则
Property SSAForAppNo As %Library.String(COLLATION = "EXACT", MAXLEN = 5) [ SqlColumnNumber = 8, SqlFieldName = SSA_ForAppNo ];

/// 用于参数设置
Property SSAForParams As %Library.String(COLLATION = "EXACT", MAXLEN = 5) [ SqlColumnNumber = 9, SqlFieldName = SSA_ForParams ];

Storage SQLStorage
{
<ExtentSize>50</ExtentSize>
<SqlIdExpression>$i(^DHCSSA)</SqlIdExpression>
<SQLMap name="DataMasterSSA">
<Data name="SSA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSA_ForAppNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SSA_ForParams">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SSA_GrpType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSA_ModuType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSA_Pro_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSA_SortNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCSSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SSA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ACODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SSA_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SSA_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGrpType">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AGTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSA_GrpType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModuType">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AMTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSA_ModuType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysAppS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSSA)
	s oldI = +$g(^mdata("DHCSTKSYSAPP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSSA = maxI
	s ^mdata("DHCSTKSYSAPP") = maxI
}

}
