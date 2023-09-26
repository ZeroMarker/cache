Class User.PMPContractDetails Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCTD_Rowid, SqlTableName = PMP_ContractDetails, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PCTDChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PCTParRef As PMPContract [ Cardinality = parent, Inverse = ChildPCTDSub, Required, SqlFieldName = PCT_ParRef ];

/// PCTDChildsub
Property PCTDChildsub As %Library.Float [ InitialExpression = {$i(^PMPContractDetails($p(%d(0),$c(1),1),"Details",0))}, SqlColumnNumber = 2, SqlFieldName = PCTD_Childsub ];

/// PCTD_Title
Property PCTDTitle As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PCTD_Title ];

/// PCTD_Level
Property PCTDLevel As PMPDictionary3 [ SqlColumnNumber = 4, SqlFieldName = PCTD_Level ];

/// PCTD_FatherLevel
Property PCTDFatherLevel As PMPContractDetails [ SqlColumnNumber = 5, SqlFieldName = PCTD_FatherLevel ];

/// PCTD_Menu
Property PCTDMenu As %String(COLLATION = "AlphaUp", MAXLEN = 2048, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PCTD_Menu ];

/// PCTD_Remark
Property PCTDRemark As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PCTD_Remark ];

/// PCTD_Date
Property PCTDDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PCTD_Date ];

/// PCTD_Time
Property PCTDTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PCTD_Time ];

/// PCTD_User
Property PCTDUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PCTD_User ];

/// PCTD_UpdateDate
Property PCTDUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PCTD_UpdateDate ];

/// PCTD_UpdateTime
Property PCTDUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PCTD_UpdateTime ];

/// PCTD_UpdateUser
Property PCTDUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PCTD_UpdateUser ];

/// PCTD_Standby1
Property PCTDStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PCTD_Standby1 ];

/// PCTD_Standby2
Property PCTDStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PCTD_Standby2 ];

/// PCTD_Standby3
Property PCTDStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PCTD_Standby3 ];

/// PCTD_Standby4
Property PCTDStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PCTD_Standby4 ];

/// PCTD_Standby5
Property PCTDStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PCTD_Standby5 ];

/// PCTD_Standby6
Property PCTDStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PCTD_Standby6 ];

/// PCTD_Standby7
Property PCTDStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PCTD_Standby7 ];

/// PCTD_Standby8
Property PCTDStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PCTD_Standby8 ];

/// PCTD_Standby9
Property PCTDStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PCTD_Standby9 ];

/// PCTD_Standby10
Property PCTDStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PCTD_Standby10 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPContractDetails("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PCTD_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCTD_FatherLevel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCTD_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCTD_Menu">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCTD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCTD_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCTD_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PCTD_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCTD_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PCTD_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PCTD_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PCTD_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PCTD_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PCTD_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PCTD_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PCTD_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCTD_Title">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCTD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCTD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCTD_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCTD_User">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCT_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPContractDetails</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_Contract.PCT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PCTD_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_Contract.PCT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PCTD_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofFatherLevelv">
<Global>^PMPContractDetailsi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"FatherLevel"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Contract.PCT_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTD_Level}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCTD_FatherLevel}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCTD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofLevel">
<Global>^PMPContractDetailsi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"LEVEL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Contract.PCT_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTD_Level}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCTD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofLevelvFather">
<Global>^PMPContractDetailsi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"LevelvFather"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Contract.PCT_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTD_FatherLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCTD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPContractDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
