/// OE Order Entry          (OEORN,121)
Class User.OEOrdEnt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdEnt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OEORNChildsub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to OEORD
Relationship OEORNOEORDParRef As OEOrder [ Cardinality = parent, Inverse = ChildOEOrdEnt, Required, SqlFieldName = OEORN_OEORD_ParRef ];

/// OEORN Child Sub (New key)
Property OEORNChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"N",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OEORN_Childsub ];

/// Des Ref to ARCOS
Property OEORNOrdSetsDR As ARCOrdSets [ SqlColumnNumber = 3, SqlFieldName = OEORN_OrdSets_DR ];

/// Type
Property OEORNType As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = OEORN_Type ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdEnt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdEnt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdEnt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdEnt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdEnt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdEnt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdEnt).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdEnt","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdEnt).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdEnt","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="OEORNDataMasterMap">
<Data name="OEORN_OrdSets_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OEORN_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OEORN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"N"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OEORN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEORN_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdEntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
