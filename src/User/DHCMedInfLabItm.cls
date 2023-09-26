Class User.DHCMedInfLabItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MLAB_Rowid, SqlTableName = DHC_MedInfLabItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MLAB_ActiveFlag
Property MLABActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = MLAB_ActiveFlag ];

/// MLAB_InfType
Property MLABInfType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MLAB_InfType ];

/// MLAB_InfKind
Property MLABInfKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MLAB_InfKind ];

/// MLAB_ItmDesc
Property MLABItmDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MLAB_ItmDesc ];

/// MLAB_ItmExplain
Property MLABItmExplain As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MLAB_ItmExplain ];

/// MLAB_Sample
Property MLABSample As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MLAB_Sample ];

/// MLAB_Demo
Property MLABDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MLAB_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMILI)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MLAB_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MLAB_Demo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MLAB_InfKind">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MLAB_InfType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MLAB_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MLAB_ItmExplain">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MLAB_Sample">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMILI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MLAB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MLAB_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfLabItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
