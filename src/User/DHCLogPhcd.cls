Class User.DHCLogPhcd Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLPH_Rowid, SqlTableName = DHC_Log_Phcd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DLPHChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_Log Parent Reference
Relationship DLPHDLParref As User.DHCLog [ Cardinality = parent, Inverse = ChildDHCLogPhcd, Required, SqlFieldName = DLPH_DL_Parref ];

/// DLPH_Childsub
Property DLPHChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DLPH_Childsub ];

/// DLPH_Code
Property DLPHCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DLPH_Code ];

/// DLPH_Desc
Property DLPHDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DLPH_Desc ];

/// DLPH_Poison :User.PHCPoison
Property DLPHPoison As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DLPH_Poison ];

/// DLPH_Manufacturer :User.PHManufacturer
Property DLPHManufacturer As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DLPH_Manufacturer ];

/// DLPH_SubCat :User.PHCSubCat
Property DLPHSubCat As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DLPH_SubCat ];

/// DLPH_MinorSubCat :User.PHCMinorSubCat
Property DLPHMinorSubCat As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DLPH_MinorSubCat ];

/// DLPH_Generic :User.PHCGeneric
Property DLPHGeneric As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DLPH_Generic ];

/// DLPH_OfficialCode
Property DLPHOfficialCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DLPH_OfficialCode ];

/// DLPH_CTUOM_DR :User.CTUOM
Property DLPHCTUOMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DLPH_CTUOM_DR ];

/// DLPH_PHCD_DR :User.PHCDrgMast
Property DLPHPHCDDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DLPH_PHCD_DR ];

/// DLPH_Type
Property DLPHType As %Library.String(MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 13, SqlFieldName = DLPH_Type ];

/// DLPH_Freq :User.PHCFreq
Property DLPHFreq As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DLPH_Freq ];

/// DLPH_Form :User.PHCForm
Property DLPHForm As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DLPH_Form ];

/// DLPH_Instruction :User.PHCInstruc
Property DLPHInstruction As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DLPH_Instruction ];

/// DLPH_Reason
Property DLPHReason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DLPH_Reason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DLPH_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DLPH_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLPH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLPH_Form">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DLPH_Freq">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DLPH_Generic">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DLPH_Instruction">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DLPH_Manufacturer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DLPH_MinorSubCat">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DLPH_OfficialCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DLPH_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLPH_Poison">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DLPH_Reason">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DLPH_SubCat">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLPH_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_Log.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DLPH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_Log.DL_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHCD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLPH_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCD">
<Global>^DHCLOG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_Log.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DLPH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHLOG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLPH_PHCD_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_Log.DL_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DLPH_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCLogPhcdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
