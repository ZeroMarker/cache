Class User.DHCDocPilotProSAE Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPSAE_RowId, SqlTableName = DHC_DocPilotProSAE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPSAEChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPSAEPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProSAE, Required, SqlFieldName = PPSAE_PP_ParRef ];

/// PPSAE_ChildSub
Property PPSAEChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPSAE(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPSAE_ChildSub ];

/// PPPSAE_DocumentRegNo：文件登记编号
Property PPSAEDocumentRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPSAE_DocumentRegNo ];

/// PPSAE_PatNameab：受试者姓名缩写
Property PPSAEPatNameab As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPSAE_PatNameab ];

/// PPSAE_Date：报告日期
Property PPSAEDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PPSAE_Date ];

/// PPSAE_ICDCode：SAE的诊断
Property PPSAEICDCode As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPSAE_ICDCode ];

/// PPSAE_Situation_DR：SAE情况
Property PPSAESituationDr As User.DHCDocCTDefineData [ SqlColumnNumber = 7, SqlFieldName = PPSAE_Situation_Dr ];

/// PPSAE_Relate_Dr：与试验药物的相关性
Property PPSAERelateDr As User.DHCDocCTDefineData [ SqlColumnNumber = 8, SqlFieldName = PPSAE_Relate_Dr ];

/// PPSAE_Step_Dr：对试验药物采取的措施
Property PPSAEStepDr As User.DHCDocCTDefineData [ SqlColumnNumber = 9, SqlFieldName = PPSAE_Step_Dr ];

/// PPSAE_Lapse_Dr：	SAE的转归
Property PPSAELapseDr As User.DHCDocCTDefineData [ SqlColumnNumber = 10, SqlFieldName = PPSAE_Lapse_Dr ];

/// PPSAE_ReportType_Dr：	报告类型
Property PPSAEReportTypeDr As User.DHCDocCTDefineData [ SqlColumnNumber = 11, SqlFieldName = PPSAE_ReportType_Dr ];

/// PPSAE_DeathDate：死亡日期
Property PPSAEDeathDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PPSAE_DeathDate ];

/// /备注
Property PPSAERemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PPSAE_Remark ];

/// 中期描述
Property PPSAEMidSummary As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PPSAE_MidSummary ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPSAE_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPSAE_DeathDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPSAE_DocumentRegNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPSAE_ICDCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPSAE_Lapse_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPSAE_MidSummary">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPSAE_PatNameab">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPSAE_Relate_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPSAE_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPSAE_ReportType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPSAE_Situation_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPSAE_Step_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDocPPSAE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPSAE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPSAE_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCDocPPSAE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPSAE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPSAE_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PPSAE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProSAES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
