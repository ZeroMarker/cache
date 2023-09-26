Class User.DHCWMRExamRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_ExamRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCWMRExamGarde As User.DHCWMRExamGarde [ Cardinality = children, Inverse = ParRef ];

Relationship ChildDHCWMRExamSection As User.DHCWMRExamSection [ Cardinality = children, Inverse = ParRef ];

/// RuleDr
Property RuleDr As User.DHCWMRRuleDic [ SqlColumnNumber = 2 ];

/// MaxScore
Property MaxScore As %Library.Float [ SqlColumnNumber = 3 ];

/// PassingScore
Property PassingScore As %Library.Float [ SqlColumnNumber = 4 ];

/// DeductLine
Property DeductLine As %Library.Float [ SqlColumnNumber = 5 ];

/// MonyPerPoint
Property MonyPerPoint As %Library.Float [ SqlColumnNumber = 6 ];

/// Punishment
Property Punishment As %Library.Float [ SqlColumnNumber = 7 ];

/// ScoreMethod
Property ScoreMethod As %Library.String(MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Add||A,Reduce||R") [ SqlColumnNumber = 8 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRER)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DeductLine">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MaxScore">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MonyPerPoint">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PassingScore">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Punishment">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RuleDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ScoreMethod">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCWMRER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRuleActive">
<Global>^DHCWMRER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RuleActive"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RuleDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IsActive}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRExamRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
