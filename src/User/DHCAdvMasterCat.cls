Class User.DHCAdvMasterCat Extends %Persistent [ SqlRowIdName = MC_RowID, SqlTableName = DHC_AdvMasterCat, StorageStrategy = SQLStorage ]
{

/// 不良事件主表ID   MC_Master_Dr
Property MCMasterDr As User.DHCAdvMaster [ SqlColumnNumber = 2, SqlFieldName = MC_Master_Dr ];

/// 管理类别  MC_ManageCat
Property MCManageCat As %String [ SqlColumnNumber = 3, SqlFieldName = MC_ManageCat ];

/// 服务项目  MC_ManCatProject
Property MCManCatProject As %String [ SqlColumnNumber = 4, SqlFieldName = MC_ManCatProject ];

/// 子项  MC_CatProChild
Property MCCatProChild As %String [ SqlColumnNumber = 5, SqlFieldName = MC_CatProChild ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVMASTERCAT)</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCADVMASTERCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Master"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_Master_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMasert">
<Data name="MC_CatProChild">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MC_ManCatProject">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MC_ManageCat">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MC_Master_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVMASTERCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvMasterCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
