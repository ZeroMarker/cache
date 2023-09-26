/// ARC Qty Allowed Per Period(1115)
Class User.ARCQtyAllowed Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_QtyAllowed, StorageStrategy = SQLStorage ]
{

/// Code
Property QTYALCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = QTYAL_Code ];

/// Description
Property QTYALDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = QTYAL_Desc ];

/// InPatient
Property QTYALInPat As %Float [ SqlColumnNumber = 6, SqlFieldName = QTYAL_InPat ];

/// OutPatient
Property QTYALOutPat As %Float [ SqlColumnNumber = 7, SqlFieldName = QTYAL_OutPat ];

/// Time Period
Property QTYALPeriod As %String(DISPLAYLIST = ",Year,Month,Week,Day,Treatment", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",Y,M,W,D,T") [ SqlColumnNumber = 4, SqlFieldName = QTYAL_Period ];

/// Total
Property QTYALTotal As %Float [ SqlColumnNumber = 5, SqlFieldName = QTYAL_Total ];

Index QTYALCodeUnqIdx1 On QTYALCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCQtyAllowed).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCQtyAllowed","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCQtyAllowed).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCQtyAllowed","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCQtyAllowed).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCQtyAllowed","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCQtyAllowed).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCQtyAllowed","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCQtyAllowed).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCQtyAllowed","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("QTYAL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="QTYAL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTYAL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QTYAL_InPat">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QTYAL_OutPat">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QTYAL_Period">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QTYAL_Total">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>QTYAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QTYAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QTYAL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QTYAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QTYAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QTYAL_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QTYAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QTYAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QTYAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QTYAL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QTYAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QTYAL_RowId</SqlRowIdName>
<StreamLocation>^User.ARCQtyAllowedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
