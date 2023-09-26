/// 基础数据平台-临床知识库-病症字典
Class User.DHCPHDiseaseList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHDISL_RowId, SqlTableName = DHC_PHDiseaseList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

// ^DHCPHDISL

Relationship ChildDHCPHDiseaseItmList As User.DHCPHDiseaseItmList [ Cardinality = children, Inverse = PHDISLIDisDr ];

Property PHDISLDiseaCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHDISL_DiseaCode ];

Property PHDISLDiseaDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHDISL_DiseaDesc ];

Property PHDISLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHDISL_ActiveFlag ];

Property PHDISLSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHDISL_SysFlag ];

// 新增字段：备注 2016/6/22

Property PHDISLRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHDISL_Remark ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISL(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHDISL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDISL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHDISL_DiseaCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDISL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="PHDISL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDISL_DiseaCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDISL_DiseaDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDISL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDISL_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHDISL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDISL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHDISL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHDISL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDISL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHDISL_DiseaDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDISL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHDISL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
