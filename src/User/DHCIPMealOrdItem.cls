Class User.DHCIPMealOrdItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMOI_RowID, SqlTableName = DHC_IPMealOrdItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCMOIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_IPMealOrder Parent Reference
Relationship DHCMOIMORDPARREF As User.DHCIPMealOrder [ Cardinality = parent, Inverse = ChildDHCIPMealOrdItem, Required, SqlFieldName = DHCMOI_MORD_PARREF ];

/// DHCMOI_ChildSub
Property DHCMOIChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ InitialExpression = {$i(^DHCIPMEALORDER($p(%d(0),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = DHCMOI_ChildSub ];

/// DHCMOI_MItm_Dr
Property DHCMOIMItmDr As User.DHCIPMealItem [ SqlColumnNumber = 3, SqlFieldName = DHCMOI_MItm_Dr ];

/// DHCMOI_StartDate
Property DHCMOIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCMOI_StartDate ];

/// DHCMOI_StartTime
Property DHCMOIStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DHCMOI_StartTime ];

/// DHCMOI_LocAdd_Dr
Property DHCMOIUserLocAddDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCMOI_UserLocAdd_Dr ];

/// DHCMOI_Qty
Property DHCMOIQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCMOI_Qty ];

/// DHCMOI_OrdBill_Dr
Property DHCMOIOrdBillDr As User.DHCIPMealBillDetail [ SqlColumnNumber = 8, SqlFieldName = DHCMOI_OrdBill_Dr ];

/// DHCMOI_CurLoc_Dr
Property DHCMOICurLocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCMOI_CurLoc_Dr ];

/// DHCMOI_CurWard_Dr
Property DHCMOICurWardDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DHCMOI_CurWard_Dr ];

/// dDHCMOI_AddDate
Property DHCMOIAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DHCMOI_AddDate ];

/// DHCMOI_AddTime
Property DHCMOIAddTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DHCMOI_AddTime ];

/// DHCMOI_UpdateUser_Dr
Property DHCMOIUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DHCMOI_UpdateUser_Dr ];

/// DHCMOI_UpdateDate
Property DHCMOIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCMOI_UpdateDate ];

/// DHCMOI_UpdateTime
Property DHCMOIUpdateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DHCMOI_UpdateTime ];

/// DHCMOI_Billed
Property DHCMOIBilled As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DHCMOI_Billed ];

/// DHCMOI_Remark
Property DHCMOIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCMOI_Remark ];

/// DHCMOI_Comment1
Property DHCMOIComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHCMOI_Comment1 ];

/// DHCMOI_Comment2
Property DHCMOIComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCMOI_Comment2 ];

/// DHCMOI_AddUser_Dr
Property DHCMOIAddUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = DHCMOI_AddUser_Dr ];

/// DHCMOI_MealType_Dr
Property DHCMOIMealTypeDr As User.DHCIPMealType [ SqlColumnNumber = 21, SqlFieldName = DHCMOI_MealType_Dr ];

/// DHCMOI_MealModality_Dr
Property DHCMOIMealModalityDr As User.DHCIPMealModality [ SqlColumnNumber = 22, SqlFieldName = DHCMOI_MealModality_Dr ];

Property DHCMOIInitDr As User.DHCIPMealOrdItem [ SqlColumnNumber = 23, SqlFieldName = DHCMOI_Init_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCMOI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMOI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMOI_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCMOI_Billed">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCMOI_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCMOI_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCMOI_CurLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMOI_CurWard_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMOI_Init_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCMOI_MItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMOI_MealModality_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCMOI_MealType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCMOI_OrdBill_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMOI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMOI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCMOI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMOI_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMOI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCMOI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCMOI_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCMOI_UserLocAdd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPMEALORDER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_IPMealOrder.DHCMO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCMOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_IPMealOrder.DHCMO_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCMOI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInitDr">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealOrder.DHCMO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InitDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMOI_Init_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealOrder.DHCMO_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItm">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealOrder.DHCMO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCMOI_StartDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMOI_MItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealOrder.DHCMO_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealOrder.DHCMO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMOI_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealOrder.DHCMO_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDateMM">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartDateMM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMOI_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMOI_MealModality_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_IPMealOrder.DHCMO_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCMOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDateMT">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartDateMT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMOI_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMOI_MealType_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_IPMealOrder.DHCMO_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCMOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCIPMEALORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealOrder.DHCMO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMOI_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealOrder.DHCMO_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
