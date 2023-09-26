Class User.PMPImprovementAdjunct Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPAJ_Rowid, SqlTableName = PMP_ImprovementAdjunct, StorageStrategy = SQLStorage ]
{

/// IPAJImprove
Property IPAJImprove As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = IPAJ_Improve ];

/// IPAJName
Property IPAJName As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IPAJ_Name ];

/// IPAJLocation
Property IPAJLocation As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = IPAJ_Location ];

/// IPAJRemark
Property IPAJRemark As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = IPAJ_Remark ];

/// IPAJAffiliation
Property IPAJAffiliation As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = IPAJ_Affiliation ];

/// IPAJStandby2
Property IPAJStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = IPAJ_Standby2 ];

/// IPAJStandby3
Property IPAJStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IPAJ_Standby3 ];

/// IPAJStandby4
Property IPAJStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = IPAJ_Standby4 ];

/// IPAJStandby5
Property IPAJStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = IPAJ_Standby5 ];

/// IPAJStandby6
Property IPAJStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = IPAJ_Standby6 ];

/// IPAJ_User_DR
Property IPAJUserDR As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = IPAJ_User_DR ];

/// IPAJ_Date
Property IPAJDate As %Date [ SqlColumnNumber = 13, SqlFieldName = IPAJ_Date ];

/// IPAJ_Time
Property IPAJTime As %Time [ SqlColumnNumber = 14, SqlFieldName = IPAJ_Time ];

/// IPAJStandby7
Property IPAJStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = IPAJ_Standby7 ];

/// IPAJStandby8
Property IPAJStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = IPAJ_Standby8 ];

/// IPAJStandby9
Property IPAJStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = IPAJ_Standby9 ];

/// IPAJStandby10
Property IPAJStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IPAJ_Standby10 ];

/// IPAJStandby11
Property IPAJStandby11 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = IPAJ_Standby11 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPImprovementAdjunct(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IPAJ_Affiliation">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPAJ_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPAJ_Improve">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPAJ_Location">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPAJ_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPAJ_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPAJ_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IPAJ_Standby11">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IPAJ_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPAJ_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPAJ_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPAJ_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPAJ_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPAJ_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPAJ_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IPAJ_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IPAJ_Time">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPAJ_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^PMPImprovementAdjunct</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPAJ_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IPAJ_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAffiliation">
<Global>^PMPImproveAdjuncti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Affilation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPAJ_Affiliation}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPAJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPImproveAdjuncti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPAJ_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPAJ_Affiliation}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPAJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIPAJUser">
<Global>^PMPImproveAdjuncti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPAJ_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPAJ_Affiliation}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPAJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofStanbdy6">
<Global>^PMPImproveAdjuncti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Stanbdy6"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPAJ_Standby6}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPAJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofImprove">
<Global>^PMPImproveAdjuncti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Improve"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPAJ_Improve}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPAJ_Affiliation}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPAJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPImprovementAdjunctS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
