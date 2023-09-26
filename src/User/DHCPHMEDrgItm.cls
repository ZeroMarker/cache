Class User.DHCPHMEDrgItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMEDI_RowID, SqlTableName = DHC_PHMEDrgItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMEDIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHMedEducation Parent Reference PHMEDI_PHME_Parref
Relationship PHMEDIPHMEParref As User.DHCPHMedEducation [ Cardinality = parent, Inverse = ChildDHCPHMEDRGITM, Required, SqlFieldName = PHMEDI_PHME_Parref ];

/// PHMEDI_ChildSub
Property PHMEDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMEDI_ChildSub ];

/// PHMEDI_OEORI_DR  医嘱ID
Property PHMEDIOEORIDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHMEDI_OEORI_DR ];

/// PHMEDI_Desc 指导意见
Property PHMEDIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHMEDI_Desc ];

/// PHMEDI_PurPose 用药目的
Property PHMEDIPurPose As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHMEDI_PurPose ];

/// PHMEDI_Notice 注意事项
Property PHMEDINotice As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHMEDI_Notice ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHMEDI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMEDI_Notice">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMEDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMEDI_PurPose">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHME</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMedEducation.PHME_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMEDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMedEducation.PHME_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMEDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMEDrgItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
