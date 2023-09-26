/// CTOR: QP
/// DATE: 2020-07-04
/// DESC: 化疗日期状态表
Class User.ChemoPlanDateStatus Extends %Persistent [ SqlTableName = Chemo_PlanDateStatus, StorageStrategy = SQLStorage ]
{

Relationship PDSParRef As User.ChemoPlanDate [ Cardinality = parent, Inverse = ChildStatus, Required, SqlFieldName = PDS_ParRef ];

Index RowIDBasedIDKeyIndex On PDSChildSub [ IdKey, PrimaryKey, Unique ];

/// PDS_ChildSub
Property PDSChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.PlanDate(+$s($d(initvalue):initvalue,1:%d(0)),"S",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PDS_ChildSub ];

/// 状态(N,A,S,U：初始,未完成,中止,完成)
Property PDSStatus As %String [ SqlColumnNumber = 3, SqlFieldName = PDS_Status ];

/// 审核日期
Property PDSDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PDS_Date ];

/// 审核时间
Property PDSTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PDS_Time ];

/// 审核人
Property PDSUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PDS_User ];

/// 科室
Property PDSLoc As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = PDS_Loc ];

/// 备注
Property PDSNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PDS_Note ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PDS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDS_Loc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDS_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDS_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDS_User">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanDateD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PDS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxStatus">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PDS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanDateStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDS_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDS_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanDateStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
