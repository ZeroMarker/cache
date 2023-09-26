Class User.DHCEmConsItemProp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsItemProp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EC_Code  代码
Property ECCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EC_Code ];

/// EC_Desc  描述
Property ECDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EC_Desc ];

/// 是否可用  EC_ActiveFlag
Property ECActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = EC_ActiveFlag ];

/// 类型指针  EC_Item_Dr
Property ECItemDr As User.DHCEmConsDicItem [ SqlColumnNumber = 5, SqlFieldName = EC_Item_Dr ];

/// 参数  EC_Value
Property ECValue As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EC_Value ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEMCIP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_Value">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMCIP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMCIP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMCIP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEMCIP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Item_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsItemPropS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
