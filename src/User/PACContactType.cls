/// PAC Contact Type(1879)
Class User.PACContactType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ContactType, StorageStrategy = SQLStorage ]
{

/// Code
Property CONTTPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CONTTP_Code ];

/// ContRole
Property CONTTPContRole As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CONTTP_ContRole ];

/// CONTTP Date From
Property CONTTPDateFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CONTTP_Date_From ];

/// CONTTP Date To
Property CONTTPDateTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CONTTP_Date_To ];

/// Description
Property CONTTPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CONTTP_Desc ];

/// Display Order
Property CONTTPDisplayOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CONTTP_DisplayOrder ];

/// Family Relationship
Property CONTTPFamilyRelship As CTRelation [ SqlColumnNumber = 8, SqlFieldName = CONTTP_FamilyRelship ];

/// FundingArrange
Property CONTTPFundingArrange As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CONTTP_FundingArrange ];

/// Not Ongoing
Property CONTTPNotOngoing As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CONTTP_NotOngoing ];

/// Priority
Property CONTTPPriority As %Float [ SqlColumnNumber = 11, SqlFieldName = CONTTP_Priority ];

Parameter EXTENTSIZE = 9;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACContactType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContactType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACContactType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContactType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACContactType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContactType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACContactType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContactType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACContactType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContactType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>9</ExtentSize>
<Property name="CONTTPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTTPContRole">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTTPDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTTPDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTTPDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTTPDisplayOrder">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CONTTPFamilyRelship">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTTPFundingArrange">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTTPNotOngoing">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CONTTPPriority">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("CONTTP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CONTTP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONTTP_ContRole">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONTTP_Date_From">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONTTP_Date_To">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONTTP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONTTP_DisplayOrder">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CONTTP_FamilyRelship">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONTTP_FundingArrange">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CONTTP_NotOngoing">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONTTP_Priority">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CONTTP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CONTTP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CONTTP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CONTTP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONTTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CONTTP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CONTTP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONTTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CONTTP_RowId</SqlRowIdName>
<StreamLocation>^User.PACContactTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
