Class User.DHCEQImportMonthDepre Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_EQImportMonthDepre, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property EquipNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EquipNo ];

Property OrginalFee As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OrginalFee ];

Property LimitYearsNum As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LimitYearsNum ];

Property DepreMonthsNum As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DepreMonthsNum ];

Property MonthStr As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MonthStr ];

Property DepreTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DepreTotalFee ];

Property DepreFee As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DepreFee ];

Property NetFee As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = NetFee ];

Property DepreDate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DepreDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQImportMonthDepre(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DepreDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DepreFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DepreMonthsNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EquipNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MonthStr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NetFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OrginalFee">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQImportMonthDepre</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQImportMonthDepreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
