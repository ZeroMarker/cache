Class User.DHCNewItmAduRecPic Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = NIARP_Rowid, SqlTableName = DHC_NewItmAduRecPic, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DHCNewItmAduRecPicSub [ IdKey, PrimaryKey, Unique ];

Relationship NIARPNIARParref As User.DHCNewItmAduRec [ Cardinality = parent, Inverse = ChildDHCNewItmAduRecPic, Required, SqlFieldName = NIARP_NIARParref ];

Property DHCNewItmAduRecPicSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DHCNewItmAduRecPic_Sub ];

/// 图片路径
Property NIARPSrc As %String [ SqlColumnNumber = 3, SqlFieldName = NIARP_Src ];

/// 图片类型
Property NIARPType As %String [ SqlColumnNumber = 4, SqlFieldName = NIARP_Type ];

Storage SQLStorage
{
<SQLMap name="DataMater">
<Data name="NIARP_Src">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NIARP_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCNEWITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_NewItm.NI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_NewItmAduRec.DHCNewItmAduRec_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHCNewItmAduRecPic_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_NewItm.NI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_NewItmAduRec.DHCNewItmAduRec_Sub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCNewItmAduRecPic_Sub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NIARP_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCNewItmAduRecPicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
