/// 基础数据平台-临床知识库-特殊人群字典
Class User.DHCSpecialPopu Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SPE_RowId, SqlTableName = DHC_SpecialPopu, StorageStrategy = SQLStorage ]
{

// ^DHCSPEP

Relationship ChildDHCSpecialPopuLab As User.DHCSpecialPopuLab [ Cardinality = children, Inverse = SPELPODr ];

Relationship ChildDHCSpecialPopuExa As User.DHCSpecialPopuExa [ Cardinality = children, Inverse = SPEEPODr ];

Relationship ChildDHCSpecialPopuDis As User.DHCSpecialPopuDis [ Cardinality = children, Inverse = SPEDPODr ];

Relationship ChildDHCSpecialPopuHistory As User.DHCSpecialPopuHistory [ Cardinality = children, Inverse = SPEHPODr ];

Property SPECode As %String [ SqlColumnNumber = 2, SqlFieldName = SPE_Code ];

Property SPEDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SPE_Desc ];

Property SPEType As %String [ SqlColumnNumber = 4, SqlFieldName = SPE_Type ];

Property SPELibDr As User.DHCPHLibaryLabel [ SqlColumnNumber = 5, SqlFieldName = SPE_Lib_Dr ];

Property SPEActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SPE_ActiveFlag ];

Property SPESysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SPE_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCSPEP(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({SPE_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="SPE_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SPE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPE_Lib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPE_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SPE_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SPE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({SPE_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSpecialPopuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
