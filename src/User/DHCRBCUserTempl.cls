Class User.DHCRBCUserTempl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DUC_RowID, SqlTableName = DHCRBC_UserTempl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DUC_User_DR
Property DUCUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DUC_User_DR ];

/// DUC_TemplCat_DR
Property DUCTemplCatDR As User.DHCRBCTemplCat [ SqlColumnNumber = 3, SqlFieldName = DUC_TemplCat_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCTemplSet("UserTemp"))</SqlIdExpression>
<SQLMap name="IndexUser">
<Global>^DHCRBCTemplSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DUC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UserTempl"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUC_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DUC_TemplCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DUC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCTemplSet</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DUC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UserTemp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCUserTemplS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
