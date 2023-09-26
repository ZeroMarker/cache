Class User.DHCEQEquipAttributeList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EAL_RowID, SqlTableName = DHC_EQEquipAttributeList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EAL_InvalidFlag
Property EALInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = EAL_InvalidFlag ];

/// EAL_EquipAttributeDR
Property EALEquipAttributeDR As User.DHCEQCEquipAttribute [ SqlColumnNumber = 2, SqlFieldName = EAL_EquipAttributeDR ];

/// EAL_SourceType
Property EALSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EAL_SourceType ];

/// EAL_SourceID
Property EALSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EAL_SourceID ];

/// EAL_SubInfo
Property EALSubInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EAL_SubInfo ];

/// EAL_Remark
Property EALRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EAL_Remark ];

/// EAL_Hold1
Property EALHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EAL_Hold1 ];

/// EAL_Hold2
Property EALHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EAL_Hold2 ];

/// EAL_Hold3
Property EALHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EAL_Hold3 ];

/// EAL_Hold4
Property EALHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EAL_Hold4 ];

/// EAL_Hold5
Property EALHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EAL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipAttributeList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EAL_EquipAttributeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EAL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EAL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EAL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EAL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EAL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EAL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EAL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EAL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EAL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EAL_SubInfo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQEquipAttributeList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{EAL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAttributeSource">
<Global>^DHCEQEquipAttributeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AttributeSource"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EAL_EquipAttributeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAL_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EAL_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipAttribute">
<Global>^DHCEQEquipAttributeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipAttribute"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EAL_EquipAttributeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceAttribute">
<Global>^DHCEQEquipAttributeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceAttribute"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EAL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EAL_EquipAttributeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQEquipAttributeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EAL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubInfo">
<Global>^DHCEQEquipAttributeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SubInfo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EAL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EAL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EAL_SubInfo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipAttributeListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
