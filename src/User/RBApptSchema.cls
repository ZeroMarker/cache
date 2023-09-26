/// ApptSchema(2774)
Class User.RBApptSchema Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptSchema, StorageStrategy = SQLStorage ]
{

Relationship ChildRBApptSchemaAppt As RBApptSchemaAppt [ Cardinality = children, Inverse = APParRef ];

/// Description
Property SCHDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SCH_Desc ];

/// Type
Property SCHType As %String(DISPLAYLIST = ",Occupation,Medical,Preventative", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",O,M,P") [ SqlColumnNumber = 3, SqlFieldName = SCH_Type ];

/// DateFrom
Property SCHDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SCH_DateFrom ];

/// DateTo
Property SCHDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SCH_DateTo ];

/// Number Of Appt
Property SCHNumberOfAppt As %Float [ SqlColumnNumber = 6, SqlFieldName = SCH_NumberOfAppt ];

/// Des Ref Hospital
Property SCHHospitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = SCH_Hospital_DR ];

/// Des Ref CTLOC
Property SCHCTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = SCH_CTLOC_DR ];

/// Code
Property SCHCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SCH_Code ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBApptSchema).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchema","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBApptSchema).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchema","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBApptSchema).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchema","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBApptSchema).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchema","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBApptSchema).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchema","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchema","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="SCHCTLOCDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHNumberOfAppt">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHType">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^RB("SCH",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SCH_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SCH_Code">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SCH_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCH_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SCH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCH_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SCH_NumberOfAppt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SCH_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SCH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SCH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SCH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SCH_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SCH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SCH_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SCH_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptSchemaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
