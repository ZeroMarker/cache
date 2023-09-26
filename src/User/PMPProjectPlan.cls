Class User.PMPProjectPlan Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPP_Rowid, SqlTableName = PMP_ProjectPlan, StorageStrategy = SQLStorage ]
{

Relationship ChildPPPSub As PMPProjectPlanUser [ Cardinality = children, Inverse = PPPParRef ];

/// PPP_Code
Property PPPCode As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPP_Code ];

/// PPP_Desc
Property PPPDesc As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPP_Desc ];

/// PPP_Type
Property PPPType As PMPDirectoryTree [ SqlColumnNumber = 4, SqlFieldName = PPP_Type ];

/// PPP_Menu
Property PPPMenu As %String(COLLATION = "Exact", MAXLEN = 2048, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPP_Menu ];

/// PPP_PlanStartDate
Property PPPPlanStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PPP_PlanStartDate ];

/// PPP_PlanStartTime
Property PPPPlanStartTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PPP_PlanStartTime ];

/// PPP_PlanEndDate
Property PPPPlanEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PPP_PlanEndDate ];

/// PPP_PlanEndTime
Property PPPPlanEndTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PPP_PlanEndTime ];

/// PPP_RealityStartDate
Property PPPRealityStartDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PPP_RealityStartDate ];

/// PPP_RealityStartTime
Property PPPRealityStartTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PPP_RealityStartTime ];

/// PPP_RealityEndDate
Property PPPRealityEndDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PPP_RealityEndDate ];

/// PPP_RealityEndTime
Property PPPRealityEndTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PPP_RealityEndTime ];

/// PPP_Status
Property PPPStatus As PMPDictionary3 [ SqlColumnNumber = 14, SqlFieldName = PPP_Status ];

/// PPP_Responsibility
Property PPPResponsibility As %String(DISPLAYLIST = ",是,否,其他", MAXLEN = 30, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 15, SqlFieldName = PPP_Responsibility ];

/// PPP_Remark
Property PPPRemark As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PPP_Remark ];

/// PPP_CreatDate
Property PPPCreatDate As %Date [ SqlColumnNumber = 17, SqlFieldName = PPP_CreatDate ];

/// PPP_CreatTime
Property PPPCreatTime As %Time [ SqlColumnNumber = 18, SqlFieldName = PPP_CreatTime ];

/// PPP_CreatUser
Property PPPCreatUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PPP_CreatUser ];

/// PPP_UpdateDate
Property PPPUpdateDate As %Date [ SqlColumnNumber = 20, SqlFieldName = PPP_UpdateDate ];

/// PPP_UpdateTime
Property PPPUpdateTime As %Time [ SqlColumnNumber = 21, SqlFieldName = PPP_UpdateTime ];

/// PPP_UpdateUser
Property PPPUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PPP_UpdateUser ];

/// PPP_Standby1
Property PPPStandby1 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PPP_Standby1 ];

/// PPP_Standby2
Property PPPStandby2 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PPP_Standby2 ];

/// PPP_Standby3
Property PPPStandby3 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PPP_Standby3 ];

/// PPP_Standby4
Property PPPStandby4 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PPP_Standby4 ];

/// PPP_Standby5
Property PPPStandby5 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PPP_Standby5 ];

/// PPP_Standby6
Property PPPStandby6 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PPP_Standby6 ];

/// PPP_Standby7
Property PPPStandby7 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PPP_Standby7 ];

/// PPP_Standby8
Property PPPStandby8 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PPP_Standby8 ];

/// PPP_Standby9
Property PPPStandby9 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PPP_Standby9 ];

/// PPP_Standby10
Property PPPStandby10 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PPP_Standby10 ];

/// PPP_Improvment_DR
Property PPPImprovmentDR As PMPImprovementList [ SqlColumnNumber = 33, SqlFieldName = PPP_Improvment_DR ];

/// PPP_JobLogg_DR
Property PPPJobLoggDR As PMPJobLogging [ SqlColumnNumber = 34, SqlFieldName = PPP_JobLogg_DR ];

/// PPP_Module_DR
Property PPPModuleDR As PMPModule [ SqlColumnNumber = 35, SqlFieldName = PPP_Module_DR ];

/// PPP_ContractAging_DR
Property PPPContractAgingDR As PMPContractAging [ SqlColumnNumber = 36, SqlFieldName = PPP_ContractAging_DR ];

/// PPP_Contract_DR
Property PPPContractDR As PMPContract [ SqlColumnNumber = 37, SqlFieldName = PPP_Contract_DR ];

/// PPP_Adjuc
Property PPPAdjuc As %String(DISPLAYLIST = ",Yes,No,Other", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N,Other") [ SqlColumnNumber = 38, SqlFieldName = PPP_Adjuc ];

/// PPP_Leve
Property PPPLeve As PMPDictionary3 [ SqlColumnNumber = 39, SqlFieldName = PPP_Leve ];

/// PPP_FatherLevel
Property PPPFatherLevel As PMPProjectPlan [ SqlColumnNumber = 40, SqlFieldName = PPP_FatherLevel ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPProjectPlan("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPP_Adjuc">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PPP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPP_ContractAging_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PPP_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PPP_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PPP_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PPP_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PPP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPP_FatherLevel">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PPP_Improvment_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PPP_JobLogg_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PPP_Leve">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PPP_Menu">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPP_Module_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PPP_PlanEndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPP_PlanEndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPP_PlanStartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPP_PlanStartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPP_RealityEndDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPP_RealityEndTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPP_RealityStartDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPP_RealityStartTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PPP_Responsibility">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PPP_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PPP_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PPP_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PPP_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PPP_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PPP_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PPP_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PPP_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PPP_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PPP_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PPP_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPP_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PPP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PPP_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^PMPProjectPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAdjuc">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Adjuc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_Adjuc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofContract">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_Contract_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofContractAging">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ContractAging"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_ContractAging_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFatherLeve">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"FatherLeve"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_FatherLevel}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofImprovement">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Improvment"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_Improvment_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofJobLogg">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"LobJogg"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_JobLogg_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofLeve">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"LEVE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_FatherLevel}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofModule">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Module"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_Module_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPProjectPlani</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPP_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPProjectPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
