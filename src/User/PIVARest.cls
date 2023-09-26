/// 排班管理-存假-常规设置
Class User.PIVARest Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_Rest, StorageStrategy = CacheSQLStorage ]
{

Relationship ChildPIVARestItm As User.PIVARestItm [ Cardinality = children, Inverse = PRIParref ];

/// 配液中心
Property PRLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PR_Loc_Dr ];

/// 人员
Property PRUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PR_User_Dr ];

/// 日期
Property PRMonth As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PR_Month ];

/// 固定休假天数
Property PRRestDays As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PR_RestDays ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Busi.PIVA.Rest(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PR_Month">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PR_RestDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^Busi.PIVA.Rest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocMon">
<Global>^Busi.PIVA.Rest</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocMon"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PR_Month}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PR_RowId</SqlRowIdName>
<StreamLocation>^Busi.PIVA.RestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
