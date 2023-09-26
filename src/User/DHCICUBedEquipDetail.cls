/// DHC_ICU_BedEquipDetail
Class User.DHCICUBedEquipDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUBED_RowId, SqlTableName = DHC_ICU_BedEquipDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ICUBEDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_ICU_BedEquip Parent Reference
Relationship ICUBEDParref As User.DHCICUBedEquip [ Cardinality = parent, Inverse = ChildDHCICUBedEquipDetail, Required, SqlFieldName = ICUBED_Parref ];

/// ICUBED_ChildSub
Property ICUBEDChildSub As %Library.Float [ InitialExpression = {$i(^DHCICUBedEquip($p(%d(0),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = ICUBED_ChildSub ];

/// ICUBED_ComOrd_Dr
Property ICUBEDComOrdDr As User.DHCICUCRecordItem [ SqlColumnNumber = 3, SqlFieldName = ICUBED_ComOrd_Dr ];

/// ICUBED_Active
Property ICUBEDActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ICUBED_Active ];

/// ICUBED_ChannelNo
Property ICUBEDChannelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ICUBED_ChannelNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUBED_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUBED_ChannelNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUBED_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCICUBedEquip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_BedEquip.ICUBE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUBED_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_ICU_BedEquip.ICUBE_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUBED_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChannelNo">
<Global>^DHCICUBedEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ICU_BedEquip.ICUBE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ICUBED_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ChannelNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUBED_ChannelNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUBED_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUBED_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUBedEquipDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
