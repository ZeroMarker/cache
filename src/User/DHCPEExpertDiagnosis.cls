/// 专家建议（主检结论及建议）主表
Class User.DHCPEExpertDiagnosis Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ED_RowId, SqlTableName = DHC_PE_ExpertDiagnosis, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEExpertDiagnosis";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEEDCondition As User.DHCPEEDCondition [ Cardinality = children, Inverse = EDCParRef ];

Relationship ChildDHCPEEDLoc As User.DHCPEEDLoc [ Cardinality = children, Inverse = EDLParRef ];

Relationship ChildDHCPEEDBlackBall As User.DHCPEEDBlackBall [ Cardinality = children, Inverse = EDBBParRef ];

/// 诊断结论
Property EDDiagnoseConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ED_DiagnoseConclusion ];

/// 内容
Property EDDetail As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ED_Detail ];

/// 更信人
Property EDUserUpdateDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = ED_UserUpdate_DR ];

/// 更新日期
Property EDDateUpdate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = ED_DateUpdate ];

/// 是否疾病
Property EDIllness As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ED_Illness ];

/// 是否常见病
Property EDCommonIllness As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ED_CommonIllness ];

/// 编号
Property EDCode As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ED_Code ];

/// 站点
Property EDStationDR As User.DHCPEStation [ SqlColumnNumber = 9, SqlFieldName = ED_Station_DR ];

/// 高危
Property EDHighRisk As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ED_HighRisk ];

/// 顺序号
Property EDSort As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ED_Sort ];

/// 站点分类
Property EDStationLocID As User.DHCPEStationLoc [ SqlColumnNumber = 12, SqlFieldName = ED_StationLocID ];

/// 性别 指向CT_Sex
Property EDSexDR As %String [ SqlFieldName = ED_Sex_DR ];

/// 乙肝
Property EDYGCheck As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ED_YGCheck ];

/// 激活
Property EDActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ED_Active ];

/// 更新时间
Property EDTimeUpdate As %Time [ SqlFieldName = ED_TimeUpdate ];

/// 知识库专家建议（外部码）
Property EDKBXCode As %String [ SqlFieldName = ED_KBXCode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEED)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEED">
<Data name="ED_Active">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="ED_Code">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="ED_CommonIllness">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="ED_DateUpdate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="ED_Detail">
<Delimiter>"^"</Delimiter>
<Node>"Detail"</Node>
<Piece>1</Piece>
</Data>
<Data name="ED_DiagnoseConclusion">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="ED_HighRisk">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="ED_Illness">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="ED_KBXCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="ED_Sex_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="ED_Sort">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="ED_StationLocID">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="ED_Station_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="ED_TimeUpdate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="ED_UserUpdate_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="ED_YGCheck">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Global>^DHCPEED</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ED_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="HighRiskIndex">
<Global>^DHCPEED</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HighRisk"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ED_HighRisk}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxOfKBXCode">
<Global>^DHCPEED</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ED_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KBXCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ED_KBXCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPEED</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ED_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConclusion">
<Global>^DHCPEED</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Conclusion"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ED_DiagnoseConclusion}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEExpertDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
