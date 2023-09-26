/// PanicReportItems
Class User.DHCAntCVReportItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPRI_RowID, SqlTableName = DHC_AntCVReportItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DPRITestCodeDR [ IdKey, PrimaryKey, Unique ];

/// DHC_AntCVReport Parent Reference
Relationship DPRIParRef As User.DHCAntCVReport [ Cardinality = parent, Inverse = ChildDHCAntCVReportItems, Required, SqlFieldName = DPRI_ParRef ];

/// DPRI_TestCodeDR
Property DPRITestCodeDR As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DPRI_TestCodeDR ];

/// DPRI_TCSync
Property DPRITCSync As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DPRI_TCSync ];

/// DPRI_Result
Property DPRIResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DPRI_Result ];

/// DPRI_Unit
Property DPRIUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DPRI_Unit ];

/// DPRI_Flag
Property DPRIFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DPRI_Flag ];

/// DPRI_RefRanges
Property DPRIRefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DPRI_RefRanges ];

/// DPRI_Machine
Property DPRIMachine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DPRI_Machine ];

/// DPRI_Comment
Property DPRIComment As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DPRI_Comment ];

/// DPRI_TestName
Property DPRITestName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DPRI_TestName ];

/// DPRI_EngName
Property DPRIEngName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DPRI_EngName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DPRI_Comment">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DPRI_EngName">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DPRI_Flag">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPRI_Machine">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPRI_RefRanges">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DPRI_Result">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DPRI_TCSync">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPRI_TestName">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DPRI_Unit">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAntCVReport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AntCVReport.DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_AntCVReport.DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>DHC_AntCVReport.DPRP_Order</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L5}</Expression>
<Field>DPRI_TestCodeDR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AntCVReport.DPRP_Type}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_AntCVReport.DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AntCVReport.DPRP_Order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRI_TestCodeDR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAntCVReportItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
