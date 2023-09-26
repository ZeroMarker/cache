Class User.DHCPEIEPrice Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = P_RowID, SqlTableName = DHC_PE_IEPrice, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEIEPrice";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_ItemExtend Parent Reference
Relationship PParref As User.DHCPEItemExtend [ Cardinality = parent, Inverse = ChildDHCPEIEPrice, Required, SqlFieldName = P_Parref ];

/// P_ChildSub
Property PChildSub As %Library.Float [ InitialExpression = {$i(^DHCPEIE($p(%d(0),$c(1),1),"P",0))}, Required, SqlColumnNumber = 2, SqlFieldName = P_ChildSub ];

/// P_Price
Property PPrice As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = P_Price ];

/// P_BeginDate
Property PBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = P_BeginDate ];

/// P_EndDate
Property PEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = P_EndDate ];

/// P_Loc_DR
Property PLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = P_Loc_DR ];

/// P_SetsFlag
Property PSetsFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = P_SetsFlag ];

/// P_1
Property P1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = P_1 ];

/// P_CreateUser_DR
Property PCreateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = P_CreateUser_DR ];

/// P_CreateDate
Property PCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = P_CreateDate ];

/// P_CreateTime
Property PCreateTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = P_CreateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterData">
<Data name="P_1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="P_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="P_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="P_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="P_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="P_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="P_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="P_Price">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="P_SetsFlag">
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
<Field>P_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PE_ItemExtend.IE_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{P_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEIEPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
