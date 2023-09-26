/// DRGCodingEdition(2399)
Class User.MRCDRGCodingEdition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DRGCodingEdition, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EDChildsub As %Float [ InitialExpression = {$i(^MRC("DRGCOD",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ED",0))}, SqlColumnNumber = 2, SqlFieldName = ED_Childsub ];

/// Des Ref Edition
Property EDEditionDR As MRCICDEdition [ SqlColumnNumber = 3, SqlFieldName = ED_Edition_DR ];

/// MRC_DRGCoding Parent Reference
Relationship EDParRef As MRCDRGCoding [ Cardinality = parent, Inverse = ChildMRCDRGCodingEdition, Required, SqlFieldName = ED_ParRef ];

Index RowIDBasedIDKeyIndex On EDChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingEdition).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingEdition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingEdition).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingEdition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingEdition).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingEdition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCDRGCodingEdition).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingEdition","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCDRGCodingEdition).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingEdition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ED_Edition_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_DRGCoding.DRGCOD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCoding.DRGCOD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexedition">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_DRGCoding.DRGCOD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCoding.DRGCOD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Edition"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ED_Edition_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ED_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDRGCodingEditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
