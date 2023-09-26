/// test
Class User.DHCQTRECTYP Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TYP_ROWID, SqlTableName = DHC_QTRECTYP, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TYP_CODE
Property TYPCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TYP_CODE ];

/// TYP_DESC
Property TYPDESC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TYP_DESC ];

/// TYP_TYPE
Property TYPTYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TYP_TYPE ];

/// TYP_TYPE_CODE
Property TYPTYPECODE As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TYP_TYPE_CODE ];

/// HOSPITAL
Property TYPHOSPITAL As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TYP_HOSPITAL ];

/// 医嘱项
Property orderItems As %String [ SqlColumnNumber = 7, SqlFieldName = orderItems ];

/// 医嘱子类
Property orderCats As %String [ SqlColumnNumber = 8, SqlFieldName = orderCats ];

/// 是否允许编辑
Property editFlag As %String [ SqlColumnNumber = 9, SqlFieldName = editFlag ];

/// 启用
Property enableFlag As %String [ SqlColumnNumber = 10, SqlFieldName = enableFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^mdata("DHCQTRECTYP"))</SqlIdExpression>
<SQLMap name="DATAMASTER">
<Data name="TYP_CODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TYP_DESC">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TYP_HOSPITAL">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TYP_TYPE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TYP_TYPE_CODE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="editFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="enableFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="orderCats">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="orderItems">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCQTRECTYP</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TYP_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"typ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TYP_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^DHCQTRECTYP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>TYP_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TYP_HOSPITAL}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TYP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospTYPEDESC">
<Global>^DHCQTRECTYP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TYP_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HOSPTYPDESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TYP_HOSPITAL}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TYP_DESC}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TYP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTYPEDESC">
<Global>^DHCQTRECTYP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L3</Expression>
<Field>TYP_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TYPDESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TYP_DESC}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TYP_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCQTRECTYPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
