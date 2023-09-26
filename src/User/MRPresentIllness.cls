/// MR Present Illness(1080)
Class User.MRPresentIllness Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PresentIllness, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PRESIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRPresentIllnessKeyw As MRPresentIllnessKeyw [ Cardinality = children, Inverse = KEYWParRef ];

/// MR_Adm Parent Reference
Relationship PRESIParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRPresentIllness, Required, SqlFieldName = PRESI_ParRef ];

/// Childsub
Property PRESIChildsub As %Float [ InitialExpression = {$i(^MR($P($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PRESI",0))}, SqlColumnNumber = 2, SqlFieldName = PRESI_Childsub ];

/// Description
Property PRESIDesc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PRESI_Desc, SqlListType = subnode ];

/// Date
Property PRESIDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PRESI_Date ];

/// Time
Property PRESITime As %Time [ SqlColumnNumber = 5, SqlFieldName = PRESI_Time ];

/// Des Ref CTCP
Property PRESICTCPDR As CTCareProv [ SqlColumnNumber = 6, SqlFieldName = PRESI_CTCP_DR ];

/// Des Ref User
Property PRESIUpdateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = PRESI_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property PRESIUpdateHospitalDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = PRESI_UpdateHospital_DR ];

/// DSReportFlag
Property PRESIDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PRESI_DSReportFlag ];

/// Des Ref DiagnosStatus
Property PRESIDiagnosStatusDR As MRCDiagnosStatus [ SqlColumnNumber = 10, SqlFieldName = PRESI_DiagnosStatus_DR ];

/// Des Ref ICDCode
Property PRESIICDCodeDR As MRCICDDx [ SqlColumnNumber = 11, SqlFieldName = PRESI_ICDCode_DR ];

/// DateOnset
Property PRESIDateOnset As %Date [ SqlColumnNumber = 12, SqlFieldName = PRESI_DateOnset ];

/// Des Ref BodyParts
Property PRESIBodyPartsDR As MRCBodyParts [ SqlColumnNumber = 13, SqlFieldName = PRESI_BodyParts_DR ];

/// Des Ref BodyPartsSymp
Property PRESIBodyPartsSympDR As MRCBodyPartsSymptoms [ SqlColumnNumber = 14, SqlFieldName = PRESI_BodyPartsSymp_DR ];

/// Des Ref BodyPartSymSubs
Property PRESIBodyPartSymSubsDR As MRCBodyPartsSympSubsym [ SqlColumnNumber = 15, SqlFieldName = PRESI_BodyPartSymSubs_DR ];

/// EndDate
Property PRESIEndDate As %Date [ SqlColumnNumber = 16, SqlFieldName = PRESI_EndDate ];

/// Des Ref EditCP
Property PRESIEditCPDR As CTCareProv [ SqlColumnNumber = 17, SqlFieldName = PRESI_EditCP_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRPresentIllness).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllness","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRPresentIllness).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllness","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRPresentIllness).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllness","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRPresentIllness).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllness","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllness","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRPresentIllness).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllness","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PRESI_BodyPartSymSubs_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PRESI_BodyPartsSymp_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PRESI_BodyParts_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRESI_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRESI_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRESI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRESI_DateOnset">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PRESI_Desc">
<Node>"REM"</Node>
</Data>
<Data name="PRESI_DiagnosStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRESI_EditCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PRESI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PRESI_ICDCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRESI_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRESI_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRESI_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PRESI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRESI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRESI_RowId</SqlRowIdName>
<StreamLocation>^User.MRPresentIllnessS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
