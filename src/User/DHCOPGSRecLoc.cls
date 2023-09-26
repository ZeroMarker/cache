Class User.DHCOPGSRecLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RL_RowID, SqlTableName = DHC_OPGSRecLoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RLSub [ IdKey, PrimaryKey, Unique ];

/// DHC_OPGroupSettings Parent Reference
Relationship GSRLParRef As User.DHCOPGroupSettings [ Cardinality = parent, Inverse = ChildDHCOPGSRecLoc, Required, SqlFieldName = GS_RL_ParRef ];

/// PM_Sub
Property RLSub As %Library.Float [ InitialExpression = {$i(^DHCOPGS("GS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"RL",0))}, SqlColumnNumber = 2, SqlFieldName = RL_Sub ];

/// RL_RecLoc_DR
Property RLRecLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = RL_RecLoc_DR ];

/// RL_DateFrom
Property RLDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = RL_DateFrom ];

/// RL_DateTo
Property RLDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = RL_DateTo ];

///  RL_ActiveFlag
Property RLActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RL_ActiveFlag ];

/// RL_LoadLoc_DR
Property RLLoadLocDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = RL_LoadLoc_DR ];

/// RL_Note1
Property RLNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RL_Note1 ];

/// RL_Note2
Property RLNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RL_Note2 ];

/// RL_Note3
Property RLNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RL_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMap">
<Data name="RL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RL_LoadLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RL_Note1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RL_Note2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RL_Note3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RL_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOPGS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_OPGroupSettings.GS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RL_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_OPGroupSettings.GS_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"RL"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RL_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoadLoc">
<Global>^DHCOPGSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_OPGroupSettings.GS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RL_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"LRDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RL_LoadLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_OPGroupSettings.GS_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"RL"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{RL_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPGSRecLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
