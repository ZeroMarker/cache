Class User.DHCAppArcLinkDisp Extends %Persistent [ SqlRowIdName = ALD_RowID, SqlTableName = DHC_AppArcLinkDisp, StorageStrategy = SQLStorage ]
{

/// 医嘱项ID ALD_Arc_Dr
Property ALDArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ALD_Arc_Dr ];

/// 后处理Dr ALD_Disp_Dr
Property ALDDispDr As User.DHCAppDispMedthod [ SqlColumnNumber = 3, SqlFieldName = ALD_Disp_Dr ];

Storage Default
{
<Data name="DHCAppArcLinkDispDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.DHCAppArcLinkDispD</DataLocation>
<DefaultData>DHCAppArcLinkDispDefaultData</DefaultData>
<IdLocation>^User.DHCAppArcLinkDispD</IdLocation>
<IndexLocation>^User.DHCAppArcLinkDispI</IndexLocation>
<SqlIdExpression>$i(^User.DHCAppArcLinkDispD)</SqlIdExpression>
<StreamLocation>^User.DHCAppArcLinkDispS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPARCDI(0))</SqlIdExpression>
<SQLMap name="Arc">
<Global>^DHCAPARCDI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ALD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALD_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ArcDisp">
<Global>^DHCAPARCDI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ArcDisp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALD_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALD_Disp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDispArc">
<Global>^DHCAPARCDI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DispArc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALD_Disp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALD_Arc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ALD_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALD_Disp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPARCDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ALD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ALD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ALD_RowID</SqlRowIdName>
<StreamLocation>^User.DHCAppArcLinkDispS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
