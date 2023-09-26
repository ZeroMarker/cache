Class User.PMPModuleDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MODT_Rowid, SqlTableName = PMP_ModuleDetail, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MODTChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PMPModuleParRef As User.PMPModule [ Cardinality = parent, Inverse = ChildPMPModule, Required, SqlFieldName = PMP_Module_ParRef ];

/// MODTChildsub
Property MODTChildsub As %Library.Float [ InitialExpression = {$i(^PMPModuleDetail($p(%d(0),$c(1),1),"M",0))}, SqlColumnNumber = 2, SqlFieldName = MODT_Childsub ];

/// MODTStatusDR
Property MODTStatusDR As PMPDictionary3 [ SqlColumnNumber = 3, SqlFieldName = MODT_Status_DR ];

/// MODTRemark
Property MODTRemark As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MODT_Remark ];

/// MODTDate
Property MODTDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MODT_Date ];

/// MODTTime
Property MODTTime As %Time [ SqlColumnNumber = 6, SqlFieldName = MODT_Time ];

/// MODTUserDR
Property MODTUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MODT_User_DR ];

/// MODTStandby1
Property MODTStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = MODT_Standby1 ];

/// MODTStandby2
Property MODTStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = MODT_Standby2 ];

/// MODTStandby3
Property MODTStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MODT_Standby3 ];

/// MODTStandby4
Property MODTStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = MODT_Standby4 ];

/// MODTStandby5
Property MODTStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = MODT_Standby5 ];

/// MODTStandby6
Property MODTStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = MODT_Standby6 ];

/// MODTStandby7
Property MODTStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = MODT_Standby7 ];

/// MODTStandby8
Property MODTStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = MODT_Standby8 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPModuleDetail(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MODT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MODT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MODT_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MODT_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MODT_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MODT_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MODT_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MODT_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MODT_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MODT_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MODT_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MODT_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MODT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^PMPModuleDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_Module.MODE_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MODT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PMP_Module.MODE_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"M"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MODT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPModuleDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Module.MODE_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MODT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPModuleDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
