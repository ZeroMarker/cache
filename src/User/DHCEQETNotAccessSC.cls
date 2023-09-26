Class User.DHCEQETNotAccessSC Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ENS_RowID, SqlTableName = DHC_EQETNotAccessSC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ENS_EquipTypeDR
Property ENSEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 2, SqlFieldName = ENS_EquipTypeDR ];

/// ENS_StatCatDR
Property ENSStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 3, SqlFieldName = ENS_StatCatDR ];

/// ENS_Remark
Property ENSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ENS_Remark ];

/// ENS_NotAccessFlag
Property ENSNotAccessFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ENS_NotAccessFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQETNotAccessSC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ENS_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ENS_NotAccessFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ENS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ENS_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ENS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQETNotAccessSC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ENS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatCat">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCEQETNotAccessSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"StatCat"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ENS_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ENS_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ENS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQETNotAccessSCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
