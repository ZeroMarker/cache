Class User.DHCPEPreIOrdEntFee Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIOEF_RowId, SqlTableName = DHC_PE_PreIOrdEntFee, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIOrdEntFee";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PIOEFChildSub [ IdKey, PrimaryKey, Unique ];

/// PIOEF_AddOrdItem
Property PIOEFAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = PIOEF_AddOrdItem ];

/// PIOEF_ChildSub
Property PIOEFChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreIADM(+%d(0),"ORDENT",$p($p(%d(0),$c(1)),"||",2),"FEE",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PIOEF_ChildSub ];

/// PIOEF_FactAmount
Property PIOEFFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 4, SqlFieldName = PIOEF_FactAmount ];

/// PIOEF_PAudit_DR
Property PIOEFPAuditDR As User.DHCPEPreAudit [ SqlColumnNumber = 7, SqlFieldName = PIOEF_PAudit_DR ];

/// DHC_PE_PreIOrdEnt Parent Reference
Relationship PIOEFParRef As User.DHCPEPreIOrdEnt [ Cardinality = parent, Inverse = ChildDHCPEPreIOrdEntFee, Required, SqlFieldName = PIOEF_ParRef ];

/// PIOEF_Privilege
Property PIOEFPrivilege As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PIOEF_Privilege ];

/// PIOEF_PrivilegeMode
Property PIOEFPrivilegeMode As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PIOEF_PrivilegeMode ];

/// PIOEF_UpdateDate
Property PIOEFUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 9, SqlFieldName = PIOEF_UpdateDate ];

/// PIOEF_UpdateTime
Property PIOEFUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PIOEF_UpdateTime ];

/// PIOEF_UpdateUser_DR
Property PIOEFUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PIOEF_UpdateUser_DR ];

/// PIOEF_AccountAmount
Property PIOEFAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 11, SqlFieldName = PIOEF_AccountAmount ];

/// 插入数据以后
Trigger InserAfter [ Event = INSERT, Time = AFTER ]
{
	Set ParRef = {PIOEF_ParRef}
	d ##class(web.DHCPE.PreAudit).InsertEntFactAmount(ParRef)
}

Trigger UpdateAfter [ Event = UPDATE, Time = AFTER ]
{
	Set ParRef = {PIOEF_ParRef}
	d ##class(web.DHCPE.PreAudit).InsertEntFactAmount(ParRef)
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreIADM">
<Data name="PIOEF_AccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIOEF_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIOEF_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIOEF_PAudit_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIOEF_Privilege">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIOEF_PrivilegeMode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIOEF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIOEF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIOEF_UpdateUser_DR">
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
<Field>DHC_PE_PreIOrdEnt.PIOE_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PIOEF_ChildSub</Field>
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
<Expression>{DHC_PE_PreIOrdEnt.PIOE_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"FEE"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOEF_ChildSub}</Expression>
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
<Field>DHC_PE_PreIOrdEnt.PIOE_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PIOEF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAORDENT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOEF_PAudit_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIOrdEnt.PIOE_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PIOEF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIOrdEntFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
