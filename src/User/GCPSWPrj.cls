/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 项目
Class User.GCPSWPrj Extends %Persistent [ SqlTableName = GCPSW_Prj, StorageStrategy = SQLStorage ]
{

Relationship ChildKPI As User.GCPSWPrjKPI [ Cardinality = children, Inverse = PKParRef ];

Index RowIDBasedIDKeyIndex On PID [ IdKey, PrimaryKey, Unique ];

/// P_ID
Property PID As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.GCPSW.Prj(0))}, Required, SqlFieldName = P_ID ];

/// 代码
Property PCode As %String [ SqlColumnNumber = 2, SqlFieldName = P_Code ];

/// 描述
Property PDesc As %String [ SqlColumnNumber = 3, SqlFieldName = P_Desc ];

/// 开始日期
Property PStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = P_StartDate ];

/// 结束日期
Property PEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = P_EndDate ];

/// 科研项目	
Property PPPRowId As User.DHCDocPilotProject [ SqlColumnNumber = 6, SqlFieldName = P_PPRowId ];

/// 创建日期	
Property PAddDate As %Date [ SqlColumnNumber = 7, SqlFieldName = P_AddDate ];

/// 创建时间	
Property PAddTime As %Time [ SqlColumnNumber = 8, SqlFieldName = P_AddTime ];

/// 创建人	
Property PAddUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = P_AddUser ];

/// 备注
Property PNote As %String [ SqlColumnNumber = 10, SqlFieldName = P_Note ];

/// 状态(U:完成)
Property PStatus As %String [ SqlColumnNumber = 11, SqlFieldName = P_Status ];

/// 团队可见
Property PTeamView As %String [ SqlColumnNumber = 12, SqlFieldName = P_TeamView ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="P_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="P_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="P_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="P_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="P_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="P_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="P_Note">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="P_PPRowId">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="P_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="P_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="P_TeamView">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^CF.DOC.GCPSW.PrjD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>P_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{P_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxPCode">
<Global>^CF.DOC.GCPSW.PrjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>P_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Prj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{P_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{P_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>P_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWPrjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
