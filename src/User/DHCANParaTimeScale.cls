/// DHC_AN_ParaTimeScale
Class User.DHCANParaTimeScale Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANPT_RowId, SqlTableName = DHC_AN_ParaTimeScale, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ANPTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_Para Parent Reference
Relationship ANPTParref As User.DHCANPara [ Cardinality = parent, Inverse = ChildDHCANParaTimeScale, Required, SqlFieldName = ANPT_Parref ];

///  For P8
/// ANPT_ChildSub
Property ANPTChildSub As %Library.Float [ InitialExpression = {$i(^DHCANPara($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"T",0))}, SqlColumnNumber = 2, SqlFieldName = ANPT_ChildSub ];

/// ANPT_Date
Property ANPTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ANPT_Date ];

/// ANPT_Time
Property ANPTTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = ANPT_Time ];

/// ANPT_Scale
Property ANPTScale As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ANPT_Scale ];

/// ANPT_UpdateUser
Property ANPTUpdateUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ANPT_UpdateUser ];

/// ANPT_UpdateDate
Property ANPTUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ANPT_UpdateDate ];

/// ANPT_UpdateTime
Property ANPTUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = ANPT_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANPT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANPT_Scale">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANPT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANPT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANPT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANPT_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCANPara</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_Para.ANP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ANPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_Para.ANP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"T"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANPT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANParaTimeScaleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
