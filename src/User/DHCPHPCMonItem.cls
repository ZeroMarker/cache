Class User.DHCPHPCMonItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMI_RowID, SqlTableName = DHC_PHPCMonItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHPharCare Parent Reference PHMI_PHPC_Parref
Relationship PHMIPHPCParref As User.DHCPHPharCare [ Cardinality = parent, Inverse = ChildDHCPHPCMONITEM, Required, SqlFieldName = PHMI_PHPC_Parref ];

/// PHMI_ChildSub
Property PHMIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMI_ChildSub ];

/// PHMI_MonItm_Dr  监控项目
Property PHMIMonItmDr As User.DHCPHMonItem [ SqlColumnNumber = 3, SqlFieldName = PHMI_MonItm_Dr ];

/// PHMI_Desc  值
Property PHMIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHMI_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHMI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMI_MonItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHPharCare.PHPC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHPharCare.PHPC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPCMonItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
