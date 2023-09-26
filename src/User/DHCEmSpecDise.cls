Class User.DHCEmSpecDise Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SDI_RowID, SqlTableName = DHC_EmSpecDise, StorageStrategy = SQLStorage ]
{

/// 代码  SDI_Code
Property SDICode As %Library.Text(MAXLEN = 10) [ SqlColumnNumber = 2, SqlFieldName = SDI_Code ];

/// 描述  SDI_Desc
Property SDIDesc As %Library.Text(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = SDI_Desc ];

/// 是否启用  SDI_ActiveFlag
Property SDIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SDI_ActiveFlag ];

/// 医院   SDI_Hosp_Dr
Property SDIHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = SDI_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMSPD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SDI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SDI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDI_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMSPD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SDI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMSPD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SDI_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmSpecDiseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
