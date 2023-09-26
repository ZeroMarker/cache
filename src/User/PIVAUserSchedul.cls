/// 排班管理-人员班次对照
Class User.PIVAUserSchedul Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_UserSchedul, StorageStrategy = CahceSQLStorage ]
{

/// 用户
Property PUSUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PUS_User_Dr ];

/// 班次
Property PUSSchedulDr As User.PIVASchedul [ SqlColumnNumber = 3, SqlFieldName = PUS_Schedul_Dr ];

/// 对照类型(M:每月初,ME:每月末,W:每周,D:指定日期,N:常规)
Property PUSType As %String [ SqlColumnNumber = 4, SqlFieldName = PUS_Type ];

Property PUSDays As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PUS_Days ];

Storage CahceSQLStorage
{
<SqlIdExpression>$i(^Config.PIVA.UserSchedul(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PUS_Days">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PUS_Schedul_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PUS_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PUS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^Config.PIVA.UserSchedul</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PUS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PUS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSchedu">
<Global>^Config.PIVA.UserSchedul</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PUS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Schedul"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PUS_Schedul_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^Config.PIVA.UserSchedul</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PUS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PUS_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PUS_RowId</SqlRowIdName>
<StreamLocation>^Config.PIVA.UserSchedulS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
