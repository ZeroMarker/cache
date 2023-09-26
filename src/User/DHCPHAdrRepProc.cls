Class User.DHCPHAdrRepProc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRRP_RowID, SqlTableName = DHC_PHAdrRepProc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADRRPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrReport Parent Reference ADRRP_ADRR_Parref
Relationship ADRRPADRRParref As User.DHCPHAdrReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPPROC, Required, SqlFieldName = ADRRP_ADRR_Parref ];

/// ADRRP_ChildSub
Property ADRRPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADRRP_ChildSub ];

/// ADRRP_TherapMeas 
Property ADRRPTherapMeas As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRRP_TherapMeas ];

/// ADRRP_Symptom
Property ADRRPSymptom As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADRRP_Symptom ];

/// ADRRP_OtherExplanation
Property ADRRPOtherExplanation As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ADRRP_OtherExplanation ];

/// ADRRP_ProcessDesc
Property ADRRPProcessDesc As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ADRRP_ProcessDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADRRP_OtherExplanation">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADRRP_ProcessDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADRRP_Symptom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRRP_TherapMeas">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHADRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAdrReport.ADRR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADRRP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdrReport.ADRR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADRRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRRP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrRepProcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
