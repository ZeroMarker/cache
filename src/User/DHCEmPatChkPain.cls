Class User.DHCEmPatChkPain Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = PCP_RowId, SqlTableName = DHC_EmPatChkPain, StorageStrategy = NewStorage1 ]
{

/// 预检表 PCP_Chk_Dr
Property PCPChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCP_Chk_Dr ];

/// 性质 PCP_Nature
Property PCPNature As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PCP_Nature ];

/// 分数 PCP_Score
Property PCPScore As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PCP_Score ];

/// 时间 PCP_Time
Property PCPTime As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PCP_Time ];

/// 方法 PCP_Method
Property PCPMethod As %Library.String [ SqlColumnNumber = 6, SqlFieldName = PCP_Method ];

/// 激活状态 PCP_Active
Property PCPActive As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PCP_Active ];

/// 疼痛部位 PCP_Pos
Property PCPPos As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PCP_Pos ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMPCP)</SqlIdExpression>
<SQLMap name="IndexPatCheLev">
<Global>^DHCEMPCP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCP_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PCP_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCP_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCP_Method">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCP_Nature">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCP_Pos">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCP_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCP_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkPainS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
