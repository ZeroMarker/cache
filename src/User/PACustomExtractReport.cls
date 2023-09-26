/// PA CustomExtractReport(2343)
Class User.PACustomExtractReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CustomExtractReport, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property REPCTLOCDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = REP_CTLOC_DR ];

/// Childsub
Property REPChildsub As %Float [ InitialExpression = {$i(^PAEX($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REP",0))}, SqlColumnNumber = 2, SqlFieldName = REP_Childsub ];

/// Des Ref PAC CustomExtractRep
Property REPCustomExtractRepDR As PACCustomExtractReport [ SqlColumnNumber = 3, SqlFieldName = REP_CustomExtractRep_DR ];

/// Date From
Property REPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = REP_DateFrom ];

/// Date Run
Property REPDateRun As %Date [ SqlColumnNumber = 6, SqlFieldName = REP_DateRun ];

/// Date To
Property REPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = REP_DateTo ];

/// Errors
Property REPErrors As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = REP_Errors ];

/// Des Ref HCA
Property REPHCADR As CTHealthCareArea [ SqlColumnNumber = 12, SqlFieldName = REP_HCA_DR ];

/// Des Ref Hospital
Property REPHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = REP_Hospital_DR ];

/// PA_CustomExtract Parent Reference
Relationship REPParRef As PACustomExtract [ Cardinality = parent, Inverse = ChildPACustomExtractReport, Required, SqlFieldName = REP_ParRef ];

/// Specialty Exclude
Property REPSpecialtyExclude As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = REP_SpecialtyExclude ];

/// Specialty String
Property REPSpecialtyString As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = REP_SpecialtyString ];

/// Status
Property REPStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = REP_Status ];

/// Des Ref Trust
Property REPTrustDR As PACTrust [ SqlColumnNumber = 11, SqlFieldName = REP_Trust_DR ];

/// Des Ref User
Property REPUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = REP_User_DR ];

Index RowIDBasedIDKeyIndex On REPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="REPCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPCustomExtractRepDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPDateRun">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPErrors">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPHCADR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPSpecialtyExclude">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="REPSpecialtyString">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPStatus">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPTrustDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="REP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REP_CustomExtractRep_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REP_DateRun">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REP_Errors">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REP_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="REP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REP_SpecialtyExclude">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REP_SpecialtyString">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="REP_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REP_Trust_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REP_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAEX</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_CustomExtract.EX_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_CustomExtract.EX_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REP_RowId</SqlRowIdName>
<StreamLocation>^User.PACustomExtractReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
