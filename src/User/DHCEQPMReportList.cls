Class User.DHCEQPMReportList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PMRL_RowID, SqlTableName = DHC_EQPMReportList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PMRL_ReportDR
Property PMRLReportDR As User.DHCEQPMReport [ SqlColumnNumber = 2, SqlFieldName = PMRL_ReportDR ];

/// PMRL_MaintItemDR
Property PMRLMaintItemDR As User.DHCEQCMaintItem [ SqlColumnNumber = 3, SqlFieldName = PMRL_MaintItemDR ];

/// PMRL_Result
Property PMRLResult As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PMRL_Result ];

/// PMRL_Note
Property PMRLNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PMRL_Note ];

/// PMRL_Remark
Property PMRLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PMRL_Remark ];

/// PMRL_Sort
Property PMRLSort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PMRL_Sort ];

/// PMRL_Hold1
Property PMRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PMRL_Hold1 ];

/// PMRL_Hold2
Property PMRLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PMRL_Hold2 ];

/// PMRL_Hold3
Property PMRLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PMRL_Hold3 ];

/// PMRL_ItemFactorKey
Property PMRLItemFactorKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PMRL_ItemFactorKey ];

/// PMRL_NormalType
Property PMRLNormalType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PMRL_NormalType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPMReportList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PMRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PMRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PMRL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PMRL_ItemFactorKey">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PMRL_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMRL_NormalType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PMRL_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PMRL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PMRL_ReportDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PMRL_Result">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMRL_Sort">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQPMReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PMRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReportDR">
<Global>^DHCEQPMReportList</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PMRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReportDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMRL_ReportDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPMReportListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
