Class User.DHCStkSysPHCCodeSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCS_RowId, SqlTableName = DHC_StkSysPHCCodeSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 分类级别
Property PCSLevel As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCS_Level ];

/// 代码长度
Property PCSLength As %Library.Numeric [ SqlColumnNumber = 3, SqlFieldName = PCS_Length ];

/// PCS_Start
Property PCSStart As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PCS_Start ];

/// 医院
Property PCSHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PCS_Hosp_Dr ];

/// 当前最大码
Property PCSCurNo As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PCS_CurNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSSPCS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCS_CurNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCS_Length">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCS_Level">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCS_Start">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSSPCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PCS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLevel">
<Global>^DHCSSPCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LEVEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>+{PCS_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PCS_Level}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PCS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysPHCCodeSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSSPCS)
	s oldI = +$g(^mdata("DHCSTKSYSPHCCODESET"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSSPCS = maxI
	s ^mdata("DHCSTKSYSPHCCODESET") = maxI
}

}
