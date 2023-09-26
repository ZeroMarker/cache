/// 站点字典表
Class User.DHCPEStation Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ST_RowId, SqlTableName = DHC_PE_Station, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEStation";

Parameter EXTENTSIZE = 250;

Index STCodeUnqIdx1 On STCode [ Unique ];

Relationship ChildDHCPEOrderDetail As User.DHCPEOrderDetail [ Cardinality = children, Inverse = ODParRef ];

Relationship ChildDHCPEStationOrder As User.DHCPEStationOrder [ Cardinality = children, Inverse = STORDParRef ];

Relationship ChildDHCPEStationWait As User.DHCPEStationWait [ Cardinality = children, Inverse = STWParRef ];

Relationship ChildDHCPEStationLoc As User.DHCPEStationLoc [ Cardinality = children, Inverse = STLParRef ];

/// 激活
Property STActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ST_Active ];

/// 代码
Property STCode As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ST_Code ];

/// 描述
Property STDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ST_Desc ];

/// 【作废】站点所在位置
Property STPlace As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ST_Place ];

/// 【作废】总检顺序
Property STSequence As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 5, SqlFieldName = ST_Sequence ];

/// 【作废】自动审核
Property STAutoAudit As %Library.String [ SqlColumnNumber = 7, SqlFieldName = ST_AutoAudit ];

/// 【作废】界面类型
Property STLayoutType As %Library.String [ SqlColumnNumber = 8, SqlFieldName = ST_LayoutType ];

/// 【作废】按钮类型
Property STButtonType As %Library.String [ SqlColumnNumber = 9, SqlFieldName = ST_ButtonType ];

/// 【作废】报告顺序
Property STReportSequence As %Library.String [ SqlColumnNumber = 10, SqlFieldName = ST_ReportSequence ];

/// 更新日期
Property STUpdateDate As %Date [ SqlFieldName = ST_UpdateDate ];

/// 更新时间
Property STUpdateTime As %Time [ SqlFieldName = ST_UpdateTime ];

/// 更信人 指向SS_User
Property STUpdateUserDR As %String [ SqlFieldName = ST_UpdateUserDR ];

/// 知识库站点项目分类代码（外部码）
Property STKBXCode As %String [ SqlFieldName = ST_KBXCode ];

/// 知识库站点项目分类描述
Property STKBItemCatDesc As %String(MAXLEN = 200) [ SqlFieldName = ST_KBItemCatDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEST)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEST">
<Data name="ST_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ST_AutoAudit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ST_ButtonType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ST_KBItemCatDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ST_KBXCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ST_LayoutType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ST_Place">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ST_ReportSequence">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ST_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ST_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ST_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ST_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfKBXCode">
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KBXCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ST_KBXCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTCode">
<Global>^DHCPEST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowId</Field>
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
<Expression>$$ALPHAUP({ST_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTDesc">
<Global>^DHCPEST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ST_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEStationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
