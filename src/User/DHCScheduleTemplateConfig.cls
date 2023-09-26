Class User.DHCScheduleTemplateConfig Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHCScheduleTemplateConfig, StorageStrategy = DHCScheduleTemplateConfig ]
{

/// 代码
Property STCCode As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = STCCode ];

/// 描述
Property STCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = STCDesc ];

/// 类型
Property STCType As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = STCType ];

/// 父关联ID
Property STCFatherCode As %Library.String [ SqlColumnNumber = 5, SqlFieldName = STCFatherCode ];

/// 关联表名称
Property STCDataTemp As %Library.String [ SqlColumnNumber = 6, SqlFieldName = STCDataTemp ];

/// 关联表展示字段
Property STCDataTempDesc As %Library.String [ SqlColumnNumber = 7, SqlFieldName = STCDataTempDesc ];

/// 是否有效
Property STCActive As %Library.String [ SqlColumnNumber = 8, SqlFieldName = STCActive ];

/// 医院
Property STCHospDr As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = STCHospDr ];

Property STCDataTempGlobal As %Library.String [ SqlColumnNumber = 10, SqlFieldName = STCDataTempGlobal ];

Property STCDataMultCheck As %Library.String [ SqlColumnNumber = 11, SqlFieldName = STCDataMultCheck ];

/// 医院表达式
Property STCDataHospShow As %Library.String(COLLATION = "Exact", MAXLEN = 300000, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = STCDataHospShow ];

/// 医嘱项 STCType为Order
Property STCArcimDr As ARCItmMast [ SqlColumnNumber = 13, SqlFieldName = STCArcimDr ];

/// ICD 诊断 STCType为Diag
Property STCICDDr As MRCICDDx [ SqlColumnNumber = 14, SqlFieldName = STCICDDr ];

Storage DHCScheduleTemplateConfig
{
<SqlIdExpression>$i(^DHCSCHEDULETEMPCON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="STCActive">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STCArcimDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="STCCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STCDataHospShow">
<Node>"hospshow"</Node>
</Data>
<Data name="STCDataMultCheck">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STCDataTemp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STCDataTempDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STCDataTempGlobal">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STCDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STCFatherCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STCHospDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STCICDDr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="STCType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSCHEDULETEMPCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^DHCSCHEDULETEMPCONi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STCHospDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCScheduleF212S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
