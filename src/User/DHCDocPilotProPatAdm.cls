Class User.DHCDocPilotProPatAdm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPPA_RowId, SqlTableName = DHC_DocPilotProPatAdm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPPAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProPat Parent Reference
Relationship PPPAPPPParRef As User.DHCDocPilotProPat [ Cardinality = parent, Inverse = ChildDHCDocPilotProPatAdm, Required, SqlFieldName = PPPA_PPP_ParRef ];

/// PPPA_ChildSub
Property PPPAChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPPA($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),0))}, SqlColumnNumber = 2, SqlFieldName = PPPA_ChildSub ];

/// PPPA_Adm_Dr
Property PPPAAdmDr As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PPPA_Adm_Dr ];

/// PPPA_Loc_Dr
Property PPPALocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PPPA_Loc_Dr ];

/// PPPA_Doc_Dr
Property PPPADocDr As User.CTCareProv [ SqlColumnNumber = 5, SqlFieldName = PPPA_Doc_Dr ];

/// PPPA_ActiveFlag
Property PPPAActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PPPA_ActiveFlag ];

/// PPPA_DateAdd
Property PPPADateAdd As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PPPA_DateAdd ];

/// PPPA_TimeAdd
Property PPPATimeAdd As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PPPA_TimeAdd ];

/// PPPA_Note1
Property PPPANote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PPPA_Note1 ];

/// PPPA_Note2
Property PPPANote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PPPA_Note2 ];

/// PPPA_PPPA_Dr
Property PPPAPPPADr As User.DHCDocPilotProPatAdm [ SqlColumnNumber = 11, SqlFieldName = PPPA_PPPA_Dr ];

/// PPPA_AllFreeFlag 住院费用全部科研 
Property PPPAAllFreeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PPPA_AllFreeFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPPA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPPA_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPPA_AllFreeFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPPA_DateAdd">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPPA_Doc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPPA_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPPA_Note1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPPA_Note2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPPA_PPPA_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPPA_TimeAdd">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDocPPPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_DocPilotProPat.PPP_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>PPPA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_DocPilotProPat.PPP_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPPA_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^DHCDocPPPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_DocPilotProPat.PPP_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PPPA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PPPA_Adm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProPat.PPP_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PPPA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateAdd">
<Global>^DHCDocPPPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_DocPilotProPat.PPP_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PPPA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DateAdd"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PPPA_DateAdd}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProPat.PPP_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PPPA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDr">
<Global>^DHCDocPPPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_DocPilotProPat.PPP_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PPPA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LocDr"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PPPA_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProPat.PPP_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PPPA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProPatAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
