/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 抗菌药物碳青霉烯类及替加环素项目本地化的扩展表
Class User.DHCAntCQMXMode Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHCAnt_CQMXMode, StorageStrategy = SQLStorage ]
{

/// CQMX_Admid
Property Admid As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = CQMX_Admid ];

/// CQMX_Locid
Property Locid As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = CQMX_Locid ];

/// CQMX_ArcimDr
Property ArcimDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = CQMX_ArcimDr ];

/// CQMX_PatMasDr
Property PatMasDr As User.PAPatMas [ SqlColumnNumber = 5, SqlFieldName = CQMX_PatMasDr ];

/// CQMX_InstrucDr 用法
Property InstrucDr As User.PHCInstruc [ SqlColumnNumber = 6, SqlFieldName = CQMX_InstrucDr ];

/// CQMX_IsConsult 是否会诊
Property IsConsult As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CQMX_IsConsult ];

/// CQMX_IsEmergency 是否紧急使用
Property IsEmergency As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CQMX_IsEmergency ];

/// CQMX_IsLab 是否送检
Property IsLab As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CQMX_IsLab ];

/// CQMX_PrescDoc 处方医师
Property PrescDoc As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = CQMX_PrescDoc ];

/// CQMX_PrescDate 处方日期
Property PrescDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CQMX_PrescDate ];

/// CQMX_PrescTime 处方时间
Property PrescTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CQMX_PrescTime ];

/// CQMX_Type 类型：1代表CQMX 2代表TGC
Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CQMX_Type ];

/// CQMX_MainDiagnosisDr 主要诊断Dr
Property MainDiagnosisDr As User.MRCICDDx [ SqlColumnNumber = 14, SqlFieldName = CQMX_MainDiagnosisDr ];

/// CQMX_AimDr 使用目的
Property AimDr As User.DHCAntUsePurpose [ SqlColumnNumber = 15, SqlFieldName = CQMX_AimDr ];

/// CQMX_ApplyDr 申请表
Property ApplyDr As User.DHCDocAntibioticApply [ SqlColumnNumber = 16, SqlFieldName = CQMX_ApplyDr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.ANT.DHCAntCQMXModeD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CQMX_Admid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CQMX_AimDr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CQMX_ApplyDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CQMX_ArcimDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CQMX_InstrucDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CQMX_IsConsult">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CQMX_IsEmergency">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CQMX_IsLab">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CQMX_Locid">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CQMX_MainDiagnosisDr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CQMX_PatMasDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CQMX_PrescDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CQMX_PrescDoc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CQMX_PrescTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CQMX_Type">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^BS.ANT.DHCAntCQMXModeD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^BS.ANT.DHCAntCQMXModeI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_Locid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescDate">
<Global>^BS.ANT.DHCAntCQMXModeI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrescDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_PrescDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^BS.ANT.DHCAntCQMXModeI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CQMX_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAntCQMXModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
