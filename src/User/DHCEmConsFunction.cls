Class User.DHCEmConsFunction Extends %Persistent [ SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsFunction, StorageStrategy = SQLStorage, System = 0 ]
{

/// 代码 ECCode
Property ECCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EC_Code ];

/// 名称 ECName
Property ECName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EC_Name ];

/// 表达式 ECExpress
Property ECExpress As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EC_Express ];

/// 是否可用 ECActiveFlag
Property ECActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = EC_ActiveFlag ];

/// 集团化医院 ECHospDr
Property ECHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = EC_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMCONF)</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCEMCONF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="EC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Express">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EC_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCONF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsFunctionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
