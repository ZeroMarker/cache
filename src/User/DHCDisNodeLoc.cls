Class User.DHCDisNodeLoc Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = NL_RowID, SqlTableName = DHC_DisNodeLoc, StorageStrategy = SQLStorage ]
{

/// NL_Code  代码
Property NLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = NL_Code ];

/// NL_Desc  描述
Property NLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = NL_Desc ];

/// NL_ActiveFlag  是否可用
Property NLActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = NL_ActiveFlag ];

/// NL_Loc_Dr  所属科室
Property NLLocDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = NL_Loc_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISNL)</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCDISNL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NL_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DateMaster">
<Data name="NL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISNL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{NL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisNodeLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
