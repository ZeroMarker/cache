Class User.DHCPEPreIOrdItemFee Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIOIF_RowId, SqlTableName = DHC_PE_PreIOrdItemFee, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIOrdItemFee";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PIOIFChildSub [ IdKey, PrimaryKey, Unique ];

/// PIOIF_AddOrdItem
Property PIOIFAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = PIOIF_AddOrdItem ];

/// PIOIF_ChildSub
Property PIOIFChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreIADM(+%d(0),"ORDITEM",$p($p(%d(0),$c(1)),"||",2),"FEE",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PIOIF_ChildSub ];

/// PIOIF_FactAmount
Property PIOIFFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 4, SqlFieldName = PIOIF_FactAmount ];

/// PIOIF_PAudit_DR
Property PIOIFPAuditDR As User.DHCPEPreAudit [ SqlColumnNumber = 7, SqlFieldName = PIOIF_PAudit_DR ];

/// DHC_PE_PreIOrdItem Parent Reference
Relationship PIOIFParRef As User.DHCPEPreIOrdItem [ Cardinality = parent, Inverse = ChildDHCPEPreIOrdItemFee, Required, SqlFieldName = PIOIF_ParRef ];

/// PIOIF_Privilege
Property PIOIFPrivilege As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PIOIF_Privilege ];

/// PIOIF_PrivilegeMode
Property PIOIFPrivilegeMode As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PIOIF_PrivilegeMode ];

/// PIOIF_UpdateDate
Property PIOIFUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 9, SqlFieldName = PIOIF_UpdateDate ];

/// PIOIF_UpdateTime
Property PIOIFUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PIOIF_UpdateTime ];

/// PIOIF_UpdateUser_DR
Property PIOIFUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PIOIF_UpdateUser_DR ];

/// PIOIF_AccountAmount  记录原价对应得金额
Property PIOIFAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 11, SqlFieldName = PIOIF_AccountAmount ];

/// PIOIF_Rebate  每个项目对应的折扣率
Property PIOIFRebate As %Library.Numeric(SCALE = 4) [ SqlColumnNumber = 12, SqlFieldName = PIOIF_Rebate ];

/// 插入数据以后
Trigger InserAfter [ Event = INSERT, Time = AFTER ]
{
	Set ParRef = {PIOIF_ParRef}
	d ##class(web.DHCPE.PreAudit).InsertItemFactAmount(ParRef)
}

Trigger UpdateAfter [ Event = UPDATE, Time = AFTER ]
{
	Set ParRef = {PIOIF_ParRef}
	d ##class(web.DHCPE.PreAudit).InsertItemFactAmount(ParRef)
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreIADM">
<Data name="PIOIF_AccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIOIF_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIOIF_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIOIF_PAudit_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIOIF_Privilege">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIOIF_PrivilegeMode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIOIF_Rebate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIOIF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIOIF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIOIF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPEPreIADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PE_PreIOrdItem.PIOI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PIOIF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ORDITEM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIOrdItem.PIOI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"FEE"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOIF_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAudit">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PE_PreIOrdItem.PIOI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PIOIF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAORDITEM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOIF_PAudit_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIOrdItem.PIOI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PIOIF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIOrdItemFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
