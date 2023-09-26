/// ServiceAgreementGPPractices(2318)
Class User.PACServiceAgreementGPPractices Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementGPPractices, StorageStrategy = SQLStorage ]
{

/// Childsub
Property GPPChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"GPP",0))}, SqlColumnNumber = 2, SqlFieldName = GPP_Childsub ];

/// PAC_ServiceAgreement Parent Reference
Relationship GPPParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementGPPract, Required, SqlFieldName = GPP_ParRef ];

/// Practice
Property GPPPractice As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = GPP_Practice ];

Index RowIDBasedIDKeyIndex On GPPChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="GPP_Practice">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ServiceAgreement.SLA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>GPP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GPP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GPP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>GPP_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementGPPracS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
