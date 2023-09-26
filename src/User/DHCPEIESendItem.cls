Class User.DHCPEIESendItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SI_RowID, SqlTableName = DHC_PE_IESendItem, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEIESendItem";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_ItemExtend Parent Reference
Relationship SIParref As User.DHCPEItemExtend [ Cardinality = parent, Inverse = ChildDHCPEIESendItem, Required, SqlFieldName = SI_Parref ];

/// SI_ChildSub
Property SIChildSub As %Library.Float [ InitialExpression = {$i(^DHCPEIE($p(%d(0),$c(1),1),"SI",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SI_ChildSub ];

/// SI_CostFeeMin
Property SICostFeeMin As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SI_CostFeeMin ];

/// SI_CostFeeMax
Property SICostFeeMax As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SI_CostFeeMax ];

/// SI_BeginDate
Property SIBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = SI_BeginDate ];

/// SI_EndDate
Property SIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = SI_EndDate ];

/// SI_Loc_DR
Property SILocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SI_Loc_DR ];

/// SI_GroupFlag
Property SIGroupFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SI_GroupFlag ];

/// SI_1
Property SI1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SI_1 ];

/// SI_CreateUser_DR
Property SICreateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = SI_CreateUser_DR ];

/// SI_CreateDate
Property SICreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = SI_CreateDate ];

/// SI_CreateTime
Property SICreateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = SI_CreateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterData">
<Data name="SI_1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SI_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SI_CostFeeMax">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SI_CostFeeMin">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SI_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SI_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SI_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SI_GroupFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SI_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPEIE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_ItemExtend.IE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PE_ItemExtend.IE_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEIESendItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
