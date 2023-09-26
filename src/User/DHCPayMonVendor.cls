Class User.DHCPayMonVendor Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PMV_RowId, SqlTableName = DHC_PayMonVendor, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On PMVChildSub [ IdKey, PrimaryKey, Unique ];

/// PMV_Parref
Relationship PMVParRef As User.DHCPayMon [ Cardinality = parent, Inverse = ChildDHCPayMonVendor, Required, SqlFieldName = PMV_ParRef ];

/// PMV_ChildSub
Property PMVChildSub As %Library.Float [ InitialExpression = {$i(^DHCPAYM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"V",0))}, SqlColumnNumber = 2, SqlFieldName = PMV_ChildSub ];

/// PMV_APCVM_DR
Property PMVAPCVMDR As User.APCVendor [ SqlColumnNumber = 3, SqlFieldName = PMV_APCVM_DR ];

/// PMV_AcctPayableAmt_Last
Property PMVAcctPayableAmtLast As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PMV_AcctPayableAmt_Last ];

/// PMV_AddedAmt
Property PMVAddedAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PMV_AddedAmt ];

/// PMV_PayedAmt
Property PMVPayedAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PMV_PayedAmt ];

/// PMV_AcctPayableAmt
Property PMVAcctPayableAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PMV_AcctPayableAmt ];

Storage SqlStorage
{
<SQLMap name="DataMaster">
<Data name="PMV_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PMV_AcctPayableAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PMV_AcctPayableAmt_Last">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMV_AddedAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMV_PayedAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPAYM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PayMon.PM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PMV_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PayMon.PM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"V"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PMV_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPayMonVendorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
