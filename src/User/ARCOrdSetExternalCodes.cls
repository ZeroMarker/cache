/// ARC Ord Set External Codes(1679)
Class User.ARCOrdSetExternalCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetExternalCodes, StorageStrategy = SQLStorage ]
{

/// Des Ref AuxInsType
Property EXAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 6, SqlFieldName = EX_AuxInsType_DR ];

/// Childsub
Property EXChildsub As %Float [ InitialExpression = {$i(^ARCOS($p(%d(0),$c(1)),"EX",0))}, SqlColumnNumber = 2, SqlFieldName = EX_Childsub ];

/// Code
Property EXCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EX_Code ];

/// Date From
Property EXDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = EX_DateFrom ];

/// Date To
Property EXDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = EX_DateTo ];

/// Description
Property EXDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EX_Desc ];

/// Des Ref InsType
Property EXInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 5, SqlFieldName = EX_InsType_DR ];

/// ARC_OrdSets Parent Reference
Relationship EXParRef As ARCOrdSets [ Cardinality = parent, Inverse = ChildARCOrdSetExternalCodes, Required, SqlFieldName = EX_ParRef ];

Index RowIDBasedIDKeyIndex On EXChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetExternalCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetExternalCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetExternalCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetExternalCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetExternalCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetExternalCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCOrdSetExternalCodes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetExternalCodes","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCOrdSetExternalCodes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetExternalCodes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EX_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EX_Code">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EX_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EX_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EX_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EX_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARCOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EX_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EX_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateAuxIns">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EX_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateAuxIns"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EX_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EX_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EX_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateInsType">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EX_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateIns"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EX_InsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EX_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EX_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EX_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetExternalCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
