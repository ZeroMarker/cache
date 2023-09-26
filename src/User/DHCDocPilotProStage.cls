/// CTOR: QP
/// DATE: 2020-09-02
/// DESC: 阶段字典表
Class User.DHCDocPilotProStage Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_DocPilotProStage, StorageStrategy = SQLStorage ]
{

/// 阶段名
Property STName As %Library.String [ SqlColumnNumber = 2, SqlFieldName = ST_Name ];

/// 代码
Property STCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ST_Code ];

/// 阶段顺序
Property STOrder As %Library.String [ SqlColumnNumber = 4, SqlFieldName = ST_Order ];

/// 备注
Property STNote As %Library.String [ SqlColumnNumber = 5, SqlFieldName = ST_Note ];

/// 阶段天数
Property STDays As %Library.String [ SqlColumnNumber = 6, SqlFieldName = ST_Days ];

/// 院区
Property STHosp As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = ST_Hosp ];

/// 项目
Property STProject As User.DHCDocPilotProject [ SqlColumnNumber = 8, SqlFieldName = ST_Project ];

/// 是否激活
Property STActive As %Library.String [ SqlColumnNumber = 9, SqlFieldName = ST_Active ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.DOC.Pilot.OEStageD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ST_Active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ST_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ST_Days">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ST_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ST_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ST_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ST_Order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ST_Project">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF.DOC.Pilot.OEStageD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxPrjCode">
<Global>^CF.DOC.Pilot.OEStageI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrjCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ST_Project}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPrjOrder">
<Global>^CF.DOC.Pilot.OEStageI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrjOrder"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ST_Project}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_Order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxProject">
<Global>^CF.DOC.Pilot.OEStageI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Prj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ST_Project}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CF.DOC.Pilot.OEStageI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ST_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospCode">
<Global>^CF.DOC.Pilot.OEStageI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ST_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospOrder">
<Global>^CF.DOC.Pilot.OEStageI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospOrder"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ST_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_Order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^CF.DOC.Pilot.OEStageI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"STOrder"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ST_Order}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ST_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPilotProStageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
