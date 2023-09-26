Class User.DHCLocDailyTotal Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Day_RowID, SqlTableName = DHC_LocDailyTotal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCLocBTDailyTotal As User.DHCLocBTDailyTotal [ Cardinality = children, Inverse = DayBTParRef ];

/// Day_Itm_DR : User.INCItm
Property DayItmDR As %Library.String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Day_Itm_DR ];

/// Day_Loc_DR : User.CTLoc
Property DayLocDR As %Library.String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Day_Loc_DR ];

/// Day_QtyBeg
Property DayQtyBeg As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = Day_QtyBeg ];

/// Day_QtyEnd
Property DayQtyEnd As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = Day_QtyEnd ];

/// Day_Date
Property DayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = Day_Date ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLOCTOT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Day_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Day_Itm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Day_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Day_QtyBeg">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Day_QtyEnd">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCLOCTOT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Day_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Day_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCLOCTOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>Day_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Day_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Day_Loc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Day_Itm_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{Day_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocItmDate">
<Global>^DHCLOCTOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>Day_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCITMDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Day_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Day_Itm_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Day_Date}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{Day_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCLocDailyTotalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
    s newI = +$g(^DHCLOCTOT)
    s oldI = +$g(^mdata("DHCLOCDAILYTOTAL"))
    s maxI = $s(newI > oldI : newI, 1 : oldI)
    s ^DHCLOCTOT = maxI
    s ^mdata("DHCLOCDAILYTOTAL") = maxI
}

}
