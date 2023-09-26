/// MR Adm Input/Output(1048)
Class User.MRInputOutput Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_InputOutput, StorageStrategy = SQLStorage ]
{

/// Aspiration
Property INPOUTAspiration As %Float [ SqlColumnNumber = 12, SqlFieldName = INPOUT_Aspiration ];

/// Blood
Property INPOUTBlood As %Float [ SqlColumnNumber = 7, SqlFieldName = INPOUT_Blood ];

/// Des Ref CTCP
Property INPOUTCTCPDR As CTCareProv [ SqlColumnNumber = 17, SqlFieldName = INPOUT_CTCP_DR ];

/// Childsub
Property INPOUTChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),$c(1)),"INP",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INPOUT_Childsub ];

/// Date
Property INPOUTDate As %Date [ SqlColumnNumber = 4, SqlFieldName = INPOUT_Date ];

/// Drainage
Property INPOUTDrainage As %Float [ SqlColumnNumber = 10, SqlFieldName = INPOUT_Drainage ];

/// End Date
Property INPOUTEndDate As %Date [ SqlColumnNumber = 19, SqlFieldName = INPOUT_EndDate ];

/// End Time
Property INPOUTEndTime As %Time [ SqlColumnNumber = 18, SqlFieldName = INPOUT_EndTime ];

/// I/O Balance
Property INPOUTIOBalance As %Float [ SqlColumnNumber = 15, SqlComputeCode = { s {INPOUT_IOBalance}={INPOUT_TotalIntake}-{INPOUT_TotalOutput}
}, SqlComputed, SqlFieldName = INPOUT_IOBalance, Transient ];

/// IV Intake
Property INPOUTIVIntake As %Float [ SqlColumnNumber = 6, SqlFieldName = INPOUT_IVIntake ];

/// Oral Intake
Property INPOUTOralIntake As %Float [ SqlColumnNumber = 5, SqlFieldName = INPOUT_OralIntake ];

/// Admin. Order State Des Ref to OECOrdSt
Property INPOUTOrderStatDR As OECOrderAdminStatus [ SqlColumnNumber = 16, SqlFieldName = INPOUT_OrderStat_DR ];

/// MR_Adm Parent Reference
Relationship INPOUTParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRInputOutput, Required, SqlFieldName = INPOUT_ParRef ];

/// Shift
Property INPOUTShift As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = INPOUT_Shift ];

/// Stool
Property INPOUTStool As %Float [ SqlColumnNumber = 13, SqlFieldName = INPOUT_Stool ];

/// Time
Property INPOUTTime As %Time [ SqlColumnNumber = 3, SqlFieldName = INPOUT_Time ];

/// Total Intake
Property INPOUTTotalIntake As %Float [ SqlColumnNumber = 8, SqlComputeCode = { s {INPOUT_TotalIntake}={INPOUT_OralIntake}+{INPOUT_IVIntake}+{INPOUT_Blood}
}, SqlComputed, SqlFieldName = INPOUT_TotalIntake, Transient ];

/// Total Output
Property INPOUTTotalOutput As %Float [ SqlColumnNumber = 14, SqlComputeCode = { s {INPOUT_TotalOutput}={INPOUT_UrineOutput}+{INPOUT_Drainage}+{INPOUT_Vomit}+{INPOUT_Aspiration}+{INPOUT_Stool}
}, SqlComputed, SqlFieldName = INPOUT_TotalOutput, Transient ];

/// UpdateDate
Property INPOUTUpdateDate As %Date [ SqlColumnNumber = 21, SqlFieldName = INPOUT_UpdateDate ];

/// UpdateTime
Property INPOUTUpdateTime As %Time [ SqlColumnNumber = 22, SqlFieldName = INPOUT_UpdateTime ];

/// DEs REf User
Property INPOUTUpdateUserDR As SSUser [ SqlColumnNumber = 23, SqlFieldName = INPOUT_UpdateUser_DR ];

/// Urine Output
Property INPOUTUrineOutput As %Float [ SqlColumnNumber = 9, SqlFieldName = INPOUT_UrineOutput ];

/// Vomit
Property INPOUTVomit As %Float [ SqlColumnNumber = 11, SqlFieldName = INPOUT_Vomit ];

Index RowIDBasedIDKeyIndex On INPOUTChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRInputOutput).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRInputOutput","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRInputOutput).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRInputOutput","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRInputOutput).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRInputOutput","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRInputOutput).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRInputOutput","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRInputOutput).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRInputOutput","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INPOUT_Aspiration">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPOUT_Blood">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPOUT_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INPOUT_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPOUT_Drainage">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPOUT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INPOUT_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPOUT_IVIntake">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPOUT_OralIntake">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPOUT_OrderStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPOUT_Shift">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INPOUT_Stool">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPOUT_Time">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPOUT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INPOUT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INPOUT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INPOUT_UrineOutput">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INPOUT_Vomit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INPOUT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPOUT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INPOUT_RowId</SqlRowIdName>
<StreamLocation>^User.MRInputOutputS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
