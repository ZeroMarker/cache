/// 排班管理-排班主表
Class User.PIVAScheArrange Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_ScheArrange, StorageStrategy = CacheSQLStorage ]
{

Relationship ChildPIVAScheArrangeItm As User.PIVAScheArrangeItm [ Cardinality = children, Inverse = PSAIParref ];

/// 配液中心
Property PSALocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PSA_Loc_Dr ];

/// 月份
Property PSAMonth As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PSA_Month ];

/// 创建日期
Property PSADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PSA_Date ];

/// 创建时间
Property PSATime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PSA_Time ];

/// 创建人员
Property PSAUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PSA_User_Dr ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Busi.PIVA.ScheArrange(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PSA_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PSA_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PSA_Month">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PSA_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PSA_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^Busi.PIVA.ScheArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PSA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PSA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocMon">
<Global>^Busi.PIVA.ScheArrange</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PSA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocMon"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSA_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PSA_Month}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PSA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PSA_RowId</SqlRowIdName>
<StreamLocation>^Busi.PIVA.ScheArrangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
