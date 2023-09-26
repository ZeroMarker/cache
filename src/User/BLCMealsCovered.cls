/// BLC Meals Covered(1202)
Class User.BLCMealsCovered Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_MealsCovered, StorageStrategy = SQLStorage ]
{

/// Date From
Property MEALCDateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = MEALC_DateFrom ];

/// Date To
Property MEALCDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = MEALC_DateTo ];

/// Not Used Diet Type
Property MEALCDietType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MEALC_DietType ];

/// Des Ref InsType_DR
Property MEALCInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = MEALC_InsType_DR ];

/// Number of Meals
Property MEALCNumberofMeals As %Float [ SqlColumnNumber = 5, SqlFieldName = MEALC_Number_of_Meals ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCMealsCovered).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMealsCovered","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCMealsCovered).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMealsCovered","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCMealsCovered).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMealsCovered","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCMealsCovered).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMealsCovered","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCMealsCovered).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMealsCovered","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="MEALCDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MEALCDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MEALCDietType">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MEALCInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MEALCNumberofMeals">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("MEALC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MEALC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEALC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEALC_DietType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEALC_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEALC_Number_of_Meals">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MEALC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MEALC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MEALC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MEALC_RowId</SqlRowIdName>
<StreamLocation>^User.BLCMealsCoveredS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
