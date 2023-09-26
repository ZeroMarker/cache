Class User.DHCPEPreIOrdEnt Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIOE_RowId, SqlTableName = DHC_PE_PreIOrdEnt, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIOrdEnt";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PIOEChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPEPreIOrdEntFee As User.DHCPEPreIOrdEntFee [ Cardinality = children, Inverse = PIOEFParRef ];

/// PIOE_AccountAmount
Property PIOEAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 9, SqlFieldName = PIOE_AccountAmount ];

/// PIOE_ChildSub
Property PIOEChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreIADM($p(%d(0),$c(1),1),"ORDENT",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PIOE_ChildSub ];

/// PIOE_FactAmount
Property PIOEFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 8, SqlFieldName = PIOE_FactAmount ];

/// PIOE_GTOE_DR
Property PIOEGTOEDR As User.DHCPEPreGTOrdEnt [ SqlColumnNumber = 4, SqlFieldName = PIOE_GTOE_DR ];

/// PIOE_ItemStat
Property PIOEItemStat As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PIOE_ItemStat ];

/// PIOE_OrderSets_DR
Property PIOEOrderSetsDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PIOE_OrderSets_DR ];

/// DHC_PE_PreIADM Parent Reference
Relationship PIOEParRef As User.DHCPEPreIADM [ Cardinality = parent, Inverse = ChildDHCPEPreIOrdEnt, Required, SqlFieldName = PIOE_ParRef ];

/// PIOE_Type
Property PIOEType As %Library.String(DISPLAYLIST = ",PreReg,AddOrder", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",PRE,ADD") [ SqlColumnNumber = 10, SqlFieldName = PIOE_Type ];

/// PIOE_UpdateDate
Property PIOEUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = PIOE_UpdateDate ];

/// PIOE_UpdateTime
Property PIOEUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PIOE_UpdateTime ];

/// PIOE_UpdateUser_DR
Property PIOEUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PIOE_UpdateUser_DR ];

/// 【新加】体检医嘱套扩展表ID（注：体检医嘱套扩展表【医嘱套ID】与本表中【PIOEOrderSetsDR】字段对应）
Property PIOESTOrdSetsExDR As User.DHCPEOrdSetsEx [ SqlColumnNumber = 12, SqlFieldName = PIOE_STOrdSetsExDR ];

/// 【新加】体检项目开单科室 指向CT_Loc
Property PIOEOrderLocDR As %String [ SqlColumnNumber = 13, SqlFieldName = PIOE_OrderLocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreIADM">
<Data name="PIOE_AccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIOE_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIOE_GTOE_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIOE_ItemStat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIOE_OrderLocDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PIOE_OrderSets_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIOE_STOrdSetsExDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIOE_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIOE_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIOE_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIOE_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPEPreIADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIOE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ORDENT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOE_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGTOE">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIOE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GTOE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOE_GTOE_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderSets">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIOE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrderSets"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOE_OrderSets_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPIOEPAType">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PIOE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PIOEPAType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIOE_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PIOE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIOrdEntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
