Class User.DHCNewItmAduRec Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = NIAR_Rowid, SqlTableName = DHC_NewItmAduRec, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DHCNewItmAduRecSub [ IdKey, PrimaryKey, Unique ];

Relationship NIARNIParref As User.DHCNewItm [ Cardinality = parent, Inverse = ChildDHCNewItmAduRec, Required, SqlFieldName = NIAR_NIParref ];

Relationship ChildDHCNewItmAduRecPic As User.DHCNewItmAduRecPic [ Cardinality = children, Inverse = NIARPNIARParref ];

Property DHCNewItmAduRecSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DHCNewItmAduRec_Sub ];

/// 审批人
Property NIARAckUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = NIAR_AckUserDR ];

/// 审批日期
Property NIAckDate As %Date [ SqlColumnNumber = 4, SqlFieldName = NIAR_AckDate ];

/// 审批时间
Property NIARAckTime As %Time [ SqlColumnNumber = 5, SqlFieldName = NIARI_AckTime ];

/// 审批意见
Property NIAROpinion As %String [ SqlColumnNumber = 6, SqlFieldName = NIAR_Opinion ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="NIARI_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NIAR_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NIAR_AckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NIAR_Opinion">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCNEWITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_NewItm.NI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCNewItmAduRec_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_NewItm.NI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCNewItmAduRec_Sub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NIAR_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCNewItmAduRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
