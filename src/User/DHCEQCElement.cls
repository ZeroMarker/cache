Class User.DHCEQCElement Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = E_RowID, SqlTableName = DHC_EQCElement, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// E_ElementCatDR
Property EElementCatDR As User.DHCEQCElementCat [ SqlColumnNumber = 2, SqlFieldName = E_ElementCatDR ];

/// E_Name
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = E_Name ];

/// E_Note
Property ENote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = E_Note ];

/// E_ValueType
Property EValueType As %Library.String(DISPLAYLIST = ",文本,日期,时间,选择,指向,布尔,整数,浮点,百分数,大文本", MAXLEN = 4, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5,6,7,8,9") [ SqlColumnNumber = 5, SqlFieldName = E_ValueType ];

/// E_Reference
Property EReference As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = E_Reference ];

/// E_Qualitative
Property EQualitative As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = E_Qualitative ];

/// E_SettingFlag
Property ESettingFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = E_SettingFlag ];

/// E_CompositeFlag
Property ECompositeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = E_CompositeFlag ];

/// E_GroupDR
Property EGroupDR As User.DHCEQCElementCat [ SqlColumnNumber = 10, SqlFieldName = E_GroupDR ];

/// E_Remark
Property ERemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = E_Remark ];

/// E_InvalidFlag
Property EInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = E_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCElement",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="E_CompositeFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="E_ElementCatDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="E_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="E_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="E_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="E_Note">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="E_Qualitative">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="E_Reference">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="E_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="E_SettingFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="E_ValueType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCElement"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{E_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexElementCatDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCElement"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ElementCatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{E_ElementCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCElementS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
