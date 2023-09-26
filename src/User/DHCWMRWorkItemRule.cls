Class User.DHCWMRWorkItemRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_WorkItemRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WMR_WorkItem Parent Reference
Relationship Parref As User.DHCWMRWorkItem [ Cardinality = parent, Inverse = ChildDHCWMRWorkItemRule, Required ];

/// Child subscript
Property ChildSub As %Library.Float [ InitialExpression = {$i(^DHCWMRWITM($p(%d(0),$c(1),1),"R",0))}, Required, SqlColumnNumber = 2 ];

/// Description
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// Resume
Property Resume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="Description">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Resume">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCWMRWITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WMR_WorkItem.Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WMR_WorkItem.Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"R"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRWorkItemRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
