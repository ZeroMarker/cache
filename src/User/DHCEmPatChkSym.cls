Class User.DHCEmPatChkSym Extends %Persistent [ SqlRowIdName = PCSY_RowID, SqlTableName = DHC_EmPatChkSym, StorageStrategy = SQLStorage ]
{

/// 预检表 PCS_Chk_Dr
Property PCSYChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCSY_Chk_Dr ];

/// 症状字典表 PCS_SymField_Dr
Property PCSYSymFieldDr As User.DHCSymptomFeild [ SqlColumnNumber = 3, SqlFieldName = PCSY_SymField_Dr ];

Storage SQLStorage
{
<ExtentSize>10000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPCSY)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCSY_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCSY_SymField_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCSY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCSY_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCSY_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCSY</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCSY_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCSY_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCSY_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkSymS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
