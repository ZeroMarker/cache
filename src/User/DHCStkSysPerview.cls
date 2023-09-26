Class User.DHCStkSysPerview Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSP_RowID, SqlTableName = DHC_StkSysPerview, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SSP_Point
Property SSPPoint As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SSP_Point ];

/// SSP_Type
Property SSPType As %Library.String(MAXLEN = 8, SELECTIVITY = "14.2857%", VALUELIST = ",Hospital||H,SCGType||S,SS_Group||G,CT_Loc||L,SS_User||U,DHC||D") [ SqlColumnNumber = 3, SqlFieldName = SSP_Type ];

/// SSP_STCUS_Dr
Property SSPSTCUSDr As User.DHCSTCUSTOMER [ SqlColumnNumber = 4, SqlFieldName = SSP_STCUS_Dr ];

/// SP_Level
Property SSPLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SSP_Level ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSSP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SSP_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSP_Point">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSP_STCUS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSP_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSSP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SSP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospTypePoint">
<Global>^DHCSSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HTP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSP_STCUS_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSP_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSP_Point}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SSP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePoint">
<Global>^DHCSSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSP_Point}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysPerviewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSSP)
	s oldI = +$g(^mdata("DHCSTKSYSPERVIEW"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSSP = maxI
	s ^mdata("DHCSTKSYSPERVIEW") = maxI
}

}
