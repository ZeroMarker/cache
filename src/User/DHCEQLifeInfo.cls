Class User.DHCEQLifeInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LI_RowID, SqlTableName = DHC_EQLifeInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LI_AppendType
Property LIAppendType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = LI_AppendType ];

/// LI_ChangeDate
Property LIChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = LI_ChangeDate ];

/// LI_ChangeDesc
Property LIChangeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = LI_ChangeDesc ];

/// LI_ChangeReason
Property LIChangeReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = LI_ChangeReason ];

/// LI_ChangeTime
Property LIChangeTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = LI_ChangeTime ];

/// LI_EquipDR
Property LIEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = LI_EquipDR ];

/// LI_FromManagerLocDR
Property LIFromManagerLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LI_FromManagerLocDR ];

/// LI_FromNetFee
Property LIFromNetFee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = LI_FromNetFee ];

/// LI_FromOriginalFee
Property LIFromOriginalFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = LI_FromOriginalFee ];

/// LI_FromStoreLocDR
Property LIFromStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = LI_FromStoreLocDR ];

/// LI_FromUseLocDR
Property LIFromUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LI_FromUseLocDR ];

/// LI_GroupDR
Property LIGroupDR As User.DHCEQGroup [ SqlColumnNumber = 3, SqlFieldName = LI_GroupDR ];

/// LI_Hold1
Property LIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = LI_Hold1 ];

/// LI_Hold2
Property LIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = LI_Hold2 ];

/// LI_Hold3
Property LIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = LI_Hold3 ];

/// LI_Hold4
Property LIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = LI_Hold4 ];

/// LI_Hold5
Property LIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = LI_Hold5 ];

/// LI_InvoiceDate
Property LIInvoiceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = LI_InvoiceDate ];

/// LI_InvoiceDept
Property LIInvoiceDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = LI_InvoiceDept ];

/// LI_InvoiceNo
Property LIInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = LI_InvoiceNo ];

/// LI_LifeType
Property LILifeType As %Library.String(DISPLAYLIST = ",收入,支出,变动,其他", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",I,P,C,O") [ SqlColumnNumber = 19, SqlFieldName = LI_LifeType ];

/// LI_Remark
Property LIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = LI_Remark ];

/// LI_SourceID
Property LISourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = LI_SourceID ];

/// LI_SourceType
Property LISourceType As %Library.String(DISPLAYLIST = ",开箱验收,安装调试验收,入库,转移,减少,维修,保养,检查,保费,折旧,使用,设备调账,数据调整,报废预警鉴定,设备拆分", MAXLEN = 6, SELECTIVITY = "7.1429%", TRUNCATE = 1, VALUELIST = ",11,12,21,22,23,31,32,33,34,35,41,51,61,82,55") [ SqlColumnNumber = 20, SqlFieldName = LI_SourceType ];

/// LI_ToManagerLocDR
Property LIToManagerLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = LI_ToManagerLocDR ];

/// LI_ToNetFee
Property LIToNetFee As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = LI_ToNetFee ];

/// LI_ToOriginalFee
Property LIToOriginalFee As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = LI_ToOriginalFee ];

/// LI_ToStoreLocDR
Property LIToStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = LI_ToStoreLocDR ];

/// LI_ToUseLocDR
Property LIToUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = LI_ToUseLocDR ];

/// LI_UpdateDate
Property LIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = LI_UpdateDate ];

/// LI_UpdateTime
Property LIUpdateTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = LI_UpdateTime ];

/// LI_UpdateUserDR
Property LIUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = LI_UpdateUserDR ];

/// LI_UsedFee
Property LIUsedFee As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = LI_UsedFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQLifeInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LI_AppendType">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="LI_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="LI_ChangeDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="LI_ChangeReason">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="LI_ChangeTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="LI_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LI_FromManagerLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LI_FromNetFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LI_FromOriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LI_FromStoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LI_FromUseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LI_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="LI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="LI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="LI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="LI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="LI_InvoiceDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="LI_InvoiceDept">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="LI_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="LI_LifeType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="LI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="LI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="LI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="LI_ToManagerLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LI_ToNetFee">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="LI_ToOriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LI_ToStoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LI_ToUseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="LI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="LI_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="LI_UsedFee">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCEQLifeInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppendType">
<Global>^DHCEQLifeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppendType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LI_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LI_AppendType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LI_ChangeDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQLifeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LI_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LI_ChangeDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipSource">
<Global>^DHCEQLifeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EquipSource"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LI_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LI_EquipDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LI_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{LI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipSourceDate">
<Global>^DHCEQLifeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EquipSourceDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LI_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LI_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LI_ChangeDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{LI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLifeType">
<Global>^DHCEQLifeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LifeType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LI_LifeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LI_ChangeDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQLifeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LI_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LI_ChangeDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQLifeInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
