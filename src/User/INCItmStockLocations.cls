/// INC Item Stock Locations(1618)
Class User.INCItmStockLocations Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmStockLocations, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 26;

/// Bar Code
Property LOCBarCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = LOC_BarCode ];

/// Childsub
Property LOCChildsub As %Float [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LOC",0))}, SqlColumnNumber = 2, SqlFieldName = LOC_Childsub ];

/// Code
Property LOCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LOC_Code ];

/// Description
Property LOCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LOC_Desc ];

/// Locations
Property LOCLocations As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LOC_Locations ];

/// INC_Itm Parent Reference
Relationship LOCParRef As INCItm [ Cardinality = parent, Inverse = ChildINCItmStockLocations, Required, SqlFieldName = LOC_ParRef ];

/// StockTakeGroup
Property LOCStockTakeGroup As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LOC_StockTakeGroup ];

Index RowIDBasedIDKeyIndex On LOCChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmStockLocations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmStockLocations","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmStockLocations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmStockLocations","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmStockLocations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmStockLocations","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmStockLocations).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmStockLocations","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
	d VALINS^at1618
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmStockLocations).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmStockLocations","OnBeforeUpdate")
 
 d VALUPD^at1618
}

Storage SQLStorage
{
<ExtentSize>26</ExtentSize>
<Property name="LOCBarCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOCChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="LOCCode">
<Selectivity>5.5556%</Selectivity>
</Property>
<Property name="LOCDesc">
<Selectivity>5.5556%</Selectivity>
</Property>
<Property name="LOCLocations">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="LOCParRef">
<Selectivity>5.5556%</Selectivity>
</Property>
<Property name="LOCStockTakeGroup">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="LOC_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LOC_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LOC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LOC_Locations">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOC_StockTakeGroup">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StLocCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Locations}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LOC_BarCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StLocCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Locations}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LOC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StLocDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Locations}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LOC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTGDesc">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STGLocDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Locations}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_StockTakeGroup}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({LOC_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTGroupBarCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STGLocCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Locations}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_StockTakeGroup}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({LOC_BarCode})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTKGroupCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STGLocCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Locations}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_StockTakeGroup}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({LOC_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOC_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmStockLocationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
