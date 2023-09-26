Class User.DHCAppArcRule Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AR_RowId, SqlTableName = DHC_AppArcRule, StorageStrategy = SQLStorage ]
{

/// 医嘱项id AR_Arc_Dr
Property ARArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = AR_Arc_Dr ];

/// 优先级 AR_Priority
Property ARPriority As %Library.String [ SqlColumnNumber = 3, SqlFieldName = AR_Priority ];

/// 组号 AR_GrpNo
Property ARGrpNo As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AR_GrpNo ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPAR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_GrpNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_Priority">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArc">
<Global>^DHCAPPAR</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AR_Arc_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
