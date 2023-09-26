/// MR Clinical Data        (MRCLN,315)
Class User.MRClncData Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ClncData, StorageStrategy = SQLStorage ]
{

/// Blood Pressure Diastolic
Property MRCLNBldPressDias As %Float [ SqlColumnNumber = 4, SqlFieldName = MRCLN_BldPressDias ];

/// Blood Pressure Systolic
Property MRCLNBldPressSyst As %Float [ SqlColumnNumber = 3, SqlFieldName = MRCLN_BldPressSyst ];

/// Body Temperature
Property MRCLNBodyTemp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MRCLN_BodyTemp ];

/// Des Ref to CTPCP
Property MRCLNCTPCPDR As CTCareProv [ InitialExpression = {$g(XCONF("WORKING PROVIDER"))}, SqlColumnNumber = 13, SqlFieldName = MRCLN_CTPCP_DR ];

/// MRCLN Childsub (NewKey)
Property MRCLNChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^MR($p(%d(0),$c(1),1),"CLN",0))}, Required, SqlColumnNumber = 5, SqlFieldName = MRCLN_Childsub ];

/// Date
Property MRCLNDate As %Date [ SqlColumnNumber = 10, SqlFieldName = MRCLN_Date ];

/// DateUpdate
Property MRCLNDateUpdate As %Date [ SqlColumnNumber = 17, SqlFieldName = MRCLN_DateUpdate ];

/// Des Ref to MRADM
Relationship MRCLNMRADMParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRClncData, Required, SqlFieldName = MRCLN_MRADM_ParRef ];

/// Admin Order State Des Ref to OECOrdSt
Property MRCLNOrderState As OECOrderAdminStatus [ SqlColumnNumber = 15, SqlFieldName = MRCLN_OrderState ];

/// Pulse Rate Critical Flag
Property MRCLNPRCrit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MRCLN_PRCrit ];

/// Blood Pressure Critical Flag
Property MRCLNPressCrit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MRCLN_PressCrit ];

/// Pulse Rate
Property MRCLNPulseRate As %Float [ SqlColumnNumber = 6, SqlFieldName = MRCLN_PulseRate ];

/// Respiration Rate
Property MRCLNRespirationRate As %Float [ SqlColumnNumber = 14, SqlFieldName = MRCLN_RespirationRate ];

/// Temperature Critical Flag
Property MRCLNTempCrit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MRCLN_TempCrit ];

/// Time
Property MRCLNTime As %Time [ SqlColumnNumber = 11, SqlFieldName = MRCLN_Time ];

/// TimeUpdate
Property MRCLNTimeUpdate As %Time [ SqlColumnNumber = 18, SqlFieldName = MRCLN_TimeUpdate ];

/// Des Ref User
Property MRCLNUserDR As SSUser [ SqlColumnNumber = 16, SqlFieldName = MRCLN_User_DR ];

Index RowIDBasedIDKeyIndex On MRCLNChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRClncData).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClncData","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRClncData).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClncData","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRClncData).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClncData","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRClncData).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClncData","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRClncData).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRClncData","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MRCLNDataMasterMap">
<Data name="MRCLN_BldPressDias">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRCLN_BldPressSyst">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRCLN_BodyTemp">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRCLN_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRCLN_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRCLN_DateUpdate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MRCLN_OrderState">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MRCLN_PRCrit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRCLN_PressCrit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRCLN_PulseRate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRCLN_RespirationRate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRCLN_TempCrit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRCLN_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRCLN_TimeUpdate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MRCLN_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRCLN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRCLN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRCLN_RowId</SqlRowIdName>
<StreamLocation>^User.MRClncDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
