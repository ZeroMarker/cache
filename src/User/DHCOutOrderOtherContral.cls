Class User.DHCOutOrderOtherContral Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OOC_RowId, SqlTableName = DHC_OutOrderOtherContral, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OOC_ItemCat_DR
Property OOCItemCatDR As User.ARCItemCat [ SqlColumnNumber = 2, SqlFieldName = OOC_ItemCat_DR ];

/// OOC_AdmReason_DR
Property OOCAdmReasonDR As User.PACAdmReason [ SqlColumnNumber = 3, SqlFieldName = OOC_AdmReason_DR ];

/// OOC_Dur_DR
Property OOCDurDR As User.PHCDuration [ SqlColumnNumber = 4, SqlFieldName = OOC_Dur_DR ];

/// OOC_Drugspecies
Property OOCDrugspecies As %Library.Float(MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = OOC_Drugspecies ];

/// OOC_Hosp_DR
Property OOCHospDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = OOC_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOOOC)</SqlIdExpression>
<SQLMap name="DataMasterIndex">
<Data name="OOC_AdmReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OOC_Drugspecies">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OOC_Dur_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OOC_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OOC_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOOOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OOC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemCat">
<Global>^DHCOOOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ItemCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OOC_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOutOrderOtherContralS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
