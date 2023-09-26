Class User.DHCItmManfCertSA Extends (%Persistent, User.Abstract) [ SqlRowIdName = ISA_RowId, SqlTableName = DHC_ItmManfCert_SA, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On ISAChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ISAParRef As User.DHCItmManfCert [ Cardinality = parent, Inverse = ChildDHCItmManfCertSA, Required, SqlFieldName = ISA_ParRef ];

Relationship ChildDHCItmManfCertSAPic As User.DHCItmManfCertSAPic [ Cardinality = children, Inverse = ISAPSAParRef ];

Property ISAChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCIMCSA($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"SA",0))}, SqlColumnNumber = 2, SqlFieldName = ISA_ChildSub ];

Property ISACode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ISA_Code ];

Property ISADesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ISA_Desc ];

Property ISAVendor1DR As User.APCVendor [ SqlColumnNumber = 5, SqlFieldName = ISA_Vendor1_DR ];

Property ISAVendor1Lic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ISA_Vendor1_Lic ];

Property ISAVendor1LicExpDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ISA_Vendor1_LicExpDate ];

Property ISAVendor2DR As User.APCVendor [ SqlColumnNumber = 8, SqlFieldName = ISA_Vendor2_DR ];

Property ISAVendor2Lic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ISA_Vendor2_Lic ];

Property ISAVendor2LicExpDate As %Date [ SqlColumnNumber = 10, SqlFieldName = ISA_Vendor2_LicExpDate ];

Property ISAVendor3DR As User.APCVendor [ SqlColumnNumber = 11, SqlFieldName = ISA_Vendor3_DR ];

Property ISAVendor3Lic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ISA_Vendor3_Lic ];

Property ISAVendor3LicExpDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ISA_Vendor3_LicExpDate ];

Property ISAVendor4DR As User.APCVendor [ SqlColumnNumber = 14, SqlFieldName = ISA_Vendor4_DR ];

Property ISAVendor4Lic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ISA_Vendor4_Lic ];

Property ISAVendor4LicExpDate As %Date [ SqlColumnNumber = 16, SqlFieldName = ISA_Vendor4_LicExpDate ];

Property ISAVendor5DR As User.APCVendor [ SqlColumnNumber = 17, SqlFieldName = ISA_Vendor5_DR ];

Property ISAVendor5Lic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ISA_Vendor5_Lic ];

Property ISAVendor5LicExpDate As %Date [ SqlColumnNumber = 19, SqlFieldName = ISA_Vendor5_LicExpDate ];

Property ISAActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = ISA_Active ];

Property ISAChainString As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlComputeCode = {s {ISA_ChainString}={ISA_Vendor1_DR}_"&"_{ISA_Vendor1_LicExpDate}_"||"_{ISA_Vendor2_DR}_"&"_{ISA_Vendor2_LicExpDate}_"||"_{ISA_Vendor3_DR}_"&"_{ISA_Vendor3_LicExpDate}_"||"_{ISA_Vendor4_DR}_"&"_{ISA_Vendor4_LicExpDate}_"||"_{ISA_Vendor5_DR}_"&"_{ISA_Vendor5_LicExpDate}}, SqlComputed, SqlComputeOnChange = (ISAVendor1DR, ISAVendor1LicExpDate, ISAVendor2DR, ISAVendor2LicExpDate, ISAVendor3DR, ISAVendor3LicExpDate, ISAVendor4DR, ISAVendor5DR, ISAVendor4LicExpDate, ISAVendor5LicExpDate), SqlFieldName = ISA_ChainString ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ISA_Active">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ISA_ChainString">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ISA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISA_Vendor1_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ISA_Vendor1_Lic">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISA_Vendor1_LicExpDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ISA_Vendor2_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISA_Vendor2_Lic">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ISA_Vendor2_LicExpDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ISA_Vendor3_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ISA_Vendor3_Lic">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ISA_Vendor3_LicExpDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ISA_Vendor4_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ISA_Vendor4_Lic">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ISA_Vendor4_LicExpDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ISA_Vendor5_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ISA_Vendor5_Lic">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ISA_Vendor5_LicExpDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCIMCSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmManfCert.IMC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ISA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ItmManfCert.IMC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ISA_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ISA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmManfCertSAS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
