/// DRGCodingProcedures(2148)
Class User.MRCDRGCodingProcedures Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DRGCodingProcedures, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PROCChildsub As %Float [ InitialExpression = {$i(^MRC("DRGCOD",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PROC",0))}, SqlColumnNumber = 2, SqlFieldName = PROC_Childsub ];

/// Des Ref Operation
Property PROCOperationDR As ORCOperation [ SqlColumnNumber = 3, SqlFieldName = PROC_Operation_DR ];

/// MRC_DRGCoding Parent Reference
Relationship PROCParRef As MRCDRGCoding [ Cardinality = parent, Inverse = ChildMRCDRGCodingProcedures, Required, SqlFieldName = PROC_ParRef ];

Index RowIDBasedIDKeyIndex On PROCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingProcedures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingProcedures","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingProcedures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingProcedures","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingProcedures).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingProcedures","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCDRGCodingProcedures).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingProcedures","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCDRGCodingProcedures).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingProcedures","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="PROCChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PROCOperationDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="PROCParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PROC_Operation_DR">
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
<Field>PROC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCoding.DRGCOD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PROC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPROC">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_DRGCoding.DRGCOD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PROC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCoding.DRGCOD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PROC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PROC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PROC_Operation_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PROC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PROC_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDRGCodingProceduresS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
