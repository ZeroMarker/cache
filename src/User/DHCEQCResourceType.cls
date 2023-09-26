Class User.DHCEQCResourceType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RT_RowID, SqlTableName = DHC_EQCResourceType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RT_Code
Property RTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RT_Code ];

/// RT_Desc
Property RTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RT_Desc ];

/// RT_ExID
Property RTExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RT_ExID ];

/// RT_ExType
Property RTExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RT_ExType ];

/// RT_InvalidFlag
Property RTInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = RT_InvalidFlag ];

/// RT_Price
Property RTPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RT_Price ];

/// RT_Remark
Property RTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RT_Remark ];

/// RT_Type
Property RTType As %Library.String(DISPLAYLIST = ",固定单价,无固定单价,根据接口获取单价", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",1,2,3") [ SqlColumnNumber = 6, SqlFieldName = RT_Type ];

/// RT_Unit
Property RTUnit As User.CTUOM [ SqlColumnNumber = 8, SqlFieldName = RT_Unit ];

/// RT_FixdFlag
Property RTFixdFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = RT_FixdFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCResourceType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RT_ExID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RT_ExType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RT_FixdFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RT_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RT_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RT_Unit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCResourceType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCResourceTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
