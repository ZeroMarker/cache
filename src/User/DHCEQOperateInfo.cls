Class User.DHCEQOperateInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OI_RowID, SqlTableName = DHC_EQOperateInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ERL_AccessFlag
Property OISourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OI_SourceType ];

/// ERL_EquipRangeDR
Property OISourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OI_SourceID ];

/// ERL_Type
Property OIOperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = OI_OperateDate ];

/// ERL_Value
Property OIOperateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = OI_OperateTime ];

/// ERL_Value
Property OIOperateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OI_OperateUser ];

/// ERL_Value
Property OIOperateState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OI_OperateState ];

/// ERL_Value
Property OIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OI_Remark ];

/// ERL_Value
Property OIInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OI_InvalidFlag ];

/// ERL_Value
Property OIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = OI_Hold1 ];

/// ERL_Value
Property OIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OI_Hold2 ];

/// ERL_Value
Property OIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OI_Hold3 ];

/// ERL_Value
Property OIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = OI_Hold4 ];

/// ERL_Value
Property OIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = OI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOperateInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OI_OperateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OI_OperateState">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OI_OperateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OI_OperateUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQOperateInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQOperateInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OI_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OI_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOperateInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
