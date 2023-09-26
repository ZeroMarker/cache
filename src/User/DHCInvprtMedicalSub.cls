Class User.DHCInvprtMedicalSub Extends (%Persistent, User.Abstract) [ SqlRowIdName = PRTSub_RowID, SqlTableName = DHC_InvprtMedicalSub, StorageStrategy = SqlStorage ]
{

Relationship InvMedParRef As User.DHCInvprtMedical [ Cardinality = parent, Inverse = ChildDHCInvprtMedicalSub, Required, SqlFieldName = PRTSub_Prt_Parref ];

/// PRTSub_ChildSub
Property PRTSubChildSub As %Float [ InitialExpression = {$i(^DHCINVPRTMEDICAL($p(%d(0),$c(1)),"P",0))}, SqlColumnNumber = 2, SqlFieldName = PRTSub_ChildSub ];

/// PRTSub_Itm_Dr
Property PRTSubItmDr As %String [ SqlColumnNumber = 3, SqlFieldName = PRTSub_Itm_Dr ];

/// PRTSub_Price
Property PRTSubPrice As %Float [ Required, SqlColumnNumber = 4, SqlFieldName = PRTSub_Price ];

/// PRTSub_Qty
Property PRTSubQty As %Integer [ Required, SqlColumnNumber = 5, SqlFieldName = PRTSub_Qty ];

/// PRTSub_Acount
Property PRTSubAcount As %Float [ Required, SqlColumnNumber = 6, SqlFieldName = PRTSub_Acount ];

Index RowIDBasedIDKeyIndex On PRTSubChildSub [ IdKey, PrimaryKey, Unique ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MasterMap">
<Data name="PRTSub_Acount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRTSub_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRTSub_Itm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRTSub_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRTSub_Prt_Parref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRTSub_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINVPRTMEDICAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InvprtMedical.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PRTSub_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_InvprtMedical.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRTSub_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRTSub_RowID</SqlRowIdName>
<StreamLocation>^User.DHCInvprtMedicalSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
