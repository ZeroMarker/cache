/// User Def Win Group(2375)
Class User.SSUserDefWinGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserDefWinGroup, StorageStrategy = SQLStorage ]
{

/// Code
Property WINGRPCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WINGRP_Code ];

/// Description
Property WINGRPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WINGRP_Desc ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="WINGRPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="WINGRPDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SSU("WINGRP",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="WINGRP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WINGRP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WINGRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WINGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WINGRP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WINGRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WINGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WINGRP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WINGRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WINGRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WINGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WINGRP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WINGRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WINGRP_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserDefWinGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
