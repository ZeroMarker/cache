Class User.DHCPHMonItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMI_RowID, SqlTableName = DHC_PHMonItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHMI_Code  代码
Property PHMICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHMI_Code ];

/// PHMI_Desc  描述
Property PHMIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHMI_Desc ];

/// PHMI_ML_DR  监护级别
Property PHMIMLDR As User.DHCPHMonLevel [ SqlColumnNumber = 4, SqlFieldName = PHMI_ML_DR ];

/// PHMI_CTLOC_DR  指定科室
Property PHMICTLOCDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PHMI_CTLOC_DR ];

/// PHMI_SubClass_DR  学科分类
Property PHMISubClassDR As User.DHCPHMonSubClass [ SqlColumnNumber = 6, SqlFieldName = PHMI_SubClass_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMI_ML_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMI_SubClass_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHMI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocLevel">
<Global>^DHCPHMI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{PHMI_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocLevel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMI_ML_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubClassLevel">
<Global>^DHCPHMI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PHMI_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SubClassLevel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMI_SubClass_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMI_ML_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
