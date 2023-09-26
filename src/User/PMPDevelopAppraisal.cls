Class User.PMPDevelopAppraisal Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLAP_Rowid, SqlTableName = PMP_DevelopAppraisal, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DLAPChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PMPDevelopAppraisalParRef As PMPDevelop [ Cardinality = parent, Inverse = ChildPMPDevelopAppraisal, Required, SqlFieldName = PMP_DevelopAppraisal_ParRef ];

/// DLAPChildsub
Property DLAPChildsub As %Library.Float [ InitialExpression = {$i(^PMPDevelopAppraisal($p(%d(0),$c(1),1),"E",0))}, SqlColumnNumber = 2, SqlFieldName = DLAP_Childsub ];

/// DLAPType
Property DLAPType As %String(DISPLAYLIST = ",PA,DA,HA,LA,SS,Other", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",PA,DA,HA,LA,SS,Other") [ SqlColumnNumber = 3, SqlFieldName = DLAP_Type ];

/// DLAPUser
Property DLAPUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DLAP_User ];

/// DLAPStatus
Property DLAPStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DLAP_Status ];

/// DLAPDate
Property DLAPDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DLAP_Date ];

/// DLAPTime
Property DLAPTime As %Time [ SqlColumnNumber = 7, SqlFieldName = DLAP_Time ];

/// DLAPMeau
Property DLAPMeau As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DLAP_Meau ];

/// DLAPAdjunct
Property DLAPAdjunct As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DLAP_Adjunct ];

/// DLAPBY1
Property DLAPBY1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DLAP_BY1 ];

/// DLAPBY2
Property DLAPBY2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DLAP_BY2 ];

/// DLAPBY3
Property DLAPBY3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DLAP_BY3 ];

/// DLAPBY4
Property DLAPBY4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DLAP_BY4 ];

/// DLAPBY5
Property DLAPBY5 As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DLAP_BY5 ];

/// DLAPBY6
Property DLAPBY6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DLAP_BY6 ];

/// DLAPBY7
Property DLAPBY7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DLAP_BY7 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPDevelopAppraisal(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DLAP_Adjunct">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DLAP_BY1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DLAP_BY2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DLAP_BY3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DLAP_BY4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DLAP_BY5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DLAP_BY6">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DLAP_BY7">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DLAP_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DLAP_Meau">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DLAP_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLAP_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLAP_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLAP_User">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMP_DevelopAppraisal_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPDevelopAppraisal</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_Develop.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DLAP_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLAP_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAdjunct">
<Global>^PMPDevelopAppraisal</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Adjunct"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLAP_Adjunct}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLAP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPDevelopAppraisal</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLAP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLAP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPDevelopAppraisal</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLAP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLAP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUser">
<Global>^PMPDevelopAppraisal</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Develop.DL_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLAP_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLAP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPDevelopAppraisalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
