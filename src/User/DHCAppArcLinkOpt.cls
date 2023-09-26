Class User.DHCAppArcLinkOpt Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ALO_RowID, SqlTableName = DHC_AppArcLinkOpt, StorageStrategy = SQLStorage ]
{

/// 医嘱项id  ALO_Arc_Dr
Property ALOArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ALO_Arc_Dr ];

/// 其他项目  ALO_Opt_Dr
Property ALOOptDr As User.DHCAppOtherOpt [ SqlColumnNumber = 3, SqlFieldName = ALO_Opt_Dr ];

/// 默认选择
Property ALOMoChoice As %String [ SqlColumnNumber = 4, SqlFieldName = ALO_MoChoice ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPARCO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ALO_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALO_MoChoice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALO_Opt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPARCO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{ALO_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ALO_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArc">
<Global>^DHCAPARCO</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALO_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALO_Opt_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcLinkOptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
