Class User.DHCEQSplitList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SL_RowID, SqlTableName = DHC_EQSplitList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SL_SplitDR
Property SLSplitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SL_SplitDR ];

/// SL_EquipDR
Property SLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = SL_EquipDR ];

/// SL_EquipNo
Property SLEquipNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SL_EquipNo ];

/// SL_EquipName
Property SLEquipName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SL_EquipName ];

/// SL_OriginalFee
Property SLOriginalFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SL_OriginalFee ];

/// SL_DepreTotalFee
Property SLDepreTotalFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SL_DepreTotalFee ];

/// SL_NetFee
Property SLNetFee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SL_NetFee ];

/// SL_LeaveFactoryNo
Property SLLeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SL_LeaveFactoryNo ];

/// SL_FileNo
Property SLFileNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SL_FileNo ];

/// SL_ItemDR
Property SLItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 11, SqlFieldName = SL_ItemDR ];

/// SL_EquipTypeDR
Property SLEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 12, SqlFieldName = SL_EquipTypeDR ];

/// SL_StatCatDR
Property SLStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 13, SqlFieldName = SL_StatCatDR ];

/// SL_EquipCatDR
Property SLEquipCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 14, SqlFieldName = SL_EquipCatDR ];

/// SL_LocDR
Property SLLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 15, SqlFieldName = SL_LocDR ];

/// SL_LimitYearsNum
Property SLLimitYearsNum As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SL_LimitYearsNum ];

/// SL_DepreMethodDR
Property SLDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 17, SqlFieldName = SL_DepreMethodDR ];

/// SL_ManuFactoryDR
Property SLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 18, SqlFieldName = SL_ManuFactoryDR ];

/// SL_ModelDR
Property SLModelDR As User.DHCEQCModel [ SqlColumnNumber = 19, SqlFieldName = SL_ModelDR ];

/// SL_LocationDR
Property SLLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 20, SqlFieldName = SL_LocationDR ];

/// SL_Remark
Property SLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = SL_Remark ];

/// SL_QuantityNum 数量
Property SLQuantityNum As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = SL_QuantityNum ];

/// SL_Hold1
Property SLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = SL_Hold1 ];

/// SL_Hold2
Property SLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = SL_Hold2 ];

/// SL_Hold3
Property SLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = SL_Hold3 ];

/// SL_Hold4
Property SLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = SL_Hold4 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSplitList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SL_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SL_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SL_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SL_EquipName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SL_EquipNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SL_FileNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SL_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SL_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SL_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SL_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SL_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SL_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SL_SplitDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQSplitList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipDR">
<Global>^DHCEQSplitList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSplit">
<Global>^DHCEQSplitList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Split"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SL_SplitDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSplitListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
