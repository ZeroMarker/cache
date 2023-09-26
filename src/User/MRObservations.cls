/// MR Observations(1712)
Class User.MRObservations Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Observations, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OBSChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRObservationsAudit As MRObservationsAudit [ Cardinality = children, Inverse = VALParRef ];

/// MR_Adm Parent Reference
Relationship OBSParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRObservations, Required, SqlFieldName = OBS_ParRef ];

/// Childsub
Property OBSChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"OBS",0))}, SqlColumnNumber = 2, SqlFieldName = OBS_Childsub ];

/// Des Ref Observ Item
Property OBSItemDR As MRCObservationItem [ SqlColumnNumber = 3, SqlFieldName = OBS_Item_DR ];

/// Value
Property OBSValue As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OBS_Value ];

/// Date
Property OBSDate As %Date [ SqlColumnNumber = 5, SqlFieldName = OBS_Date ];

/// Time
Property OBSTime As %Time [ SqlColumnNumber = 6, SqlFieldName = OBS_Time ];

/// Des Ref User
Property OBSUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = OBS_User_DR ];

/// Short Description
Property OBSShortDesc As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = OBS_ShortDesc ];

/// Long Description
Property OBSLongDescription As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = OBS_LongDescription, SqlListType = SUBNODE ];

/// Verified
Property OBSVerified As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = OBS_Verified ];

/// Collection Status
Property OBSCollectionStatus As %String(DISPLAYLIST = ",Resumed,Suspended", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",R,S") [ SqlColumnNumber = 11, SqlFieldName = OBS_CollectionStatus ];

/// Des Ref OEExec
Property OBSOEExecDR As OEOrdExec [ SqlColumnNumber = 12, SqlFieldName = OBS_OEExec_DR ];

/// Des Ref OBSStatus
Property OBSOBSStatusDR As MRCObservationStatus [ SqlColumnNumber = 13, SqlFieldName = OBS_OBSStatus_DR ];

/// UpdateDate
Property OBSUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = OBS_UpdateDate ];

/// UpdateTime
Property OBSUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = OBS_UpdateTime ];

/// Des Ref UpdateHospital
Property OBSUpdateHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = OBS_UpdateHospital_DR ];

/// Des Ref Consult
Property OBSConsultDR As PAPersonConsultSetCons [ SqlColumnNumber = 17, SqlFieldName = OBS_Consult_DR ];

/// IsPartogram
Property OBSIsPartogram As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = OBS_IsPartogram ];

/// 备注
Property OBSNote As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = OBS_Note ];

/// 来源id
Property OBSSourceId As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = OBS_SourceId ];

/// 来源名称
Property OBSSourceName As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = OBS_SourceName ];

/// CreateDate
Property OBSCreateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = OBS_CreateDate ];

/// CreateTime
Property OBSCreateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = OBS_CreateTime ];

/// 措施
Property OBSMeasure As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = OBS_Measure ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRObservations).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservations","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRObservations).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservations","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRObservations).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservations","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRObservations).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservations","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRObservations).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservations","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservations","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>28660</ExtentSize>
<Property name="OBSChildsub">
<Selectivity>0.0347%</Selectivity>
</Property>
<Property name="OBSCollectionStatus">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OBSConsultDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="OBSDate">
<Selectivity>0.0709%</Selectivity>
</Property>
<Property name="OBSIsPartogram">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OBSItemDR">
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="OBSLongDescription">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OBSOBSStatusDR">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="OBSOEExecDR">
<Selectivity>4.5455%</Selectivity>
</Property>
<Property name="OBSParRef">
<Selectivity>1.5868%</Selectivity>
</Property>
<Property name="OBSShortDesc">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="OBSTime">
<Selectivity>1.0476%</Selectivity>
</Property>
<Property name="OBSUpdateDate">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OBSUpdateHospitalDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="OBSUpdateTime">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="OBSUserDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="OBSValue">
<Selectivity>0.4489%</Selectivity>
</Property>
<Property name="OBSVerified">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OBS_CollectionStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OBS_Consult_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OBS_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OBS_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OBS_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OBS_IsPartogram">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OBS_Item_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OBS_LongDescription">
<Node>"TXT"</Node>
</Data>
<Data name="OBS_Measure">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OBS_Note">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OBS_OBSStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OBS_OEExec_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OBS_ShortDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OBS_SourceId">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OBS_SourceName">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OBS_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OBS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OBS_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OBS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OBS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OBS_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OBS_Verified">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OBS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCons">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS-Cons"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OBS_Consult_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBS_Item_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTime">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateTime"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBS_Time}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTimePartog">
<Condition>{OBS_IsPartogram}["Y"</Condition>
<ConditionFields>OBS_IsPartogram,OBS_Date,OBS_Time</ConditionFields>
<Global>^MR</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateTimePart"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBS_Time}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBS_Item_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBS_Date}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OBS_Time}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexexec">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Exec"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBS_OEExec_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OBS_RowId</SqlRowIdName>
<StreamLocation>^User.MRObservationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
