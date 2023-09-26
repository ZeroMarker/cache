Class User.DHCPEPreGTOrdEnt Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGTOE_RowId, SqlTableName = DHC_PE_PreGTOrdEnt, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreGTOrdEnt";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PGTOEChildSub [ IdKey, PrimaryKey, Unique ];

/// PGTOE_AccountAmount
Property PGTOEAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 8, SqlFieldName = PGTOE_AccountAmount ];

/// PGTOE_ChildSub
Property PGTOEChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreGADM(+%d(0),"Team",$p($p(%d(0),$c(1)),"||",2),"ORDENT",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PGTOE_ChildSub ];

/// PGTOE_FactAmount
Property PGTOEFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 7, SqlFieldName = PGTOE_FactAmount ];

/// PGTOE_ItemStat
Property PGTOEItemStat As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PGTOE_ItemStat ];

/// PGTOE_OrderSets_DR
Property PGTOEOrderSetsDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PGTOE_OrderSets_DR ];

/// DHC_PE_PreGTeam Parent Reference
Relationship PGTOEParRef As User.DHCPEPreGTeam [ Cardinality = parent, Inverse = ChildDHCPEPreGTOrdEnt, Required, SqlFieldName = PGTOE_ParRef ];

/// PGTOE_UpdateDate
Property PGTOEUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = PGTOE_UpdateDate ];

/// PGTOE_UpdateTime
Property PGTOEUpdateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PGTOE_UpdateTime ];

/// PGTOE_UpdateUser_DR
Property PGTOEUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PGTOE_UpdateUser_DR ];

/// 【新加】体检医嘱套扩展表ID（注：体检医嘱套扩展表【医嘱套ID】与本表中【PGTOEOrderSetsDR】字段对应）
Property PGTOESTOrdSetsExDR As User.DHCPEOrdSetsEx [ SqlColumnNumber = 10, SqlFieldName = PGTOE_STOrdSetsExDR ];

/// 【新加】体检项目开单科室 指向CT_Loc
Property PGTOEOrderLocDR As %String [ SqlColumnNumber = 11, SqlFieldName = PGTOE_OrderLocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreGADM">
<Data name="PGTOE_AccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PGTOE_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGTOE_ItemStat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PGTOE_OrderLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PGTOE_OrderSets_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGTOE_STOrdSetsExDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PGTOE_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGTOE_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PGTOE_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPEPreGADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_PreGADM.PGADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PE_PreGTeam.PGT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PGTOE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreGADM.PGADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Team"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreGTeam.PGT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"ORDENT"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PGTOE_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrderSets">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreGADM.PGADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_PE_PreGTeam.PGT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PGTOE_ChildSub</Field>
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
<Expression>{PGTOE_OrderSets_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreGADM.PGADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreGTeam.PGT_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PGTOE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreGTOrdEntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
