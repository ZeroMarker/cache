Class User.DHCWLPatAntiDrugInfoDep Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// DHCWLPADDEP_PaadmDr
Property DHCWLPADDEPPaadmDr As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCWLPADDEP_PaadmDr ];

/// DHCWLPADDEP_PatType
Property DHCWLPADDEPPatType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCWLPADDEP_PatType ];

/// DHCWLPADDEP_AdmDate
Property DHCWLPADDEPAdmDate As %Date [ SqlColumnNumber = 4, SqlFieldName = DHCWLPADDEP_AdmDate ];

/// DHCWLPADDEP_DisDate
Property DHCWLPADDEPDisDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DHCWLPADDEP_DisDate ];

/// DHCWLPADDEP_DisDep
Property DHCWLPADDEPDisDep As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCWLPADDEP_DisDep ];

/// DHCWLPADDEP_DisWard
Property DHCWLPADDEPDisWard As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCWLPADDEP_DisWard ];

/// DHCWLPADDEP_TotleFee
Property DHCWLPADDEPTotleFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCWLPADDEP_TotleFee ];

/// DHCWLPADDEP_DrugFee
Property DHCWLPADDEPDrugFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCWLPADDEP_DrugFee ];

/// DHCWLPADDEP_AntiFlag
Property DHCWLPADDEPAntiFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCWLPADDEP_AntiFlag ];

/// DHCWLPADDEP_AntiFee
Property DHCWLPADDEPAntiFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCWLPADDEP_AntiFee ];

/// DHCWLPADDEP_AntiNums
Property DHCWLPADDEPAntiNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCWLPADDEP_AntiNums ];

/// DHCWLPADDEP_AntiDDD
Property DHCWLPADDEPAntiDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCWLPADDEP_AntiDDD ];

/// DHCWLPADDEP_BaseFlag
Property DHCWLPADDEPBaseFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DHCWLPADDEP_BaseFlag ];

/// DHCWLPADDEP_BaseFee
Property DHCWLPADDEPBaseFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCWLPADDEP_BaseFee ];

/// DHCWLPADDEP_BaseNums
Property DHCWLPADDEPBaseNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DHCWLPADDEP_BaseNums ];

/// DHCWLPADDEP_BaseDDD
Property DHCWLPADDEPBaseDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCWLPADDEP_BaseDDD ];

/// DHCWLPADDEP_SpAntFlag
Property DHCWLPADDEPSpAntFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHCWLPADDEP_SpAntFlag ];

/// DHCWLPADDEP_SpAntFee
Property DHCWLPADDEPSpAntFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCWLPADDEP_SpAntFee ];

/// DHCWLPADDEP_SpAntNums
Property DHCWLPADDEPSpAntNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DHCWLPADDEP_SpAntNums ];

/// DHCWLPADDEP_SpAntDDD
Property DHCWLPADDEPSpAntDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DHCWLPADDEP_SpAntDDD ];

/// DHCWLPADDEP_InjAntFlag
Property DHCWLPADDEPInjAntFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DHCWLPADDEP_InjAntFlag ];

/// DHCWLPADDEP_InjAntFee
Property DHCWLPADDEPInjAntFee As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DHCWLPADDEP_InjAntFee ];

/// DHCWLPADDEP_InjAntNums
Property DHCWLPADDEPInjAntNums As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DHCWLPADDEP_InjAntNums ];

/// DHCWLPADDEP_InjAntDDD
Property DHCWLPADDEPInjAntDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DHCWLPADDEP_InjAntDDD ];

/// DHCWLPADDEP_OperIcd
Property DHCWLPADDEPOperIcd As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DHCWLPADDEP_OperIcd ];

/// DHCWLPADDEP_OperHealLev
Property DHCWLPADDEPOperHealLev As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DHCWLPADDEP_OperHealLev ];

/// DHCWLPADDEP_OperPreTime
Property DHCWLPADDEPOperPreTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DHCWLPADDEP_OperPreTime ];

