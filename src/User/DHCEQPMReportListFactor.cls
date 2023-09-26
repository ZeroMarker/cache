Class User.DHCEQPMReportListFactor Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RLF_RowID, SqlTableName = DHC_EQPMReportListFactor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RLF_ReportListDR
Property RLFReportListDR As User.DHCEQPMReportList [ SqlColumnNumber = 2, SqlFieldName = RLF_ReportListDR ];

/// RLF_FactorDR
Property RLFFactorDR As User.DHCEQMCFactor [ SqlColumnNumber = 3, SqlFieldName = RLF_FactorDR ];

/// RLF_FactorValue
Property RLFFactorValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RLF_FactorValue ];

/// RLF_Unit
Property RLFUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RLF_Unit ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPMReportListFactor("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RLF_FactorDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RLF_FactorValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RLF_ReportListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RLF_Unit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQPMReportListFactor</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RLF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RLF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReportListDR">
<Global>^DHCEQPMReportListFactor</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RLF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReportListDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RLF_ReportListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPMReportListFactorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
