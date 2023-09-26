Class User.DHCEQBuildingUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BU_RowID, SqlTableName = DHC_EQBuildingUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BU_BuildingDR
Property BUBuildingDR As User.DHCEQBuilding [ SqlColumnNumber = 2, SqlFieldName = BU_BuildingDR ];

/// BU_Desc
Property BUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BU_Desc ];

/// BU_Floor
Property BUFloor As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BU_Floor ];

/// BU_DoorNo
Property BUDoorNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BU_DoorNo ];

/// BU_Place
Property BUPlace As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BU_Place ];

/// BU_BuildingArea
Property BUBuildingArea As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = BU_BuildingArea ];

/// BU_UtilizationArea
Property BUUtilizationArea As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = BU_UtilizationArea ];

/// BU_Stuct
Property BUStuct As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BU_Stuct ];

/// BU_UseLocDR
Property BUUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BU_UseLocDR ];

/// BU_LendTypeDR
Property BULendTypeDR As User.DHCEQCLendType [ SqlColumnNumber = 11, SqlFieldName = BU_LendTypeDR ];

/// BU_Company
Property BUCompany As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BU_Company ];

/// BU_ContractPerson
Property BUContractPerson As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BU_ContractPerson ];

/// BU_Purpose
Property BUPurpose As User.DHCEQCLandPurpose [ SqlColumnNumber = 14, SqlFieldName = BU_Purpose ];

/// BU_OriginalFee
Property BUOriginalFee As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = BU_OriginalFee ];

/// BU_RentFee
Property BURentFee As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = BU_RentFee ];

/// BU_RentFeeType
Property BURentFeeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BU_RentFeeType ];

/// BU_BeginDate
Property BUBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = BU_BeginDate ];

/// BU_EndDate
Property BUEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = BU_EndDate ];

/// BU_UserDR
Property BUUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BU_UserDR ];

/// BU_Date
Property BUDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = BU_Date ];

/// BU_SubmitUserDR
Property BUSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BU_SubmitUserDR ];

/// BU_SubmitDate
Property BUSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = BU_SubmitDate ];

/// BU_SubmitTime
Property BUSubmitTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = BU_SubmitTime ];

/// BU_AuditUserDR
Property BUAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BU_AuditUserDR ];

/// BU_AuditDate
Property BUAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = BU_AuditDate ];

/// BU_AuditTime
Property BUAuditTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = BU_AuditTime ];

/// BU_Status
Property BUStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 28, SqlFieldName = BU_Status ];

/// BU_Hold1
Property BUHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BU_Hold1 ];

/// BU_Hold2
Property BUHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BU_Hold2 ];

/// BU_Hold3
Property BUHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = BU_Hold3 ];

/// BU_Hold4
Property BUHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = BU_Hold4 ];

/// BU_Hold5
Property BUHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = BU_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuildingUnit("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BU_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BU_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BU_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BU_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BU_BuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BU_BuildingDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BU_Company">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BU_ContractPerson">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BU_Date">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BU_DoorNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BU_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BU_Floor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BU_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BU_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BU_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BU_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BU_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BU_LendTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BU_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BU_Place">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BU_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BU_RentFee">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BU_RentFeeType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BU_Status">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BU_Stuct">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BU_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BU_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BU_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BU_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BU_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BU_UtilizationArea">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQBuildingUnit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuilding">
<Global>^DHCEQBuildingUnit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Building"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BU_BuildingDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuildingUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
