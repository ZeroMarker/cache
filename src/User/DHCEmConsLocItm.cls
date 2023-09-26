Class User.DHCEmConsLocItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsLocItm, StorageStrategy = SQLStorage ]
{

/// EC_User_Dr  科室ID
Property ECCode As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = EC_Loc_Dr ];

/// EC_SubMar_Dr  亚专业
Property ECSubMarDr As User.DHCEmConsDicItem [ SqlColumnNumber = 3, SqlFieldName = EC_SubMar_Dr ];

/// EC_IndItm_Dr  指针
Property ECIndItmDr As User.DHCEmConsDicItem [ SqlColumnNumber = 4, SqlFieldName = EC_IndItm_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCLI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_IndItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_SubMar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEMCLI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMar">
<Global>^DHCEMCLI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SubMar"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_SubMar_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsLocItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
