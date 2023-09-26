/// 站点分类字典表
Class User.DHCPEStationLoc Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STL_RowId, SqlTableName = DHC_PE_StationLoc, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEStationLoc";

Parameter EXTENTSIZE = 250;

/// DHC_PE_Station Parent Reference
Relationship STLParRef As User.DHCPEStation [ Cardinality = parent, Inverse = ChildDHCPEStationLoc, Required, SqlFieldName = STL_ParRef ];

Index RowIDBasedIDKeyIndex On STLChildSub [ IdKey, PrimaryKey, Unique ];

/// STL_ChildSub
Property STLChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ InitialExpression = {$i(^DHCPEST($p(%d(0),$c(1),1),"Loc",0))}, Required, SqlColumnNumber = 2, SqlFieldName = STL_ChildSub ];

/// 站点分类
Property STLLocDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = STL_LocDesc ];

/// 【作废】顺序号
Property STLLocSort As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = STL_LocSort ];

/// 作废标记
Property STLNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = STL_NoActive ];

/// 更新日期
Property STLUpdateDate As %Date [ SqlFieldName = STL_UpdateDate ];

/// 更新时间
Property STLUpdateTime As %Time [ SqlFieldName = STL_UpdateTime ];

/// 更信人 指向SS_User
Property STLUpdateUserDR As %String [ SqlFieldName = STL_UpdateUserDR ];

/// 知识库站点项目分类代码（外部码）
Property STLKBXCode As %String [ SqlFieldName = STL_KBXCode ];

/// 知识库站点项目分类描述
Property STLKBItemCatDesc As %String(MAXLEN = 200) [ SqlFieldName = STL_KBItemCatDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPESTL">
<Data name="STL_KBItemCatDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STL_KBXCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STL_LocDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STL_LocSort">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STL_NoActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>STL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfDesc">
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>STL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STL_LocDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{STL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxOfKBXCode">
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>STL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"KBXCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STL_KBXCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{STL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEStationWaitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
