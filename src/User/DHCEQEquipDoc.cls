Class User.DHCEQEquipDoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ED_RowID, SqlTableName = DHC_EQEquipDoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ED_OriginalType
Property EDOriginalType As %Library.String(DISPLAYLIST = ",论证附加资料,合同附加资料,设备附加资料,申请附加资料", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3,4") [ SqlColumnNumber = 2, SqlFieldName = ED_OriginalType ];

/// ED_OriginalID
Property EDOriginalID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ED_OriginalID ];

/// ED_DocName
Property EDDocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ED_DocName ];

/// ED_FileName
Property EDFileName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ED_FileName ];

/// ED_FilePath
Property EDFilePath As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ED_FilePath ];

/// ED_FileType
Property EDFileType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ED_FileType ];

/// ED_Remark
Property EDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ED_Remark ];

/// ED_AddUserDR
Property EDAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ED_AddUserDR ];

/// ED_AddDate
Property EDAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = ED_AddDate ];

/// ED_AddTime
Property EDAddTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = ED_AddTime ];

/// ED_UpdateUserDR
Property EDUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ED_UpdateUserDR ];

/// ED_UpdateDate
Property EDUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = ED_UpdateDate ];

/// ED_UpdateTime
Property EDUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = ED_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipDoc("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ED_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ED_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ED_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ED_DocName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ED_FileName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ED_FilePath">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ED_FileType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ED_OriginalID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ED_OriginalType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ED_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ED_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ED_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ED_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQEquipDoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ED_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ED_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOriginal">
<Global>^DHCEQEquipDoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ED_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Original"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ED_OriginalType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ED_OriginalID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ED_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipDocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
