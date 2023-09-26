Class User.DHCEQCPromptInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PI_RowID, SqlTableName = DHC_EQCPromptInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PI_Type
Property PIType As %Library.String(DISPLAYLIST = ",系统,自定义", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 2, SqlFieldName = PI_Type ];

/// PI_Source
Property PISource As %Library.String(DISPLAYLIST = ",Cache,类业务,类通用,JS业务,JS通用,Tooltip", MAXLEN = 3, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5") [ SqlColumnNumber = 3, SqlFieldName = PI_Source ];

/// PI_DeleteFlag
Property PIDeleteFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PI_DeleteFlag ];

/// PI_Buss
Property PIBuss As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PI_Buss ];

/// PI_Code
Property PICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PI_Code ];

/// PI_Desc
Property PIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PI_Desc ];

/// PI_UpdateFlag
Property PIUpdateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PI_UpdateFlag ];

/// PI_System
Property PISystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PI_System ];

/// PI_Remark
Property PIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PI_Remark ];

/// PI_Hold1
Property PIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PI_Hold1 ];

/// PI_Hold2
Property PIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PI_Hold2 ];

/// PI_Hold3
Property PIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PI_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCPromptInfo",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PI_Buss">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PI_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PI_DeleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PI_Source">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PI_System">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PI_UpdateFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCPromptInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCPromptInfo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCPromptInfo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PI_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PI_Source}</Expression>
</Subscript>
<Subscript name="6">
<Expression>" "_{PI_Buss}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCPromptInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
