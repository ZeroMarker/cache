Class User.DHCPHMEGuiContent Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMEGC_RowID, SqlTableName = DHC_PHMEGuiContent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMEGCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHMedEducation Parent Reference PHMEGC_PHME_Parref
Relationship PHMEGCPHMEParref As User.DHCPHMedEducation [ Cardinality = parent, Inverse = ChildDHCPHMEGUICONTENT, Required, SqlFieldName = PHMEGC_PHME_Parref ];

/// PHMEGC_ChildSub
Property PHMEGCChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMEGC_ChildSub ];

/// PHMEGC_Code  代码
Property PHMEGCCode As User.DHCPHGuiScope [ SqlColumnNumber = 3, SqlFieldName = PHMEGC_Code ];

/// PHMEGC_GuidDesc 指导内容描述
Property PHMEGCGuidDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHMEGC_GuidDesc ];

Property PHMEGCGuiScopeDR As DHCPHGuiScope [ SqlColumnNumber = 5, SqlFieldName = PHMEGC_GuiScope_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHMEGC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMEGC_GuiScope_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMEGC_GuidDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHME</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMedEducation.PHME_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMEGC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMedEducation.PHME_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMEGC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMEGuiContentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
