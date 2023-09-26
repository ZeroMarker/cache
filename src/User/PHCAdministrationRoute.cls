/// Administration Route(2656)
Class User.PHCAdministrationRoute Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_AdministrationRoute, StorageStrategy = SQLStorage ]
{

/// Code
Property ADMRCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ADMR_Code ];

/// Description
Property ADMRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADMR_Desc ];

/// Date From
Property ADMRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ADMR_DateFrom ];

/// Date To
Property ADMRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ADMR_DateTo ];

/// IVType
Property ADMRIVType As %String(DISPLAYLIST = ",Continuous IV,Mini-bag,IV Push", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",C,M,P") [ SqlColumnNumber = 6, SqlFieldName = ADMR_IVType ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PHCAdministrationRoute).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCAdministrationRoute","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PHCAdministrationRoute).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCAdministrationRoute","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PHCAdministrationRoute).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCAdministrationRoute","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PHCAdministrationRoute).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCAdministrationRoute","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PHCAdministrationRoute).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCAdministrationRoute","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="ADMRCode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ADMRDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ADMRDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ADMRDesc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ADMRIVType">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PHC("ADMR",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="ADMR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADMR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADMR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADMR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADMR_IVType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PHC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADMR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PHC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADMR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PHC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADMR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADMR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADMR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADMR_RowId</SqlRowIdName>
<StreamLocation>^User.PHCAdministrationRouteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
