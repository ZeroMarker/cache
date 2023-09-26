/// Patient Family            (FAM,101)
Class User.PAFamily Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Family, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FAMChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to PAPMI
Relationship FAMPAPMIParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAFamily, Required, SqlFieldName = FAM_PAPMI_ParRef ];

/// Family Childsub
Property FAMChildSub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"FAM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = FAM_ChildSub ];

/// Des Ref to PAPER
Property FAMPAPERDR As PAPerson [ SqlColumnNumber = 4, SqlFieldName = FAM_PAPER_DR ];

/// Des Ref to CTRLT
Property FAMRelationDR As CTRelation [ Required, SqlColumnNumber = 5, SqlFieldName = FAM_Relation_DR ];

/// Archived Flag
Property FAMRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = FAM_RcFlag ];

/// Des Ref to MRCICDDx
Property FAMMRCICDDR As MRCICDDx [ SqlColumnNumber = 8, SqlFieldName = FAM_MRCICD_DR ];

/// Duration in Days
Property FAMDuratDays As %Float [ SqlColumnNumber = 9, SqlFieldName = FAM_DuratDays ];

/// Duration in Month
Property FAMDuratMonth As %Float [ SqlColumnNumber = 10, SqlFieldName = FAM_DuratMonth ];

/// Duration in Year
Property FAMDuratYear As %Float [ SqlColumnNumber = 11, SqlFieldName = FAM_DuratYear ];

/// Onset Date
Property FAMOnsetDate As %Date [ SqlColumnNumber = 12, SqlFieldName = FAM_OnsetDate ];

/// Description
Property FAMDesc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = FAM_Desc, SqlListType = subnode ];

/// Des Ref CTCP
Property FAMCTCPDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = FAM_CTCP_DR ];

/// Date
Property FAMDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 15, SqlFieldName = FAM_Date ];

/// Time
Property FAMTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 16, SqlFieldName = FAM_Time ];

/// Des Ref User
Property FAMUpdateUserDR As SSUser [ SqlColumnNumber = 17, SqlFieldName = FAM_UpdateUser_DR ];

/// InActive
Property FAMInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = FAM_InActive ];

/// UpdateDate
Property FAMUpdateDate As %Date [ SqlColumnNumber = 19, SqlFieldName = FAM_UpdateDate ];

/// UpdateTime
Property FAMUpdateTime As %Time [ SqlColumnNumber = 20, SqlFieldName = FAM_UpdateTime ];

/// Des Ref UpdateHospital
Property FAMUpdateHospitalDR As CTHospital [ SqlColumnNumber = 21, SqlFieldName = FAM_UpdateHospital_DR ];

/// MRCBodSysProbSub
Property FAMMRCBodSysProbSubDR As MRCBodyPartsSympSubsym [ SqlColumnNumber = 22, SqlFieldName = FAM_MRCBodSysProbSub_DR ];

/// Des Ref MRCBodySysProb
Property FAMMRCBodySysProbDR As MRCBodyPartsSymptoms [ SqlColumnNumber = 23, SqlFieldName = FAM_MRCBodySysProb_DR ];

/// Des Ref MRCBodySys
Property FAMMRCBodySysDR As MRCBodyParts [ SqlColumnNumber = 24, SqlFieldName = FAM_MRCBodySys_DR ];

/// DSReportFlag
Property FAMDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = FAM_DSReportFlag ];

/// Duration
Property FAMDuration As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = FAM_Duration ];

/// DurationDesc
Property FAMDurationDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = FAM_DurationDesc ];

/// ApproxOnsetDate
Property FAMApproxOnsetDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = FAM_ApproxOnsetDate ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAFamily).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamily","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAFamily).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamily","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAFamily).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamily","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAFamily).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamily","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAFamily).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamily","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAFamily","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>36</ExtentSize>
<Property name="FAMApproxOnsetDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FAMCTCPDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="FAMChildSub">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="FAMDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FAMDate">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="FAMDesc">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="FAMDuratDays">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="FAMDuratMonth">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="FAMDuratYear">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="FAMDuration">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="FAMDurationDesc">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="FAMInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FAMMRCBodSysProbSubDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="FAMMRCBodySysDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="FAMMRCBodySysProbDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="FAMMRCICDDR">
<Selectivity>3.7037%</Selectivity>
</Property>
<Property name="FAMOnsetDate">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="FAMPAPERDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="FAMPAPMIParRef">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="FAMRcFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FAMRelationDR">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="FAMTime">
<Selectivity>3.0303%</Selectivity>
</Property>
<Property name="FAMUpdateDate">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="FAMUpdateHospitalDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="FAMUpdateTime">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="FAMUpdateUserDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="DataMasterMapFAM">
<Data name="FAM_ApproxOnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="FAM_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FAM_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="FAM_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FAM_Desc">
<Node>"REM"</Node>
</Data>
<Data name="FAM_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FAM_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FAM_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FAM_Duration">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="FAM_DurationDesc">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="FAM_InActive">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="FAM_MRCBodSysProbSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="FAM_MRCBodySysProb_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="FAM_MRCBodySys_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="FAM_MRCICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FAM_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FAM_PAPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FAM_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FAM_Relation_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FAM_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FAM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="FAM_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="FAM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="FAM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FAM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FAM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FAM_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAPERDR">
<Global>^PAPERDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>FAM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FAM_PAPER_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FAM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FAM_PAPMI_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FAM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FAM_RowId</SqlRowIdName>
<StreamLocation>^User.PAFamilyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
