/// 排班管理-岗位人员关联
Class User.PIVADutyUser Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_DutyUser, StorageStrategy = CacheSQLStorage ]
{

/// 岗位
Property PDUDutyDr As User.PIVADuty [ SqlColumnNumber = 2, SqlFieldName = PDU_Duty_Dr ];

/// 人员
Property PDUUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PDU_User_Dr ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Config.PIVA.DutyUser(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDU_Duty_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDU_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^Config.PIVA.DutyUser</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDU_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDuty">
<Global>^Config.PIVA.DutyUser</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Duty"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDU_Duty_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^Config.PIVA.DutyUser</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDU_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDU_RowId</SqlRowIdName>
<StreamLocation>^Config.PIVA.DutyUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
