/// Surcharge Code(1110)
Class User.ARCSurchargeCode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SurchargeCode, StorageStrategy = SQLStorage ]
{

Relationship ChildARCSurchAgeDepend As ARCSurchAgeDepend [ Cardinality = children, Inverse = AGEParRef ];

Relationship ChildARCSurchEpisSubtype As ARCSurchEpisSubtype [ Cardinality = children, Inverse = EPISParRef ];

Relationship ChildARCSurchIncremental As ARCSurchIncremental [ Cardinality = children, Inverse = INCRParRef ];

Relationship ChildARCSurchInsSubType As ARCSurchInsSubType [ Cardinality = children, Inverse = INSParRef ];

Relationship ChildARCSurchSpecialist As ARCSurchSpecialist [ Cardinality = children, Inverse = SPECParRef ];

Relationship ChildARCSurchTimeDepend As ARCSurchTimeDepend [ Cardinality = children, Inverse = TIMEParRef ];

/// Code
Property SURCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SURC_Code ];

/// Description
Property SURCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SURC_Desc ];

/// Name of Extrinsic
Property SURCExtrinsic As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SURC_Extrinsic ];

/// Fixed Amount
Property SURCFixed As %Float [ SqlColumnNumber = 9, SqlFieldName = SURC_Fixed ];

/// Increment Price
Property SURCIncrementPrice As %Float [ SqlColumnNumber = 8, SqlFieldName = SURC_IncrementPrice ];

/// Increment Time
Property SURCIncrementTime As %Float [ SqlColumnNumber = 7, SqlFieldName = SURC_IncrementTime ];

/// Percentage Surcharge
Property SURCPercentage As %Float [ SqlColumnNumber = 10, SqlFieldName = SURC_Percentage ];

/// Time From
Property SURCTimeFrom As %Float [ SqlColumnNumber = 5, SqlFieldName = SURC_TimeFrom ];

/// Time Until
Property SURCTimeUntil As %Float [ SqlColumnNumber = 6, SqlFieldName = SURC_TimeUntil ];

Index SURCCodeUnqIdx1 On SURCCode [ Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSurchargeCode).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchargeCode","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSurchargeCode).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchargeCode","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSurchargeCode).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchargeCode","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSurchargeCode).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchargeCode","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSurchargeCode).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchargeCode","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="SURCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SURCDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SURCExtrinsic">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SURCFixed">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SURCIncrementPrice">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SURCIncrementTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SURCPercentage">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SURCTimeFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SURCTimeUntil">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("SURC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SURC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SURC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SURC_Extrinsic">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SURC_Fixed">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SURC_IncrementPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SURC_IncrementTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SURC_Percentage">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SURC_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SURC_TimeUntil">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SURC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SURC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SURC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SURC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SURC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SURC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SURC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SURC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SURC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSurchargeCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