/// DHCWLPADDEP_OperConTime
Property DHCWLPADDEPOperConTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DHCWLPADDEP_OperConTime ];

/// DHCWLPADDEP_EtiExaFlag
Property DHCWLPADDEPEtiExaFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DHCWLPADDEP_EtiExaFlag ];

/// DHCWLPADDEP_IsMedAntiPat
Property DHCWLPADDEPIsMedAntiPat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DHCWLPADDEP_IsMedAntiPat ];

/// DHCWLPADDEP_LimMedAntiPat
Property DHCWLPADDEPLimMedAntiPat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DHCWLPADDEP_LimMedAntiPat ];

/// DHCWLPADDEP_SpMedAntiPat
Property DHCWLPADDEPSpMedAntiPat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DHCWLPADDEP_SpMedAntiPat ];

/// DHCWLPADDEP_LimAntFlag
Property DHCWLPADDEPLimAntFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DHCWLPADDEP_LimAntFlag ];

/// DHCWLPADDEP_LimAntDDD
Property DHCWLPADDEPLimAntDDD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DHCWLPADDEP_LimAntDDD ];

/// DHCWLPADDEP_OperPre2h
Property DHCWLPADDEPOperPre2h As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DHCWLPADDEP_OperPre2h ];

/// DHCWLPADDEP_PatDep
Property DHCWLPADDEPPatDep As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = DHCWLPADDEP_PatDep ];

/// DHCWLPADDEP_PatDepDays
Property DHCWLPADDEPPatDepDays As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = DHCWLPADDEP_PatDepDays ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCWLPADDEPI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCWLPADDEP_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCWLPADDEP_AntiDDD">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCWLPADDEP_AntiFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCWLPADDEP_AntiFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCWLPADDEP_AntiNums">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCWLPADDEP_BaseDDD">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCWLPADDEP_BaseFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCWLPADDEP_BaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCWLPADDEP_BaseNums">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCWLPADDEP_DisDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCWLPADDEP_DisDep">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCWLPADDEP_DisWard">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCWLPADDEP_DrugFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCWLPADDEP_EtiExaFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHCWLPADDEP_InjAntDDD">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCWLPADDEP_InjAntFee">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCWLPADDEP_InjAntFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCWLPADDEP_InjAntNums">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCWLPADDEP_IsMedAntiPat">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHCWLPADDEP_LimAntDDD">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHCWLPADDEP_LimAntFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHCWLPADDEP_LimMedAntiPat">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHCWLPADDEP_OperConTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHCWLPADDEP_OperHealLev">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHCWLPADDEP_OperIcd">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHCWLPADDEP_OperPre2h">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DHCWLPADDEP_OperPreTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHCWLPADDEP_PaadmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCWLPADDEP_PatDep">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DHCWLPADDEP_PatDepDays">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DHCWLPADDEP_PatType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCWLPADDEP_SpAntDDD">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCWLPADDEP_SpAntFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCWLPADDEP_SpAntFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCWLPADDEP_SpAntNums">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCWLPADDEP_SpMedAntiPat">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHCWLPADDEP_TotleFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCWLPADDEPI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCWLPADDEP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCWLPADDEP_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDESXDisDep">
<Global>^DHCWLPADDEPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPADDEP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPADDEP_DisDep}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPADDEP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXAdmDr">
<Global>^DHCWLPADDEPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPADDEP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPADDEP_PaadmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPADDEP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXAdmType">
<Global>^DHCWLPADDEPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCWLPADDEP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPADDEP_PatType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPADDEP_PaadmDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCWLPADDEP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXDisDate">
<Global>^DHCWLPADDEPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPADDEP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPADDEP_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPADDEP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXDisWard">
<Global>^DHCWLPADDEPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPADDEP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPADDEP_DisWard}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPADDEP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="iNDEXAdmDate">
<Global>^DHCWLPADDEPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCWLPADDEP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWLPADDEP_AdmDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWLPADDEP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCWLPADDEP_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCWLPatAntiDrugInfoDepS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
