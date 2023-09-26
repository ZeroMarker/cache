Class User.PMPContractMode Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCM_Rowid, SqlTableName = PMP_ContractMode, StorageStrategy = SQLStorage ]
{

/// PCM_Contract_DR
Property PCMContractDR As PMPContract [ SqlColumnNumber = 2, SqlFieldName = PCM_Contract_DR ];

/// PCM_Mode_DR
Property PCMModeDR As PMPModule [ SqlColumnNumber = 3, SqlFieldName = PCM_Mode_DR ];

/// PCM_Date
Property PCMDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PCM_Date ];

/// PCM_Time
Property PCMTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PCM_Time ];

/// PCM_User
Property PCMUser As SSUser [ SqlColumnNumber = 6, SqlFieldName = PCM_User ];

/// PCM_UpdateDate
Property PCMUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PCM_UpdateDate ];

/// PCM_UpdateTime
Property PCMUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PCM_UpdateTime ];

/// PCM_UpdateUser
Property PCMUpdateUser As SSUser [ SqlColumnNumber = 9, SqlFieldName = PCM_UpdateUser ];

/// PCM_Standby1
Property PCMStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PCM_Standby1 ];

/// PCM_Standby2
Property PCMStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PCM_Standby2 ];

/// PCM_Standby3
Property PCMStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PCM_Standby3 ];

/// PCM_Standby4
Property PCMStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PCM_Standby4 ];

/// PCM_Standby5
Property PCMStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PCM_Standby5 ];

/// PCM_Standby6
Property PCMStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PCM_Standby6 ];

/// PCM_Standby7
Property PCMStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PCM_Standby7 ];

/// PCM_Standby8
Property PCMStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PCM_Standby8 ];

/// PCM_Standby9
Property PCMStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PCM_Standby9 ];

/// PCM_Standby10
Property PCMStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PCM_Standby10 ];

/// PCM_Remark
Property PCMRemark As %String(COLLATION = "AlphaUp", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PCM_Remark ];

/// PCM_ContractAging
Property PCMContractAging As PMPContractAging [ SqlColumnNumber = 21, SqlFieldName = PCM_ContractAging ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPContractMode("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PCM_ContractAging">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PCM_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCM_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCM_Mode_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PCM_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCM_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PCM_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCM_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCM_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCM_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCM_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCM_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PCM_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PCM_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PCM_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCM_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCM_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PMPContractMode</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofContract">
<Global>^PMPContractModei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CONTRACT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PCM_Contract_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofMode">
<Global>^PMPContractModei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"MODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PCM_Mode_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPContractModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
