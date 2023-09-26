Class User.DHCMRDiagnos Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_MRDiagnos, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (MRDIAMRADMParRef, MRDIAChildsub) [ IdKey, PrimaryKey, Unique ];

/// MRDIA_Childsub
Property MRDIAChildsub As %Float(MINVAL = 1) [ SqlColumnNumber = 3, SqlFieldName = MRDIA_Childsub ];

/// MR_AdmLink Parent Reference
Property MRDIAMRADMParRef As MRAdm [ Required, SqlColumnNumber = 2, SqlFieldName = MRDIA_MRADM_ParRef ];

/// Description
Property MRDIASignSymDesc As list Of %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MRDIA_SignSymDesc, SqlListType = subnode ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="MRDIA_SignSymDesc">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRDIA_MRADM_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRDIA_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MRDIA_MRADM_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRDIA_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRDIA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRDiagnosS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
