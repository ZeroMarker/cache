Class User.DHCItmManfCertPic Extends (%Persistent, User.Abstract) [ SqlRowIdName = IMCP_RowId, SqlTableName = DHC_ItmManfCertPic, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On IMCPChildSub [ IdKey, PrimaryKey, Unique ];

Relationship IMCPMCParRef As User.DHCItmManfCert [ Cardinality = parent, Inverse = ChildDHCItmManfCertPic, Required, SqlFieldName = IMCP_MC_ParRef ];

Property IMCPChildSub As %Float [ InitialExpression = {$i(^DHCIMCSA($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"IMCP",0))}, SqlColumnNumber = 2, SqlFieldName = IMCP_ChildSub ];

Property IMCPPicFileName As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IMCP_PicFileName ];

Property IMCPType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IMCP_Type ];

Property IMCPSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = IMCP_SSUSR_DR ];

Property IMCPDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = IMCP_Date ];

Property IMCPTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = IMCP_Time ];

Property IMCPActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 8, SqlFieldName = IMCP_Active ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IMCP_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IMCP_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IMCP_PicFileName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IMCP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IMCP_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IMCP_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCIMCSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmManfCert.IMC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IMCP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmManfCert.IMC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"IMCP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IMCP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IMCP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmManfCertPicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
