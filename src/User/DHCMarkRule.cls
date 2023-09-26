Class User.DHCMarkRule Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_MarkRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMarkRuleAdd As DHCMarkRuleAdd [ Cardinality = children, Inverse = MRAMRParref ];

/// MR_Code
Property MRCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MR_Code ];

/// MR_Desc
Property MRDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MR_Desc ];

/// MR_MinRp
Property MRMinRp As %Float [ SqlColumnNumber = 4, SqlFieldName = MR_MinRp ];

/// MR_MaxRp
Property MRMaxRp As %Float [ SqlColumnNumber = 5, SqlFieldName = MR_MaxRp ];

/// MR_Margin
Property MRMargin As %Float [ SqlColumnNumber = 6, SqlFieldName = MR_Margin ];

/// MR_MT_Dr
Property MRMTDr As DHCMarkType [ SqlColumnNumber = 7, SqlFieldName = MR_MT_Dr ];

/// MR_Remark
Property MRRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MR_Remark ];

/// MR_UseFlag
Property MRUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MR_UseFlag ];

/// MR_MaxMPrice
Property MRMaxMPrice As %Float [ SqlColumnNumber = 10, SqlFieldName = MR_MaxMPrice ];

/// MR_MPrice
Property MRMPrice As %Float [ SqlColumnNumber = 11, SqlFieldName = MR_MPrice ];

/// MR_MaxMargin
Property MRMaxMargin As %Float [ SqlColumnNumber = 12, SqlFieldName = MR_MaxMargin ];

/// DHC_StkDecimal
Property MRSDDr As DHCStkDecimal [ SqlColumnNumber = 13, SqlFieldName = MR_SD_Dr ];

/// MR_Type
Property MRType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 14, SqlFieldName = MR_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINMR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MR_MPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MR_MT_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MR_Margin">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MR_MaxMPrice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MR_MaxMargin">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MR_MaxRp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MR_MinRp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MR_SD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MR_Type">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MR_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCINMR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMarkType">
<Global>^DHCINMR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_MT_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MR_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCMarkRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINMR)
	s oldI = +$g(^mdata("DHCMARKFACTOR"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINMR = maxI
	s ^mdata("DHCMARKFACTOR") = maxI
}

}
