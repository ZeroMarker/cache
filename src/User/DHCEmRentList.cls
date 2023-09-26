Class User.DHCEmRentList Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RL_RowId, SqlTableName = DHC_EmRentList, StorageStrategy = SQLStorage ]
{

/// 出租物品代码  RL_Code
Property RLCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = RL_Code ];

/// 出租物品描述  RL_Desc
Property RLDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = RL_Desc ];

/// 是否可用  RL_ActiveFlag
Property RLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = RL_ActiveFlag ];

/// 集团化医院  RL_Hosp_Dr 
Property RLHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = RL_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMRL)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMRLI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RL_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="RL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RL_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMRL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmRentListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
