Class User.DHCEQMExObj Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EO_RowID, SqlTableName = DHC_EQMExObj, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EO_Name
Property EOName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EO_Name ];

/// EO_No
Property EONo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EO_No ];

/// EO_LocDR
Property EOLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EO_LocDR ];

/// EO_ExType
Property EOExType As %Library.String(DISPLAYLIST = ",设备,其他", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,9") [ SqlColumnNumber = 5, SqlFieldName = EO_ExType ];

/// EO_ExID
Property EOExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EO_ExID ];

/// EO_ObjTypeDR
Property EOObjTypeDR As User.DHCEQMCObjType [ SqlColumnNumber = 7, SqlFieldName = EO_ObjTypeDR ];

/// EO_Remark
Property EORemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EO_Remark ];

/// EO_CreateDate
Property EOCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = EO_CreateDate ];

/// EO_CreateUserDR
Property EOCreateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EO_CreateUserDR ];

/// EO_UpdateDate
Property EOUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = EO_UpdateDate ];

/// EO_UpdateUserDR
Property EOUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EO_UpdateUserDR ];

/// EO_DelDate
Property EODelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = EO_DelDate ];

/// EO_DelUserDR
Property EODelUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = EO_DelUserDR ];

/// EO_InValidFlag
Property EOInValidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = EO_InValidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMExObj("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EO_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EO_CreateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EO_DelDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EO_DelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EO_ExID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EO_ExType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EO_InValidFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EO_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EO_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EO_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EO_ObjTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EO_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQMExObj</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EO_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExID">
<Global>^DHCEQMExObj</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EO_ExType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EO_ExID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMExObjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
