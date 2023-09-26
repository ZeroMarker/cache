Class User.DHCEmPatChkHisMore Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PCHIM_RowID, SqlTableName = DHC_EmPatChkHisMore, StorageStrategy = NewStorage1 ]
{

/// 预检表 PCHIM_Chk_Dr
Property PCHIMChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCHIM_Chk_Dr ];

/// 既往史 PCHIM_His_Dr
Property PCHIMHisDr As User.DHCEmPatHistoryMore [ SqlColumnNumber = 3, SqlFieldName = PCHIM_His_Dr ];

/// 是否可用  PCHIIM_Flag
Property PCHIIMFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PCHIIM_Flag ];

/// 具体描述  PCHIIM_Text
Property PCHIIMText As %String [ SqlColumnNumber = 5, SqlFieldName = PCHIIM_Text ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMPCHIM)</SqlIdExpression>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCHIM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCHIM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCHIM_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCHIM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PCHIIM_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCHIIM_Text">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCHIM_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCHIM_His_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCHIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCHIM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCHIM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkHisMoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
