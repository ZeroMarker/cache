Class User.DHCPhaLocDisType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLDP_Rowid, SqlTableName = DHC_PhaLocDisType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PLDPChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaLocation Parent Reference
Relationship PLDPPLParref As User.DHCPhaLocation [ Cardinality = parent, Inverse = ChildDHCPhaLocDisType, Required, SqlFieldName = PLDP_PL_Parref ];

/// PLDP_Child
Property PLDPChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PLDP_Childsub ];

/// PLDP_DrugType_DR
Property PLDPDrugTypeDR As User.DHCStkDrugGroup [ SqlColumnNumber = 3, SqlFieldName = PLDP_DrugType_DR ];

/// PLDP_OrdLongFlag
Property PLDPOrdLongFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PLDP_OrdLongFlag ];

/// PLDP_OrdShortFlag
Property PLDPOrdShortFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PLDP_OrdShortFlag ];

/// PLDP_OrdCYDYFlag
Property PLDPOrdCYDYFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PLDP_OrdCYDYFlag ];

/// PLDP_DefaultFlag
Property PLDPDefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PLDP_DefaultFlag ];

/// PLDP_ImPermitReqFlag
Property PLDPImPermitReqFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PLDP_ImPermitReqFlag ];

/// 打印方式
Property PLDPPrintType As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PLDP_PrintType ];

/// 打印序号
Property PLDPPrintIndex As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PLDP_PrintIndex ];

/// 审核标记
Property PLDPAduFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PLDP_AduFlag ];

/// 冲减退药医嘱优先级 
Property PLDPReservePriority As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PLDP_ReservePriority ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PLDP_AduFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PLDP_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PLDP_DrugType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLDP_ImPermitReqFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PLDP_OrdCYDYFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PLDP_OrdLongFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLDP_OrdShortFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLDP_PrintIndex">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PLDP_PrintType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PLDP_ReservePriority">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCPL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaLocation.PL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PLDP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaLocation.PL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DIS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PLDP_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaLocDisTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
