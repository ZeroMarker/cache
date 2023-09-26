/// Microfilm Roll(2435)
Class User.OEMicrofilmRoll Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_MicrofilmRoll, StorageStrategy = SQLStorage ]
{

Relationship ChildOEMicrofilmRollPosition As OEMicrofilmRollPosition [ Cardinality = children, Inverse = POSParRef ];

/// Roll
Property OEMFRoll As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OEMF_Roll ];

/// Roll ID
Property OEMFRollID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OEMF_RollID ];

/// Roll Description
Property OEMFRollDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OEMF_RollDesc ];

/// Des Ref Hospital
Property OEMFHospitalDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = OEMF_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEMicrofilmRoll).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRoll","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEMicrofilmRoll).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRoll","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEMicrofilmRoll).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRoll","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEMicrofilmRoll).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRoll","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEMicrofilmRoll).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRoll","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEMF(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="OEMF_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OEMF_Roll">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OEMF_RollDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OEMF_RollID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEMF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OEMF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OEMF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEMF_RowId</SqlRowIdName>
<StreamLocation>^User.OEMicrofilmRollS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
