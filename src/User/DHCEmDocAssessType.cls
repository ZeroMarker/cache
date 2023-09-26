Class User.DHCEmDocAssessType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DAT_RowID, SqlTableName = DHC_EmDocAssessType, StorageStrategy = SQLStorage ]
{

/// 代码 
Property DATCode As %Library.Text(MAXLEN = 10) [ SqlColumnNumber = 2, SqlFieldName = DAT_Code ];

/// 描述
Property DATDesc As %Library.Text(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = DAT_Desc ];

/// 是否启用
Property DATActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DAT_ActiveFlag ];

/// 医院
Property DATHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = DAT_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMDAT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DAT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMDAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DAT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DAT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMDAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DAT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDocAssessTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
