/// 基础数据平台-临床知识库-生理字典表
Class User.DHCPhysiologyFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHYF_RowId, SqlTableName = DHC_PhysiologyFeild, StorageStrategy = SQLStorage ]
{

// ^DHCPHYSIF

Property PHYFCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHYF_Code ];

Property PHYFDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHYF_Desc ];

Property PHYFType As %String [ SqlColumnNumber = 4, SqlFieldName = PHYF_Type ];

Property PHYFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHYF_ActiveFlag ];

Property PHYFSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHYF_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHYSIF(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHYSIFi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHYF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHYF_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHYF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHYSIFi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHYF_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHYF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MaterData">
<Data name="PHYF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHYF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHYF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHYF_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHYF_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHYSIF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHYF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHYF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHYF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPhysiologyFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
