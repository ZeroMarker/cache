Class User.DHCCTLocMinor Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = CTLMN_RowID, SqlTableName = DHC_CTLoc_Minor, StorageStrategy = SQLStorage ]
{

Property CTLMNCTLocDR As CTLoc [ Required, SqlFieldName = CTLMN_CTLocDR ];

Property CTLMNIsActive As %Boolean [ SqlFieldName = CTLMN_IsActive ];

Property CTLMNChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCCTLoc($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MINOR",0))}, Required, SqlColumnNumber = 2, SqlFieldName = CTLMN_ChildSub ];

Index RowIDBasedIDKeyIndex On CTLMNChildSub [ IdKey, PrimaryKey, Unique ];

Relationship CTLMNParRef As User.DHCCTLocMajor [ Cardinality = parent, Inverse = ChildCTLMN, Required, SqlFieldName = CTLMN_ParRef ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMap">
<Data name="CTLMN_CTLocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTLMN_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTLMN_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCTLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CTLoc_Major.CTLMJ_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CTLMN_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_CTLoc_Major.CTLMJ_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MINOR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLMN_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCTLocMinorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
