Class User.DHCPHMedReview Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMR_RowID, SqlTableName = DHC_PHMedReview, StorageStrategy = SQLStorage ]
{

/// 2018-8-3 hezhigang
/// 用于保存出院带药维护的复查相关事项
Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMRChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHMedReview Parent Reference PHMEGC_PHME_Parref
Relationship PHMRPHMEParref As User.DHCPHMedEducation [ Cardinality = parent, Inverse = ChildDHCPHMReview, Required, SqlFieldName = PHMR_PHME_Parref ];

/// PHMR_ChildSub
Property PHMRChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMR_ChildSub ];

/// PHMR_ID  复查事项ID
Property PHMRID As DHCPHReviewMatters [ SqlColumnNumber = 3, SqlFieldName = PHMR_ID ];

/// PHMR_Code 复查内容描述
Property PHMRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHMR_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHMR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMR_ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHME</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMedEducation.PHME_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMedEducation.PHME_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMedReviewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
