Class User.DHCAppTreeLink Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TRA_RowID, SqlTableName = DHC_AppTreeLink, StorageStrategy = SQLStorage ]
{

/// DHC_AppTreeAdd Parent Reference TRA_Add_ParRef
Relationship TRAAddParRef As User.DHCAppTreeAdd [ Cardinality = parent, Inverse = ChildDHCAPPTREELINK, Required, SqlFieldName = TRA_Add_ParRef ];

Relationship ChildDHCAPPTREEGROUP As User.DHCAppTreeGroup [ Cardinality = children, Inverse = TRALinkParRef ];

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On TRAChildSub [ IdKey, PrimaryKey, Unique ];

/// TRA_ChildSub
Property TRAChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = TRA_ChildSub ];

/// 子部位id  TRA_Part_Dr 
Property TRAPartDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = TRA_Part_Dr ];

/// 医嘱项id  TRA_Arc_Dr
Property TRAArcDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = TRA_Arc_Dr ];

/// 开始日期  TRA_StDate
Property TRAStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = TRA_StDate ];

/// 截止日期  TRA_EndDate
Property TRAEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = TRA_EndDate ];

/// 顺序号  TRA_OrdNum
Property TRAOrdNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TRA_OrdNum ];

/// 牙位图标志  TRA_ToothFlag
Property TRAToothFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TRA_ToothFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TRA_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRA_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRA_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRA_StDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRA_ToothFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppTreeAdd.TRA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppTreeAdd.TRA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArc">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppTreeAdd.TRA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TRA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppTreeAdd.TRA_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPart">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppTreeAdd.TRA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TRA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Part"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_Part_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppTreeAdd.TRA_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTreeLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
