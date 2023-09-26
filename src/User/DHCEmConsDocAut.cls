Class User.DHCEmConsDocAut Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsDocAut, StorageStrategy = SQLStorage ]
{

/// EC_User_Dr  用户ID
Property ECCode As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = EC_User_Dr ];

/// EC_Itm_Dr  项目
Property ECItmDr As User.DHCEmConsDicItem [ SqlColumnNumber = 3, SqlFieldName = EC_Itm_Dr ];

/// 集团化医院  EC_Hosp_Dr
Property ECHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = EC_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCDA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_Itm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMCDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospUser">
<Global>^DHCEMCDA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEMCDA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_Itm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsDocAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
