Class User.DHCMedReportLinkItm Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEDSR_ItmRowID, SqlTableName = DHC_MedReportLinkItm, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On MEDSRItmChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MEDSRIMEDSRParref As User.DHCMedReportLink [ Cardinality = parent, Inverse = ChildDHCMedReportLinkItm, Required, SqlFieldName = MEDSRI_MEDSR_Parref ];

Property MEDSRItmChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MEDSR_ItmChildSub ];

Property MEDSRLinkItem As %String [ SqlColumnNumber = 3, SqlFieldName = MEDSR_LinkItem ];

Property MEDSRCorrect As %String [ SqlColumnNumber = 4, SqlFieldName = MEDSR_Correct ];

Property MEDSRError As %String [ SqlColumnNumber = 5, SqlFieldName = MEDSR_Error ];

Property MEDSROtherDesc As %String [ SqlColumnNumber = 6, SqlFieldName = MEDSR_OtherDesc ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexLinkItem">
<Global>^DHCADVMEDRLK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MedReportLink.MEDSR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MEDSR_ItmChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_LinkItem}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_MedReportLink.MEDSR_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEDSR_ItmChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MEDSR_Correct">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEDSR_Error">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDSR_LinkItem">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDSR_OtherDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVMEDRLK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedReportLink.MEDSR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MEDSR_ItmChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MedReportLink.MEDSR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MEDSRI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_ItmChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedReportLinkItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
