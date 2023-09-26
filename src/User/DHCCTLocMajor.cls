/// 一级科室
Class User.DHCCTLocMajor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = CTLMJ_RowID, SqlTableName = DHC_CTLoc_Major, StorageStrategy = SQLStorage ]
{

Property CTLMJCode As %String [ Required, SqlFieldName = CTLMJ_Code ];

Property CTLMJName As %String [ Required, SqlFieldName = CTLMJ_Name ];

Property CTLMJStartDate As %Date [ SqlFieldName = CTLMJ_StartDate ];

Property CTLMJEndDate As %Date [ SqlFieldName = CTLMJ_EndDate ];

Property CTLMJHospDr As User.CTHospital [ SqlFieldName = CTLMJ_Hosp_Dr ];

Relationship ChildCTLMN As User.DHCCTLocMinor [ Cardinality = children, Inverse = CTLMNParRef ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCCTLoc)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="CTLMJ_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTLMJ_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTLMJ_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTLMJ_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTLMJ_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCTLoc</Global>
<RowIdSpec name="1">
<Field>CTLMJ_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{CTLMJ_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCTLocMajorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
