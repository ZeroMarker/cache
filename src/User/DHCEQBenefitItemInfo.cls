Class User.DHCEQBenefitItemInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQBenefitItemInfo, StorageStrategy = SQLStorage ]
{

/// BII_UseContextDR 
Property BIIUseContextDR As User.DHCEQUseContext [ SqlColumnNumber = 2, SqlFieldName = BII_UseContextDR ];

/// BII_BenefitItemDR
Property BIIBenefitItemDR As User.DHCEQCBenefitItem [ SqlColumnNumber = 3, SqlFieldName = BII_BenefitItemDR ];

/// BII_Score
Property BIIScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BII_Score ];

/// BII_Resume
Property BIIResume As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BII_Resume ];

/// BII_Remark
Property BIIRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BII_Remark ];

/// BII_Hold1
Property BIIHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BII_Hold1 ];

/// BII_Hold2
Property BIIHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BII_Hold2 ];

/// BII_Hold3
Property BIIHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BII_Hold3 ];

/// BII_Hold4
Property BIIHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BII_Hold4 ];

/// BII_Hold5
Property BIIHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BII_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQBenefitItemInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BII_BenefitItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BII_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BII_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BII_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BII_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BII_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BII_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BII_Resume">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BII_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BII_UseContextDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQBenefitItemInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BII_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BII_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDR">
<Global>^DHCEQBenefitItemInfo</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BenefitItemInfo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BII_UseContextDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BII_BenefitItemDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFunctionItemDR">
<Global>^DHCEQBenefitItemInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BII_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FunctionItemDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BII_BenefitItemDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{BII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseContextDR">
<Global>^DHCEQBenefitItemInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BII_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseContextDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BII_UseContextDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BII_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQBenefitItemInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
