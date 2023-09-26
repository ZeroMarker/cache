Class User.DHCIncHosp Extends (%Persistent, User.Abstract) [ SqlRowIdName = IncHosp_ROWID, SqlTableName = DHC_IncHosp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property IncHospINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = IncHosp_INCI_DR ];

Property IncHospHOSPDR As User.CTHospital [ SqlColumnNumber = 3, SqlFieldName = IncHosp_HOSP_DR ];

Property IncHospZero As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = IncHosp_Zero ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINCHOSP(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IncHosp_HOSP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IncHosp_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IncHosp_Zero">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINCHOSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IncHosp_INCI_DR</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^DHCINCHOSP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IncHosp_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_HOSP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCINCHOSP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IncHosp_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIHOSP">
<Global>^DHCINCHOSP</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncHosp_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCIHOSP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_HOSP_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{IncHosp_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IncHosp_ROWID</SqlRowIdName>
<StreamLocation>^User.DHCIncHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
