/// Description:  药学代码外部数据类型
Class User.DHCDocCTExtDataType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CTEDT_Rowid, SqlTableName = DHCDoc_CT_ExtDataType, StorageStrategy = SQLStorage ]
{

/// CTEDT_Code
Property CTEDTCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = CTEDT_Code ];

/// CTEDT_Desc
Property CTEDTDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = CTEDT_Desc ];

/// CTEDT_ClassName
Property CTEDTClassName As %Library.String [ SqlColumnNumber = 4, SqlFieldName = CTEDT_ClassName ];

/// CTEDT_QueryName
Property CTEDTQueryName As %Library.String [ SqlColumnNumber = 5, SqlFieldName = CTEDT_QueryName ];

/// CTEDT_Active
Property CTEDTActive As %Library.String [ SqlColumnNumber = 6, SqlFieldName = CTEDT_Active ];

/// CTEDT_Active
Property CTEDTTable As %Library.String [ SqlColumnNumber = 7, SqlFieldName = CTEDT_Table ];

/// CTEDT_Active
Property CTEDTTableCode As %Library.String [ SqlColumnNumber = 8, SqlFieldName = CTEDT_TableCode ];

/// CTEDT_Active
Property CTEDTTableDesc As %Library.String [ SqlColumnNumber = 9, SqlFieldName = CTEDT_TableDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDOCCTEDT("CTEDT"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CTEDT_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTEDT_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTEDT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTEDT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTEDT_QueryName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTEDT_Table">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTEDT_TableCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTEDT_TableDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCDOCCTEDT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTEDT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CTEDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CTEDT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDOCCTEDTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CTEDT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CTEDTCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CTEDT_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTEDT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocCTExtDataTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
