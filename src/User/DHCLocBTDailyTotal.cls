Class User.DHCLocBTDailyTotal Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DayBT_RowID, SqlTableName = DHC_LocBTDailyTotal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DayBTChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_LocDailyTotal Parent Reference
Relationship DayBTParRef As User.DHCLocDailyTotal [ Cardinality = parent, Inverse = ChildDHCLocBTDailyTotal, Required, SqlFieldName = DayBT_ParRef ];

/// DayBT_Bat_DR : User.INCItmLcBt
Property DayBTBatDR As %Library.String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DayBT_Bat_DR ];

/// DayBT_QtyBeg
Property DayBTQtyBeg As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DayBT_QtyBeg ];

/// DayBT_QtyEnd
Property DayBTQtyEnd As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DayBT_QtyEnd ];

/// DayBT_Childsub
Property DayBTChildsub As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DayBT_Childsub ];

/// Day_Date
Property DayBTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DayBT_Date ];

/// Loc : User.CTLoc
Property DayBTLocDR As %Library.String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DayBT_Loc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DayBT_Bat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DayBT_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DayBT_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DayBT_QtyBeg">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DayBT_QtyEnd">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCBTLOCTOT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LocDailyTotal.Day_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DayBT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_LocDailyTotal.Day_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DayBT_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCIDateLocINCLB">
<Global>^DHCBTLOCTOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_LocDailyTotal.Day_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>DayBT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCIDateLocINCLB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$p({DayBT_Bat_DR},"||")</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DayBT_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DayBT_Loc_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DayBT_Bat_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_LocDailyTotal.Day_RowID}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DayBT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCLBDate">
<Global>^DHCBTLOCTOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_LocDailyTotal.Day_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DayBT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCLBDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DayBT_Bat_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DayBT_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_LocDailyTotal.Day_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DayBT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocBtDate">
<Global>^DHCBTLOCTOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_LocDailyTotal.Day_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DayBT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LocBtDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DayBT_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DayBT_Bat_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DayBT_Date}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_LocDailyTotal.Day_RowID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{DayBT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDateINCLB">
<Global>^DHCBTLOCTOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_LocDailyTotal.Day_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DayBT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDateINCLB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DayBT_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DayBT_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DayBT_Bat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_LocDailyTotal.Day_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DayBT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCLocBTDailyTotalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
