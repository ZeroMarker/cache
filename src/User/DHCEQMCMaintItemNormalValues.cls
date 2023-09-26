Class User.DHCEQMCMaintItemNormalValues Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MINV_RowID, SqlTableName = DHC_EQMCMaintItemNormalValues, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MINV_MaintItemDR
Property MINVMaintItemDR As User.DHCEQCMaintItem [ SqlColumnNumber = 2, SqlFieldName = MINV_MaintItemDR ];

/// MINV_ValueType
Property MINVValueType As %Library.String(DISPLAYLIST = ",绝对值,差值数值,差值百分比,指定值", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 3, SqlFieldName = MINV_ValueType ];

/// MINV_AllFlag
Property MINVAllFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MINV_AllFlag ];

/// MINV_NormalValue
Property MINVNormalValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MINV_NormalValue ];

/// MINV_MinValue
Property MINVMinValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MINV_MinValue ];

/// MINV_MaxValue
Property MINVMaxValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MINV_MaxValue ];

/// MINV_ItemFactorKey
Property MINVItemFactorKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MINV_ItemFactorKey ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQMCMaintItemNormalValues",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MINV_AllFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MINV_ItemFactorKey">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MINV_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MINV_MaxValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MINV_MinValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MINV_NormalValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MINV_ValueType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MINV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQMCMaintItemNormalValues"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{MINV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexMaintItemDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MINV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQMCMaintItemNormalValues"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MaintItemDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MINV_MaintItemDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MINV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMCMaintItemNormalValuesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
