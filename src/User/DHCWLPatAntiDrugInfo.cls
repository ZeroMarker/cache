Class User.DHCWLPatAntiDrugInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// DHCWLPAD_PaadmDr
Property DHCWLPADPaadmDr As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCWLPAD_PaadmDr ];

/// DHCWLPAD_PatType
Property DHCWLPADPatType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCWLPAD_PatType ];

/// DHCWLPAD_AdmDate
Property DHCWLPADAdmDate As %Date [ SqlColumnNumber = 4, SqlFieldName = DHCWLPAD_AdmDate ];

/// DHCWLPAD_DisDate
Property DHCWLPADDisDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DHCWLPAD_DisDate ];

/// DHCWLPAD_DisDep
Property DHCWLPADDisDep As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCWLPAD_DisDep ];

/// DHCWLPAD_DisWard
Property DHCWLPADDisWard As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCWLPAD_DisWard ];

/// DHCWLPAD_TotleFee
Property DHCWLPADTotleFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCWLPAD_TotleFee ];

/// DHCWLPAD_DrugFee
Property DHCWLPADDrugFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCWLPAD_DrugFee ];

/// DHCWLPAD_AntiFlag
Property DHCWLPADAntiFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCWLPAD_AntiFlag ];

/// DHCWLPAD_AntiFee
Property DHCWLPADAntiFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCWLPAD_AntiFee ];

/// DHCWLPAD_AntiNums
Property DHCWLPADAntiNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCWLPAD_AntiNums ];

/// DHCWLPAD_AntiDDD
Property DHCWLPADAntiDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCWLPAD_AntiDDD ];

/// DHCWLPAD_BaseFlag
Property DHCWLPADBaseFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DHCWLPAD_BaseFlag ];

/// DHCWLPAD_BaseFee
Property DHCWLPADBaseFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCWLPAD_BaseFee ];

/// DHCWLPAD_BaseNums
Property DHCWLPADBaseNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DHCWLPAD_BaseNums ];

/// DHCWLPAD_BaseDDD
Property DHCWLPADBaseDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCWLPAD_BaseDDD ];

/// DHCWLPAD_SpAntFlag
Property DHCWLPADSpAntFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHCWLPAD_SpAntFlag ];

/// DHCWLPAD_SpAntFee
Property DHCWLPADSpAntFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCWLPAD_SpAntFee ];

/// DHCWLPAD_SpAntNums
Property DHCWLPADSpAntNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DHCWLPAD_SpAntNums ];

/// DHCWLPAD_SpAntDDD
Property DHCWLPADSpAntDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DHCWLPAD_SpAntDDD ];

/// DHCWLPAD_InjAntFlag
Property DHCWLPADInjAntFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DHCWLPAD_InjAntFlag ];

/// DHCWLPAD_InjAntFee
Property DHCWLPADInjAntFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DHCWLPAD_InjAntFee ];

/// DHCWLPAD_InjAntNums
Property DHCWLPADInjAntNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DHCWLPAD_InjAntNums ];

/// DHCWLPAD_InjAntDDD
Property DHCWLPADInjAntDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DHCWLPAD_InjAntDDD ];

/// DHCWLPAD_OperIcd
Property DHCWLPADOperIcd As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DHCWLPAD_OperIcd ];

/// DHCWLPAD_OperHealLev
Property DHCWLPADOperHealLev As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DHCWLPAD_OperHealLev ];

/// DHCWLPAD_OperPreTime
Property DHCWLPADOperPreTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DHCWLPAD_OperPreTime ];

/// DHCWLPAD_OperConTime
Property DHCWLPADOperConTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DHCWLPAD_OperConTime ];

/// DHCWLPAD_EtiExaFlag
Property DHCWLPADEtiExaFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DHCWLPAD_EtiExaFlag ];

/// DHCWLPAD_IsMedAntiPat
Property DHCWLPADIsMedAntiPat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DHCWLPAD_IsMedAntiPat ];

/// DHCWLPAD_LimMedAntiPat
Property DHCWLPADLimMedAntiPat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DHCWLPAD_LimMedAntiPat ];

/// DHCWLPAD_SpMedAntiPat
Property DHCWLPADSpMedAntiPat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DHCWLPAD_SpMedAntiPat ];

/// DHCWLPAD_LimAntFlag
Property DHCWLPADLimAntFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DHCWLPAD_LimAntFlag ];

/// DHCWLPAD_LimAntDDD
Property DHCWLPADLimAntDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DHCWLPAD_LimAntDDD ];

/// DHCWLPAD_OperPre2h
Property DHCWLPADOperPre2h As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DHCWLPAD_OperPre2h ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCWLPADI(0))</SqlIdExpression>
<SQLMap name="DataMasterDHCWLPADI">
<Data name="DHCWLPAD_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCWLPAD_AntiDDD">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCWLPAD_AntiFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCWLPAD_AntiFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCWLPAD_AntiNums">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCWLPAD_BaseDDD">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCWLPAD_BaseFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCWLPAD_BaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCWLPAD_BaseNums">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCWLPAD_DisDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCWLPAD_DisDep">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCWLPAD_DisWard">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCWLPAD_DrugFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCWLPAD_EtiExaFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHCWLPAD_InjAntDDD">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCWLPAD_InjAntFee">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCWLPAD_InjAntFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCWLPAD_InjAntNums">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCWLPAD_IsMedAntiPat">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHCWLPAD_LimAntDDD">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHCWLPAD_LimAntFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHCWLPAD_LimMedAntiPat">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHCWLPAD_OperConTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHCWLPAD_OperHealLev">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHCWLPAD_OperIcd">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHCWLPAD_OperPre2h">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DHCWLPAD_OperPreTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHCWLPAD_PaadmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCWLPAD_PatType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCWLPAD_SpAntDDD">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCWLPAD_SpAntFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCWLPAD_SpAntFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCWLPAD_SpAntNums">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCWLPAD_SpMedAntiPat">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHCWLPAD_TotleFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCWLPADI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCWLPAD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCWLPAD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="InDexAdmDate">
<Global>^DHCWLPADI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPAD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPAD_AdmDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPAD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="InDexAdmDr">
<Global>^DHCWLPADI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPAD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPAD_PaadmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPAD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="InDexAdmType">
<Global>^DHCWLPADI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCWLPAD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPAD_PatType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPAD_PaadmDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCWLPAD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="InDexDisDate">
<Global>^DHCWLPADI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPAD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPAD_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPAD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="InDexDisDep">
<Global>^DHCWLPADI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPAD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPAD_DisDep}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPAD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisWard">
<Global>^DHCWLPADI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPAD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPAD_DisWard}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPAD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCWLPAD_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCWLPatAntiDrugInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
