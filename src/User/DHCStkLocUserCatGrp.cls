Class User.DHCStkLocUserCatGrp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = U_RowId, SqlTableName = DHC_StkLocUserCatGrp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On UChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkLocCatGroup Parent Reference
Relationship USLCGParref As User.DHCStkLocCatGroup [ Cardinality = parent, Inverse = ChildDHCStkLocUserCatGrp, Required, SqlFieldName = U_SLCG_Parref ];

/// USLCG_ChildSub
Property UChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = U_ChildSub ];

/// USLCG_SSUSR_DR
Property USSUSRDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = U_SSUSR_DR ];

/// USLCG_Active
Property UActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = U_Active ];

/// U_Default
Property UDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = U_Default ];

/// 类组最高级审核标致
Property UACKFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = U_ACK_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="U_ACK_Flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="U_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="U_Default">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="U_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSLCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkLocCatGroup.SLCG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>U_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkLocCatGroup.SLCG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{U_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCSLCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkLocCatGroup.SLCG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>U_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{U_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_StkLocCatGroup.SLCG_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{U_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkLocUserCatGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
