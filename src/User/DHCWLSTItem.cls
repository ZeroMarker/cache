Class User.DHCWLSTItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WLSTIT_Rowid, SqlTableName = DHC_WLSTItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On WLSTITChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCWLSTDetail As User.DHCWLSTDetail [ Cardinality = children, Inverse = WLSTDTWLSTITParRef ];

/// DHC_WLStat Parent Reference
Relationship WLSTITWLSTATParRef As User.DHCWLStat [ Cardinality = parent, Inverse = ChildDHCWLSTItem, Required, SqlFieldName = WLSTIT_WLSTAT_ParRef ];

/// WLSTIT_Code
Property WLSTITCode As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = WLSTIT_Code ];

/// WLSTIT_Desc
Property WLSTITDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WLSTIT_Desc ];

/// WLSTIT_Ratio
Property WLSTITRatio As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = WLSTIT_Ratio ];

/// WLSTIT_ChildSub
Property WLSTITChildSub As %Library.Float [ InitialExpression = {$i(^DHCWLSTAT($p(%d(0),$c(1),1),"ITEM",0))}, SqlColumnNumber = 6, SqlFieldName = WLSTIT_ChildSub ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterWLSTITEM">
<Data name="WLSTIT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLSTIT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLSTIT_Ratio">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCWLSTAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WLSTIT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WLSTIT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWLSTItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
