/// 名称: 药品业务表 5用量用法
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCPHUsageDosage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHUSDO_RowId, SqlTableName = DHC_PHUsageDosage, StorageStrategy = SQLStorage ]
{

/// PHUSDO_RowId  ^DHCPHUSDO
Property PHUSDOInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHUSDO_Inst_Dr ];

/// PHUSDO_OneDayTimeMin
Property PHUSDOOneDayTimeMin As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PHUSDO_OneDayTimeMin ];

/// PHUSDO_OneDayTimeMax
Property PHUSDOOneDayTimeMax As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHUSDO_OneDayTimeMax ];

/// PHUSDO_OnceQtyMin
Property PHUSDOOnceQtyMin As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHUSDO_OnceQtyMin ];

/// PHUSDO_OnceQtyMax
Property PHUSDOOnceQtyMax As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHUSDO_OnceQtyMax ];

/// PHUSDO_OnceQtyUom_Dr
Property PHUSDOOnceQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 7, SqlFieldName = PHUSDO_OnceQtyUom_Dr ];

/// PHUSDO_OneDayQtyMin
Property PHUSDOOneDayQtyMin As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHUSDO_OneDayQtyMin ];

/// PHUSDO_OneDayQtyMax
Property PHUSDOOneDayQtyMax As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PHUSDO_OneDayQtyMax ];

/// PHUSDO_OneDayQtyUom_Dr
Property PHUSDOOneDayQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 10, SqlFieldName = PHUSDO_OneDayQtyUom_Dr ];

/// PHUSDO_OnceMaxQty
Property PHUSDOOnceMaxQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PHUSDO_OnceMaxQty ];

/// PHUSDO_OnceMaxQtyUom_Dr
Property PHUSDOOnceMaxQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 12, SqlFieldName = PHUSDO_OnceMaxQtyUom_Dr ];

/// PHUSDO_OneDayMaxQty
Property PHUSDOOneDayMaxQty As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PHUSDO_OneDayMaxQty ];

/// PHUSDO_OneDayMaxQtyUom_Dr
Property PHUSDOOneDayMaxQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 14, SqlFieldName = PHUSDO_OneDayMaxQtyUom_Dr ];

/// PHUSDO_FristTimeQtyMin
Property PHUSDOFristTimeQtyMin As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = PHUSDO_FristTimeQtyMin ];

/// PHUSDO_FristTimeQtyMax
Property PHUSDOFristTimeQtyMax As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = PHUSDO_FristTimeQtyMax ];

/// PHUSDO_FristTimeQtyUom_Dr
Property PHUSDOFristTimeQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 17, SqlFieldName = PHUSDO_FristTimeQtyUom_Dr ];

/// PHUSDO_DurationQtyMin
Property PHUSDODurationQtyMin As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PHUSDO_DurationQtyMin ];

/// PHUSDO_DurationQtyMax
Property PHUSDODurationQtyMax As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PHUSDO_DurationQtyMax ];

/// PHUSDO_DurationQtyUom_Dr
Property PHUSDODurationQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 20, SqlFieldName = PHUSDO_DurationQtyUom_Dr ];

/// PHUSDO_SpaceQtyMin
Property PHUSDOSpaceQtyMin As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = PHUSDO_SpaceQtyMin ];

/// PHUSDO_SpaceQtyMax
Property PHUSDOSpaceQtyMax As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = PHUSDO_SpaceQtyMax ];

/// PHUSDO_SpaceQtyUom_Dr
Property PHUSDOSpaceQtyUomDr As DHCPHExtUom [ SqlColumnNumber = 23, SqlFieldName = PHUSDO_SpaceQtyUom_Dr ];

/// PHUSDO_WeightMin
Property PHUSDOWeightMin As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = PHUSDO_WeightMin ];

/// PHUSDO_WeightMax
Property PHUSDOWeightMax As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = PHUSDO_WeightMax ];

/// PHUSDO_BodyAreaMin
Property PHUSDOBodyAreaMin As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = PHUSDO_BodyAreaMin ];

/// PHUSDO_BodyAreaMax
Property PHUSDOBodyAreaMax As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = PHUSDO_BodyAreaMax ];

/// PHUSDO_DurationDayMin连用最大天数
Property PHUSDODurationDayMin As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = PHUSDO_DurationDayMin ];

/// PHUSDO_DurationDayMax连用最小天数
Property PHUSDODurationDayMax As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = PHUSDO_DurationDayMax ];

/// PHUSDO_WeightKg按体重每多少kg
Property PHUSDOWeightKg As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = PHUSDO_WeightKg ];

/// 新增字段疗程
Property PHUSDOPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PHUSDO_Period ];

/// 新增字段疗程
Storage SQLStorage
{
<Description>
<![CDATA[新增字段疗程]]></Description>
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHUSDO(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHUSDO_BodyAreaMax">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PHUSDO_BodyAreaMin">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PHUSDO_DurationDayMax">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PHUSDO_DurationDayMin">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PHUSDO_DurationQtyMax">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHUSDO_DurationQtyMin">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHUSDO_DurationQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHUSDO_FristTimeQtyMax">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHUSDO_FristTimeQtyMin">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHUSDO_FristTimeQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHUSDO_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUSDO_OnceMaxQty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHUSDO_OnceMaxQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHUSDO_OnceQtyMax">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHUSDO_OnceQtyMin">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHUSDO_OnceQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHUSDO_OneDayMaxQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHUSDO_OneDayMaxQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHUSDO_OneDayQtyMax">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHUSDO_OneDayQtyMin">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHUSDO_OneDayQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHUSDO_OneDayTimeMax">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUSDO_OneDayTimeMin">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHUSDO_Period">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PHUSDO_SpaceQtyMax">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHUSDO_SpaceQtyMin">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHUSDO_SpaceQtyUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHUSDO_WeightKg">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PHUSDO_WeightMax">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHUSDO_WeightMin">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCPHUSDO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHUSDO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHUSDO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHUSDO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHUSDO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHUSDO_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHUSDO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHUSDO_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHUsageDosageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
