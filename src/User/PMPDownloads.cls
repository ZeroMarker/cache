Class User.PMPDownloads Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDMD_Rowid, SqlTableName = PMP_Downloads, StorageStrategy = SQLStorage ]
{

/// PDMD_SourceDocument
Property PDMDSourceDocument As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PDMD_SourceDocument ];

/// PDMD_Type
Property PDMDType As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDMD_Type ];

/// PDMD_User
Property PDMDUser As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PDMD_User ];

/// PDMD_Date
Property PDMDDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PDMD_Date ];

/// PDMD_Time
Property PDMDTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PDMD_Time ];

/// PDMD_IP
Property PDMDIP As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PDMD_IP ];

/// PDMD_Standby1
Property PDMDStandby1 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PDMD_Standby1 ];

/// PDMD_Standby2
Property PDMDStandby2 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PDMD_Standby2 ];

/// PDMD_Standby3
Property PDMDStandby3 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PDMD_Standby3 ];

/// PDMD_Standby4
Property PDMDStandby4 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PDMD_Standby4 ];

/// PDMD_Standby5
Property PDMDStandby5 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PDMD_Standby5 ];

/// PDMD_Standby6
Property PDMDStandby6 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PDMD_Standby6 ];

/// PDMD_Standby7
Property PDMDStandby7 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PDMD_Standby7 ];

/// PDMD_Standby8
Property PDMDStandby8 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PDMD_Standby8 ];

/// PDMD_Standby9
Property PDMDStandby9 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PDMD_Standby9 ];

/// PDMD_Standby10
Property PDMDStandby10 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PDMD_Standby10 ];

/// PDMD_Remark
Property PDMDRemark As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PDMD_Remark ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPDownloads("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PDMD_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDMD_IP">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDMD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PDMD_SourceDocument">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDMD_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDMD_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PDMD_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDMD_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDMD_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDMD_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDMD_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PDMD_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PDMD_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PDMD_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PDMD_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDMD_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDMD_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PMPDownloads</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDMD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDMD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDateUser">
<Global>^PMPDownloadsi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DateUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDMD_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMD_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIP">
<Global>^PMPDownloadsi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDMD_IP}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPDownloadsi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDMD_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeRowid">
<Global>^PMPDownloadsi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"TYPERowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDMD_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMD_SourceDocument}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPDownloadsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
