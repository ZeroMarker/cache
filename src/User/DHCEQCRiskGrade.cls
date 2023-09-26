Class User.DHCEQCRiskGrade Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCRiskGrade, StorageStrategy = SQLStorage ]
{

/// RG_Code
Property RGCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RG_Code ];

/// RG_Desc
Property RGDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RG_Desc ];

/// RG_InvalidFlag
Property RGInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = RG_InvalidFlag ];

/// RG_Remark
Property RGRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RG_Remark ];

/// RG_MinValue
Property RGMinValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RG_MinValue ];

/// RG_MaxValue
Property RGMaxValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RG_MaxValue ];

/// RG_CycleNum
Property RGCycleNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RG_CycleNum ];

/// RG_CycleUnitDR
Property RGCycleUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 9, SqlFieldName = RG_CycleUnitDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCRiskGrade",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RG_CycleNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RG_CycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RG_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RG_MaxValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RG_MinValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RG_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCRiskGrade"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCRiskGrade"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RG_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RG_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCRiskGradeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
