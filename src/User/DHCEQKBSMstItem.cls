Class User.DHCEQKBSMstItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMI_RowID, SqlTableName = DHC_EQKBSMstItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SMI_Desc
Property SMIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SMI_Desc ];

/// SMI_Code
Property SMICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SMI_Code ];

/// SMI_FinanceTypeDR
Property SMIFinanceTypeDR As User.DHCEQCFinanceType [ SqlColumnNumber = 4, SqlFieldName = SMI_FinanceTypeDR ];

/// SMI_StatCatDR
Property SMIStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 5, SqlFieldName = SMI_StatCatDR ];

/// SMI_CatDR
Property SMICatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 6, SqlFieldName = SMI_CatDR ];

/// SMI_TreeDR
Property SMITreeDR As User.DHCEQCTree [ SqlColumnNumber = 7, SqlFieldName = SMI_TreeDR ];

/// SMI_UnitDR
Property SMIUnitDR As User.DHCEQCUOM [ SqlColumnNumber = 8, SqlFieldName = SMI_UnitDR ];

/// SMI_InvalidFlag
Property SMIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SMI_InvalidFlag ];

/// SMI_ForceInspectFlag
Property SMIForceInspectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SMI_ForceInspectFlag ];

/// SMI_MedicalFlag
Property SMIMedicalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SMI_MedicalFlag ];

/// SMI_RaditionFlag
Property SMIRaditionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = SMI_RaditionFlag ];

/// SMI_MeasureFlag
Property SMIMeasureFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SMI_MeasureFlag ];

/// SMI_CycleNum
Property SMICycleNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SMI_CycleNum ];

/// SMI_CycleUnitDR
Property SMICycleUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 15, SqlFieldName = SMI_CycleUnitDR ];

/// SMI_Remark
Property SMIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SMI_Remark ];

/// SMI_Frequency
Property SMIFrequency As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = SMI_Frequency ];

/// SMI_EqCatIsEndFlag
Property SMIEqCatIsEndFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = SMI_EqCatIsEndFlag ];

/// SMI_Hold1 国标分类对应财务大类
Property SMIHold1 As User.DHCEQCFinanceType [ SqlColumnNumber = 19, SqlFieldName = SMI_Hold1 ];

/// SMI_Hold2 国标分类对应设备类型
Property SMIHold2 As User.DHCEQCStatCat [ SqlColumnNumber = 20, SqlFieldName = SMI_Hold2 ];

/// SMI_Hold3 该项被匹配次数
Property SMIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = SMI_Hold3 ];

/// SMI_Hold4 项目确认次数
Property SMIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = SMI_Hold4 ];

/// SMI_Hold5 确认标志：1为项目确认，2为最终确认
Property SMIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = SMI_Hold5 ];

/// SMI_Hold6 
Property SMIHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = SMI_Hold6 ];

/// SMI_Hold7
Property SMIHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = SMI_Hold7 ];

/// SMI_Hold8
Property SMIHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = SMI_Hold8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQKB("DHCEQKBSMstItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SMI_CatDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMI_CycleNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMI_CycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMI_EqCatIsEndFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMI_FinanceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMI_ForceInspectFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMI_Frequency">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SMI_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SMI_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SMI_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SMI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMI_MeasureFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMI_MedicalFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMI_RaditionFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMI_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMI_TreeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMI_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQKB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{SMI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCatDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMI_CatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SMI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFinanceTypeDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FinanceTypeDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMI_FinanceTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFrequency">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Frequency"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMI_InvalidFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SMI_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SMI_Frequency}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMultiDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MultiDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SMI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMI_FinanceTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SMI_StatCatDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SMI_CatDR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTreeDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TreeDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMI_TreeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexStatCatDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBSMstItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"StatCatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMI_StatCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCStantardMstItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
