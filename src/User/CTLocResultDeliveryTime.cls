/// CT Loc Result Delivery Time(1700)
Class User.CTLocResultDeliveryTime Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Loc_ResultDeliveryTime, StorageStrategy = SQLStorage ]
{

/// Childsub
Property RDTChildsub As %Float [ InitialExpression = {$i(^CTLOC($p(%d(0),$c(1)),"RDT",0))}, SqlColumnNumber = 2, SqlFieldName = RDT_Childsub ];

/// Closing Time
Property RDTClosingTime As %Time [ SqlColumnNumber = 7, SqlFieldName = RDT_ClosingTime ];

/// Des Ref DOW
Property RDTDOWDR As CTDayOfWeek [ SqlColumnNumber = 5, SqlFieldName = RDT_DOW_DR ];

/// Date From
Property RDTDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = RDT_DateFrom ];

/// Date To
Property RDTDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = RDT_DateTo ];

/// Opening Time
Property RDTOpeningTime As %Time [ SqlColumnNumber = 6, SqlFieldName = RDT_OpeningTime ];

/// CT_Loc Parent Reference
Relationship RDTParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocResultDeliveryTime, Required, SqlFieldName = RDT_ParRef ];

Index RowIDBasedIDKeyIndex On RDTChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocResultDeliveryTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocResultDeliveryTime","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocResultDeliveryTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocResultDeliveryTime","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocResultDeliveryTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocResultDeliveryTime","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocResultDeliveryTime).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocResultDeliveryTime","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocResultDeliveryTime).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocResultDeliveryTime","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RDT_ClosingTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RDT_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RDT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RDT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RDT_OpeningTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RDT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RDT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RDT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RDT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RDT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RDT_DOW_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RDT_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RDT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RDT_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocResultDeliveryTimeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
