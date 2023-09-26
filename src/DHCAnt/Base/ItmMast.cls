Class DHCAnt.Base.ItmMast Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = ItmMast, StorageStrategy = SQLStorage ]
{

/// ANTITM_ARCIMDR 
Property ARCIMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ANTITM_ARCIMDR ];

/// ANTITM_CQMX 是否碳青霉烯
Property CQMX As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = ANTITM_CQMX ];

/// ANTITM_TGC 是否替加环素
Property TGC As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ANTITM_TGC ];

/// ANTITM_LAB 是否送检
Property LAB As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANTITM_LAB ];

/// ANTITM_Hosp 院区
Property Hosp As %Library.String [ SqlColumnNumber = 6, SqlFieldName = ANTITM_Hosp ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.ANT.ItmMastD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANTITM_ARCIMDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANTITM_CQMX">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANTITM_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANTITM_LAB">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANTITM_TGC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.ANT.ItmMastD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxHospArcim">
<Global>^CF.ANT.ItmMastI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospArcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANTITM_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANTITM_ARCIMDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArcim">
<Global>^CF.ANT.ItmMastI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ITM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANTITM_ARCIMDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^DHCAnt.Base.ItmMastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
