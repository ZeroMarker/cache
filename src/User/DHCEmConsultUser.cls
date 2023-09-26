Class User.DHCEmConsultUser Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsultUser, StorageStrategy = SQLStorage ]
{

/// 会诊子表ID  EC_ParRef_Dr
Property ECParRefDr As User.DHCEmConsultItm [ SqlColumnNumber = 2, SqlFieldName = EC_ParRef_Dr ];

/// 小组成员  EC_User_Dr
Property ECUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = EC_User_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCONU)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCONU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
