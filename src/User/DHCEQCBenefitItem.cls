Class User.DHCEQCBenefitItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCBenefitItem, StorageStrategy = SQLStorage ]
{

/// BI_Code
Property BICode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BI_Code ];

/// BI_Desc
Property BIDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BI_Desc ];

/// BI_MinScore
Property BIMinScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BI_MinScore ];

/// BI_MaxScore
Property BIMaxScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BI_MaxScore ];

/// BI_Remark
Property BIRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BI_Remark ];

/// BI_InvalidFlag
Property BIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = BI_InvalidFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCBenefitItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BI_MaxScore">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BI_MinScore">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCBenefitItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{BI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCBenefitItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
