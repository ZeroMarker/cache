Class User.DHCPHCInstrRecLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_PHCInstrRecLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (InstrRecLocParRef, InstrRecLocSub) [ IdKey, PrimaryKey, Unique ];

/// Instr_RecLoc_ParRef
Property InstrRecLocParRef As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Instr_RecLoc_ParRef ];

/// Instr_RecLoc_Sub
Property InstrRecLocSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^PHCIN($p($s($d(initvalue):initvalue,1:1),$c(1)),"RecLoc",0))}, SqlColumnNumber = 3, SqlFieldName = Instr_RecLoc_Sub ];

/// Instr_OrdDep
Property InstrOrdDep As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Instr_OrdDep ];

/// Instr_RecLoc
Property InstrRecLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Instr_RecLoc ];

/// Instr_Default
Property InstrDefault As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Instr_Default ];

/// Instr_OrdSubCat
Property InstrOrdSubCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Instr_OrdSubCat ];

/// Instr_OrdPrior
Property InstrOrdPrior As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Instr_OrdPrior ];

/// Instr_TimeRange
Property InstrTimeRange As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Instr_TimeRange ];

/// Instr_Hospital_DR
Property InstrHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Instr_Hospital_DR ];

/// 只接收化疗药物|TPN药物
Property InstrOnlyChemotherapeuticAndTPN As %Library.String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = Instr_OnlyChemotherapeuticAndTPN ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterMap">
<Data name="Instr_Default">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Instr_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Instr_OnlyChemotherapeuticAndTPN">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Instr_OrdDep">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Instr_OrdPrior">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Instr_OrdSubCat">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Instr_RecLoc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Instr_TimeRange">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PHCIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Instr_RecLoc_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Instr_RecLoc_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Instr_RecLoc_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Instr_RecLoc_Sub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHCInstrRecLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
