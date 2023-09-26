Class User.DHCPHMediSugItm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHMSI_RowId, SqlTableName = DHCPH_MediSugItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMSIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCPH_MediSuggest Parent Reference
Relationship PHMSIPHMSParRef As User.DHCPHMediSuggest [ Cardinality = parent, Inverse = ChildDHCPHMediSugItm, Required, SqlFieldName = PHMSI_PHMS_ParRef ];

/// PHMSI_ChildSub
Property PHMSIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMSI_ChildSub ];

/// PHMSI_IdentityMark  身份信息 药师 P ,医师 D
Property PHMSIIdentityMark As %Library.String(DISPLAYLIST = ",Pharmacist,Doctor", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",P,D") [ SqlColumnNumber = 3, SqlFieldName = PHMSI_IdentityMark ];

/// PHMSI_Suggestion  建议信息
Property PHMSISuggestion As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHMSI_Suggestion ];

/// PHMSI_User_Dr  操作人
Property PHMSIUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PHMSI_User_Dr ];

/// PHMSI_Date  日期
Property PHMSIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PHMSI_Date ];

/// PHMSI_Time  时间
Property PHMSITime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PHMSI_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterData">
<Data name="PHMSI_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMSI_IdentityMark">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMSI_Suggestion">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMSI_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMSI_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHMSI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPH_MediSuggest.PHMS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCPH_MediSuggest.PHMS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMSI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMediSugItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
