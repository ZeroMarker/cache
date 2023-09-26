Class User.DHCPEPreGTOrdItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGTOI_RowId, SqlTableName = DHC_PE_PreGTOrdItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PGTOIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_PreGTeam Parent Reference
Relationship PGTOIParRef As User.DHCPEPreGTeam [ Cardinality = parent, Inverse = ChildDHCPEPreGTOrdItem, Required, SqlFieldName = PGTOI_ParRef ];

Relationship ChildDHCPEPreGTOrdItemTarItem As User.DHCPEPreGTOrdItemTarItem [ Cardinality = children, Inverse = PGTOITParRef ];

/// PGTOI_ChildSub
Property PGTOIChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreGADM(+%d(0),"Team",$p($p(%d(0),$c(1)),"||",2),"ORDITEM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PGTOI_ChildSub ];

/// PGTOI_ItmMast_DR
Property PGTOIItmMastDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PGTOI_ItmMast_DR ];

/// PGTOI_OrdEnt_DR
Property PGTOIOrdEntDR As User.DHCPEPreGTOrdEnt [ SqlColumnNumber = 4, SqlFieldName = PGTOI_OrdEnt_DR ];

/// PGTOI_ARCOS_DR
Property PGTOIARCOSDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PGTOI_ARCOS_DR ];

/// PGTOI_FactAmount
Property PGTOIFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 6, SqlFieldName = PGTOI_FactAmount ];

/// PGTOI_PrivilegeMode
Property PGTOIPrivilegeMode As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PGTOI_PrivilegeMode ];

/// PGTOI_Privilege
Property PGTOIPrivilege As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PGTOI_Privilege ];

/// PGTOI_AsCharged
Property PGTOIAsCharged As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PGTOI_AsCharged ];

/// PGTOI_UpdateUser_DR
Property PGTOIUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PGTOI_UpdateUser_DR ];

/// PGTOI_UpdateDate
Property PGTOIUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 11, SqlFieldName = PGTOI_UpdateDate ];

/// PGTOI_UpdateTime
Property PGTOIUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PGTOI_UpdateTime ];

/// PGTOI_AccountAmount
Property PGTOIAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 13, SqlFieldName = PGTOI_AccountAmount ];

/// PGTOI_PAudit_DR
Property PGTOIPAuditDR As User.DHCPEPreAudit [ SqlColumnNumber = 14, SqlFieldName = PGTOI_PAudit_DR ];

/// PGTOI_ItemStat
Property PGTOIItemStat As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PGTOI_ItemStat ];

/// PGTOI_ItemRecLoc_DR
Property PGTOIItemRecLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PGTOI_ItemRecLoc_DR ];

/// 【新加】科室站点项目扩展表ID（注：科室站点项目扩展表->站点项目组合表【医嘱项ID】与本表中【PGTOIItmMastDR】字段对应）
Property PGTOISTOrderSetDR As User.DHCPEStationOrderSet [ SqlColumnNumber = 17, SqlFieldName = PGTOI_STOrderSetDR ];

/// 【新加】体检项目开单科室 指向CT_Loc
Property PGTOIOrderLocDR As %String [ SqlColumnNumber = 18, SqlFieldName = PGTOI_OrderLocDR ];

/// PGTOI_CurAccountAmount  当前收费项对应的项目金额
Property PGTOICurAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 19, SqlFieldName = PGTOI_CurAccountAmount ];

/// PGTOI_Type(公费/自费)
Property PGTOIType As %Library.String(DISPLAYLIST = ",PreReg,AddOrder", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",PRE,ADD") [ SqlColumnNumber = 20, SqlFieldName = PGTOI_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreGADM">
<Data name="PGTOI_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGTOI_AccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PGTOI_AsCharged">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PGTOI_CurAccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PGTOI_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PGTOI_ItemRecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PGTOI_ItemStat">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PGTOI_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGTOI_OrdEnt_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGTOI_OrderLocDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PGTOI_PAudit_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PGTOI_Privilege">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PGTOI_PrivilegeMode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGTOI_STOrderSetDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PGTOI_Type">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PGTOI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PGTOI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PGTOI_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
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
<Field>PGTOI_ChildSub</Field>
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
<Expression>"ORDITEM"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PGTOI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdEnt">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreGADM.PGADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PE_PreGTeam.PGT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PGTOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrdEnt"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PGTOI_OrdEnt_DR}</Expression>
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
<Expression>{PGTOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPGTOIPAudit">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreGADM.PGADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PE_PreGTeam.PGT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PGTOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PGTOIPAudit"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PGTOI_PAudit_DR}</Expression>
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
<Expression>{PGTOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreGTOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
