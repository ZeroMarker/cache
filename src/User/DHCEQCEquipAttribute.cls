Class User.DHCEQCEquipAttribute Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCEquipAttribute, StorageStrategy = SQLStorage ]
{

/// EA_Code
Property EACode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EA_Code ];

/// EA_Name
Property EAName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EA_Name ];

/// EA_Group
Property EAGroup As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EA_Group ];

/// EA_Remark
Property EARemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EA_Remark ];

/// EA_InvalidFlag
Property EAInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = EA_InvalidFlag ];

/// EA_Hold1
Property EAHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EA_Hold1 ];

/// EA_Hold2
Property EAHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EA_Hold2 ];

/// EA_Hold3
Property EAHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EA_Hold3 ];

/// EA_Hold4
Property EAHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EA_Hold4 ];

/// EA_Hold5
Property EAHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EA_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCEquipAttribute",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EA_Group">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EA_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCEquipAttribute"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{EA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCEquipAttribute"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EA_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCEQCEquipAttribute"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EA_Group}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EA_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCEquipAttributeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
