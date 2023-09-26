Class User.DHCWMRWorkItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_WorkItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCWMRWorkItemList As User.DHCWMRWorkItemList [ Cardinality = children, Inverse = Parref ];

Relationship ChildDHCWMRWorkItemRule As User.DHCWMRWorkItemRule [ Cardinality = children, Inverse = Parref ];

/// ItemType
Property ItemTypeDr As User.DHCWMRDictionary [ SqlColumnNumber = 2, SqlFieldName = ItemType_Dr ];

/// Description
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// Resume
Property Resume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// SysOper_Dr
Property SysOperDr As User.DHCWMRDictionary [ SqlColumnNumber = 6, SqlFieldName = SysOper_Dr ];

/// CheckUser
Property CheckUser As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// BeRequest
Property BeRequest As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRWITM)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="BeRequest">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CheckUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ItemType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Resume">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SysOper_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWMRWITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRWorkItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
