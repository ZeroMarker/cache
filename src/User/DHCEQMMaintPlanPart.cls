Class User.DHCEQMMaintPlanPart Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MPP_RowID, SqlTableName = DHC_EQMMaintPlanPart, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MPP_MaintPlanDR
Property MPPMaintPlanDR As User.DHCEQMMaintPlan [ SqlColumnNumber = 2, SqlFieldName = MPP_MaintPlanDR ];

/// MPP_AccessoryDR
Property MPPAccessoryDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = MPP_AccessoryDR ];

/// MPP_QuantityNum
Property MPPQuantityNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = MPP_QuantityNum ];

/// MPP_PriceFee
Property MPPPriceFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MPP_PriceFee ];

/// MPP_TotalFee
Property MPPTotalFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MPP_TotalFee ];

/// MPP_Remark
Property MPPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MPP_Remark ];

/// MPP_FeeFlag
Property MPPFeeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MPP_FeeFlag ];

/// MPP_Hold1
Property MPPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MPP_Hold1 ];

/// MPP_Hold2
Property MPPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MPP_Hold2 ];

/// MPP_Hold3
Property MPPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MPP_Hold3 ];

/// MPP_Hold4
Property MPPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MPP_Hold4 ];

/// MPP_Hold5
Property MPPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MPP_Hold5 ];

/// MPP_Model
Property MPPModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MPP_Model ];

/// MPP_ManufacturerDR
Property MPPManufacturerDR As User.DHCEQCManufacturer [ SqlColumnNumber = 15, SqlFieldName = MPP_ManufacturerDR ];

/// MPP_ProviderDR
Property MPPProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 16, SqlFieldName = MPP_ProviderDR ];

/// MPP_MaintPlanItemDR
Property MPPMaintPlanItemDR As User.DHCEQMMaintPlanItem [ SqlColumnNumber = 17, SqlFieldName = MPP_MaintPlanItemDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMMaintPlanPart("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MPP_AccessoryDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MPP_FeeFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MPP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MPP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MPP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MPP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MPP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MPP_MaintPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MPP_MaintPlanItemDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MPP_ManufacturerDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MPP_Model">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MPP_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MPP_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MPP_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MPP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MPP_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMMaintPlanPart</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MPP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MPP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMaintPlan">
<Global>^DHCEQMMaintPlanPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MPP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MaintPlan"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MPP_MaintPlanDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MPP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMMaintPlanPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
