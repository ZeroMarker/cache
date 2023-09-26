Class User.DHCEQCEmployeeType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ET_RowID, SqlTableName = DHC_EQCEmployeeType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ET_Code
Property ETCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ET_Code ];

/// ET_Desc
Property ETDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ET_Desc ];

/// ET_Remark
Property ETRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ET_Remark ];

/// ET_InvalidFlag
Property ETInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ET_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCEmployeeType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ET_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ET_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ET_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ET_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ET_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCEmployeeType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ET_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCEmployeeTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
