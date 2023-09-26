Class User.DHCEQKBMstItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MI_RowID, SqlTableName = DHC_EQKBMstItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MI_Desc
Property MIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MI_Desc ];

/// MI_Code
Property MICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MI_Code ];

/// MI_FinanceTypeDR
Property MIFinanceTypeDR As User.DHCEQCFinanceType [ SqlColumnNumber = 4, SqlFieldName = MI_FinanceTypeDR ];

/// MI_StatCatDR
Property MIStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 5, SqlFieldName = MI_StatCatDR ];

/// MI_CatDR
Property MICatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 6, SqlFieldName = MI_CatDR ];

/// MI_TreeDR
Property MITreeDR As User.DHCEQCTree [ SqlColumnNumber = 7, SqlFieldName = MI_TreeDR ];

/// MI_UnitDR
Property MIUnitDR As User.DHCEQCUOM [ SqlColumnNumber = 8, SqlFieldName = MI_UnitDR ];

/// MI_InvalidFlag
Property MIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MI_InvalidFlag ];

/// MI_ForceInspectFlag
Property MIForceInspectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = MI_ForceInspectFlag ];

/// MI_MedicalFlag
Property MIMedicalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MI_MedicalFlag ];

/// MI_RaditionFlag
Property MIRaditionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MI_RaditionFlag ];

/// MI_MeasureFlag
Property MIMeasureFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = MI_MeasureFlag ];

/// MI_CycleNum
Property MICycleNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MI_CycleNum ];

/// MI_CycleUnitDR
Property MICycleUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 15, SqlFieldName = MI_CycleUnitDR ];

/// MI_Remark
Property MIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MI_Remark ];

/// MI_HospDR
Property MIHospDR As User.DHCEQKBHospital [ SqlColumnNumber = 17, SqlFieldName = MI_HospDR ];

/// MI_EqCatIsEndFlag
Property MIEqCatIsEndFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = MI_EqCatIsEndFlag ];

/// MI_Hold1
Property MIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MI_Hold1 ];

/// MI_Hold2
Property MIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MI_Hold2 ];

/// MI_Hold3
Property MIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MI_Hold3 ];

/// MI_Hold4
Property MIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MI_Hold4 ];

/// MI_Hold5
Property MIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MI_Hold5 ];

/// MI_Hold6
Property MIHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MI_Hold6 ];

/// MI_Hold7
Property MIHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MI_Hold7 ];

/// MI_Hold8
Property MIHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MI_Hold8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQKB("DHCEQKBMstItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MI_CatDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MI_CycleNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MI_CycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MI_EqCatIsEndFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MI_FinanceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MI_ForceInspectFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MI_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MI_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MI_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MI_HospDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MI_MeasureFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MI_MedicalFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MI_RaditionFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MI_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MI_TreeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MI_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQKB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCatDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_CatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFinanceTypeDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FinanceTypeDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_FinanceTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HospDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_HospDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatCatDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MIStatCatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_StatCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTreeDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MITreeDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_TreeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQKBMstItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
