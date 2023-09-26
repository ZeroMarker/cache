Class User.DHCJFYJAcountPaym Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCJFYJPM_RowID, SqlTableName = DHC_JFYJAcountPaym, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DHCJFYJPMChildsub [ IdKey, PrimaryKey, Unique ];

/// Dhc_JFYJAcount Parent Reference
Relationship DHCJFYJPMAcctdr As User.DhcJFYJAcount [ Cardinality = parent, Inverse = ChildDHCJFYJAcountPaym, Required, SqlFieldName = DHCJFYJPM_Acct_dr ];

/// DHCJFYJPM_Childsub
Property DHCJFYJPMChildsub As %Library.Float [ InitialExpression = {$i(^DHCJFYJACOUNTPAYM($p(%d(0),$c(1),1),"PMSUB",0))}, SqlColumnNumber = 2, SqlFieldName = DHCJFYJPM_Childsub ];

/// DHCJFYJPM_PayMode_dr
Property DHCJFYJPMPayModedr As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = DHCJFYJPM_PayMode_dr ];

/// DHCJFYJPM_LastRemain
Property DHCJFYJPMLastRemain As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DHCJFYJPM_LastRemain ];

/// DHCJFYJPM_JfSum
Property DHCJFYJPMJfSum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DHCJFYJPM_JfSum ];

/// DHCJFYJPM_DfSum
Property DHCJFYJPMDfSum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DHCJFYJPM_DfSum ];

/// DHCJFYJPM_CurrentRemain
Property DHCJFYJPMCurrentRemain As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DHCJFYJPM_CurrentRemain ];

/// DHCJFYJPM_PrintFlag
Property DHCJFYJPMPrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCJFYJPM_PrintFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterMap">
<Data name="DHCJFYJPM_Acct_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCJFYJPM_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCJFYJPM_CurrentRemain">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCJFYJPM_DfSum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCJFYJPM_JfSum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCJFYJPM_LastRemain">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCJFYJPM_PayMode_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCJFYJPM_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCJFYJACOUNTPAYM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Dhc_JFYJAcount.Acct_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCJFYJPM_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Dhc_JFYJAcount.Acct_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PMSUB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCJFYJPM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFYJAcountPaymS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
