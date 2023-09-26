/// Adm SNAP(2437)
Class User.PAAdmSNAP Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmSNAP, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SNAPChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAAdmSNAPDetails As PAAdmSNAPDetails [ Cardinality = children, Inverse = SNAPDParRef ];

/// PA_Adm Parent Reference
Relationship SNAPParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmSNAP, Required, SqlFieldName = SNAP_ParRef ];

/// Childsub
Property SNAPChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SNAP",0))}, SqlColumnNumber = 2, SqlFieldName = SNAP_Childsub ];

/// Date
Property SNAPDate As %Date [ SqlColumnNumber = 3, SqlFieldName = SNAP_Date ];

/// Time
Property SNAPTime As %Time [ SqlColumnNumber = 4, SqlFieldName = SNAP_Time ];

/// Score
Property SNAPScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SNAP_Score ];

/// Phase
Property SNAPPhase As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SNAP_Phase ];

/// Des Ref SNAPCareType
Property SNAPSNAPCareTypeDR As PACSNAPCareType [ SqlColumnNumber = 7, SqlFieldName = SNAP_SNAPCareType_DR ];

/// Des Ref ADLCareType
Property SNAPADLCareTypeDR As PACADLCareType [ SqlColumnNumber = 8, SqlFieldName = SNAP_ADLCareType_DR ];

/// Des Ref ADLSubType
Property SNAPADLSubTypeDR As PACADLSubType [ SqlColumnNumber = 9, SqlFieldName = SNAP_ADLSubType_DR ];

/// Des Ref UpdateUser
Property SNAPUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = SNAP_UpdateUser_DR ];

/// UpdateDate
Property SNAPUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = SNAP_UpdateDate ];

/// UpdateTime
Property SNAPUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = SNAP_UpdateTime ];

/// Des Ref UpdateUserHospital
Property SNAPUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 13, SqlFieldName = SNAP_UpdateUserHospital_DR ];

/// Number
Property SNAPNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = SNAP_Number ];

/// StartDate
Property SNAPStartDate As %Date [ SqlColumnNumber = 15, SqlFieldName = SNAP_StartDate ];

/// EndDate
Property SNAPEndDate As %Date [ SqlColumnNumber = 16, SqlFieldName = SNAP_EndDate ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmSNAP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAP","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmSNAP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAP","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmSNAP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAP","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmSNAP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAP","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmSNAP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAP","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SNAP_ADLCareType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SNAP_ADLSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SNAP_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNAP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SNAP_Number">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SNAP_Phase">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SNAP_SNAPCareType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SNAP_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SNAP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SNAP_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SNAP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SNAP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SNAP_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SNAP_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SNAP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SNAP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SNAP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SNAP_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmSNAPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
