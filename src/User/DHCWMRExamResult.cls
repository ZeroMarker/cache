Class User.DHCWMRExamResult Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_ExamResult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCWMRExamRDtl As User.DHCWMRExamRDtl [ Cardinality = children, Inverse = ParRef ];

/// VolumeId
Property VolumeId As User.DHCWMRMainVolume [ SqlColumnNumber = 2 ];

/// RuleDr
Property ExamRuleDr As User.DHCWMRExamRule [ SqlColumnNumber = 3 ];

/// Veto
Property Veto As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// Score
Property Score As %Library.Float [ SqlColumnNumber = 5 ];

/// ActualScore
Property ActualScore As %Library.Float [ SqlColumnNumber = 6 ];

/// IsPrimary
Property IsPrimary As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// GradeDr
Property GradeDr As User.DHCWMRExamGarde [ SqlColumnNumber = 8 ];

/// Remind
Property Remind As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// Money
Property Money As %Library.Float [ SqlColumnNumber = 10 ];

/// SignUserDr
Property SignUserDr As User.SSUser [ SqlColumnNumber = 11 ];

/// ExamDate
Property ExamDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12 ];

/// ExamTime
Property ExamTime As %Library.Time [ SqlColumnNumber = 13 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

/// PaadmDr
Property PaadmDr As User.PAAdm [ SqlColumnNumber = 16 ];

/// ExamType
Property ExamType As %Library.String(MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Move||M,Finally||F") [ SqlColumnNumber = 17 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRERST)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="ActualScore">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ExamDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ExamRuleDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ExamTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ExamType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="GradeDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IsPrimary">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Money">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PaadmDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Remind">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Score">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SignUserDr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Veto">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VolumeId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCWMRERST</Global>
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
<SQLMap name="IndexPaadm">
<Global>^DHCWMRERST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PaadmDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRuleAdm">
<Global>^DHCWMRERST</Global>
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
<Expression>"RuleAdm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ExamRuleDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PaadmDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRuleDate">
<Global>^DHCWMRERST</Global>
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
<Expression>"RuleDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ExamRuleDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ExamDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRuleVol">
<Global>^DHCWMRERST</Global>
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
<Expression>"RuleVol"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ExamRuleDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{VolumeId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRExamResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
