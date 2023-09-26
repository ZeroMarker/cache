Class User.DHCEQUsedResource Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UR_RowID, SqlTableName = DHC_EQUsedResource, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UR_AddDate
Property URAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = UR_AddDate ];

/// UR_AddTime
Property URAddTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = UR_AddTime ];

/// UR_AddUser
Property URAddUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = UR_AddUser ];

/// UR_Amount
Property URAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = UR_Amount ];

/// UR_AuditDate
Property URAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = UR_AuditDate ];

/// UR_AuditTime
Property URAuditTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = UR_AuditTime ];

/// UR_AuditUser
Property URAuditUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = UR_AuditUser ];

/// UR_CancelDate
Property URCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = UR_CancelDate ];

/// UR_CancelTime
Property URCancelTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = UR_CancelTime ];

/// UR_CancelUser
Property URCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = UR_CancelUser ];

/// UR_EquipConsumableDR
Property UREquipConsumableDR As User.DHCEQEquipConsumable [ SqlColumnNumber = 20, SqlFieldName = UR_EquipConsumableDR ];

/// UR_Hold1
Property URHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = UR_Hold1 ];

/// UR_Hold2
Property URHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = UR_Hold2 ];

/// UR_Hold3
Property URHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = UR_Hold3 ];

/// UR_Hold4
Property URHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = UR_Hold4 ];

/// UR_Hold5
Property URHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = UR_Hold5 ];

/// UR_IsInputFlag
Property URIsInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = UR_IsInputFlag ];

/// UR_LocDR
Property URLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UR_LocDR ];

/// UR_ModelDR
Property URModelDR As User.DHCEQCModel [ SqlColumnNumber = 15, SqlFieldName = UR_ModelDR ];

/// UR_Month
Property URMonth As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = UR_Month ];

/// UR_Price
Property URPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = UR_Price ];

/// UR_Quantity
Property URQuantity As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = UR_Quantity ];

/// UR_Remark
Property URRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = UR_Remark ];

/// UR_ResourceTypeDR
Property URResourceTypeDR As User.DHCEQCResourceType [ SqlColumnNumber = 6, SqlFieldName = UR_ResourceTypeDR ];

/// UR_SourceID
Property URSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UR_SourceID ];

/// UR_SourceType
Property URSourceType As %Library.String(DISPLAYLIST = ",设备,设备项", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 4, SqlFieldName = UR_SourceType ];

/// UR_Status
Property URStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 19, SqlFieldName = UR_Status ];

/// UR_SubmitDate
Property URSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = UR_SubmitDate ];

/// UR_SubmitTime
Property URSubmitTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = UR_SubmitTime ];

/// UR_SubmitUser
Property URSubmitUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = UR_SubmitUser ];

/// UR_UomDR
Property URUomDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = UR_UomDR ];

/// UR_UpdateDate
Property URUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = UR_UpdateDate ];

/// UR_UpdateTime
Property URUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = UR_UpdateTime ];

/// UR_UpdateUser
Property URUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = UR_UpdateUser ];

/// UR_Year
Property URYear As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = UR_Year ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUsedResource("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UR_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UR_Amount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="UR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="UR_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="UR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="UR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="UR_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="UR_EquipConsumableDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="UR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="UR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="UR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="UR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="UR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="UR_IsInputFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="UR_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UR_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UR_Month">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UR_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UR_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="UR_ResourceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UR_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UR_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="UR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="UR_SubmitUser">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="UR_UomDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UR_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UR_Year">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQUsedResource</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCancelDate">
<Global>^DHCEQUsedResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CancelDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_CancelDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQUsedResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^DHCEQUsedResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ResourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_ResourceTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQUsedResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceCancel">
<Global>^DHCEQUsedResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceCancel"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_CancelDate}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceDate">
<Global>^DHCEQUsedResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_Year}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{UR_Month}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexYearMonth">
<Global>^DHCEQUsedResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YearMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_ResourceTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUsedResourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
