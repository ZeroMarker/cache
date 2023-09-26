Class User.DHCIPMealMenuDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMMD_RowID, SqlTableName = DHC_IPMealMenuDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCMMDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_IPMealMenu Parent Reference
Relationship DHCMMDMMParref As User.DHCIPMealMenu [ Cardinality = parent, Inverse = ChildDHCIPMealMenuDetail, Required, SqlFieldName = DHCMMD_MM_Parref ];

/// DHCMM_ChildSub
Property DHCMMDChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ InitialExpression = {$i(^DHCIPMEALMENU($p(%d(0),$c(1),1),"M",0))}, SqlColumnNumber = 2, SqlFieldName = DHCMMD_ChildSub ];

/// DHCMM_MealItm_Dr
Property DHCMMDMealItmDr As User.DHCIPMealItem [ SqlColumnNumber = 3, SqlFieldName = DHCMMD_MealItm_Dr ];

/// DHCMMD_MealType_Dr
Property DHCMMDMealTypeDr As User.DHCIPMealType [ SqlColumnNumber = 4, SqlFieldName = DHCMMD_MealType_Dr ];

/// DHCMMD_MealModality_Dr
Property DHCMMDMealModalityDr As User.DHCIPMealModality [ SqlColumnNumber = 5, SqlFieldName = DHCMMD_MealModality_Dr ];

/// DHCMMD_UpdateDate
Property DHCMMDUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCMMD_UpdateDate ];

/// DHCMMD_UpdateTime
Property DHCMMDUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DHCMMD_UpdateTime ];

/// DHCMMD_UpdateUser_Dr
Property DHCMMDUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DHCMMD_UpdateUser_Dr ];

/// DHCMMD_Remark
Property DHCMMDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCMMD_Remark ];

/// DHCMMD_StartDate
Property DHCMMDStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DHCMMD_StartDate ];

/// DHCMMD_ItmStatus
Property DHCMMDItmStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DHCMMD_ItmStatus ];

/// DHCMMD_Index
Property DHCMMDIndex As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCMMD_Index ];

/// DHCMMD_UpdateIndexUser_Dr
Property DHCMMDUpdateIndexUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DHCMMD_UpdateIndexUser_Dr ];

/// DHCMMD_UpdateIndexDate
Property DHCMMDUpdateIndexDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCMMD_UpdateIndexDate ];

/// DHCMMD_UpdateIndexTime
Property DHCMMDUpdateIndexTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DHCMMD_UpdateIndexTime ];

/// DHCMMD_Comment1
Property DHCMMDComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DHCMMD_Comment1 ];

/// DHCMMD_Comment2
Property DHCMMDComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCMMD_Comment2 ];

Property DHCMMDComment3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHCMMD_Comment3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCMMD_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCMMD_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCMMD_Comment3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCMMD_Index">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMMD_ItmStatus">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMMD_MealItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMMD_MealModality_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMMD_MealType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMMD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMMD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMMD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMMD_UpdateIndexDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCMMD_UpdateIndexTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCMMD_UpdateIndexUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCMMD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMMD_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCIPMEALMENU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_IPMealMenu.DHCMM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCMMD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_IPMealMenu.DHCMM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"M"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCMMD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCIPMEALMENU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealMenu.DHCMM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMMD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DetailStartDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMMD_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealMenu.DHCMM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMMD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDateMDR">
<Global>^DHCIPMEALMENU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_IPMealMenu.DHCMM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHCMMD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DetailStartDateMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMMD_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMMD_MealModality_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_IPMealMenu.DHCMM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCMMD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDateSort">
<Global>^DHCIPMEALMENU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_IPMealMenu.DHCMM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DHCMMD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartDateSort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMMD_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Index"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMMD_Index}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_IPMealMenu.DHCMM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHCMMD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealMenuDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
