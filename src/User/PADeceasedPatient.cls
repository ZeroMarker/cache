/// PA Deceased Patient(1634)
Class User.PADeceasedPatient Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_DeceasedPatient, StorageStrategy = SQLStorage ]
{

Relationship ChildPADeceasedDetails As PADeceasedDetails [ Cardinality = children, Inverse = DETParRef ];

/// Date
Property DECDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DEC_Date ];

/// Des Ref PAPMI
Property DECPAPMIDR As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = DEC_PAPMI_DR ];

/// Time
Property DECTime As %Time [ SqlColumnNumber = 4, SqlFieldName = DEC_Time ];

Parameter EXTENTSIZE = 172;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PADeceasedPatient).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedPatient","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PADeceasedPatient).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedPatient","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PADeceasedPatient).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedPatient","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PADeceasedPatient).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedPatient","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PADeceasedPatient).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedPatient","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>172</ExtentSize>
<Property name="DECDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="DECPAPMIDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DECTime">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PADC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DEC_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEC_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEC_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PADC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DEC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^PADCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DEC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEC_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEC_RowId</SqlRowIdName>
<StreamLocation>^User.PADeceasedPatientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
