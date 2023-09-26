/// Discharge Summary(2541)
Class User.PADischargeSummary Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_DischargeSummary, StorageStrategy = SQLStorage ]
{

Relationship ChildPADischargeSummaryRefDoc As PADischargeSummaryRefDoc [ Cardinality = children, Inverse = REFParRef ];

Relationship ChildPADischargeSummaryDet As PADischargeSummaryDet [ Cardinality = children, Inverse = DETParRef ];

/// Status
Property DISStatus As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DIS_Status ];

/// Des Ref DocumType
Property DISDocumTypeDR As PACDocumentType [ SqlColumnNumber = 3, SqlFieldName = DIS_DocumType_DR ];

/// Des Ref CTLOC
Property DISCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = DIS_CTLOC_DR ];

/// Date
Property DISDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DIS_Date ];

/// File Name
Property DISFileName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DIS_FileName ];

/// UpdateDate
Property DISUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DIS_UpdateDate ];

/// UpdateTime
Property DISUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = DIS_UpdateTime ];

/// Des Ref UpdateUser
Property DISUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = DIS_UpdateUser_DR ];

/// Principal Diagnosis
Property DISPrincipalDiagnosis As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DIS_PrincipalDiagnosis, SqlListType = subnode ];

/// ActiveProblems
Property DISActiveProblems As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DIS_ActiveProblems, SqlListType = subnode ];

/// Des Ref DischargeSummaryType
Property DISDischargeSummaryTypeDR As epr.CTDischargeSummaryType [ SqlColumnNumber = 12, SqlFieldName = DIS_DischargeSummaryType_DR ];

/// Des Ref Version
Property DISVersionDR As PADischargeSummary [ SqlColumnNumber = 13, SqlFieldName = DIS_Version_DR ];

/// Procedures
Property DISProcedures As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DIS_Procedures, SqlListType = subnode ];

/// ProgressNotes
Property DISProgressNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DIS_ProgressNotes, SqlListType = subnode ];

/// ClinicalOpinion
Property DISClinicalOpinion As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DIS_ClinicalOpinion, SqlListType = subnode ];

/// Suggestions
Property DISSuggestions As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DIS_Suggestions, SqlListType = subnode ];

/// OtherResults
Property DISOtherResults As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = DIS_OtherResults, SqlListType = subnode ];

/// Des Ref CareProv
Property DISCareProvDR As CTCareProv [ SqlColumnNumber = 19, SqlFieldName = DIS_CareProv_DR ];

/// Des Ref UpdateHospital
Property DISUpdateHospitalDR As CTHospital [ SqlColumnNumber = 20, SqlFieldName = DIS_UpdateHospital_DR ];

/// Des Ref DischargeDestination
Property DISDischargeDestinationDR As PACDischargeDestination [ SqlColumnNumber = 21, SqlFieldName = DIS_DischargeDestination_DR ];

/// Des Ref ModeOfSeparation
Property DISModeOfSeparationDR As CTDisposit [ SqlColumnNumber = 22, SqlFieldName = DIS_ModeOfSeparation_DR ];

/// Des Ref Resource
Property DISResourceDR As RBResource [ SqlColumnNumber = 23, SqlFieldName = DIS_Resource_DR ];

/// Deleted
Property DISDeleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = DIS_Deleted ];

/// TreatingClinicians
Property DISTreatingClinicians As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = DIS_TreatingClinicians, SqlListType = subnode ];

/// TreatingCliniciansRTF
Property DISTreatingCliniciansRTF As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = DIS_TreatingCliniciansRTF, SqlListType = subnode ];

/// Comment01
Property DISComment01 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = DIS_Comment01, SqlListType = subnode ];

/// Comment01RTF
Property DISComment01RTF As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = DIS_Comment01RTF, SqlListType = subnode ];

/// Comment02
Property DISComment02 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = DIS_Comment02, SqlListType = subnode ];

/// Comment02RTF
Property DISComment02RTF As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = DIS_Comment02RTF, SqlListType = subnode ];

/// Comment03
Property DISComment03 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DIS_Comment03, SqlListType = subnode ];

/// Comment03RTF
Property DISComment03RTF As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = DIS_Comment03RTF, SqlListType = subnode ];

/// Comment04
Property DISComment04 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = DIS_Comment04, SqlListType = subnode ];

/// Comment04RTF
Property DISComment04RTF As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = DIS_Comment04RTF, SqlListType = subnode ];

/// Comment05
Property DISComment05 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = DIS_Comment05, SqlListType = subnode ];

/// Comment05RTF
Property DISComment05RTF As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = DIS_Comment05RTF, SqlListType = subnode ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PADischargeSummary).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummary","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PADischargeSummary).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummary","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PADischargeSummary).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummary","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PADischargeSummary).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummary","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummary","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PADischargeSummary).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummary","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PA("DISSUM",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="DIS_ActiveProblems">
<Node>"ACT"</Node>
</Data>
<Data name="DIS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIS_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DIS_ClinicalOpinion">
<Node>"CO"</Node>
</Data>
<Data name="DIS_Comment01">
<Node>"COM01"</Node>
</Data>
<Data name="DIS_Comment01RTF">
<Node>"COM01RTF"</Node>
</Data>
<Data name="DIS_Comment02">
<Node>"COM02"</Node>
</Data>
<Data name="DIS_Comment02RTF">
<Node>"COM02RTF"</Node>
</Data>
<Data name="DIS_Comment03">
<Node>"COM03"</Node>
</Data>
<Data name="DIS_Comment03RTF">
<Node>"COM03RTF"</Node>
</Data>
<Data name="DIS_Comment04">
<Node>"COM04"</Node>
</Data>
<Data name="DIS_Comment04RTF">
<Node>"COM04RTF"</Node>
</Data>
<Data name="DIS_Comment05">
<Node>"COM05"</Node>
</Data>
<Data name="DIS_Comment05RTF">
<Node>"COM05RTF"</Node>
</Data>
<Data name="DIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIS_Deleted">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DIS_DischargeDestination_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DIS_DischargeSummaryType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DIS_DocumType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIS_FileName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIS_ModeOfSeparation_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DIS_OtherResults">
<Node>"OR"</Node>
</Data>
<Data name="DIS_PrincipalDiagnosis">
<Node>"PD"</Node>
</Data>
<Data name="DIS_Procedures">
<Node>"PROC"</Node>
</Data>
<Data name="DIS_ProgressNotes">
<Node>"PN"</Node>
</Data>
<Data name="DIS_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DIS_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIS_Suggestions">
<Node>"SUG"</Node>
</Data>
<Data name="DIS_TreatingClinicians">
<Node>"TCL"</Node>
</Data>
<Data name="DIS_TreatingCliniciansRTF">
<Node>"TCLRTF"</Node>
</Data>
<Data name="DIS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIS_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DIS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DIS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DIS_Version_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVersion">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DIS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Ver"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DIS_Version_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DIS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DIS_RowId</SqlRowIdName>
<StreamLocation>^User.PADischargeSummaryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
