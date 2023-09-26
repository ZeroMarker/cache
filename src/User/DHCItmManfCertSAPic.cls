Class User.DHCItmManfCertSAPic Extends (%Persistent, User.Abstract) [ SqlRowIdName = ISAP_RowId, SqlTableName = DHC_ItmManfCert_SAPic, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On ISAPChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ISAPSAParRef As User.DHCItmManfCertSA [ Cardinality = parent, Inverse = ChildDHCItmManfCertSAPic, Required, SqlFieldName = ISAP_SA_ParRef ];

Property ISAPChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCIMCSA($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"SA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"PIC",0))}, SqlColumnNumber = 2, SqlFieldName = ISAP_ChildSub ];

Property ISAPAPCVMDR As User.APCVendor [ SqlColumnNumber = 3, SqlFieldName = ISAP_APCVM_DR ];

Property ISAPPicFileName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ISAP_PicFileName ];

Property ISAPType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ISAP_Type ];

Property ISAPSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = ISAP_SSUSR_DR ];

Property ISAPDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ISAP_Date ];

Property ISAPTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ISAP_Time ];

Property ISAPActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = ISAP_Active ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ISAP_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISAP_Active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ISAP_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ISAP_PicFileName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISAP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISAP_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISAP_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCIMCSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmManfCert.IMC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_ItmManfCert_SA.ISA_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ISAP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmManfCert.IMC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmManfCert_SA.ISA_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ISAP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ISAP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmManfCertSAPicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
