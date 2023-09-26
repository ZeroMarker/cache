Class User.DHCPHMonitorItm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHMI_RowID, SqlTableName = DHC_PHMonitorItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHMonitor Parent Reference
Relationship PHMIPHMParref As User.DHCPHMonitor [ Cardinality = parent, Inverse = ChildDHCPHMonitorItm, Required, SqlFieldName = PHMI_PHM_Parref ];

/// PHMI_ChildSub
Property PHMIChildSub As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHMI_ChildSub ];

/// PHMI_Type
Property PHMIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHMI_Type ];

/// PHMI_ARCIM_DR  医嘱ID
Property PHMIARCIMDR As ARCItmMast [ SqlColumnNumber = 7, SqlFieldName = PHMI_ARCIM_DR ];

/// PHMI_AbnVal
Property PHMIAbnVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHMI_AbnVal ];

/// PHMI_AbnDesc
Property PHMIAbnDesc As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHMI_AbnDesc ];

/// PHMI_OrdItem
Property PHMIOrdItem As OEOrdItem [ SqlColumnNumber = 10, SqlFieldName = PHMI_OrdItem ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DateMaster">
<Data name="PHMI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMI_AbnDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMI_AbnVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMI_OrdItem">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMonitor.PHM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMonitor.PHM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonitorItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
