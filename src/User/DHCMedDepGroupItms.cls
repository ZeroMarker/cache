Class User.DHCMedDepGroupItms Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDGI_Rowid, SqlTableName = DHC_MedDepGroupItms, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MDGIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedDepGroup Parent Reference
Relationship MDGIParRef As User.DHCMedDepGroup [ Cardinality = parent, Inverse = ChildDHCMedDepGroupItms, Required, SqlFieldName = MDGI_ParRef ];

/// Child subscript
Property MDGIChildSub As %Library.Float [ InitialExpression = {$i(^DHCMDG($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MDGI_ChildSub ];

/// MDGI_ActiveFlag
Property MDGIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = MDGI_ActiveFlag ];

/// MDGI_MLAB_DR
Property MDGIMLABDR As User.DHCMedInfLabItm [ SqlColumnNumber = 4, SqlFieldName = MDGI_MLAB_DR ];

/// MDGI_Demo
Property MDGIDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MDGI_Demo ];

/// MDGI_Points
Property MDGIPoints As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MDGI_Points ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MDGI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDGI_Demo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDGI_MLAB_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDGI_Points">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMDG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedDepGroup.MDG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MDGI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedDepGroup.MDG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDGI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDepGroupItmsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
