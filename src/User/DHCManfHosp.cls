Class User.DHCManfHosp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MH_ROWID, SqlTableName = DHC_ManfHosp, StorageStrategy = SQLStorage ]
{

/// MH_Manf_DR  厂商ID PHManufactor
Property MHManfDR As PHManufacturer [ SqlColumnNumber = 2, SqlFieldName = MH_Manf_DR ];

/// MH_Hospital_DR  医院ID
Property MHHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = MH_Hospital_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MANFHOP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MH_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MH_Manf_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MANFHOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MH_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexHosp">
<Global>^MANFHOP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MH_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MH_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexManf">
<Global>^MANFHOP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Manf"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MH_Manf_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MH_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCManfHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^MANFHOP)
	s oldI = +$g(^mdata("DHCMANFHOSP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^MANFHOP = maxI
	s ^mdata("DHCMANFHOSP") = maxI
}

}
