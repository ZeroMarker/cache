/// 医院楼表
/// 基础数据平台-李可凡
/// 2020年8月11日
Class User.CTLocBuilding Extends (%Persistent, User.Abstract) [ SqlRowIdName = CTLB_RowId, SqlTableName = CT_LocBuilding, StorageStrategy = SQLStorage ]
{

Relationship ChildFloor As User.CTLocBuildingFloor [ Cardinality = children, Inverse = CTLBFParRef ];

/// Code
Property CTLBCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTLB_Code ];

/// Desc
Property CTLBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTLB_Desc ];

/// Date From
Property CTLBDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CTLB_DateFrom ];

/// Date To
Property CTLBDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CTLB_DateTo ];

/// Mark
Property CTLBMark As %String [ SqlColumnNumber = 6, SqlFieldName = CTLB_Mark ];

/// Hospital DR
Property CTLBHospitalDR As CTHospital [ Required, SqlColumnNumber = 7, SqlFieldName = CTLB_HospitalDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CT("CTLB",0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CTLB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTLB_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTLB_HospitalDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTLB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMap">
<Data name="CTLB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTLB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTLB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTLB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTLB_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTLB_Mark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CTLB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CTLB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CTLB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTLB_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTLB_HospitalDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTLB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTLB_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocBuildingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
