/// linshi rukoudan zibiao 
Class User.PHAINStatCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PINSC_RowID, SqlTableName = PHAIN_StatCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PINSCChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPHAINStatDetail As User.PHAINStatDetail [ Cardinality = children, Inverse = PINSDSCParref ];

/// PINSC_ST_Parref
Relationship PINSCSTParref As User.PHAINStatType [ Cardinality = parent, Inverse = ChildPHAINStatCat, Required, SqlFieldName = PINSC_ST_Parref ];

/// PINSC_ChildSub
Property PINSCChildSub As %Library.Integer [ SqlColumnNumber = 2, SqlFieldName = PINSC_ChildSub ];

/// PINSC_Code
Property PINSCCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PINSC_Code ];

/// PINSC_Desc
Property PINSCDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PINSC_Desc ];

/// PINSC_StartDate
Property PINSCStartDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = PINSC_StartDate ];

/// PINSC_EndDate
Property PINSCEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = PINSC_EndDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="CatMASTER">
<Data name="PINSC_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PINSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PINSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PINSC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PINSC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CD.PHA.IN.STAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_StatType.PINST_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PINSC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_StatType.PINST_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PINSC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHAINStatCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
