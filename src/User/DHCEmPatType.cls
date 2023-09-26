Class User.DHCEmPatType Extends %Persistent [ Not Abstract, Owner = {_SYSTEM}, SqlRowIdName = PT_RowID, SqlTableName = DHC_EmPatType, StorageStrategy = NewStorage1 ]
{

/// 人群代码 PT_Code
Property PTCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PT_Code ];

/// 人群描述 PT_Desc
Property PTDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PT_Desc ];

/// 是否可用
Property PTActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PT_ActiveFlag ];

/// 集团化医院 
Property PTHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PT_Hosp_Dr ];

/// 特殊人群类型 
Property PTType As %Text(MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = PT_Type ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMPT)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMPT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PT_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
