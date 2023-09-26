/// Episode Subtype(1468)
Class User.PACEpisodeSubType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_EpisodeSubType, StorageStrategy = SQLStorage ]
{

/// Code
Property SUBTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SUBT_Code ];

/// Description
Property SUBTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SUBT_Desc ];

/// Admission Type
Property SUBTAdmType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ Required, SqlColumnNumber = 4, SqlFieldName = SUBT_AdmType ];

/// Day Surgery
Property SUBTDaySurgery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SUBT_DaySurgery ];

/// First Reg Day Night
Property SUBTFirstRegDayNight As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SUBT_FirstRegDayNight ];

/// Wait Time
Property SUBTWaitTime As %Float [ SqlColumnNumber = 7, SqlFieldName = SUBT_WaitTime ];

/// National Code
Property SUBTNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SUBT_NationCode ];

/// Date From
Property SUBTDateFrom As %Date [ SqlColumnNumber = 9, SqlFieldName = SUBT_DateFrom ];

/// Date To
Property SUBTDateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = SUBT_DateTo ];

Index SUBTCodeUnqIdx1 On SUBTCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACEpisodeSubType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACEpisodeSubType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACEpisodeSubType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACEpisodeSubType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACEpisodeSubType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACEpisodeSubType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACEpisodeSubType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACEpisodeSubType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACEpisodeSubType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACEpisodeSubType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("SUBT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SUBT_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUBT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUBT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUBT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SUBT_DaySurgery">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUBT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUBT_FirstRegDayNight">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUBT_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUBT_WaitTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SUBT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUBT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SUBT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SUBT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUBT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SUBT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SUBT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SUBT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUBT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SUBT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SUBT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUBT_RowId</SqlRowIdName>
<StreamLocation>^User.PACEpisodeSubTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
