/// DHC_TarFactor
Class User.DHCTarFactor Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TF_RowId, SqlTableName = DHC_TarFactor, StorageStrategy = SQLStorage ]
{

/// Patient Insurance Type
Property TFPITDR As User.PACAdmReason [ SqlColumnNumber = 2, SqlFieldName = TF_PIT_DR ];

/// Tariff Item SubCategory
Property TFTARSCDR As User.DHCTarSubCate [ SqlColumnNumber = 3, SqlFieldName = TF_TARSC_DR ];

/// Tariff Item
Property TFTARIDR As User.DHCTarItem [ SqlColumnNumber = 4, SqlFieldName = TF_TARI_DR ];

/// Factor Start Date
Property TFStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = TF_StartDate ];

/// Factor End Date
Property TFEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = TF_EndDate ];

/// Discount Rate for Patient Insurance Type
Property TFDiscRate As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = TF_DiscRate ];

/// Payor's Rate for Patient Insurance Type
Property TFPayorRate As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = TF_PayorRate ];

/// TF_AlterLevel
Property TFAlterLevel As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = TF_AlterLevel ];

/// TF_AlterPayorRate
Property TFAlterPayorRate As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = TF_AlterPayorRate ];

/// TF_RecCon_Dr
Property TFRecConDr As %Library.String [ SqlColumnNumber = 11, SqlFieldName = TF_RecCon_Dr ];

/// TF_UpdateDate
Property TFUpdateDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = TF_UpdateDate ];

/// TF_UpdateTime
Property TFUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = TF_UpdateTime ];

/// TF_UpdateUser
Property TFUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = TF_UpdateUser ];

/// TF_TARC_Dr 收费项项目大类
Property TFTARCDr As User.DHCTarCate [ SqlColumnNumber = 15, SqlFieldName = TF_TARC_Dr ];

/// TF_AdmType 就诊类型：急诊，门诊，住院，体检，全部
Property TFAdmType As %String(TRUNCATE = 1, VALUELIST = ",E,O,I,H,A") [ Required, SqlColumnNumber = 16, SqlFieldName = TF_AdmType ];

/// TF_Hosp_Dr
Property TFHospDr As User.CTHospital [ SqlColumnNumber = 17, SqlFieldName = TF_Hosp_Dr ];

/// TF_Arcim_Dr
Property TFArcimDr As User.ARCItmMast [ SqlColumnNumber = 18, SqlFieldName = TF_Arcim_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTARF)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="TF_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TF_AlterLevel">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TF_AlterPayorRate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TF_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TF_DiscRate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TF_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TF_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TF_PIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TF_PayorRate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TF_RecCon_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TF_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TF_TARC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TF_TARI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TF_TARSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TF_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCTARF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXHospDr">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TF_PIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TF_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TF_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRECDICATE">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECDICATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TF_RecCon_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TF_TARC_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TF_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRECDISCATE">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECDISCATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TF_RecCon_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TF_TARSC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TF_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRECDISTARI">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECDISTARI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TF_RecCon_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TF_TARI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TF_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXTarCate">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TARC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{TF_PIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{TF_TARC_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{TF_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXTarSubCategory">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TARSC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{TF_PIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{TF_TARSC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{TF_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXTariffItem">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TARI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TF_PIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{TF_TARI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TF_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmType">
<Global>^DHCTARF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TF_PIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TF_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTarFactorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
