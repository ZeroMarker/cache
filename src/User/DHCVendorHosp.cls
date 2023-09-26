Class User.DHCVendorHosp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VH_ROWID, SqlTableName = DHC_VendorHosp, StorageStrategy = SQLStorage ]
{

/// VH_Vendor_DR  供应商ID
Property VHVendorDR As APCVendor [ SqlColumnNumber = 2, SqlFieldName = VH_Vendor_DR ];

/// VH_Hospital_DR  医院ID
Property VHHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = VH_Hospital_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^VENDHOP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VH_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VH_Vendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^VENDHOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{VH_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexHosp">
<Global>^VENDHOP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VH_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VH_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexVendor">
<Global>^VENDHOP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VH_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VH_Vendor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VH_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVendorHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^VENDHOP)
	s oldI = +$g(^mdata("DHCVENDORHOSP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^VENDHOP = maxI
	s ^mdata("DHCVENDORHOSP") = maxI
}

}
