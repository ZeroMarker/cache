Class User.DHCEQCGroupSysType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GST_RowID, SqlTableName = DHC_EQCGroupSysType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GST_GroupDR
Property GSTGroupDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = GST_GroupDR ];

/// GST_SysTypeDR
Property GSTSysTypeDR As User.DHCEQCSysType [ SqlColumnNumber = 3, SqlFieldName = GST_SysTypeDR ];

/// GST_Hold1
Property GSTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GST_Hold1 ];

/// GST_Hold2
Property GSTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GST_Hold2 ];

/// GST_Hold3
Property GSTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = GST_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupSysType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GST_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GST_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GST_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GST_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GST_SysTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GST_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupSysType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GST_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroupDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GST_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupSysType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"GroupDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GST_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GST_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupSysTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
