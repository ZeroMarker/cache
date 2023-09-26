/// PAC Ward Restriction on Avail(2008
Class User.PACWardAvailRestriction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WardAvailRestriction, StorageStrategy = SQLStorage ]
{

/// Childsub
Property AVRChildsub As %Float [ InitialExpression = {$i(^PAWARD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"AVR",0))}, SqlColumnNumber = 2, SqlFieldName = AVR_Childsub ];

/// Date From
Property AVRDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = AVR_DateFrom ];

/// Date To
Property AVRDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = AVR_DateTo ];

/// Friday
Property AVRFriday As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = AVR_Friday ];

/// Monday
Property AVRMonday As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = AVR_Monday ];

/// PAC_Ward Parent Reference
Relationship AVRParRef As PACWard [ Cardinality = parent, Inverse = ChildPACWardAvailRestriction, Required, SqlFieldName = AVR_ParRef ];

/// Des Ref ReasonNotAvail
Property AVRReasonNotAvailDR As PACBedReasonNotAvail [ SqlColumnNumber = 5, SqlFieldName = AVR_ReasonNotAvail_DR ];

/// Saturday
Property AVRSaturday As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = AVR_Saturday ];

/// Sunday
Property AVRSunday As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = AVR_Sunday ];

/// Thursday
Property AVRThursday As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = AVR_Thursday ];

/// Time From
Property AVRTimeFrom As %Time [ SqlColumnNumber = 6, SqlFieldName = AVR_TimeFrom ];

/// Time To
Property AVRTimeTo As %Time [ SqlColumnNumber = 7, SqlFieldName = AVR_TimeTo ];

/// Tuesday
Property AVRTuesday As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = AVR_Tuesday ];

/// Wednesday
Property AVRWednesday As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = AVR_Wednesday ];

Index RowIDBasedIDKeyIndex On AVRChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWardAvailRestriction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardAvailRestriction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWardAvailRestriction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardAvailRestriction","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWardAvailRestriction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardAvailRestriction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWardAvailRestriction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardAvailRestriction","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWardAvailRestriction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardAvailRestriction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="AVRChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRFriday">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRMonday">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRReasonNotAvailDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRSaturday">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRSunday">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRThursday">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRTimeFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRTimeTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRTuesday">
<Selectivity>1</Selectivity>
</Property>
<Property name="AVRWednesday">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="AVR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AVR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AVR_Friday">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AVR_Monday">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AVR_ReasonNotAvail_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AVR_Saturday">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AVR_Sunday">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AVR_Thursday">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AVR_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AVR_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AVR_Tuesday">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AVR_Wednesday">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AVR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AVR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AVR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateFrom">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AVR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AVR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateFrom"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AVR_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AVR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AVR_RowId</SqlRowIdName>
<StreamLocation>^User.PACWardAvailRestrictionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
