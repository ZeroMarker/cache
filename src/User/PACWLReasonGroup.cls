/// PAC WL Reason Group(2021)
Class User.PACWLReasonGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLReasonGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 16;

/// Code
Property WLRGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WLRG_Code ];

/// Description
Property WLRGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WLRG_Desc ];

/// Date From
Property WLRGDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = WLRG_DateFrom ];

/// Date To
Property WLRGDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = WLRG_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWLReasonGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWLReasonGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWLReasonGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWLReasonGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonGroup","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWLReasonGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>16</ExtentSize>
<Property name="WLRGCode">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="WLRGDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="WLRGDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="WLRGDesc">
<Selectivity>12.5000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("WLRG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WLRG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLRG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLRG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLRG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WLRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WLRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLRG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLRG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLRG_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLReasonGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
