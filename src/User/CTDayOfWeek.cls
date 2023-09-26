/// CT Day Of Week           (DOW,8060)
Class User.CTDayOfWeek Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_DayOfWeek, StorageStrategy = SQLStorage ]
{

/// Checked
Property DOWChecked As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DOW_Checked ];

/// Day (1-Monday, .. 7-Sunday)
Property DOWDay As %Float(MAXVAL = 7, MINVAL = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DOW_Day ];

/// Name of the day (eg. Monday, Tuesday ,...)
Property DOWName As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DOW_Name ];

/// Sequence
Property DOWSequence As %Float [ SqlColumnNumber = 4, SqlFieldName = DOW_Sequence ];

/// Weekend
Property DOWWeekend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DOW_Weekend ];

Index DOWDayUnqIdx1 On DOWDay [ Unique ];

Index RowIDBasedIDKeyIndex On DOWDay [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTDayOfWeek).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTDayOfWeek","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTDayOfWeek).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTDayOfWeek","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTDayOfWeek).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTDayOfWeek","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTDayOfWeek).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTDayOfWeek","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTDayOfWeek).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTDayOfWeek","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="DOWChecked">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DOWDay">
<Selectivity>1</Selectivity>
</Property>
<Property name="DOWName">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="DOWSequence">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="DOWWeekend">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMasterDOW">
<Data name="DOW_Checked">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DOW_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOW_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOW_Weekend">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DOW_Day</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DOW"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>1</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DOW_Day}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DOW_RowId</SqlRowIdName>
<StreamLocation>^User.CTDayOfWeekS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
