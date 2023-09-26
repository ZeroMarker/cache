/// Film Execute(2091)
Class User.OEFilmExecute Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_FilmExecute, StorageStrategy = SQLStorage ]
{

Relationship ChildOEFilmExecuteFilmsUsed As OEFilmExecuteFilmsUsed [ Cardinality = children, Inverse = FUParRef ];

Relationship ChildOEFilmExecuteIsotope As OEFilmExecuteIsotope [ Cardinality = children, Inverse = ISParRef ];

Relationship ChildOEFilmExecuteItems As OEFilmExecuteItems [ Cardinality = children, Inverse = ITMParRef ];

/// Date
Property OEFEDate As %Date [ SqlColumnNumber = 2, SqlFieldName = OEFE_Date ];

Parameter EXTENTSIZE = 892;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEFilmExecute).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEFilmExecute).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEFilmExecute).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEFilmExecute).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEFilmExecute).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>892</ExtentSize>
<Property name="OEFEDate">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^OEFE(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="OEFE_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEFE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OEFE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OEFE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEFE_RowId</SqlRowIdName>
<StreamLocation>^User.OEFilmExecuteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
