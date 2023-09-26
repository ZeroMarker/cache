/// AdmDischargeSummary(2463)
Class User.PAAdm2DischargeSummary Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Adm2DischargeSummary, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DISChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm2 Parent Reference
Relationship DISParRef As PAAdm2 [ Cardinality = parent, Inverse = ChildPAAdm2DischargeSummary, Required, SqlFieldName = DIS_ParRef ];

/// Childsub
Property DISChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DISSUM",0))}, SqlColumnNumber = 2, SqlFieldName = DIS_Childsub ];

/// Status
Property DISStatus As %String(DISPLAYLIST = ",Entered,Authorised,Corrected", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",E,A,C") [ SqlColumnNumber = 3, SqlFieldName = DIS_Status ];

/// Des Ref DocumType
Property DISDocumTypeDR As PACDocumentType [ SqlColumnNumber = 4, SqlFieldName = DIS_DocumType_DR ];

/// Des Ref CTLOC
Property DISCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = DIS_CTLOC_DR ];

/// Date
Property DISDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DIS_Date ];

/// File Name
Property DISFileName As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DIS_FileName ];

/// Update Date
Property DISUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DIS_UpdateDate ];

/// Update Time
Property DISUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = DIS_UpdateTime ];

/// Des Ref UpdateUser
Property DISUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = DIS_UpdateUser_DR ];

/// Principal Diagnosis
Property DISPrincipalDiagnosis As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 11, SqlFieldName = DIS_PrincipalDiagnosis, SqlListType = SUBNODE ];

/// ActiveProblems
Property DISActiveProblems As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 12, SqlFieldName = DIS_ActiveProblems, SqlListType = SUBNODE ];

/// Des Ref DischargeSummaryType
Property DISDischargeSummaryTypeDR As epr.CTDischargeSummaryType [ SqlColumnNumber = 13, SqlFieldName = DIS_DischargeSummaryType_DR ];

/// Des Ref PADischargeSummary
Property DISPADischargeSummaryDR As PADischargeSummary [ SqlColumnNumber = 14, SqlFieldName = DIS_PADischargeSummary_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdm2DischargeSummary).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2DischargeSummary","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdm2DischargeSummary).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2DischargeSummary","OnAfterInsert")
 
 d Table^HL7Outbound("PAAdm2DischargeSummary",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdm2DischargeSummary).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2DischargeSummary","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdm2DischargeSummary).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2DischargeSummary","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdm2DischargeSummary).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2DischargeSummary","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DIS_ActiveProblems">
<Node>"ACT"</Node>
</Data>
<Data name="DIS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
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
<Data name="DIS_PADischargeSummary_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DIS_PrincipalDiagnosis">
<Node>"PD"</Node>
</Data>
<Data name="DIS_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DIS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDischSum">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIS_PADischargeSummary_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DIS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DIS_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdm2DischargeSummaryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
