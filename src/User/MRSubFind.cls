/// Sub Find(Chief Complains MRSUB,304)
Class User.MRSubFind Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_SubFind, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MRSUBChildsub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to MRADM
Relationship MRSUBMRADMParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRSubFind, Required, SqlFieldName = MRSUB_MRADM_ParRef ];

/// MRSUB Childsub (NewKey)
Property MRSUBChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"SUB",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MRSUB_Childsub ];

/// Description of Subjective Findings
Property MRSUBDesc As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MRSUB_Desc, SqlListType = subnode ];

/// Des Ref to CTPCP
Property MRSUBDocCodeDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = MRSUB_DocCode_DR ];

/// Des Ref to MRCBodyParts
Property MRSUBBodyPartsDR As MRCBodyParts [ SqlColumnNumber = 5, SqlFieldName = MRSUB_BodyParts_DR ];

/// Des Ref to MRCBodyPartsSymp
Property MRSUBBodyPartsSympDR As MRCBodyPartsSymptoms [ SqlColumnNumber = 6, SqlFieldName = MRSUB_BodyPartsSymp_DR ];

/// Duration in Years
Property MRSUBDurationYear As %Float [ SqlColumnNumber = 7, SqlFieldName = MRSUB_DurationYear ];

/// Duration in Months
Property MRSUBDurationMonth As %Float [ SqlColumnNumber = 8, SqlFieldName = MRSUB_DurationMonth ];

/// Duration in Days
Property MRSUBDurationDays As %Float [ SqlColumnNumber = 9, SqlFieldName = MRSUB_DurationDays ];

/// Date Started
Property MRSUBDateStarted As %Date [ SqlColumnNumber = 10, SqlFieldName = MRSUB_DateStarted ];

/// Date
Property MRSUBDate As %Date [ SqlColumnNumber = 11, SqlFieldName = MRSUB_Date ];

/// Time
Property MRSUBTime As %Time [ SqlColumnNumber = 12, SqlFieldName = MRSUB_Time ];

/// Des Ref to BodyPartSymSubs
Property MRSUBBodyPartSymSubs As MRCBodyPartsSympSubsym [ SqlColumnNumber = 13, SqlFieldName = MRSUB_BodyPartSymSubs ];

/// Des Ref User
Property MRSUBUserUpdate As SSUser [ SqlColumnNumber = 15, SqlFieldName = MRSUB_UserUpdate ];

/// RTF Notes
Property MRSUBRTFNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MRSUB_RTFNotes, SqlListType = subnode ];

/// Des Ref UpdateHospital
Property MRSUBUpdateHospitalDR As CTHospital [ SqlColumnNumber = 17, SqlFieldName = MRSUB_UpdateHospital_DR ];

/// Update Date
Property MRSUBUpdateDate As %Date [ SqlColumnNumber = 18, SqlFieldName = MRSUB_UpdateDate ];

/// Update Time
Property MRSUBUpdateTime As %Time [ SqlColumnNumber = 19, SqlFieldName = MRSUB_UpdateTime ];

/// DSReportFlag
Property MRSUBDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = MRSUB_DSReportFlag ];

/// Des Ref EditCP
Property MRSUBEditCPDR As CTCareProv [ SqlColumnNumber = 21, SqlFieldName = MRSUB_EditCP_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRSubFind).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubFind","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRSubFind).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubFind","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRSubFind).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubFind","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRSubFind).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubFind","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubFind","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRSubFind).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubFind","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MRSUBDataMasterMap">
<Data name="MRSUB_BodyPartSymSubs">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRSUB_BodyPartsSymp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRSUB_BodyParts_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRSUB_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MRSUB_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRSUB_DateStarted">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRSUB_Desc">
<Node>"DESC"</Node>
</Data>
<Data name="MRSUB_DocCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRSUB_DurationDays">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRSUB_DurationMonth">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRSUB_DurationYear">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRSUB_EditCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MRSUB_RTFNotes">
<Node>"RTF"</Node>
</Data>
<Data name="MRSUB_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRSUB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MRSUB_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MRSUB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MRSUB_UserUpdate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRSUB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRSUB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRSUB_RowId</SqlRowIdName>
<StreamLocation>^User.MRSubFindS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
