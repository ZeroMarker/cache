/// DT Employee Meals(1373)
Class User.DTEmployeeMeals Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DT_EmployeeMeals, StorageStrategy = SQLStorage ]
{

/// Date of Meal
Property EMPMDate As %Date [ SqlColumnNumber = 2, SqlFieldName = EMPM_Date ];

/// Des Ref EmplJob
Property EMPMEmplJobDR As CTEmpJob [ SqlColumnNumber = 4, SqlFieldName = EMPM_EmplJob_DR ];

/// Des REf MealType
Property EMPMMealTypeDR As DTCMealType [ SqlColumnNumber = 3, SqlFieldName = EMPM_MealType_DR ];

/// Number of employees
Property EMPMNumber As %Float [ SqlColumnNumber = 5, SqlFieldName = EMPM_Number ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DTEmployeeMeals).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTEmployeeMeals","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DTEmployeeMeals).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTEmployeeMeals","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DTEmployeeMeals).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTEmployeeMeals","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DTEmployeeMeals).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTEmployeeMeals","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DTEmployeeMeals).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.DTEmployeeMeals","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DT("EMPM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EMPM_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EMPM_EmplJob_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EMPM_MealType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EMPM_Number">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EMPM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EMPM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EMPM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EMPM_RowId</SqlRowIdName>
<StreamLocation>^User.DTEmployeeMealsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
