Class User.PMPContractAging Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCTA_Rowid, SqlTableName = PMP_ContractAging, StorageStrategy = SQLStorage ]
{

Relationship ChildPCAMSub As PMPContractAgingMode [ Cardinality = children, Inverse = PCTAParRef ];

/// PCTA_Contract
Property PCTAContract As PMPContract [ SqlColumnNumber = 2, SqlFieldName = PCTA_Contract ];

/// PCTA_Aging
Property PCTAAging As PMPDictionary3 [ SqlColumnNumber = 3, SqlFieldName = PCTA_Aging ];

/// PCTA_Code
Property PCTACode As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PCTA_Code ];

/// PCTA_Desc
Property PCTADesc As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PCTA_Desc ];

/// PCTA_Status
Property PCTAStatus As PMPDictionary3 [ SqlColumnNumber = 6, SqlFieldName = PCTA_Status ];

/// PCTA_StartDate
Property PCTAStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PCTA_StartDate ];

/// PCTA_StartTime
Property PCTAStartTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PCTA_StartTime ];

/// PCTA_EndDate
Property PCTAEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PCTA_EndDate ];

/// PCTA_EndTime
Property PCTAEndTime As %Time [ SqlColumnNumber = 10, SqlFieldName = PCTA_EndTime ];

/// PCTA_CreatUser
Property PCTACreatUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PCTA_CreatUser ];

/// PCTA_CreatDate
Property PCTACreatDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PCTA_CreatDate ];

/// PCTA_CreatTime
Property PCTACreatTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PCTA_CreatTime ];

/// PCTA_UpdateDate
Property PCTAUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PCTA_UpdateDate ];

/// PCTA_UpdateTime
Property PCTAUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PCTA_UpdateTime ];

/// PCTA_UpdateUser
Property PCTAUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PCTA_UpdateUser ];

/// PCTA_Standby1
Property PCTAStandby1 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PCTA_Standby1 ];

/// PCTA_Standby2
Property PCTAStandby2 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PCTA_Standby2 ];

/// PCTA_Standby3
Property PCTAStandby3 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PCTA_Standby3 ];

/// PCTA_Standby4
Property PCTAStandby4 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PCTA_Standby4 ];

/// PCTA_Standby5
Property PCTAStandby5 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PCTA_Standby5 ];

/// PCTA_Standby6
Property PCTAStandby6 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PCTA_Standby6 ];

/// PCTA_Standby7
Property PCTAStandby7 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PCTA_Standby7 ];

/// PCTA_Standby8
Property PCTAStandby8 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PCTA_Standby8 ];

/// PCTA_Standby9
Property PCTAStandby9 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PCTA_Standby9 ];

/// PCTA_Standby10
Property PCTAStandby10 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PCTA_Standby10 ];

/// PCTA_Remark
Property PCTARemark As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PCTA_Remark ];

/// PCTA_PlanStartDate
Property PCTAPlanStartDate As %Date [ SqlColumnNumber = 28, SqlFieldName = PCTA_PlanStartDate ];

/// PCTA_PlanStartTime
Property PCTAPlanStartTime As %Time [ SqlColumnNumber = 29, SqlFieldName = PCTA_PlanStartTime ];

/// PCTA_PlanEndDate
Property PCTAPlanEndDate As %Date [ SqlColumnNumber = 30, SqlFieldName = PCTA_PlanEndDate ];

/// PCTA_PlanEndTime
Property PCTAPlanEndTime As %Time [ SqlColumnNumber = 31, SqlFieldName = PCTA_PlanEndTime ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPContractAging("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PCTA_Aging">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCTA_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCTA_Contract">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCTA_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCTA_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCTA_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCTA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCTA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCTA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCTA_PlanEndDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PCTA_PlanEndTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PCTA_PlanStartDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PCTA_PlanStartTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PCTA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PCTA_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PCTA_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PCTA_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PCTA_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PCTA_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PCTA_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PCTA_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PCTA_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PCTA_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PCTA_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PCTA_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCTA_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCTA_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCTA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCTA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCTA_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^PMPContractAging</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCTA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCTA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofContract">
<Global>^PMPContractAgingi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PCTA_Contract}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCTA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPContractAgingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
