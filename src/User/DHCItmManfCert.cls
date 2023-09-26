Class User.DHCItmManfCert Extends (%Persistent, User.Abstract) [ SqlRowIdName = IMC_RowId, SqlTableName = DHC_ItmManfCert, StorageStrategy = NewStorage1 ]
{

Relationship ChildDHCItmManfCertSA As User.DHCItmManfCertSA [ Cardinality = children, Inverse = ISAParRef ];

Relationship ChildDHCItmManfCertPic As User.DHCItmManfCertPic [ Cardinality = children, Inverse = IMCPMCParRef ];

Property IMCMANFDR As User.PHManufacturer [ SqlColumnNumber = 2, SqlFieldName = IMC_MANF_DR ];

Property IMCCertNo As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IMC_CertNo ];

Property IMCCertExpDate As %Date [ SqlColumnNumber = 4, SqlFieldName = IMC_CertExpDate ];

Property IMCRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IMC_Remark ];

Property IMCDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = IMC_Date ];

Property IMCTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = IMC_Time ];

Property IMCSSUSRDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = IMC_SSUSR_DR ];

Property IMCActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = IMC_Active ];

Property IMCRegistrant As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = IMC_Registrant ];

Property IMCRegAddr As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = IMC_RegAddr ];

Property IMCRegResidence As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = IMC_RegResidence ];

Property IMCAgent As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = IMC_Agent ];

Property IMCAgentResidence As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = IMC_AgentResidence ];

Property IMCTel As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = IMC_Tel ];

Property IMCFax As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = IMC_Fax ];

Property IMCPrdctIngredient As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = IMC_PrdctIngredient ];

Property IMCApplyScope As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IMC_ApplyScope ];

Property IMCPrdctContraindication As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = IMC_PrdctContraindication ];

Property IMCAttachment As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = IMC_Attachment ];

Property IMCOtherContent As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = IMC_OtherContent ];

Property IMCApprovedDate As %Date [ SqlColumnNumber = 22, SqlFieldName = IMC_ApprovedDate ];

Property IMCPrdctStandard As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = IMC_PrdctStandard ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCIMCSA(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IMC_Active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IMC_Agent">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IMC_AgentResidence">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IMC_ApplyScope">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IMC_ApprovedDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IMC_Attachment">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IMC_CertExpDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IMC_CertNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IMC_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IMC_Fax">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IMC_MANF_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IMC_OtherContent">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IMC_PrdctContraindication">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IMC_PrdctIngredient">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IMC_PrdctStandard">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IMC_RegAddr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IMC_RegResidence">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IMC_Registrant">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IMC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IMC_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IMC_Tel">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IMC_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCIMCSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IMC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IMC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexManf">
<Global>^DHCIMCSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IMC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MANF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IMC_MANF_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IMC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IMC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmManfCertS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
