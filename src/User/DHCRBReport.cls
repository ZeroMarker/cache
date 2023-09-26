Class User.DHCRBReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRPT_RowID, SqlTableName = DHCRB_Report, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBReportFiles As User.DHCRBReportFiles [ Cardinality = children, Inverse = DRPFParRef ];

Relationship ChildDHCRBReportUnit As User.DHCRBReportUnit [ Cardinality = children, Inverse = DMRSUParRef ];

/// DRPT_StudyNo
Property DRPTStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRPT_StudyNo ];

/// DRPT_ReportID
Property DRPTReportID As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DRPT_ReportID ];

/// DRPT_Version
Property DRPTVersion As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DRPT_Version ];

/// DRPT_ExamDesc
Property DRPTExamDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRPT_ExamDesc ];

/// DRPT_ResultDesc
Property DRPTResultDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRPT_ResultDesc ];

/// DPRT_Result
Property DRPTResult As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DRPT_Result ];

/// DRPT_Status_DR
Property DRPTStatusDR As User.DHCRBCReportStatus [ SqlColumnNumber = 8, SqlFieldName = DRPT_Status_DR ];

/// DPRT_ReportDoc_DR
Property DRPTReportDocDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = DRPT_ReportDoc_DR ];

/// DPRT_ReportDate
Property DRPTReportDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DRPT_ReportDate ];

/// DPRT_ReportTime
Property DRPTReportTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DRPT_ReportTime ];

/// DRPT_VerifyDoc_DR
Property DRPTVerifyDocDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = DRPT_VerifyDoc_DR ];

/// DRPT_VerifyDate
Property DRPTVerifyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DRPT_VerifyDate ];

/// DRPT_VerifyTime
Property DRPTVerifyTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = DRPT_VerifyTime ];

/// DRPT_RegInfo_DR
Property DRPTRegInfoDR As User.DHCRBRegInfo [ SqlColumnNumber = 15, SqlFieldName = DRPT_RegInfo_DR ];

/// DRPT_OeordItm_DR
Property DRPTOeordItmDR As User.OEOrdItem [ SqlColumnNumber = 16, SqlFieldName = DRPT_OeordItm_DR ];

/// DRPT_PAADM_DR
Property DRPTPAADMDR As User.PAAdm [ SqlColumnNumber = 17, SqlFieldName = DRPT_PAADM_DR ];

/// DRPT_StudyDesc_DR
Property DRPTStudyDescDR As User.DHCRBStudyDesc [ SqlColumnNumber = 18, SqlFieldName = DRPT_StudyDesc_DR ];

/// DRPT_Type
Property DRPTType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DRPT_Type ];

/// DRPT_BodyPart_DR
Property DRPTBodyPartDR As User.MRCBodyParts [ SqlColumnNumber = 20, SqlFieldName = DRPT_BodyPart_DR ];

/// DRPT_AssociateStudyNo
Property DRPTAssociateStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DRPT_AssociateStudyNo ];

/// DRPT_Sepecial
Property DRPTSepecial As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = DRPT_Sepecial ];

/// DRPT_Research
Property DRPTResearch As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = DRPT_Research ];

/// DRPT_SeeDesc
Property DRPTSeeDesc As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DRPT_SeeDesc, SqlListType = SUBNODE ];

/// DRPT_Memo
Property DRPTMemo As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DRPT_Memo, SqlListType = SUBNODE ];

/// DRPT_ExamDescEx
Property DRPTExamDescEx As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DRPT_ExamDescEx, SqlListType = SUBNODE ];

/// DRPT_ResultDescEx
Property DRPTResultDescEx As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DRPT_ResultDescEx, SqlListType = SUBNODE ];

/// DRPT_HTable
Property DRPTHTable As %Library.String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DRPT_HTable ];

/// DRPT_ExameMethod
Property DRPTExameMethod As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DRPT_ExameMethod ];

/// DRPT_Note2
Property DRPTNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DRPT_Note2 ];

