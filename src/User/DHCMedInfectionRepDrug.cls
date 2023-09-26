Class User.DHCMedInfectionRepDrug Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRD_Rowid, SqlTableName = DHC_MedInfectionRepDrug, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIRDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfectionRep Parent Reference
Relationship MIRDParRef As User.DHCMedInfectionRep [ Cardinality = parent, Inverse = ChildDHCMedInfectionRepDrug, Required, SqlFieldName = MIRD_ParRef ];

/// Child subscript
Property MIRDChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRD_ChildSub ];

/// MIRD_OEORI_DR
Property MIRDOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MIRD_OEORI_DR ];

/// MIRD_Instr
Property MIRDInstr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIRD_Instr ];

/// MIRD_DateFrom
Property MIRDDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MIRD_DateFrom ];

/// MIRD_DateTo
Property MIRDDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MIRD_DateTo ];

/// MIRD_Days
Property MIRDDays As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = MIRD_Days ];

/// MIRD_Mode
Property MIRDMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MIRD_Mode ];

/// MIRD_Aim
Property MIRDAim As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MIRD_Aim ];

/// MIRD_CureDrugMode
Property MIRDCureDrugMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MIRD_CureDrugMode ];

/// MIRD_PrevDrugMode
Property MIRDPrevDrugMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MIRD_PrevDrugMode ];

/// MIRD_PrevDrugFlag
Property MIRDPrevDrugFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MIRD_PrevDrugFlag ];

/// MIRD_PrevDrugEffect
Property MIRDPrevDrugEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MIRD_PrevDrugEffect ];

/// MIRD_UniteDrug
Property MIRDUniteDrug As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MIRD_UniteDrug ];

/// MIRD_OprDrugFlag
Property MIRDOprDrugFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MIRD_OprDrugFlag ];

/// MIRD_PreDrugTime
Property MIRDPreDrugTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MIRD_PreDrugTime ];

/// MIRD_AftDrugDays
Property MIRDAftDrugDays As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = MIRD_AftDrugDays ];

/// MIRD_RightFlag
Property MIRDRightFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MIRD_RightFlag ];

/// MIRD_Impertinency
Property MIRDImpertinency As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MIRD_Impertinency ];

/// MIRD_Effect
Property MIRDEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MIRD_Effect ];

/// MIRD_Arcim_DR
Property MIRDArcimDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = MIRD_Arcim_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRD_AftDrugDays">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MIRD_Aim">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MIRD_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MIRD_CureDrugMode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MIRD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIRD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIRD_Days">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIRD_Effect">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MIRD_Impertinency">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MIRD_Instr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIRD_Mode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIRD_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIRD_OprDrugFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MIRD_PreDrugTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MIRD_PrevDrugEffect">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MIRD_PrevDrugFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MIRD_PrevDrugMode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MIRD_RightFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MIRD_UniteDrug">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCMedIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfectionRep.MIR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIRD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfectionRep.MIR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIRD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionRepDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
