/// 排班管理-岗位班次对照
Class User.PIVADutySchedul Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_DutySchedul, StorageStrategy = CahceSQLStorage ]
{

/// 岗位
Property PDSDutyDr As User.PIVADuty [ SqlColumnNumber = 2, SqlFieldName = PDS_Duty_Dr ];

/// 班次
Property PDSSchedulDr As User.PIVASchedul [ SqlColumnNumber = 3, SqlFieldName = PDS_Schedul_Dr ];

/// 对照类型(M:每月初,ME:每月末,W:每周,D:指定日期,N:常规)
Property PDSType As %String [ SqlColumnNumber = 4, SqlFieldName = PDS_Type ];

Property PDSDays As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PDS_Days ];

Storage CahceSQLStorage
{
<SqlIdExpression>$i(^Config.PIVA.DutySchedul(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDS_Days">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDS_Duty_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDS_Schedul_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDS_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^Config.PIVA.DutySchedul</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDuty">
<Global>^Config.PIVA.DutySchedul</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Duty"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDS_Duty_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDS_RowId</SqlRowIdName>
<StreamLocation>^Config.PIVA.DutySchedulS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
