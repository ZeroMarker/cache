/// Anaesthesia Agent(1002)
Class User.ORCAnaestAgent Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_AnaestAgent, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ANAGNARCIMDR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ANAGN_ARCIM_DR ];

/// An. Agent Code
Property ANAGNCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ANAGN_Code ];

/// An.Agent Description
Property ANAGNDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ANAGN_Desc ];

/// Des Ref Method
Property ANAGNMethodDR As ORCAnaestMethod [ SqlColumnNumber = 5, SqlFieldName = ANAGN_Method_DR ];

Index ANAGNCodeUnqIdx1 On ANAGNCode [ Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCAnaestAgent).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestAgent","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCAnaestAgent).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestAgent","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCAnaestAgent).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestAgent","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCAnaestAgent).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestAgent","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCAnaestAgent).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestAgent","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="ANAGNARCIMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANAGNCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANAGNDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANAGNMethodDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^ORC("ANAGN",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANAGN_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANAGN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANAGN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANAGN_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANAGN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANAGN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANAGN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANAGN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANAGN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ANAGN_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANAGN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANAGN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANAGN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ANAGN_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANAGN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANAGN_RowId</SqlRowIdName>
<StreamLocation>^User.ORCAnaestAgentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
