Class User.DHCMedReportLink Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEDSR_RowID, SqlTableName = DHC_MedReportLink, StorageStrategy = NewStorage1 ]
{

Property MEDSRRepDr As %String [ SqlColumnNumber = 2, SqlFieldName = MEDSR_RepDr ];

Property MEDSRLinkDr As %String [ SqlColumnNumber = 3, SqlFieldName = MEDSR_LinkDr ];

Property MEDSRJob As %String [ SqlColumnNumber = 4, SqlFieldName = MEDSR_Job ];

Property MEDSRCareProv As %String [ SqlColumnNumber = 5, SqlFieldName = MEDSR_CareProv ];

Property MEDSROtherDesc As %String [ SqlColumnNumber = 6, SqlFieldName = MEDSR_OtherDesc ];

Relationship ChildDHCMedReportLinkItm As User.DHCMedReportLinkItm [ Cardinality = children, Inverse = MEDSRIMEDSRParref ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVMEDRLK)</SqlIdExpression>
<SQLMap name="IndexLinkDr">
<Global>^DHCADVMEDRLK</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_LinkDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepDr">
<Global>^DHCADVMEDRLK</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_RepDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MEDSR_CareProv">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEDSR_Job">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDSR_LinkDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEDSR_OtherDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEDSR_RepDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVMEDRLK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedReportLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