/// DRPT_Note3
Property DRPTNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DRPT_Note3 ];

/// DRPT_Note4
Property DRPTNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DRPT_Note4 ];

/// DRPT_PatDepiction
Property DRPTPatDepiction As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DRPT_PatDepiction ];

/// DRPT_PerOPSLeechdom
Property DRPTPerOPSLeechdom As %Library.String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DRPT_PerOPSLeechdom ];

/// DRPT_CheckBodayPart
Property DRPTCheckBodayPart As %Library.String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DRPT_CheckBodayPart ];

/// DRPT_HP
Property DRPTHP As %Library.String(COLLATION = "Exact", MAXLEN = 64, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DRPT_HP ];

/// DRPT_Advice
Property DRPTAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 512, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = DRPT_Advice ];

/// DRPT_Assay
Property DRPTAssay As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = DRPT_Assay ];

/// DRPT_LocID
Property DRPTLocID As User.CTLoc [ SqlColumnNumber = 39, SqlFieldName = DRPT_LocID ];

/// DRPT_RptShapeID
Property DRPTRptShapeID As %Library.String(COLLATION = "Exact", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = DRPT_RptShapeID ];

/// DRPT_IssueDoc_DR
Property DRPTIssueDocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = DRPT_IssueDoc_DR ];

/// DRPT_IssueDate
Property DRPTIssueDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = DRPT_IssueDate ];

/// DRPT_IssueTime
Property DRPTIssueTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = DRPT_IssueTime ];

/// DRPT_CriticalDiseaseID
Property DRPTCriticalDiseaseID As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = DRPT_CriticalDiseaseID ];

/// DRPT_SerialNumber
Property DRPTSerialNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = DRPT_SerialNumber ];

/// DRPT_MovieNumber
Property DRPTMovieNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = DRPT_MovieNumber ];

/// DRPT_CriticalIllness
Property DRPTCriticalIllness As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = DRPT_CriticalIllness ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBStudy("Report"))</SqlIdExpression>
<SQLMap name="IndexData">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ReportDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_ReportDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Doctor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_ReportDoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPT_ReportDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIssueDate">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IssueDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_IssueDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeordItmDR">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report-Oeorditm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_OeordItm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegInfo">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ReportRegDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_RegInfo_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyDescDR">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report-StudyDesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_StudyDesc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_StudyNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexlocid">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report-loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_ReportDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexpaadmDR">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report-PAADMDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_PAADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRPT_Advice">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DRPT_Assay">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DRPT_AssociateStudyNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DRPT_BodyPart_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DRPT_CheckBodayPart">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DRPT_CriticalDiseaseID">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DRPT_CriticalIllness">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DRPT_ExamDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRPT_ExamDescEx">
<Node>"ExamDescEx"</Node>
</Data>
<Data name="DRPT_ExameMethod">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DRPT_HP">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DRPT_HTable">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DRPT_IssueDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DRPT_IssueDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DRPT_IssueTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DRPT_LocID">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DRPT_Memo">
<Node>"MemoEx"</Node>
</Data>
<Data name="DRPT_MovieNumber">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DRPT_Note2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DRPT_Note3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DRPT_Note4">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DRPT_OeordItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DRPT_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DRPT_PatDepiction">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DRPT_PerOPSLeechdom">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DRPT_RegInfo_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRPT_ReportDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRPT_ReportDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRPT_ReportID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRPT_ReportTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRPT_Research">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DRPT_Result">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRPT_ResultDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRPT_ResultDescEx">
<Node>"ResultDescEx"</Node>
</Data>
<Data name="DRPT_RptShapeID">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DRPT_SeeDesc">
<Node>"SeeDescEx"</Node>
</Data>
<Data name="DRPT_Sepecial">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DRPT_SerialNumber">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DRPT_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRPT_StudyDesc_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DRPT_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRPT_Type">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DRPT_VerifyDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRPT_VerifyDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRPT_VerifyTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRPT_Version">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBStudy</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRPT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
