Class User.PMPImprovementAppraisal Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPAP_Rowrd, SqlTableName = PMP_ImprovementAppraisal, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IPAPChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PMPAppraisalParRef As PMPImprovementList [ Cardinality = parent, Inverse = ChildPMPAppraisal, Required, SqlFieldName = PMP_AppraisalPar_Ref ];

/// IPAJ_Name
Property IPAPChildsub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^PMPImprovementAppraisal($p(%d(0),$c(1),1),0))}, Required, SqlColumnNumber = 2, SqlFieldName = IPAP_Childsub ];

/// IPAPType
Property IPAPType As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IPAP_Type ];

/// IPAPUser
Property IPAPUser As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = IPAP_User ];

/// IPAPStatus
Property IPAPStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = IPAP_Status ];

/// IPAPDate
Property IPAPDate As %Date [ SqlColumnNumber = 6, SqlFieldName = IPAP_Date ];

/// IPAPTime
Property IPAPTime As %Time [ SqlColumnNumber = 7, SqlFieldName = IPAP_Time ];

/// IPAPMeau
Property IPAPMeau As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IPAP_Meau ];

/// IPAPAdjunct
Property IPAPAdjunct As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = IPAP_Adjunct ];

/// IPAPPJ1
Property IPAPPJ1 As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = IPAP_PJ1 ];

/// IPAPPJ2
Property IPAPPJ2 As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = IPAP_PJ2 ];

/// IPAPPJ3
Property IPAPPJ3 As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = IPAP_PJ3 ];

/// IPAPBeiYong1
Property IPAPBeiYong1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = IPAP_BeiYong1 ];

/// IPAPBeiYong2
Property IPAPBeiYong2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = IPAP_BeiYong2 ];

/// IPAPBeiYong3
Property IPAPBeiYong3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = IPAP_BeiYong3 ];

/// IPAPBeiYong4
Property IPAPBeiYong4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = IPAP_BeiYong4 ];

/// IPAPBeiYong5
Property IPAPBeiYong5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = IPAP_BeiYong5 ];

/// IPAPBeiYong6
Property IPAPBeiYong6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IPAP_BeiYong6 ];

/// IPAPBeiYong7
Property IPAPBeiYong7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = IPAP_BeiYong7 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMap">
<Data name="IPAP_Adjunct">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPAP_BeiYong1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPAP_BeiYong2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPAP_BeiYong3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPAP_BeiYong4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPAP_BeiYong5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IPAP_BeiYong6">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IPAP_BeiYong7">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IPAP_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPAP_Meau">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPAP_PJ1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPAP_PJ2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPAP_PJ3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPAP_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPAP_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPAP_Type">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IPAP_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMP_AppraisalPar_Ref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPImprovementAppraisal</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_ImprovementList.IPML_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>IPAP_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPAP_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PMPImprovementAppraisalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
