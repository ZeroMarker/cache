Class User.DHCEQCGroupEquipAttribute Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CEA_RowID, SqlTableName = DHC_EQCGroupEquipAttribute, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CEA_DefaultFlag
Property CEADefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CEA_DefaultFlag ];

/// CEA_EquipAttributeDR
Property CEAEquipAttributeDR As User.DHCEQCEquipAttribute [ SqlColumnNumber = 3, SqlFieldName = CEA_EquipAttributeDR ];

/// CEA_GroupDR
Property CEAGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CEA_GroupDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupEquipAttribute",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CEA_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CEA_EquipAttributeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CEA_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CEA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupEquipAttribute"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CEA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CEA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCGroupEquipAttribute"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CEA_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CEA_EquipAttributeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CEA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupEquipAttributeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
