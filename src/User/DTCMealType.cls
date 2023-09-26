/// Meal Type(1139)
Class User.DTCMealType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DTC_MealType, StorageStrategy = SQLStorage ]
{

/// Code
Property MEALTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = MEALT_Code ];

/// Description
Property MEALTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = MEALT_Desc ];

/// Meal Time
Property MEALTTime As %Time [ SqlColumnNumber = 4, SqlFieldName = MEALT_Time ];

/// Cut Off Time
Property MEALTCutOffTime As %Time [ SqlColumnNumber = 5, SqlFieldName = MEALT_CutOffTime ];

/// Main Meal
Property MEALTMainMeal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = MEALT_MainMeal ];

/// CutOffBulkTime
Property MEALTCutOffBulkTime As %Time [ SqlColumnNumber = 7, SqlFieldName = MEALT_CutOffBulkTime ];

/// Des Ref Hospital
Property MEALTHospitalDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = MEALT_Hospital_DR ];

/// Des Ref Location
Property MEALTLocationDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = MEALT_Location_DR ];

/// Color
Property MEALTColor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MEALT_Color ];

Index MEALTCodeUnqIdx1 On MEALTCode [ Unique ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.DTCMealType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTCMealType","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.DTCMealType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTCMealType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.DTCMealType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTCMealType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.DTCMealType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTCMealType","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.DTCMealType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTCMealType","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DTCMealType","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>8</ExtentSize>
<Property name="MEALTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="MEALTColor">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="MEALTCutOffBulkTime">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="MEALTCutOffTime">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="MEALTDesc">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="MEALTHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MEALTLocationDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MEALTMainMeal">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MEALTTime">
<Selectivity>12.5000%</Selectivity>
</Property>
<SqlIdExpression>$i(^DTC("MEALT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MEALT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEALT_Color">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEALT_CutOffBulkTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEALT_CutOffTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEALT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEALT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEALT_Location_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEALT_MainMeal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEALT_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MEALT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MEALT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MEALT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEALT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MEALT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MEALT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEALT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEALT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MEALT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MEALT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEALT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MEALT_RowId</SqlRowIdName>
<StreamLocation>^User.DTCMealTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
