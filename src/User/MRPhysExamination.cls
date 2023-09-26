/// MR Physical Examination(MRPHE,1082)
Class User.MRPhysExamination Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PhysExamination, StorageStrategy = SQLStorage ]
{

/// Des Ref BodyArea
Property PHYSBodyAreaDR As MRCBodyArea [ SqlColumnNumber = 12, SqlFieldName = PHYS_BodyArea_DR ];

/// Des Ref BodyProbStat
Property PHYSBodyProbStatDR As MRCBodySystemProbStatus [ SqlColumnNumber = 11, SqlFieldName = PHYS_BodyProbStat_DR ];

/// Des Ref CTCP
Property PHYSCTCPDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = PHYS_CTCP_DR ];

/// Childsub
Property PHYSChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PHYS",0))}, SqlColumnNumber = 2, SqlFieldName = PHYS_Childsub ];

/// Date
Property PHYSDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = PHYS_Date ];

/// Description
Property PHYSDesc As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PHYS_Desc, SqlListType = SUBNODE ];

/// Des Ref to MRCBodyAreaProb
Property PHYSMRCBodyAreProbDR As MRCBodyAreaProblems [ SqlColumnNumber = 3, SqlFieldName = PHYS_MRCBodyAreProb_DR ];

/// Des Ref to MRCBodyAreaProbSub
Property PHYSMRCBodyAreaProbSubDR As MRCBodyAreaProblemsSubp [ SqlColumnNumber = 9, SqlFieldName = PHYS_MRCBodyAreaProbSub_DR ];

/// MR_Adm Parent Reference
Relationship PHYSParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRPhysExamination, Required, SqlFieldName = PHYS_ParRef ];

/// Time
Property PHYSTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = PHYS_Time ];

/// UpdateDate
Property PHYSUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = PHYS_UpdateDate ];

/// Des Ref UpdateHospital
Property PHYSUpdateHospitalDR As CTHospital [ SqlColumnNumber = 15, SqlFieldName = PHYS_UpdateHospital_DR ];

/// UpdateTime
Property PHYSUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = PHYS_UpdateTime ];

/// Des Ref User
Property PHYSUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = PHYS_UpdateUser_DR ];

Index RowIDBasedIDKeyIndex On PHYSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 53;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPhysExamination).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPhysExamination","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPhysExamination).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPhysExamination","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPhysExamination).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPhysExamination","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPhysExamination).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPhysExamination","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPhysExamination).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPhysExamination","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>53</ExtentSize>
<Property name="PHYSBodyAreaDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSBodyProbStatDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSCTCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSMRCBodyAreProbDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSMRCBodyAreaProbSubDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSUpdateHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHYSUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PHYS_BodyArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHYS_BodyProbStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHYS_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHYS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHYS_Desc">
<Node>"REM"</Node>
</Data>
<Data name="PHYS_MRCBodyAreProb_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHYS_MRCBodyAreaProbSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHYS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHYS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHYS_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHYS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHYS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHYS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHYS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHYS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHYS_RowId</SqlRowIdName>
<StreamLocation>^User.MRPhysExaminationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
