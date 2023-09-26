Class User.DHCEQCSysSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SS_RowID, SqlTableName = DHC_EQCSysSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SS_Code
Property SSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SS_Code ];

/// SS_Value
Property SSValue As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SS_Value ];

/// SS_Desc
Property SSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SS_Desc ];

/// SS_Remark
Property SSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SS_Remark ];

/// SS_AddValue
Property SSAddValue As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SS_AddValue ];

/// SS_Hidden
Property SSHidden As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SS_Hidden ];

/// SS_HospDR CZF0138
Property SSHospDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SS_HospDR ];

/// SS_DefaultValue 默认值 
Property SSDefaultValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SS_DefaultValue ];

/// SS_UniqueFlag 唯一性
Property SSUniqueFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SS_UniqueFlag ];

/// Index SSCodeUnqIdx1 On SSCode [ Unique ];
Storage SQLStorage
{
<Description>
<![CDATA[Index SSCodeUnqIdx1 On SSCode [ Unique ];]]></Description>
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCSysSet",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SS_AddValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SS_DefaultValue">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SS_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SS_HospDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SS_UniqueFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SS_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCSysSet"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCSysSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCSysSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnique">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCSysSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Unique"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_UniqueFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCSysSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
