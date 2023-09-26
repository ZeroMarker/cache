/// Loc Transport(2330)
Class User.CTLocTransport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocTransport, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TRANSPChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Loc Parent Reference
Relationship TRANSPParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocTransport, Required, SqlFieldName = TRANSP_ParRef ];

/// Childsub
Property TRANSPChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRANSP",0))}, SqlColumnNumber = 2, SqlFieldName = TRANSP_Childsub ];

/// Des Ref Transport
Property TRANSPTransportDR As RBCAppointTransport [ SqlColumnNumber = 3, SqlFieldName = TRANSP_Transport_DR ];

/// Date From
Property TRANSPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = TRANSP_DateFrom ];

/// Date To
Property TRANSPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = TRANSP_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocTransport).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocTransport","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocTransport).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocTransport","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocTransport).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocTransport","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocTransport).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocTransport","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocTransport).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocTransport","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocTransport","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="TRANSPChildsub">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="TRANSPDateFrom">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="TRANSPDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="TRANSPParRef">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="TRANSPTransportDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="TRANSP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANSP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANSP_Transport_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRANSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRANSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANSP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTransp">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>TRANSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRANSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Tr"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANSP_Transport_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRANSP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRANSP_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocTransportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
