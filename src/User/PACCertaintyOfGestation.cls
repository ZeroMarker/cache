/// PAC Certainty of Gestation(1950)
Class User.PACCertaintyOfGestation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CertaintyOfGestation, StorageStrategy = SQLStorage ]
{

/// Code
Property GESTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = GEST_Code ];

/// Description
Property GESTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = GEST_Desc ];

/// National Code
Property GESTNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = GEST_NationalCode ];

/// Date From
Property GESTDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = GEST_DateFrom ];

/// Date To
Property GESTDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = GEST_DateTo ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACCertaintyOfGestation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCertaintyOfGestation","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACCertaintyOfGestation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCertaintyOfGestation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACCertaintyOfGestation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCertaintyOfGestation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACCertaintyOfGestation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCertaintyOfGestation","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACCertaintyOfGestation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCertaintyOfGestation","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCertaintyOfGestation","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("GEST",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="GEST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GEST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GEST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GEST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GEST_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GEST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GEST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{GEST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GEST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GEST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GEST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GEST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GEST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GEST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GEST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GEST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GEST_RowId</SqlRowIdName>
<StreamLocation>^User.PACCertaintyOfGestationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
