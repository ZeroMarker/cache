Class User.DHCEQCTypeDefine Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TD_RowID, SqlTableName = DHC_EQCTypeDefine, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TD_Name
Property TDName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TD_Name ];

/// TD_Value
Property TDValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TD_Value ];

/// TD_Desc
Property TDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TD_Desc ];

/// TD_InvalidFlag
Property TDInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = TD_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCTypeDefine",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TD_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TD_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TD_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCTypeDefine"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{TD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCTypeDefineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
