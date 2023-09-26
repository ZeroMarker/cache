/// DHC_EQBudget
Class User.DHCEQBudget Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQBudget, StorageStrategy = SQLStorage ]
{

/// B_No
Property BNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = B_No ];

/// B_Name
Property BName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = B_Name ];

/// B_BudgetYear
Property BBudgetYear As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = B_BudgetYear ];

/// B_BudgetType
Property BBudgetType As %String(DISPLAYLIST = ",年度预算", MAXLEN = 2, VALUELIST = ",1") [ SqlColumnNumber = 5, SqlFieldName = B_BudgetType ];

/// B_BudgetInfo
Property BBudgetInfo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = B_BudgetInfo ];

/// B_BudgetAmount
Property BBudgetAmount As %Float [ SqlColumnNumber = 7, SqlFieldName = B_BudgetAmount ];

/// B_UsedLocDR
Property BUsedLocDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = B_UsedLocDR ];

/// B_UsedType
Property BUsedType As %String(DISPLAYLIST = ",采购,维修", MAXLEN = 2, VALUELIST = ",1,2") [ SqlColumnNumber = 9, SqlFieldName = B_UsedType ];

/// B_UsedRangeType
Property BUsedRangeType As %String(DISPLAYLIST = ",类组,类型,分类,设备项,设备", MAXLEN = 2, VALUELIST = ",1,2,3,4,5") [ SqlColumnNumber = 10, SqlFieldName = B_UsedRangeType ];

/// B_UsedRange
Property BUsedRange As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = B_UsedRange ];

/// B_RemainAmount
Property BRemainAmount As %Float [ SqlColumnNumber = 12, SqlFieldName = B_RemainAmount ];

/// B_FreezeAmount
Property BFreezeAmount As %Float [ SqlColumnNumber = 13, SqlFieldName = B_FreezeAmount ];

/// B_MakerUserDR
Property BMakerUserDR As SSUser [ SqlColumnNumber = 14, SqlFieldName = B_MakerUserDR ];

/// B_MakerLocDR
Property BMakerLocDR As CTLoc [ SqlColumnNumber = 15, SqlFieldName = B_MakerLocDR ];

/// B_MakerDate
Property BMakerDate As %Date [ SqlColumnNumber = 16, SqlFieldName = B_MakerDate ];

/// B_Status
Property BStatus As %String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 17, SqlFieldName = B_Status ];

/// B_Remark
Property BRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = B_Remark ];

/// B_InvalidFlag
Property BInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = B_InvalidFlag ];

/// B_AddUserDR
Property BAddUserDR As SSUser [ SqlColumnNumber = 20, SqlFieldName = B_AddUserDR ];

/// B_AddDate
Property BAddDate As %Date [ SqlColumnNumber = 21, SqlFieldName = B_AddDate ];

/// B_AddTime
Property BAddTime As %Time [ SqlColumnNumber = 22, SqlFieldName = B_AddTime ];

/// B_SubmitUserDR
Property BSubmitUserDR As SSUser [ SqlColumnNumber = 23, SqlFieldName = B_SubmitUserDR ];

/// B_SubmitDate
Property BSubmitDate As %Date [ SqlColumnNumber = 24, SqlFieldName = B_SubmitDate ];

/// B_SubmitTime
Property BSubmitTime As %Time [ SqlColumnNumber = 25, SqlFieldName = B_SubmitTime ];

/// B_AuditUserDR
Property BAuditUserDR As SSUser [ SqlColumnNumber = 26, SqlFieldName = B_AuditUserDR ];

/// B_AuditDate
Property BAuditDate As %Date [ SqlColumnNumber = 27, SqlFieldName = B_AuditDate ];

/// B_AuditTime
Property BAuditTime As %Time [ SqlColumnNumber = 28, SqlFieldName = B_AuditTime ];

/// B_CancelUserDR
Property BCancelUserDR As SSUser [ SqlColumnNumber = 29, SqlFieldName = B_CancelUserDR ];

/// B_CancelDate
Property BCancelDate As %Date [ SqlColumnNumber = 30, SqlFieldName = B_CancelDate ];

/// B_CancelTime
Property BCancelTime As %Time [ SqlColumnNumber = 31, SqlFieldName = B_CancelTime ];

/// B_Hold1
Property BHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = B_Hold1 ];

/// B_Hold2
Property BHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = B_Hold2 ];

/// B_Hold3
Property BHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = B_Hold3 ];

/// B_Hold4
Property BHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = B_Hold4 ];

/// B_Hold5
Property BHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = B_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQBudget("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="B_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="B_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="B_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="B_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="B_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="B_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="B_BudgetAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="B_BudgetInfo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="B_BudgetType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="B_BudgetYear">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="B_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="B_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="B_CancelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="B_FreezeAmount">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="B_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="B_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="B_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="B_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="B_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="B_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="B_MakerDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="B_MakerLocDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="B_MakerUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="B_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="B_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="B_RemainAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="B_Remark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="B_Status">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="B_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="B_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="B_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="B_UsedLocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="B_UsedRange">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="B_UsedRangeType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="B_UsedType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQBudget</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexYearUsedType">
<Global>^DHCEQBudget</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YearUsedType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{B_BudgetType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{B_BudgetYear}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{B_UsedType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>B_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQBudgetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
