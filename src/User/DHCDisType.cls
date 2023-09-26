Class User.DHCDisType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DT_RowID, SqlTableName = DHC_DisType, StorageStrategy = SQLStorage ]
{

/// 代码  DT_Code
Property DTCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = DT_Code ];

/// 描述  DT_Desc
Property DTDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = DT_Desc ];

/// 是否可用  DT_ActiveFlag
Property DTActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DT_ActiveFlag ];

/// 集团化医院  Dt_Hosp_Dr
Property DTHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = DT_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISTY)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCDISTY</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="DT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISTY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
