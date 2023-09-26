/// Route Admin(2657)
Class User.OECRouteAdmin Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_RouteAdmin, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADMChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_Route Parent Reference
Relationship ADMParRef As OECRoute [ Cardinality = parent, Inverse = ChildOECRouteAdmin, Required, SqlFieldName = ADM_ParRef ];

/// Childsub
Property ADMChildsub As %Float [ InitialExpression = {$i(^OEC("ROUTE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ADM",0))}, SqlColumnNumber = 2, SqlFieldName = ADM_Childsub ];

/// Des Ref AdminRoute
Property ADMAdminRouteDR As PHCAdministrationRoute [ SqlColumnNumber = 3, SqlFieldName = ADM_AdminRoute_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECRouteAdmin).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRouteAdmin","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECRouteAdmin).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRouteAdmin","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECRouteAdmin).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRouteAdmin","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECRouteAdmin).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRouteAdmin","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECRouteAdmin).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECRouteAdmin","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ADM_AdminRoute_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_Route.ROUTE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROUTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_Route.ROUTE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRoute">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_Route.ROUTE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROUTE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_Route.ROUTE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADM_AdminRoute_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADM_RowId</SqlRowIdName>
<StreamLocation>^User.OECRouteAdminS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
