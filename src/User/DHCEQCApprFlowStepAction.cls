Class User.DHCEQCApprFlowStepAction Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AFSA_RowID, SqlTableName = DHC_EQCApprFlowStepAction, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AFSA_FlowDR
Property AFSAFlowDR As User.DHCEQCApproveFlow [ SqlColumnNumber = 2, SqlFieldName = AFSA_FlowDR ];

/// AFSA_ActionDR
Property AFSAActionDR As User.DHCEQCApproveAction [ SqlColumnNumber = 3, SqlFieldName = AFSA_ActionDR ];

/// AFSA_Hold1
Property AFSAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AFSA_Hold1 ];

/// AFSA_Hold2
Property AFSAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AFSA_Hold2 ];

/// AFSA_hold3
Property AFSAhold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AFSA_hold3 ];

/// AFSA_Hold4
Property AFSAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AFSA_Hold4 ];

/// AFSA_Hold5
Property AFSAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AFSA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCApprFlowStepAction",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AFSA_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AFSA_FlowDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AFSA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AFSA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AFSA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AFSA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AFSA_hold3">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AFSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCApprFlowStepAction"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AFSA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAction">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AFSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApprFlowStepAction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Action"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AFSA_ActionDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AFSA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlow">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AFSA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApprFlowStepAction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Flow"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AFSA_FlowDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AFSA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCApprFlowStepActionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
