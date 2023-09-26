Class User.PMPDocumentReceive Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCAM_Rowid, SqlTableName = PMP_DocumentReceive, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PDMRChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PDMParRef As PMPDocument [ Cardinality = parent, Inverse = ChildPDMSub, Required, SqlFieldName = PDM_ParRef ];

/// PCAMChildsub
Property PDMRChildsub As %Library.Float [ InitialExpression = {$i(^PMPDocumentReceive($p(%d(0),$c(1),1),"Details",0))}, SqlColumnNumber = 2, SqlFieldName = PDMR_Childsub ];

/// PDMR_ReceiveUser
Property PDMRReceiveUser As SSUser [ SqlColumnNumber = 3, SqlFieldName = PDMR_ReceiveUser ];

/// PDMR_CreatDate
Property PDMRCreatDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PDMR_CreatDate ];

/// PDMR_CreatTime
Property PDMRCreatTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PDMR_CreatTime ];

/// PDMR_CreatUser
Property PDMRCreatUser As SSUser [ SqlColumnNumber = 6, SqlFieldName = PDMR_CreatUser ];

/// PDMR_Date
Property PDMRDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PDMR_Date ];

/// PDMR_Time
Property PDMRTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PDMR_Time ];

/// PDMR_User
Property PDMRUser As SSUser [ SqlColumnNumber = 9, SqlFieldName = PDMR_User ];

/// PDMR_Type
Property PDMRType As %String(DISPLAYLIST = ",已接收,未接收,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 10, SqlFieldName = PDMR_Type ];

/// PDMR_DownloadsType
Property PDMRDownloadsType As %String(DISPLAYLIST = ",已下载,未下载,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 11, SqlFieldName = PDMR_DownloadsType ];

/// PDMR_Standby1
Property PDMRStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PDMR_Standby1 ];

/// PDMR_Standby2
Property PDMRStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PDMR_Standby2 ];

/// PDMR_Standby3
Property PDMRStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PDMR_Standby3 ];

/// PDMR_Standby4
Property PDMRStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PDMR_Standby4 ];

/// PDMR_Standby5
Property PDMRStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PDMR_Standby5 ];

/// PDMR_Standby6
Property PDMRStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PDMR_Standby6 ];

/// PDMR_Standby7
Property PDMRStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PDMR_Standby7 ];

/// PDMR_Standby8
Property PDMRStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PDMR_Standby8 ];

/// PDMR_Standby9
Property PDMRStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PDMR_Standby9 ];

/// PDMR_Standby10
Property PDMRStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PDMR_Standby10 ];

/// PDMR_Remark
Property PDMRRemark As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PDMR_Remark ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPDocumentReceive("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PDMR_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDMR_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDMR_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDMR_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDMR_DownloadsType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDMR_ReceiveUser">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDMR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PDMR_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDMR_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PDMR_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PDMR_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PDMR_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PDMR_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PDMR_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PDMR_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PDMR_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PDMR_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PDMR_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDMR_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDMR_User">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDM_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPDocumentReceive</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_Document.PDM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PDMR_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_Document.PDM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDMR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofCreatDate">
<Global>^PMPDocumentReceivei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CreatDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Document.PDM_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMR_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofCreatDateUser">
<Global>^PMPDocumentReceivei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CreatDateUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Document.PDM_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMR_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMR_CreatUser}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofCreatUser">
<Global>^PMPDocumentReceivei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CREATUSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Document.PDM_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMR_CreatUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPDocumentReceivei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DateReceviveuser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Document.PDM_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDateReceviveuser">
<Global>^PMPDocumentReceivei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DateReceviveuser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Document.PDM_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMR_User}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofReceiveUser">
<Global>^PMPDocumentReceivei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ReceiveUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Document.PDM_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDMR_ReceiveUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPDocumentReceiveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
