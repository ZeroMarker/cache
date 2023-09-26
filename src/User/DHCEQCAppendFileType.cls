Class User.DHCEQCAppendFileType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AFT_RowID, SqlTableName = DHC_EQCAppendFileType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AFT_Code
Property AFTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AFT_Code ];

/// AFT_Desc
Property AFTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AFT_Desc ];

/// AFT_Remark
Property AFTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AFT_Remark ];

/// AFT_InvalidFlag
Property AFTInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AFT_Invalidflag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCAppendFileType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AFT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AFT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AFT_Invalidflag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AFT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCAppendFileType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{AFT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCAppendFileTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
