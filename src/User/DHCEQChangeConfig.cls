Class User.DHCEQChangeConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CC_RowID, SqlTableName = DHC_EQChangeConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CC_SourceDR
Property CCSourceDR As User.DHCEQConfig [ SqlColumnNumber = 2, SqlFieldName = CC_SourceDR ];

/// CC_EquipDR
Property CCEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = CC_EquipDR ];

/// CC_ChangeDate
Property CCChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = CC_ChangeDate ];

/// CC_ChangeType
Property CCChangeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CC_ChangeType ];

/// CC_FromConfigItemDR
Property CCFromConfigItemDR As User.DHCEQCConfigItem [ SqlColumnNumber = 6, SqlFieldName = CC_FromConfigItemDR ];

/// CC_FromValue
Property CCFromValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CC_FromValue ];

/// CC_ToConfigItemDR
Property CCToConfigItemDR As User.DHCEQCConfigItem [ SqlColumnNumber = 8, SqlFieldName = CC_ToConfigItemDR ];

/// CC_ToValue
Property CCToValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CC_ToValue ];

/// CC_Remark
Property CCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CC_Remark ];

/// CC_AuditUserDR
Property CCAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CC_AuditUserDR ];

/// CC_AuditDate
Property CCAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = CC_AuditDate ];

/// CC_Status
Property CCStatus As %Library.String(DISPLAYLIST = ",新增,审核", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 13, SqlFieldName = CC_Status ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQChangeConfig("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CC_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CC_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CC_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CC_ChangeType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CC_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CC_FromConfigItemDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CC_FromValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CC_SourceDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CC_Status">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CC_ToConfigItemDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CC_ToValue">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQChangeConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQChangeConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQChangeConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
