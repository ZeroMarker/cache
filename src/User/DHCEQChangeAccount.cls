Class User.DHCEQChangeAccount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CA_RowID, SqlTableName = DHC_EQChangeAccount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CA_EquipDR
Property CAEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CA_EquipDR ];

/// CA_ChangeFee
Property CAChangeFee As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = CA_ChangeFee ];

/// CA_ChangedOriginalFee
Property CAChangedOriginalFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CA_ChangedOriginalFee ];

/// CA_ChangedNetFee
Property CAChangedNetFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CA_ChangedNetFee ];

/// CA_TotalDepreFee
Property CATotalDepreFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = CA_TotalDepreFee ];

/// CA_ChangeItem
Property CAChangeItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CA_ChangeItem ];

/// CA_ChangeReasonDR
Property CAChangeReasonDR As User.DHCEQCValueChangeReason [ SqlColumnNumber = 8, SqlFieldName = CA_ChangeReasonDR ];

/// CA_ChangeReason
Property CAChangeReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CA_ChangeReason ];

/// CA_ChangeDate
Property CAChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CA_ChangeDate ];

/// CA_Remark
Property CARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CA_Remark ];

/// CA_Status
Property CAStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 12, SqlFieldName = CA_Status ];

/// CA_AddUserDR
Property CAAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CA_AddUserDR ];

/// CA_AddDate
Property CAAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = CA_AddDate ];

/// CA_AddTime
Property CAAddTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = CA_AddTime ];

/// CA_UpdateUserDR
Property CAUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CA_UpdateUserDR ];

/// CA_UpdateDate
Property CAUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = CA_UpdateDate ];

/// CA_UpdateTime
Property CAUpdateTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = CA_UpdateTime ];

/// CA_SubmitUserDR
Property CASubmitUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = CA_SubmitUserDR ];

/// CA_SubmitDate
Property CASubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = CA_SubmitDate ];

/// CA_SubmitTime
Property CASubmitTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = CA_SubmitTime ];

/// CA_AuditUserDR
Property CAAuditUserDR As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = CA_AuditUserDR ];

/// CA_AuditDate
Property CAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = CA_AuditDate ];

/// CA_AuditTime
Property CAAuditTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = CA_AuditTime ];

/// CA_OriginalFee
Property CAOriginalFee As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = CA_OriginalFee ];

/// CA_NetFee
Property CANetFee As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = CA_NetFee ];

/// CA_NetRemainFee
Property CANetRemainFee As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = CA_NetRemainFee ];

/// CA_ChangedNetRemainFee
Property CAChangedNetRemainFee As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = CA_ChangedNetRemainFee ];

/// CA_StoreLocDR
Property CAStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = CA_StoreLocDR ];

/// CA_UseLocDR
Property CAUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = CA_UseLocDR ];

/// CA_EquipTypeDR
Property CAEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 31, SqlFieldName = CA_EquipTypeDR ];

/// CA_StatCatDR
Property CAStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 32, SqlFieldName = CA_StatCatDR ];

/// CA_Hold1
Property CAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = CA_Hold1 ];

/// CA_Hold2
Property CAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = CA_Hold2 ];

/// CA_Hold3
Property CAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = CA_Hold3 ];

/// CA_Hold4
Property CAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = CA_Hold4 ];

/// CA_Hold5
Property CAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = CA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQChangeAccount("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CA_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CA_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CA_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CA_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CA_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CA_ChangeFee">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CA_ChangeItem">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CA_ChangeReason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CA_ChangeReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CA_ChangedNetFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CA_ChangedNetRemainFee">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CA_ChangedOriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CA_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CA_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CA_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CA_NetRemainFee">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CA_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CA_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CA_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CA_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CA_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CA_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CA_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CA_TotalDepreFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CA_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CA_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Global>^DHCEQChangeAccount</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQChangeAccount</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQChangeAccount</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CA_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQChangeAccount</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CA_RowID</Field>
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
<Expression>{CA_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CA_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLoc">
<Global>^DHCEQChangeAccount</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UseLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CA_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQChangeAccountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
