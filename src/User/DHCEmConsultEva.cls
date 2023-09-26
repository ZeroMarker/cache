Class User.DHCEmConsultEva Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsultEva, StorageStrategy = SQLStorage ]
{

/// ECL_Cst_Ref	项目id:主表或者字表ID
Property ECCstRef As %Library.String [ SqlColumnNumber = 2, SqlFieldName = EC_Cst_Ref ];

/// 评价项目ID  ECDicItmDr
Property ECDicItmDr As User.DHCEmConsDicItem [ SqlColumnNumber = 3, SqlFieldName = EC_DicItm_Dr ];

/// 存储的值  EC_EvaValue
Property ECEvaValue As %Library.String [ SqlColumnNumber = 4, SqlFieldName = EC_EvaValue ];

/// 类型  EC_EvaType R/C
Property ECEvaType As %Library.String [ SqlColumnNumber = 5, SqlFieldName = EC_EvaType ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCONE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Cst_Ref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_DicItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_EvaType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_EvaValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMCONE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCstAndDic">
<Global>^DHCEMCONE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexCstAndDic"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Cst_Ref}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_DicItm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultEvaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
