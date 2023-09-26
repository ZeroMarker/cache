Class User.DHCLog Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DL_Rowid, SqlTableName = DHC_Log, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCLogArcim As User.DHCLogArcim [ Cardinality = children, Inverse = DLARDLParref ];

Relationship ChildDHCLogINCI As User.DHCLogINCI [ Cardinality = children, Inverse = DLINDLParref ];

Relationship ChildDHCLogPhcd As User.DHCLogPhcd [ Cardinality = children, Inverse = DLPHDLParref ];

/// DL_Date 
Property DLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DL_Date ];

/// DL_Time
Property DLTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = DL_Time ];

/// DL_SSUSR_DR : User.SSUser  
Property DLSSUSRDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DL_SSUSR_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLOG)</SqlIdExpression>
<SQLMap name="DataMasterDhcLog">
<Data name="DL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DL_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
