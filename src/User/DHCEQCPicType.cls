Class User.DHCEQCPicType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PT_RowID, SqlTableName = DHC_EQCPicType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BT_Code
Property PTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PT_Code ];

/// BT_Desc
Property PTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PT_Desc ];

/// BT_Remark
Property PTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PT_Reamrk ];

/// BT_InvalidFlag
Property PTInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PT_Invalidflag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCPicType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PT_Invalidflag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PT_Reamrk">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCPicType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCPicTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
