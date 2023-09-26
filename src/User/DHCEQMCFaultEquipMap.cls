Class User.DHCEQMCFaultEquipMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQMCFaultEquipMap, StorageStrategy = SQLStorage ]
{

/// FEM_MapType modified by WY 2022-9-15 增加故障类型的对照
Property FEMMapType As %String(DISPLAYLIST = ",故障现象,故障原因,故障解决方法,故障类型", MAXLEN = 6, VALUELIST = ",1,2,3,4") [ SqlColumnNumber = 2, SqlFieldName = FEM_MapType ];

/// FEM_FaultID
Property FEMFaultID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FEM_FaultID ];

/// FEM_ESourceType
Property FEMESourceType As %String(DISPLAYLIST = ",设备分类,设备项", MAXLEN = 4, VALUELIST = ",1,2") [ SqlColumnNumber = 4, SqlFieldName = FEM_ESourceType ];

/// FEM_ESourceID
Property FEMESourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FEM_ESourceID ];

/// FEM_EModelDR
Property FEMEModelDR As DHCEQCModel [ SqlColumnNumber = 6, SqlFieldName = FEM_EModelDR ];

/// FEM_EBrandDR
Property FEMEBrandDR As DHCEQCBrand [ SqlColumnNumber = 7, SqlFieldName = FEM_EBrandDR ];

/// FEM_UsedFlag
Property FEMUsedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = FEM_UsedFlag ];

/// FEM_Hold1
Property FEMHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = FEM_Hold1 ];

/// FEM_Hold2
Property FEMHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = FEM_Hold2 ];

/// FEM_Hold3
Property FEMHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = FEM_Hold3 ];

/// FEM_Hold4
Property FEMHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = FEM_Hold4 ];

/// FEM_Hold5
Property FEMHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = FEM_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQMCFaultEquipMap",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FEM_EBrandDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FEM_EModelDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FEM_ESourceID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FEM_ESourceType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FEM_FaultID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FEM_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FEM_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FEM_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FEM_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FEM_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="FEM_MapType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FEM_UsedFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>FEM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCFaultEquipMap"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{FEM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFaultID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>FEM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCFaultEquipMap"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"FaultID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FEM_MapType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FEM_FaultID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{FEM_ESourceType}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{FEM_ESourceID}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{FEM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>FEM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCFaultEquipMap"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FEM_ESourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FEM_ESourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{FEM_MapType}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{FEM_FaultID}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{FEM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FEM_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQMCFaultEquipMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
