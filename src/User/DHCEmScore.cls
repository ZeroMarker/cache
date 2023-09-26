Class User.DHCEmScore Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SCORE_RowID, SqlTableName = DHC_EmScore, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEMSCOREITM As User.DHCEmScoreItm [ Cardinality = children, Inverse = SCOREItmParRef ];

/// 就诊ID  SCORE_Adm_Dr
Property SCOREAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = SCORE_Adm_Dr ];

/// 创建人  SCORE_CreateUser_Dr
Property SCORECreateUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SCORE_CreateUser_Dr ];

/// 创建日期  SCORE_CreateDate	
Property SCORECreateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SCORE_CreateDate ];

/// 创建时间  UNS_CreateTime	
Property SCORECreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = SCORE_CreateTime ];

/// 更新人  SCORE_UpdateUser_Dr
Property SCOREUpdateUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = SCORE_UpdateUser_Dr ];

/// 更新日期  SCORE_UpdateDate	
Property SCOREUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = SCORE_UpdateDate ];

/// 更新时间  SCORE_UpdateTime	
Property SCOREUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = SCORE_UpdateTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMSCORE)</SqlIdExpression>
<SQLMap name="IndexAdm">
<Global>^DHCEMSCORE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SCORE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCORE_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCORE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMSCORE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SCORE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Create"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCORE_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCORE_Adm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCORE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="SCORE_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCORE_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCORE_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SCORE_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCORE_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SCORE_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SCORE_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMSCORE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SCORE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SCORE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmScoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
