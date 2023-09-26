/// Meal Order(2171)
Class User.DTMealOrder Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DT_MealOrder, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ORDARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = ORD_ARCIM_DR ];

/// Des Ref CTLOC
Property ORDCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = ORD_CTLOC_DR ];

/// Date
Property ORDDate As %Date [ SqlColumnNumber = 2, SqlFieldName = ORD_Date ];

/// Des Ref MealType
Property ORDMealTypeDR As DTCMealType [ SqlColumnNumber = 4, SqlFieldName = ORD_MealType_DR ];

/// Qty
Property ORDQty As %Float [ SqlColumnNumber = 6, SqlFieldName = ORD_Qty ];

Parameter EXTENTSIZE = 80;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DTMealOrder).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTMealOrder","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DTMealOrder).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTMealOrder","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DTMealOrder).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTMealOrder","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DTMealOrder).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTMealOrder","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DTMealOrder).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTMealOrder","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>80</ExtentSize>
<Property name="ORDARCIMDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ORDCTLOCDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="ORDDate">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="ORDMealTypeDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ORDQty">
<Selectivity>6.2500%</Selectivity>
</Property>
<SqlIdExpression>$i(^DT("ORD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ORD_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ORD_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORD_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORD_MealType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ORD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORD_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORD_RowId</SqlRowIdName>
<StreamLocation>^User.DTMealOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
