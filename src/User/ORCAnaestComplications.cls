/// Anaest. Complications(1021)
Class User.ORCAnaestComplications Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_Anaest_Complications, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCOS
Property ANACOMARCOSDR As ARCOrdSets [ SqlColumnNumber = 4, SqlFieldName = ANACOM_ARCOS_DR ];

/// Code
Property ANACOMCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ANACOM_Code ];

/// Description
Property ANACOMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ANACOM_Desc ];

Index ANACOMCodeUnqIdx1 On ANACOMCode [ Unique ];

Parameter EXTENTSIZE = 86;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCAnaestComplications).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestComplications","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCAnaestComplications).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestComplications","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCAnaestComplications).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestComplications","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCAnaestComplications).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestComplications","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCAnaestComplications).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestComplications","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>86</ExtentSize>
<Property name="ANACOMARCOSDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANACOMCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANACOMDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^ORC("COMP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANACOM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANACOM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANACOM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANACOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"COMP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANACOM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANACOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"COMP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ANACOM_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANACOM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANACOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"COMP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ANACOM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANACOM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANACOM_RowId</SqlRowIdName>
<StreamLocation>^User.ORCAnaestComplicationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
