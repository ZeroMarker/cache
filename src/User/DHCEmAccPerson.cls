Class User.DHCEmAccPerson Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EAP_RowID, SqlTableName = DHC_EmAccPerson, StorageStrategy = SQLStorage ]
{

/// 派车信息Adm   EM_ParRef_Dr
Property EMParRefDr As User.DHCEmDisAmbMan [ SqlColumnNumber = 2, SqlFieldName = EM_ParRef_Dr ];

/// 人员ID  EM_User_Dr
Property EMUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = EM_User_Dr ];

/// 人员描述  EM_User
Property EMUser As %Library.String [ SqlColumnNumber = 4, SqlFieldName = EM_User ];

/// 人员类型  EM_Type
Property EMType As %Library.String [ SqlColumnNumber = 5, SqlFieldName = EM_Type ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMACCP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EM_User">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMACCP</Global>
<Subscript name="1">
<Expression>{EAP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndByParRef">
<Global>^DHCEMACCPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParRef"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndByParType">
<Global>^DHCEMACCPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EAP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EAP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmAccPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
