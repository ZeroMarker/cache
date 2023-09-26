Class User.PMPDevelopImprovement Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLDI_Rowid, SqlTableName = PMP_DevelopImprovement, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DLDIChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PMPDevelopImprovementParRef As PMPDevelop [ Cardinality = parent, Inverse = ChildPMPDevelopImprovement, Required, SqlFieldName = PMP_DevelopImprovement_ParRef ];

/// DLDIChildsub
Property DLDIChildsub As %Library.Float [ InitialExpression = {$i(^PMPDevelopImprovement($p(%d(0),$c(1),1),0))}, SqlColumnNumber = 2, SqlFieldName = DLDI_Childsub ];

/// DLDIType
Property DLDIType As PMPDictionary3 [ SqlColumnNumber = 3, SqlFieldName = DLDI_Type ];

/// DLDIUser
Property DLDIUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DLDI_User ];

/// DLDIStatus
Property DLDIStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DLDI_Status ];

/// DLDIDate
Property DLDIDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DLDI_Date ];

/// DLDITime
Property DLDITime As %Time [ SqlColumnNumber = 7, SqlFieldName = DLDI_Time ];

/// DLDIImprovement
Property DLDIImprovement As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DLDI_Improvement ];

/// DLDIAdjunct
Property DLDIAdjunct As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DLDI_Adjunct ];

/// DLDIMenu
Property DLDIMenu As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DLDI_Menu ];

/// DLDIBY1
Property DLDIBY1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DLDI_BY1 ];

/// DLDIBY2
Property DLDIBY2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DLDI_BY2 ];

/// DLDIBY3
Property DLDIBY3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DLDI_BY3 ];

/// DLDIBY4
Property DLDIBY4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DLDI_BY4 ];

/// DLDIBY5
Property DLDIBY5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DLDI_BY5 ];

/// DLDIBY6
Property DLDIBY6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DLDI_BY6 ];

/// DLDIBY7
Property DLDIBY7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DLDI_BY7 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPDevelopImprovement(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DLDI_Adjunct">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DLDI_BY1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DLDI_BY2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DLDI_BY3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DLDI_BY4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DLDI_BY5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DLDI_BY6">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DLDI_BY7">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DLDI_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DLDI_Improvement">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DLDI_Menu">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DLDI_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLDI_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLDI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLDI_User">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMP_DevelopImprovement_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPDevelopImprovement</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_Develop.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DLDI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLDI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofImprovement">
<Global>^PMPDevelopImprovement</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Improvement"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLDI_Improvement}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLDI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPDevelopImprovement</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLDI_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLDI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPDevelopImprovementS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
