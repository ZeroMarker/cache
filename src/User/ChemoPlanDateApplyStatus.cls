/// CTOR: QP
/// DATE: 2020-08-07
/// DESC: 化疗日期审核状态表
Class User.ChemoPlanDateApplyStatus Extends %Persistent [ SqlTableName = Chemo_PlanDateApplyStatus, StorageStrategy = SQLStorage ]
{

Relationship PASParRef As User.ChemoPlanDateApply [ Cardinality = parent, Inverse = ChildDetail, Required, SqlFieldName = PAS_ParRef ];

Index RowIDBasedIDKeyIndex On PASChildSub [ IdKey, PrimaryKey, Unique ];

/// PAS_ChildSub
Property PASChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.PlanDate($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"A",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"S",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PAS_ChildSub ];

/// 状态(A,S,RS,Y,RY：申请，科室通过，科室拒绝，药房同意，药房拒绝)
Property PASStatus As %String [ SqlColumnNumber = 3, SqlFieldName = PAS_Status ];

/// 审核日期
Property PASDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PAS_Date ];

/// 审核时间
Property PASTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PAS_Time ];

/// 审核人
Property PASUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PAS_User ];

/// 科室
Property PASLoc As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = PAS_Loc ];

/// 备注
Property PASNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PAS_Note ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PAS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAS_Loc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAS_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAS_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAS_User">
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
<Field>Chemo_PlanDateApply.PDA_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PAS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_PlanDateApply.PDA_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PAS_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanDateApplyStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
