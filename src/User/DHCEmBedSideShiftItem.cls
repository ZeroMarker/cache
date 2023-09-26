Class User.DHCEmBedSideShiftItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmBedSideShiftItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EMChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_EmBedSideShift Parent Reference EM_ParRef_Dr
Relationship EMParRefDr As User.DHCEmBedSideShift [ Cardinality = parent, Inverse = ChildDHCEMBEDSIDESHIFTITEM, Required, SqlFieldName = EM_ParRef_Dr ];

/// EM_ChildSub
Property EMChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = EM_ChildSub ];

/// 就诊ID  EM_Adm_Dr
Property EMAdmDr As User.DHCEmConsDicItem [ SqlColumnNumber = 3, SqlFieldName = EM_Adm_Dr ];

/// 床号  EM_Bed_Dr
Property EMBedDr As %Library.String [ SqlColumnNumber = 4, SqlFieldName = EM_Bed_Dr ];

/// 诊断  EM_PatDiag
Property EMPatDiag As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EM_PatDiag ];

/// 生命体征  EM_VitalSign
Property EMVitalSign As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EM_VitalSign ];

/// 交班内容  EM_Contents
Property EMContents As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EM_Contents ];

/// 备注  EM_Note
Property EMNote As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EM_Note ];

/// 病史  EM_MedHis
Property EMMedHis As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EM_MedHis ];

/// 治疗方式  EM_TreatMet
Property EMTreatMet As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EM_TreatMet ];

/// 联系电话  EM_CotNumber
Property EMCotNumber As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EM_CotNumber ];

/// 建议  EM_Suggest
Property EMSuggest As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EM_Suggest ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="EM_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_Bed_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_Contents">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EM_CotNumber">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EM_MedHis">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EM_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EM_PatDiag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_Suggest">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EM_TreatMet">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EM_VitalSign">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMBSS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmBedSideShift.EM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmBedSideShift.EM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCEMBSS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmBedSideShift.EM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmBedSideShift.EM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmBedSideShiftItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
