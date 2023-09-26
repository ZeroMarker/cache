Class User.DHCEQPLATCAssetItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPLATCAssetItem, StorageStrategy = SQLStorage ]
{

/// AI_Code
Property AICode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AI_Code ];

/// AI_Desc
Property AIDesc As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AI_Desc ];

/// AI_DrugFlag
Property AIDrugFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AI_DrugFlag ];

/// AI_MedicalDeviceFlag
Property AIMedicalDeviceFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AI_MedicalDeviceFlag ];

/// AI_MeteregeFlag
Property AIMeteregeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = AI_MeteregeFlag ];

/// AI_MeterageCycleNum
Property AIMeterageCycleNum As %Float [ SqlColumnNumber = 7, SqlFieldName = AI_MeterageCycleNum ];

/// AI_MeterageCycleUnitDR
Property AIMeterageCycleUnitDR As DHCEQCCycleUnit [ SqlColumnNumber = 8, SqlFieldName = AI_MeterageCycleUnitDR ];

/// AI_UnitDR
Property AIUnitDR As DHCEQCUOM [ SqlColumnNumber = 9, SqlFieldName = AI_UnitDR ];

/// AI_RadiationFlag
Property AIRadiationFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = AI_RadiationFlag ];

/// AI_Remark
Property AIRemark As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AI_Remark ];

/// AI_DateFrom
Property AIDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = AI_DateFrom ];

/// AI_DateTo
Property AIDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = AI_DateTo ];

/// AI_InvalidFlag
Property AIInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = AI_InvalidFlag ];

/// AI_InfectionFlag
Property AIInfectionFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = AI_InfectionFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCTPLAT("AssetItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AI_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AI_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AI_DrugFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AI_InfectionFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AI_MedicalDeviceFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AI_MeterageCycleNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AI_MeterageCycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AI_MeteregeFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AI_RadiationFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AI_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQCTPLAT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AssetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCTPLAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AssetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AI_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPLATCAssetItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
