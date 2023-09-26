Class User.DHCEQEquipConsumable Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EQEquipConsumable, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EC_SourceType
Property ECSourceType As %Library.String(DISPLAYLIST = ",设备,设备项", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 2, SqlFieldName = EC_SourceType ];

/// EC_SourceID
Property ECSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EC_SourceID ];

/// EC_ResourceTypeDR
Property ECResourceTypeDR As User.DHCEQCResourceType [ SqlColumnNumber = 4, SqlFieldName = EC_ResourceTypeDR ];

/// EC_Price
Property ECPrice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = EC_Price ];

/// EC_Unit
Property ECUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EC_Unit ];

/// EC_Quantity
Property ECQuantity As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = EC_Quantity ];

/// EC_Amount
Property ECAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = EC_Amount ];

/// EC_Remark
Property ECRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EC_Remark ];

/// EC_ModelDR
Property ECModelDR As User.DHCEQCModel [ SqlColumnNumber = 10, SqlFieldName = EC_ModelDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipConsumable("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Amount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EC_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EC_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EC_ResourceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Unit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQEquipConsumable</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^DHCEQEquipConsumable</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Resource"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EC_ResourceTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EC_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EC_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQEquipConsumable</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EC_RowID</Field>
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
<Expression>{EC_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EC_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EC_ResourceTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipConsumableS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
