Class User.DHCEQEquipStatus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQEquipStatus, StorageStrategy = SQLStorage ]
{

/// ES_Code
Property ESCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ES_Code ];

/// ES_Desc
Property ESDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ES_Desc ];

/// ES_Remark
Property ESRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ES_Remark ];

/// ES_InvalidFlag
Property ESInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ES_InvalidFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQEquipStatus",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ES_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ES_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ES_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ES_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ES_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQEquipStatus"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ES_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ES_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQEquipStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
