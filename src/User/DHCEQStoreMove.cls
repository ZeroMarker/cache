Class User.DHCEQStoreMove Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SM_RowID, SqlTableName = DHC_EQStoreMove, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index SMStoreMoveNoUnqIdx1 On SMStoreMoveNo [ Unique ];

/// SM_AckDate
Property SMAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = SM_AckDate ];

/// SM_AckTime
Property SMAckTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = SM_AckTime ];

/// SM_AckUserDR
Property SMAckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SM_AckUserDR ];

/// SM_BillAckDate
Property SMBillAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = SM_BillAckDate ];

/// SM_BillAckTime
Property SMBillAckTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = SM_BillAckTime ];

/// SM_BillAckUserDR
Property SMBillAckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = SM_BillAckUserDR ];

/// SM_CancelDate
Property SMCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = SM_CancelDate ];

/// SM_CancelTime
Property SMCancelTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = SM_CancelTime ];

/// SM_CancelUser
Property SMCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = SM_CancelUser ];

/// SM_EquipTypeDR
Property SMEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 17, SqlFieldName = SM_EquipTypeDR ];

/// SM_FromLocDR
Property SMFromLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SM_FromLocDR ];

/// SM_Hold1
Property SMHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = SM_Hold1 ];

/// SM_Hold2
Property SMHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = SM_Hold2 ];

/// SM_Hold3
Property SMHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = SM_Hold3 ];

/// SM_InAckDate
Property SMInAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = SM_InAckDate ];

/// SM_InAckTime
Property SMInAckTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = SM_InAckTime ];

/// SM_InAckUserDR
Property SMInAckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SM_InAckUserDR ];

/// SM_InvalidFlag
Property SMInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = SM_InvalidFlag ];

/// SM_MakeDate
Property SMMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = SM_MakeDate ];

/// SM_MakerDR
Property SMMakerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SM_MakerDR ];

/// SM_MoveType
Property SMMoveType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SM_MoveType ];

/// SM_ReciverDR
Property SMReciverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SM_ReciverDR ];

/// SM_Remark
Property SMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SM_Remark ];

/// SM_StatCatDR
Property SMStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 18, SqlFieldName = SM_StatCatDR ];

/// SM_Status
Property SMStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 14, SqlFieldName = SM_Status ];

/// SM_StoreMoveNo
Property SMStoreMoveNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SM_StoreMoveNo ];

/// SM_ToLocDR
Property SMToLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SM_ToLocDR ];

/// SM_MoveOutReason	转出原因
Property SMMoveOutReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = SM_MoveOutReason ];

/// SM_MoveInReason		转入原因
Property SMMoveInReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = SM_MoveInReason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQStoreMove("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SM_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SM_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SM_AckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SM_BillAckDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SM_BillAckTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SM_BillAckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SM_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SM_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SM_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SM_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SM_FromLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SM_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SM_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SM_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SM_InAckDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SM_InAckTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SM_InAckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SM_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SM_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SM_MakerDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SM_MoveInReason">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SM_MoveOutReason">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SM_MoveType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SM_ReciverDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SM_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SM_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SM_StoreMoveNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SM_ToLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQStoreMove</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFromLoc">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SM_FromLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFromLocInDate">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromLocInDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SM_FromLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SM_InAckDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SM_MoveType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SM_Status}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFromLocStatCat">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FromLocStatCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SM_FromLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SM_InAckDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{SM_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInAckDateStat">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InAckDateStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SM_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SM_InAckDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{SM_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SM_MoveType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusFromLoc">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StatusFromLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SM_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SM_FromLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreMoveNo">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreMoveNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SM_StoreMoveNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToLoc">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SM_ToLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToLocInDate">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToLocInDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SM_ToLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SM_InAckDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SM_MoveType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SM_Status}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQStoreMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SM_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SM_InAckDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQStoreMoveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
