/// ServicesLeaflet(2659)
Class User.RBCServicesLeaflet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_ServicesLeaflet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LFTChildsub [ IdKey, PrimaryKey, Unique ];

/// RBC_Services Parent Reference
Relationship LFTParRef As RBCServices [ Cardinality = parent, Inverse = ChildRBCServicesLeaflet, Required, SqlFieldName = LFT_ParRef ];

/// Childsub
Property LFTChildsub As %Float [ InitialExpression = {$i(^RBC("SER",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LFT",0))}, SqlColumnNumber = 2, SqlFieldName = LFT_Childsub ];

/// Des Ref Leaflet
Property LFTLeafletDR As RBCLeafletType [ SqlColumnNumber = 3, SqlFieldName = LFT_Leaflet_DR ];

/// DateFrom
Property LFTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = LFT_DateFrom ];

/// DateTo
Property LFTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = LFT_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCServicesLeaflet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServicesLeaflet","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCServicesLeaflet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServicesLeaflet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCServicesLeaflet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServicesLeaflet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCServicesLeaflet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServicesLeaflet","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCServicesLeaflet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServicesLeaflet","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="LFT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LFT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LFT_Leaflet_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_Services.SER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LFT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_Services.SER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LFT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LFT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLeaflet">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_Services.SER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LFT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_Services.SER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LFT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Leaflet"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LFT_Leaflet_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LFT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LFT_RowId</SqlRowIdName>
<StreamLocation>^User.RBCServicesLeafletS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
