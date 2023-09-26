/// 站点细项表
Class User.DHCPEOrderDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OD_RowId, SqlTableName = DHC_PE_OrderDetail, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEOrderDetail";

Parameter EXTENTSIZE = 250;

Index ODCodeUnqIdx1 On ODCode;

Index RowIDBasedIDKeyIndex On ODChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPEODStandard As User.DHCPEODStandard [ Cardinality = children, Inverse = ODSParRef ];

/// DHC_PE_Station Parent Reference
Relationship ODParRef As User.DHCPEStation [ Cardinality = parent, Inverse = ChildDHCPEOrderDetail, Required, SqlFieldName = OD_ParRef ];

/// OD_ChildSub
Property ODChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEST($p(%d(0),$c(1),1),"OD",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OD_ChildSub ];

/// 【作废】是否有建议项
Property ODAdvice As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = OD_Advice ];

/// 项目编号
Property ODCode As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = OD_Code ];

/// 项目名称
Property ODDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = OD_Desc ];

/// 说明
Property ODExplain As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OD_Explain ];

/// 表达式
Property ODExpression As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OD_Expression ];

/// 检验项目编码
Property ODLabtrakCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OD_LabtrakCode ];

/// 【作废】顺序号
Property ODSequence As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 9, SqlFieldName = OD_Sequence ];

/// 性别
Property ODSex As %Library.String(DISPLAYLIST = ",Male,Female,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",M,F,N") [ SqlColumnNumber = 11, SqlFieldName = OD_Sex ];

/// 【作废】是否进入小结
Property ODSummary As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = OD_Summary ];

/// 项目类型（T说明型，N数值型，C计算型，S选择型，A多行文本）
Property ODType As %Library.String(DISPLAYLIST = ",Text,Number,Calcul,Select,TextArea", MAXLEN = 8, SELECTIVITY = "16.66667%", TRUNCATE = 1, VALUELIST = ",T,N,C,S,A") [ SqlColumnNumber = 3, SqlFieldName = OD_Type ];

/// 单位
Property ODUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OD_Unit ];

/// 作废标记
Property ODNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = OD_NoActive ];

/// 更新日期
Property ODUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = OD_UpdateDate ];

/// 更新时间
Property ODUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = OD_UpdateTime ];

/// 更新人 指向SS_User
Property ODUpdateUserDR As %String [ SqlColumnNumber = 17, SqlFieldName = OD_UpdateUserDR ];

/// 知识库站点细项代码（外部码）
Property ODKBXCode As %String [ SqlColumnNumber = 18, SqlFieldName = OD_KBXCode ];

/// 知识库站点细项名称
Property ODKBItemDtlDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 19, SqlFieldName = OD_KBItemDtlDesc ];

/// 【新加】站点（在项目更改站点时用，如果此字段有值，以此字段为准）
Property ODStationDR As User.DHCPEStation [ SqlColumnNumber = 20, SqlFieldName = OD_StationDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEOD">
<Data name="OD_Advice">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OD_Code">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OD_Explain">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OD_Expression">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OD_KBItemDtlDesc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OD_KBXCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OD_LabtrakCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OD_NoActive">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OD_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OD_Sex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OD_StationDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OD_Summary">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OD_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OD_Unit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OD_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfKBXCode">
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"KBXCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OD_KBXCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPEST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OD_Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({OD_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPEST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OD_Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({OD_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEOrderDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
