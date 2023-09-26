/// Loc Interpreter(2331)
Class User.CTLocInterpreter Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocInterpreter, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INTERPChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Loc Parent Reference
Relationship INTERPParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocInterpreter, Required, SqlFieldName = INTERP_ParRef ];

/// Childsub
Property INTERPChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INTERP",0))}, SqlColumnNumber = 2, SqlFieldName = INTERP_Childsub ];

/// Des Ref Interpreter
Property INTERPInterpreterDR As PACInterpreter [ SqlColumnNumber = 3, SqlFieldName = INTERP_Interpreter_DR ];

/// Date From
Property INTERPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = INTERP_DateFrom ];

/// Date To
Property INTERPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = INTERP_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocInterpreter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocInterpreter","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocInterpreter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocInterpreter","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocInterpreter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocInterpreter","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocInterpreter).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocInterpreter","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocInterpreter).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocInterpreter","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocInterpreter","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>11</ExtentSize>
<Property name="INTERPChildsub">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTERPDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTERPDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTERPInterpreterDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTERPParRef">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="INTERP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTERP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTERP_Interpreter_DR">
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
<Field>INTERP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INTERP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTERP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInterpreter">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INTERP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INTERP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Int"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTERP_Interpreter_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTERP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INTERP_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocInterpreterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
