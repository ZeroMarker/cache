Class User.DHCPMComRecord Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CR_RowId, SqlTableName = DHC_PMComRecord, StorageStrategy = SQLStoragre ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PMCChildSub [ IdKey, PrimaryKey, Unique ];

/// User.PMPImprovementDetail Parent Reference
Relationship PMDeParRef As PMPImprovementDetail [ Cardinality = parent, Inverse = ChildDHCPMComRecord, Required, SqlFieldName = PM_De_ParRef ];

/// PMCChildSub
Property PMCChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^PMPImprovementDetail(+%d(0),$p($p(%d(0),$c(1)),"||",2),0))}, Required, SqlColumnNumber = 2, SqlFieldName = CR_ChildSub ];

/// CR_Note
Property CRNote As %Library.String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CR_Note ];

/// CRUpdate
Property CRUpdate As %Library.String [ SqlColumnNumber = 4, SqlFieldName = CR_Update ];

/// CRUpTime
Property CRUpTime As %Library.String [ SqlColumnNumber = 5, SqlFieldName = CR_UpTime ];

/// CRCreater
Property CRCreater As %Library.String [ SqlColumnNumber = 6, SqlFieldName = CR_Creater ];

/// CRComDR
Property CRComDR As %Library.String [ SqlColumnNumber = 7, SqlFieldName = CR_Com_DR ];

/// CRPrjectUserDR
Property CRPrjectUserDR As %Library.String [ SqlColumnNumber = 8, SqlFieldName = CR_Prject_UserDR ];

/// CRHosUserDR
Property CRHosUserDR As %Library.String [ SqlColumnNumber = 9, SqlFieldName = CR_Hos_UserDR ];

/// CR_Duration
Property CRDuration As %Library.String [ SqlColumnNumber = 10, SqlFieldName = CR_Duration ];

/// CRLocation
Property CRLocation As %Library.String [ SqlColumnNumber = 11, SqlFieldName = CR_Location ];

/// CRComdate
Property CRComdate As %Library.String [ SqlColumnNumber = 12, SqlFieldName = CR_Comdate ];

/// CRComTime
Property CRComTime As %Library.String [ SqlColumnNumber = 13, SqlFieldName = CR_ComTime ];

/// extStr1
Property extStr1 As %Library.String [ SqlColumnNumber = 14, SqlFieldName = extStr1 ];

/// extStr2
Property extStr2 As %Library.String [ SqlColumnNumber = 15, SqlFieldName = extStr2 ];

/// extStr3
Property extStr3 As %Library.String [ SqlColumnNumber = 16, SqlFieldName = extStr3 ];

/// extStr4
Property extStr4 As %Library.String [ SqlColumnNumber = 17, SqlFieldName = extStr4 ];

Storage SQLStoragre
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CR_ComTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CR_Com_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CR_Comdate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CR_Creater">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CR_Duration">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CR_Hos_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CR_Location">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CR_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CR_Prject_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CR_UpTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CR_Update">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="extStr1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="extStr2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="extStr3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="extStr4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCPMComRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_ImprovementList.IPML_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PMP_ImprovementDetail.IPMD_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>CR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementDetail.IPMD_Childsub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="commDateIndex">
<Global>^DHCPMComRecordi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PMP_ImprovementList.IPML_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PMP_ImprovementDetail.IPMD_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>CR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"commDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CR_Comdate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMP_ImprovementDetail.IPMD_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPMComRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
