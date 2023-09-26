Class User.DHCPayMonLB Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PMLB_Rowid, SqlTableName = DHC_PayMonLB, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PMLBChildsub [ IdKey, PrimaryKey, Unique ];

/// PMLB_PM_Parref
Relationship PMLBPMParref As User.DHCPayMon [ Cardinality = parent, Inverse = ChildDHCPayMonLB, Required, SqlFieldName = PMLB_PM_Parref ];

/// PMLBChildsub
Property PMLBChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PMLB_Childsub ];

/// PMLB_INCLB_DR
Property PMLBINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = PMLB_INCLB_DR ];

/// PMLB_LastUnPayRpAmt
Property PMLBLastUnPayRpAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PMLB_LastUnPayRpAmt ];

/// PMLB_RecRpAmt
Property PMLBRecRpAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PMLB_RecRpAmt ];

/// PMLB_RetRpAmt
Property PMLBRetRpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PMLB_RetRpAmt ];

/// PMLB_PayAmt
Property PMLBPayAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PMLB_PayAmt ];

/// PMLB_UnPayRpAmt
Property PMLBUnPayRpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PMLB_UnPayRpAmt ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPAYMONLB(0))</SqlIdExpression>
<SQLMap name="datamaster">
<Data name="PMLB_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PMLB_LastUnPayRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMLB_PayAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PMLB_RecRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMLB_RetRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PMLB_UnPayRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPAYMONLB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PayMon.PM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PMLB_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PayMon.PM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PMLB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexlb">
<Global>^DHCPAYMONLB</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PayMon.PM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PMLB_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PMLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PMLB_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PayMon.PM_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PMLB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPayMonLBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
