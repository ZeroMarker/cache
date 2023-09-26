Class User.DHCStkSysAProp Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSAP_RowID, SqlTableName = DHC_StkSysAProp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 500;

Index RowIDBasedIDKeyIndex On SSAPChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCStkSysAPropPref As User.DHCStkSysAPropPref [ Cardinality = children, Inverse = PFSSAPParRef ];

/// DHC_StkSysApp Parent Reference
Relationship SSAPSSAParref As User.DHCStkSysApp [ Cardinality = parent, Inverse = ChildDHCStkSysAProp, Required, SqlFieldName = SSAP_SSA_Parref ];

/// SSAP_ChildSub
Property SSAPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SSAP_ChildSub ];

/// SSAP_Code
Property SSAPCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SSAP_Code ];

/// SSAP_Desc
Property SSAPDesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SSAP_Desc ];

/// SSAP_Value
Property SSAPValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SSAP_Value ];

/// SSAP_Memo
Property SSAPMemo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SSAP_Memo ];

/// SSAP_SSP_Dr
Property SSAPSSPDr As User.DHCStkSysPerview [ SqlColumnNumber = 7, SqlFieldName = SSAP_SSP_Dr ];

/// SSAP_HospLevelFlag  
Property SSAPHospLevelFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = SSAP_HospLevelFlag ];

/// SSAP_DateConfigFlag  
Property SSAPDateConfigFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 9, SqlFieldName = SSAP_DateConfigFlag ];

/// SSAP_TypeList
Property SSAPTypeList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SSAP_TypeList ];

/// SSAP_StartDate
Property SSAPStartDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = SSAP_StartDate ];

/// SSAP_EndDate
Property SSAPEndDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = SSAP_EndDate ];

Storage SQLStorage
{
<ExtentSize>500</ExtentSize>
<SQLMap name="DataMasterSSAP">
<Data name="SSAP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSAP_DateConfigFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SSAP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSAP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SSAP_HospLevelFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSAP_Memo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSAP_SSP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSAP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SSAP_TypeList">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SSAP_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SSAP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSAP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SSAP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SSAP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSAP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SSAP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APDESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SSAP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSAP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPerview">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SSAP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSAP_SSP_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSAP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysAPropS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
