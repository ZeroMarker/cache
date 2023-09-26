Class User.DHCEQMCMaintItemValues Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIV_RowID, SqlTableName = DHC_EQMCMaintItemValues, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MIV_MaintItemDR
Property MIVMaintItemDR As User.DHCEQCMaintItem [ SqlColumnNumber = 2, SqlFieldName = MIV_MaintItemDR ];

/// MIV_Value
Property MIVValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIV_Value ];

/// MIV_Desc
Property MIVDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIV_Desc ];

/// MIV_NormalType
Property MIVNormalType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIV_NormalType ];

/// MIV_InvalidFlag
Property MIVInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = MIV_InvalidFlag ];

/// MIV_Remark
Property MIVRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MIV_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQMCMaintItemValues",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MIV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIV_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIV_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIV_NormalType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIV_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIV_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MIV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQMCMaintItemValues"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{MIV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexMaintItemDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MIV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQMCMaintItemValues"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MaintItemDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MIV_MaintItemDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMCMaintItemValuesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
