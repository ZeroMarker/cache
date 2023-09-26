Class User.DHCRBRegInfoBodyParts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RRB_Rowid, SqlTableName = DHCRB_RegInfo_BodyParts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RRBChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_RegInfo Parent Reference
Relationship RRBParRef As User.DHCRBRegInfo [ Cardinality = parent, Inverse = ChildDHCRBRegInfoBodyParts, Required, SqlFieldName = RRB_ParRef ];

/// Child subscript
Property RRBChildSub As %Library.Float [ InitialExpression = {$i(^mdata("DHCRBREGINFOBODYPARTS"))}, Required, SqlColumnNumber = 2, SqlFieldName = RRB_ChildSub ];

/// RRB_BodyPart_DR
Property RRBBodyPartDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RRB_BodyPart_DR ];

/// RRB_BodyPart_Code_
Property RRBBodyPartCode As %Library.String(COLLATION = "EXACT", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RRB_BodyPart_Code ];

/// RRB_BodyPart_Desc
Property RRBBodyPartDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RRB_BodyPart_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="RRB_BodyPart_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RRB_BodyPart_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RRB_BodyPart_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPACRegInfoBD</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_RegInfo.RAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RRB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODYPARTS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_RegInfo.RAR_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RRB_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBRegInfoBodyPartsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
