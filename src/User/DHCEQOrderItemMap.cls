Class User.DHCEQOrderItemMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OIM_RowID, SqlTableName = DHC_EQOrderItemMap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OIM_EquipDR
Property OIMEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = OIM_EquipDR ];

/// OIM_OrderItemDR
Property OIMOrderItemDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OIM_OrderItemDR ];

/// OIM_Remark
Property OIMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OIM_Remark ];

/// OIM_AddUserDR
Property OIMAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OIM_AddUserDR ];

/// OIM_AddDate
Property OIMAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OIM_AddDate ];

/// OIM_AddTime
Property OIMAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = OIM_AddTime ];

/// OIM_UpdateUserDR
Property OIMUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OIM_UpdateUserDR ];

/// OIM_UpdateDate
Property OIMUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = OIM_UpdateDate ];

/// OIM_UpdateTime
Property OIMUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = OIM_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOrderItemMap("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OIM_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OIM_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OIM_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OIM_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OIM_OrderItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OIM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OIM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OIM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OIM_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQOrderItemMap</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OIM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OIM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQOrderItemMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OIM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OIM_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OIM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderItem">
<Global>^DHCEQOrderItemMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OIM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrderItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OIM_OrderItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OIM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOrderItemMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
