Class User.DHCMedInfectionRepOPR Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRO_Rowid, SqlTableName = DHC_MedInfectionRepOPR, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIROChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfectionRep Parent Reference
Relationship MIROParRef As User.DHCMedInfectionRep [ Cardinality = parent, Inverse = ChildDHCMedInfectionRepOPR, Required, SqlFieldName = MIRO_ParRef ];

/// Child subscript
Property MIROChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),$c(1),1),"O",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRO_ChildSub ];

/// MIRO_OperationDesc
Property MIROOperationDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIRO_OperationDesc ];

/// MIRO_EmerOprFlag
Property MIROEmerOprFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MIRO_EmerOprFlag ];

/// MIRO_DateFrom
Property MIRODateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MIRO_DateFrom ];

/// MIRO_TimeFrom
Property MIROTimeFrom As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = MIRO_TimeFrom ];

/// MIRO_DateTo
Property MIRODateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MIRO_DateTo ];

/// MIRO_TimeTo
Property MIROTimeTo As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MIRO_TimeTo ];

/// MIRO_OprDoc
Property MIROOprDoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = MIRO_OprDoc ];

/// MIRO_Anaesthesia
Property MIROAnaesthesia As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MIRO_Anaesthesia ];

/// MIRO_CuteType
Property MIROCuteType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MIRO_CuteType ];

/// MIRO_Concrescence
Property MIROConcrescence As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MIRO_Concrescence ];

/// MIRO_CuteInfFlag
Property MIROCuteInfFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = MIRO_CuteInfFlag ];

/// MIRO_OprCuteType
Property MIROOprCuteType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MIRO_OprCuteType ];

/// MIRO_InfectionFlag
Property MIROInfectionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = MIRO_InfectionFlag ];

/// MIRO_OEORI_DR
Property MIROOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MIRO_OEORI_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRO_Anaesthesia">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MIRO_Concrescence">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MIRO_CuteInfFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MIRO_CuteType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MIRO_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIRO_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIRO_EmerOprFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIRO_InfectionFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MIRO_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MIRO_OperationDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIRO_OprCuteType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MIRO_OprDoc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MIRO_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIRO_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMedIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfectionRep.MIR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIRO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfectionRep.MIR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIRO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionRepOPRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
