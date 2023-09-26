/// PA Major Incident(2043)
Class User.PAMajorIncident Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_MajorIncident, StorageStrategy = SQLStorage ]
{

/// Date
Property MIDate As %Date [ SqlColumnNumber = 9, SqlFieldName = MI_Date ];

/// Description
Property MIDescription As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MI_Description ];

/// Location
Property MILocation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MI_Location ];

/// Time
Property MITime As %Time [ SqlColumnNumber = 4, SqlFieldName = MI_Time ];

/// Update Date
Property MIUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = MI_UpdateDate ];

/// Update Time
Property MIUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = MI_UpdateTime ];

/// Des Ref User
Property MIUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = MI_User_DR ];

/// Estimate Number
Property NIEstimateNumber As %Float [ SqlColumnNumber = 5, SqlFieldName = NI_EstimateNumber ];

Parameter EXTENTSIZE = 33;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAMajorIncident).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMajorIncident","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAMajorIncident).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMajorIncident","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAMajorIncident).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMajorIncident","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAMajorIncident).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMajorIncident","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAMajorIncident).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMajorIncident","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>33</ExtentSize>
<Property name="MIDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIDescription">
<Selectivity>1</Selectivity>
</Property>
<Property name="MILocation">
<Selectivity>1</Selectivity>
</Property>
<Property name="MITime">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="MIUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NIEstimateNumber">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAMI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MI_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MI_Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MI_Location">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MI_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MI_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NI_EstimateNumber">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAMI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MI_RowId</SqlRowIdName>
<StreamLocation>^User.PAMajorIncidentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
