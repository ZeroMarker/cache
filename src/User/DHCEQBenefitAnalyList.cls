Class User.DHCEQBenefitAnalyList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BAL_RowID, SqlTableName = DHC_EQBenefitAnalyList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BAL_BenefitAnalyDR
Property BALBenefitAnalyDR As User.DHCEQBenefitAnaly [ SqlColumnNumber = 2, SqlFieldName = BAL_BenefitAnalyDR ];

/// BAL_ResourceTypeDR
Property BALResourceTypeDR As User.DHCEQCResourceType [ SqlColumnNumber = 3, SqlFieldName = BAL_ResourceTypeDR ];

/// BAL_Fee
Property BALFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BAL_Fee ];

/// BAL_DutyUserDR
Property BALDutyUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BAL_DutyUserDR ];

/// BAL_Remark
Property BALRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BAL_Remark ];

/// BAL_Hold1
Property BALHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BAL_Hold1 ];

/// BAL_Hold2
Property BALHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BAL_Hold2 ];

/// BAL_Hold3
Property BALHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BAL_Hold3 ];

/// BAL_Hold4
Property BALHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BAL_Hold4 ];

/// BAL_Hold5
Property BALHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BAL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBenefitAnalyList)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BAL_BenefitAnalyDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BAL_DutyUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BAL_Fee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BAL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BAL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BAL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BAL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BAL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BAL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BAL_ResourceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQBenefitAnalyList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BAL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBenefitAnaly">
<Global>^DHCEQBenefitAnalyList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BenefitAnaly"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BAL_BenefitAnalyDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBenefitAnalyListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
