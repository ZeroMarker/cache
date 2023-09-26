Class DHCMGNUR.DHCNurHEAProject Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// 项目一
Property Item1 As %String(TRUNCATE = 1) [ Required, SqlFieldName = HEAP_Item1 ];

/// 病区
Property WardItemDR As %String(TRUNCATE = 1) [ SqlFieldName = HEAP_WardItemDR ];

/// 有效
Property Item1Valid As %String(TRUNCATE = 1) [ SqlFieldName = HEAP_Valid ];

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SqlIdExpression>$i(^HEDUAP(0))</SqlIdExpression>
<SQLMap name="HEAProjectData">
<Data name="HEAP_Item1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HEAP_Valid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HEAP_WardItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^HEDUAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{HEAP_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HEAP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexWardDR">
<Global>^HEDUAP</Global>
<Subscript name="1">
<Expression>{HEAP_WardItemDR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HEAPW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HEAP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HEAP_RowId</SqlRowIdName>
<StreamLocation>^DHCMGNUR.DHCNurHEAProjectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
