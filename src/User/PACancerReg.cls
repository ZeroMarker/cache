/// Cancer Registration(2227)
Class User.PACancerReg Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CancerReg, StorageStrategy = SQLStorage ]
{

Relationship ChildPACancerRegLinkAdm As PACancerRegLinkAdm [ Cardinality = children, Inverse = ADMParRef ];

/// Des Ref Person
Property PACRPersonDR As PAPerson [ SqlColumnNumber = 2, SqlFieldName = PACR_Person_DR ];

/// Autopsy Held
Property PACRAutopsyHeld As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 3, SqlFieldName = PACR_AutopsyHeld ];

/// Cause Of Death
Property PACRCauseOfDeath As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PACR_CauseOfDeath ];

/// RegNumber
Property PACRRegNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PACR_RegNumber ];

/// Description
Property PACRDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PACR_Description ];

/// RegDate
Property PACRRegDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PACR_RegDate ];

/// Extract Date
Property PACRExtractDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PACR_ExtractDate ];

/// Extract Needed
Property PACRExtractNeeded As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PACR_ExtractNeeded ];

/// UpdateDate
Property PACRUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PACR_UpdateDate ];

/// UpdateTime
Property PACRUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PACR_UpdateTime ];

/// Des Ref UpdateUser
Property PACRUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = PACR_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property PACRUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 13, SqlFieldName = PACR_UpdateUserHospital_DR ];

/// LifetimeOccupation
Property PACRLifetimeOccupation As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PACR_LifetimeOccupation ];

/// Active
Property PACRActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PACR_Active ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACancerReg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerReg","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACancerReg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerReg","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACancerReg).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerReg","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACancerReg).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerReg","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACancerReg).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerReg","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PACR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PACR_Active">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PACR_AutopsyHeld">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PACR_CauseOfDeath">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PACR_Description">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PACR_ExtractDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PACR_ExtractNeeded">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PACR_LifetimeOccupation">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PACR_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PACR_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PACR_RegNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PACR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PACR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PACR_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PACR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^PACR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PACR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PACR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^PACRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PACR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PACR_Person_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PACR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdDate">
<Global>^PACRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PACR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PACR_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PACR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexextractdate">
<Global>^PACRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PACR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PACR_ExtractDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PACR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexextractneeded">
<Condition>{PACR_ExtractNeeded}["Y"</Condition>
<ConditionFields>PACR_ExtractNeeded</ConditionFields>
<Global>^PACRi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PACR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtrNeeded"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PACR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PACR_RowId</SqlRowIdName>
<StreamLocation>^User.PACancerRegS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
