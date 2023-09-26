Class User.PMPImprovmentRevList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPRL_Rowid, SqlTableName = PMP_ImprovmentRevList, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IPRLChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PMPImprovementRevListParRef As PMPImprovementList [ Cardinality = parent, Inverse = ChildPMPImprovementRevList, Required, SqlFieldName = PMP_ImprovementRevList_ParRef ];

/// IPRLChildsub
Property IPRLChildsub As %Library.Float [ InitialExpression = {$i(^PMPImprovmentRevList($p(%d(0),$c(1),1),"E",0))}, SqlColumnNumber = 2, SqlFieldName = IPRL_Childsub ];

/// IPRLUser
Property IPRLUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IPRL_User ];

/// IPRLDate
Property IPRLDate As %Date [ SqlColumnNumber = 4, SqlFieldName = IPRL_Date ];

/// IPRLTime
Property IPRLTime As %Time [ SqlColumnNumber = 5, SqlFieldName = IPRL_Time ];

/// IPRLUpdateUser
Property IPRLUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IPRL_UpdateUser ];

/// IPRLType
Property IPRLType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = IPRL_Type ];

/// IPRLMeak
Property IPRLMeak As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IPRL_Meak ];

/// IPRLLoc
Property IPRLLoc As CTLoc [ SqlColumnNumber = 9, SqlFieldName = IPRL_Loc ];

/// IPRLFalg
Property IPRLFalg As %String(DISPLAYLIST = ",医院,项目,其他", MAXLEN = 32, TRUNCATE = 1, VALUELIST = ",HP,PI,OT") [ SqlColumnNumber = 10, SqlFieldName = IPRL_Falg ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPImprovmentRevList(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IPRL_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPRL_Falg">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPRL_Loc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPRL_Meak">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPRL_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPRL_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPRL_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPRL_User">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMP_ImprovementRevList_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPImprovementRevList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_ImprovementList.IPML_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>IPRL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPRL_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPImprovementRevListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRL_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPRL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFalg">
<Global>^PMPImprovementRevListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Falg"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPRL_Falg}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPRL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofLoc">
<Global>^PMPImprovementRevListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRL_Loc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPRL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUpdateUser">
<Global>^PMPImprovementRevListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"UpdateUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRL_UpdateUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPRL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUser">
<Global>^PMPImprovementRevListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPRL_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPRL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPImprovmentRevListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
