/// Midwife Community Team
Class User.PACMidwifeCommTeam Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_MidwifeCommTeam, StorageStrategy = SQLStorage ]
{

/// Code
Property MIDCOMMCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MIDCOMM_Code ];

/// Date From
Property MIDCOMMDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = MIDCOMM_DateFrom ];

/// Date To
Property MIDCOMMDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = MIDCOMM_DateTo ];

/// Description
Property MIDCOMMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MIDCOMM_Desc ];

/// National Code
Property MIDCOMMNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MIDCOMM_NationalCode ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACMidwifeCommTeam).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACMidwifeCommTeam","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACMidwifeCommTeam).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACMidwifeCommTeam","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACMidwifeCommTeam).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACMidwifeCommTeam","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACMidwifeCommTeam).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACMidwifeCommTeam","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACMidwifeCommTeam).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACMidwifeCommTeam","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="MIDCOMMCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIDCOMMDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIDCOMMDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIDCOMMDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIDCOMMNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("MIDCOMM",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MIDCOMM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIDCOMM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIDCOMM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIDCOMM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIDCOMM_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MIDCOMM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MIDCOMM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MIDCOMM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MIDCOMM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MIDCOMM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MIDCOMM_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIDCOMM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MIDCOMM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MIDCOMM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MIDCOMM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIDCOMM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MIDCOMM_RowId</SqlRowIdName>
<StreamLocation>^User.PACMidwifeCommTeamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
