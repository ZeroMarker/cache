/// SNAPCareTypeADLType(2489)
Class User.PACSNAPCareTypeADLType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SNAPCareTypeADLType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADLChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_SNAPCareType Parent Reference
Relationship ADLParRef As PACSNAPCareType [ Cardinality = parent, Inverse = ChildPACSNAPCareTypeADLType, Required, SqlFieldName = ADL_ParRef ];

/// Childsub
Property ADLChildsub As %Float [ InitialExpression = {$i(^PAC("SNAPCT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ADL",0))}, SqlColumnNumber = 2, SqlFieldName = ADL_Childsub ];

/// Des Ref ADLCareType
Property ADLADLCareTypeDR As PACADLCareType [ SqlColumnNumber = 3, SqlFieldName = ADL_ADLCareType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSNAPCareTypeADLType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareTypeADLType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSNAPCareTypeADLType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareTypeADLType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSNAPCareTypeADLType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareTypeADLType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSNAPCareTypeADLType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareTypeADLType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSNAPCareTypeADLType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareTypeADLType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADL_ADLCareType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_SNAPCareType.SNAPCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNAPCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_SNAPCareType.SNAPCT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexADLCareType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_SNAPCareType.SNAPCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ADL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNAPCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_SNAPCareType.SNAPCT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ADLType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADL_ADLCareType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADL_RowId</SqlRowIdName>
<StreamLocation>^User.PACSNAPCareTypeADLTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
