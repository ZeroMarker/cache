Class User.DHCEQReturn Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = R_RowID, SqlTableName = DHC_EQReturn, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RReturnNoUnqIdx1 On RReturnNo [ Unique ];

/// R_AckDate
Property RAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = R_AckDate ];

/// R_AckTime
Property RAckTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = R_AckTime ];

/// R_AckUserDR
Property RAckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = R_AckUserDR ];

/// R_BillAckDate
Property RBillAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = R_BillAckDate ];

/// R_BillAckTime
Property RBillAckTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = R_BillAckTime ];

/// R_BillAckUserDR
Property RBillAckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = R_BillAckUserDR ];

/// R_CancelDate
Property RCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = R_CancelDate ];

/// R_CancelTime
Property RCancelTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = R_CancelTime ];

/// R_CancelUser
Property RCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = R_CancelUser ];

/// R_EquipTypeDR
Property REquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 16, SqlFieldName = R_EquipTypeDR ];

/// R_Hold1
Property RHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = R_Hold1 ];

/// R_Hold2
Property RHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = R_Hold2 ];

/// R_Hold3
Property RHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = R_Hold3 ];

/// R_Hold4
Property RHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = R_Hold4 ];

/// R_Hold5
Property RHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = R_Hold5 ];

/// R_InvalidFlag
Property RInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = R_InvalidFlag ];

/// R_MakeDate
Property RMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = R_MakeDate ];

/// R_MakerDR
Property RMakerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = R_MakerDR ];

/// R_OutTypeDR
Property ROutTypeDR As User.DHCEQCOutType [ SqlColumnNumber = 18, SqlFieldName = R_OutTypeDR ];

/// R_ProviderDR
Property RProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 4, SqlFieldName = R_ProviderDR ];

/// R_Remark
Property RRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = R_Remark ];

/// R_ReturnDate
Property RReturnDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = R_ReturnDate ];

/// R_ReturnLocDR
Property RReturnLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = R_ReturnLocDR ];

/// R_ReturnNo
Property RReturnNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = R_ReturnNo ];

/// R_StatCatDR
Property RStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 17, SqlFieldName = R_StatCatDR ];

/// R_Status
Property RStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 14, SqlFieldName = R_Status ];

/// R_ToDeptDR
Property RToDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 19, SqlFieldName = R_ToDeptDR ];

/// R_UseLocDR
Property RUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = R_UseLocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQReturn("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="R_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="R_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="R_AckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="R_BillAckDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="R_BillAckTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="R_BillAckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="R_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="R_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="R_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="R_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="R_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="R_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="R_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="R_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="R_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="R_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="R_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="R_MakerDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="R_OutTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="R_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="R_Remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="R_ReturnDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="R_ReturnLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="R_ReturnNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="R_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="R_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="R_ToDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="R_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^DHCEQReturn</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{R_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAckDateStat">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AckDateStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_AckDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{R_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutType">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OutType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{R_OutTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReturnLoc">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ReturnLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{R_ReturnLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{R_BillAckDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{R_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReturnNo">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReturnNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_ReturnNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusReturnLoc">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StatusReturnLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{R_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{R_ReturnLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusUseLoc">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatueUseLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_UseLocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>R_RowID</Field>
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
<Expression>{R_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{R_OutTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{R_AckDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLoc">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UseLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLocBillAck">
<Global>^DHCEQReturn</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UseLocBillAck"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_BillAckDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQReturnS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
