/// Emergency Condition(1155)
Class User.MRCEmergencyCondition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_EmergencyCondition, StorageStrategy = SQLStorage ]
{

/// Code
Property EMCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = EMC_Code ];

/// Date From
Property EMCDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = EMC_DateFrom ];

/// Date To
Property EMCDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = EMC_DateTo ];

/// Description
Property EMCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = EMC_Desc ];

/// Icon Name
Property EMCIconName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EMC_IconName ];

/// Icon Priority
Property EMCIconPriority As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EMC_IconPriority ];

Index EMCCodeUnqIdx1 On EMCCode [ Unique ];

Parameter EXTENTSIZE = 12;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCEmergencyCondition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCEmergencyCondition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCEmergencyCondition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCEmergencyCondition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCEmergencyCondition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCEmergencyCondition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCEmergencyCondition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCEmergencyCondition","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCEmergencyCondition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCEmergencyCondition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>12</ExtentSize>
<Property name="EMCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="EMCDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="EMCDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EMCDesc">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="EMCIconName">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="EMCIconPriority">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^MRC("EMC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EMC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EMC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EMC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EMC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EMC_IconName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EMC_IconPriority">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EMC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EMC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EMC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EMC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EMC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EMC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EMC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EMC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EMC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EMC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EMC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EMC_RowId</SqlRowIdName>
<StreamLocation>^User.MRCEmergencyConditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
