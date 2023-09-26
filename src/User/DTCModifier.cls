/// DTC Modifier(2009)
Class User.DTCModifier Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DTC_Modifier, StorageStrategy = SQLStorage ]
{

/// Code
Property MODIFCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MODIF_Code ];

/// Description
Property MODIFDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MODIF_Desc ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DTCModifier).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTCModifier","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DTCModifier).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTCModifier","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DTCModifier).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTCModifier","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DTCModifier).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTCModifier","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DTCModifier).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTCModifier","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="MODIFCode">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="MODIFDesc">
<Selectivity>10.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^DTC("MODIF",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MODIF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MODIF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MODIF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MODIF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODIF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MODIF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MODIF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MODIF_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MODIF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MODIF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MODIF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MODIF_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MODIF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MODIF_RowId</SqlRowIdName>
<StreamLocation>^User.DTCModifierS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
