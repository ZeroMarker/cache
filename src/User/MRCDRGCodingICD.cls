/// DRGCodingICD(2149)
Class User.MRCDRGCodingICD Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DRGCodingICD, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ICDChildsub As %Float [ InitialExpression = {$i(^MRC("DRGCOD",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ICD",0))}, SqlColumnNumber = 2, SqlFieldName = ICD_Childsub ];

/// Des Ref ICD
Property ICDICDDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = ICD_ICD_DR ];

/// MRC_DRGCoding Parent Reference
Relationship ICDParRef As MRCDRGCoding [ Cardinality = parent, Inverse = ChildMRCDRGCodingICD, Required, SqlFieldName = ICD_ParRef ];

Index RowIDBasedIDKeyIndex On ICDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingICD).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingICD","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingICD).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingICD","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodingICD).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingICD","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCDRGCodingICD).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingICD","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCDRGCodingICD).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodingICD","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="ICDChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ICDICDDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ICDParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ICD_ICD_DR">
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
<Field>ICD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCoding.DRGCOD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICD">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_DRGCoding.DRGCOD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ICD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGCOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCoding.DRGCOD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ICD_ICD_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ICD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICD_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDRGCodingICDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
