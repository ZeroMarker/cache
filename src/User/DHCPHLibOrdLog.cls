Class User.DHCPHLibOrdLog Extends (%Persistent, User.Abstract) [ Owner = {_PUBLIC}, SqlRowIdName = PHLIB_RowID, SqlTableName = DHC_PHLibOrdLog, StorageStrategy = NewStorage1 ]
{

Property PHLIBCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHLIB_CreateDate ];

Property PHLIBCreateTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHLIB_CreateTime ];

Property PHLIBDocUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHLIB_DocUser_Dr ];

Property PHLIBDocLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PHLIB_DocLoc_Dr ];

Property PHLIBDocGrpDr As User.SSGroup [ SqlColumnNumber = 6, SqlFieldName = PHLIB_DocGrp_Dr ];

Property PHLIBAdm As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PHLIB_Adm ];

Property PHLIBGeneric As %String [ SqlColumnNumber = 8, SqlFieldName = PHLIB_Generic ];

Property PHLIBLevel As %String [ SqlColumnNumber = 9, SqlFieldName = PHLIB_Level ];

Property PHLIBPrompt As %String(MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = PHLIB_Prompt ];

Property PHLIBPara As %String(MAXLEN = 500) [ SqlColumnNumber = 11, SqlFieldName = PHLIB_Para ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHLIBORDL)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCPHLIBORDL</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHLIB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLIB_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLIB_CreateTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHLIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHLIB_Adm">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHLIB_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLIB_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLIB_DocGrp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHLIB_DocLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHLIB_DocUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLIB_Generic">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHLIB_Level">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHLIB_Para">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHLIB_Prompt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHLIBORDL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLIB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHLIB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLibOrdLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
