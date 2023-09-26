Class User.DHCMRBed Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// MR_Date
Property MRDate As %Date [ SqlColumnNumber = 2, SqlFieldName = MR_Date ];

/// MR_Loc
Property MRLoc As CTLoc [ SqlColumnNumber = 3, SqlFieldName = MR_Loc ];

/// MR_GDNum
Property MRGDNum As %Float [ SqlColumnNumber = 4, SqlFieldName = MR_GDNum ];

/// MR_SYNum
Property MRSYNum As %Float [ SqlColumnNumber = 5, SqlFieldName = MR_SYNum ];

/// MR_BZNum
Property MRBZNum As %Float [ SqlColumnNumber = 6, SqlFieldName = MR_BZNum ];

/// MR_Ward
Property MRWard As PACWard [ SqlColumnNumber = 7, SqlFieldName = MR_Ward ];

/// MR_Doc
Property MRDoc As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = MR_Doc ];

/// MR_DateTime
Property MRDateTime As %String [ SqlColumnNumber = 9, SqlFieldName = MR_DateTime ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMRBed)</SqlIdExpression>
<SQLMap name="DataMasterDHCMRBed">
<Data name="MR_BZNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MR_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MR_DateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MR_Doc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MR_GDNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MR_Loc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MR_SYNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MR_Ward">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMRBed</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateDoc">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Doc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Loc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateWard">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Ward}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Doc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDate">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Doc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Loc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Loc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Ward}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardDate">
<Global>^DHCMRBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Ward}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRBedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
