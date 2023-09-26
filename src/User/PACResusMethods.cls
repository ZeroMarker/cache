/// Resuscitation Methods(2261)
Class User.PACResusMethods Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ResusMethods, StorageStrategy = SQLStorage ]
{

/// Active flag
Property RESUSMTHActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = RESUSMTH_Active ];

/// Code
Property RESUSMTHCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RESUSMTH_Code ];

/// Date From
Property RESUSMTHDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = RESUSMTH_DateFrom ];

/// Date To
Property RESUSMTHDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = RESUSMTH_DateTo ];

/// Description
Property RESUSMTHDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RESUSMTH_Desc ];

/// National Code
Property RESUSMTHNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RESUSMTH_NationalCode ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACResusMethods).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACResusMethods","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACResusMethods).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACResusMethods","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACResusMethods).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACResusMethods","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACResusMethods).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACResusMethods","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACResusMethods).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACResusMethods","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="RESUSMTHActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESUSMTHCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESUSMTHDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESUSMTHDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESUSMTHDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="RESUSMTHNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^("RESUSMTH",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RESUSMTH_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RESUSMTH_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RESUSMTH_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RESUSMTH_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RESUSMTH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RESUSMTH_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RESUSMTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESUSMTH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RESUSMTH_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RESUSMTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESUSMTH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RESUSMTH_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RESUSMTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RESUSMTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESUSMTH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RESUSMTH_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RESUSMTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RESUSMTH_RowId</SqlRowIdName>
<StreamLocation>^User.PACResusMethodsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
