Class User.DHCPhaReturn Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHAR_Rowid, SqlTableName = DHC_PhaReturn, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPhaReturnItm As User.DHCPhaReturnItm [ Cardinality = children, Inverse = PHARIPHARParref ];

/// PHAR_Date
Property PHARDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHAR_Date ];

/// PHAR_Time
Property PHARTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHAR_Time ];

/// PHAR_SSUSR_DR
Property PHARSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHAR_SSUSR_DR ];

/// PHAR_RETRQ_DR 
Property PHARRETRQDR As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHAR_RETRQ_DR ];

/// PHAR_RecLoc_DR
Property PHARRecLocDR As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = PHAR_RecLoc_DR ];

/// PHAR_DeptLoc_DR
Property PHARDeptLocDR As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = PHAR_DeptLoc_DR ];

/// PHAR_RetNo
Property PHARRetNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHAR_RetNo ];

/// PHAR_AckStatus
Property PHARAckStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 18, SqlFieldName = PHAR_AckStatus ];

/// PHAR_AckDate
Property PHARAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = PHAR_AckDate ];

/// PHAR_AckTime
Property PHARAckTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = PHAR_AckTime ];

/// PHAR_AckUser
Property PHARAckUser As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = PHAR_AckUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHARET)</SqlIdExpression>
<SQLMap name="DataMasterPhaReturn">
<Data name="PHAR_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHAR_AckStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHAR_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHAR_AckUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHAR_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHAR_DeptLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHAR_RETRQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAR_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHAR_RetNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHAR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHAR_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHARET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHAR_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRecLoc">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RECLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHAR_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHAR_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRetNo">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHAR_RetNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdate">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHAR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDeptLoc">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DEPTLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHAR_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PHAR_DeptLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHAR_AckStatus}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PHAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexLOCDEPT">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCDEPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAR_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAR_DeptLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaReturnS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
