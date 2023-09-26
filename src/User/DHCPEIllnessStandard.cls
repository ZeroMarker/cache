/// 疾病维护表
Class User.DHCPEIllnessStandard Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ILLS_RowId, SqlTableName = DHC_PE_IllnessStandard, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEIllnessStandard";

Parameter EXTENTSIZE = 250;

/// 编码
Property ILLSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ILLS_Code ];

/// 疾病描述
Property ILLSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ILLS_Desc ];

/// 疾病建议
Property ILLSDetail As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ILLS_Detail ];

/// 更新人
Property ILLSUserUpdateDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ILLS_UserUpdate_DR ];

/// 更新日期
Property ILLSUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = ILLS_UpdateDate ];

/// 是否疾病
Property ILLSIllness As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ILLS_Illness ];

/// 是否常见病
Property ILLSCommonIllness As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ILLS_CommonIllness ];

/// 是否上报
Property ILLSToReport As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ILLS_ToReport ];

/// 性别
Property ILLSSex As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ILLS_Sex ];

/// 科室（作废）
Property ILLSLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ILLS_Loc_DR ];

/// 类型  1:团体分析疾病对照使用  2：妇科疾病对照使用  3：阳性统计
Property ILLSType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ILLS_Type ];

/// 作废标记
Property ILLSNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ILLS_NoActive ];

/// 更新时间
Property ILLSTimeUpdate As %Time [ SqlColumnNumber = 14, SqlFieldName = ILLS_TimeUpdate ];

/// 知识库疾病表（外部码）
Property ILLSKBXCode As %String [ SqlColumnNumber = 15, SqlFieldName = ILLS_KBXCode ];

/// ILLS_TypeNew  标记 分类1、疾病2、项目3
Property ILLSTypeNew As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ILLS_TypeNew ];

/// ILLS_Type   增加检查分类 （先对应站点信息）
Property ILLSStation As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ILLS_Station ];

/// ILLS_Type  特殊分类（选疾病表数据）
Property ILLSFatherIll As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ILLS_FatherIll ];

/// ILLS_Note  备注 
Property ILLSNote As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ILLS_Note ];

/// 是否对比 
Property ILLSIfCompare As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = ILLS_IfCompare ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEILLS)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEILLS">
<Data name="ILLS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ILLS_CommonIllness">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ILLS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILLS_Detail">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ILLS_FatherIll">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ILLS_IfCompare">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ILLS_Illness">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ILLS_KBXCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ILLS_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ILLS_NoActive">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ILLS_Note">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ILLS_Sex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ILLS_Station">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ILLS_TimeUpdate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ILLS_ToReport">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ILLS_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ILLS_TypeNew">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ILLS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ILLS_UserUpdate_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPEILLS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ILLS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfKBXCode">
<Global>^DHCPEILLS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILLS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KBXCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ILLS_KBXCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ILLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPEILLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ILLS_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCommonIllness">
<Global>^DHCPEILLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CommonIllness"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ILLS_CommonIllness}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPEILLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILLS_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFatherIll">
<Global>^DHCPEILLS</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"FatherIll"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILLS_FatherIll}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIllness">
<Global>^DHCPEILLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Illness"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ILLS_Illness}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToReport">
<Global>^DHCPEILLS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ToReport"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ILLS_ToReport}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEIllnessStandardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
