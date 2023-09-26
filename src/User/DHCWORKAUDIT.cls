Class User.DHCWORKAUDIT Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WORKAUDIT_Rowid, SqlTableName = DHC_WORKAUDIT, StorageStrategy = SQLStorage ]
{

Property WORKAUDITDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 2, SqlFieldName = WORKAUDIT_Date ];

Property WORKAUDITTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = WORKAUDIT_Time ];

Property WORKAUDITType As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WORKAUDIT_Type ];

Property WORKAUDITPoint As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WORKAUDIT_Point ];

Property WORKAUDITUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = WORKAUDIT_User ];

Property WORKAUDITLevel As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = WORKAUDIT_Level ];

Property WORKAUDITFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = WORKAUDIT_Flag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCWORKAUDIT)</SqlIdExpression>
<SQLMap name="DataMasterDHCWAUDIT">
<Data name="WORKAUDIT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WORKAUDIT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WORKAUDIT_Level">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WORKAUDIT_Point">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WORKAUDIT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WORKAUDIT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WORKAUDIT_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWORKAUDIT</Global>
<Subscript name="1">
<Expression>{WORKAUDIT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCWORKAUDIT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WORKAUDIT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WORKAUDIT_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WORKAUDIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCWORKAUDIT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WORKAUDIT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WORKAUDIT_Point}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WORKAUDIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWORKAUDITS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
