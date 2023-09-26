Class User.DHCPHMedLifeTips Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMLT_RowID, SqlTableName = DHC_PHMedLifeTips, StorageStrategy = SQLStorage ]
{

/// 2018-8-3 hezhigang
/// 用于保存出院带药维护的服药及生活提示
Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMLTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHMedLifeTips Parent Reference PHMLT_PHME_Parref
Relationship PHMLTPHMEParref As User.DHCPHMedEducation [ Cardinality = parent, Inverse = ChildDHCPHMLifeTips, Required, SqlFieldName = PHMLT_PHME_Parref ];

/// PHMLT_ChildSub
Property PHMLTChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMLT_ChildSub ];

/// PHMLT_ID  服药及生活提示ID
Property PHMLTID As DHCPHMedAndLifeTips [ SqlColumnNumber = 3, SqlFieldName = PHMLT_ID ];

/// PHMLT_Code 服药及生活提示描述
Property PHMLTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHMLT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHMLT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMLT_ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHMLTS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMedEducation.PHME_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMLT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMedEducation.PHME_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MLT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMLT_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMedLifeTipsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
