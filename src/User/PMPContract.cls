Class User.PMPContract Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCT_Rowid, SqlTableName = PMP_Contract, StorageStrategy = SQLStorage ]
{

Relationship ChildPCTDSub As PMPContractDetails [ Cardinality = children, Inverse = PCTParRef ];

/// PCT_Code
Property PCTCode As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCT_Code ];

/// PCT_Desc
Property PCTDesc As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCT_Desc ];

/// PCT_Group
Property PCTGroup As PMPDictionary3 [ SqlColumnNumber = 4, SqlFieldName = PCT_Group ];

/// PCT_Type
Property PCTType As PMPDictionary3 [ SqlColumnNumber = 5, SqlFieldName = PCT_Type ];

/// PCT_Principal
Property PCTPrincipal As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PCT_Principal ];

/// PCT_Department
Property PCTDepartment As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PCT_Department ];

/// PCT_ContractDate
Property PCTContractDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PCT_ContractDate ];

/// PCT_ContractTime
Property PCTContractTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PCT_ContractTime ];

/// PCT_TotalMoney
Property PCTTotalMoney As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PCT_TotalMoney ];

/// PCT_Currency
Property PCTCurrency As PMPDictionary3 [ SqlColumnNumber = 11, SqlFieldName = PCT_Currency ];

/// PCT_ModeExecution
Property PCTModeExecution As PMPDictionary3 [ SqlColumnNumber = 12, SqlFieldName = PCT_ModeExecution ];

/// PCT_ConcludeMode
Property PCTConcludeMode As PMPDictionary3 [ SqlColumnNumber = 13, SqlFieldName = PCT_ConcludeMode ];

/// PCT_Source
Property PCTSource As PMPDictionary3 [ SqlColumnNumber = 14, SqlFieldName = PCT_Source ];

/// PCT_EffectiveDate
Property PCTEffectiveDate As %Date [ SqlColumnNumber = 15, SqlFieldName = PCT_EffectiveDate ];

/// PCT_EffectiveTime
Property PCTEffectiveTime As %Time [ SqlColumnNumber = 16, SqlFieldName = PCT_EffectiveTime ];

/// PCT_FinishDate
Property PCTFinishDate As %Date [ SqlColumnNumber = 17, SqlFieldName = PCT_FinishDate ];

/// PCT_FinishTime
Property PCTFinishTime As %Time [ SqlColumnNumber = 18, SqlFieldName = PCT_FinishTime ];

/// PCT_Status
Property PCTStatus As PMPDictionary3 [ SqlColumnNumber = 19, SqlFieldName = PCT_Status ];

/// PCT_Menu
Property PCTMenu As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PCT_Menu ];

/// PCT_Remark
Property PCTRemark As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PCT_Remark ];

/// PCT_FirstParty
Property PCTFirstParty As PMPCompany [ SqlColumnNumber = 22, SqlFieldName = PCT_FirstParty ];

/// PCT_SecondParty
Property PCTSecondParty As PMPCompany [ SqlColumnNumber = 23, SqlFieldName = PCT_SecondParty ];

/// PCT_ThirdParty
Property PCTThirdParty As PMPCompany [ SqlColumnNumber = 24, SqlFieldName = PCT_ThirdParty ];

/// PCT_FirstUser
Property PCTFirstUser As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PCT_FirstUser ];

/// PCT_SecondUser
Property PCTSecondUser As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PCT_SecondUser ];

/// PCT_ThirdUser
Property PCTThirdUser As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PCT_ThirdUser ];

/// PCT_Abnormal
Property PCTAbnormal As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PCT_Abnormal ];

/// PCT_Pigeonhole
Property PCTPigeonhole As %String(DISPLAYLIST = ",是,否,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 29, SqlFieldName = PCT_Pigeonhole ];

/// PCT_ElectronicContract
Property PCTElectronicContract As %String(DISPLAYLIST = ",是,否,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 30, SqlFieldName = PCT_ElectronicContract ];

/// PCT_Date
Property PCTDate As %Date [ SqlColumnNumber = 31, SqlFieldName = PCT_Date ];

/// PCT_Time
Property PCTTime As %Time [ SqlColumnNumber = 32, SqlFieldName = PCT_Time ];

/// PCT_User
Property PCTUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = PCT_User ];

/// PCT_UpdateDate
Property PCTUpdateDate As %Date [ SqlColumnNumber = 34, SqlFieldName = PCT_UpdateDate ];

/// PCT_UpdateTime
Property PCTUpdateTime As %Time [ SqlColumnNumber = 35, SqlFieldName = PCT_UpdateTime ];

/// PCT_UpdateUser
Property PCTUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PCT_UpdateUser ];

/// PCT_Standby1
Property PCTStandby1 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = PCT_Standby1 ];

/// PCT_Standby2
Property PCTStandby2 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = PCT_Standby2 ];

/// PCT_Standby3
Property PCTStandby3 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = PCT_Standby3 ];

/// PCT_Standby4
Property PCTStandby4 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = PCT_Standby4 ];

/// PCT_Standby5
Property PCTStandby5 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = PCT_Standby5 ];

/// PCT_Standby6
Property PCTStandby6 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = PCT_Standby6 ];

/// PCT_Standby7
Property PCTStandby7 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = PCT_Standby7 ];

/// PCT_Standby8
Property PCTStandby8 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = PCT_Standby8 ];

/// PCT_Standby9
Property PCTStandby9 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = PCT_Standby9 ];

/// PCT_Standby10
Property PCTStandby10 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = PCT_Standby10 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPContract("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PCT_Abnormal">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PCT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCT_ConcludeMode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCT_ContractDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCT_ContractTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCT_Currency">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCT_Date">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PCT_Department">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCT_EffectiveDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCT_EffectiveTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PCT_ElectronicContract">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PCT_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PCT_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PCT_FirstParty">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PCT_FirstUser">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PCT_Group">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCT_Menu">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PCT_ModeExecution">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCT_Pigeonhole">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PCT_Principal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PCT_SecondParty">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PCT_SecondUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PCT_Source">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCT_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PCT_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="PCT_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PCT_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PCT_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PCT_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="PCT_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="PCT_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="PCT_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="PCT_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="PCT_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PCT_ThirdParty">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PCT_ThirdUser">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PCT_Time">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PCT_TotalMoney">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PCT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PCT_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PCT_User">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Global>^PMPContract</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPContracti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PCT_Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PCT_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPContractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
