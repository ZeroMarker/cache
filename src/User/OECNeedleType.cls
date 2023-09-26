/// Needle Type(1102)
Class User.OECNeedleType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_NeedleType, StorageStrategy = SQLStorage ]
{

/// Code
Property NEDTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = NEDT_Code ];

/// Description
Property NEDTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = NEDT_Desc ];

Index NEDTCodeUnqIdx1 On NEDTCode [ Unique ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECNeedleType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECNeedleType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECNeedleType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECNeedleType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECNeedleType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECNeedleType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECNeedleType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECNeedleType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECNeedleType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECNeedleType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="NEDTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="NEDTDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^OEC("NEDT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NEDT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NEDT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NEDT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NEDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NEDT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NEDT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NEDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NEDT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NEDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NEDT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NEDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NEDT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NEDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NEDT_RowId</SqlRowIdName>
<StreamLocation>^User.OECNeedleTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
