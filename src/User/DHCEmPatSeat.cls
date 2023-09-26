Class User.DHCEmPatSeat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SE_RowID, SqlTableName = DHC_EmPatSeat, StorageStrategy = SQLStorage ]
{

/// 科室 SE_Loc_Dr
Property SELocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = SE_Loc_Dr ];

/// 类型 SE_Type
Property SEType As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = SE_Type ];

/// 数量 SE_Num
Property SENum As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = SE_Num ];

/// 是否可用  SE_ActiveFlag
Property SEActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SE_ActiveFlag ];

/// 座位宽度 SE_Width
Property SEWidth As %Text(MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = SE_Width ];

/// 座位高度 SE_Height
Property SEHeight As %Text(MAXLEN = 30) [ SqlColumnNumber = 7, SqlFieldName = SE_Height ];

Relationship ChildDHCEMPATSEST As User.DHCEmPatSeatItm [ Cardinality = children, Inverse = SETheParRef ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPSE)</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCEMPSE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SE_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="SE_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SE_Height">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SE_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SE_Num">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SE_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SE_Width">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMPSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatSeatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
