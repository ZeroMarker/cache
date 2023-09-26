Class User.DHCAppCatLinkOpt Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ALO_RowId, SqlTableName = DHC_AppCatLinkOpt, StorageStrategy = SQLStorage ]
{

/// 主表ID ALO_Opt_ParRef
Relationship ALOOptParRef As User.DHCAppArcCat [ Cardinality = parent, Inverse = ChildDHCAPPCATLINKOPT, Required, SqlFieldName = ALO_Opt_ParRef ];

/// 子表Sub ALO_ChildSub
Property ALOChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ALO_ChildSub ];

/// 其他项目 ALO_Opt_Dr
Property ALOOptDr As User.DHCAppOtherOpt [ SqlColumnNumber = 3, SqlFieldName = ALO_Opt_Dr ];

Index RowIDBasedIDKeyIndex On ALOChildSub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<IdExpression>$i(^mdata("DHCAPCATO"))</IdExpression>
<SQLMap name="DataMaster">
<Data name="ALO_Opt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPCATO</Global>
<Subscript name="1">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppCatLinkOptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
