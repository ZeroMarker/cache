Class User.DHCEQDepreSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DS_RowID, SqlTableName = DHC_EQDepreSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DS_EquipDR
Property DSEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = DS_EquipDR ];

/// DS_DepreMethodDR
Property DSDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 3, SqlFieldName = DS_DepreMethodDR ];

/// DS_MainFlag
Property DSMainFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DS_MainFlag ];

/// DS_AutoFlag
Property DSAutoFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DS_AutoFlag ];

/// DS_PreDepreMonth
Property DSPreDepreMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DS_PreDepreMonth ];

/// DS_CostAllotType
Property DSCostAllotType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DS_CostAllotType ];

/// DS_CostAllotDR
Property DSCostAllotDR As User.DHCEQCostAllot [ SqlColumnNumber = 8, SqlFieldName = DS_CostAllotDR ];

/// DS_Remark
Property DSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DS_Remark ];

/// DS_Status
Property DSStatus As %Library.String(DISPLAYLIST = ",新增,提交", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 10, SqlFieldName = DS_Status ];

/// DS_AddUserDR
Property DSAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DS_AddUserDR ];

/// DS_AddDate
Property DSAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DS_AddDate ];

/// DS_AddTime
Property DSAddTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DS_AddTime ];

/// DS_UpdateUserDR
Property DSUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DS_UpdateUserDR ];

/// DS_UpdateDate
Property DSUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = DS_UpdateDate ];

/// DS_UpdateTime
Property DSUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = DS_UpdateTime ];

/// DS_AuditUserDR
Property DSAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DS_AuditUserDR ];

/// DS_AuditDate
Property DSAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = DS_AuditDate ];

/// DS_AuditTime
Property DSAuditTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = DS_AuditTime ];

/// DS_DepreType
Property DSDepreTypeDR As User.DHCEQCDepreType [ SqlColumnNumber = 20, SqlFieldName = DS_DepreTypeDR ];

/// DS_SourceType
Property DSSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DS_SourceType ];

/// DS_SourceID
Property DSSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DS_SourceID ];

/// DS_DepreTotal
Property DSDepreTotal As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = DS_DepreTotal ];

/// DS_DepreTotalFee
Property DSDepreTotalFee As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = DS_DepreTotalFee ];

/// DS_Years
Property DSYears As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = DS_Years ];

/// DS_Hold1 开始折旧日期
Property DSHold1 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = DS_Hold1 ];

/// DS_Hold2 设备折旧状态
Property DSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DS_Hold2 ];

/// DS_Hold3
Property DSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DS_Hold3 ];

/// DS_Hold4
Property DSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DS_Hold4 ];

/// DS_Hold5
Property DSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DS_Hold5 ];

/// add by czf 2020-06-02 begin
Trigger AfterDelete [ Event = INSERT, Time = AFTER ]
{
	Set id = {DS_RowID}
	set equipdr={DS_EquipDR}
	d ##Class(web.DHCEQDepreSet).AfterDelete(id, equipdr)
}

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
	Set id = {DS_RowID}
	set equipdr={DS_EquipDR}
	set predepremonth={DS_PreDepreMonth}
	set depretotalnum={DS_DepreTotal}
	d ##Class(web.DHCEQDepreSet).AfterInsert(id, equipdr, predepremonth, depretotalnum)
}

Trigger AfterUpdate [ Event = UPDATE, Time = AFTER ]
{
	Set id = {DS_RowID}
	set equipdr={DS_EquipDR}
	set predepremonth={DS_PreDepreMonth}
	set depretotalnum={DS_DepreTotal}
	d ##Class(web.DHCEQDepreSet).AfterUpdate(id, equipdr, predepremonth, depretotalnum)
}

/// add by czf 2020-06-03 end
Storage SQLStorage
{
<Description>
<![CDATA[add by czf 2020-06-03 end]]></Description>
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDepreSet("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DS_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DS_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DS_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DS_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DS_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DS_AutoFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DS_CostAllotDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DS_CostAllotType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DS_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DS_DepreTotal">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DS_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DS_DepreTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DS_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DS_MainFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DS_PreDepreMonth">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DS_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DS_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DS_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DS_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DS_Years">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^DHCEQDepreSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQDepreSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DS_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipMain">
<Global>^DHCEQDepreSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipMain"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DS_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DS_MainFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQDepreSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DS_RowID</Field>
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
<Expression>{DS_DepreTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DS_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DS_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDepreSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
