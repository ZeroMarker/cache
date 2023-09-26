/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 抗菌药物基本主配置表：抗菌药物全局开关和全局参数值
Class DHCAnt.Base.MainConfig Extends %Persistent [ StorageStrategy = CacheSQLStorage ]
{

/// MCG_Type 配置类型
Property MCGType As %Library.String [ SqlColumnNumber = 2, SqlFieldName = MCG_Type ];

/// MCG_ParentCode 父级代码,顶级的为BASE
Property MCGParentCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = MCG_ParentCode ];

/// MCG_Code 配置代码
Property MCGCode As %Library.String [ SqlColumnNumber = 4, SqlFieldName = MCG_Code ];

/// MCG_Desc 配置描述
Property MCGDesc As %Library.String [ SqlColumnNumber = 5, SqlFieldName = MCG_Desc ];

/// MCG_Active 是否有效
Property MCGActive As %Boolean [ SqlColumnNumber = 6, SqlFieldName = MCG_Active ];

/// MCG_DateFrom 起始日期
Property MCGDateFrom As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = MCG_DateFrom ];

/// MCG_DateTo  结束日期
Property MCGDateTo As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = MCG_DateTo ];

/// MCG_ControlType 控制类型
Property MCGControlType As %Library.String [ SqlColumnNumber = 9, SqlFieldName = MCG_ControlType ];

/// MCG_ControlValue 控制值
Property MCGControlValue As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MCG_ControlValue ];

/// MCG_ProcessNext  流程下一个节点
Property MCGProcessNext As %Library.String [ SqlColumnNumber = 11, SqlFieldName = MCG_ProcessNext ];

/// MCG_StrB  备用字段2 配置描述
Property MCGStrB As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MCG_StrB ];

/// MCG_StrC  备用字段3 菜单显示顺序
Property MCGStrC As %Library.String [ SqlColumnNumber = 13, SqlFieldName = MCG_StrC ];

/// MCG_StrD  备用字段4 菜单url
Property MCGStrD As %Library.String [ SqlColumnNumber = 14, SqlFieldName = MCG_StrD ];

/// MCG_Hosp  医院
Property MCGHosp As %Library.String [ SqlColumnNumber = 15, SqlFieldName = MCG_Hosp ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCAntBaseMainConfigD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MCG_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MCG_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MCG_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MCG_ControlValue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MCG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MCG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MCG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MCG_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MCG_ParentCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MCG_ProcessNext">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MCG_StrB">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MCG_StrC">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MCG_StrD">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MCG_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAntBaseMainConfigD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMCGCode">
<Global>^DHCAntBaseMainConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MCGCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MCG_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMCGHosp">
<Global>^DHCAntBaseMainConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MCGHosp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MCG_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMCGHospAndCode">
<Global>^DHCAntBaseMainConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MCGHospAndCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MCG_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMCGHospAndType">
<Global>^DHCAntBaseMainConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MCGHospAndType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MCG_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMCGParentCode">
<Global>^DHCAntBaseMainConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MCGParentCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MCG_ParentCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMCGType">
<Global>^DHCAntBaseMainConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MCGType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MCG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMCGTypeCode">
<Global>^DHCAntBaseMainConfigI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MCGTypeCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MCG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MCG_RowId</SqlRowIdName>
<StreamLocation>^DHCAnt.Base.MainConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
