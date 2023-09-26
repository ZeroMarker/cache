/// SS VB Exec Fields(1597)
Class User.SSVBExecFields Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_VBExecFields, StorageStrategy = SQLStorage ]
{

/// Childsub
Property FLDChildsub As %Float [ InitialExpression = {$i(^SS("SSVBE",$p(%d(0),$c(1)),"FLD",0))}, SqlColumnNumber = 2, SqlFieldName = FLD_Childsub ];

/// Description
Property FLDDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = FLD_Desc ];

/// Field
Property FLDField As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = FLD_Field ];

/// Index
Property FLDIndex As %Float [ SqlColumnNumber = 6, SqlFieldName = FLD_Index ];

/// Mandatory
Property FLDMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = FLD_Mandatory ];

/// SS_VBExecutables Parent Reference
Relationship FLDParRef As SSVBExecutables [ Cardinality = parent, Inverse = ChildSSVBExecFields, Required, SqlFieldName = FLD_ParRef ];

/// Visible
Property FLDVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 5, SqlFieldName = FLD_Visible ];

Index RowIDBasedIDKeyIndex On FLDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 160;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSVBExecFields).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBExecFields","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSVBExecFields).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBExecFields","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSVBExecFields).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBExecFields","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSVBExecFields).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBExecFields","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSVBExecFields).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBExecFields","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>160</ExtentSize>
<Property name="FLDChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDField">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDIndex">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDMandatory">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="FLDParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDVisible">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="FLD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FLD_Field">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FLD_Index">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FLD_Mandatory">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FLD_Visible">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_VBExecutables.SSVBE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>FLD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSVBE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_VBExecutables.SSVBE_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FLD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FLD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexField">
<Global>^SS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_VBExecutables.SSVBE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>FLD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSVBE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_VBExecutables.SSVBE_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FLD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Field"</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({FLD_Field})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{FLD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FLD_RowId</SqlRowIdName>
<StreamLocation>^User.SSVBExecFieldsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
