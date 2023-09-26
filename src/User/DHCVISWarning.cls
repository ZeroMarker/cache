Class User.DHCVISWarning Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_WarnId, SqlTableName = DHC_VIS_Warn, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 诊室计算机名
Property VISWarnComputerName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_WarnComputerName ];

/// 院区
Property VISWarnHospitalId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VIS_WarnHospitalId ];

/// 楼号
Property VISWarnBuildId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VIS_WarnBuildId ];

/// 楼层
Property VISWarnFloorId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VIS_WarnFloorId ];

/// 诊区
Property VISWarnClinicalId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = VIS_WarnClinicalId ];

/// 房间
Property VISWarnRoomId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VIS_WarnRoomId ];

/// 科室
Property VISWarnLocId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = VIS_WarnLocId ];

/// 发送至位置
Property VISWarnSendAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = VIS_WarnSendAddress ];

/// 发送至计算机名
Property VISWarnSendToComputerName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = VIS_WarnSendToComputerName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISWarn)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_WarnBuildId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VIS_WarnClinicalId">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VIS_WarnComputerName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_WarnFloorId">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VIS_WarnHospitalId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VIS_WarnLocId">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VIS_WarnRoomId">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VIS_WarnSendAddress">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VIS_WarnSendToComputerName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCVISWarn</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_WarnId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_WarnId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexWarnComputerName">
<Global>^DHCVISWarni</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_WarnId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WarnComputerName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_WarnComputerName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_WarnId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWarnLocId">
<Global>^DHCVISWarni</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_WarnLocId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WarnLocId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_WarnLocId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_WarnId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISWarnS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
