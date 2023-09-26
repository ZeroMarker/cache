/// MR Observations Audit(1713)
Class User.MRObservationsAudit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ObservationsAudit, StorageStrategy = SQLStorage ]
{

/// Childsub
Property VALChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),"||"),"OBS",$p(%d(0),"||",2),"VAL",0))}, SqlColumnNumber = 2, SqlFieldName = VAL_Childsub ];

/// Date
Property VALDate As %Date [ SqlColumnNumber = 3, SqlFieldName = VAL_Date ];

/// MR_Observations Parent Reference
Relationship VALParRef As MRObservations [ Cardinality = parent, Inverse = ChildMRObservationsAudit, Required, SqlFieldName = VAL_ParRef ];

/// Time
Property VALTime As %Time [ SqlColumnNumber = 4, SqlFieldName = VAL_Time ];

/// Des Ref User
Property VALUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = VAL_User_DR ];

/// Value
Property VALValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = VAL_Value ];

Index RowIDBasedIDKeyIndex On VALChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRObservationsAudit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRObservationsAudit","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRObservationsAudit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRObservationsAudit","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRObservationsAudit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRObservationsAudit","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRObservationsAudit).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRObservationsAudit","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRObservationsAudit).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRObservationsAudit","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="VALChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="VALDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="VALParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="VALTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="VALUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="VALValue">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="VAL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VAL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VAL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VAL_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_Observations.OBS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>VAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Observations.OBS_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"VAL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VAL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VAL_RowId</SqlRowIdName>
<StreamLocation>^User.MRObservationsAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
