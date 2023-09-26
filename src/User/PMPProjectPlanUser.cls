Class User.PMPProjectPlanUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPPU_Rowid, SqlTableName = PMP_ProjectPlanUser, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PPPUChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PPPParRef As PMPProjectPlan [ Cardinality = parent, Inverse = ChildPPPSub, Required, SqlFieldName = PPP_ParRef ];

/// PCAMChildsub
Property PPPUChildsub As %Library.Float [ InitialExpression = {$i(^PMPProjectPlanUser($p(%d(0),$c(1),1),"Details",0))}, SqlColumnNumber = 2, SqlFieldName = PPPU_Childsub ];

/// PPPU_User
Property PPPUUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPPU_User ];

/// PPPU_Status
Property PPPUStatus As PMPDictionary3 [ SqlColumnNumber = 4, SqlFieldName = PPPU_Status ];

/// PPPU_PlanStartDate
Property PPPUPlanStartDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PPPU_PlanStartDate ];

/// PPPU_PlanStartTime
Property PPPUPlanStartTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PPPU_PlanStartTime ];

/// PPPU_PlanEndDate
Property PPPUPlanEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PPPU_PlanEndDate ];

/// PPPU_PlanEndTime
Property PPPUPlanEndTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PPPU_PlanEndTime ];

/// PPPU_RealityStartDate
Property PPPURealityStartDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PPPU_RealityStartDate ];

/// PPPU_RealityStartTime
Property PPPURealityStartTime As %Time [ SqlColumnNumber = 10, SqlFieldName = PPPU_RealityStartTime ];

/// PPPU_RealityEndDate
Property PPPURealityEndDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PPPU_RealityEndDate ];

/// PPPU_RealityEndTime
Property PPPURealityEndTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PPPU_RealityEndTime ];

/// PPPU_Remark
Property PPPURemark As %String(COLLATION = "AlphaUp", MAXLEN = 2048, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PPPU_Remark ];

/// PPPU_CreatDate
Property PPPUCreatDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PPPU_CreatDate ];

/// PPPU_CreatTime
Property PPPUCreatTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PPPU_CreatTime ];

/// PPPU_CreatUser
Property PPPUCreatUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PPPU_CreatUser ];

/// PPPU_UpdateDate
Property PPPUUpdateDate As %Date [ SqlColumnNumber = 17, SqlFieldName = PPPU_UpdateDate ];

/// PPPU_UpdateTime
Property PPPUUpdateTime As %Time [ SqlColumnNumber = 18, SqlFieldName = PPPU_UpdateTime ];

/// PPPU_UpdateUser
Property PPPUUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PPPU_UpdateUser ];

/// PPPU_Standby1
Property PPPUStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PPPU_Standby1 ];

/// PPPU_Standby2
Property PPPUStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PPPU_Standby2 ];

/// PPPU_Standby3
Property PPPUStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PPPU_Standby3 ];

/// PPPU_Standby4
Property PPPUStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PPPU_Standby4 ];

/// PPPU_Standby5
Property PPPUStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = PPPU_Standby5 ];

/// PPPU_Standby6
Property PPPUStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = PPPU_Standby6 ];

/// PPPU_Standby7
Property PPPUStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = PPPU_Standby7 ];

/// PPPU_Standby8
Property PPPUStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PPPU_Standby8 ];

/// PPPU_Standby9
Property PPPUStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = PPPU_Standby9 ];

/// PPPU_Standby10
Property PPPUStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = PPPU_Standby10 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPProjectPlanUser("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPPU_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPPU_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PPPU_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PPPU_PlanEndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPPU_PlanEndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPPU_PlanStartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPPU_PlanStartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPPU_RealityEndDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPPU_RealityEndTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPPU_RealityStartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPPU_RealityStartTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPPU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPPU_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PPPU_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PPPU_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PPPU_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PPPU_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PPPU_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PPPU_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PPPU_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PPPU_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PPPU_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PPPU_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPPU_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PPPU_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PPPU_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PPPU_User">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPP_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPProjectPlanUser</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_ProjectPlan.PPP_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPPU_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_ProjectPlan.PPP_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPPU_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofStatus">
<Global>^PMPProjectPlanUseri</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ProjectPlan.PPP_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPPU_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPPU_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPProjectPlanUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
