Class User.PMPContractAgingMode Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCAM_Rowid, SqlTableName = PMP_ContractAgingMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PCAMChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PCTAParRef As PMPContractAging [ Cardinality = parent, Inverse = ChildPCAMSub, Required, SqlFieldName = PCTA_ParRef ];

/// PCAMChildsub
Property PCAMChildsub As %Library.Float [ InitialExpression = {$i(^PMPContractAgingMode($p(%d(0),$c(1),1),"Details",0))}, SqlColumnNumber = 2, SqlFieldName = PCAM_Childsub ];

/// PCAM_Mode
Property PCAMMode As PMPModule [ SqlColumnNumber = 3, SqlFieldName = PCAM_Mode ];

/// PCAM_Status
Property PCAMStatus As PMPDictionary3 [ SqlColumnNumber = 4, SqlFieldName = PCAM_Status ];

/// PCAM_Remark
Property PCAMRemark As %String(COLLATION = "AlphaUp", MAXLEN = 2048, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PCAM_Remark ];

/// PCAM_Date
Property PCAMDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PCAM_Date ];

/// PCAM_Time
Property PCAMTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PCAM_Time ];

/// PCAM_User
Property PCAMUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PCAM_User ];

/// PCAM_UpdateDate
Property PCAMUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PCAM_UpdateDate ];

/// PCAM_UpdateTime
Property PCAMUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = PCAM_UpdateTime ];

/// PCAM_UpdateUser
Property PCAMUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PCAM_UpdateUser ];

/// PCAM_Standby1
Property PCAMStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PCAM_Standby1 ];

/// PCAM_Standby2
Property PCAMStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PCAM_Standby2 ];

/// PCAM_Standby3
Property PCAMStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PCAM_Standby3 ];

/// PCAM_Standby4
Property PCAMStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PCAM_Standby4 ];

/// PCAM_Standby5
Property PCAMStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PCAM_Standby5 ];

/// PCAM_Standby6
Property PCAMStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PCAM_Standby6 ];

/// PCAM_Standby7
Property PCAMStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PCAM_Standby7 ];

/// PCAM_Standby8
Property PCAMStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PCAM_Standby8 ];

/// PCAM_Standby9
Property PCAMStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PCAM_Standby9 ];

/// PCAM_Standby10
Property PCAMStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PCAM_Standby10 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPContractAgingMode("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PCAM_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCAM_Mode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCAM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCAM_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCAM_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PCAM_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCAM_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCAM_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCAM_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PCAM_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PCAM_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PCAM_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PCAM_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PCAM_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCAM_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCAM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCAM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCAM_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCAM_User">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCTA_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPContractAgingMode</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_ContractAging.PCTA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PCAM_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_ContractAging.PCTA_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PCAM_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofMode">
<Global>^PMPContractAgingModei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"MODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ContractAging.PCTA_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCAM_Mode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCAM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPContractAgingModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
